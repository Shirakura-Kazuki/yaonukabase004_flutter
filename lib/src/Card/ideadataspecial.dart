import 'package:flutter/material.dart';

class IdeaDataSpecial extends StatelessWidget {
  final int id;
  final String ideaname;
  final String ideaconcept;
  final String ideatechnology1;
  final String? ideatechnology2;
  final String? ideatechnology3;
  final String ideadate;
  final int numberoflikes;
  final bool isBookmarked;

  const IdeaDataSpecial({
    Key? key,
    required this.id,
    required this.ideaname,
    required this.ideaconcept,
    required this.ideatechnology1,
    this.ideatechnology2,
    this.ideatechnology3,
    required this.ideadate,
    required this.numberoflikes,
    required this.isBookmarked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('アイデア詳細'),
      ),
      body: Container(
        color: Colors.grey.shade50,
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('アイデア詳細', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
              SizedBox(height: 16),
              Container(
                color: Colors.deepOrange.shade900,  // 背景色を青に設定
                padding: const EdgeInsets.all(8.0),  // 内側の余白を設定
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('ID: ', style: TextStyle(fontSize: 18, color: Colors.white)),
                        Text('$id', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                        SizedBox(width: 20),
                        Text('タイトル: ', style: TextStyle(fontSize: 18, color: Colors.white)),
                        Expanded(
                          child: Text(
                            ideaname,
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 5, 10),
                    child: Container(
                      height: MediaQuery.of(context).size.width * 0.3,
                      width: MediaQuery.of(context).size.width * 0.3,
                      constraints: BoxConstraints(
                        minHeight: 50,
                        minWidth: 50,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white, width: 2,
                        ),
                      ),
                      child: Image.asset('assets/images/noimg.png', fit: BoxFit.cover),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          color: Colors.deepOrange.shade900,  // 背景色を青に設定
                          padding: const EdgeInsets.all(8.0),  // 内側の余白を設定
                          child: Text(
                            '必要な技術',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text('技術ジャンル1: $ideatechnology1', style: TextStyle(fontSize: 18)),
                        if (ideatechnology2 != null) Text('技術ジャンル2: $ideatechnology2', style: TextStyle(fontSize: 18)),
                        if (ideatechnology3 != null) Text('技術ジャンル3: $ideatechnology3', style: TextStyle(fontSize: 18)),
                        SizedBox(height: 16),
                        Text('アイデア追加日時: ', style: TextStyle(fontSize: 18)),
                        Text(ideadate, style: TextStyle(fontSize: 16)),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Text('いいね数: ', style: TextStyle(fontSize: 18)),
                            Text('$numberoflikes', style: TextStyle(fontSize: 16)),
                            SizedBox(width: 20),
                            Text('ブックマーク: ', style: TextStyle(fontSize: 18)),
                            Image.asset(
                              isBookmarked ? 'assets/images/mynukaadd.png' : 'assets/images/notmynuka.png',
                              width: 24,
                              height: 24,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Container(
                color: Colors.deepOrange.shade900,  // 背景色を青に設定
                padding: const EdgeInsets.all(8.0),  // 内側の余白を設定
                child: Text(
                  'アイデアコンセプト',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              Container(
                color: Colors.grey.shade300,  // テキスト表示スペースの背景色を灰色に設定
                width: double.infinity,  // 幅を画面いっぱいに設定
                padding: const EdgeInsets.all(8.0),  // 内側の余白を設定
                child: Text(
                  ideaconcept,
                  style: TextStyle(fontSize: 16),
                  maxLines: 10,  // 最大行数を設定
                  overflow: TextOverflow.ellipsis,  // テキストが溢れた場合に省略記号を表示
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



// import 'package:flutter/material.dart';

// class IdeaDataSpecial extends StatelessWidget {
//   final int id;
//   final String ideaname;
//   final String ideaconcept;
//   final String ideatechnology1;
//   final String? ideatechnology2;
//   final String? ideatechnology3;
//   final String ideadate;
//   final int numberoflikes;
//   final bool isBookmarked;

//   const IdeaDataSpecial({
//     Key? key,
//     required this.id,
//     required this.ideaname,
//     required this.ideaconcept,
//     required this.ideatechnology1,
//     this.ideatechnology2,
//     this.ideatechnology3,
//     required this.ideadate,
//     required this.numberoflikes,
//     required this.isBookmarked,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('アイデア詳細'),
//       ),
//       body: Container(
//         color: Colors.grey.shade50,
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('アイデア詳細', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
//             SizedBox(height: 16),
//             Container(
//               color: Colors.deepOrange.shade900,  // 背景色を青に設定
//               padding: const EdgeInsets.all(8.0),  // 内側の余白を設定
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Text('ID: ', style: TextStyle(fontSize: 18, color: Colors.white)),
//                       Text('$id', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
//                       SizedBox(width: 20),
//                       Text('タイトル: ', style: TextStyle(fontSize: 18, color: Colors.white)),
//                       Expanded(
//                         child:Text(
//                           ideaname, 
//                           style: TextStyle(
//                             fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis,
//                         ), 
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 16),
//             Row(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(10, 0, 5, 10),
//                   child: Container(
//                     height: 300,
//                     width: 300,
//                     decoration: BoxDecoration(
//                       border: Border.all(
//                         color: Colors.white, width: 2,
//                       ),
//                     ),
//                     child: Image.asset('assets/images/noimg.png'),
//                   ),
//                 ),
//                 SizedBox(width: 10),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Container(
//                       color: Colors.deepOrange.shade900,  // 背景色を青に設定
//                       padding: const EdgeInsets.all(8.0),  // 内側の余白を設定
//                       child: Text(
//                         '必要な技術',
//                         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
//                       ),
//                     ),
//                     SizedBox(height: 8),
//                     Text('技術ジャンル1: $ideatechnology1', style: TextStyle(fontSize: 18)),
//                     if (ideatechnology2 != null) Text('技術ジャンル2: $ideatechnology2', style: TextStyle(fontSize: 18)),
//                     if (ideatechnology3 != null) Text('技術ジャンル3: $ideatechnology3', style: TextStyle(fontSize: 18)),
//                     SizedBox(height: 16),
//                     Text('アイデア追加日時: ', style: TextStyle(fontSize: 18)),
//                     Text(ideadate, style: TextStyle(fontSize: 16)),
//                     SizedBox(height: 16),
//                     Row(
//                       children: [
//                         Text('いいね数: ', style: TextStyle(fontSize: 18)),
//                         Text('$numberoflikes', style: TextStyle(fontSize: 16)),
//                         SizedBox(width: 20),
//                         Text('ブックマーク: ', style: TextStyle(fontSize: 18)),
//                         Image.asset(
//                           isBookmarked ? 'assets/images/mynukaadd.png' : 'assets/images/notmynuka.png',
//                           width: 24,
//                           height: 24,
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             SizedBox(height: 16),
//             Container(
//               color: Colors.deepOrange.shade900,  // 背景色を青に設定
//               padding: const EdgeInsets.all(8.0),  // 内側の余白を設定
//               child: Text(
//                 'アイデアコンセプト',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Text(ideaconcept, style: TextStyle(fontSize: 16)),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
