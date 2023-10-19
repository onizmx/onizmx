import { Route, Routes } from 'react-router-dom';
import { routeConfig } from '../../config/route.config';
import { Home } from './home/Home';
import { About } from './about/About';
import { Project } from './project/Project';

export const Pages = () => {
  return (
    <Routes>
      <Route path={routeConfig.home.path} element={<Home />} />
      <Route path={routeConfig.about.path} element={<About />} />
      <Route path={routeConfig.project.path} element={<Project />} />
    </Routes>
  );
};
