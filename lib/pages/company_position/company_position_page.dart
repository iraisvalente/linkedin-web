import 'dart:convert';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:project/models/answer_bard.dart';
import 'package:project/models/ask.dart';
import 'package:project/models/ask_bard.dart';
import 'package:project/models/connection.dart';
import 'package:project/models/position.dart';
import 'package:project/service/http/ask.dart';
import 'package:project/service/http/bard.dart';
import 'package:project/service/http/connection.dart';
import 'package:project/service/http/position.dart';
import 'package:project/models/response.dart';
import 'package:project/widgets/navbar_inside.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import "package:webview_universal/webview_universal.dart";
import 'dart:html' as html;

class CompanyPositionPage extends StatefulWidget {
  const CompanyPositionPage({super.key});

  @override
  State<CompanyPositionPage> createState() => _CompanyPositionPageState();
}

class _CompanyPositionPageState extends State<CompanyPositionPage> {
  String fileName = "No file chosen";
  String path = "";
  ScrollController scrollController = ScrollController();
  WebViewController webViewLinkedinController = WebViewController();
  BardService bardService = BardService();

  String email = '';
  String password = '';
  List<dynamic> bardResult = [];
  List<DataRow> _rowList = [];
  List<DataRow> rows = [];
  List<TextEditingController> _controllerList = [];
  List<List<String>> _answerContent = [];
  List<Position> positions = [];
  List<Connection>? listData = [];
  List<Column> tables = [];
  List<List<dynamic>> rowsAsListOfValues = [];
  int originalPositions = 0;
  PositionService positionService = PositionService();
  AskService askService = AskService();

  Future<List<Connection>> connections(String company) async {
    List<Connection> connections = [];
    await searchConnection(company).then((value) {
      connections = [];
      connections = value!;
    });
    return connections;
  }

  void createTable() async {
    List companies = rowsAsListOfValues.expand((element) => element).toList();
    for (String company in companies) {
      var comp = company.toString().toUpperCase().replaceAll("\n", " ");
      comp = comp.toString().toUpperCase().replaceAll(" ", "");
      comp = comp.toString().toUpperCase().replaceAll('"', "");
      comp = comp.trim();
      List<Connection> conn = await connections(comp);
      DataTableSource tableConnection = ConnectionsTable(conn);
      setState(() {
        tables.add(table(tableConnection));
      });
    }
    tables.add(Column(
      children: [
        ElevatedButton(
            onPressed: () async {
              List<List<dynamic>> rows = [];
              rows.add([
                "First Name",
                "Last Name",
                "Email Address",
                "Company",
                "Position",
                "Connection"
              ]);
              for (String company in companies) {
                var comp =
                    company.toString().toUpperCase().replaceAll("\n", " ");
                comp = comp.toString().toUpperCase().replaceAll(" ", "");
                comp = comp.toString().toUpperCase().replaceAll('"', "");
                comp = comp.trim();
                List<Connection> conn = await connections(comp);

                for (Connection connection in conn) {
                  rows.add([
                    connection.firstname,
                    connection.lastname,
                    connection.email,
                    connection.company,
                    connection.position,
                  ]);
                }
              }
              String csv = const ListToCsvConverter().convert(rows);
              final bytes = utf8.encode(csv);
              final blob = html.Blob([bytes]);
              final url = html.Url.createObjectUrlFromBlob(blob);
              final anchor =
                  html.document.createElement('a') as html.AnchorElement
                    ..href = url
                    ..style.display = 'none'
                    ..download = 'Connections_search.csv';
              html.document.body!.children.add(anchor);
              anchor.click();
              html.Url.revokeObjectUrl(url);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('File exported successfully')),
              );
            },
            child: Text('Export CSV')),
        SizedBox(
          height: 30,
        )
      ],
    ));
  }

  List<DataColumn> columns() {
    return [
      DataColumn(label: Text('Firstname')),
      DataColumn(label: Text('Lastname')),
      DataColumn(label: Text('Email Addres')),
      DataColumn(label: Text('Company')),
      DataColumn(label: Text('Position'))
    ];
  }

  Column table(DataTableSource table) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(30),
          child: PaginatedDataTable(
            source: table,
            columns: columns(),
            columnSpacing: 100,
            horizontalMargin: 10,
            rowsPerPage: 5,
            showCheckboxColumn: false,
          ),
        ),
        SizedBox(
          height: 20,
        )
      ],
    );
  }

  DataTable positionTable() {
    return DataTable(columns: [
      DataColumn(label: Text('Position')),
      DataColumn(label: Text('')),
    ], rows: _rowList);
  }

  void _addRow(String? position, int? id) {
    if (position == null) {
      int index = _rowList.length;
      TextEditingController controller = TextEditingController();
      _controllerList.add(controller);
      setState(() {
        _rowList.add(DataRow(cells: <DataCell>[
          DataCell(
            TextFormField(
              keyboardType: TextInputType.text,
              controller: controller,
            ),
          ),
          DataCell(Icon(Icons.delete), onTap: () {
            _deleteRow(index, null);
          }),
        ]));
      });
    } else {
      int index = _rowList.length;
      TextEditingController controller = TextEditingController(text: position);
      _controllerList.add(controller);
      setState(() {
        _rowList.add(DataRow(cells: <DataCell>[
          DataCell(
            TextFormField(
              keyboardType: TextInputType.text,
              controller: controller,
            ),
          ),
          DataCell(Icon(Icons.delete), onTap: () {
            _deleteRow(index, id!);
          }),
        ]));
      });
    }
  }

  void _deleteRow(int? index, int? id) {
    if (id != null) {
      originalPositions -= 1;
      deletePosition(id);
      setState(() {
        _rowList.removeAt(index!);
        _controllerList.removeAt(index);
      });
    } else {
      setState(() {
        _rowList.removeAt(index!);
        _controllerList.removeAt(index);
      });
    }
  }

  void getPositions() async {
    positions = await positionService.getAllPositions();
    if (positions.isNotEmpty) {
      originalPositions = positions.length;
      for (Position position in positions) {
        _addRow(position.position, position.id!);
      }
    }
  }

  void saveNewPositions() async {
    if (originalPositions > 0) {
      for (int i = 0; i < originalPositions; i++) {
        _controllerList.removeAt(i);
      }
    }
    for (TextEditingController controller in _controllerList) {
      positionService.savePosition(Position(null, controller.text, null));
    }
    setState(() {
      positionTable();
    });
  }

  void deletePosition(int searchId) async {
    positionService.deletePosition(searchId);
  }

  String extractSingleValue(String input, String field) {
    RegExp regExp = RegExp("$field: ([^\n]*)");
    RegExpMatch? match = regExp.firstMatch(input);
    if (match != null) {
      return match.group(1)!.trim();
    }
    return "";
  }

  String extractResumeWithLinkedin(
      String input, String startField, String endField) {
    RegExp regExp = RegExp("$startField: ([^\n]*)");
    RegExpMatch? match = regExp.firstMatch(input);
    if (match != null) {
      int startIndex = match.end;
      int endIndex = input.indexOf(endField, startIndex);
      if (endIndex != -1) {
        return input.substring(startIndex, endIndex).trim();
      }
    }
    return "";
  }

  String extractResumeWithoutLinkedin(String input, String startField) {
    RegExp regExp = RegExp("$startField: ");
    RegExpMatch? match = regExp.firstMatch(input);
    if (match != null) {
      int startIndex = match.end;
      return input.substring(startIndex).trim();
    }
    return "";
  }

  String addline(String input) {
    List<String> words = input.split(' ');
    String result = '';
    int wordCount = 0;

    for (String word in words) {
      result += word + ' ';
      wordCount++;

      if (wordCount == 20) {
        result += '\n';
        wordCount = 0;
      }
    }

    return result.trim();
  }

  void getCredentials() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    email = prefs.getString('email')!;
    password = prefs.getString('password')!;
  }

  @override
  void initState() {
    super.initState();
    getPositions();
    getCredentials();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            NavBar(),
            Container(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.width * 0.02,
                  left: MediaQuery.of(context).size.width * 0.20,
                  right: MediaQuery.of(context).size.width * 0.20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Import company position",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 35),
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
                              rowsAsListOfValues = const CsvToListConverter()
                                  .convert(decodedBytes);
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
                    ],
                  ),
                  Spacer(),
                  Column(
                    children: [
                      SizedBox(
                        width: 300,
                        height: 300,
                        child: SingleChildScrollView(
                          child: positionTable(),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                          onPressed: () => _addRow(null, null),
                          child: Text('Add position')),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            ElevatedButton(
                onPressed: () async {
                  setState(() {
                    rows = [];
                    tables = [];
                  });
                  List<DataCell> cells = [];
                  List companies =
                      rowsAsListOfValues.expand((element) => element).toList();
                  print(companies);
                  for (String company in companies) {
                    for (TextEditingController controller in _controllerList) {
                      print('WORK IN PROCESS');
                      String name = 'No name found';
                      String resume = 'No description found';
                      String linkedin = 'No linkedin link found';
                      var comp = company
                          .toString()
                          .toUpperCase()
                          .replaceAll("\n", " ");
                      comp = comp.toString().toUpperCase().replaceAll(" ", "");
                      comp = comp.toString().toUpperCase().replaceAll('"', "");
                      comp = comp.trim();
                      var pos = controller.text.toString().toUpperCase();
                      Response? response =
                          await askService.ask(Ask(comp, pos, email, password));
                      if (response!.response.contains("Link: ")) {
                        resume = addline(extractResumeWithLinkedin(
                            response.response, 'Resume', 'Link'));
                      } else {
                        resume = addline(extractResumeWithoutLinkedin(
                            response.response, 'Resume'));
                      }
                      name = extractSingleValue(response.response, 'Name');
                      linkedin = extractSingleValue(response.response, 'Link');
                      print('DONE');
                      List<String> answer = [
                        company,
                        controller.text,
                        name,
                        resume,
                        linkedin
                      ];
                      cells.add(DataCell(Text(answer[0])));
                      cells.add(DataCell(Text(answer[1])));
                      cells.add(DataCell(Text(answer[2])));
                      cells.add(DataCell(Text(answer[3])));
                      cells.add(DataCell(Text(answer[4])));
                      rows.add(DataRow(cells: cells));
                      cells = [];
                      /*AnswerBard? result =
                          await bardService.askBard(AskBard(comp, pos));*/
                      // if (result!.answer.contains('Secure-1PSID') ||
                      //     result.answer.contains('Error')) {
                      //   ScaffoldMessenger.of(context).showSnackBar(
                      //     SnackBar(content: Text(result.answer)),
                      //   );
                      // } else {
                      //   print('DONE');
                      //   bardResult.add(result.answer);
                      //   for (var result in bardResult) {
                      //     String personName;
                      //     personName = result.split(".")[0].toString();
                      //     List<dynamic> listResume =
                      //         result.split("\n").sublist(1);
                      //     String resume = listResume.join(' ');
                      //     try {
                      //       String linkedinLink = '${listResume.last}';
                      //       if (resume.contains(personName)) {
                      //         List<String> answer = [
                      //           company,
                      //           controller.text,
                      //           personName,
                      //           resume,
                      //           linkedinLink
                      //         ];
                      //         cells.add(DataCell(Text(answer[0])));
                      //         cells.add(DataCell(Text(answer[1])));
                      //         cells.add(DataCell(Text(answer[2])));
                      //         cells.add(DataCell(SizedBox(
                      //           width: 650,
                      //           child: TextField(
                      //             decoration: InputDecoration(
                      //               border: InputBorder.none,
                      //             ),
                      //             keyboardType: TextInputType.multiline,
                      //             maxLines: 10,
                      //             controller:
                      //                 TextEditingController(text: answer[3]),
                      //           ),
                      //         )));
                      //         cells.add(DataCell(TextButton(
                      //             child: Text(answer[4].trim()),
                      //             onPressed: () async {
                      //               final Uri url = Uri.parse(answer[4].trim());
                      //               if (!await launchUrl(url)) {
                      //                 throw Exception('Could not launch $url');
                      //               }
                      //             })));
                      //         rows.add(DataRow(cells: cells));
                      //       } else {
                      //         List<String> answer = [
                      //           company,
                      //           controller.text,
                      //           '',
                      //           '',
                      //           ''
                      //         ];
                      //         cells.add(DataCell(Text(answer[0])));
                      //         cells.add(DataCell(Text(answer[1])));
                      //         cells.add(DataCell(Text(answer[2])));
                      //         cells.add(DataCell(Text(answer[3])));
                      //         cells.add(DataCell(Text(answer[4])));
                      //         rows.add(DataRow(cells: cells));
                      //       }
                      //     } catch (e) {
                      //       List<String> answer = [
                      //         company,
                      //         controller.text,
                      //         personName,
                      //         resume,
                      //         ''
                      //       ];
                      //       cells.add(DataCell(Text(answer[0])));
                      //       cells.add(DataCell(Text(answer[1])));
                      //       cells.add(DataCell(Text(answer[2])));
                      //       cells.add(DataCell(Text(answer[3])));
                      //       cells.add(DataCell(Text(answer[4])));
                      //       rows.add(DataRow(cells: cells));
                      //     }

                      //     cells = [];
                      //   }
                      //   bardResult = [];
                      // }
                      setState(() {
                        rows;
                      });
                    }
                  }
                  positions = [];
                  for (TextEditingController controller in _controllerList) {
                    positions.add(Position(null, controller.text, null));
                  }
                  saveNewPositions();
                  createTable();
                },
                child: Text('Submit')),
            SizedBox(
              height: 30,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Scrollbar(
                controller: scrollController,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  controller: scrollController,
                  child: Center(
                    child: DataTable(columns: [
                      DataColumn(label: Text('Company')),
                      DataColumn(label: Text('Position')),
                      DataColumn(label: Text('Person')),
                      DataColumn(label: Text('Summary')),
                      DataColumn(label: Text('Link to LinkedIn')),
                    ], rows: rows, dataRowHeight: 190),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Column(
              children: tables,
            )
          ],
        ),
      ),
    );
  }
}

class ConnectionsTable extends DataTableSource {
  final List<Connection> table;
  ConnectionsTable(this.table);

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => table.length;
  @override
  int get selectedRowCount => 0;
  @override
  DataRow getRow(int index) {
    return DataRow(cells: [
      DataCell(Text(table[index].firstname!)),
      DataCell(Text(table[index].lastname!)),
      DataCell(Text(table[index].email!)),
      DataCell(Text(table[index].company!)),
      DataCell(Text(table[index].position!))
    ]);
  }
}
