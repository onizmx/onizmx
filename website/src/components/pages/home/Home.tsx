import { Box, Flex, Text } from "@chakra-ui/react";
import { Helmet } from "react-helmet";
import { domain, routeConfig } from "../../../config/route.config";

export const Home = () => {
  return (
    <>
      <Helmet>
        <title>{routeConfig.home.name}</title>
        <link rel="canonical" href={domain + routeConfig.home.path} />
      </Helmet>
      <Box w="100%" h="100%">
        <Flex w="100%" h="100%" align="center" justify="center">
          <Text fontSize="2xl" fontFamily="RalewayRegular">
            this is
          </Text>
        </Flex>
      </Box>
    </>
  );
};
