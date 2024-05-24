import 'package:flutter/material.dart';
import 'package:yaonukabase004/src/Navibar_src/pageA.dart';
import 'package:yaonukabase004/src/Navibar_src/pageB.dart';
import 'package:yaonukabase004/src/Navibar_src/pageC.dart';
import 'package:yaonukabase004/src/Navibar_src/pageD.dart';
import 'package:yaonukabase004/src/Navibar_src/User_Info.dart';




class NaviApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5, // タブの数
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'HOME'),  //a
              Tab(text: 'YAONUKA投稿'), //b
              Tab(text: 'NUKABASE'),  //c
              Tab(text: 'MyNUKA'),  //d
              Tab(text: 'User情報'),  //User_Info
            ],
          ),
          title:Image.asset(
            'assets/images/toplogo.png',
            width: 100,
            height: 100,
          )
        ),
        body:  TabBarView(
          // ナビゲーションバースワイプ操作無効
          physics: NeverScrollableScrollPhysics(),
          children: [
            PageA(),
            // HorizontalCardListWithButton(),
            page_b(),
            page_c(),
            page_d(),
            User_Info(),
          ],
        ),
      ),
    );
  }
}

