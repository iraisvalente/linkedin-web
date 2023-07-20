class Position {
  final int? id;
  final String position;
  final String? count;

  Position(this.id, this.position, this.count);

  Position.fromJson(Map<String, dynamic> json)
      : id = json['Id'],
        position = json['Position'],
        count = json['Count'];

  Map<String, dynamic> toJson() {
    return {'Position': position, 'Count': count};
  }
}
