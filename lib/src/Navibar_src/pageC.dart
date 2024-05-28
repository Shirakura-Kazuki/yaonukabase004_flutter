
import 'package:flutter/material.dart';
import 'package:yaonukabase004/src/Card/card.dart';
import 'package:yaonukabase004/src/Card/card1.dart';
import 'package:yaonukabase004/src/Card/card2.dart';

class page_c extends StatelessWidget {

    final List<String> titles = [
  '自動洗浄食器',
  'スマート買い物リスト',
  '自動植物給水器',
  'バーチャルワードローブアシスタント',
  '音声操作ホームアシスタント',
  'ソーラーパワーバックパック',
  'ポータブルワークアウトステーション',
  'スマートアラーム時計',
  '瞬間言語翻訳機',
  'エコフレンドリー包装'
];

final List<String> genres = [
  '家庭の改善',
  'ライフスタイル',
  'ガーデニング',
  'ファッション',
  'テクノロジー',
  '旅行',
  'フィットネス',
  '健康',
  'コミュニケーション',
  '持続可能性'
];

final List<String> ideaContents = [
  '使用後に自動で洗浄される食器。',
  'レシピに基づいて自動的に買い物リストを生成するアプリ。',
  '植物に最適なタイミングで給水するデバイス。',
  '服の選択やワードローブの管理を支援するアプリ。',
  '音声コマンドに応答するホームアシスタント。',
  'ソーラーエネルギーでデバイスを充電するバックパック。',
  'どこでもワークアウトができるコンパクトなポータブルステーション。',
  '睡眠サイクルに基づいて起床時間を調整するアラーム時計。',
  '話した言葉を瞬時に翻訳するハンドヘルドデバイス。',
  '廃棄物を減らすための生分解性材料で作られた包装。'
];

final List<String> photoUrls = [
  'assets/images/veg1.png',
  'assets/images/veg2.png',
  'assets/images/veg3.png',
  'assets/images/veg4.png',
  'assets/images/veg5.png',
  'assets/images/veg6.png',
  'assets/images/veg7.png',
  'assets/images/veg8.png',
  'assets/images/veg9.png',
  'assets/images/veg10.png'
];


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
                HorizontalCardList(
                  titles: titles, 
                  genres: genres, 
                  ideaContents: ideaContents, 
                  photoUrls: photoUrls
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