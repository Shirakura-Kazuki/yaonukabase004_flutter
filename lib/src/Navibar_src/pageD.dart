import 'package:flutter/material.dart';
import 'package:yaonukabase004/src/Card/inCard.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';

class PageD extends StatefulWidget {
  @override
  State<PageD> createState() => _PageDState();
}

class _PageDState extends State<PageD> {
  List<String> titles = [];
  List<String> genres = [];
  List<String> ideaContents = [];
  List<String> photoUrls = [];
  bool isLoading = true;
  List<int> colorNumbers = [];  // カラー取得
  List<int> ideaId = [];  // アイデアID取得
  List<int> numberoflikes = [];
  String userIds = '';
  List<bool> isBookmarked = [];  // ブックマークの状態取得
  List<String> concept = [];
  // テクノロジーと日時の取得用
  List<String> Tec1 = [];
  List<String> Tec2 = [];
  List<String> Tec3 = [];
  List<String> ideadate = [];

  @override
  void initState() {
    super.initState();
    _fetchUserId();
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
    // final url = 'https://getideas.azurewebsites.net/api/get_ideas?userid=$userId';
    final url = 'https://get-bookmarks.azurewebsites.net/api/get_bookmarks?userid=$userId';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {  // ステータスコードを200に修正
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> data = responseData['data'];

        // 取得したデータをコンソールに表示
        print('取得したデータ: $responseData');

        setState(() {
          titles = data.map((item) => item['ideaname'].toString()).toList();
          genres = data.map((item) => item['ideatechnology1'].toString()).toList(); // 例として技術1をジャンルとしています
          ideaContents = data.map((item) => item['ideaconcept'].toString()).toList();
          photoUrls = List.generate(data.length, (index) => 'assets/images/veg${index % 10 + 1}.png');
          colorNumbers = data.map((item) => item['ideacolornumber'] as int).toList(); // カラー取得
          ideaId = data.map((item) => item['id'] as int).toList(); // IDの取得
          numberoflikes = data.map((item) => item['numberoflikes'] as int).toList();
          isBookmarked = data.map((item) => item['IsBookmarked'] as bool? ?? false).toList(); // null の場合 false に設定
          concept = data.map((item) => item['ideaconcept'].toString()).toList();
          Tec1 = data.map((item) => item['ideatechnology1'].toString()).toList();
          Tec2 = data.map((item) => item['ideatechnology2'].toString()).toList();
          Tec3 = data.map((item) => item['ideatechnology3'].toString()).toList();
          ideadate = data.map((item) => item['ideadate'].toString()).toList();
          isLoading = false;
        });
      } else {
        // 詳細なエラーメッセージをログに出力
        print('Failed to load data. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
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
    // 画面描画
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(  // 画面より大きい場合スクロールする
              scrollDirection: Axis.vertical, // 垂直方向にスクロール
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 5, 0, 0),
                      child: SizedBox(
                        width: 500,
                        child: TextField(
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.search),
                            suffixIcon: IconButton(
                              icon: const Icon(
                                Icons.sort,
                                size: 32,
                              ),
                              onPressed: () {},
                            ),
                            hintText: '検索',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32),
                            ),
                          ),
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.search,
                          onChanged: (value) {},
                          onSubmitted: (value) {},
                        ),
                      ),
                    ),
                    const Divider(
                      height: 40,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 0, 5),
                      child: Text(
                        'MyNUKAリスト',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    HorizonCustomCardList(
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
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:yaonukabase004/src/Card/card1.dart';
// import 'package:yaonukabase004/src/Card/inCard.dart';
// // 追加0608
// import 'package:http/http.dart' as http;
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:yaonukabase004/src/Navibar_src/form.dart';
// import 'dart:convert';

// class page_d extends StatefulWidget {
//   @override
//   State<page_d> createState() => _page_dState();
// }

// class _page_dState extends State<page_d> {
//   // 0608追加
// List<String> titles = [];
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

//   @override
//   void initState() {
//     super.initState();
//     _fetchUserId();
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



//   // 
//   @override
//   Widget build(BuildContext context) {
//     // 画面描画
//     return Scaffold(  
//       body: SingleChildScrollView(  //画面より大きい場合スクロールする
//         scrollDirection: Axis.vertical, //垂直方向にスクロール
//         child: ConstrainedBox(
//           constraints: BoxConstraints(
//             minHeight: MediaQuery.of(context).size.height,
//           ),
//           child: //Center(
//             Column(
//             //child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(10, 5, 0, 0),
//                   child: SizedBox(
//                     width: 500,
//                     child: TextField(
//                     decoration: InputDecoration(
//                     prefixIcon: const Icon(Icons.search),
//                     suffixIcon: IconButton(
//                       icon: const Icon(
//                         Icons.sort,
//                         size: 32,
//                       ),
//                       onPressed: () {},
//                     ),
//                     hintText: '検索',
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(32),
//                     ),
//                   ),
//                   keyboardType: TextInputType.text,
//                   textInputAction: TextInputAction.search,
//                   onChanged: (value) {},
//                   onSubmitted: (value) {},
//                   ),
//                   ),
//                 ),
                
//                 // Padding(
//                 //   padding: const EdgeInsets.fromLTRB(25, 10, 0, 0),
//                 //   child: Text('【検索項目】',
//                 //     style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),
//                 //   ),),
//                   const Divider(
//                     height: 40,
//                   ),
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(15, 0, 0, 5),
//                   child: Text('MyNUKAリスト',
//                     style: TextStyle(fontSize: 20),
//                   ),
//                 ),
//                 HorizontalCardListSKV(
//                   titles: List.generate(10, (index) => 'ユーザー名 $index'),
//                 ),
//                 HorizonCustomCardList(
//                   titles: titles,
//                   colorNumbers: colorNumbers,
//                   ideaId: ideaId,
//                   likeNum: numberoflikes,
//                   isBookmarked: isBookmarked,
//                   Concepts: concept,
//                   tec1: Tec1,
//                   tec2: Tec2,
//                   tec3: Tec3,
//                   ideaDate: ideadate
//                 )
//               ],
//             ),
//           //),
//         ),
//       ),
//     );
//   }
// }