class Search {
  final int? id;
  final String? name;
  final String? note;
  final bool? search;
  final String? firstname;
  final String? lastname;
  final String? email;
  final String? company;
  final String? position;
  final String? connection;

  Search(this.id, this.name, this.note, this.search, this.firstname,
      this.lastname, this.email, this.company, this.position, this.connection);

  Search.fromJson(Map<String, dynamic> json)
      : id = json['Id'],
        name = json['Name'],
        note = json['Note'],
        search = json['Search'],
        firstname = json['Connection_first_name'],
        lastname = json['Connection_last_name'],
        email = json['Connection_email'],
        company = json['Connection_company'],
        position = json['Connection_position'],
        connection = json['Connection_connection'];

  Map<String, dynamic> toJson() {
    return {
      'Id': name,
      'Name': name,
      'Note': note,
      'Search': search,
      'Connection_firstname': firstname,
      'Connection_lastname': lastname,
      'Connection_email': email,
      'Connection_company': company,
      'Connection_position': position,
      'Connection_connection': connection,
    };
  }
}
