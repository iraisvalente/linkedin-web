import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:project/models/connection.dart';

Future<List<Connection>?> connections() async {
  List<Connection>? connections = [];
  final response =
      await http.get(Uri.parse('http://127.0.0.1:8000/connections/'));

  if (response.statusCode == 200) {
    var responseJson = json.decode(response.body);
    for (final response in responseJson) {
      connections.add(Connection(
          response['First_Name']!,
          response['Last_Name']!,
          response['Email_Address']!,
          response['Company']!,
          response['Position']!,
          response['Connection']!));
    }
    print(connections.length);
    return connections;
  } else {
    throw Exception('Failed to load connections');
  }
}

Future<http.Response?> connectionsAllFilters(Connection connection) async {
  return http.post(
    Uri.parse('http://127.0.0.1:8000/connections'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(connection.toMap()),
  );
}

Future<List<Connection>?> connectionsFilter(String filter, String value) async {
  List<Connection>? connections = [];
  final response = await http
      .get(Uri.parse('http://127.0.0.1:8000/connections/$filter/$value'));

  if (response.statusCode == 200) {
    var responseJson = json.decode(response.body);
    for (final response in responseJson) {
      connections.add(Connection(
          response['First_Name']!,
          response['Last_Name']!,
          response['Email_Address']!,
          response['Company']!,
          response['Position']!,
          response['Connection']!));
    }
    print(connections.length);
    return connections;
  } else {
    throw Exception('Failed to load album');
  }
}

Future<List<Connection>?> searchConnection(String company) async {
  List<Connection>? connections = [];
  final response =
      await http.get(Uri.parse('http://127.0.0.1:8000/connections/$company'));
  try {
    var responseJson = json.decode(response.body);
    for (final response in responseJson) {
      connections.add(Connection(
          response['First_Name']!,
          response['Last_Name']!,
          response['Email_Address']!,
          response['Company']!,
          response['Position']!,
          response['Connection']!));
    }
    print(connections.length);
    return connections;
  } catch (e) {
    print(e);
  }
}

Future<List<Connection>?> connection_dependent_search(
    Connection connection) async {
  List<Connection>? connections = [];
  final response = await http.post(
    Uri.parse('http://127.0.0.1:8000/connection_dependent_search/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      "First_Name": connection.firstname!,
      "Last_Name": connection.lastname!,
      "Email_Address": connection.email!,
      "Company": connection.company!,
      "Position": connection.position!,
      "Connection": connection.connection!
    }),
  );
  if (response.statusCode == 200) {
    var responseJson = json.decode(response.body);
    for (final response in responseJson) {
      connections.add(Connection(
          response['First_Name']!,
          response['Last_Name']!,
          response['Email_Address']!,
          response['Company']!,
          response['Position']!,
          response['Connection']!));
    }
    print(connections.length);
    return connections;
  } else {
    throw Exception('Failed to load connections');
  }
}

Future<List<Connection>?> connection_independent_search(
    Connection connection) async {
  List<Connection>? connections = [];
  final response = await http.post(
    Uri.parse('http://127.0.0.1:8000/connection_independent_search/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      "First_Name": connection.firstname!,
      "Last_Name": connection.lastname!,
      "Email_Address": connection.email!,
      "Company": connection.company!,
      "Position": connection.position!,
      "Connection": connection.connection!
    }),
  );
  if (response.statusCode == 200) {
    var responseJson = json.decode(response.body);
    for (final response in responseJson) {
      connections.add(Connection(
          response['First_Name']!,
          response['Last_Name']!,
          response['Email_Address']!,
          response['Company']!,
          response['Position']!,
          response['Connection']!));
    }
    print(connections.length);
    return connections;
  } else {
    throw Exception('Failed to load connections');
  }
}

Future<Connection?> bardConnection(Connection connection) async {
  Connection? connections;
  final response = await http.post(
    Uri.parse('http://127.0.0.1:8000/connections/bard_connection/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      "First_Name": connection.firstname!,
      "Last_Name": connection.lastname!,
    }),
  );
  if (response.statusCode == 200) {
    var responseJson = json.decode(response.body);
    print(responseJson);
    connections = Connection(
        responseJson['First_Name'],
        responseJson['Last_Name'],
        responseJson['Email_Address'],
        responseJson['Company'],
        responseJson['Position'],
        responseJson['Connection']);
    return connections;
  } else {
    throw Exception('Failed to load connections');
  }
}
