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

import 'package:http/http.dart' as http;
import 'dart:convert';

// マップの登録位置群を取得-------------------------------------------------------------
Future<String> getMaps() async {
  final response = await http
      .get(Uri.parse('https://mitei-backend-api-v2.herokuapp.com/maps'));
  print(response.body);
  return Future<String>.value(response.body);
}

// マップ位置の登録　(経度，緯度，スタンプランク)
void postMap(double latitude, double longitude, int rank) async {
  final response = await http.post(
      Uri.parse('https://mitei-backend-api-v2.herokuapp.com/maps'),
      body: json
          .encode({"latitude": latitude, "longitude": longitude, "rank": rank}),
      headers: {"Content-Type": "application/json"});
  print(response.body);
  //print('${jsonDecode(response.body)['data']['id']}');
}

void postMapFirst(
    double latitude, double longitude, int rank, String comment_body) async {
  final response = await http.post(
      Uri.parse('https://mitei-backend-api-v2.herokuapp.com/maps'),
      body: json
          .encode({"latitude": latitude, "longitude": longitude, "rank": rank}),
      headers: {"Content-Type": "application/json"});
  print(response.body);
  int id = jsonDecode(response.body)['data']['id'];
  print(id);
  postMapComment(comment_body, id, rank);
}

//マップに基づいたコメントの表示
Future<String> getMapComment(int map_id) async {
  final response = await http.get(Uri.parse(
      'https://mitei-backend-api-v2.herokuapp.com/maps/comment/' +
          map_id.toString()));
  print(response.body);
  //print(jsonDecode(response.body)['data'][0]['body']);
  return Future<String>.value(response.body);
}

void postMapComment(String comment_context, int maps_id, int rank) async {
  final response = await http.post(
      Uri.parse('https://mitei-backend-api-v2.herokuapp.com/comments'),
      body: json
          .encode({"body": comment_context, "maps_id": maps_id, "rank": rank}),
      headers: {"Content-Type": "application/json"});
  print(response.body);
}

//----------------------------------------------------------------------------------

class Const {
  static const routeFirstView = '/first';
}

// class Item {
//   Item(this.lat, this.lon);
//   //Item(this.lat, this.lon, this.stamp, this.daydata);

//   final double lat;
//   final double lon;
//   //final int stamp;
//   //final int daydata;
// }

class Item {
  Item(this.lat, this.lon);
  //Item(this.lat, this.lon, this.stamp, this.daydata);

  final double lat;
  final double lon;
  double getlet() {
    return this.lat;
  }

  double getlon() {
    return this.lon;
  }
  //final int stamp;
  //final int daydata;
}

List<Item> data = <Item>[
  Item(35, 135),
  Item(36, 136),
];

late Future<String> locationList;
var latitudeList = [];
var longitudeList = [];
var locationIdList = [];
var locationStamplist = [];
int idLocationCount = 0;

late Position cPosition;

late final Position currentLocationX;
late final Position currentLocationY;

Map locationMaps = {};

final List startSetMaps = [];
//

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

bool testFlag = false;

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  var _status = 'Ready';

  bool _isEnabled = true;
  late Timer _timer;

  double _val = 50;

  final myController = TextEditingController();
  String _imageText = 'images/tiny02.jpg';
  int rankStamp = 1;

  @override
  void initState() {
    super.initState();

    //アプリ起動時に一度だけ実行される
    locationList = getMaps();

    locationList.then((value) {
      latitudeList = [];
      longitudeList = [];
      locationIdList = [];
      locationStamplist = [];
      idLocationCount = 0;
      try {
        while (true) {
          data.add(Item(jsonDecode(value)['data'][idLocationCount]['latitude'],
              jsonDecode(value)['data'][idLocationCount]['longitude']));
          latitudeList
              .add(jsonDecode(value)['data'][idLocationCount]['latitude']);
          longitudeList
              .add(jsonDecode(value)['data'][idLocationCount]['longitude']);
          locationIdList.add(jsonDecode(value)['data'][idLocationCount]['id']);
          locationStamplist
              .add(jsonDecode(value)['data'][idLocationCount]['rank']);
          idLocationCount += 1;
        }
      } catch (e) {
        print(idLocationCount);
        //print(latitudeList);
      }
    });

    // for (int i = 0; i <= idLocationCount; i++) {
    //   data.add(Item(latitudeList[i], longitudeList[i]));
    // }
  }

  @override
  Widget build(BuildContext context) {
    final double deviceHeight = MediaQuery.of(context).size.height;

    var items = [];
    var stampNum = [];
    String stampName = 'tiny02.jpg';

    var textList = getMapComment(1);
    // textList.then((value) {
    //   int idCount = 0;
    //   try {
    //     setState(() {
    //       while (true) {
    //         items.add(jsonDecode(value)['data'][idCount]['body']);
    //         idCount += 1;
    //       }
    //     });
    //   } catch (e) {
    //     print(idCount);
    //   }
    // });
    Future _setMapCom() async {
      getMapComment(1);
      textList.then((value) {
        items = [];
        int idCount = 0;
        try {
          setState(() {
            while (true) {
              items.add(jsonDecode(value)['data'][idCount]['body']);
              stampNum.add(jsonDecode(value)['data'][idCount]['rank']);
              idCount += 1;
            }
          });
        } catch (e) {
          print(idCount);
        }
      });
    }

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
              if (stampNum[index] == 1) {
                stampName = 'tiny02.jpg';
              } else if (stampNum[index] == 2) {
                stampName = 'tiny03.jpg';
              } else if (stampNum[index] == 3) {
                stampName = 'tiny04.jpg';
              } else if (stampNum[index] == 4) {
                stampName = 'tiny05.jpg';
              } else if (stampNum[index] == 5) {
                stampName = 'tiny06.jpg';
              } else {
                stampName = 'tiny02.jpg';
              }
              return ListTile(
                leading: Image.asset('images/' + stampName),
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
                        _setMapCom();
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
                                        child: IconButton(
                                          icon: Icon(Icons.add_comment),
                                          onPressed: () {
                                            // ここにボタンを押した時に呼ばれるコードを書く
                                            showModalBottomSheet(
                                                //モーダルの背景の色、透過
                                                backgroundColor:
                                                    Colors.transparent,
                                                //ドラッグ可能にする（高さもハーフサイズからフルサイズになる様子）
                                                isScrollControlled: true,
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return StatefulBuilder(
                                                      builder: (BuildContext
                                                              context,
                                                          StateSetter
                                                              setState /*You can rename this!*/) {
                                                    return Container(
                                                      margin: EdgeInsets.only(
                                                          top: 64),
                                                      decoration: BoxDecoration(
                                                        //モーダル自体の色
                                                        color: Colors.white,
                                                        //角丸にする
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  20),
                                                          topRight:
                                                              Radius.circular(
                                                                  20),
                                                        ),
                                                      ),
                                                      child: Column(
                                                        children: <Widget>[
                                                          Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: <Widget>[
                                                              Container(
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceEvenly,
                                                                  children: [
                                                                    Container(
                                                                      child:
                                                                          TextButton(
                                                                        child: const Text(
                                                                            'キャンセル'),
                                                                        style: TextButton
                                                                            .styleFrom(
                                                                          primary:
                                                                              Colors.black,
                                                                        ),
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);

                                                                          myController.text =
                                                                              '';
                                                                          setState(
                                                                              () {
                                                                            _imageText =
                                                                                'images/tiny02.jpg';
                                                                            rankStamp =
                                                                                1;
                                                                          });
                                                                        },
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      child:
                                                                          ElevatedButton(
                                                                        child: const Text(
                                                                            '投稿'),
                                                                        style: ElevatedButton
                                                                            .styleFrom(
                                                                          primary:
                                                                              Colors.blue,
                                                                          onPrimary:
                                                                              Colors.black,
                                                                          shape:
                                                                              const StadiumBorder(),
                                                                        ),
                                                                        onPressed:
                                                                            () async {
                                                                          await _setMapCom();
                                                                          setState(
                                                                              () {
                                                                            _imageText =
                                                                                'images/tiny02.jpg';
                                                                            //データ送信------------------------
                                                                            postMapComment(
                                                                                myController.text,
                                                                                1,
                                                                                rankStamp);
                                                                            //--------------------------------
                                                                          });
                                                                          Navigator.pop(
                                                                              context);
                                                                          Navigator.pop(
                                                                              context);
                                                                          myController.text =
                                                                              '';
                                                                        },
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Container(
                                                                child:
                                                                    TextField(
                                                                  maxLines: 4,
                                                                  controller:
                                                                      myController,
                                                                  autofocus:
                                                                      true,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    hintText:
                                                                        'コメントを入力',
                                                                    fillColor:
                                                                        Colors.grey[
                                                                            200],
                                                                    filled:
                                                                        true,
                                                                  ),
                                                                ),
                                                              ),
                                                              Container(
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: <
                                                                      Widget>[
                                                                    Container(
                                                                      child:
                                                                          SizedBox(
                                                                        height: deviceHeight *
                                                                            0.1,
                                                                        width: deviceHeight *
                                                                            0.1,
                                                                        child:
                                                                            IconButton(
                                                                          icon:
                                                                              Image.asset(
                                                                            'images/tiny02.jpg',
                                                                            width:
                                                                                deviceHeight * 0.6,
                                                                            height:
                                                                                deviceHeight * 0.6,
                                                                          ),
                                                                          onPressed:
                                                                              () {
                                                                            // ここにボタンを押した時に呼ばれるコードを書く
                                                                            setState(() {
                                                                              _imageText = 'images/tiny02.jpg';
                                                                              rankStamp = 1;
                                                                            });
                                                                          },
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      child:
                                                                          SizedBox(
                                                                        height: deviceHeight *
                                                                            0.1,
                                                                        width: deviceHeight *
                                                                            0.1,
                                                                        child:
                                                                            IconButton(
                                                                          icon:
                                                                              Image.asset(
                                                                            'images/tiny03.jpg',
                                                                            width:
                                                                                deviceHeight * 0.6,
                                                                            height:
                                                                                deviceHeight * 0.6,
                                                                          ),
                                                                          onPressed:
                                                                              () {
                                                                            // ここにボタンを押した時に呼ばれるコードを書く
                                                                            setState(() {
                                                                              _imageText = 'images/tiny03.jpg';
                                                                              rankStamp = 2;
                                                                            });
                                                                          },
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      child:
                                                                          SizedBox(
                                                                        height: deviceHeight *
                                                                            0.1,
                                                                        width: deviceHeight *
                                                                            0.1,
                                                                        child:
                                                                            IconButton(
                                                                          icon:
                                                                              Image.asset(
                                                                            'images/tiny04.jpg',
                                                                            width:
                                                                                deviceHeight * 0.6,
                                                                            height:
                                                                                deviceHeight * 0.6,
                                                                          ),
                                                                          onPressed:
                                                                              () {
                                                                            // ここにボタンを押した時に呼ばれるコードを書く
                                                                            setState(() {
                                                                              _imageText = 'images/tiny04.jpg';
                                                                              rankStamp = 3;
                                                                            });
                                                                          },
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      child:
                                                                          SizedBox(
                                                                        height: deviceHeight *
                                                                            0.1,
                                                                        width: deviceHeight *
                                                                            0.1,
                                                                        child:
                                                                            IconButton(
                                                                          icon:
                                                                              Image.asset(
                                                                            'images/tiny05.jpg',
                                                                            width:
                                                                                deviceHeight * 0.6,
                                                                            height:
                                                                                deviceHeight * 0.6,
                                                                          ),
                                                                          onPressed:
                                                                              () {
                                                                            // ここにボタンを押した時に呼ばれるコードを書く
                                                                            setState(() {
                                                                              _imageText = 'images/tiny05.jpg';
                                                                              rankStamp = 4;
                                                                            });
                                                                          },
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Container(
                                                                child: Center(
                                                                  child: Image
                                                                      .asset(
                                                                    '$_imageText',
                                                                    width:
                                                                        deviceHeight *
                                                                            0.15,
                                                                    height:
                                                                        deviceHeight *
                                                                            0.15,
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
                                        ),
                                      ),
                                      Center(
                                        child: IconButton(
                                          icon: Icon(Icons.close),
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
                            "110番通報",
                            textAlign: TextAlign.center,
                          ),
                          actions: [
                            Container(
                                height: deviceHeight * 0.1,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(
                                      child: CircleAvatar(
                                        radius: 25,
                                        backgroundColor: Colors.lightGreen,
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.call,
                                            color: Colors.black,
                                          ),
                                          onPressed: () {
                                            var url =
                                                'https://flutter.keicode.com/';
                                            _launchUrl('$url');
                                          },
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: CircleAvatar(
                                        radius: 25,
                                        backgroundColor: Colors.red,
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.cancel_sharp,
                                            color: Colors.black,
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
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
                                                  if (_timer.isActive)
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
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        _isEnabled = true;
                                        if (Platform.isAndroid) {
                                          FlutterRingtonePlayer.stop();
                                        } else if (Platform.isIOS) {
                                          if (_timer.isActive) _timer.cancel();
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
            Container(
              child: Center(
                child: IconButton(
                  icon: Icon(Icons.post_add),
                  onPressed: () => {
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
                                                    _imageText =
                                                        'images/tiny02.jpg';
                                                    rankStamp = 1;
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
                                                    _imageText =
                                                        'images/tiny02.jpg';
                                                    //データ送信------------------------
                                                    postMapFirst(
                                                        cPosition.latitude,
                                                        cPosition.longitude,
                                                        rankStamp,
                                                        myController.text);
                                                    print(cPosition.latitude);
                                                    //--------------------------------
                                                  });
                                                  Navigator.pop(context);
                                                  myController.text = '';
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
                                                      _imageText =
                                                          'images/tiny02.jpg';
                                                      rankStamp = 1;
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
                                                      _imageText =
                                                          'images/tiny03.jpg';
                                                      rankStamp = 2;
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
                                                      _imageText =
                                                          'images/tiny04.jpg';
                                                      rankStamp = 3;
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
                                                    'images/tiny05.jpg',
                                                    width: deviceHeight * 0.6,
                                                    height: deviceHeight * 0.6,
                                                  ),
                                                  onPressed: () {
                                                    // ここにボタンを押した時に呼ばれるコードを書く
                                                    setState(() {
                                                      _imageText =
                                                          'images/tiny05.jpg';
                                                      rankStamp = 4;
                                                    });
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
                        }),
                  },
                ),
              ),
            ),
          ],
        )
      ],
      body: MyMap(),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     // ここにボタンを押した時に呼ばれるコードを書く
      //   },
      //   tooltip: 'Increment',
      //   child: Icon(Icons.add),
      // ),
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

class MyMap extends StatefulWidget {
  MyMap({Key? key, this.title}) : super(key: key);
  final String? title;
  @override
  _MyMap createState() => _MyMap();
}

class _MyMap extends State<MyMap> {
  late BitmapDescriptor pinLocationIcon01;
  late BitmapDescriptor pinLocationIcon02;
  late BitmapDescriptor pinLocationIcon03;
  late BitmapDescriptor pinLocationIcon04;
  late BitmapDescriptor pinLocationIcon05;
  late BitmapDescriptor mapIcons;

  @override
  void initState() {
    super.initState();
    setCustomMapPin01();
    setCustomMapPin02();
    setCustomMapPin03();
    setCustomMapPin04();
    setCustomMapPin05();
  }

  void setCustomMapPin01() async {
    pinLocationIcon01 = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), 'images/tiny02_2.jpg');
  }

  void setCustomMapPin02() async {
    pinLocationIcon02 = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), 'images/tiny03_2.jpg');
  }

  void setCustomMapPin03() async {
    pinLocationIcon03 = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), 'images/tiny04_2.jpg');
  }

  void setCustomMapPin04() async {
    pinLocationIcon04 = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), 'images/tiny05_2.jpg');
  }

  void setCustomMapPin05() async {
    pinLocationIcon05 = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), 'images/tiny06_2.jpg');
  }
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
      body: GoogleMap(
        // マップとマーカー表示
        onMapCreated: _mapController.complete,
        markers: Set.from(_myMarker),
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

      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).accentColor,
        onPressed: () {
          _getLocation();
        },
        child: Icon(Icons.add),
      ),
      // bottomNavigationBar: SizedBox(
      //   height: 40,
      //   child: BottomAppBar(
      //     color: Theme.of(context).primaryColor,
      //     notchMargin: 6.0,
      //     shape: AutomaticNotchedShape(
      //       RoundedRectangleBorder(),
      //       StadiumBorder(
      //         side: BorderSide(),
      //       ),
      //     ),
      //     child: Padding(
      //       padding: const EdgeInsets.symmetric(horizontal: 8.0),
      //       child: new Row(
      //         mainAxisSize: MainAxisSize.max,
      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //         children: <Widget>[
      //           IconButton(
      //             icon: Icon(
      //               Icons.person_outline,
      //               color: Colors.white,
      //             ),
      //             onPressed: () {},
      //           ),
      //           IconButton(
      //             icon: Icon(
      //               Icons.info_outline,
      //               color: Colors.white,
      //             ),
      //             onPressed: () {},
      //           ),
      //         ],
      //       ),
      //     ),
      //   ),
      // ),
    );
  }

  _getLocation() async {
    cPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    print(LatLng(cPosition.latitude, cPosition.longitude));
    print(data);
    data.add(Item(cPosition.latitude, cPosition.longitude));
    print(cPosition.latitude);
    setState(() {
      //myMarker = [];
      _myMarker.add(Marker(
        markerId: MarkerId(cPosition.toString()),
        position: LatLng(cPosition.latitude, cPosition.longitude),
        //icon: pinLocationIcon,
      ));
    });
    // print(latitudeList);
    // print(longitudeList);
    //print(locationIdList);
    print(locationStamplist);
    for (int i = 0; i < latitudeList.length; i++) {
      //print(latitudeList);
      setState(() {
        if (locationStamplist[i] == 1) {
          mapIcons = pinLocationIcon01;
        } else if (locationStamplist[i] == 2) {
          mapIcons = pinLocationIcon02;
        } else if (locationStamplist[i] == 3) {
          mapIcons = pinLocationIcon03;
        } else if (locationStamplist[i] == 4) {
          mapIcons = pinLocationIcon04;
        } else if (locationStamplist[i] == 5) {
          mapIcons = pinLocationIcon05;
        }
        //myMarker = [];
        _myMarker.add(
          Marker(
            markerId: MarkerId(locationIdList[i].toString()),
            position: LatLng(latitudeList[i], longitudeList[i]),
            icon: mapIcons,
            //infoWindow: InfoWindow(Image: Image.asset(pinLocationIcon)),
          ),
        );
      });
    }
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
