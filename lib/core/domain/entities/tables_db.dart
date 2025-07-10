enum TablesDB {
  plantings('user_plantings'),
  userInfoWithPlantings('user_plantings_with_userinfo');

  final String name;
  const TablesDB(this.name);
}
