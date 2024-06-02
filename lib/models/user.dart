class User {
  final String userid;
  final String? username;
  final String? usertype;
  final String? createdat;
  final String? icon;
  final String? profile;
  final int? numberofpoints;
  final String? companyname;

  User({
    required this.userid,
    this.username,
    this.usertype,
    this.createdat,
    this.icon,
    this.profile,
    this.numberofpoints,
    this.companyname,
  });
}
