import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
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
                              '300',
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
                              '200',
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
                              '200',
                              style: TextStyle(
                                color: Colors.grey.shade100,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                            child: Text('コンペ'),
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
                    ),
                  ],
                ),
              ),
            ),
      floatingActionButton: SizedBox(
        width: 155,
        height: 105,
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
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:firebase_auth/firebase_auth.dart';
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
//           isBookmarked = data.map((item) => item['Isbookmarked'] as bool? ?? false).toList(); // null の場合 false に設定
//           isLoading = false;
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
//                               '300',
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
//                               '200',
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
//                               '200',
//                               style: TextStyle(
//                                 color: Colors.grey.shade100,
//                               ),
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
//                             child: Text('コンペ'),
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
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//       floatingActionButton: SizedBox(
//         width: 155,
//         height: 105,
//         child: FloatingActionButton.extended(
//           tooltip: 'Action!',
//           icon: Icon(Icons.add),
//           label: Text(
//             'アイデア投稿',
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//           onPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => form_page()),
//             );
//           },
//         ),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
//     );
//   }
// }


// // import 'package:flutter/material.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:yaonukabase004/src/Card/card2.dart';
// // import 'package:yaonukabase004/src/Navibar_src/form.dart';
// // import 'dart:convert';

// // class PageB extends StatefulWidget {
// //   const PageB({super.key});

// //   @override
// //   State<PageB> createState() => _PageBState();
// // }

// // class _PageBState extends State<PageB> {
// //   List<String> titles = [];
// //   List<String> genres = [];
// //   List<String> ideaContents = [];
// //   List<String> photoUrls = [];
// //   bool isLoading = true;
// //   List<int> colorNumbers = [];  //カラー取得
// //   List<int> ideaId = [];  //アイデアID取得
// //   List<int> numberoflikes = [];
// //   String userIds = '';
// //   List<bool> isBookmarked = [];  // ブックマークの状態取得

// //   @override
// //   void initState() {
// //     super.initState();
// //     _fetchUserId();
// //   }

// //   Future<void> _fetchUserId() async {
// //     final user = FirebaseAuth.instance.currentUser;
// //     if (user != null) {
// //       setState(() {
// //         userIds = user.uid;
// //       });
// //       _fetchIdeaData(user.uid);
// //     } else {
// //       print('User is not logged in.');
// //       setState(() {
// //         isLoading = false;
// //       });
// //     }
// //   }

// //   Future<void> _fetchIdeaData(String userId) async {
// //     final url = 'https://getideas.azurewebsites.net/api/get_ideas?userid=$userId';
// //     try {
// //       final response = await http.get(
// //         Uri.parse(url),
// //         headers: {'Content-Type': 'application/json'},
// //       );

// //       if (response.statusCode == 201) {
// //         final Map<String, dynamic> responseData = json.decode(response.body);
// //         final List<dynamic> data = responseData['data'];
        
// //         // 取得したデータをコンソールに表示
// //         print('取得したデータ: $responseData');
        
// //         setState(() {
// //           titles = data.map((item) => item['ideaname'].toString()).toList();
// //           genres = data.map((item) => item['ideatechnology1'].toString()).toList(); // 例として技術1をジャンルとしています
// //           ideaContents = data.map((item) => item['ideaconcept'].toString()).toList();
// //           photoUrls = List.generate(data.length, (index) => 'assets/images/veg${index % 10 + 1}.png');
// //           isLoading = false;
// //           colorNumbers = data.map((item) => item['ideacolornumber'] as int).toList(); //カラー取得
// //           ideaId = data.map((item) => item['id'] as int).toList(); //IDの取得
// //           numberoflikes = data.map((item) => item['numberoflikes'] as int).toList();
// //           isBookmarked = data.map((item) => item['Isbookmarked'] as bool).toList();
// //         });

// //       } else {
// //         throw Exception('Failed to load data');
// //       }
// //     } catch (e) {
// //       print('エラーが発生しました: $e');
// //       setState(() {
// //         isLoading = false;
// //       });
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: isLoading
// //           ? Center(child: CircularProgressIndicator())
// //           : SingleChildScrollView(
// //               scrollDirection: Axis.vertical,
// //               child: ConstrainedBox(
// //                 constraints: BoxConstraints(
// //                   minHeight: MediaQuery.of(context).size.height,
// //                 ),
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     Container(
// //                       color: Colors.grey.shade50,
// //                       width: double.infinity,
// //                       height: 50,
// //                       child: Row(
// //                         mainAxisAlignment: MainAxisAlignment.center,
// //                         children: [
// //                           Container(
// //                             padding: EdgeInsets.symmetric(horizontal: 8),
// //                             color: Colors.grey.shade700,
// //                             child: Text(
// //                               '300',
// //                               style: TextStyle(
// //                                 color: Colors.grey.shade100,
// //                               ),
// //                             ),
// //                           ),
// //                           Padding(
// //                             padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
// //                             child: Text('ALL'),
// //                           ),
// //                           Container(
// //                             padding: EdgeInsets.symmetric(horizontal: 8),
// //                             color: Colors.lightBlue.shade800,
// //                             child: Text(
// //                               '200',
// //                               style: TextStyle(
// //                                 color: Colors.grey.shade100,
// //                               ),
// //                             ),
// //                           ),
// //                           Padding(
// //                             padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
// //                             child: Text('アイデア'),
// //                           ),
// //                           Container(
// //                             padding: EdgeInsets.symmetric(horizontal: 8),
// //                             color: Colors.red.shade800,
// //                             child: Text(
// //                               '200',
// //                               style: TextStyle(
// //                                 color: Colors.grey.shade100,
// //                               ),
// //                             ),
// //                           ),
// //                           Padding(
// //                             padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
// //                             child: Text('コンペ'),
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //                     HorizontalCardLists(
// //                       titles: titles,
// //                       colorNumbers: colorNumbers,
// //                       ideaId: ideaId,
// //                       likeNum: numberoflikes,
// //                       isBookmarked: isBookmarked,
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //       floatingActionButton: SizedBox(
// //         width: 155,
// //         height: 105,
// //         child: FloatingActionButton.extended(
// //           tooltip: 'Action!',
// //           icon: Icon(Icons.add),
// //           label: Text(
// //             'アイデア投稿',
// //             style: TextStyle(fontWeight: FontWeight.bold),
// //           ),
// //           onPressed: () {
// //             Navigator.push(
// //               context,
// //               MaterialPageRoute(builder: (context) => form_page()),
// //             );
// //           },
// //         ),
// //       ),
// //       floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
// //     );
// //   }
// // }



// // // import 'package:flutter/material.dart';
// // // import 'package:http/http.dart' as http;
// // // import 'package:yaonukabase004/src/Card/card2.dart';
// // // import 'package:yaonukabase004/src/Navibar_src/form.dart';
// // // import 'dart:convert';

// // // class PageB extends StatefulWidget {
// // //   const PageB({super.key});

// // //   @override
// // //   State<PageB> createState() => _PageBState();
// // // }

// // // class _PageBState extends State<PageB> {
// // //   List<String> titles = [];
// // //   List<String> genres = [];
// // //   List<String> ideaContents = [];
// // //   List<String> photoUrls = [];
// // //   bool isLoading = true;
// // //   List<int> colorNumbers = [];  //カラー取得
// // //   List<int> ideaId= [];  //アイデアID取得
// // //   List<int> numberoflikes =[];
// // //   String userIds = '';


// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _fetchIdeaData();
// // //   }

// // //   Future<void> _fetchIdeaData() async {
// // //     // const url = 'https://getideas.azurewebsites.net/api/get_ideas';
// // //     const url = 'https://getideas.azurewebsites.net/api/get_ideas'; //UIDパラメータ追加
// // //     try {
// // //       final response = await http.get(
// // //         Uri.parse(url),
// // //         headers: {'Content-Type': 'application/json'},
// // //       );

// // //       if (response.statusCode == 201) {
// // //         final Map<String, dynamic> responseData = json.decode(response.body);
// // //         final List<dynamic> data = responseData['data'];
        
// // //          setState(() {
// // //           titles = data.map((item) => item['ideaname'].toString()).toList();
// // //           genres = data.map((item) => item['ideatechnology1'].toString()).toList(); // 例として技術1をジャンルとしています
// // //           ideaContents = data.map((item) => item['ideaconcept'].toString()).toList();
// // //           photoUrls = List.generate(data.length, (index) => 'assets/images/veg${index % 10 + 1}.png');
// // //           isLoading = false;
// // //           colorNumbers = data.map((item) => item['ideacolornumber'] as int).toList(); //カラー取得
// // //           ideaId = data.map((item) => item['id'] as int).toList(); //IDの取得
// // //           numberoflikes = data.map((item) => item['numberoflikes'] as int).toList();
// // //         });
// // //         // setState(() {
// // //         //   titles = data.map((item) => item['ideaname'] as String).toList();
// // //         //   genres = data.map((item) => item['ideatechnology1'] as String).toList(); // 例として技術1をジャンルとしています
// // //         //   ideaContents = data.map((item) => item['ideaconcept'] as String).toList();
// // //         //   photoUrls = List.generate(data.length, (index) => 'assets/images/veg${index % 10 + 1}.png');
// // //         //   isLoading = false;
// // //         // });

// // //         print('取得したデータ: $responseData');
// // //       } else {
// // //         throw Exception('Failed to load data');
// // //       }
// // //     } catch (e) {
// // //       print('エラーが発生しました: $e');
// // //       setState(() {
// // //         isLoading = false;
// // //       });
// // //     }
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       body: isLoading
// // //           ? Center(child: CircularProgressIndicator())
// // //           : SingleChildScrollView(
// // //               scrollDirection: Axis.vertical,
// // //               child: ConstrainedBox(
// // //                 constraints: BoxConstraints(
// // //                   minHeight: MediaQuery.of(context).size.height,
// // //                 ),
// // //                 child: Column(
// // //                   crossAxisAlignment: CrossAxisAlignment.start,
// // //                   children: [
// // //                     Container(
// // //                       color: Colors.grey.shade50,
// // //                       width: double.infinity,
// // //                       height: 50,
// // //                       child: Row(
// // //                         mainAxisAlignment: MainAxisAlignment.center,
// // //                         children: [
// // //                           Container(
// // //                             padding: EdgeInsets.symmetric(horizontal: 8),
// // //                             color: Colors.grey.shade700,
// // //                             child: Text(
// // //                               '300',
// // //                               style: TextStyle(
// // //                                 color: Colors.grey.shade100,
// // //                               ),
// // //                             ),
// // //                           ),
// // //                           Padding(
// // //                             padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
// // //                             child: Text('ALL'),
// // //                           ),
// // //                           Container(
// // //                             padding: EdgeInsets.symmetric(horizontal: 8),
// // //                             color: Colors.lightBlue.shade800,
// // //                             child: Text(
// // //                               '200',
// // //                               style: TextStyle(
// // //                                 color: Colors.grey.shade100,
// // //                               ),
// // //                             ),
// // //                           ),
// // //                           Padding(
// // //                             padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
// // //                             child: Text('アイデア'),
// // //                           ),
// // //                           Container(
// // //                             padding: EdgeInsets.symmetric(horizontal: 8),
// // //                             color: Colors.red.shade800,
// // //                             child: Text(
// // //                               '200',
// // //                               style: TextStyle(
// // //                                 color: Colors.grey.shade100,
// // //                               ),
// // //                             ),
// // //                           ),
// // //                           Padding(
// // //                             padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
// // //                             child: Text('コンペ'),
// // //                           ),
// // //                         ],
// // //                       ),
// // //                     ),
// // //                     HorizontalCardLists(
// // //                       titles: titles,
// // //                       colorNumbers :colorNumbers,
// // //                       ideaId :ideaId,
// // //                       // numberoflikes : likeNum,
// // //                       likeNum : numberoflikes,
// // //                       // userId: userIds,
// // //                     ),
// // //                   ],
// // //                 ),
// // //               ),
// // //             ),
// // //       floatingActionButton: SizedBox(
// // //         width: 155,
// // //         height: 105,
// // //         child: FloatingActionButton.extended(
// // //           tooltip: 'Action!',
// // //           icon: Icon(Icons.add),
// // //           label: Text(
// // //             'アイデア投稿',
// // //             style: TextStyle(fontWeight: FontWeight.bold),
// // //           ),
// // //           onPressed: () {
// // //             Navigator.push(
// // //               context,
// // //               MaterialPageRoute(builder: (context) => form_page()),
// // //             );
// // //           },
// // //         ),
// // //       ),
// // //       floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
// // //     );
// // //   }
// // // }


