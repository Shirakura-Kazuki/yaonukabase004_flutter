import 'package:flutter/material.dart';
import 'package:yaonukabase004/src/Card/card2.dart';
import 'package:yaonukabase004/src/Navibar_src/form.dart';


class page_b extends StatefulWidget {
  const page_b({super.key});

  @override
  State<page_b> createState() => _page_bState();
}

class _page_bState extends State<page_b> {
  @override
  Widget build(BuildContext context) {
   
    return Scaffold(  
      body: SingleChildScrollView(  //画面より大きい場合スクロールする
        scrollDirection: Axis.vertical, //垂直方向にスクロール
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
                        padding: EdgeInsets.symmetric(horizontal: 8), // 水平方向に8ピクセルのパディングを追加
                        color: Colors.grey.shade700, // テキストの背景色
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
                        padding: EdgeInsets.symmetric(horizontal: 8), // 水平方向に8ピクセルのパディングを追加
                        color: Colors.lightBlue.shade800, // テキストの背景色
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
                        padding: EdgeInsets.symmetric(horizontal: 8), // 水平方向に8ピクセルのパディングを追加
                        color: Colors.red.shade800, // テキストの背景色
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
                  titles: List.generate(10, (index) => 'ユーザー名 $index'),
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
          icon: Icon(Icons.add), // アイコンは無しでもOK
          label: Text('アイデア投稿',
          style: TextStyle(fontWeight: FontWeight.bold),
          ),
          onPressed: (){
            //アクション
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => form_page()), // TargetPageへ遷移
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, // ボタンを右下に配置
    );  
  }
}