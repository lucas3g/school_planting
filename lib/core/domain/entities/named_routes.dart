enum NamedRoutes {
  splash('/'),
  auth('/auth'),
  home('/home'),
  planting('/planting'),
  myPlantings('/my-plantings'),
  impact('/impact');

  final String route;
  const NamedRoutes(this.route);
}
