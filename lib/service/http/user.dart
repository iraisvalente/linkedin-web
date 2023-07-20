import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:project/models/user.dart';

Future<http.Response?> login(String email, String password) async {
  return http.post(
    Uri.parse('http://127.0.0.1:8000/users/login'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'Email_Address': email,
      'Password_user': password,
    }),
  );
}

Future<http.Response?> register(User user) async {
  return http.post(
    Uri.parse('http://127.0.0.1:8000/users/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(user.toMap()),
  );
}
