package main

import (
	"fmt"
	"math"
	"math/rand"
	"os"
	"time"

	mapset "github.com/deckarep/golang-set/v2"
	"github.com/gocarina/gocsv"
	"github.com/google/uuid"
)

const (
	CSV_OUTPUT_DIR = "./output"

	TOTAL_FARM_COUNT  = 12
	TOTAL_TOWER_COUNT = 48

	MIN_TOWER_COUNT = 2
	MAX_TOWER_COUNT = 8

	MIN_DATA_POINT_COUNT = 3000
	MAX_DATA_POINT_COUNT = 10000
)

type TowerStream struct {
	FarmID  string `json:"farmId" csv:"farmId"`
	TowerID string `json:"towerId" csv:"towerId"`
	RSSI    int    `json:"rssi" csv:"rssi"`
}

func main() {
	farmIDList := make([]string, 0, TOTAL_FARM_COUNT)
	for index := 0; index < TOTAL_FARM_COUNT; index++ {
		farmID := uuid.NewString()
		farmIDList = append(farmIDList, farmID)
	}

	towerIDList := make([]string, 0, TOTAL_TOWER_COUNT)
	for index := 0; index < TOTAL_TOWER_COUNT; index++ {
		towerID := uuid.NewString()
		towerIDList = append(towerIDList, towerID)
	}

	farmTowerIDListMap := make(map[string][]string, TOTAL_FARM_COUNT)
	for _, farmID := range farmIDList {
		towerCount := getRandomInt(MIN_TOWER_COUNT, MAX_TOWER_COUNT)
		towerIDSet := mapset.NewSet[string]()
		for {
			towerIDIndex := getRandomInt(0, TOTAL_TOWER_COUNT-1)
			towerID := towerIDList[towerIDIndex]
			towerIDSet.Add(towerID)
			if towerIDSet.Cardinality() == towerCount {
				break
			}
		}
		farmTowerIDListMap[farmID] = towerIDSet.ToSlice()
	}

	towerStreamList := make([]TowerStream, 0)
	for farmID, towerIDList := range farmTowerIDListMap {
		for _, towerID := range towerIDList {
			minRSSI := getRandomInt(60, 89)
			maxRSSI := getRandomInt(90, 120)
			dataPointCount := getRandomInt(MIN_DATA_POINT_COUNT, MAX_DATA_POINT_COUNT)
			for index := 0; index < dataPointCount; index++ {
				rssi := getRandomInt(minRSSI, maxRSSI) * -1
				towerStream := TowerStream{
					FarmID:  farmID,
					TowerID: towerID,
					RSSI:    rssi,
				}
				towerStreamList = append(towerStreamList, towerStream)
			}
		}
	}

	towerStreamList = shuffleSlice(towerStreamList)
	chunkSize := int(math.Ceil(float64(len(towerStreamList)) / float64(4)))
	towerStreamChunkList := chunkSlice(towerStreamList, chunkSize)

	if _, statErr := os.Stat(CSV_OUTPUT_DIR); os.IsNotExist(statErr) {
		makeErr := os.Mkdir(CSV_OUTPUT_DIR, os.ModePerm)
		if makeErr != nil {
			panic(makeErr)
		}
	}
	for _, towerStreamChunk := range towerStreamChunkList {
		outputPath := fmt.Sprintf("%s/tower-stream-%s.csv", CSV_OUTPUT_DIR, toISOString(time.Now().UnixMilli()))
		outputFile, createErr := os.Create(outputPath)
		if createErr != nil {
			panic(createErr)
		}
		marshalErr := gocsv.MarshalFile(&towerStreamChunk, outputFile)
		if marshalErr != nil {
			panic(marshalErr)
		}
		outputFile.Close()
	}
}

func getRandomInt(
	min int,
	max int,
) int {
	random := rand.New(rand.NewSource(time.Now().UnixNano()))

	return random.Intn(max-min+1) + min
}

func toISOString(
	unixMillis int64,
) string {
	return time.UnixMilli(unixMillis).UTC().Format("2006-01-02T15:04:05.000Z")
}

func shuffleSlice[T any](
	items []T,
) []T {
	random := rand.New(rand.NewSource(time.Now().UnixNano()))

	output := make([]T, len(items))
	copy(output, items)
	random.Shuffle(len(output), func(i int, j int) {
		output[i], output[j] = output[j], output[i]
	})

	return output
}

func chunkSlice[T any](
	items []T,
	size int,
) [][]T {
	chunks := make([][]T, 0, (len(items)/size)+1)

	if len(items) == 0 {
		return chunks
	}
	for size < len(items) {
		items, chunks = items[size:], append(chunks, items[0:size:size])
	}

	return append(chunks, items)
}
