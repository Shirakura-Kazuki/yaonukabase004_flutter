import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart'; // FirebaseAuthをインポート
import 'detail_screen1.dart';

class CordinatorScreen extends StatefulWidget {
  const CordinatorScreen({Key? key}) : super(key: key);

  @override
  _CordinatorScreenState createState() => _CordinatorScreenState();
}

class _CordinatorScreenState extends State<CordinatorScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _shakeAnimation;
  late Animation<double> _moveLeftAnimation;
  late Animation<double> _rotateAnimation;
  bool _showList = false;
  bool _isFirstTap = true;

  List<dynamic> _matchedIdeas = []; // アイデアの詳細データを格納するリスト
  List<dynamic> _rankingItems = []; // 新しいリスト

  String userId = ''; // userIdを初期化

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3), // Reduced duration to make the animation faster
      vsync: this,
    );

    _shakeAnimation = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 15.0).chain(CurveTween(curve: Curves.easeInOut)), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 15.0, end: -15.0).chain(CurveTween(curve: Curves.easeInOut)), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -15.0, end: 0.0).chain(CurveTween(curve: Curves.easeInOut)), weight: 1),
    ]).animate(CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.2)));

    _rotateAnimation = Tween(begin: 0.0, end: 0.5).chain(CurveTween(curve: Curves.easeInOut)).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.3, 0.5)),
    );

    _fetchUserId(); // initStateでFirebaseユーザーIDを取得
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _moveLeftAnimation = Tween(begin: 0.0, end: -MediaQuery.of(context).size.width / 2 + 450).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.7, 1.0, curve: Curves.easeInOut)),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _showList = true;
          _isFirstTap = false;
        });
      }
    });
  }

  Future<void> _fetchUserId() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userId = user.uid;
      });
      _updateRanking(); // ユーザーIDを取得した後にランキングを更新
    } else {
      print('User is not logged in.');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startAnimation() {
    _controller.forward(from: 0.0);
  }

  void _updateRanking() async {
    try {
      final response = await http.get(
        Uri.parse('https://getmatchedideas.azurewebsites.net/api/get_matched_ideas?userid=$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Access-Control-Allow-Origin': '*',
        },
      );

      if (response.statusCode == 200) {
        // UTF-8エンコードされたボディをデコード
        final utf8Body = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> jsonData = jsonDecode(utf8Body);
        final List<dynamic> matchedIdeas = jsonData['matched_ideas'];

        // percentageで降順にソート
        matchedIdeas.sort((a, b) => (b['percentage'] as num).compareTo(a['percentage'] as num));

        print(matchedIdeas);

        // 新しいリストにコピー
        final List<dynamic> rankingItems = [];
        int count = 0;
        for (final item in matchedIdeas) {
          final originalIdea = item['original_idea'];
          final otherIdea = item['the_other_idea'];
          final String combinedIdeaId = '${originalIdea['ideaname']}-${otherIdea['ideaname']}';
          rankingItems.add(combinedIdeaId);
          count++;
          if (count >= 5) {
            break;
          }
        }

        // アイデアの詳細をリストに保存
        setState(() {
          _matchedIdeas = matchedIdeas;
          _rankingItems = rankingItems;
        });

      } else {
        print('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Cordinator Screen', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Stack(
        children: [
          Center(
            child: GestureDetector(
              onTap: () {
                if (_isFirstTap) {
                  _startAnimation();
                  _updateRanking();
                } else {
                  _controller.reset();
                }
              },
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  final offset = _isFirstTap
                      ? Offset(_shakeAnimation.value + _moveLeftAnimation.value,0)
                      : Offset(_moveLeftAnimation.value, 0) + Offset(_shakeAnimation.value, 0);
                  return Transform.translate(
                    offset: offset,
                    child: Transform.rotate(
                      angle: _rotateAnimation.value,
                      child: child,
                    ),
                  );
                },
                child: Image.asset(
                  'assets/images/2tubo.png',
                  fit: BoxFit.cover,
                  width: 300,
                  height: 300,
                ),
              ),
            ),
          ),
          if (_showList)
            Positioned(
              top: 0,
              bottom: 0,
              right: 0,
              child: Container(
                width: MediaQuery.of(context).size.width / 2,
                color: Colors.white,
                child: _buildRankingList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildRankingList() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _rankingItems.length,
        itemBuilder: (context, index) {
          final item = _rankingItems[index];

          return GestureDetector(
            onTap: () async {
              final originalIdea = _matchedIdeas[index]['original_idea'];
              final otherIdea = _matchedIdeas[index]['the_other_idea'];

              // nullチェックを追加
              if (originalIdea != null && otherIdea != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailPage(
                      originalTitle: originalIdea['ideaname'],
                      originalGenre: originalIdea['ideaconcept'],
                      originalIdeaContent: originalIdea['ideaconcept'],
                      originalPhotoUrl: originalIdea['ideaimage'],
                      otherTitle: otherIdea['ideaname'],
                      otherGenre: otherIdea['ideaconcept'],
                      otherIdeaContent: otherIdea['ideaconcept'],
                      otherPhotoUrl: otherIdea['ideaimage'],
                    ),
                  ),
                );
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Text(
                    '${index + 1}.',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      height: 50,
                      color: Colors.grey[200],
                      child: Center(
                        child: Text(item, style: const TextStyle(color: Colors.black)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.white,
        primaryColor: Colors.white,
        colorScheme: const ColorScheme.light().copyWith(
          secondary: Colors.blueAccent,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          titleTextStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
          iconTheme: IconThemeData(color: Colors.black),
        ),
      ),
      home: const CordinatorScreen(),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'detail_screen1.dart';

// class CordinatorScreen extends StatefulWidget {
//   const CordinatorScreen({Key? key}) : super(key: key);

//   @override
//   _CordinatorScreenState createState() => _CordinatorScreenState();
// }

// class _CordinatorScreenState extends State<CordinatorScreen> with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _shakeAnimation;
//   late Animation<double> _moveLeftAnimation;
//   late Animation<double> _rotateAnimation;
//   bool _showList = false;
//   bool _isFirstTap = true;

//   List<dynamic> _matchedIdeas = []; // アイデアの詳細データを格納するリスト
//   List<dynamic> _rankingItems = []; // 新しいリスト

//   final String userId = '1';

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(seconds: 3), // Reduced duration to make the animation faster
//       vsync: this,
//     );

//     _shakeAnimation = TweenSequence([
//       TweenSequenceItem(tween: Tween(begin: 0.0, end: 15.0).chain(CurveTween(curve: Curves.easeInOut)), weight: 1),
//       TweenSequenceItem(tween: Tween(begin: 15.0, end: -15.0).chain(CurveTween(curve: Curves.easeInOut)), weight: 1),
//       TweenSequenceItem(tween: Tween(begin: -15.0, end: 0.0).chain(CurveTween(curve: Curves.easeInOut)), weight: 1),
//     ]).animate(CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.2)));

//     _rotateAnimation = Tween(begin: 0.0, end: 0.5).chain(CurveTween(curve: Curves.easeInOut)).animate(
//       CurvedAnimation(parent: _controller, curve: const Interval(0.3, 0.5)),
//     );
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     _moveLeftAnimation = Tween(begin: 0.0, end: -MediaQuery.of(context).size.width / 2 + 450).animate(
//       CurvedAnimation(parent: _controller, curve: const Interval(0.7, 1.0, curve: Curves.easeInOut)),
//     );

//     _controller.addStatusListener((status) {
//       if (status == AnimationStatus.completed) {
//         setState(() {
//           _showList = true;
//           _isFirstTap = false;
//         });
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   void _startAnimation() {
//     _controller.forward(from: 0.0);
//   }

//   void _updateRanking() async {
//     try {
//       final response = await http.get(
//         Uri.parse('https://getmatchedideas.azurewebsites.net/api/get_matched_ideas?userid=$userId'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Access-Control-Allow-Origin': '*',
//         },
//       );

//       if (response.statusCode == 200) {
//         // UTF-8エンコードされたボディをデコード
//         final utf8Body = utf8.decode(response.bodyBytes);
//         final Map<String, dynamic> jsonData = jsonDecode(utf8Body);
//         final List<dynamic> matchedIdeas = jsonData['matched_ideas'];

//         // percentageで降順にソート
//         matchedIdeas.sort((a, b) => (b['percentage'] as num).compareTo(a['percentage'] as num));

//         print(matchedIdeas);

//         // 新しいリストにコピー
//         final List<dynamic> rankingItems = [];
//         int count = 0;
//         for (final item in matchedIdeas) {
//           final originalIdea = item['original_idea'];
//           final otherIdea = item['the_other_idea'];
//           final String combinedIdeaId = '${originalIdea['ideaname']}-${otherIdea['ideaname']}';
//           rankingItems.add(combinedIdeaId);
//           count++;
//           if (count >= 5) {
//             break;
//           }
//         }

//         // アイデアの詳細をリストに保存
//         setState(() {
//           _matchedIdeas = matchedIdeas;
//           _rankingItems = rankingItems;
//         });

//       } else {
//         print('Failed to fetch data: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error fetching data: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         title: const Text('Cordinator Screen', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
//         iconTheme: const IconThemeData(color: Colors.black),
//       ),
//       body: Stack(
//         children: [
//           Center(
//             child: GestureDetector(
//               onTap: () {
//                 if (_isFirstTap) {
//                   _startAnimation();
//                   _updateRanking();
//                 } else {
//                   _controller.reset();
//                 }
//               },
//               child: AnimatedBuilder(
//                 animation: _controller,
//                 builder: (context, child) {
//                   final offset = _isFirstTap
//                       ? Offset(_shakeAnimation.value + _moveLeftAnimation.value,0)
//                       : Offset(_moveLeftAnimation.value, 0) + Offset(_shakeAnimation.value, 0);
//                   return Transform.translate(
//                     offset: offset,
//                     child: Transform.rotate(
//                       angle: _rotateAnimation.value,
//                       child: child,
//                     ),
//                   );
//                 },
//                 child: Image.asset(
//                   'assets/images/2tubo.png',
//                   fit: BoxFit.cover,
//                   width: 300,
//                   height: 300,
//                 ),
//               ),
//             ),
//           ),
//           if (_showList)
//             Positioned(
//               top: 0,
//               bottom: 0,
//               right: 0,
//               child: Container(
//                 width: MediaQuery.of(context).size.width / 2,
//                 color: Colors.white,
//                 child: _buildRankingList(),
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   Widget _buildRankingList() {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: ListView.builder(
//         padding: const EdgeInsets.all(16.0),
//         itemCount: _rankingItems.length,
//         itemBuilder: (context, index) {
//           final item = _rankingItems[index];

//           return GestureDetector(
//             onTap: () async {
//               final originalIdea = _matchedIdeas[index]['original_idea'];
//               final otherIdea = _matchedIdeas[index]['the_other_idea'];

//               // nullチェックを追加
//               if (originalIdea != null && otherIdea != null) {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => DetailPage(
//                       originalTitle: originalIdea['ideaname'],
//                       originalGenre: originalIdea['ideaconcept'],
//                       originalIdeaContent: originalIdea['ideaconcept'],
//                       originalPhotoUrl: originalIdea['ideaimage'],
//                       otherTitle: otherIdea['ideaname'],
//                       otherGenre: otherIdea['ideaconcept'],
//                       otherIdeaContent: otherIdea['ideaconcept'],
//                       otherPhotoUrl: otherIdea['ideaimage'],
//                     ),
//                   ),
//                 );
//               }
//             },
//             child: Padding(
//               padding: const EdgeInsets.symmetric(vertical: 8.0),
//               child: Row(
//                 children: [
//                   Text(
//                     '${index + 1}.',
//                     style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
//                   ),
//                   const SizedBox(width: 10),
//                   Expanded(
//                     child: Container(
//                       height: 50,
//                       color: Colors.grey[200],
//                       child: Center(
//                         child: Text(item, style: const TextStyle(color: Colors.black)),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData.light().copyWith(
//         scaffoldBackgroundColor: Colors.white,
//         primaryColor: Colors.white,
//         colorScheme: const ColorScheme.light().copyWith(
//           secondary: Colors.blueAccent,
//         ),
//         appBarTheme: const AppBarTheme(
//           backgroundColor: Colors.white,
//           titleTextStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
//           iconTheme: IconThemeData(color: Colors.black),
//         ),
//       ),
//       home: const CordinatorScreen(),
//     );
//   }
// }
