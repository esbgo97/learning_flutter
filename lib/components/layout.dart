import 'package:flutter/material.dart';

import '../about.dart';
import '../data_page.dart';
import '../maps_page.dart';

Widget buildDrawer(BuildContext context) => Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountEmail: Text("esbgo97@gmail.com"),
            accountName: Text("ESBGO97"),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage("https://i.pravatar.cc/300"),
            ),
          ),
          ListTile(
            title: Text("Home"),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text("About"),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => AboutPage()));
            },
          ),
          ListTile(
            title: Text("Maps"),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => MapsPage()));
            },
          ),
          ListTile(
            title: Text("CRUD Markers (Firebase)"),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => CrudPage()));
            },
          )
        ],
      ),
    );

Widget buildInputText(String name, TextInputType type, Function onChange,dynamic value) {
  return TextFormField(
    initialValue: value.toString(),
    decoration: InputDecoration(
      hintText: name,
    ),
    keyboardType: type,
    onChanged: (val){
      onChange(val);
    },
    validator: (val) {
      if (val.isEmpty) {
        return "Please enater a $name";
      }
      return null;
    },
  );
}
