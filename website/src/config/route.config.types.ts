export type Route = {
  path: string;
  name: string;
};

export type RouteConfig = {
  home: Route;
  about: Route;
  project: Route;
  downloader: Route;
};
