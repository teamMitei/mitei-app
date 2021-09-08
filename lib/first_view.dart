import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:volume_control/volume_control.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'dart:async';
import 'dart:io';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_hooks/flutter_hooks.dart';


class Const {
  static const routeFirstView = '/first';
}

class FirstView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'TeamMitei'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
    var _status = 'Ready';

  bool _isEnabled = true;
  late Timer _timer;

  double _val = 50;

  final myController = TextEditingController();
  String _imageText = 'images/tiny02.jpg';

  @override
  Widget build(BuildContext context) {
    final double deviceHeight = MediaQuery.of(context).size.height;

    final items = [
      'qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq',
      'ffff',
      'ffff',
      'ffff',
      'ffff',
      'ffff',
      'ffff',
      'ffff',
      'ffff'
    ];

    //listViewのSize等の指定
    Widget setupAlertDialoadContainer() {
      return Container(
        height: deviceHeight * 0.3, // Change as per your requirement
        width: deviceHeight * 0.5, // Change as per your requirement
        child: Scrollbar(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: items.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                leading: Image.asset('images/tiny02.jpg'),
                title: Text('${items[index]}'),
              );
            },
          ),
        ),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Google Maps View'),
      ),
      persistentFooterButtons: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    child: IconButton(
                      icon: Icon(Icons.comment),
                      onPressed: () {
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(
                                  '口コミ',
                                  textAlign: TextAlign.center,
                                ),
                                content: setupAlertDialoadContainer(),
                                actions: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Center(
                                        child: ElevatedButton(
                                          child: const Text('write'),
                                          style: ElevatedButton.styleFrom(
                                            primary: Colors.orange,
                                            onPrimary: Colors.white,
                                          ),
                                          onPressed: () {
                                            // ここにボタンを押した時に呼ばれるコードを書く
                                          },
                                        ),
                                      ),
                                      Center(
                                        child: ElevatedButton(
                                          child: const Text('cancel'),
                                          style: ElevatedButton.styleFrom(
                                            primary: Colors.orange,
                                            onPrimary: Colors.white,
                                          ),
                                          onPressed: () {
                                            // ここにボタンを押した時に呼ばれるコードを書く
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            });
                      },
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Center(
                child: IconButton(
                  icon: Icon(Icons.call),
                  onPressed: () {
                    // ここにボタンを押した時に呼ばれるコードを書く
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) {
                        return AlertDialog(
                          title: Text(
                            "110番通報する",
                            textAlign: TextAlign.center,
                          ),
                          actions: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  child: ElevatedButton(
                                    child: Text('call'),
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.orange,
                                      onPrimary: Colors.white,
                                    ),
                                    onPressed: () {
                                      // ここにボタンを押した時に呼ばれるコードを書く
                                      var url = 'https://flutter.keicode.com/';
                                      _launchUrl('$url');
                                    },
                                  ),
                                ),
                                Container(
                                  child: ElevatedButton(
                                    child: Text('cancel'),
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.orange,
                                      onPrimary: Colors.white,
                                    ),
                                    onPressed: () {
                                      // ここにボタンを押した時に呼ばれるコードを書く
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                              ],
                            )
                          ],
                        );
                      },
                    );
                    // var tel = '+12345678901';
                    // _launchUrl('tel:$tel');
                  },
                ),
              ),
            ),
            Container(
              child: Center(
                child: IconButton(
                  icon: Icon(Icons.campaign),
                  onPressed: () => {
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (_) {
                        return AlertDialog(
                          backgroundColor: Colors.transparent,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          actions: <Widget>[
                            // ボタン領域
                            Column(
                              children: <Widget>[
                                Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        child: SizedBox(
                                          height: deviceHeight * 0.3,
                                          width: deviceHeight * 0.3,
                                          child: ElevatedButton(
                                            child: FittedBox(
                                              fit: BoxFit.fitWidth,
                                              child: Text(
                                                "Tap",
                                                style: TextStyle(fontSize: 32),
                                              ),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors
                                                  .red, // HexColorで指定 //ボタンの背景色
                                              onPrimary: Colors.black,
                                              shape: const CircleBorder(
                                                side: BorderSide(
                                                  color: Colors.black,
                                                  width: 1,
                                                  style: BorderStyle.solid,
                                                ),
                                              ),
                                            ),
                                            onPressed: () {
                                              if (_isEnabled) {
                                                _isEnabled = false;
                                                FlutterRingtonePlayer.play(
                                                  android: AndroidSounds
                                                      .notification, // Android用のサウンド
                                                  ios: const IosSound(
                                                      1014), // iOS用のサウンド
                                                );
                                                if (Platform.isIOS) {
                                                  _timer = Timer.periodic(
                                                    Duration(seconds: 2),
                                                    (Timer timer) => {
                                                      FlutterRingtonePlayer
                                                          .play(
                                                        android: AndroidSounds
                                                            .notification, // Android用のサウンド
                                                        ios: const IosSound(
                                                            1014), // iOS用のサウンド
                                                      ),
                                                      () {
                                                        VolumeControl.setVolume(
                                                            _val);
                                                      }
                                                    },
                                                  );
                                                }
                                              } else {
                                                _isEnabled = true;
                                                if (Platform.isAndroid) {
                                                  FlutterRingtonePlayer.stop();
                                                } else if (Platform.isIOS) {
                                                  if (_timer != null &&
                                                      _timer.isActive)
                                                    _timer.cancel();
                                                }
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  child: Center(
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.close_rounded,
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        if (Platform.isAndroid) {
                                          FlutterRingtonePlayer.stop();
                                        } else if (Platform.isIOS) {
                                          if (_timer != null && _timer.isActive)
                                            _timer.cancel();
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    )
                  },
                ),
              ),
            ),
          ],
        )
      ],
      body: _MapView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // ここにボタンを押した時に呼ばれるコードを書く
          showModalBottomSheet(
              //モーダルの背景の色、透過
              backgroundColor: Colors.transparent,
              //ドラッグ可能にする（高さもハーフサイズからフルサイズになる様子）
              isScrollControlled: true,
              context: context,
              builder: (BuildContext context) {
                return StatefulBuilder(builder: (BuildContext context,
                    StateSetter setState /*You can rename this!*/) {
                  return Container(
                    margin: EdgeInsets.only(top: 64),
                    decoration: BoxDecoration(
                      //モーダル自体の色
                      color: Colors.white,
                      //角丸にする
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    child: TextButton(
                                      child: const Text('キャンセル'),
                                      style: TextButton.styleFrom(
                                        primary: Colors.black,
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        myController.text = '';
                                        setState(() {
                                          _imageText = 'images/tiny02.jpg';
                                        });
                                      },
                                    ),
                                  ),
                                  Container(
                                    child: ElevatedButton(
                                      child: const Text('投稿'),
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.blue,
                                        onPrimary: Colors.black,
                                        shape: const StadiumBorder(),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _imageText = 'images/tiny02.jpg';
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child: TextField(
                                maxLines: 4,
                                controller: myController,
                                autofocus: true,
                                decoration: InputDecoration(
                                  hintText: 'コメントを入力',
                                  fillColor: Colors.grey[200],
                                  filled: true,
                                ),
                              ),
                            ),
                            Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    child: SizedBox(
                                      height: deviceHeight * 0.1,
                                      width: deviceHeight * 0.1,
                                      child: IconButton(
                                        icon: Image.asset(
                                          'images/tiny02.jpg',
                                          width: deviceHeight * 0.6,
                                          height: deviceHeight * 0.6,
                                        ),
                                        onPressed: () {
                                          // ここにボタンを押した時に呼ばれるコードを書く
                                          setState(() {
                                            _imageText = 'images/tiny02.jpg';
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: SizedBox(
                                      height: deviceHeight * 0.1,
                                      width: deviceHeight * 0.1,
                                      child: IconButton(
                                        icon: Image.asset(
                                          'images/tiny03.jpg',
                                          width: deviceHeight * 0.6,
                                          height: deviceHeight * 0.6,
                                        ),
                                        onPressed: () {
                                          // ここにボタンを押した時に呼ばれるコードを書く
                                          setState(() {
                                            _imageText = 'images/tiny03.jpg';
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: SizedBox(
                                      height: deviceHeight * 0.1,
                                      width: deviceHeight * 0.1,
                                      child: IconButton(
                                        icon: Image.asset(
                                          'images/tiny04.jpg',
                                          width: deviceHeight * 0.6,
                                          height: deviceHeight * 0.6,
                                        ),
                                        onPressed: () {
                                          // ここにボタンを押した時に呼ばれるコードを書く
                                          setState(() {
                                            _imageText = 'images/tiny04.jpg';
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: SizedBox(
                                      height: deviceHeight * 0.1,
                                      width: deviceHeight * 0.1,
                                      child: IconButton(
                                        icon: Image.asset(
                                          'images/tiny02.jpg',
                                          width: deviceHeight * 0.6,
                                          height: deviceHeight * 0.6,
                                        ),
                                        onPressed: () {
                                          // ここにボタンを押した時に呼ばれるコードを書く
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child: Center(
                                child: Image.asset(
                                  '$_imageText',
                                  width: deviceHeight * 0.15,
                                  height: deviceHeight * 0.15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                });
              });
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }

  _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      setState(() {
        _status = 'Unable to launch url $url';
      });
    }
  }

}

// child: ElevatedButton(
//   onPressed: () => Navigator.pushNamed(context, Const.routeFirstView),
//   child: const Text('Launch the map'),
// ),

class _MapView extends HookWidget {
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
    // 初期表示座標のMarkerを設定
    final initialMarkers = {
      _initialPosition.timestamp.toString(): Marker(
        markerId: MarkerId(_initialPosition.timestamp.toString()),
        position: LatLng(_initialPosition.latitude, _initialPosition.longitude),
      ),
    };
    final position = useState<Position>(_initialPosition);
    final markers = useState<Map<String, Marker>>(initialMarkers);

    _setCurrentLocation(position, markers);
    _animateCamera(position);

    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        myLocationButtonEnabled: false,
        // 初期表示位置は渋谷駅に設定
        initialCameraPosition: CameraPosition(
          target: LatLng(_initialPosition.latitude, _initialPosition.longitude),
          zoom: 14.4746,
        ),
        onMapCreated: _mapController.complete,
        markers: markers.value.values.toSet(),
      ),
    );
  }

  Future<void> _setCurrentLocation(ValueNotifier<Position> position,
      ValueNotifier<Map<String, Marker>> markers) async {
    final currentPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    const decimalPoint = 3;
    // 過去の座標と最新の座標の小数点第三位で切り捨てた値を判定
    if ((position.value.latitude).toStringAsFixed(decimalPoint) !=
            (currentPosition.latitude).toStringAsFixed(decimalPoint) &&
        (position.value.longitude).toStringAsFixed(decimalPoint) !=
            (currentPosition.longitude).toStringAsFixed(decimalPoint)) {
      // 現在地座標にMarkerを立てる
      final marker = Marker(
          markerId: MarkerId(currentPosition.timestamp.toString()),
          position: LatLng(currentPosition.latitude, currentPosition.longitude),

          //追記----------------------------------------------------------------------
          onTap: () {
            print('tap');
          }
          //--------------------------------------------------------------------------
          );
      markers.value.clear();
      markers.value[currentPosition.timestamp.toString()] = marker;
      // 現在地座標のstateを更新する
      position.value = currentPosition;
    }
  }

  Future<void> _animateCamera(ValueNotifier<Position> position) async {
    final mapController = await _mapController.future;
    // 現在地座標が取得できたらカメラを現在地に移動する
    await mapController.animateCamera(
      CameraUpdate.newLatLng(
        LatLng(position.value.latitude, position.value.longitude),
      ),
    );
  }
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
