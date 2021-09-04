// Map View

import 'package:flutter/material.dart';
// Latitude & Longitude
import 'package:geolocator/geolocator.dart';
// Google Map
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// file

class MyMap extends StatefulWidget {
  MyMap({Key? key, this.title}) : super(key: key);
  final String? title;
  @override
  _MyMap createState() => _MyMap();
}

class _MyMap extends State<MyMap> {
  /* Latitude & Longitude */
  // 現在地を取得
  double _lat = 0.0;
  double _lon = 0.0;
  Future<void> getLocation() async {
    // 現在の位置を返す
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  /*Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }*/

  /* Google Map */
  Completer<GoogleMapController> _controller = Completer();

  // 位置情報
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  static final LatLng _kMapCenter1 =
      LatLng(37.43296265331129, -122.08832357078792);
  static final LatLng _kMapCenter2 =
      LatLng(37.43306265331129, -122.08830057078792);

  //LatLng _mapping = LatLng(_lat, _lon);

  // マーカーの情報
  Set<Marker> _createMarker() {
    return {
      Marker(
          markerId: MarkerId("marker_1"),
          position: _kMapCenter1,
          icon: BitmapDescriptor.defaultMarkerWithHue(5.4),
          infoWindow: InfoWindow(title: "みかん", snippet: 'みかんじゃない')),
      Marker(
        markerId: MarkerId("marker_2"),
        position: _kMapCenter1,
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        markers: _createMarker(),
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: getLocation, child: Icon(Icons.location_on)),
    );
  }
}
