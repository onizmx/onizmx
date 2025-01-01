import { Box, Flex, Text } from "@chakra-ui/react";
import { Helmet } from "react-helmet";
import { domain, routeConfig } from "../../../config/route.config";

export const About = () => {
  return (
    <>
      <Helmet>
        <title>{routeConfig.about.name}</title>
        <link rel="canonical" href={domain + routeConfig.about.path} />
      </Helmet>
      <Box w="100%" h="100%">
        <Flex w="100%" h="100%" align="center" justify="center">
          <Text fontSize="2xl" fontFamily="RalewayRegular">
            a website
          </Text>
        </Flex>
      </Box>
    </>
  );
};
