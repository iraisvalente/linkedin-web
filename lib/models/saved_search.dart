import 'package:project/models/connection.dart';

class SavedSearch {
  final String name;
  final String note;
  final bool search;
  final Connection connection;

  SavedSearch(this.name, this.note, this.search, this.connection);

  SavedSearch.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        note = json['note'],
        search = json['search'],
        connection = Connection.fromMap(json['connection']);

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'note': note,
      'search': search,
      'connection': connection.toMap()
    };
  }
}
