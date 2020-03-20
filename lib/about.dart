import 'package:flutter/material.dart';
import 'package:pruebas_flutter/components/layout.dart';

class AboutPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AboutPage();
}

class _AboutPage extends State<AboutPage> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
      ),
      drawer: buildDrawer(context),
    );
  }
}
