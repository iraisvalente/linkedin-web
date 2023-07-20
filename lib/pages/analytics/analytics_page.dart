import 'dart:math';

import 'package:flutter/material.dart';
import 'package:project/models/company.dart';
import 'package:project/models/company_positions.dart';
import 'package:project/models/connection.dart';
import 'package:project/models/position.dart';
import 'package:project/service/http/analytics.dart';
import 'package:project/widgets/navbar_inside.dart';

class AnalyticsPage extends StatefulWidget {
  AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  DataTableSource _dataCompanyAnalytics = CompanyAnalyticsTable([]);
  DataTableSource _dataConnectionAnalytics = ConnectionsAnalyticsTable([]);
  TextEditingController search = TextEditingController();
  TextEditingController email = TextEditingController();
  String dropdownvalue = 'Select the company';
  List<String> companiesNames = ['Select the company'];
  bool loading = true;

  Future allCompanies() async {
    print(loading);
    List<Company> companiesList = [];
    await companies(false).then((value) {
      companiesList.addAll(value!);
    });
    for (Company company in companiesList) {
      companiesNames.add(company.company);
    }
    setState(() {
      loading = false;
    });
  }

  Future<List<Position>> positionsPerCompany(String company) async {
    List<Position> positions = [];
    await companyPositions(company).then((value) {
      positions.addAll(value);
    });
    for (Position position in positions) {
      print(position.position);
      print(position.count);
    }
    setState(() {
      _dataCompanyAnalytics = CompanyAnalyticsTable(positions);
    });
    return positions;
  }

  Future<List<Connection>?> connections(String connection) async {
    List<Connection> connections = [];
    await connectionsPerUser(connection).then((value) {
      connections.addAll(value!);
    });
    print(connections.length);
    return connections;
  }

  List<DataColumn> columnsCompany() {
    return [
      DataColumn(label: Text('Position')),
      DataColumn(label: Text('Count'))
    ];
  }

  List<DataColumn> columnsConnections() {
    return [
      DataColumn(label: Text('Firstname')),
      DataColumn(label: Text('Lastname')),
      DataColumn(label: Text('Email Addres')),
      DataColumn(label: Text('Company')),
      DataColumn(label: Text('Position'))
    ];
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    allCompanies();
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
          const NavBar(),
          Container(
            margin: const EdgeInsets.all(35),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Company Analysis",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    SizedBox(width: 40),
                    DropdownButton(
                      value: dropdownvalue,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: companiesNames.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownvalue = newValue!;
                        });
                      },
                    ),
                    SizedBox(width: 20),
                    SizedBox(
                        height: 40,
                        width: 100,
                        child: ElevatedButton(
                            onPressed: () async {
                              print(dropdownvalue);
                              await positionsPerCompany(dropdownvalue);
                            },
                            child: Text('Search')))
                  ],
                ),
                PaginatedDataTable(
                  source: _dataCompanyAnalytics,
                  columns: columnsCompany(),
                  columnSpacing: 100,
                  horizontalMargin: 10,
                  rowsPerPage: 5,
                  showCheckboxColumn: false,
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  "Contacts",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    SizedBox(width: 20),
                    Expanded(
                      child: TextField(
                        controller: email,
                        decoration:
                            const InputDecoration(hintText: 'Write an email'),
                      ),
                    ),
                    SizedBox(width: 40),
                    SizedBox(
                      height: 40,
                      width: 100,
                      child: ElevatedButton(
                          onPressed: () async {
                            List<Connection>? data =
                                await connections(email.text);
                            setState(() {
                              _dataConnectionAnalytics =
                                  ConnectionsAnalyticsTable(data!);
                            });
                          },
                          child: Text('Search')),
                    ),
                  ],
                ),
                PaginatedDataTable(
                  source: _dataConnectionAnalytics,
                  columns: columnsConnections(),
                  columnSpacing: 100,
                  horizontalMargin: 10,
                  rowsPerPage: 5,
                  showCheckboxColumn: false,
                ),
              ],
            ),
          )
        ],
      ),
    ));
  }
}

class CompanyAnalyticsTable extends DataTableSource {
  final List<Position> table;
  CompanyAnalyticsTable(this.table) {
    print('using table');
    print(this.table.length);
  }

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => table.length;
  @override
  int get selectedRowCount => 0;
  @override
  DataRow getRow(int index) {
    return DataRow(cells: [
      DataCell(Text(table[index].position)),
      DataCell(Text(table[index].count.toString()))
    ]);
  }
}

class ConnectionsAnalyticsTable extends DataTableSource {
  final List<Connection> table;
  ConnectionsAnalyticsTable(this.table) {
    print('using table');
    print(this.table.length);
  }

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
