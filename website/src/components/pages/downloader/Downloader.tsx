import { Box, Flex, Text } from "@chakra-ui/react";
import { Helmet } from "react-helmet";
import { domain, routeConfig } from "../../../config/route.config";

export const Downloader = () => {
  return (
    <>
      <Helmet>
        <title>{routeConfig.downloader.name}</title>
        <link rel="canonical" href={domain + routeConfig.downloader.path} />
      </Helmet>
      <Box w="100%" h="100%">
        <Flex w="100%" h="100%" align="center" justify="center">
          <Text fontSize="2xl" fontFamily="RalewayRegular">
            Downloader
          </Text>
        </Flex>
      </Box>
    </>
  );
};
