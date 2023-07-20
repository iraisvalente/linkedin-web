class Response {
  final String response;

  Response(this.response);

  Response.fromJson(Map<String, dynamic> json) : response = json['response'];

  Map<String, dynamic> toJson() {
    return {'response': response};
  }
}
