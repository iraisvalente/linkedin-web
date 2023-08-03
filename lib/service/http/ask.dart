import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:project/models/ask.dart';
import 'package:project/models/response.dart';

class AskService {
  Future<Response?> ask(Ask ask) async {
    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/serach/company_position/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "company": ask.company,
          "position": ask.position,
          "email": ask.email,
          "password": ask.password,
        }),
      );

      if (response.statusCode == 200) {
        var responseJson = json.decode(response.body);
        print(responseJson['response']);
        return Response(responseJson['response']);
      } else {
        // Handle non-200 status code
        print('Request failed with status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      // Handle exceptions
      print('Exception during HTTP request: $e');
      return null;
    }
  }
}
