import 'dart:convert';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:project/models/answer_bard.dart';
import 'package:project/models/ask.dart';
import 'package:project/models/ask_bard.dart';
import 'package:project/service/http/ask.dart';
import 'package:project/service/http/bard.dart';
import 'package:project/models/response.dart';
import 'package:project/widgets/navbar_inside.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import "package:webview_universal/webview_universal.dart";
import 'package:project/models/connection.dart';
import 'package:project/service/http/connection.dart';
import 'package:string_similarity/string_similarity.dart';
import 'dart:html' as html;

class CompanyInfoPage extends StatefulWidget {
  const CompanyInfoPage({super.key});

  @override
  State<CompanyInfoPage> createState() => _CompanyInfoPageState();
}

class _CompanyInfoPageState extends State<CompanyInfoPage> {
  TextEditingController company = TextEditingController();
  TextEditingController position = TextEditingController();
  ScrollController scrollController = ScrollController();
  WebViewController webViewSearchController = WebViewController();
  WebViewController webViewLinkedinController = WebViewController();
  List<Connection>? listData = [];
  String prueba = '';
  String search = '';
  String askResult = '';
  String email = '';
  String password = '';
  // BardService bardService = BardService();
  AskService askService = AskService();
  bool loading = true;

  Future<void> connections(String company) async {
    await searchConnection(company).then((value) {
      listData = [];
      listData = value;
    });
    setState(() {
      rows();
      loading = false;
    });
  }

  Future<Connection?> connection(String firstname, String lastname) async {
    Connection? connection;
    await bardConnection(Connection.bardSearch(firstname, lastname))
        .then((value) {
      connection = value;
    });
    return connection;
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
    setState(() {
      loading = false;
    });
  }

  void newSearch() async {
    Response? response =
        await askService.ask(Ask(company.text, position.text, email, password));
    String? conc = response?.response;
    askResult = response!.response;
    search = extractSingleValue(conc!, 'Name');
    print(search);
    print('SEARCH');
    print(search);
    alertConnectionFound(search);
    connections(company.text);
    prueba = search;
    /*
    AnswerBard? result =
        await bardService.askBard(AskBard(company.text, position.text));
    if (result!.answer.contains('Secure-1PSID') ||
        result.answer.contains('Error')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result.answer)),
      );
    } else {
      print('DONE');
      String conc = result.answer;
      askResult = result.answer;
      search = conc.split("\n")[0];
      alertConnectionFound(search);
      connections(company.text);
      prueba = search;
    }*/
  }

  void alertConnectionFound(result) async {
    String fullname = result.split(".")[0].toString().toUpperCase();
    String firstname = fullname.split(' ')[0];
    String lastname = fullname.split(' ')[1];
    Connection? searchConnection = await connection(firstname, lastname);
    if (searchConnection!.firstname != null &&
        searchConnection.lastname != null) {
      print('encontrado');
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Search found in your connections'),
          content: Text(
              '${searchConnection.firstname} ${searchConnection.lastname} has been found in your connections'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  List<DataRow> rows() {
    List<DataRow> rowList = [];
    String fullname = search.split(".")[0].toString().toUpperCase();
    String firstname = fullname.split(' ')[0];
    String lastname = fullname.split(' ')[1];

    for (int i = 0; i < listData!.length; i++) {
      String linkedinLink = '';
      if (listData![i].firstname!.toUpperCase().similarityTo(firstname) > 0.7 &&
          listData![i].lastname!.toUpperCase().similarityTo(lastname) > 0.7) {
        List<dynamic> listResume = askResult.split("\n").sublist(1);
        linkedinLink = '${listResume.last}'.trim();
      }
      rowList.add(DataRow(cells: [
        DataCell(Text(listData![i].firstname!)),
        DataCell(Text(listData![i].lastname!)),
        DataCell(Text(listData![i].email!)),
        DataCell(Text(listData![i].company!)),
        DataCell(Text(listData![i].position!)),
        DataCell(Text(listData![i].connection!)),
        DataCell(TextButton(
          onPressed: () async {
            final Uri url = Uri.parse(linkedinLink);
            if (!await launchUrl(url)) {
              throw Exception('Could not launch $url');
            }
          },
          child: Text(linkedinLink),
        )),
      ]));
    }
    return rowList;
  }

  @override
  void initState() {
    super.initState();
    getCredentials();
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
          children: [
            NavBar(),
            Container(
              margin: EdgeInsets.all(30),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: company,
                      decoration:
                          const InputDecoration(hintText: 'Write the company'),
                    ),
                  ),
                  SizedBox(width: 40),
                  Expanded(
                    child: TextField(
                      controller: position,
                      decoration:
                          const InputDecoration(hintText: 'Write the position'),
                    ),
                  ),
                  SizedBox(width: 40),
                  SizedBox(
                    height: 40,
                    width: 100,
                    child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            loading = true;
                          });
                          newSearch();
                        },
                        child: Text('Search')),
                  ),
                ],
              ),
            ),
            askResult != ''
                ? Column(
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.4,
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: SingleChildScrollView(
                            child: Card(
                                clipBehavior: Clip.antiAlias,
                                margin: EdgeInsets.all(20),
                                child: Container(
                                  padding: EdgeInsets.all(20),
                                  child: Column(
                                    children: [
                                      Text('Name',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      SelectableText(askResult.contains('Name')
                                          ? '${extractSingleValue(askResult, 'Name')}\n'
                                          : 'No name found\n'),
                                      Text('LinkedIn',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      SelectableText(askResult.contains('Link')
                                          ? '${extractSingleValue(askResult, 'Link')}\n'
                                          : 'No linkedin link found\n'),
                                      Text('Description',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      SelectableText(askResult
                                              .contains('Resume')
                                          ? '${extractSingleValue(askResult, 'Resume')}\n'
                                          : 'No description found\n'),
                                    ],
                                  ),
                                ))),
                      ),
                      // SizedBox(
                      //   height: MediaQuery.of(context).size.height * 0.2,
                      //   width: MediaQuery.of(context).size.width * 0.8,
                      //   child: SingleChildScrollView(
                      //       child: SelectableText(askResult)),
                      // ),
                      SizedBox(
                        height: 20,
                      ),
                      Scrollbar(
                          controller: scrollController,
                          child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              controller: scrollController,
                              child: DataTable(columns: [
                                DataColumn(
                                    label: Text('First Name',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold))),
                                DataColumn(
                                    label: Text('Last Name',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold))),
                                DataColumn(
                                    label: Text('Email Address',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold))),
                                DataColumn(
                                    label: Text('Company',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold))),
                                DataColumn(
                                    label: Text('Position',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold))),
                                DataColumn(
                                    label: Text('Connection',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold))),
                                DataColumn(
                                    label: Text('Link to LinkedIn',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)))
                              ], rows: rows()))),
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          List<List<dynamic>> rows = [];
                          rows.add([
                            "First Name",
                            "Last Name",
                            "Email Address",
                            "Company",
                            "Position",
                            "Connection",
                          ]);
                          for (Connection connection in listData!) {
                            rows.add([
                              connection.firstname,
                              connection.lastname,
                              connection.email,
                              connection.company,
                              connection.position,
                              connection.connection
                            ]);
                          }

                          String csv = const ListToCsvConverter().convert(rows);
                          final bytes = utf8.encode(csv);
                          final blob = html.Blob([bytes]);
                          final url = html.Url.createObjectUrlFromBlob(blob);
                          final anchor = html.document.createElement('a')
                              as html.AnchorElement
                            ..href = url
                            ..style.display = 'none'
                            ..download = 'company_info.csv';
                          html.document.body!.children.add(anchor);
                          anchor.click();
                          html.Url.revokeObjectUrl(url);
                        },
                        child: Text('Export to CSV'),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
