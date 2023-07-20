import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:project/models/connection.dart';
import 'package:project/models/saved_search.dart';
import 'package:project/models/search.dart';
import 'package:project/pages/search/search_page.dart';
import 'package:project/service/http/search.dart';
import 'package:project/service/json_service.dart';
import 'package:project/widgets/navbar_inside.dart';
import 'package:http/http.dart' as http;

class SavedSearchPage extends StatefulWidget {
  const SavedSearchPage({super.key});

  @override
  State<SavedSearchPage> createState() => _SavedSearchPageState();
}

class _SavedSearchPageState extends State<SavedSearchPage> {
  List<Search> searches = [];
  SearchService search = SearchService();

  void getAllSearches() async {
    searches = await search.getAllSearches();
    setState(() {
      rows();
    });
  }

  List<DataRow> rows() {
    List<DataRow> row = [];
    for (int i = 0; i < searches.length; i++) {
      row.add(DataRow(cells: [
        DataCell(Text(searches[i].name!)),
        DataCell(Text(searches[i].note!)),
        DataCell(Row(
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) =>
                          SearchPage(search: searches[i]),
                      transitionDuration: Duration(seconds: 0),
                    ),
                  );
                },
                child: Text("Re-run search")),
            SizedBox(
              width: 30,
            ),
            ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith((states) {
                    if (states.contains(MaterialState.pressed)) {
                      return Colors.grey.shade400;
                    }
                    return Colors.grey.shade300;
                  }),
                  foregroundColor: MaterialStateProperty.resolveWith((states) {
                    if (states.contains(MaterialState.pressed)) {
                      return Colors.white;
                    }
                    return Colors.black54;
                  }),
                ),
                onPressed: () {
                  search.deleteSearch(searches[i].id!);
                  setState(() {
                    getAllSearches();
                  });
                },
                child: Text("Delete"))
          ],
        )),
      ]));
    }
    return row;
  }

  @override
  void initState() {
    super.initState();
    getAllSearches();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            NavBar(),
            Container(
              margin: EdgeInsets.only(bottom: 35, top: 35),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Saved Searches",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  SingleChildScrollView(
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.90,
                        child: DataTable(columns: [
                          DataColumn(
                            label: Text(
                              'Name',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Note',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                              label: Text(
                            'Action',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                        ], rows: rows())),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
