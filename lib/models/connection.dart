class Connection {
  String? firstname;
  String? lastname;
  String? email;
  String? company;
  String? position;
  String? connection;
  int? count;

  Connection(this.firstname, this.lastname, this.email, this.company,
      this.position, this.connection);

  Connection.commonConnection(this.connection, this.count);

  Connection.bardSearch(this.firstname, this.lastname);

  Connection.fromMap(dynamic obj) {
    firstname = obj['firstname'];
    lastname = obj['lastname'];
    email = obj['email'];
    company = obj['company'];
    position = obj['position'];
    connection = obj['connection'];
  }

  Connection.fromMapEmail(dynamic obj) {
    firstname = obj['First_Name'];
    lastname = obj['Last_Name'];
    email = obj['Email_Address'];
    company = obj['Company'];
    position = obj['Position'];
  }

  Connection.commonConnectionFromMap(dynamic obj) {
    connection = obj['connection'];
    count = obj['count'];
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['first_name'] = firstname;
    map['last_name'] = lastname;
    map['email'] = email;
    map['company'] = company;
    map['position'] = position;
    map['connection'] = connection;
    return map;
  }

  Map<String, dynamic> commonConnectiontoMap() {
    var map = Map<String, dynamic>();
    map['connection'] = connection;
    map['count'] = count;
    return map;
  }
}
