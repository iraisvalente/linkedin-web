import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:project/models/file_request.dart';
import 'package:project/models/linked.dart';
import 'package:project/models/linked_result.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

class LinkedService {
  Future<LinkedResult?> choice(Linked linked) async {
    late LinkedResult result;
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/linked/choice/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "username": linked.username,
        "password": linked.password!
      }),
    );
    if (response.statusCode == 200) {
      var responseJson = json.decode(response.body);
      result = LinkedResult(responseJson['result']);
      print(result.result);
      return result;
    } else {
      throw Exception('Failed to load');
    }
  }

  Future<LinkedResult?> download(Linked linked) async {
    late LinkedResult result;
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/linked/download/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "username": linked.username,
        "password": linked.password!
      }),
    );
    if (response.statusCode == 200) {
      var responseJson = json.decode(response.body);
      result = LinkedResult(responseJson['result']);
      print(result.result);
      return result;
    } else {
      throw Exception('Failed to load');
    }
  }

  Future<LinkedResult> extract() async {
    late LinkedResult result;
    final response =
        await http.get(Uri.parse('http://127.0.0.1:8000/linked/extract/'));

    if (response.statusCode == 200) {
      var responseJson = json.decode(response.body);
      result = LinkedResult(responseJson['result']);
      print(result.result);
      return result;
    } else {
      throw Exception('Failed to load');
    }
  }

  Future<LinkedResult?> append(Linked linked) async {
    late LinkedResult result;
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/linked/append/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{"username": linked.username}),
    );
    if (response.statusCode == 200) {
      var responseJson = json.decode(response.body);
      result = LinkedResult(responseJson['result']);
      print(result.result);
      return result;
    } else {
      throw Exception('Failed to load');
    }
  }

  // Future<LinkedResult?> uploadFile(FileRequest file) async {
  //   late LinkedResult result;
  //   final response = await http.post(
  //     Uri.parse('http://127.0.0.1:8000/linked/copy/'),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //     body: jsonEncode(<String, String>{
  //       "name": file.name,
  //       "content": file.content,
  //       "email": file.email
  //     }),
  //   );
  //   try {
  //     var responseJson = json.decode(response.body);
  //     result = LinkedResult(responseJson['result']);
  //     print(result);
  //     return result;
  //   } catch (e) {
  //     print(e);
  //   }
  // }
  Future<String> uploadFile(
      List<int> file, String fileName, String email) async {
    var dio = Dio();
    FormData formData = FormData.fromMap({
      "file": MultipartFile.fromBytes(
        file,
        filename: fileName,
        contentType: MediaType("csv", "png"),
      ),
    });
    var response = await dio.post(
      "http://127.0.0.1:8000/linked/copy/${email}",
      data: formData,
    );
    return response.data['result'];
  }
}
