import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocation/geolocation.dart';
import 'package:pruebas_flutter/components/layout.dart';

class CrudPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CrudPage();
}

class _CrudPage extends State<CrudPage> {
  List<DocumentSnapshot> datos;
  final formKey = GlobalKey<FormState>();
  String markerName = "";
  double latitude = 0, longitude = 0;

  getMarkers() {
    Firestore.instance.collection("markers").snapshots().listen((data) {
      var resp = data.documents;
      setState(() {
        datos = resp;
      });
    });
  }

  @override
  void initState() {
    getMarkers();
    super.initState();
  }

  Future addMarker() async {
    await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return SimpleDialog(
              title: Text(
                "Creating Marker",
              ),
              children: <Widget>[
                Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Column(
                            children: <Widget>[
                              buildInputText("Name", TextInputType.text, (val) {
                                setState(() {
                                  markerName = val;
                                });
                              }, markerName),
                              buildInputText("Latitude", TextInputType.number,
                                  (val) {
                                setState(() {
                                  latitude = val;
                                });
                              }, latitude),
                              buildInputText("Longitude", TextInputType.text,
                                  (val) {
                                setState(() {
                                  longitude = val;
                                });
                              }, longitude),
                              Padding(
                                padding: EdgeInsets.all(20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    RaisedButton(
                                        color: Colors.blue,
                                        child: IconButton(
                                            icon: Icon(
                                              Icons.save,
                                              color: Colors.white,
                                            ),
                                            onPressed: null),
                                        onPressed: () {
                                          saveMarker().then((resp) {
                                            Navigator.of(context).pop();
                                          });
                                        }),
                                    RaisedButton(
                                        color: Colors.blue,
                                        child: IconButton(
                                            icon: Icon(
                                              Icons.my_location,
                                              color: Colors.white,
                                            ),
                                            onPressed: null),
                                        onPressed: () async {
                                          await Geolocation
                                                  .requestLocationPermission()
                                              .then((resp) {
                                            if (resp.isSuccessful) {
                                              Geolocation.currentLocation(
                                                      accuracy:
                                                          LocationAccuracy.best)
                                                  .listen((onData) {
                                                setState(() {
                                                  latitude =
                                                      onData.location.latitude;
                                                  longitude =
                                                      onData.location.longitude;
                                                });
                                                print(latitude.toString() +
                                                    ":" +
                                                    longitude.toString());
                                              });
                                            }
                                          });
                                        })
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ))
              ]);
        });
  }

  Future saveMarker() async {
    Map<String, dynamic> data = Map<String, dynamic>();
    data["name"] = markerName;
    data["coords"] = GeoPoint(latitude, longitude);
    print("datos: " + data.toString());
    Firestore.instance.collection("markers").add(data).then((da) {
      print("resp=>" + da.documentID);
    }).catchError((err) {
      print(err.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CRUD Markers(Firebase)'),
      ),
      floatingActionButton: FloatingActionButton(
          child: IconButton(
              icon: Icon(Icons.add), color: Colors.white, onPressed: null),
          onPressed: addMarker),
      body: ListView.builder(
          itemCount: datos == null ? 0 : datos.length,
          itemBuilder: (BuildContext context, i) {
            final mark = datos[i].data;
            GeoPoint point = mark["coords"];
            return ListTile(
              title: Text(mark["name"]),
              subtitle: Text(point.latitude.toString() +": "+ point.longitude.toString()),
              onTap: (){
                print(mark.toString());
              },
            );
          }),
    );
  }
}
