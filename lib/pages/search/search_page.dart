import 'dart:convert';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:project/models/connection.dart';
import 'package:project/models/search.dart';
import 'package:project/service/http/connection.dart';
import 'package:project/service/http/search.dart';
import 'dart:html' as html;
import 'package:project/widgets/navbar_inside.dart';

class SearchPage extends StatefulWidget {
  final Search? search;

  const SearchPage({super.key, this.search});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController companyController = TextEditingController();
  TextEditingController positionController = TextEditingController();
  TextEditingController connectedOnController = TextEditingController();
  TextEditingController searchName = TextEditingController();
  TextEditingController searchNote = TextEditingController();

  List<Connection>? listData = [];
  DataTableSource _searchTable = SearchTable([]);
  List<List<dynamic>> head = [];
  bool valuefirst = false;
  late Future conn;
  List<bool> disable = [true, true, true, true, true, true];

  SearchService search = SearchService();

  Future<void> allConnections() async {
    await connections().then((value) {
      listData = [];
      listData = value;
    });
    setState(() {
      _searchTable = SearchTable(listData!);
    });
  }

  allFilters(Connection connection) async {
    await connection_dependent_search(connection).then((value) {
      listData = [];
      listData = value;
    });
    setState(() {
      _searchTable = SearchTable(listData!);
    });
  }

  filters() async {
    await connection_independent_search(Connection(
            firstnameController.text,
            lastnameController.text,
            emailController.text,
            companyController.text,
            positionController.text,
            connectedOnController.text))
        .then((value) {
      listData = [];
      listData = value;
    });
    setState(() {
      _searchTable = SearchTable(listData!);
    });
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Toggle search save'),
            content: Container(
              width: MediaQuery.of(context).size.width * 0.20,
              height: MediaQuery.of(context).size.height * 0.20,
              child: Column(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchName,
                      decoration: const InputDecoration(hintText: 'Name'),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      controller: searchNote,
                      decoration: const InputDecoration(hintText: 'Note'),
                    ),
                  )
                ],
              ),
            ),
            actions: <Widget>[
              MaterialButton(
                color: Colors.grey,
                textColor: Colors.white,
                child: const Text('CANCEL'),
                onPressed: () {
                  setState(() {
                    searchName.text = '';
                    searchNote.text = '';
                    Navigator.pop(context);
                  });
                },
              ),
              MaterialButton(
                color: Colors.blue,
                textColor: Colors.white,
                child: const Text('OK'),
                onPressed: () async {
                  search.saveSearch(Search(
                      null,
                      searchName.text,
                      searchNote.text,
                      valuefirst,
                      firstnameController.text,
                      lastnameController.text,
                      emailController.text,
                      companyController.text,
                      positionController.text,
                      connectedOnController.text));
                  setState(() {
                    searchName.text = '';
                    searchNote.text = '';
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    if (widget.search != null) {
      firstnameController.text = widget.search!.firstname ?? '';
      lastnameController.text = widget.search!.lastname ?? '';
      emailController.text = widget.search!.email ?? '';
      companyController.text = widget.search!.company ?? '';
      positionController.text = widget.search!.position ?? '';
      connectedOnController.text = widget.search!.connection ?? '';
      if (widget.search!.search == false) {
        allFilters(Connection(
            firstnameController.text,
            lastnameController.text,
            emailController.text,
            companyController.text,
            positionController.text,
            connectedOnController.text));
      } else {
        valuefirst = widget.search!.search!;
        filters();
      }
    } else {
      allConnections();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              NavBar(),
              Container(
                margin: EdgeInsets.all(35),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Search Contacts',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(15),
                            child: TextFormField(
                              enabled: disable[0],
                              controller: firstnameController,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Firstname'),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the firstname';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(15),
                            child: TextFormField(
                              enabled: disable[1],
                              controller: lastnameController,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Lastname'),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the lastname';
                                }
                                return null;
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(15),
                            child: TextFormField(
                              enabled: disable[2],
                              controller: emailController,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Email'),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the email';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(15),
                            child: TextFormField(
                              enabled: disable[3],
                              controller: companyController,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Company'),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the company';
                                }
                                return null;
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(15),
                            child: TextFormField(
                              enabled: disable[4],
                              controller: positionController,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Position'),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the position';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(15),
                            child: TextFormField(
                              enabled: disable[5],
                              controller: connectedOnController,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Connection'),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the connection email';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        SizedBox(
                          width: 30,
                        ),
                        Text(
                          'Independent search by field: ',
                          style: TextStyle(fontSize: 17.0),
                        ),
                        Checkbox(
                          value: valuefirst,
                          onChanged: (value) {
                            setState(() {
                              valuefirst = value!;
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Container(
                            margin: EdgeInsets.only(left: 35, right: 35),
                            child: ElevatedButton(
                              onPressed: () {
                                if (valuefirst == false) {
                                  allFilters(Connection(
                                      firstnameController.text,
                                      lastnameController.text,
                                      emailController.text,
                                      companyController.text,
                                      positionController.text,
                                      connectedOnController.text));
                                } else {
                                  filters();
                                  _formKey.currentState!.reset();
                                }
                              },
                              child: const Text('Search'),
                            )),
                        Container(
                            margin: EdgeInsets.only(left: 35, right: 35),
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
                                allConnections();
                              },
                              child: const Text('Reset search'),
                            ))
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Company Analysis',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    PaginatedDataTable(
                      source: _searchTable,
                      columns: [
                        DataColumn(label: Text('First Name')),
                        DataColumn(label: Text('Last Name')),
                        DataColumn(label: Text('Email Address')),
                        DataColumn(label: Text('Company')),
                        DataColumn(label: Text('Position')),
                        DataColumn(label: Text('Connection')),
                      ],
                      columnSpacing: 100,
                      horizontalMargin: 10,
                      rowsPerPage: 8,
                      showCheckboxColumn: false,
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 35, right: 35),
                child: Row(
                  children: [
                    SizedBox(
                        child: ElevatedButton(
                      onPressed: () {
                        _displayTextInputDialog(context);
                      },
                      child: const Text('Toggle save search'),
                    )),
                    SizedBox(width: 10),
                    SizedBox(
                        child: ElevatedButton(
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
                          ..download = 'Connections_search.csv';
                        html.document.body!.children.add(anchor);
                        anchor.click();
                        html.Url.revokeObjectUrl(url);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('File exported successfully')),
                        );
                      },
                      child: const Text('Export selected'),
                    )),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SearchTable extends DataTableSource {
  late List<Connection> listData;

  SearchTable(this.listData);

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => listData.length;
  @override
  int get selectedRowCount => 0;
  @override
  DataRow getRow(int index) {
    return DataRow(cells: [
      DataCell(Text(listData[index].firstname.toString())),
      DataCell(Text(listData[index].lastname.toString())),
      DataCell(Text(listData[index].email.toString())),
      DataCell(Text(listData[index].company.toString())),
      DataCell(Text(listData[index].position.toString())),
      DataCell(Text(listData[index].connection.toString())),
    ]);
  }
}
