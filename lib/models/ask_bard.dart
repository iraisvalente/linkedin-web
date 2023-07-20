class AskBard {
  final String company;
  final String position;

  AskBard(this.company, this.position);

  AskBard.fromJson(Map<String, dynamic> json)
      : company = json['company'],
        position = json['position'];

  Map<String, dynamic> toJson() {
    return {'company': company, 'position': position};
  }
}
