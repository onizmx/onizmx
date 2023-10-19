import { Box, ChakraProvider, Flex } from '@chakra-ui/react';
import { RecoilRoot } from 'recoil';
import styles from './App.module.css';
import { Navigator } from './navigator/Navigator';
import { Pages } from './pages/Pages';

export const App = () => {
  return (
    <div className={styles.app}>
      <RecoilRoot>
        <ChakraProvider>
          <Flex w='100%' h='100%'>
            <Box w='200px' h='100%' bg='#efefef'>
              <Navigator />
            </Box>
            <Box position='relative' flex={{ base: 1 }} overflow='hidden' bg='#dfdfdf'>
              <Pages />
            </Box>
          </Flex>
        </ChakraProvider>
      </RecoilRoot>
    </div>
  );
};
