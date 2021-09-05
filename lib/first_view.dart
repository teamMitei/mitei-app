import 'package:flutter/material.dart';
import 'package:location_3/map_view.dart';

class Const {
  static const routeFirstView = '/first';
}

class FirstView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.white),
      routes: <String, WidgetBuilder>{
        Const.routeFirstView: (BuildContext context) => MapView(),
      },
      home: _FirstView(),
    );
  }
}

class _FirstView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Maps App'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.pushNamed(context, Const.routeFirstView),
          child: const Text('Launch the map'),
        ),
      ),
    );
  }
}
