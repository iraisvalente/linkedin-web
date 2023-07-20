class Ask {
  final String company;
  final String position;
  final String email;
  final String password;

  Ask(this.company, this.position, this.email, this.password);

  Ask.fromJson(Map<String, dynamic> json)
      : company = json['company'],
        position = json['position'],
        email = json['email'],
        password = json['password'];

  Map<String, dynamic> toJson() {
    return {
      'company': company,
      'position': position,
      'email': email,
      'password': password
    };
  }
}
