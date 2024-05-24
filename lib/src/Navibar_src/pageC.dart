import 'package:flutter/material.dart';
import 'package:yaonukabase004/src/Card/card1.dart';

class page_c extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 画面描画
    return Scaffold(  
      body: SingleChildScrollView(  //画面より大きい場合スクロールする
        scrollDirection: Axis.vertical, //垂直方向にスクロール
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: //Center(
            Column(
            //child: Column(
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
                
                // Padding(
                //   padding: const EdgeInsets.fromLTRB(25, 10, 0, 0),
                //   child: Text('【検索項目】',
                //     style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),
                //   ),),
                  const Divider(
                    height: 40,
                  ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 0, 5),
                  child: Text('企業リスト',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                HorizontalCardListSKV(
                  titles: List.generate(10, (index) => '企業名 $index'),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 5, 0, 5),
                  child: Text('過去の事例リスト',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                HorizontalCardListSKV(
                  titles: List.generate(10, (index) => 'ユーザー名 $index'),
                ),
              ],
            ),
          //),
        ),
      ),
    );
  }
}