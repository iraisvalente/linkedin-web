import 'package:flutter/material.dart';

import 'package:project/widgets/navbar_init.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        NavBar(),
        Container(
          height: 100,
          child: Center(child: Text('This is the privacy policy')),
        )
      ],
    ));
  }
}
