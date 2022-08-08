class UserApp {
  String? username;
  String? email;
  String? password;
  String? profileId;

  UserApp({this.email, this.username, this.password, this.profileId});

  Map<String, dynamic> toJson() => {
        'username': username,
        'email': email,
        'password': password,
        'profileId': profileId,
      };
}
