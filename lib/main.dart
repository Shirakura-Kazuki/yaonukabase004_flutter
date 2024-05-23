import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:yaonukabase004/firebase_options.dart';
import 'package:yaonukabase004/src/Navibar_src/form.dart';
import 'package:yaonukabase004/src/newUser/createnew.dart';
import 'package:yaonukabase004/src/newUser/login.dart';
import 'package:yaonukabase004/src/newUser/roleoption/useradd.dart';
import 'package:yaonukabase004/src/user/useradddemo.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
      title: 'Crafts Connect',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      // home: const MyHomePage( ),  //本番環境
      // home: NaviApp(),
      //開発環境用:ホームを設定する
      home: LoginPage(), // ログインページに変更
      // home: form_page(),
      // home: UserAddPage(),
    );
  }
}

