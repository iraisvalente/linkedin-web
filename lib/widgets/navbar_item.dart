import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

double collapsableHeight = 0.0;
Color selected = Color(0xffffffff);
Color notSelected = Color(0xafffffff);

class NavBarItemRow extends StatefulWidget {
  final String text;
  final Function function;
  NavBarItemRow({
    super.key,
    required this.text,
    required this.function,
  });

  @override
  _NavBarItemRowState createState() => _NavBarItemRowState();
}

class _NavBarItemRowState extends State<NavBarItemRow> {
  Color color = notSelected;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () => widget.function(),
        child: Text(
          widget.text,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ));
  }
}
