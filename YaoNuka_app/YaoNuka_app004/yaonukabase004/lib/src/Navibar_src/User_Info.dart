import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class User_Info extends StatefulWidget {
  const User_Info({super.key});

  @override
  State<User_Info> createState() => _User_InfoState();
}

class _User_InfoState extends State<User_Info> {
  double? _deviceWidth, _deviceHeight;

  @override
  Widget build(BuildContext context) {
    // 画面の大きさを取得する
    _deviceWidth = MediaQuery.of(context).size.width;
    _deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: _deviceWidth,
                  height: _deviceHeight! * 0.35,
                  color: Colors.white,
                  child: Center(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                          child: Text(
                            'マイページ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                        ),
                        Container(
                          height: 180,
                          width: 180,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Image.asset(
                            'assets/images/icon_sample.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'ユーザー名', // ユーザーごとに変更する（変数管理）
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ]
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: _deviceWidth,
                  height: _deviceHeight! * 0.2,
                  color: Colors.lightBlue.shade900,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          '所持ポイント',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: Colors.white
                          ),
                        ),
                        SizedBox(height: 10),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '1000',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 36,
                                color: Colors.white
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'P',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.white
                                ),
                              ),
                            )
                          ],
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: 400,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50)
                          ),
                          child: Text(
                            '〇〇〇と交換する',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Scrollbar(
              child: Container(
                width: _deviceWidth,
                height: _deviceHeight! * 0.3,
                color: Colors.white,
                child: ListView(
                  itemExtent: 60, // 高さを適切に調整
                  children: [
                    Divider(),
                    buildInkWell(context, 'アカウントの設定', Icons.navigate_next, 'アカウント'),
                    Divider(),
                    buildInkWell(context, 'ポイント履歴', Icons.navigate_next, 'ポイント履歴'),
                    Divider(),
                    buildInkWell(context, 'お知らせ', Icons.navigate_next, 'お知らせ'),
                    Divider(),
                    buildInkWell(context, 'その他機能', Icons.navigate_next, 'その他機能'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInkWell(BuildContext context, String title, IconData icon, String printText) {
    print('関数が実行されました');
    return InkWell(
      onTap: () {
        print('選択されたテキストは:$printText');
      },
      splashColor: Colors.amber, // タップ時のスプラッシュカラー
      child: ListTile(
        leading: Icon(icon),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
    );
  }
}
