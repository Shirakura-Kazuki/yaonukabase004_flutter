import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yaonukabase004/src/Navibar_src/PageNavi.dart';
import 'package:yaonukabase004/src/user/useradd.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // 入力したメールアドレス・パスワード
  String _email = '';
  String _password = '';
  // firebaseのUIDを格納 
  String _uid_num = '';
  // 画面の大きさを格納する変数
  double? _deviceWidth, _deviceHeight;

  @override
  Widget build(BuildContext context) {
    // 画面の大きさを取得する
    _deviceWidth = MediaQuery.of(context).size.width;
    _deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.grey.shade200,
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.all(24),
              width: max(_deviceWidth! * 0.4, 330), //containerの幅が画面幅の80％か430ピクセルの内大きい方が採用される
              height: _deviceHeight! * 0.8,
              color: Colors.white,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  //topページロゴ画像
                  Container(
                    width: _deviceHeight! * 0.35,
                    height: _deviceHeight! * 0.2,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/toplogo.png'),
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                  // 1行目 メールアドレス入力用テキストフィールド
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'メールアドレス',
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(
                            color: Colors.black,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      ),
                      onChanged: (String value) {
                        setState(() {
                          _email = value;
                        });
                      },
                    ),
                  ),
                  // 2行目 パスワード入力用テキストフィールド
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'パスワード',
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(
                            color: Colors.black,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      ),
                      obscureText: true,
                      onChanged: (String value) {
                        setState(() {
                          _password = value;
                        });
                      },
                    ),
                  ),
                  // 4行目 ログインボタン
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: _deviceWidth! * 0.25,
                      child: ElevatedButton(
                        child: const Text('ログインをします'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange.shade900,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () async {
                          try {
                            final UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                              email: _email,
                              password: _password,
                            );
                            final User? user = userCredential.user;
                            if (user != null) {
                              print("ログインしました ${user.email}, ${user.uid}");
                              setState(() {
                                _uid_num = user.uid; // 安全にUIDを取得
                                print('現在のユーザーのUIDは:$_uid_num');
                              });
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => NaviApp()),
                              );
                            } else {
                              print("ユーザーが見つかりません。");
                            }
                          } catch (e) {
                            print(e);
                          }
                        },
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('アカウントが未登録ですか？'),
                      // ユーザ登録ボタン
                      TextButton(
                        child: const Text('サインアップ'),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.cyan.shade600,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => UserAddPage()),
                          );
                        },
                      ),
                    ],
                  ),
                  // 区切り線（サイズ調整）
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: _deviceWidth! * 0.1,
                        child: Divider(),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: const Text('または'),
                      ),
                      SizedBox(
                        width: _deviceWidth! * 0.1,
                        child: Divider(),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 22, 0, 0),
                    child: Container(
                      width: _deviceWidth! * 0.7,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: Image.asset(
                              'assets/images/google_logo_icon.png',
                              width: _deviceWidth! * 0.02,
                              height: _deviceHeight! * 0.02,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Googleで続ける'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
