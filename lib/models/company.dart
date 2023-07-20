class Company {
  final String company;
  final int? count;

  Company(this.company, this.count);

  Company.fromJson(Map<String, dynamic> json)
      : company = json['Company'],
        count = json['Count'];

  Map<String, dynamic> toJson() {
    return {'Company': company, 'Count': count};
  }
}
