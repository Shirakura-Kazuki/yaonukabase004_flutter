// import 'package:flutter/material.dart';
// //タイマー機能追加
// import 'dart:async';

// import 'package:yaonukabase004/main.dart';

// class AddConPage extends StatefulWidget {
//   const AddConPage({super.key});

//   @override
//   State<AddConPage> createState() => _AddConPageState();
// }

// class _AddConPageState extends State<AddConPage> {
//   //タイマー機能追加
//   Timer? timer;
//   @override
//   void initState(){
//     super.initState();

//     //Timerインスタンス
//     timer = Timer(
//       const Duration(seconds: 2),
//       (){
//         //タイマー後コールバック関数
//         Navigator.push(context,
//          MaterialPageRoute(
//           builder: (context) => const MyHomePage()));
//       }
//     );\
//   }

//   @override
//   void dispose(){
//     super.dispose();
//     timer?.cancel();
//   }
//   //UIデザイン用のビルドメソッド
//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       body: Center(
//         child: Column(
//           children: [
//             Text('アカウント作成が完了しました'),
//             Text('ログインしてください'),
//           ],
//         ),
//       )
//     );
//   }
// }