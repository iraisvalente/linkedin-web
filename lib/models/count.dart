class Count {
  final int? count;

  Count(this.count);

  Count.fromJson(Map<String, dynamic> json) : count = json['Count'];

  Map<String, dynamic> toJson() {
    return {'Count': count};
  }
}
