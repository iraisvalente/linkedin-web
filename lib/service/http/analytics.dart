import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:project/models/company.dart';
import 'package:project/models/company_positions.dart';
import 'package:project/models/connection.dart';
import 'package:project/models/count.dart';
import 'package:project/models/position.dart';

Future<List<Connection>?> connections() async {
  List<Connection>? connections = [];
  final response =
      await http.get(Uri.parse('http://127.0.0.1:8000/common_connections/'));

  if (response.statusCode == 200) {
    var responseJson = json.decode(response.body);
    for (final response in responseJson) {
      connections.add(Connection.commonConnection(
          response['Connection']!, int.parse(response['Count']!)));
    }
    return connections;
  } else {
    throw Exception('Failed to load album');
  }
}

Future<List<Company>?> companies(bool count) async {
  List<Company>? companies = [];
  final response;
  if (count) {
    response =
        await http.get(Uri.parse('http://127.0.0.1:8000/common_companies/'));
    if (response.statusCode == 200) {
      var responseJson = json.decode(response.body);
      for (final response in responseJson) {
        companies
            .add(Company(response['Company']!, int.parse(response['Count'])));
      }
      return companies;
    } else {
      throw Exception('Failed to load album');
    }
  } else {
    response =
        await http.get(Uri.parse('http://127.0.0.1:8000/all_companies/'));
    if (response.statusCode == 200) {
      var responseJson = json.decode(response.body);
      for (final response in responseJson) {
        companies.add(Company(response['Company']!, null));
      }
      return companies;
    } else {
      throw Exception('Failed to load album');
    }
  }
}

Future<List<Position>?> positions(bool count) async {
  List<Position>? positions = [];
  final response;
  if (count) {
    response =
        await http.get(Uri.parse('http://127.0.0.1:8000/common_positions/'));
    if (response.statusCode == 200) {
      var responseJson = json.decode(response.body);
      print(responseJson);

      for (final response in responseJson) {
        positions
            .add(Position(null, response['Position']!, response['Count']!));
      }
      return positions;
    } else {
      throw Exception('Failed to load album');
    }
  } else {
    response =
        await http.get(Uri.parse('http://127.0.0.1:8000/all_positions/'));

    if (response.statusCode == 200) {
      var responseJson = json.decode(response.body);
      for (final response in responseJson) {
        positions.add(Position(null, response['Position']!, null));
      }
      return positions;
    } else {
      throw Exception('Failed to load album');
    }
  }
}

Future<List<CompanyPositions>> companiesPositions() async {
  List<CompanyPositions> companyPositions = [];
  final response =
      await http.get(Uri.parse('http://127.0.0.1:8000/company_positions/'));

  if (response.statusCode == 200) {
    for (int i = 0; i < jsonDecode(response.body).length; i++) {
      companyPositions
          .add(CompanyPositions.fromMap(jsonDecode(response.body)[i]));
    }
    return companyPositions;
  } else {
    throw Exception('Failed to load list of company positions');
  }
}

Future<List<Position>> companyPositions(String company) async {
  List<Position> companyPositions = [];
  final response = await http
      .get(Uri.parse('http://127.0.0.1:8000/company_positions/"$company"'));

  if (response.statusCode == 200) {
    for (int i = 0; i < jsonDecode(response.body).length; i++) {
      print(jsonDecode(response.body)[i]);
      companyPositions.add(Position.fromJson(jsonDecode(response.body)[i]));
    }
    return companyPositions;
  } else {
    throw Exception('Failed to load list of company positions');
  }
}

Future<Count> uniqueNames() async {
  Count count;
  final response =
      await http.get(Uri.parse('http://127.0.0.1:8000/unique_names/'));

  if (response.statusCode == 200) {
    count = Count.fromJson(jsonDecode(response.body));
    return count;
  } else {
    throw Exception('Failed to load list of company positions');
  }
}

Future<Count> uniqueCompanies() async {
  Count count;
  final response =
      await http.get(Uri.parse('http://127.0.0.1:8000/unique_companies/'));

  if (response.statusCode == 200) {
    count = Count.fromJson(jsonDecode(response.body));
    return count;
  } else {
    throw Exception('Failed to load list of company positions');
  }
}

Future<Count> uniquePositions() async {
  Count count;
  final response =
      await http.get(Uri.parse('http://127.0.0.1:8000/unique_positions/'));

  if (response.statusCode == 200) {
    count = Count.fromJson(jsonDecode(response.body));
    return count;
  } else {
    throw Exception('Failed to load list of company positions');
  }
}

Future<List<Connection>?> connectionsPerUser(String connection) async {
  List<Connection>? connections = [];
  final response = await http
      .get(Uri.parse('http://127.0.0.1:8000/user_connections/$connection'));

  if (response.statusCode == 200) {
    var responseJson = json.decode(response.body);
    for (final response in responseJson) {
      connections.add(Connection.fromMapEmail(response));
    }
    return connections;
  } else {
    throw Exception('Failed to load album');
  }
}
