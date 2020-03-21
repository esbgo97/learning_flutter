import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocation/geolocation.dart';
import 'package:latlong/latlong.dart';

class MapsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MapsPages();
}

class _MapsPages extends State<MapsPage> {
  static LatLng actualPosition;
  List<Marker> allMarkers = List<Marker>();
  MapController controller = MapController();

  getPermission() async {
    // const permissions = LocationPermission(
    //     android: LocationPermissionAndroid.fine,
    //     ios: LocationPermissionIOS.always);

    final GeolocationResult result =
        await Geolocation.requestLocationPermission();

    return result;
  }

  @override
  void initState() {
    super.initState();
  }

  getLocation() {
    return getPermission().then((result) async {
      print("Permission: " + result.toString());
      if (result.isSuccessful) {
        return Geolocation.currentLocation(accuracy: LocationAccuracy.best);
      }
      return null;
    });
  }

  getPosition() {
    getLocation().then((response) {
      if (response != null) {
        response.listen((value) {
          setState(() {
            actualPosition =
                LatLng(value.location.latitude, value.location.longitude);
                allMarkers.add(createMarker(Colors.red, actualPosition));
          });
          controller.move(actualPosition, 18.0);
        });
      } else {
        Scaffold.of(this.context).showSnackBar(SnackBar(
          content: Text("Cannot get permission!"),
          duration: Duration(seconds: 5),
        ));
      }
    });
  }

  addToList() async {
    final query = "Hospital Kennedy Bogotá, Colombia";
    var address = await Geocoder.local.findAddressesFromQuery(query);
    var first = address.first;
    var addedPosition =
        LatLng(first.coordinates.latitude, first.coordinates.longitude);
    print("Added pos=>" + addedPosition.toString());
  }

  // Future addMarker() async {
  //   await showDialog(
  //       context: context,
  //       barrierDismissible: true,
  //       builder: (BuildContext context) {
  //         return SimpleDialog(
  //           title: Text("Add Marker"),
  //           children: <Widget>[
  //             SimpleDialogOption(
  //               child: Text("Add"),
  //               onPressed: () {
  //                 addToList();
  //               },
  //             )
  //           ],
  //         );
  //       });
  // }

  Marker createMarker(Color color, LatLng pos) {
    return Marker(
        width: 45.0,
        height: 45.0,
        point: pos,
        builder: (context) => Container(
              child: IconButton(
                icon: Icon(Icons.location_on),
                color: color,
                iconSize: 45.0,
                onPressed: () {
                  print("Mark Pressed");
                },
              ),
            ));
  }

  Widget loadMap() {
    print("loading map data");
    return StreamBuilder(
        stream: Firestore.instance.collection("markers").snapshots(),
        builder: (context, snapshot) {
          print("loaded map data" + snapshot.toString());
          if (!snapshot.hasData) return Text('Loading Markers... Please wait');
          List<Marker> marks = List<Marker>();
          for (int i = 0; i < snapshot.data.documents.length; i++) {
            var mark = snapshot.data.documents[i];
            GeoPoint coords = mark["coords"];
            print("added mark" + mark["name"] + coords.toString());
            marks.add(createMarker(
                Colors.blue, LatLng(coords.latitude, coords.longitude)));

            print(marks.length.toString());
          }
          return FlutterMap(
              mapController: controller,
              options: MapOptions(
                minZoom: 10.0,
                center: actualPosition,
              ),
              layers: [
                TileLayerOptions(
                    urlTemplate:
                        "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                    subdomains: ['a', 'b', 'c']),
                MarkerLayerOptions(markers: marks)
              ]);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Maps (${actualPosition.toString()})"),
      ),
      persistentFooterButtons: <Widget>[
        ButtonBar(
          alignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
                icon: Icon(Icons.cloud_download),
                color: Colors.blue,
                onPressed: () {
                  print("start Firebase");
                }),
            IconButton(
                icon: Icon(Icons.delete),
                color: Colors.blue,
                onPressed: () {
                  print("removed marks!");
                  setState(() {
                    allMarkers = [];
                  });
                }),
            IconButton(
                icon: Icon(Icons.add_location),
                color: Colors.blue,
                onPressed: () {
                  print("add manual mark");
                })
          ],
        )
      ],
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.my_location),
          onPressed: () {
            getPosition();
          }),
      body: loadMap(),
    );
  }
}
