import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class User_Info extends StatefulWidget {
  const User_Info({super.key});

  @override
  State<User_Info> createState() => _User_InfoState();
}

class _User_InfoState extends State<User_Info> {
  double? _deviceWidth, _deviceHeight;
  String _username = 'Loading...'; // ユーザー名を表示するための変数
  String _userrole = 'Loading...'; // ユーザー役割名を表示するための変数

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // APIからデータを取得
        final response = await http.get(
          Uri.parse('https://guser.azurewebsites.net/api/get_user?userid=${user.uid}'),
          headers: {'Content-Type': 'application/json'},
        );

        if (response.statusCode == 201) {
          final data = json.decode(response.body);
          print('APIレスポンス: ${response.body}');
          setState(() {
            _username = data['username'] ?? 'No username found';
            _userrole = data['usertype'] ?? 'No userrole found';
          });
        } else {
          print('APIリクエスト失敗: ${response.statusCode}');
          setState(() {
            _username = 'Error fetching username';
            _userrole = 'Error fetching userrole';
          });
        }
      }
    } catch (e) {
      print('エラーが発生しました: $e');
      setState(() {
        _username = 'Error fetching username';
        _userrole = 'Error fetching userrole';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // 画面の大きさを取得する
    _deviceWidth = MediaQuery.of(context).size.width;
    _deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: _deviceWidth! * 0.8,
            height: _deviceHeight,
            child: Column(
              children: [
                Container(
                  // Aゾーン
                  width: _deviceWidth! * 0.8,
                  height: _deviceHeight! * 0.35,
                  color: Colors.white,
                  child: Center(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                              child: Text(
                                'マイページ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                            Container(
                              height: constraints.maxHeight * 0.5,
                              width: constraints.maxHeight * 0.5,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Image.asset(
                                'assets/images/icon_sample.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'ユーザー名：$_username',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: constraints.maxHeight * 0.1,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: Text(
                                'アカウントタイプ：$_userrole',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: constraints.maxHeight * 0.1,
                                ),
                              ),
                            )
                          ],
                        );
                      },
                    ),
                  ),
                ),
                Container(
                  // Bゾーン
                  width: _deviceWidth! * 0.8,
                  height: _deviceHeight! * 0.2,
                  color: Colors.red.shade900,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          '所持ポイント',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              color: Colors.white),
                        ),
                        SizedBox(height: 10),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '1000',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 36,
                                  color: Colors.white),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'P',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.white),
                              ),
                            )
                          ],
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: 400,
                          height: 50,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50)),
                          child: Text(
                            '〇〇〇と交換する',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  // Cゾーン
                  width: _deviceWidth! * 0.8,
                  height: _deviceHeight! * 0.45,
                  color: Colors.white,
                  child: Scrollbar(
                    child: ListView(
                      itemExtent: 60,
                      children: [
                        Divider(),
                        buildInkWell(context, 'アカウントの設定', Icons.navigate_next, 'アカウント'),
                        Divider(),
                        buildInkWell(context, 'ポイント履歴', Icons.navigate_next, 'ポイント履歴'),
                        Divider(),
                        buildInkWell(context, 'お知らせ', Icons.navigate_next, 'お知らせ'),
                        Divider(),
                        buildInkWell(context, 'その他機能', Icons.navigate_next, 'その他機能'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildInkWell(BuildContext context, String title, IconData icon, String printText) {
    print('関数が実行されました');
    return InkWell(
      onTap: () {
        print('選択されたテキストは:$printText');
      },
      splashColor: Colors.amber,
      child: ListTile(
        leading: Icon(icon),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class User_Info extends StatefulWidget {
//   const User_Info({super.key});

//   @override
//   State<User_Info> createState() => _User_InfoState();
// }

// class _User_InfoState extends State<User_Info> {
//   double? _deviceWidth, _deviceHeight;
//   String _username = 'Loading...'; // ユーザー名を表示するための変数
//   String _userrole = 'Loading...'; // ユーザー役割名を表示するための変数

//   @override
//   void initState() {
//     super.initState();
//     _fetchUsername();
//   }

//   Future<void> _fetchUsername() async {
//     try {
//       User? user = FirebaseAuth.instance.currentUser;
//       if (user != null) {
//         DocumentSnapshot userDoc =
//             await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
//         setState(() {
//           _username = userDoc['username'] ?? 'No username found'; // Firestoreからユーザー名を取得
//           _userrole = userDoc['role'] ?? 'No userrole found'; // Firestoreからユーザー役割を取得
//         });
//       }
//     } catch (e) {
//       print('エラーが発生しました: $e');
//       setState(() {
//         _username = 'Error fetching username';
//         _userrole = 'Error fetching userrole';
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // 画面の大きさを取得する
//     _deviceWidth = MediaQuery.of(context).size.width;
//     _deviceHeight = MediaQuery.of(context).size.height;

//     return Scaffold(
//       body: Center(
//         child: SingleChildScrollView( // 画面全体をスクロール可能にする
//           child: Container(
//             width: _deviceWidth! * 0.8, // 画面幅の80%
//             height: _deviceHeight,
//             child: Column(
//               children: [
//                 Container(
//                   // Aゾーン
//                   width: _deviceWidth! * 0.8,
//                   height: _deviceHeight! * 0.35,
//                   color: Colors.white,
//                   child: Center(
//                     child: LayoutBuilder(
//                       builder: (context, constraints) {
//                         return Column(
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
//                               child: Text(
//                                 'マイページ',
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 10, // ゾーンの大きさに比例してテキストサイズを調整
//                                 ),
//                               ),
//                             ),
//                             Container(
//                               height: constraints.maxHeight * 0.5, // ゾーンの高さの50%
//                               width: constraints.maxHeight * 0.5, // ゾーンの高さの50%
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(6),
//                               ),
//                               child: Image.asset(
//                                 'assets/images/icon_sample.png',
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Text(
//                                 'ユーザー名：$_username', // Firestoreから取得したユーザー名を表示
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: constraints.maxHeight * 0.1, // ゾーンの大きさに比例してテキストサイズを調整
//                                 ),
//                               ),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.all(0.0),
//                               child: Text(
//                                 'アカウントタイプ：$_userrole', // Firestoreから取得したユーザー役割を表示
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: constraints.maxHeight * 0.1, // ゾーンの大きさに比例してテキストサイズを調整
//                                 ),
//                               ),
//                             )
//                           ],
//                         );
//                       },
//                     ),
//                   ),
//                 ),
//                 Container(
//                   // Bゾーン
//                   width: _deviceWidth! * 0.8,
//                   height: _deviceHeight! * 0.2,
//                   color: Colors.red.shade900,
//                   child: Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         const Text(
//                           '所持ポイント',
//                           style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 24,
//                               color: Colors.white),
//                         ),
//                         SizedBox(height: 10),
//                         const Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(
//                               '1000',
//                               style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 36,
//                                   color: Colors.white),
//                             ),
//                             Padding(
//                               padding: EdgeInsets.all(8.0),
//                               child: Text(
//                                 'P',
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 18,
//                                     color: Colors.white),
//                               ),
//                             )
//                           ],
//                         ),
//                         Container(
//                           alignment: Alignment.center,
//                           width: 400,
//                           height: 50,
//                           decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(50)),
//                           child: Text(
//                             '〇〇〇と交換する',
//                             style: TextStyle(
//                               fontSize: 24,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Container(
//                   // Cゾーン
//                   width: _deviceWidth! * 0.8,
//                   height: _deviceHeight! * 0.45,
//                   color: Colors.white,
//                   child: Scrollbar(
//                     child: ListView(
//                       itemExtent: 60, // 高さを適切に調整
//                       children: [
//                         Divider(),
//                         buildInkWell(context, 'アカウントの設定', Icons.navigate_next, 'アカウント'),
//                         Divider(),
//                         buildInkWell(context, 'ポイント履歴', Icons.navigate_next, 'ポイント履歴'),
//                         Divider(),
//                         buildInkWell(context, 'お知らせ', Icons.navigate_next, 'お知らせ'),
//                         Divider(),
//                         buildInkWell(context, 'その他機能', Icons.navigate_next, 'その他機能'),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildInkWell(BuildContext context, String title, IconData icon, String printText) {
//     print('関数が実行されました');
//     return InkWell(
//       onTap: () {
//         print('選択されたテキストは:$printText');
//       },
//       splashColor: Colors.amber, // タップ時のスプラッシュカラー
//       child: ListTile(
//         leading: Icon(icon),
//         title: Text(
//           title,
//           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
//         ),
//       ),
//     );
//   }
// }



// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class User_Info extends StatefulWidget {
//   const User_Info({super.key});

//   @override
//   State<User_Info> createState() => _User_InfoState();
// }

// class _User_InfoState extends State<User_Info> {
//   double? _deviceWidth, _deviceHeight;
//   String _username = 'Loading...'; // ユーザー名を表示するための変数
//   String _userrole = 'Loading...'; // ユーザー役割名を表示するための変数


//   @override
//   void initState() {
//     super.initState();
//     _fetchUsername();
//   }

//   Future<void> _fetchUsername() async {
//     try {
//       User? user = FirebaseAuth.instance.currentUser;
//       if (user != null) {
//         DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid ).get();
//         setState(() {
//           _username = userDoc['username'] ?? 'No username found'; // Firestoreからユーザー名を取得
//           _userrole = userDoc['role'] ?? 'No userrole found'; // Firestoreからユーザー役割を取得

//         });
//       }
//     } catch (e) {
//       print('エラーが発生しました: $e');
//       setState(() {
//         _username = 'Error fetching username';
//         _userrole = 'Error fetching userrole';
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // 画面の大きさを取得する
//     _deviceWidth = MediaQuery.of(context).size.width;
//     _deviceHeight = MediaQuery.of(context).size.height;

//     return Scaffold(
//       body: Center(
//         child: Column(
//           children: [
//             Stack(
//               alignment: Alignment.center,
//               children: [
//                 Container(
//                   width: _deviceWidth,
//                   height: _deviceHeight! * 0.35,
//                   color: Colors.white,
//                   child: Center(
//                     child: Column(
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
//                           child: Text(
//                             'マイページ',
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 24,
//                             ),
//                           ),
//                         ),
//                         Container(
//                           height: 180,
//                           width: 180,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(6),
//                           ),
//                           child: Image.asset(
//                             'assets/images/icon_sample.png',
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Text(
//                             _username, // Firestoreから取得したユーザー名を表示
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 24,
//                             ),
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Text(
//                             _userrole, // Firestoreから取得したユーザー役割を表示
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 24,
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             Stack(
//               alignment: Alignment.center,
//               children: [
//                 Container(
//                   width: _deviceWidth,
//                   height: _deviceHeight! * 0.2,
//                   color: Colors.red.shade900,
//                   child: Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         const Text(
//                           '所持ポイント',
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 24,
//                             color: Colors.white
//                           ),
//                         ),
//                         SizedBox(height: 10),
//                         const Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(
//                               '1000',
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 36,
//                                 color: Colors.white
//                               ),
//                             ),
//                             Padding(
//                               padding: EdgeInsets.all(8.0),
//                               child: Text(
//                                 'P',
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 18,
//                                   color: Colors.white
//                                 ),
//                               ),
//                             )
//                           ],
//                         ),
//                         Container(
//                           alignment: Alignment.center,
//                           width: 400,
//                           height: 50,
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(50)
//                           ),
//                           child: Text(
//                             '〇〇〇と交換する',
//                             style: TextStyle(
//                               fontSize: 24,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             Scrollbar(
//               child: Container(
//                 width: _deviceWidth,
//                 height: _deviceHeight! * 0.2,
//                 color: Colors.white,
//                 child: ListView(
//                   itemExtent: 30, // 高さを適切に調整
//                   children: [
//                     Divider(),
//                     buildInkWell(context, 'アカウントの設定', Icons.navigate_next, 'アカウント'),
//                     Divider(),
//                     buildInkWell(context, 'ポイント履歴', Icons.navigate_next, 'ポイント履歴'),
//                     Divider(),
//                     buildInkWell(context, 'お知らせ', Icons.navigate_next, 'お知らせ'),
//                     Divider(),
//                     buildInkWell(context, 'その他機能', Icons.navigate_next, 'その他機能'),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget buildInkWell(BuildContext context, String title, IconData icon, String printText) {
//     print('関数が実行されました');
//     return InkWell(
//       onTap: () {
//         print('選択されたテキストは:$printText');
//       },
//       splashColor: Colors.amber, // タップ時のスプラッシュカラー
//       child: ListTile(
//         leading: Icon(icon),
//         title: Text(
//           title,
//           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
//         ),
//       ),
//     );
//   }
// }


// // import 'package:flutter/material.dart';
// // import 'package:flutter/widgets.dart';

// // class User_Info extends StatefulWidget {
// //   const User_Info({super.key});

// //   @override
// //   State<User_Info> createState() => _User_InfoState();
// // }

// // class _User_InfoState extends State<User_Info> {
// //   double? _deviceWidth, _deviceHeight;

// //   @override
// //   Widget build(BuildContext context) {
// //     // 画面の大きさを取得する
// //     _deviceWidth = MediaQuery.of(context).size.width;
// //     _deviceHeight = MediaQuery.of(context).size.height;

// //     return Scaffold(
// //       body: Center(
// //         child: Column(
// //           children: [
// //             Stack(
// //               alignment: Alignment.center,
// //               children: [
// //                 Container(
// //                   width: _deviceWidth,
// //                   height: _deviceHeight! * 0.35,
// //                   color: Colors.white,
// //                   child: Center(
// //                     child: Column(
// //                       children: [
// //                         Padding(
// //                           padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
// //                           child: Text(
// //                             'マイページ',
// //                             style: TextStyle(
// //                               fontWeight: FontWeight.bold,
// //                               fontSize: 24,
// //                             ),
// //                           ),
// //                         ),
// //                         Container(
// //                           height: 180,
// //                           width: 180,
// //                           decoration: BoxDecoration(
// //                             borderRadius: BorderRadius.circular(6),
// //                           ),
// //                           child: Image.asset(
// //                             'assets/images/icon_sample.png',
// //                             fit: BoxFit.cover,
// //                           ),
// //                         ),
// //                         Padding(
// //                           padding: const EdgeInsets.all(8.0),
// //                           child: Text(
// //                             'ユーザー名', // ユーザーごとに変更する（変数管理）
// //                             style: TextStyle(
// //                               fontWeight: FontWeight.bold,
// //                               fontSize: 24,
// //                             ),
// //                           ),
// //                         )
// //                       ],
// //                     ),
// //                   ),
// //                 ),
// //               ]
// //             ),
// //             Stack(
// //               alignment: Alignment.center,
// //               children: [
// //                 Container(
// //                   width: _deviceWidth,
// //                   height: _deviceHeight! * 0.2,
// //                   color: Colors.red.shade900,
// //                   child: Center(
// //                     child: Column(
// //                       mainAxisAlignment: MainAxisAlignment.center,
// //                       children: [
// //                         const Text(
// //                           '所持ポイント',
// //                           style: TextStyle(
// //                             fontWeight: FontWeight.bold,
// //                             fontSize: 24,
// //                             color: Colors.white
// //                           ),
// //                         ),
// //                         SizedBox(height: 10),
// //                         const Row(
// //                           mainAxisAlignment: MainAxisAlignment.center,
// //                           children: [
// //                             Text(
// //                               '1000',
// //                               style: TextStyle(
// //                                 fontWeight: FontWeight.bold,
// //                                 fontSize: 36,
// //                                 color: Colors.white
// //                               ),
// //                             ),
// //                             Padding(
// //                               padding: EdgeInsets.all(8.0),
// //                               child: Text(
// //                                 'P',
// //                                 style: TextStyle(
// //                                   fontWeight: FontWeight.bold,
// //                                   fontSize: 18,
// //                                   color: Colors.white
// //                                 ),
// //                               ),
// //                             )
// //                           ],
// //                         ),
// //                         Container(
// //                           alignment: Alignment.center,
// //                           width: 400,
// //                           height: 50,
// //                           decoration: BoxDecoration(
// //                             color: Colors.white,
// //                             borderRadius: BorderRadius.circular(50)
// //                           ),
// //                           child: Text(
// //                             '〇〇〇と交換する',
// //                             style: TextStyle(
// //                               fontSize: 24,
// //                               fontWeight: FontWeight.bold,
// //                             ),
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //             Scrollbar(
// //               child: Container(
// //                 width: _deviceWidth,
// //                 height: _deviceHeight! * 0.3,
// //                 color: Colors.white,
// //                 child: ListView(
// //                   itemExtent: 60, // 高さを適切に調整
// //                   children: [
// //                     Divider(),
// //                     buildInkWell(context, 'アカウントの設定', Icons.navigate_next, 'アカウント'),
// //                     Divider(),
// //                     buildInkWell(context, 'ポイント履歴', Icons.navigate_next, 'ポイント履歴'),
// //                     Divider(),
// //                     buildInkWell(context, 'お知らせ', Icons.navigate_next, 'お知らせ'),
// //                     Divider(),
// //                     buildInkWell(context, 'その他機能', Icons.navigate_next, 'その他機能'),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget buildInkWell(BuildContext context, String title, IconData icon, String printText) {
// //     print('関数が実行されました');
// //     return InkWell(
// //       onTap: () {
// //         print('選択されたテキストは:$printText');
// //       },
// //       splashColor: Colors.amber, // タップ時のスプラッシュカラー
// //       child: ListTile(
// //         leading: Icon(icon),
// //         title: Text(
// //           title,
// //           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
// //         ),
// //       ),
// //     );
// //   }
// // }
