import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:pruebas_flutter/components/layout.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HiveSystemBeta',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Pruebas Flutter (Consumo Web API)'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String userName = 'No user Displayed!';
  List data;
  Future<String> makeRequest() async {
    final response = await http.get("https://randomuser.me/api/?results=20",
        headers: {"Accept": "application/json"});
    setState(() {
      userName = response.body;
      data = jsonDecode(response.body)["results"];
    });
    return response.body;
  }

  @override
  void initState() {
    super.initState();
    this.makeRequest();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: buildDrawer(context),
      body: ListView.builder(
        itemCount: data == null ? 0 : data.length,
        itemBuilder: (BuildContext context, i) {
          return new ListTile(
              title: Text(data[i]["name"]["first"]),
              subtitle: Text(data[i]["phone"]),
              leading: CircleAvatar(
                backgroundImage: NetworkImage(data[i]["picture"]["thumbnail"]),
              ));
        },
      ),
    );
  }
}
