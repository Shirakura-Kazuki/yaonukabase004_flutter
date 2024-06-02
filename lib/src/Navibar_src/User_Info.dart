
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yaonukabase004/providers/user_provider.dart';

class User_Info extends StatefulWidget {
  const User_Info({super.key});

  @override
  State<User_Info> createState() => _User_InfoState();
}

class _User_InfoState extends State<User_Info> {
  double? _deviceWidth, _deviceHeight;
  String? yasai_n;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    await Provider.of<UserProvider>(context, listen: false).fetchUserData();
    setState(() {
      yasai_n = Provider.of<UserProvider>(context, listen: false).user?.username;
      print('新たに取得した値は：$yasai_nです');
    });
  }

  @override
  Widget build(BuildContext context) {
    _deviceWidth = MediaQuery.of(context).size.width;
    _deviceHeight = MediaQuery.of(context).size.height;

    final user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: _deviceWidth! * 0.8,
            height: _deviceHeight,
            child: Column(
              children: [
                Container(
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
                                'ユーザー名：${user?.username ?? 'Loading...'}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: constraints.maxHeight * 0.03,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: Text(
                                'アカウントタイプ：${user?.usertype ?? 'Loading...'}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: constraints.maxHeight * 0.03,
                                ),
                              ),
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.all(8.0),
                            //   child: Text(
                            //     'プロフィール：${user?.profile ?? 'Loading...'}',
                            //     style: TextStyle(
                            //       fontWeight: FontWeight.bold,
                            //       fontSize: constraints.maxHeight * 0.03,
                            //     ),
                            //   ),
                            // ),
                            // Padding(
                            //   padding: const EdgeInsets.all(8.0),
                            //   child: Text(
                            //     '会社名：${user?.companyname ?? 'Loading...'}',
                            //     style: TextStyle(
                            //       fontWeight: FontWeight.bold,
                            //       fontSize: constraints.maxHeight * 0.03,
                            //     ),
                            //   ),
                            // ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                Container(
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
                        Text(
                          '${user?.numberofpoints ?? 0} P',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 36,
                            color: Colors.white,
                          ),
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
// import 'package:provider/provider.dart';
// import 'package:yaonukabase004/providers/user_provider.dart';

// class User_Info extends StatefulWidget {
//   const User_Info({super.key});

//   @override
//   State<User_Info> createState() => _User_InfoState();
// }

// class _User_InfoState extends State<User_Info> {
//   double? _deviceWidth, _deviceHeight;
//   String? yasai_n;

//   @override
//   void initState() {
//     super.initState();
//     _fetchUserData();
//   }

//   Future<void> _fetchUserData() async {
//     await Provider.of<UserProvider>(context, listen: false).fetchUserData();
//     setState(() {
//       yasai_n = Provider.of<UserProvider>(context, listen: false).user?.username;
//       print('新たに取得した値は：$yasai_nです');
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     _deviceWidth = MediaQuery.of(context).size.width;
//     _deviceHeight = MediaQuery.of(context).size.height;

//     final user = Provider.of<UserProvider>(context).user;

//     return Scaffold(
//       body: Center(
//         child: SingleChildScrollView(
//           child: Container(
//             width: _deviceWidth! * 0.8,
//             height: _deviceHeight,
//             child: Column(
//               children: [
//                 Container(
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
//                                   fontSize: 10,
//                                 ),
//                               ),
//                             ),
//                             Container(
//                               height: constraints.maxHeight * 0.5,
//                               width: constraints.maxHeight * 0.5,
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
//                                 'ユーザー名：${user?.username ?? 'Loading...'}',
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: constraints.maxHeight * 0.1,
//                                 ),
//                               ),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.all(0.0),
//                               child: Text(
//                                 'アカウントタイプ：${user?.usertype ?? 'Loading...'}',
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: constraints.maxHeight * 0.09,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         );
//                       },
//                     ),
//                   ),
//                 ),
//                 Container(
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
//                         Text(
//                           '${user?.numberofpoints ?? 0} P',
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 36,
//                             color: Colors.white,
//                           ),
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
//                   width: _deviceWidth! * 0.8,
//                   height: _deviceHeight! * 0.45,
//                   color: Colors.white,
//                   child: Scrollbar(
//                     child: ListView(
//                       itemExtent: 60,
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
//     return InkWell(
//       onTap: () {
//         print('選択されたテキストは:$printText');
//       },
//       splashColor: Colors.amber,
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
