enum NamedRoutes {
  splash('/'),
  auth('/auth'),
  home('/home'),
  planting('/planting');

  final String route;
  const NamedRoutes(this.route);
}
