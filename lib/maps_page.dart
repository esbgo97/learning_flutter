import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:geolocation/geolocation.dart';
import 'package:latlong/latlong.dart';

class MapsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MapsPages();
}

class _MapsPages extends State<MapsPage> {
  LatLng centralPoint = LatLng(4.6097100, -74.0817500);
  MapController controller = MapController();

  getPermission() async {
    // const permissions = LocationPermission(
    //     android: LocationPermissionAndroid.fine,
    //     ios: LocationPermissionIOS.always);

    final GeolocationResult result =
        await Geolocation.requestLocationPermission();

    return result;
  }

  getLocation() {
    return getPermission().then((result) async {
      if (result.isSuccessful) {
        return Geolocation.currentLocation(accuracy: LocationAccuracy.best);
      }
      return null;
    });
  }

  buildMap() {
    getLocation().then((response) {
      print("Values is :=" + response.toString());
      // if (response.isSuccessful) {
      response.listen((value) {
        print("listennign dispatched!");
        controller.move(
            LatLng(value.location.latitude, value.location.longitude), 15.0);
      });
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    var builedMap = this.buildMap();
    return Scaffold(
      appBar: AppBar(
        title: Text("Pruebas Flutter (Leaflet maps)"),
      ),
      body: FlutterMap(
          mapController: controller,
          options: MapOptions(
            minZoom: 10.0,
            center: builedMap,
          ),
          layers: [
            TileLayerOptions(
                urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c']),
            MarkerLayerOptions(markers: [
              Marker(
                  width: 45.0,
                  height: 45.0,
                  point: builedMap,
                  builder: (context) => Container(
                        child: IconButton(
                          icon: Icon(Icons.location_on),
                          color: Colors.blue,
                          iconSize: 45.0,
                          onPressed: () {
                            print("MarkerPressesd");
                          },
                        ),
                      ))
            ])
          ]),
    );
  }
}
