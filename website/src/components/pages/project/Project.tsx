import { Box, Flex, Text } from '@chakra-ui/react';
import { Helmet } from 'react-helmet';
import { domain, routeConfig } from '../../../config/route.config';

export const Project = () => {
  return (
    <>
      <Helmet>
        <title>{routeConfig.project.name}</title>
        <link rel='canonical' href={domain + routeConfig.project.path} />
      </Helmet>
      <Box w='100%' h='100%'>
        <Flex w='100%' h='100%' align='center' justify='center'>
          <Text fontSize='2xl' fontFamily='RalewayRegular'>
            that does nothing
          </Text>
        </Flex>
      </Box>
    </>
  );
};
