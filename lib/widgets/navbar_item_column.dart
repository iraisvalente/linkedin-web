import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

double collapsableHeight = 0.0;
Color selected = Color(0xffffffff);
Color notSelected = Color(0xafffffff);

class NavBarItemColumn extends StatefulWidget {
  final String text;
  final Function function;
  NavBarItemColumn({
    super.key,
    required this.text,
    required this.function,
  });

  @override
  _NavBarItemColumnState createState() => _NavBarItemColumnState();
}

class _NavBarItemColumnState extends State<NavBarItemColumn> {
  Color color = notSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(),
        SizedBox(
          width: double.infinity,
          height: 30,
          child: TextButton(
              onPressed: () => widget.function(),
              child: Text(
                widget.text,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              )),
        ),
      ],
    );
  }
}
