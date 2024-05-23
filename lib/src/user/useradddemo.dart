import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:yaonukabase004/firebase_options.dart';
import 'package:yaonukabase004/src/user/addpage.dart';

// メイン関数：Firebase SDK（認証やデータベースなど機能ライブラリ）の追加
void main() async {
  // １．【Flutterエンジン】の初期化しサービスを正しく使うため：１．Dartコードをネイティブコード（AndroidやiOSのコード）に変換
  WidgetsFlutterBinding.ensureInitialized();
   // ２．【Firebase SDK】の初期化：２．Firebaseサービスを利用するための機能
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

//アプリのルートクラス
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const UserAddPageA(),
    );
  }
}

// 新規ユーザー登録ページデザイン・機能の定義
class UserAddPageA extends StatefulWidget {
  const UserAddPageA({super.key});

  @override
  State<UserAddPageA> createState() => _UserAddPageAState();
}

// 新規ユーザー登録ページデザイン・機能の状態管理
class _UserAddPageAState extends State<UserAddPageA> {
  String _email = '';
  String _password = '';
  String? _uid;

  double? _deviceWidth, _deviceHeight;

  @override
  Widget build(BuildContext context) {
    _deviceWidth = MediaQuery.of(context).size.width;
    _deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.deepOrange.shade100,
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.all(24),
              width: max(_deviceWidth! * 0.4, 330),
              height: _deviceHeight! * 0.8,
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  const Text(
                    '新規登録画面',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      _uid == null ? 'UserID作成中' : 'あなたのUIDは $_uid です',
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  //  firebase送信トリガ
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: _deviceWidth! * 0.25,
                      child: ElevatedButton(
                        child: const Text('新規作成'),
                        style: ElevatedButton.styleFrom(  //ボタンのスタイル定義
                          backgroundColor: Colors.deepOrange.shade400,  //背景色
                          foregroundColor: Colors.white,  //Text色
                          shape: RoundedRectangleBorder(  //ボタンの形状
                            borderRadius: BorderRadius.circular(0), //角を丸くする半径の設定
                          ),
                        ),
                        // ボタンが押されたときの処理：非同期関数
                        onPressed: () async {
                          // エラーハンドリング
                          try {
                            // 新規ユーザーインスタンス作成：引数＝＞アドレス・パスワード#await処理
                            final UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                              email: _email,
                              password: _password,
                            );
                            // ユーザーインスタンスをuser変数に格納
                            final User? user = userCredential.user;
                            // NULLチェック
                            if (user != null) { //ユーザー情報の生成成功
                              print("ユーザ登録しました ${user.email} , ${user.uid}");
                              setState(() {
                                _uid = user.uid;
                              });
                              print('ユーザー登録をするUIDは: $_uid');

                            } else { //ユーザー情報の生成失敗
                              print("ユーザー登録に失敗しました。");
                            }
                          } catch (e) { //エラーキャッチ時（通信エラーや無効なメールアドレス等）
                            print(e);
                          }
                        },
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        child: const Text('アカウントをお持ちの方はこちら'),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.cyan.shade600,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
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



