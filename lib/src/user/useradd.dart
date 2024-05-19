import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:yaonukabase004/firebase_options.dart';
import 'package:yaonukabase004/src/user/addpage.dart';
// import 'package:yaonukabase004/homepage.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
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
      home: const UserAddPage(),
    );
  }
}

class UserAddPage extends StatefulWidget {
  const UserAddPage({super.key, });
  
  @override
  State<UserAddPage> createState() => _UserAddPageState();
}

class _UserAddPageState extends State<UserAddPage> {
  // 入力したメールアドレス・パスワード
  String _email = '';
  String _password = '';
 // firebaseのUIDを格納 
  String _uid_num = '';

  // 画面の大きさを格納する変数
  double? _deviceWidth , _deviceHeight;


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
            color: Colors.deepOrange.shade100,
          ),

          Center(
            child: Container(
              padding: const EdgeInsets.all(24),
              width: max(_deviceWidth!*0.4, 330), //containerの幅が画面幅の80％か430ピクセルの内大きい方が採用される
              height: _deviceHeight! *0.8,
              color: Colors.white,


              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text('新規登録画面',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  //topページロゴ画像
                  Container(
                    width: _deviceHeight!*0.35,
                    height: _deviceHeight!*0.2,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/toplogo.png',
                        ),
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),

                  // 1行目 メールアドレス入力用テキストフィールド
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration:  InputDecoration(
                        labelText: 'メールアドレス',
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(
                            color: Colors.black,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
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
                      decoration:  InputDecoration(
                        labelText: 'パスワード',
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(
                            color: Colors.black,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
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
                  Padding( padding: const EdgeInsets.all(8.0),
                      child:SizedBox(
                      width: _deviceWidth!*0.25,
                        child: ElevatedButton(
                          child: const Text('新規作成'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepOrange.shade400,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0)
                            )
                            ),
                          onPressed: () async {
                            try {
                              final User? user = (await FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                      email: _email, password: _password))
                                  .user;
                              if (user != null) {
                                print("ユーザ登録しました ${user.email} , ${user.uid}");  //確認用テキスト
                                setState(() {
                                  _uid_num = user.uid;  // UIDを状態変数に保存
                                });
                                // UIDを送信する処理を行う
                                print('ユーザー登録をするUIDは:$_uid_num');

                                // 確認ページへ遷移
                                // Navigator.push(context, MaterialPageRoute(builder: (context) => AddConPage()));
                              } else {
                                print("ユーザー登録に失敗しました。");
                              }
                            } catch (e) {
                              print(e);
                            }
                          },
                        ),
                      )
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // ユーザ登録ボタン
                      TextButton(
                        child: const Text('アカウントをお持ちの方はこちら'),
                        style:TextButton.styleFrom(
                          foregroundColor: Colors.cyan.shade600,
                        ),
                        onPressed: ()  {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ] 
      )
    );
  }
}
