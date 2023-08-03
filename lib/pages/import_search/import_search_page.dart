import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:project/models/connection.dart';
import 'package:project/models/message.dart';
import 'package:project/models/saved_search.dart';
import 'package:project/models/search.dart';
import 'package:project/pages/saved_search/saved_search_page.dart';
import 'package:project/service/http/search.dart';
import 'package:project/service/json_service.dart';
import 'package:project/widgets/navbar_inside.dart';
import 'package:file_picker/file_picker.dart';

class ImportSearchPage extends StatefulWidget {
  const ImportSearchPage({super.key});

  @override
  State<ImportSearchPage> createState() => _ImportSearchPageState();
}

class _ImportSearchPageState extends State<ImportSearchPage> {
  String fileName = "No file chosen";
  String path = "";
  bool loading = true;
  List<List<dynamic>> data = [];
  List<SavedSearch> searches = [];
  List<List<dynamic>> rowsAsListOfValues = [];
  SearchService search = SearchService();
  List<Message?> messages = [];

  // Future readCsv(String path) async {
  //   final File file = File(path);
  //   String contents = await file.readAsString();
  //   return const CsvToListConverter().convert(contents, eol: "\n");
  // }

  void importCSV() async {
    // Pick file
    FilePickerResult? csvFile = await FilePicker.platform.pickFiles(
      allowedExtensions: ['csv'],
      type: FileType.custom,
      allowMultiple: false,
    );

    if (csvFile != null) {
      final bytes = csvFile.files[0].bytes;
      if (bytes != null) {
        // Decode bytes back to utf8
        final decodedBytes = utf8.decode(bytes);

        // Convert CSV content to a List of Lists
        List<List<dynamic>> rowsAsListOfValues =
            const CsvToListConverter().convert(decodedBytes);

        // Process the CSV data as needed
        // ...
      }
    }
  }

  bool parseBool(String value) {
    if (value.toLowerCase() == 'true') {
      return true;
    } else if (value.toLowerCase() == 'false') {
      return false;
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    //readSearches();
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
                    "Import Search",
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
                    onPressed: () async {
                      FilePickerResult? csvFile =
                          await FilePicker.platform.pickFiles(
                        allowedExtensions: ['csv'],
                        type: FileType.custom,
                        allowMultiple: false,
                      );

                      if (csvFile != null) {
                        final bytes = csvFile.files[0].bytes;
                        if (bytes != null) {
                          // Decode bytes back to utf8
                          final decodedBytes = utf8.decode(bytes);
                          rowsAsListOfValues =
                              const CsvToListConverter().convert(decodedBytes);
                          setState(() {
                            fileName = csvFile.files[0].name;
                          });
                        }
                      }
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
                      rowsAsListOfValues.removeAt(0);
                      for (int i = 0; i < rowsAsListOfValues.length; i++) {
                        Message? message = await search.saveSearch(Search(
                            null,
                            rowsAsListOfValues[i][0],
                            rowsAsListOfValues[i][1],
                            parseBool(rowsAsListOfValues[i][2]),
                            rowsAsListOfValues[i][3],
                            rowsAsListOfValues[i][4],
                            rowsAsListOfValues[i][5],
                            rowsAsListOfValues[i][6],
                            rowsAsListOfValues[i][7],
                            rowsAsListOfValues[i][8]));
                        print(message!.message);
                        messages.add(message);
                      }
                      int messageWrong = 0;
                      for (Message? message in messages) {
                        if (message!.message != 'Search added successfully') {
                          messageWrong += 1;
                        }
                      }
                      if (messageWrong < 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  'Something went wrong at adding the search from the CSV')),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Search added successfully')),
                        );
                      }
                      Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (_, __, ___) => SavedSearchPage(),
                          ));
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
