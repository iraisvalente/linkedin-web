class FileRequest {
  final String name;
  final String content;
  final String email;

  FileRequest(this.name, this.content, this.email);

  FileRequest.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        content = json['content'],
        email = json['email'];

  Map<String, dynamic> toJson() {
    return {'name': name, 'content': content, 'email': email};
  }
}
