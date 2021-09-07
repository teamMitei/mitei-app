  // 現在地
  /*
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

        // 現在地座標にMarkerを立てる
      final marker = Marker(
        markerId: MarkerId(currentPosition.timestamp.toString()),
        position: LatLng(currentPosition.latitude, currentPosition.longitude),
      );
      markers.value.clear();
      markers.value[currentPosition.timestamp.toString()] = marker;
          var options = MarkerOptions(position: LatLng(35.6580339, 139.7016358));
    controller.addMarker(options);
      */
