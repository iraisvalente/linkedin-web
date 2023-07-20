import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:project/models/message.dart';
import 'package:project/models/search.dart';

class SearchService {
  Future<Message?> saveSearch(Search search) async {
    late Message message;
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/search/connection_search'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "Name": search.name,
        "Note": search.note,
        "Search": search.search,
        "Connection_first_name": search.firstname,
        "Connection_last_name": search.lastname,
        "Connection_email": search.email,
        "Connection_company": search.company,
        "Connection_position": search.position,
        "Connection_connection": search.connection
      }),
    );
    if (response.statusCode == 200) {
      var responseJson = json.decode(response.body);
      print('message.answer');
      print(responseJson['message']);
      message = Message(responseJson['message']);
      print(message.message);
      return message;
    } else {
      throw Exception('Failed to load connections');
    }
  }

  Future<List<Search>> getAllSearches() async {
    List<Search> searches = [];
    final response = await http
        .get(Uri.parse('http://127.0.0.1:8000/search/connection_search'));

    if (response.statusCode == 200) {
      final searchData = jsonDecode(response.body) as List<dynamic>;
      searches = searchData.map((data) => Search.fromJson(data)).toList();
      print(searches);
      return searches;
    } else {
      throw Exception('Failed to load list of company positions');
    }
  }

  Future<Message?> deleteSearch(int searchId) async {
    late Message message;
    final response = await http.delete(
      Uri.parse('http://127.0.0.1:8000/search/connection_search/$searchId'),
    );

    if (response.statusCode == 200) {
      var responseJson = json.decode(response.body);
      print('message.answer');
      print(responseJson['message']);
      message = Message(responseJson['message']);
      print(message.message);
      return message;
    } else {
      throw Exception('Failed to load connections');
    }
  }
}
