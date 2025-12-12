class LoginResponse {
  final String accessToken;
  final User user;

  LoginResponse({required this.accessToken, required this.user});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(accessToken: json['accessToken'], user: User.fromJson(json['user']));
  }
}

class User {
  final String id;
  final String name;
  final String email;
  final String imageUrl;

  User({required this.id, required this.name, required this.email, required this.imageUrl});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(id: json['id'], name: json['name'], email: json['email'], imageUrl: json['imageUrl']);
  }
}
