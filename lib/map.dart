// Map View

import 'package:flutter/material.dart';
// Latitude & Longitude
import 'package:geolocator/geolocator.dart';
// Google Map
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
// file

class Const {
  static const routeFirstView = '/first';
}

class Item {
  Item(this.lat, this.lon);
  //Item(this.lat, this.lon, this.stamp, this.daydata);

  final double lat;
  final double lon;
  //final int stamp;
  //final int daydata;
}

List<Item> data = <Item>[
  Item(35, 135),
  Item(36, 136),
];

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      routes: <String, WidgetBuilder>{
        //Const.routeFirstView: (BuildContext context) => MapView(),
      },
      home: MyMap(),
    );
  }
}

class MyMap extends StatefulWidget {
  MyMap({Key? key, this.title}) : super(key: key);
  final String? title;
  @override
  _MyMap createState() => _MyMap();
}

class _MyMap extends State<MyMap> {
  /* Latitude & Longitude */

  /*Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }*/

  final List _myMarker = [];
  /* Google Map */
  final Completer<GoogleMapController> _mapController = Completer();
  // 初期表示位置を渋谷駅に設定
  final Position _initialPosition = Position(
    latitude: 35.658034,
    longitude: 139.701636,
    timestamp: DateTime.now(),
    altitude: 0,
    accuracy: 0,
    heading: 0,
    floor: null,
    speed: 0,
    speedAccuracy: 0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('useState example')),
      body: GoogleMap(
        // マップとマーカー表示
        onMapCreated: _mapController.complete,
        markers: Set.from(_myMarker),
        //onTap: _hand,
        // 初期位置
        initialCameraPosition: CameraPosition(
          target: LatLng(_initialPosition.latitude, _initialPosition.longitude),
          zoom: 17.0,
        ),
        // 地図タイプ
        mapType: MapType.normal,
        // 現在地マーク
        myLocationEnabled: true,
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: _getLocation, child: Icon(Icons.star)),
    );
  }

  _getLocation() async {
    final cPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    print(LatLng(cPosition.latitude, cPosition.longitude));
    print(data);
    data.add(Item(cPosition.latitude, cPosition.longitude));
    setState(() {
      //myMarker = [];
      _myMarker.add(Marker(
        markerId: MarkerId(cPosition.toString()),
        position: LatLng(cPosition.latitude, cPosition.longitude),
      ));
    });
  }

  /*_hand(LatLng tapPoint) {
    setState(() {
      _myMarker.add(Marker(
        markerId: MarkerId(tapPoint.toString()),
        position: tapPoint,
      ));
    });
  }*/
}
