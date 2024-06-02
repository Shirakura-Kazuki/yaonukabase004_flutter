import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yaonukabase004/providers/user_provider.dart';
import 'package:yaonukabase004/src/Card/card.dart';
import 'package:yaonukabase004/src/Card/card1.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PageA extends StatefulWidget {
  @override
  _PageAState createState() => _PageAState();
}

class _PageAState extends State<PageA> {
  // デモ用データ
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
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    await Provider.of<UserProvider>(context, listen: false).fetchUserData();
  }

  // Future<void> _fetchUserData() async {
  //   try {
  //     User? user = FirebaseAuth.instance.currentUser;
  //     if (user != null) {
  //       String uid = user.uid;
  //       print('現在ログインしているユーザのUID: $uid');

  //       final url = Uri.parse('https://guser.azurewebsites.net/api/get_user?userid=$uid');
  //       print('アクセスするURL: $url');

  //       final response = await http.get(
  //         url,
  //         headers: {'Content-Type': 'application/json'},
  //       );

  //       if (response.statusCode == 201) {
  //         final data = json.decode(response.body);
  //         print('APIレスポンス: ${response.body}');
  //         print('usertype: ${data['usertype']}');
  //         print('createdat: ${data['createdat']}');
  //         print('icon: ${data['icon']}');
  //         print('profile: ${data['profile']}');
  //         print('numberofpoints: ${data['numberofpoints']}');
  //         print('companyname: ${data['companyname']}');
  //       } else {
  //         print('APIリクエスト失敗: ${response.statusCode}');
  //         print('レスポンスボディ: ${response.body}');
  //       }
  //     } else {
  //       print('ユーザーがログインしていません');
  //     }
  //   } catch (e) {
  //     print('エラーが発生しました: $e');
  //   }
  // }

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(25, 10, 0, 0),
                child: Text('今すぐ確認',
                  style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),
                ),),
              const Divider(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 0, 5),
                child: Text('ピックアップアイデア',
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
                child: Text('CRAFTCONNECTS成功事例',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              HorizontalCardListSKV(
                titles: List.generate(10, (index) => '事例タイトル $index'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


