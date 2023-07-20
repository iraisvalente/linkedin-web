class Linked {
  final String username;
  final String? password;

  Linked(this.username, this.password);

  Linked.fromJson(Map<String, dynamic> json)
      : username = json['username'],
        password = json['password'];

  Map<String, dynamic> toJson() {
    return {'username': username, 'password': password};
  }
}
