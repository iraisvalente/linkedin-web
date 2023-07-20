class LinkedResult {
  final String result;

  LinkedResult(this.result);

  LinkedResult.fromJson(Map<String, dynamic> json) : result = json['result'];

  Map<String, dynamic> toJson() {
    return {'result': result};
  }
}
