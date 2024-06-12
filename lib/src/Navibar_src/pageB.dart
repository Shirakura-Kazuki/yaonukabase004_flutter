import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:yaonukabase004/cordinetar1.dart';
import 'package:yaonukabase004/providers/user_provider.dart';
import 'package:yaonukabase004/src/Card/card2.dart';
import 'package:yaonukabase004/src/Navibar_src/form.dart';
import 'dart:convert';

class PageB extends StatefulWidget {
  const PageB({super.key});

  @override
  State<PageB> createState() => _PageBState();
}

class _PageBState extends State<PageB> {
  List<String> titles = [];
  List<String> genres = [];
  List<String> ideaContents = [];
  List<String> photoUrls = [];
  bool isLoading = true;
  List<int> colorNumbers = [];  //カラー取得
  List<int> ideaId = [];  //アイデアID取得
  List<int> numberoflikes = [];
  String userIds = '';
  List<bool> isBookmarked = [];  // ブックマークの状態取得
  List<String> concept = [];
  // テクノロジーと日時の取得用
  List<String> Tec1 = [];
  List<String> Tec2 = [];
  List<String> Tec3 = [];
  List<String> ideadate = [];

  String? roll ; // アクションボタンroll管理

  int ideaCount = 0;
  int techCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchUserId();
    _fetchUserType();
  }

  Future<void> _fetchUserType()async{
    await Provider.of<UserProvider>(context, listen: false).fetchUserData();
    if (mounted) { // ここでmountedをチェックする
      setState(() {
        roll = Provider.of<UserProvider>(context, listen: false).user?.usertype;
        print('新たに取得した値は：$rollです');
      });
    }
  }

  Future<void> _fetchUserId() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userIds = user.uid;
      });
      await _fetchIdeaData(user.uid);
    } else {
      print('User is not logged in.');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _fetchIdeaData(String userId) async {
    final url = 'https://getideas.azurewebsites.net/api/get_ideas?userid=$userId';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> data = responseData['data'];

        // 取得したデータをコンソールに表示
        print('取得したデータ: $responseData');

        setState(() {
          titles = data.map((item) => item['ideaname'].toString()).toList();
          genres = data.map((item) => item['ideatechnology1'].toString()).toList(); // 例として技術1をジャンルとしています
          ideaContents = data.map((item) => item['ideaconcept'].toString()).toList();
          photoUrls = List.generate(data.length, (index) => 'assets/images/veg${index % 10 + 1}.png');
          colorNumbers = data.map((item) => item['ideacolornumber'] as int).toList(); //カラー取得
          ideaId = data.map((item) => item['id'] as int).toList(); //IDの取得
          numberoflikes = data.map((item) => item['numberoflikes'] as int).toList();
          isBookmarked = data.map((item) => item['IsBookmarked'] as bool? ?? false).toList(); // null の場合 false に設定
          isLoading = false;
          concept = data.map((item) => item['ideaconcept'].toString()).toList();
          Tec1 = data.map((item) => item['ideatechnology1'].toString()).toList();
          Tec2 = data.map((item) => item['ideatechnology2'].toString()).toList();
          Tec3 = data.map((item) => item['ideatechnology3'].toString()).toList();
          ideadate = data.map((item) => item['ideadate'].toString()).toList();

          // ideacolornumberのカウント
          ideaCount = colorNumbers.where((number) => number == 0).length;
          techCount = colorNumbers.where((number) => number == 1).length;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('エラーが発生しました: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: Colors.grey.shade50,
                      width: double.infinity,
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            color: Colors.grey.shade700,
                            child: Text(
                              '20',
                              style: TextStyle(
                                color: Colors.grey.shade100,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                            child: Text('ALL'),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            color: Colors.lightBlue.shade800,
                            child: Text(
                              '$ideaCount',
                              style: TextStyle(
                                color: Colors.grey.shade100,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                            child: Text('アイデア'),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            color: Colors.red.shade800,
                            child: Text(
                              '$techCount',
                              style: TextStyle(
                                color: Colors.grey.shade100,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                            child: Text('企業技術'),
                          ),
                        ],
                      ),
                    ),
                    HorizontalCardLists(
                      titles: titles,
                      colorNumbers: colorNumbers,
                      ideaId: ideaId,
                      likeNum: numberoflikes,
                      isBookmarked: isBookmarked,
                      Concepts: concept,
                      tec1: Tec1,
                      tec2: Tec2,
                      tec3: Tec3,
                      ideaDate: ideadate,
                    ),
                  ],
                ),
              ),
            ),
      floatingActionButton: Stack(
        children: [
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton.extended(
              tooltip: 'Action!',
              icon: Icon(Icons.add),
              label: Text(
                'アイデア投稿',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => form_page()),
                );
              },
              backgroundColor: Colors.red.shade400, // 背景色を紫に変更
              foregroundColor: Colors.white, // 前景色を白に変更
              elevation: 10, // 影の強さを増加
              heroTag: null, // Heroアニメーションを無効化（必要に応じて）
            ),
          ),
          if (roll == 'Coordinator')
            Positioned(
            bottom: 86,  
            right: 16,
            child: FloatingActionButton.extended(
              tooltip: 'Second Action!',
              icon: Icon(Icons.lightbulb), // AIのようなマークに変更
              label: Text(
                'AIコーディネータページへ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CordinatorScreen()),
                );
              },
              backgroundColor: Colors.purple, // 背景色を紫に変更
              foregroundColor: Colors.white, // 前景色を白に変更
              elevation: 10, // 影の強さを増加
              heroTag: null, // Heroアニメーションを無効化（必要に応じて）
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:provider/provider.dart';
// import 'package:yaonukabase004/cordinetar1.dart';
// import 'package:yaonukabase004/providers/user_provider.dart';
// import 'package:yaonukabase004/src/Card/card2.dart';
// import 'package:yaonukabase004/src/Navibar_src/form.dart';
// import 'dart:convert';

// class PageB extends StatefulWidget {
//   const PageB({super.key});

//   @override
//   State<PageB> createState() => _PageBState();
// }

// class _PageBState extends State<PageB> {
//   List<String> titles = [];
//   List<String> genres = [];
//   List<String> ideaContents = [];
//   List<String> photoUrls = [];
//   bool isLoading = true;
//   List<int> colorNumbers = [];  //カラー取得
//   List<int> ideaId = [];  //アイデアID取得
//   List<int> numberoflikes = [];
//   String userIds = '';
//   List<bool> isBookmarked = [];  // ブックマークの状態取得
//   List<String> concept = [];
//   // テクノロジーと日時の取得用
//   List<String> Tec1 = [];
//   List<String> Tec2 = [];
//   List<String> Tec3 = [];
//   List<String> ideadate = [];

//   String? roll ; // アクションボタンroll管理


//   @override
//   void initState() {
//     super.initState();
//     _fetchUserId();
//     _fetchUserType();
//   }

//   Future<void> _fetchUserType()async{
//     await Provider.of<UserProvider>(context, listen: false).fetchUserData();
//     if (mounted) { // ここでmountedをチェックする
//       setState(() {
//         roll = Provider.of<UserProvider>(context, listen: false).user?.usertype;
//         print('新たに取得した値は：$rollです');
//       });
//     }
//   }

//   Future<void> _fetchUserId() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       setState(() {
//         userIds = user.uid;
//       });
//       await _fetchIdeaData(user.uid);
//     } else {
//       print('User is not logged in.');
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   Future<void> _fetchIdeaData(String userId) async {
//     final url = 'https://getideas.azurewebsites.net/api/get_ideas?userid=$userId';
//     try {
//       final response = await http.get(
//         Uri.parse(url),
//         headers: {'Content-Type': 'application/json'},
//       );

//       if (response.statusCode == 201) {
//         final Map<String, dynamic> responseData = json.decode(response.body);
//         final List<dynamic> data = responseData['data'];

//         // 取得したデータをコンソールに表示
//         print('取得したデータ: $responseData');

//         setState(() {
//           titles = data.map((item) => item['ideaname'].toString()).toList();
//           genres = data.map((item) => item['ideatechnology1'].toString()).toList(); // 例として技術1をジャンルとしています
//           ideaContents = data.map((item) => item['ideaconcept'].toString()).toList();
//           photoUrls = List.generate(data.length, (index) => 'assets/images/veg${index % 10 + 1}.png');
//           colorNumbers = data.map((item) => item['ideacolornumber'] as int).toList(); //カラー取得
//           ideaId = data.map((item) => item['id'] as int).toList(); //IDの取得
//           numberoflikes = data.map((item) => item['numberoflikes'] as int).toList();
//           isBookmarked = data.map((item) => item['IsBookmarked'] as bool? ?? false).toList(); // null の場合 false に設定
//           isLoading = false;
//           concept = data.map((item) => item['ideaconcept'].toString()).toList();
//           Tec1 = data.map((item) => item['ideatechnology1'].toString()).toList();
//           Tec2 = data.map((item) => item['ideatechnology2'].toString()).toList();
//           Tec3 = data.map((item) => item['ideatechnology3'].toString()).toList();
//           ideadate = data.map((item) => item['ideadate'].toString()).toList();
//         });
//       } else {
//         throw Exception('Failed to load data');
//       }
//     } catch (e) {
//       print('エラーが発生しました: $e');
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: isLoading
//           ? Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//               scrollDirection: Axis.vertical,
//               child: ConstrainedBox(
//                 constraints: BoxConstraints(
//                   minHeight: MediaQuery.of(context).size.height,
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Container(
//                       color: Colors.grey.shade50,
//                       width: double.infinity,
//                       height: 50,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Container(
//                             padding: EdgeInsets.symmetric(horizontal: 8),
//                             color: Colors.grey.shade700,
//                             child: Text(
//                               '20',
//                               style: TextStyle(
//                                 color: Colors.grey.shade100,
//                               ),
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
//                             child: Text('ALL'),
//                           ),
//                           Container(
//                             padding: EdgeInsets.symmetric(horizontal: 8),
//                             color: Colors.lightBlue.shade800,
//                             child: Text(
//                               '17',
//                               style: TextStyle(
//                                 color: Colors.grey.shade100,
//                               ),
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
//                             child: Text('アイデア'),
//                           ),
//                           Container(
//                             padding: EdgeInsets.symmetric(horizontal: 8),
//                             color: Colors.red.shade800,
//                             child: Text(
//                               '3',
//                               style: TextStyle(
//                                 color: Colors.grey.shade100,
//                               ),
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
//                             child: Text('企業技術'),
//                           ),
//                         ],
//                       ),
//                     ),
//                     HorizontalCardLists(
//                       titles: titles,
//                       colorNumbers: colorNumbers,
//                       ideaId: ideaId,
//                       likeNum: numberoflikes,
//                       isBookmarked: isBookmarked,
//                       Concepts: concept,
//                       tec1: Tec1,
//                       tec2: Tec2,
//                       tec3: Tec3,
//                       ideaDate: ideadate,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//       floatingActionButton: Stack(
//         children: [
//           Positioned(
//             bottom: 16,
//             right: 16,
//             child: FloatingActionButton.extended(
//               tooltip: 'Action!',
//               icon: Icon(Icons.add),
//               label: Text(
//                 'アイデア投稿',
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => form_page()),
//                 );
//               },
//               backgroundColor: Colors.red.shade400, // 背景色を紫に変更
//               foregroundColor: Colors.white, // 前景色を白に変更
//               elevation: 10, // 影の強さを増加
//               heroTag: null, // Heroアニメーションを無効化（必要に応じて）
//             ),
//           ),
//           if (roll == 'Coordinator')
//             Positioned(
//             bottom: 86,  
//             right: 16,
//             child: FloatingActionButton.extended(
//               tooltip: 'Second Action!',
//               icon: Icon(Icons.lightbulb), // AIのようなマークに変更
//               label: Text(
//                 'AIコーディネータページへ',
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => CordinatorScreen()),
//                 );
//               },
//               backgroundColor: Colors.purple, // 背景色を紫に変更
//               foregroundColor: Colors.white, // 前景色を白に変更
//               elevation: 10, // 影の強さを増加
//               heroTag: null, // Heroアニメーションを無効化（必要に応じて）
//             ),
//           ),
//         ],
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
//     );
//   }
// }


