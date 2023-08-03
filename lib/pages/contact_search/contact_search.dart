import 'dart:convert';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project/models/file_request.dart';
import 'package:project/models/linked_result.dart';
import 'package:project/service/http/linked.dart';
import 'package:project/widgets/navbar_inside.dart';
import 'dart:html' as html;
import 'package:shared_preferences/shared_preferences.dart';

class ImportContactSearchPage extends StatefulWidget {
  const ImportContactSearchPage({super.key});

  @override
  State<ImportContactSearchPage> createState() =>
      _ImportContactSearchPageState();
}

class _ImportContactSearchPageState extends State<ImportContactSearchPage> {
  String fileName = "No file chosen";
  String fileContent = "";
  String conecction = "";
  bool loading = true;

  LinkedService linkedService = LinkedService();

  void getCredentials() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    conecction = prefs.getString('email')!;
  }

  List<PlatformFile>? _paths;

  void pickFiles() async {
    try {
      _paths = (await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: false,
        onFileLoading: (FilePickerStatus status) => print(status),
        allowedExtensions: ['csv'],
      ))
          ?.files;
    } on PlatformException catch (e) {
      print('Unsupported operation' + e.toString());
    } catch (e) {
      print(e.toString());
    }
    setState(() {
      if (_paths != null) {
        if (_paths != null) {
          fileName = _paths!.first.name;
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getCredentials();
    loading = false;
  }

  @override
  Widget build(BuildContext context) {
    if (loading == true) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NavBar(),
            Container(
              margin:
                  EdgeInsets.only(bottom: 35, top: 35, left: 100, right: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Import Contacts",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "Select  CSV or Excel file",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  SizedBox(
                      child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.resolveWith((states) {
                        if (states.contains(MaterialState.pressed)) {
                          return Colors.grey.shade400;
                        }
                        return Colors.grey.shade300;
                      }),
                      foregroundColor:
                          MaterialStateProperty.resolveWith((states) {
                        if (states.contains(MaterialState.pressed)) {
                          return Colors.white;
                        }
                        return Colors.black54;
                      }),
                    ),
                    onPressed: () {
                      pickFiles();
                      // html.FileUploadInputElement uploadInput =
                      //     html.FileUploadInputElement();
                      // uploadInput.multiple = false;
                      // uploadInput.accept = 'text/csv';
                      // uploadInput.onChange.listen((event) {
                      //   html.File file = uploadInput.files!.first;
                      //   html.FileReader reader = html.FileReader();
                      //   reader.readAsText(file);
                      //   reader.onLoadEnd.listen((event) {
                      //     String result = reader.result
                      //         as String; // Use a separate variable
                      //     List<List<dynamic>> csvData =
                      //         CsvToListConverter().convert(result);
                      //     print(csvData[0][7]);
                      //     result = csvData
                      //         .map((innerList) => innerList
                      //             .map((element) => element
                      //                 .toString()
                      //                 .replaceAll(',', '')
                      //                 .replaceAll('[', '')
                      //                 .replaceAll(']', ''))
                      //             .join(', '))
                      //         .join('\n');
                      //     setState(() {
                      //       fileContent =
                      //           result; // Assign the result to the separate variable
                      //       fileName = file.name;
                      //     });
                      //   });
                      // });
                      // html.document.body?.append(uploadInput);
                      // uploadInput.click();
                    },
                    child: const Text('Choose File'),
                  )),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    fileName,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  SizedBox(
                      child: ElevatedButton(
                    onPressed: () async {
                      String result = await linkedService.uploadFile(
                          _paths!.first.bytes!, _paths!.first.name, conecction);
                      print(result);
                      if (result == 'Copied') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('File imported successfully')),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('File import failed')),
                        );
                      }
                    },
                    child: const Text('Import'),
                  )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
