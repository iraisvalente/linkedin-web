import 'package:flutter/material.dart';
import 'package:project/pages/analytics/analytics_page.dart';
import 'package:project/pages/company_info/company_info_page.dart';
import 'package:project/pages/company_position/company_position_page.dart';
import 'package:project/pages/contact_search/contact_search.dart';
import 'package:project/pages/import_search/import_search_page.dart';
import 'package:project/pages/login/login.dart';
import 'package:project/pages/saved_search/saved_search_page.dart';
import 'package:project/pages/search/search_page.dart';
import 'package:project/pages/summary/summary_page.dart';
import 'package:project/pages/home/home.dart';
import 'package:project/widgets/navbar_button.dart';
import 'package:project/widgets/navbar_item.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  double collapsableHeight = 0.0;
  double heigthMenu = 50.0 * 4;

  @override
  Widget build(BuildContext context) {
    List<Widget> navBarItems = [
      NavBarItemRow(
        text: 'Automation',
        function: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => Home(),
              transitionDuration: Duration(seconds: 0),
            ),
          );
        },
      )
    ];
    double width = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Container(
          color: Colors.white,
        ),
        AnimatedContainer(
            margin: EdgeInsets.only(top: 79.0),
            duration: Duration(milliseconds: 375),
            curve: Curves.ease,
            height: (width < 800.0) ? collapsableHeight : 0.0,
            width: double.infinity,
            color: Colors.blue.shade900,
            child: ListView(
              children: [
                ListTile(
                    title: Text(
                      'Automation',
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (_, __, ___) => Home(),
                          transitionDuration: Duration(seconds: 0),
                        ),
                      );
                    }),
                ExpansionTile(
                  title: Text(
                    "Analytics",
                    style: TextStyle(color: Colors.white),
                  ),
                  childrenPadding: EdgeInsets.only(left: 60),
                  children: [
                    ListTile(
                      title: Text("Analytics"),
                    ),
                    ListTile(
                      title: Text("Summary"),
                    ),
                  ],
                ),
                ExpansionTile(
                  title: Text(
                    "Search",
                    style: TextStyle(color: Colors.white),
                  ),
                  childrenPadding: EdgeInsets.only(left: 60), //children padding
                  children: [
                    ListTile(
                      title: Text("Child Category 1"),
                    ),
                    ListTile(
                      title: Text("Child Category 2"),
                    ),
                  ],
                ),
                ListTile(
                    title: Text(
                      'Logout',
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (_, __, ___) => Home(),
                          transitionDuration: Duration(seconds: 0),
                        ),
                      );
                    })
              ],
            )),
        Container(
          color: Colors.blue.shade900,
          height: 80.0,
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              LayoutBuilder(builder: (context, constraints) {
                if (width < 800.0) {
                  return NavBarButton(
                    onPressed: () {
                      if (collapsableHeight == 0.0) {
                        setState(() {
                          collapsableHeight = heigthMenu;
                        });
                      } else if (collapsableHeight == heigthMenu) {
                        setState(() {
                          collapsableHeight = 0.0;
                        });
                      }
                    },
                  );
                } else {
                  return Row(
                    children: [
                      NavBarItemRow(
                        text: 'Automation',
                        function: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (_, __, ___) => Home(),
                              transitionDuration: Duration(seconds: 0),
                            ),
                          );
                        },
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      PopupMenuButton(
                          itemBuilder: (_) {
                            return [
                              PopupMenuItem(
                                  value: "Analytics", child: Text("Analytics")),
                              PopupMenuItem(
                                  value: "Summary", child: Text("Summary")),
                            ];
                          },
                          onSelected: (i) {
                            if (i == "Analytics") {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (_, __, ___) => AnalyticsPage(),
                                  transitionDuration: Duration(seconds: 0),
                                ),
                              );
                            } else {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (_, __, ___) => SummaryPage(),
                                  transitionDuration: Duration(seconds: 0),
                                ),
                              );
                            }
                          },
                          child: Text(
                            "Analytics",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )),
                      SizedBox(
                        width: 20,
                      ),
                      PopupMenuButton(
                          itemBuilder: (_) {
                            return [
                              PopupMenuItem(
                                  value: "Search", child: Text("Search")),
                              PopupMenuItem(
                                  value: "Import Search",
                                  child: Text("Import Search")),
                              PopupMenuItem(
                                  value: "Saved Search",
                                  child: Text("Saved Search")),
                            ];
                          },
                          onSelected: (i) {
                            if (i == "Search") {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (_, __, ___) => SearchPage(),
                                  transitionDuration: Duration(seconds: 0),
                                ),
                              );
                            } else if (i == "Import Search") {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (_, __, ___) =>
                                      ImportSearchPage(),
                                  transitionDuration: Duration(seconds: 0),
                                ),
                              );
                            } else {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (_, __, ___) =>
                                      SavedSearchPage(),
                                  transitionDuration: Duration(seconds: 0),
                                ),
                              );
                            }
                          },
                          child: Text(
                            "Search",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )),
                      SizedBox(
                        width: 20,
                      ),
                      PopupMenuButton(
                          itemBuilder: (_) {
                            return [
                              PopupMenuItem(
                                  value: "Import Contact",
                                  child: Text("Import Contact")),
                            ];
                          },
                          onSelected: (i) {
                            if (i == "Import Contact") {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (_, __, ___) =>
                                      ImportContactSearchPage(),
                                  transitionDuration: Duration(seconds: 0),
                                ),
                              );
                            }
                          },
                          child: Text(
                            "Contact",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )),
                      SizedBox(
                        width: 10,
                      ),
                      PopupMenuButton(
                          itemBuilder: (_) {
                            return [
                              PopupMenuItem(
                                  value: "Look for company info",
                                  child: Text("Look for company info")),
                              PopupMenuItem(
                                  value: "Company position",
                                  child: Text("Company position")),
                            ];
                          },
                          onSelected: (i) {
                            if (i == "Look for company info") {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (_, __, ___) =>
                                      CompanyInfoPage(),
                                  transitionDuration: Duration(seconds: 0),
                                ),
                              );
                            }
                            if (i == "Company position") {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (_, __, ___) =>
                                      CompanyPositionPage(),
                                  transitionDuration: Duration(seconds: 0),
                                ),
                              );
                            }
                          },
                          child: Text(
                            "Company info",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )),
                      SizedBox(
                        width: 10,
                      ),
                      NavBarItemRow(
                        text: 'Logout',
                        function: () {
                          Navigator.pushReplacement(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (_, __, ___) => Login(),
                              transitionDuration: Duration(seconds: 0),
                            ),
                          );
                        },
                      )
                    ],
                  );
                }
              })
            ],
          ),
        ),
      ],
    );
  }
}
