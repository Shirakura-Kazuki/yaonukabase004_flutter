import 'package:flutter/material.dart';
import 'package:yaonukabase004/src/newUser/login.dart';
import 'package:yaonukabase004/src/newUser/roleoption/compadd.dart';
import 'package:yaonukabase004/src/newUser/roleoption/coordinator.dart';
import 'package:yaonukabase004/src/newUser/roleoption/useradd.dart';
import 'package:yaonukabase004/src/user/useradddemo.dart';
import 'package:yaonukabase004/main.dart'; // ここでMyAppのパスをインポート

class selectnew extends StatefulWidget {
  const selectnew({super.key});

  @override
  State<selectnew> createState() => _selectnewState();
}

class _selectnewState extends State<selectnew> {
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
                Text('▼ログインページに戻る'),
                GestureDetector(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()), // MyAppに遷移
                      (Route<dynamic> route) => false,
                    );
                  },
                  child: Image.asset(
                    'assets/images/toplogo.png',
                    width: customWidth,
                    height: customHeight,
                    fit: BoxFit.contain,
                  ),
                ), // ここに変更点
                SizedBox(height: 28,),
                Text('アカウントタイプを選択してください▼',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: Colors.lightBlue.shade400,  
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 13),
                  child: SizedBox(
                    width: 370,
                    height: 70,
                    child: ElevatedButton(
                      onPressed: () {
                         Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => UserAddPage()),
                          );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: Colors.red, // ボタンの背景色を赤に設定
                      ),
                      child: const Text(
                        '一般ユーザー',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 13, 0, 13),
                  child: SizedBox(
                    width: 370,
                    height: 70,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => CompaddPage()),
                          );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: Colors.red, // ボタンの背景色を赤に設定
                      ),
                      child: const Text(
                        '企業',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 13, 0, 13),
                  child: SizedBox(
                    width: 370,
                    height: 70,
                    child: ElevatedButton(
                      onPressed: () {
                         Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Coordinator()),
                          );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: Colors.red, // ボタンの背景色を赤に設定
                      ),
                      child: const Text(
                        'コーディネーター',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:yaonukabase004/src/newUser/login.dart';
// import 'package:yaonukabase004/src/newUser/roleoption/compadd.dart';
// import 'package:yaonukabase004/src/newUser/roleoption/coordinator.dart';
// import 'package:yaonukabase004/src/newUser/roleoption/useradd.dart';
// import 'package:yaonukabase004/src/user/useradddemo.dart';

// class selectnew extends StatefulWidget {
//   const selectnew({super.key});

//   @override
//   State<selectnew> createState() => _selectnewState();
// }

// class _selectnewState extends State<selectnew> {
//   double? _deviceWidth, _deviceHeight;

//   @override
//   Widget build(BuildContext context) {
//     _deviceWidth = MediaQuery.of(context).size.width;
//     _deviceHeight = MediaQuery.of(context).size.height;
//     double customWidth = 420;
//     double customHeight = 200;

//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           color: Colors.red.shade100,
//         ),
//         child: Center(
//           child: Container(
//             width: _deviceWidth! * 0.9,
//             height: _deviceHeight! * 0.9,
//             color: Colors.white,
//             constraints: BoxConstraints(
//               minWidth: 400,
//               minHeight: _deviceHeight! * 0.9,
//             ),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Image.asset(
//                   'assets/images/toplogo.png',
//                   width: customWidth,
//                   height: customHeight,
//                   fit: BoxFit.contain,
//                 ),
//                  SizedBox(height: 28,),
//                 Text('アカウントタイプを選択してください▼',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 17,
//                     color: Colors.lightBlue.shade400,  
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(0, 20, 0, 13),
//                   child: SizedBox(
//                     width: 370,
//                     height: 70,
//                     child: ElevatedButton(
//                       onPressed: () {
//                          Navigator.push(
//                             context,
//                             MaterialPageRoute(builder: (context) => UserAddPage()),
//                           );
//                       },
//                       style: ElevatedButton.styleFrom(
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         backgroundColor: Colors.red, // ボタンの背景色を赤に設定
//                       ),
//                       child: const Text(
//                         '一般ユーザー',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(0, 13, 0, 13),
//                   child: SizedBox(
//                     width: 370,
//                     height: 70,
//                     child: ElevatedButton(
//                       onPressed: () {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(builder: (context) => CompaddPage()),
//                           );
//                       },
//                       style: ElevatedButton.styleFrom(
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         backgroundColor: Colors.red, // ボタンの背景色を赤に設定
//                       ),
//                       child: const Text(
//                         '企業',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(0, 13, 0, 13),
//                   child: SizedBox(
//                     width: 370,
//                     height: 70,
//                     child: ElevatedButton(
//                       onPressed: () {
//                          Navigator.push(
//                             context,
//                             MaterialPageRoute(builder: (context) => coordinator()),
//                           );
//                       },
//                       style: ElevatedButton.styleFrom(
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         backgroundColor: Colors.red, // ボタンの背景色を赤に設定
//                       ),
//                       child: const Text(
//                         'コーディネーター',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
