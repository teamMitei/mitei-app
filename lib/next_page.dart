import 'package:flutter/material.dart';

class NextPage extends StatelessWidget {
  NextPage(this.name);
  String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('次の画面'),
      ),
      persistentFooterButtons: <Widget>[
        IconButton(
          icon: Icon(Icons.map),
          onPressed: () async {
            // ここにボタンを押した時に呼ばれるコードを書く
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NextPage('チーム未定')),
            );
            print(result);
          },
        ),
        IconButton(
          icon: Icon(Icons.add_location),
          onPressed: () async {
            // ここにボタンを押した時に呼ばれるコードを書く
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NextPage('チーム未定')),
            );
            print(result);
          },
        ),
        IconButton(
          icon: Icon(Icons.call),
          onPressed: () async {
            // ここにボタンを押した時に呼ばれるコードを書く
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NextPage('チーム未定')),
            );
            print(result);
          },
        ),
      ],
      body: Container(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            child: Center(
              child: ElevatedButton(
                child: const Text('スタンプを選択'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.orange,
                  onPrimary: Colors.white,
                ),
                onPressed: () {
                  // ここにボタンを押した時に呼ばれるコードを書く
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) {
                      return AlertDialog(
                        title: Text("スタンプ"),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: <Widget>[
                              Column(
                                // コンテンツ
                                children: <Widget>[
                                  Row(
                                    children: [
                                      Container(
                                        child: Center(
                                            child: IconButton(
                                            icon:
                                                Image.asset('images/tiny02.png'),
                                            iconSize: 100,
                                            onPressed: () {
                                              // ここにボタンを押した時に呼ばれるコードを書く
                                            },
                                          )
                                        ),
                                      ),
                                      Container(
                                        child: Center(
                                            child: IconButton(
                                            icon:
                                                Image.asset('images/tiny03.png'),
                                            iconSize: 100,
                                            onPressed: () {
                                              // ここにボタンを押した時に呼ばれるコードを書く
                                            },
                                          )
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        child: Center(
                                            child: IconButton(
                                            icon:
                                                Image.asset('images/tiny03.png'),
                                            iconSize: 100,
                                            onPressed: () {
                                              // ここにボタンを押した時に呼ばれるコードを書く
                                            },
                                          )
                                        ),
                                      ),
                                      Container(
                                        child: Center(
                                            child: IconButton(
                                              icon:
                                                  Image.asset('images/tiny02.png'),
                                              iconSize: 100,
                                              onPressed: () {
                                                // ここにボタンを押した時に呼ばれるコードを書く
                                              },
                                            )
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Center(
                                child: ElevatedButton(
                                  child: const Text('決定'),
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
                                  child: const Text('閉じる'),
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
                    },
                  );
                },
              ),
            ),
          ),
        ],
      )

          // child: Column(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: <Widget>[
          //     Container(
          //       child: Text('スタンプを選択'),
          //     ),
          //     Container(
          //       height: 200.0,
          //       child: ListView(
          //         scrollDirection: Axis.horizontal,
          //         children: <Widget>[
          //           Container(
          //             child: Center(
          //               child: IconButton(
          //                 icon: Image.asset('images/tiny02.png'),
          //                 iconSize: 250,
          //                 onPressed: () {
          //                   // ここにボタンを押した時に呼ばれるコードを書く
          //                 },
          //               )
          //             ),
          //           ),
          //           Container(
          //             child: Center(
          //               child: IconButton(
          //                 icon: Image.asset('images/tiny03.png'),
          //                 iconSize: 250,
          //                 onPressed: () {
          //                   // ここにボタンを押した時に呼ばれるコードを書く
          //                 },
          //               )
          //             ),
          //           ),
          //           Container(
          //             child: Center(
          //               child: IconButton(
          //                 icon: Image.asset('images/tiny03.png'),
          //                 iconSize: 250,
          //                 onPressed: () {
          //                   // ここにボタンを押した時に呼ばれるコードを書く
          //                 },
          //               )
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //     Container(
          //       child: Center(
          //         child: ElevatedButton(
          //           child: const Text('戻る'),
          //           style: ElevatedButton.styleFrom(
          //             primary: Colors.orange,
          //             onPrimary: Colors.white,
          //           ),
          //           onPressed: () {
          //             // ここにボタンを押した時に呼ばれるコードを書く
          //             Navigator.pop(context, 'llllllllll');
          //           },
          //         ),
          //       ),
          //     ),
          //   ],
          // )

          // height: double.infinity,
          // child: Column(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: <Widget>[
          //     Text(name),
          //     Center(
          //       child: ElevatedButton(
          //         child: const Text('戻る'),
          //         style: ElevatedButton.styleFrom(
          //           primary: Colors.orange,
          //           onPrimary: Colors.white,
          //         ),
          //         onPressed: () {
          //           // ここにボタンを押した時に呼ばれるコードを書く
          //           Navigator.pop(context, 'llllllllll');
          //         },
          //       ),
          //     ),
          //   ],
          // )
          ),
    );
  }
}
