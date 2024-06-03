import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'dart:math';
import 'detail_page.dart';

class HorizontalCardList extends StatefulWidget {
  final List<String> titles;
  final List<String> genres;
  final List<String> ideaContents;  // 追加
  final List<String> photoUrls;     // 追加

  const HorizontalCardList({
    Key? key,
    required this.titles,
    required this.genres,
    required this.ideaContents,  // 追加
    required this.photoUrls,     // 追加
  }) : super(key: key);

  @override
  _HorizontalCardListState createState() => _HorizontalCardListState();
}

class _HorizontalCardListState extends State<HorizontalCardList> {
  late final ScrollController titleController;
  late List<int> likes;
  late List<int> calls;
  late List<List<String>> comments;

  final List<String> callImages = [
    'assets/images/veg1.png',
    'assets/images/veg2.png',
  ];

  @override
  void initState() {
    super.initState();
    titleController = ScrollController();
    likes = List.generate(widget.titles.length, (index) => 0);
    calls = List.generate(widget.titles.length, (index) => 0);
    comments = List.generate(widget.titles.length, (index) => []);
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final minHeight = 200.0;
    final minWidth = 200.0;

    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      constraints: BoxConstraints(
        minHeight: minHeight,
      ),
      child: Column(
        children: [
          buildList(screenWidth, widget.titles, titleController, minHeight, minWidth),
        ],
      ),
    );
  }

  Widget buildList(double screenWidth, List<String> items, ScrollController controller, double minHeight, double minWidth) {
    return Expanded(
      child: Scrollbar(
        controller: controller,
        thumbVisibility: true,
        child: Listener(
          onPointerSignal: (pointerSignal) {
            if (pointerSignal is PointerScrollEvent) {
              final newOffset = controller.offset + pointerSignal.scrollDelta.dx;
              controller.jumpTo(newOffset.clamp(0.0, controller.position.maxScrollExtent));
            }
          },
          child: GestureDetector(
            onHorizontalDragUpdate: (details) {
              controller.position.moveTo(controller.offset - details.primaryDelta!);
            },
            child: ListView.builder(
              controller: controller,
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              itemBuilder: (context, index) {
                //レスポンシブ用変更箇所
                final cardWidth = screenWidth * 0.21;
                final avatarRadius = cardWidth * 0.1;
                final iconSize = cardWidth * 0.08;
                final fontSizeTitle = cardWidth * 0.07;
                final fontSizeGenre = cardWidth * 0.05;
                final fontSizeContent = cardWidth * 0.045;
                
                // ページ遷移アクション
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailPage(
                          title: widget.titles[index],
                          genre: widget.genres[index],
                          ideaContent: widget.ideaContents[index],  // 追加
                          photoUrl: widget.photoUrls[index],        // 追加
                        ),
                      ),
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                    margin: EdgeInsets.all(10),
                    child: Container(
                      //レスポンシブ用変更箇所
                      width: cardWidth, // 初期幅を現在の3分の1に調整
                      constraints: BoxConstraints(
                        minHeight: minHeight,
                        minWidth: minWidth,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: <Widget>[
                                //レスポンシブ用変更箇所
                                CircleAvatar(
                                  backgroundImage: AssetImage(widget.photoUrls[index]),
                                  radius: avatarRadius,
                                ),
                                SizedBox(width: 10),
                                //レスポンシブ用変更箇所
                                Expanded(
                                  child: Text(widget.titles[index],
                                    style: TextStyle(
                                      fontSize: fontSizeTitle,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            //レスポンシブ用変更箇所
                            Text(
                              widget.genres[index],
                              style: TextStyle(
                                fontSize: fontSizeGenre,
                                color: Colors.grey[700],
                              ),
                            ),
                            SizedBox(height: 10),
                            //レスポンシブ用変更箇所
                            Text(
                              widget.ideaContents[index],
                              style: TextStyle(
                                fontSize: fontSizeContent,
                              ),
                            ),
                            Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      likes[index] = likes[index] == 0 ? 1 : 0; //ここ変更点: 「イイネ」数を増減させるロジックを追加しました。
                                    });
                                  },
                                  //レスポンシブ用変更箇所
                                  child: buildScore(Icons.thumb_up, likes[index], iconSize),
                                ), //ここまで追加
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      calls[index]++;
                                    });
                                  },
                                  //レスポンシブ用変更箇所
                                  child: buildRandomImageScore(callImages, iconSize),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _showCommentModal(context, index);
                                  },
                                  //レスポンシブ用変更箇所
                                  child: buildScore(Icons.comment, comments[index].length, iconSize),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  //レスポンシブ用変更箇所
  Widget buildScore(IconData icon, int count, double iconSize) {
    return Row(
      children: <Widget>[
        Icon(icon, color: Colors.blue, size: iconSize),
        SizedBox(width: 4),
        Text('$count'),
      ],
    );
  }

  //レスポンシブ用変更箇所
  Widget buildRandomImageScore(List<String> images, double iconSize) {
    final random = Random();
    final imagePath = images[random.nextInt(images.length)];
    return Row(
      children: <Widget>[
        Image.asset(imagePath, width: iconSize, height: iconSize),
        SizedBox(width: 4),
        Text(''),
      ],
    );
  }

  void _showCommentModal(BuildContext context, int index) {
    final TextEditingController commentController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('コメントを追加'),
          content: TextField(
            controller: commentController,
            decoration: InputDecoration(hintText: 'コメントを入力してください'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('キャンセル'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('追加'),
              onPressed: () {
                setState(() {
                  comments[index].add(commentController.text);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:flutter/gestures.dart';
// import 'dart:math';
// import 'detail_page.dart';

// class HorizontalCardList extends StatefulWidget {
//   final List<String> titles;
//   final List<String> genres;
//   final List<String> ideaContents;  // 追加
//   final List<String> photoUrls;     // 追加

//   const HorizontalCardList({
//     Key? key,
//     required this.titles,
//     required this.genres,
//     required this.ideaContents,  // 追加
//     required this.photoUrls,     // 追加
//   }) : super(key: key);

//   @override
//   _HorizontalCardListState createState() => _HorizontalCardListState();
// }

// class _HorizontalCardListState extends State<HorizontalCardList> {
//   late final ScrollController titleController;
//   late List<int> likes;
//   late List<int> calls;
//   late List<List<String>> comments;

//   final List<String> callImages = [
//     'assets/images/veg1.png',
//     'assets/images/veg2.png',
//   ];

//   @override
//   void initState() {
//     super.initState();
//     titleController = ScrollController();
//     likes = List.generate(widget.titles.length, (index) => 0);
//     calls = List.generate(widget.titles.length, (index) => 0);
//     comments = List.generate(widget.titles.length, (index) => []);
//   }

//   @override
//   void dispose() {
//     titleController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final minHeight = 200.0;
//     final minWidth = 200.0;

//     return Container(
//       height: MediaQuery.of(context).size.height * 0.4,
//       constraints: BoxConstraints(
//         minHeight: minHeight,
//       ),
//       child: Column(
//         children: [
//           buildList(screenWidth, widget.titles, titleController, minHeight, minWidth),
//         ],
//       ),
//     );
//   }

//   Widget buildList(double screenWidth, List<String> items, ScrollController controller, double minHeight, double minWidth) {
//     return Expanded(
//       child: Scrollbar(
//         controller: controller,
//         thumbVisibility: true,
//         child: Listener(
//           onPointerSignal: (pointerSignal) {
//             if (pointerSignal is PointerScrollEvent) {
//               final newOffset = controller.offset + pointerSignal.scrollDelta.dx;
//               controller.jumpTo(newOffset.clamp(0.0, controller.position.maxScrollExtent));
//             }
//           },
//           child: GestureDetector(
//             onHorizontalDragUpdate: (details) {
//               controller.position.moveTo(controller.offset - details.primaryDelta!);
//             },
//             child: ListView.builder(
//               controller: controller,
//               scrollDirection: Axis.horizontal,
//               itemCount: items.length,
//               itemBuilder: (context, index) {
//                 //レスポンシブ用変更箇所
//                 final cardWidth = screenWidth * 0.21;
//                 final avatarRadius = cardWidth * 0.1;
//                 final iconSize = cardWidth * 0.08;
//                 final fontSizeTitle = cardWidth * 0.07;
//                 final fontSizeGenre = cardWidth * 0.05;
//                 final fontSizeContent = cardWidth * 0.045;

//                 return InkWell(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => DetailPage(
//                           title: widget.titles[index],
//                           genre: widget.genres[index],
//                           ideaContent: widget.ideaContents[index],  // 追加
//                           photoUrl: widget.photoUrls[index],        // 追加
//                         ),
//                       ),
//                     );
//                   },
//                   child: Card(
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(15),
//                     ),
//                     elevation: 5,
//                     margin: EdgeInsets.all(10),
//                     child: Container(
//                       //レスポンシブ用変更箇所
//                       width: cardWidth, // 初期幅を現在の3分の1に調整
//                       constraints: BoxConstraints(
//                         minHeight: minHeight,
//                         minWidth: minWidth,
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               children: <Widget>[
//                                 //レスポンシブ用変更箇所
//                                 CircleAvatar(
//                                   backgroundImage: AssetImage(widget.photoUrls[index]),
//                                   radius: avatarRadius,
//                                 ),
//                                 SizedBox(width: 10),
//                                 //レスポンシブ用変更箇所
//                                 Expanded(
//                                   child: Text(widget.titles[index],
//                                     style: TextStyle(
//                                       fontSize: fontSizeTitle,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             SizedBox(height: 10),
//                             //レスポンシブ用変更箇所
//                             Text(
//                               widget.genres[index],
//                               style: TextStyle(
//                                 fontSize: fontSizeGenre,
//                                 color: Colors.grey[700],
//                               ),
//                             ),
//                             SizedBox(height: 10),
//                             //レスポンシブ用変更箇所
//                             Text(
//                               widget.ideaContents[index],
//                               style: TextStyle(
//                                 fontSize: fontSizeContent,
//                               ),
//                             ),
//                             Spacer(),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                               children: <Widget>[
//                                 GestureDetector(
//                                   onTap: () {
//                                     setState(() {
//                                       likes[index]++;
//                                     });
//                                   },
//                                   //レスポンシブ用変更箇所
//                                   child: buildScore(Icons.thumb_up, likes[index], iconSize),
//                                 ),
//                                 GestureDetector(
//                                   onTap: () {
//                                     setState(() {
//                                       calls[index]++;
//                                     });
//                                   },
//                                   //レスポンシブ用変更箇所
//                                   child: buildRandomImageScore(callImages, iconSize),
//                                 ),
//                                 GestureDetector(
//                                   onTap: () {
//                                     _showCommentModal(context, index);
//                                   },
//                                   //レスポンシブ用変更箇所
//                                   child: buildScore(Icons.comment, comments[index].length, iconSize),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   //レスポンシブ用変更箇所
//   Widget buildScore(IconData icon, int count, double iconSize) {
//     return Row(
//       children: <Widget>[
//         Icon(icon, color: Colors.blue, size: iconSize),
//         SizedBox(width: 4),
//         Text('$count'),
//       ],
//     );
//   }

//   //レスポンシブ用変更箇所
//   Widget buildRandomImageScore(List<String> images, double iconSize) {
//     final random = Random();
//     final imagePath = images[random.nextInt(images.length)];
//     return Row(
//       children: <Widget>[
//         Image.asset(imagePath, width: iconSize, height: iconSize),
//         SizedBox(width: 4),
//         Text(''),
//       ],
//     );
//   }

//   void _showCommentModal(BuildContext context, int index) {
//     final TextEditingController commentController = TextEditingController();
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('コメントを追加'),
//           content: TextField(
//             controller: commentController,
//             decoration: InputDecoration(hintText: 'コメントを入力してください'),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: Text('キャンセル'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               child: Text('追加'),
//               onPressed: () {
//                 setState(() {
//                   comments[index].add(commentController.text);
//                 });
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
// }



