import 'package:flutter/material.dart';
import 'package:yaonukabase004/src/newUser/login.dart';
import 'package:yaonukabase004/src/newUser/selectnew.dart';

class CreateNew extends StatefulWidget {
  const CreateNew({super.key});

  @override
  State<CreateNew> createState() => _CreateNewState();
}

class _CreateNewState extends State<CreateNew> {
  double? _deviceWidth, _deviceHeight;

  @override
  Widget build(BuildContext context) {
    _deviceWidth = MediaQuery.of(context).size.width;
    _deviceHeight = MediaQuery.of(context).size.height;
    double customWidth = 420;
    double customHeight = 200;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.red.shade100,
        ),
        child: Center(
          child: Container(
            width: _deviceWidth! * 0.9,
            height: _deviceHeight! * 0.9,
            color: Colors.white,
            constraints: BoxConstraints(
              minWidth: 400,
              minHeight: _deviceHeight! * 0.9,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/toplogo.png',
                  width: customWidth,
                  height: customHeight,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 38,),
                Text('アカウントの作成はこちら▼',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: Colors.lightBlue.shade400,  
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 25),
                  child: SizedBox(
                    width: 370,
                    height: 70,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => selectnew()),
                          );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: Colors.red, // ボタンの背景色を赤に設定
                      ),
                      child: const Text(
                        '新規作成',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'アカウントをお持ちの方はこちら',
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                SizedBox(height: 30), // スペースを追加
                Image.asset(
                  'assets/images/bottomimage.png',
                  width: 150, // 適切な幅を設定
                  height: 150, // 適切な高さを設定
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
