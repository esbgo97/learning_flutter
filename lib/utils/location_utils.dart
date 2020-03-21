import 'package:latlong/latlong.dart';

LatLng moveTo(LatLng postion, double lat, double lon) =>
    LatLng(postion.latitude + lat, postion.longitude + lon);
