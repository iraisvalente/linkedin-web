import 'package:flutter/material.dart';
import 'package:project/pages/about/about.dart';
import 'package:project/widgets/navbar_button.dart';
import 'package:project/widgets/navbar_item.dart';
import 'package:project/pages/login/login.dart';
import 'package:project/pages/register/register.dart';
import 'package:project/widgets/navbar_item_column.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  double collapsableHeight = 0.0;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    List<Widget> navBarItemsRow = [
      NavBarItemRow(
        text: 'Login',
        function: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => Login(),
              transitionDuration: Duration(seconds: 0),
            ),
          );
        },
      ),
      NavBarItemRow(
        text: 'Register',
        function: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => Register(),
              transitionDuration: Duration(seconds: 0),
            ),
          );
        },
      ),
      NavBarItemRow(
        text: 'About',
        function: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => AboutPage(),
              transitionDuration: Duration(seconds: 0),
            ),
          );
        },
      )
    ];

    List<Widget> navBarItemsColumns = [
      NavBarItemColumn(
        text: 'Login',
        function: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => Login(),
              transitionDuration: Duration(seconds: 0),
            ),
          );
        },
      ),
      NavBarItemColumn(
        text: 'Register',
        function: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => Register(),
              transitionDuration: Duration(seconds: 0),
            ),
          );
        },
      )
    ];

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
          child: SingleChildScrollView(
            child: Column(
              children: navBarItemsColumns,
            ),
          ),
        ),
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
                          collapsableHeight = 50.0 * navBarItemsColumns.length;
                        });
                      } else if (collapsableHeight ==
                          50.0 * navBarItemsColumns.length) {
                        setState(() {
                          collapsableHeight = 0.0;
                        });
                      }
                    },
                  );
                } else {
                  return Row(
                    children: navBarItemsRow,
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
