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
  late LatLng _Position;
  double _lat = 0.0;
  double _lon = 0.0;

  Future<void> getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _Position = LatLng(position.latitude, position.longitude);
      _lat = position.latitude;
      _lon = position.longitude;
    });
  }

  /*Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }*/

  /* Google Map */
  late GoogleMapController mapController;

/*
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
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ここを追加
      body: Container(
        child: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _Position,
            zoom: 17.0,
          ),
          // 地図タイプ
          mapType: MapType.normal,
          // 現在地マーク
          myLocationEnabled: true,
/*            // コンパス表示
            compassEnabled: true,
            // 中央に表示される
            myLocationButtonEnabled: true,
            mapToolbarEnabled: true,
            buildingsEnabled: true,
            onTap: (LatLng latLang) {
              print('Clicked: $latLang');
            }*/
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: getLocation, child: Icon(Icons.location_on)),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
      mapController.animateCamera(CameraUpdate.newCameraPosition(
        const CameraPosition(
          target: LatLng(35.6580339, 139.7016358),
          zoom: 17.0,
        ),
      ));
    });
  }
}
