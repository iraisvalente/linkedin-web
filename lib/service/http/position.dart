import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:project/models/message.dart';
import 'package:project/models/position.dart';

class PositionService {
  Future<Message?> savePosition(Position position) async {
    late Message message;
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/search/position/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "Position": position.position,
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

  Future<List<Position>> getAllPositions() async {
    List<Position> positions = [];
    final response =
        await http.get(Uri.parse('http://127.0.0.1:8000/search/position/'));

    if (response.statusCode == 200) {
      final searchData = jsonDecode(response.body) as List<dynamic>;
      positions = searchData.map((data) => Position.fromJson(data)).toList();
      print(positions);
      return positions;
    } else {
      throw Exception('Failed to load list of company positions');
    }
  }

  Future<Message?> deletePosition(int searchId) async {
    late Message message;
    final response = await http.delete(
      Uri.parse('http://127.0.0.1:8000/search/position/$searchId'),
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
