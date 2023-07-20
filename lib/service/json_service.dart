import 'dart:convert';
import 'dart:io';

class JsonService {
  Future readJson(String path) async {
    final File file = File(path);
    String contents = await file.readAsString();
    return await jsonDecode(contents);
  }

  Future updateJson(String path, List<dynamic> list) async {
    final File file = File(path);
    file.writeAsStringSync(json.encode(""));
    file.writeAsStringSync(json.encode(list));
  }
}
