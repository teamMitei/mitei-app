import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:location_3/map_view.dart';
import 'package:location_3/next_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:volume_control/volume_control.dart';

import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'dart:async';
import 'dart:io';

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
      routes: <String, WidgetBuilder>{
        Const.routeFirstView: (BuildContext context) => MainPage(),
      },
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

class _MyHomePageState extends State<MyHomePage> {
  late Timer _timer;

  var _status = 'Ready';

  bool _isEnabled = true;

  String text = '次へ';
  final myFocusNode = FocusNode();
  String name = '';

  String buttonCol = '#ff0000';

  @override
  void initState() {
    super.initState();
    initVolumeState();
  }

  //init volume_control plugin
  Future<void> initVolumeState() async {
    if (!mounted) return;

    //read the current volume
    _val = await VolumeControl.volume;
    setState(() {});
  }

  double _val = 50;

  @override
  Widget build(BuildContext context) {
    final double deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          Icon(Icons.add),
          Icon(Icons.share),
        ],
      ),

      persistentFooterButtons: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              child: Center(
                child: IconButton(
                  icon: Icon(Icons.map),
                  onPressed: () {
                    // ここにボタンを押した時に呼ばれるコードを書く
                    Navigator.pushNamed(context, Const.routeFirstView);
                  },
                ),
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
                                              primary: HexColor(
                                                  buttonCol), // HexColorで指定 //ボタンの背景色
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
                    // ).then((shouldUpdate) {
                    //   print('end');
                    //   if (shouldUpdate) {
                    //     setState(() {
                    //       if (Platform.isAndroid) {
                    //         FlutterRingtonePlayer.stop();
                    //       } else if (Platform.isIOS) {
                    //         if (_timer != null && _timer.isActive)
                    //           _timer.cancel();
                    //       }
                    //     });
                    //   }
                    // }),

                    // FlutterRingtonePlayer.play(
                    //   android: AndroidSounds.notification, // Android用のサウンド
                    //   ios: const IosSound(1014), // iOS用のサウンド
                    // ),
                    // if (Platform.isIOS) {
                    //   _timer = Timer.periodic(
                    //     Duration(seconds: 2),
                    //     (Timer timer) => {
                    //       FlutterRingtonePlayer.play(
                    //         android: AndroidSounds.notification, // Android用のサウンド
                    //         ios: const IosSound(1014), // iOS用のサウンド
                    //       ),
                    //     },
                    //   ),
                    // }
                  },
                ),
              ),
            ),
          ],
        )
      ],
      body: Container(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'images/tiny01.png',
            width: deviceHeight * 0.3,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              
            ],
          )
        ],
      )),
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
