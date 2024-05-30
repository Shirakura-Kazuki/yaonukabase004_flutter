
// widget:カード型デザイン（横スクロール※Webアプリ対応）
// -カスタムwidget名
// HorizontalCardList()
// -引数
// titles: List.generate(10, (index) => 'タイトル $index'),　//10個の要素（テキスト：タイトル0~9）
// genres: List.generate(10, (index) => 'ジャンル $index'),　//10個の要素（テキスト：ジャンル0~9）
//



import 'package:flutter/material.dart';
// タッチ操作用パッケージ ：Webアプリ用にタッチ操作をするためにインポート
import 'package:flutter/gestures.dart';
import 'package:intl/intl.dart';

// 横にスクロールできるカードリストを作るクラス
class HorizontalCardListSKV extends StatefulWidget {
  final List<String> titles;  // カードのタイトルを入れるためのリスト

  // コンストラクタ（クラスを作るときに使う関数）
  const HorizontalCardListSKV({
    Key? key,
    required this.titles,  // 必要な引数 titles
  }) : super(key: key);

  // 状態を管理するクラスの作成
  @override
  _HorizontalCardListSKVState createState() => _HorizontalCardListSKVState();
}

// 状態を管理するクラス
class _HorizontalCardListSKVState extends State<HorizontalCardListSKV> {
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
      height: MediaQuery.of(context).size.height * 0.4,  // 高さは画面の40%に設定
      constraints: BoxConstraints(
        minHeight: minHeight,  // 最小の高さを設定
      ),
      child: Column(
        children: [
          // 横にスクロールできるリストを作る
          buildList(screenWidth, widget.titles, titleController, minHeight, minWidth),
        ],
      ),
    );
  }

  // 横にスクロールできるリストを作る関数
  Widget buildList(double screenWidth, List<String> items, ScrollController controller, double minHeight, double minWidth) {
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
                return InkWell(
                  // カードがタップされたときの処理
                  onTap: () => print('${items[index]} タップされました'),
                  child: Card(
                    // カードの中身
                    child: Container(
                      width: screenWidth * 0.13, 
                      constraints: BoxConstraints(
                        minHeight: minHeight,  // 最小の高さを設定
                        minWidth: minWidth,  // 最小の幅を設定
                      ),
                      // // 中央にタイトルを表示
                      // child: Center(child: Text(items[index])),
                      child: Column(
                        children: [
                          // アイコンとタイトル
                          Row(
                            children: <Widget>[
                              Icon(Icons.account_circle, size: 50),  // アイコン
                              SizedBox(width: 10),
                              Expanded(child: Text(items[index], style: TextStyle(fontSize: 20))),
                            ],
                          ),
                          // アイデア内容と写真
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('アイデア内容'),

                              Padding(
                                padding: const EdgeInsets.fromLTRB(10, 20, 0, 20),
                                child: Container(
                                  width: 85,
                                  height: 85,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black,width: 2,
                                    )
                                  ),
                                  child: Text('写真'),
                                ),
                              )
                            ],
                          ),
                          // スコア表示
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              // いいね
                              buildScore(Icons.thumb_up, 15),
                              
                              // 通話
                              buildScore(Icons.phone, 15),
                              // チェック
                              buildScore(Icons.check, 15),
                            ],
                          ),
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
