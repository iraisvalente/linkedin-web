class Message {
  late final String message;

  Message(this.message);

  Message.fromJson(Map<String, dynamic> json) : message = json['message'];

  Map<String, dynamic> toJson() {
    return {'message': message};
  }
}
