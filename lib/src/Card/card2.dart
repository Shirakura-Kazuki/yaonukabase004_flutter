
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';

class HorizontalCardLists extends StatefulWidget {
  final List<String> titles;
  final List<int> colorNumbers;
  final List<int> ideaId;
  final List<int> likeNum;
  final List<bool> isBookmarked;

  const HorizontalCardLists({
    Key? key,
    required this.titles,
    required this.colorNumbers,
    required this.ideaId,
    required this.likeNum,
    required this.isBookmarked,
  }) : super(key: key);

  @override
  _HorizontalCardListsState createState() => _HorizontalCardListsState();
}

class _HorizontalCardListsState extends State<HorizontalCardLists> {
  late final ScrollController titleController;
  late List<int> likes;
  late List<int> tapCounts;
  late List<int> tapNum;
  late List<String> imgPaths;
  late List<bool> bookmarks;
  String userId = '';

  @override
  void initState() {
    super.initState();
    titleController = ScrollController();
    likes = List.generate(widget.likeNum.length, (index) => widget.likeNum[index]);
    tapCounts = List.generate(widget.titles.length, (index) => 0);
    tapNum = List.generate(widget.titles.length, (index) => 0);
    bookmarks = List.from(widget.isBookmarked);
    imgPaths = List.generate(widget.titles.length, (index) => 
      bookmarks[index] ? 'assets/images/mynukaadd.png' : 'assets/images/notmynuka.png'
    );
    _setCurrentUserUid(); // 追加：初期化時にUIDを設定
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  Future<void> _setCurrentUserUid() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userId = user.uid;
      });
      print('現在のユーザーのUID: ${user.uid}');
    } else {
      print('ユーザーはログインしていません。');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    double cardWidth = screenWidth / (screenWidth ~/ 200);
    cardWidth = cardWidth < 200 ? 380 : cardWidth;
    cardWidth = cardWidth > 400 ? 400 : cardWidth;
    final cardHeight = 320.0;

    return Container(
      height: MediaQuery.of(context).size.height,
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: screenWidth ~/ cardWidth,
          childAspectRatio: cardWidth / cardHeight,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: widget.titles.length,
        itemBuilder: (context, index) {
          return buildCard(widget.titles[index], cardWidth, index, widget.colorNumbers[index], widget.ideaId[index], widget.likeNum[index]);
        },
      ),
    );
  }

  Widget buildCard(String title, double width, int index, int colorNumber, int ideaId, int likeNum) {
    Color borderColor = (colorNumber == 0) ? Colors.blue : Colors.red;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
        side: BorderSide(color: borderColor, width: 3.0),
      ),
      elevation: 5,
      child: Container(
        color: Colors.white,
        width: width,
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('No.$ideaId'),
            Icon(Icons.account_circle, size: 50, color: borderColor),
            SizedBox(height: 10),
            Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                width: 85,
                height: 85,
                decoration: BoxDecoration(
                  border: Border.all(color: borderColor, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(child: Text('写真')),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () async {
                    setState(() {
                      likes[index] = likes[index] == likeNum ? likeNum + 1 : likeNum;
                      tapCounts[index]++;
                    });
                    final likeStatus = likes[index];
                    final tapCount = tapCounts[index];
                    print('アイデアID: $ideaId, Like Status: $likeStatus , Tap Count: $tapCount');
                    if (tapCount % 2 == 0) {
                      print('いいねの取り消し');
                      await downdateLikeStatus(ideaId, likeStatus);
                    } else {
                      print('いいねの追加');
                      await updateLikeStatus(ideaId, likeStatus);
                    }
                  },
                  child: buildScore(Icons.thumb_up, likes[index], colorNumber),
                ),
                GestureDetector(
                  onTap: () async {
                    setState(() {
                      bookmarks[index] = !bookmarks[index];
                      imgPaths[index] = bookmarks[index] 
                        ? 'assets/images/mynukaadd.png' 
                        : 'assets/images/notmynuka.png';
                    });
                    if (bookmarks[index]) {
                      print('ブックマーク追加');
                      await createBookmark(userId, ideaId);
                    } else {
                      print('ブックマーク削除');
                      await deleteBookmark(userId, ideaId);
                    }
                  },
                  child: Image.asset(
                    imgPaths[index],
                    width: 45,
                    height: 45,
                  ),
                ),
              ],
            ),
            Text(DateFormat('yyyy/MM/dd HH:mm:ss').format(DateTime.now()), style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  // いいね数の増加
  Future<void> updateLikeStatus(int ideaId, int likeStatus) async {
    final url = 'https://addlike.azurewebsites.net/api/add_like';
    final body = json.encode({"ideaid": ideaId.toString()});
    final headers = {'Content-Type': 'application/json'};
    try {
      final response = await http.patch(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        print('Like status updated successfully for ideaId: $ideaId');
      } else {
        print('Failed to update like status for ideaId: $ideaId');
      }
    } catch (e) {
      print('Error updating like status for ideaId: $ideaId: $e');
    }
  }

  // いいね数の減少
  Future<void> downdateLikeStatus(int ideaId, int likeStatus) async {
    final url = 'https://deletelike.azurewebsites.net/api/delete_like';
    final body = json.encode({"ideaid": ideaId.toString()});
    final headers = {'Content-Type': 'application/json'};
    try {
      final response = await http.patch(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        print('Like status downdated successfully for ideaId: $ideaId');
      } else {
        print('Failed to downdate like status for ideaId: $ideaId');
      }
    } catch (e) {
      print('Error downdating like status for ideaId: $ideaId: $e');
    }
  }

  // ブックマーク追加
  Future<void> createBookmark(String userId, int ideaId) async {
    final url = 'https://createbookmark.azurewebsites.net/api/create_bookmark';
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({
      "userid": userId,
      "ideaid": ideaId,
      "bookmarkedat": DateTime.now().toIso8601String()
    });

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Bookmark created successfully for userId: $userId, ideaId: $ideaId');
      } else {
        print('Failed to create bookmark for userId: $userId, ideaId: $ideaId');
      }
    } catch (e) {
      print('Error creating bookmark for userId: $userId, ideaId: $e');
    }
  }

  Future<void> deleteBookmark(String userId, int ideaId) async {
    final url = 'https://deletebookmark.azurewebsites.net/api/delete_bookmark?userid=$userId&ideaid=$ideaId';
    final headers = {'Content-Type': 'application/json'};

    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('$url');
        print('Bookmark delete successfully for userId: $userId, ideaId: $ideaId');
      } else {
        print('Failed to delete bookmark for userId: $userId, ideaId: $ideaId');
      }
    } catch (e) {
      print('Error deleting bookmark for userId: $userId, ideaId: $e');
    }
  }

  Widget buildScore(IconData icon, int count, int colorNumber) {
    Color iconColor = (colorNumber == 0) ? Colors.blue : Colors.red;
    return Row(
      children: <Widget>[
        Icon(icon, color: iconColor),
        SizedBox(width: 4),
        Text('$count'),
      ],
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
// import 'dart:convert';
// import 'package:firebase_auth/firebase_auth.dart';

// class HorizontalCardLists extends StatefulWidget {
//   final List<String> titles;
//   final List<int> colorNumbers;
//   final List<int> ideaId;
//   final List<int> likeNum;
//   final List<bool> isBookmarked;

//   const HorizontalCardLists({
//     Key? key,
//     required this.titles,
//     required this.colorNumbers,
//     required this.ideaId,
//     required this.likeNum,
//     required this.isBookmarked,
//   }) : super(key: key);

//   @override
//   _HorizontalCardListsState createState() => _HorizontalCardListsState();
// }

// class _HorizontalCardListsState extends State<HorizontalCardLists> {
//   late final ScrollController titleController;
//   late List<int> likes;
//   late List<int> tapCounts;
//   late List<int> tapNum;
//   late List<String> imgPaths;
//   late List<bool> bookmarks;
//   String userId = '';

//   @override
//   void initState() {
//     super.initState();
//     titleController = ScrollController();
//     likes = List.generate(widget.likeNum.length, (index) => widget.likeNum[index]);
//     tapCounts = List.generate(widget.titles.length, (index) => 0);
//     tapNum = List.generate(widget.titles.length, (index) => 0);
//     bookmarks = List.from(widget.isBookmarked);
//     imgPaths = List.generate(widget.titles.length, (index) => 
//       bookmarks[index] ? 'assets/images/mynukaadd.png' : 'assets/images/notmynuka.png'
//     );
//     _setCurrentUserUid(); // 追加：初期化時にUIDを設定
//   }

//   @override
//   void dispose() {
//     titleController.dispose();
//     super.dispose();
//   }

//   Future<void> _setCurrentUserUid() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       setState(() {
//         userId = user.uid;
//       });
//       print('現在のユーザーのUID: ${user.uid}');
//     } else {
//       print('ユーザーはログインしていません。');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     double cardWidth = screenWidth / (screenWidth ~/ 200);
//     cardWidth = cardWidth < 200 ? 380 : cardWidth;
//     cardWidth = cardWidth > 400 ? 400 : cardWidth;
//     final cardHeight = 320.0;

//     return Container(
//       height: MediaQuery.of(context).size.height,
//       child: GridView.builder(
//         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: screenWidth ~/ cardWidth,
//           childAspectRatio: cardWidth / cardHeight,
//           crossAxisSpacing: 10,
//           mainAxisSpacing: 10,
//         ),
//         itemCount: widget.titles.length,
//         itemBuilder: (context, index) {
//           return buildCard(widget.titles[index], cardWidth, index, widget.colorNumbers[index], widget.ideaId[index], widget.likeNum[index]);
//         },
//       ),
//     );
//   }

//   Widget buildCard(String title, double width, int index, int colorNumber, int ideaId, int likeNum) {
//     Color borderColor = (colorNumber == 0) ? Colors.blue : Colors.red;

//     return Card(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(15.0),
//         side: BorderSide(color: borderColor, width: 3.0),
//       ),
//       elevation: 5,
//       child: Container(
//         color: Colors.white,
//         width: width,
//         padding: EdgeInsets.all(10),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text('No.$ideaId'),
//             Icon(Icons.account_circle, size: 50, color: borderColor),
//             SizedBox(height: 10),
//             Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//             Padding(
//               padding: const EdgeInsets.all(10),
//               child: Container(
//                 width: 85,
//                 height: 85,
//                 decoration: BoxDecoration(
//                   border: Border.all(color: borderColor, width: 2),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Center(child: Text('写真')),
//               ),
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 GestureDetector(
//                   onTap: () async {
//                     setState(() {
//                       likes[index] = likes[index] == likeNum ? likeNum + 1 : likeNum;
//                       tapCounts[index]++;
//                     });
//                     final likeStatus = likes[index];
//                     final tapCount = tapCounts[index];
//                     print('アイデアID: $ideaId, Like Status: $likeStatus , Tap Count: $tapCount');
//                     if (tapCount % 2 == 0) {
//                       print('いいねの取り消し');
//                       await downdateLikeStatus(ideaId, likeStatus);
//                     } else {
//                       print('いいねの追加');
//                       await updateLikeStatus(ideaId, likeStatus);
//                     }
//                   },
//                   child: buildScore(Icons.thumb_up, likes[index], colorNumber),
//                 ),
//                 GestureDetector(
//                   onTap: () async {
//                     setState(() {
//                       bookmarks[index] = !bookmarks[index];
//                       imgPaths[index] = bookmarks[index] 
//                         ? 'assets/images/mynukaadd.png' 
//                         : 'assets/images/notmynuka.png';
//                     });
//                     if (bookmarks[index]) {
//                       print('ブックマーク追加');
//                       await createBookmark(userId, ideaId);
//                     } else {
//                       print('ブックマーク削除');
//                       await deleteBookmark(userId, ideaId);
//                     }
//                   },
//                   child: Image.asset(
//                     imgPaths[index],
//                     width: 45,
//                     height: 45,
//                   ),
//                 ),
//               ],
//             ),
//             Text(DateFormat('yyyy/MM/dd HH:mm:ss').format(DateTime.now()), style: TextStyle(color: Colors.grey)),
//           ],
//         ),
//       ),
//     );
//   }

//   // いいね数の増加
//   Future<void> updateLikeStatus(int ideaId, int likeStatus) async {
//     final url = 'https://addlike.azurewebsites.net/api/add_like';
//     final body = json.encode({"ideaid": ideaId.toString()});
//     final headers = {'Content-Type': 'application/json'};
//     try {
//       final response = await http.patch(
//         Uri.parse(url),
//         headers: headers,
//         body: body,
//       );

//       if (response.statusCode == 200) {
//         print('Like status updated successfully for ideaId: $ideaId');
//       } else {
//         print('Failed to update like status for ideaId: $ideaId');
//       }
//     } catch (e) {
//       print('Error updating like status for ideaId: $ideaId: $e');
//     }
//   }

//   // いいね数の減少
//   Future<void> downdateLikeStatus(int ideaId, int likeStatus) async {
//     final url = 'https://deletelike.azurewebsites.net/api/delete_like';
//     final body = json.encode({"ideaid": ideaId.toString()});
//     final headers = {'Content-Type': 'application/json'};
//     try {
//       final response = await http.patch(
//         Uri.parse(url),
//         headers: headers,
//         body: body,
//       );

//       if (response.statusCode == 200) {
//         print('Like status downdated successfully for ideaId: $ideaId');
//       } else {
//         print('Failed to downdate like status for ideaId: $ideaId');
//       }
//     } catch (e) {
//       print('Error downdating like status for ideaId: $ideaId: $e');
//     }
//   }

//   // ブックマーク追加
//   Future<void> createBookmark(String userId, int ideaId) async {
//     final url = 'https://createbookmark.azurewebsites.net/api/create_bookmark';
//     final headers = {'Content-Type': 'application/json'};
//     final body = json.encode({
//       "userid": userId,
//       "ideaid": ideaId,
//       "bookmarkedat": DateTime.now().toIso8601String()
//     });

//     try {
//       final response = await http.post(
//         Uri.parse(url),
//         headers: headers,
//         body: body,
//       );

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         print('Bookmark created successfully for userId: $userId, ideaId: $ideaId');
//       } else {
//         print('Failed to create bookmark for userId: $userId, ideaId: $ideaId');
//       }
//     } catch (e) {
//       print('Error creating bookmark for userId: $userId, ideaId: $e');
//     }
//   }

//   Future<void> deleteBookmark(String userId, int ideaId) async {
//     final url = 'https://deletebookmark.azurewebsites.net/api/delete_bookmark?userid=$userId&ideaid=$ideaId';
//     final headers = {'Content-Type': 'application/json'};

//     try {
//       final response = await http.delete(
//         Uri.parse(url),
//         headers: headers,
//       );

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         print('$url');
//         print('Bookmark delete successfully for userId: $userId, ideaId: $ideaId');
//       } else {
//         print('Failed to delete bookmark for userId: $userId, ideaId: $ideaId');
//       }
//     } catch (e) {
//       print('Error deleting bookmark for userId: $userId, ideaId: $e');
//     }
//   }

//   Widget buildScore(IconData icon, int count, int colorNumber) {
//     Color iconColor = (colorNumber == 0) ? Colors.blue : Colors.red;
//     return Row(
//       children: <Widget>[
//         Icon(icon, color: iconColor),
//         SizedBox(width: 4),
//         Text('$count'),
//       ],
//     );
//   }

// }

