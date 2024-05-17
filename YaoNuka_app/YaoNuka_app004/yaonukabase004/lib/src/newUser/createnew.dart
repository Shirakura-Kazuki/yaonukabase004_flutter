import 'package:flutter/material.dart';

class createNew extends StatefulWidget {
  
  const createNew({super.key});

  @override
  State<createNew> createState() => _createNewState();
}

class _createNewState extends State<createNew> {
  // 画面の大きさを格納する変数
  double? _deviceWidth , _deviceHeight;

  @override
  Widget build(BuildContext context) {
     // 画面の大きさを取得する
    _deviceWidth = MediaQuery.of(context).size.width;
    _deviceHeight = MediaQuery.of(context).size.height;
    // 画像を特定のサイズで表示するための変数(アスペクト比の保持を追加)
    double customWidth = 420;
    double customHeight = 200;

    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.red.shade100,
              ),
            ),
            //白色背景表示
            Center(
              child: Container(
                width: _deviceWidth! * 0.9,
                height: _deviceHeight! *0.9,
                color: Colors.white,
                constraints: BoxConstraints(
                  minWidth: 400,
                  minHeight: _deviceHeight!*0.9
                ),
                child: Center(
                  // Image ウィジェットを使って画像を任意のサイズで配置
                  child:Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/toplogo.png',
                        width: customWidth,
                        height: customHeight,
                        fit: BoxFit.fill,  // ここでBoxFit.fillを使って画像をコンテナにフィットさせる
                      ),
                      Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: SizedBox(
                          width: 370,
                          height: 70,
                          child: ElevatedButton(
                            onPressed: (){},
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              )
                            ),
                            child: const Text('新規登録')),
                        ),
                      )
                    ],
                  ), 
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}