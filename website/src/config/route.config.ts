import { RouteConfig } from './route.config.types';

export const domain: string = window.location.hostname;

export const routeConfig: RouteConfig = {
  home: {
    path: '/',
    name: 'Home',
  },
  about: {
    path: '/about',
    name: 'About',
  },
  project: {
    path: '/project',
    name: 'Project',
  },
};
