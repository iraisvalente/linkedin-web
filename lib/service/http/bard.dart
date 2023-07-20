import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:project/models/answer_bard.dart';
import 'package:project/models/ask_bard.dart';

class BardService {
  Future<AnswerBard?> askBard(AskBard bard) async {
    late AnswerBard answerBard;
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/bard/ask/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "company": bard.company,
        "position": bard.position,
      }),
    );
    if (response.statusCode == 200) {
      var responseJson = json.decode(response.body);
      print('answerBard.answer');
      print(responseJson['answer']);
      answerBard = AnswerBard(responseJson['answer']);
      print(answerBard.answer);
      return answerBard;
    } else {
      throw Exception('Failed to load connections');
    }
  }
}
