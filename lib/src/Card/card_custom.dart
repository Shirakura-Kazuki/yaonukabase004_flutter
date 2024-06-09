import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:intl/intl.dart';
import 'package:auto_size_text/auto_size_text.dart';

// 横にスクロールできるカードリストを作るクラス
class CustomCardList extends StatefulWidget {
  final List<String> titles;  // カードのタイトルを入れるためのリスト
  final List<String> cindex;  // 会社名のリスト

  // コンストラクタ（クラスを作るときに使う関数）
  const CustomCardList({
    Key? key,
    required this.titles,  // 必要な引数 titles
    required this.cindex,  // 必要な引数 cindex
  }) : super(key: key);

  // 状態を管理するクラスの作成
  @override
  _CustomCardListState createState() => _CustomCardListState();
}

// 状態を管理するクラス
class _CustomCardListState extends State<CustomCardList> {
  late final ScrollController titleController;

  @override
  void initState() {
    super.initState();
    // スクロールを管理するためのコントローラー
    titleController = ScrollController();
  }

  // クラスが削除されるときに呼ばれる
  @override
  void dispose() {
    // メモリの無駄遣いを避けるためにコントローラーを破棄
    titleController.dispose();
    super.dispose();
  }

  // 画面を作るときに呼ばれる
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;  // 画面の幅
    final minHeight = 200.0;  // 最小の高さを200に設定
    final minWidth = 200.0;  // 最小の幅を200に設定

    // 縦に並ぶ要素をまとめたコンテナ
    return Container(
      height: MediaQuery.of(context).size.height * 0.45,  // 高さは画面の45%に設定
      constraints: BoxConstraints(
        minHeight: minHeight,  // 最小の高さを設定
      ),
      child: Column(
        children: [
          // 横にスクロールできるリストを作る
          buildList(screenWidth, widget.titles, widget.cindex, titleController, minHeight, minWidth),
        ],
      ),
    );
  }

  // 横にスクロールできるリストを作る関数
  Widget buildList(double screenWidth, List<String> items, List<String> companies, ScrollController controller, double minHeight, double minWidth) {
    return Expanded(
      child: Scrollbar(
        controller: controller,  // コントローラーを設定
        thumbVisibility: true,  // スクロールバーを表示
        child: Listener(
          // スクロールの方向を感知する
          onPointerSignal: (pointerSignal) {
            if (pointerSignal is PointerScrollEvent) {
              final newOffset = controller.offset + pointerSignal.scrollDelta.dx;
              controller.jumpTo(newOffset.clamp(0.0, controller.position.maxScrollExtent));
            }
          },
          child: GestureDetector(
            // 水平ドラッグ（横方向にドラッグ）で動くようにする
            onHorizontalDragUpdate: (details) {
              controller.position.moveTo(controller.offset - details.primaryDelta!);
            },
            child: ListView.builder(
              controller: controller,  // コントローラーを設定
              scrollDirection: Axis.horizontal,  // 横にスクロールする
              itemCount: items.length,  // リストの要素の数
              itemBuilder: (context, index) {
                final parts = items[index].split('×');
                final part1 = parts.length > 0 ? parts[0] : '';
                final part2 = parts.length > 1 ? '×' : '';
                final part3 = parts.length > 1 ? parts[1] : '';

                return InkWell(
                  // カードがタップされたときの処理
                  onTap: () => print('${items[index]} タップされました'),
                  child: Card(
                    // カードの中身
                    child: Container(
                      width: screenWidth * 0.25, 
                      constraints: BoxConstraints(
                        minHeight: minHeight,  // 最小の高さを設定
                        minWidth: minWidth,  // 最小の幅を設定
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 10, 0, 13),
                                child: Container(
                                  width: screenWidth * 0.24,
                                  height: 180,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey, width: 1,
                                    )
                                  ),
                                  child: Image.asset(
                                    'assets/images/img${index % 10 + 1}.png', // 画像
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 10), // アイコンの左にパディングを追加
                                child: Icon(Icons.account_circle, size: 50),  // アイコン
                              ),
                              SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: screenWidth * 0.15,
                                    child: AutoSizeText(
                                      part1,
                                      style: TextStyle(fontSize: 16),
                                      maxLines: 1,
                                      minFontSize: 8,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Container(
                                    width: screenWidth * 0.15,
                                    alignment: Alignment.center,
                                    child: AutoSizeText(
                                      part2,
                                      style: TextStyle(fontSize: 16),
                                      maxLines: 1,
                                      minFontSize: 8,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Container(
                                    width: screenWidth * 0.15,
                                    child: AutoSizeText(
                                      part3,
                                      style: TextStyle(fontSize: 16),
                                      maxLines: 1,
                                      minFontSize: 8,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(companies[index], style: TextStyle(fontSize: 12, color: Colors.grey)),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 2),
                          // 日付と時刻
                          Text(DateFormat('yyyy/MM/dd HH:mm:ss').format(DateTime.now()), style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                    margin: EdgeInsets.all(10),  // カードの周りに余白を設定
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

// スコア用のウィジェット
Widget buildScore(IconData icon, int count) {
  return Row(
    children: <Widget>[
      Icon(icon, color: Colors.blue),
      SizedBox(width: 4),
      Text('$count'),
    ],
  );
}


// import 'package:flutter/material.dart';
// // タッチ操作用パッケージ ：Webアプリ用にタッチ操作をするためにインポート
// import 'package:flutter/gestures.dart';
// import 'package:intl/intl.dart';
// import 'package:yaonukabase004/sns_channel_test.dart';

// // 横にスクロールできるカードリストを作るクラス
// class CustomCardList extends StatefulWidget {
//   final List<String> titles;  // カードのタイトルを入れるためのリスト

//   // コンストラクタ（クラスを作るときに使う関数）
//   const CustomCardList({
//     Key? key,
//     required this.titles,  // 必要な引数 titles
//   }) : super(key: key);

//   // 状態を管理するクラスの作成
//   @override
//   _CustomCardListState createState() => _CustomCardListState();
// }

// // 状態を管理するクラス
// class _CustomCardListState extends State<CustomCardList> {
//   late final ScrollController titleController;

//   @override
//   void initState() {
//     super.initState();
//     // スクロールを管理するためのコントローラー
//     titleController = ScrollController();
//   }

//   // クラスが削除されるときに呼ばれる
//   @override
//   void dispose() {
//     // メモリの無駄遣いを避けるためにコントローラーを破棄
//     titleController.dispose();
//     super.dispose();
//   }

//   // 画面を作るときに呼ばれる
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;  // 画面の幅
//     final minHeight = 200.0;  // 最小の高さを200に設定
//     final minWidth = 200.0;  // 最小の幅を200に設定

//     // 縦に並ぶ要素をまとめたコンテナ
//     return Container(
//       height: MediaQuery.of(context).size.height * 0.4,  // 高さは画面の40%に設定
//       constraints: BoxConstraints(
//         minHeight: minHeight,  // 最小の高さを設定
//       ),
//       child: Column(
//         children: [
//           // 横にスクロールできるリストを作る
//           buildList(screenWidth, widget.titles, titleController, minHeight, minWidth),
//         ],
//       ),
//     );
//   }

//   // 横にスクロールできるリストを作る関数
//   Widget buildList(double screenWidth, List<String> items, ScrollController controller, double minHeight, double minWidth) {
//     return Expanded(
//       child: Scrollbar(
//         controller: controller,  // コントローラーを設定
//         thumbVisibility: true,  // スクロールバーを表示
//         child: Listener(
//           // スクロールの方向を感知する
//           onPointerSignal: (pointerSignal) {
//             if (pointerSignal is PointerScrollEvent) {
//               final newOffset = controller.offset + pointerSignal.scrollDelta.dx;
//               controller.jumpTo(newOffset.clamp(0.0, controller.position.maxScrollExtent));
//             }
//           },
//           child: GestureDetector(
//             // 水平ドラッグ（横方向にドラッグ）で動くようにする
//             onHorizontalDragUpdate: (details) {
//               controller.position.moveTo(controller.offset - details.primaryDelta!);
//             },
//             child: ListView.builder(
//               controller: controller,  // コントローラーを設定
//               scrollDirection: Axis.horizontal,  // 横にスクロールする
//               itemCount: items.length,  // リストの要素の数
//               itemBuilder: (context, index) {
//                 return InkWell(
//                   // カードがタップされたときの処理
//                   onTap: () => print('${items[index]} タップされました'),
//                   child: Card(
//                     // カードの中身
//                     child: Container(
//                       width: screenWidth * 0.25, 
//                       constraints: BoxConstraints(
//                         minHeight: minHeight,  // 最小の高さを設定
//                         minWidth: minWidth,  // 最小の幅を設定
//                       ),
//                       child: Column(
//                         children: [
//                            Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.fromLTRB(0, 10, 0, 13),
//                                 child: Container(
//                                   width: screenWidth * 0.24,
//                                   height: 180,
//                                   decoration: BoxDecoration(
//                                     border: Border.all(
//                                       color: Colors.grey, width: 1,
//                                     )
//                                   ),
//                                   child: Image.asset(
//                                     'assets/images/bottomimage.png', //画像
//                                     fit: BoxFit.cover,
//                                   ),
//                                 ),
//                               )
//                             ],
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.only(left: 10), // アイコンの左にパディングを追加
//                                 child: Icon(Icons.account_circle, size: 50),  // アイコン
//                               ),
//                               SizedBox(width: 10),
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(items[index], style: TextStyle(fontSize: 20)),
//                                   Text('株式会社ABC', style: TextStyle(fontSize: 16, color: Colors.grey)),
//                                 ],
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: 2),
//                           // 日付と時刻
//                           Text(DateFormat('yyyy/MM/dd HH:mm:ss').format(DateTime.now()), style: TextStyle(color: Colors.grey)),
//                         ],
//                       ),
//                     ),
//                     margin: EdgeInsets.all(10),  // カードの周りに余白を設定
//                   ),
//                 );
//               },
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// // スコア用のウィジェット
// Widget buildScore(IconData icon, int count) {
//   return Row(
//     children: <Widget>[
//       Icon(icon, color: Colors.blue),
//       SizedBox(width: 4),
//       Text('$count'),
//     ],
//   );
// }

