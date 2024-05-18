import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

class form_page extends StatefulWidget {
  const form_page({super.key});

  @override
  State<form_page> createState() => _form_pageState();
}

class _form_pageState extends State<form_page> {
  final TextEditingController _nameController = TextEditingController(); 
  final TextEditingController _conceptController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  double? _deviceWidth;
  String _tech1 = '未選択';
  String _tech2 = '未選択';
  String _tech3 = '未選択';
  String _userId = 'guest';
  late String _formattedDate;

  @override
  void initState() {
    super.initState();
    _formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    _initializeUser();
  }

  void _initializeUser() {
    final User? user = _auth.currentUser;
    setState(() {
      _userId = user?.uid ?? 'PEsrLPjXDOXnLqHTkYDFkIt2Fbo1';  //テスト用ユーザーID
    });
  }

  Future<void> _saveToDatabase() async {
    var body = json.encode({
      'ideaname': _nameController.text,
      'ideaconcept': _conceptController.text,
      'ideadate': _formattedDate,
      'ideaimage': '0xFFD8FFE000104A46494600010100000100010000FFE201D84943435F50524F46494C45000101000001C80000000004300000',
      'ideatechnology1': _tech1,
      'ideatechnology2': _tech2,
      'ideatechnology3': _tech3,
      'userid': 'PEsrLPjXDOXnLqHTkYDFkIt2Fbo1'
      // 'userid': _userId
    });

    print("Sending Data: $body");

    try {
      final response = await http.post(
        Uri.parse('https://craftsconnect.azurewebsites.net/api/create_idea_record'),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
      // 成功した場合、ダイアログを表示
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('送信されました'),
            content: Text('投稿ホームに戻ります'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // ダイアログを閉じる
                  Navigator.of(context).pop(); // 前のページに戻る
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      print("Error from the server: ${response.body}");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${response.body}')));
    }
  } catch (e) {
    print("Exception caught: $e");
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Exception: $e')));
  }
  }

  //ボタン活性化
  bool get _isFormValid {
      return _nameController.text.isNotEmpty &&
            _conceptController.text.isNotEmpty &&
            _tech1 != 'なし';
  }

  @override
  Widget build(BuildContext context) {
    _deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: 
        Text('アイデア投稿フォーム'),
        backgroundColor: Colors.red.shade100,
        ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              alignment: Alignment.center,
              width: _deviceWidth! * 0.65,
              constraints: BoxConstraints(
                minWidth: 400,
                maxWidth: 700,
              ),
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text('アイデア投稿フォーム',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      shadows: <Shadow>[
                        Shadow(
                          color: Colors.grey,
                          offset: Offset(5, 5),
                          blurRadius: 3,
                        )
                      ]
                    ),
                    ),
                  // アイデアネーム
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      color: Colors.brown.shade100,
                      child:Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
                          child: Text('①アイデアネーム（アイデアのタイトルは？）',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15
                              ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('[必須]', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ), 
                    ),
                  ),
                  
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'アイデアネームを入力',
                      labelStyle: TextStyle(color: Colors.grey[600]),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  
                  // アイデアコンセプト
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      color: Colors.brown.shade100,
                      child:Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
                          child: Text('②アイデアコンセプト（どんなアイデア？）',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15
                              ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('[必須]', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ), 
                    ),
                  ),
                  TextField(
                    controller: _conceptController,
                    decoration: InputDecoration(
                      labelText: 'アイデアコンセプトを入力',
                      labelStyle: TextStyle(color: Colors.grey[600]),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),

                
                  // テクノロジー選択1
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      color: Colors.brown.shade100,
                      child:Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
                          child: Text('③アイデア実現に必要なテクノロジー選択',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15
                              ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('[必須]', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ), 
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('アイデアテクノロジー１'),
                      ),
                      Text('[必須]', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                  buildDropdown(_tech1, 'アイデアテクノロジー１'),
                  SizedBox(height: 20),

                  // テクノロジー選択2
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('アイデアテクノロジー２'),
                      ),
                      Text('[任意]', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                  buildDropdown(_tech2, 'アイデアテクノロジー２（任意）'),
                  SizedBox(height: 20),

                  // テクノロジー選択3
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('アイデアテクノロジー３'),
                      ),
                      Text('[任意]', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                  buildDropdown(_tech3, 'アイデアテクノロジー３（任意）'),
                  SizedBox(height: 20),

                  // ユーザーID
                  Text('ユーザーID: $_userId'),
                  SizedBox(height: 30),
                    // 投稿時間
                  Text('投稿時間: $_formattedDate'),
                  SizedBox(height: 20),


                  // 送信ボタン
                  SizedBox(
                    width: 200,
                    height: 50,
                    child:ElevatedButton(
                      onPressed: _isFormValid ? _saveToDatabase : null, // 条件に基づく活性・非活性制御
                      child: Text('送信',
                      style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        // backgroundColor: Colors.deepPurple, // ボタンの背景色
                      ),
                    ), 
                  ),
                  
                ],
              ) ,
            ),
          ),
        ),
      ),
    );
  }

  DropdownButtonFormField<String> buildDropdown(String value, String label) {
    return DropdownButtonFormField(
      value: value,
      onChanged: (String? newValue) {
        if (newValue != null) {
          setState(() {
            switch (label) {
              case 'アイデアテクノロジー１':
                _tech1 = newValue;
                break;
              case 'アイデアテクノロジー２（任意）':
                _tech2 = newValue;
                break;
              case 'アイデアテクノロジー３（任意）':
                _tech3 = newValue;
                break;
            }
          });
        }
      },
      items: <String>['未選択','Tech1', 'Tech2', 'Tech3', 'Tech4', 'Tech5']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 2.0),
        ),
      ),
    );
  }
}




// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class form_page extends StatefulWidget {
//   const form_page({super.key});

//   @override
//   State<form_page> createState() => _form_pageState();
// }


// class _form_pageState extends State<form_page> {
//   final TextEditingController _nameController = TextEditingController();  //アイデアネーム入力テキスト
//   final TextEditingController _conceptController = TextEditingController(); //アイデアコンセプト入力テキスト
//   final FirebaseAuth _auth = FirebaseAuth.instance; //firebaseauthのユーザー情報取得

//    // 画面の大きさを格納する変数
//   double? _deviceWidth , _deviceHeight;

//   String _tech1 = 'Tech1';
//   String _tech2 = 'Tech1';
//   String _tech3 = 'Tech1';
//   String _userId = 'guest';
//   late String _formattedDate;

//   @override
//   //  initState()：一度だけ実行するメソッド
//   void initState() {
//     super.initState();
//     _formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
//     _initializeUser();
//   }

//   void _initializeUser() {
//     final User? user = _auth.currentUser;
//     setState(() {
//       _userId = user?.uid ?? 'guest';
//       _userId = _userId.toString();
//     });
//   }

//  Future<void> _saveToDatabase() async {
//   var body = json.encode({
//     'ideaname': _nameController.text,
//     'ideaconcept': _conceptController.text,
//     'ideadate': _formattedDate,
//     'ideaimage': '0xFFD8FFE000104A46494600010100000100010000FFE201D84943435F50524F46494C45000101000001C80000000004300000',
//     'ideatechnology1': _tech1,
//     'ideatechnology2': _tech2,
//     'ideatechnology3': _tech3,
//     'userid': _userId
//   });


//   // 送信データをコンソールに出力
//   print("Sending Data: $body");

//   try {
//     final response = await http.post(
//       Uri.parse('https://craftsconnect.azurewebsites.net/api/create_idea_record'),
//       headers: {'Content-Type': 'application/json'},
//       body: body,
//     );

//     if (response.statusCode == 201) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Idea added successfully')));
//     } else {
//       print("Error from the server: ${response.body}");
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${response.body}')));
//     }
//   } catch (e) {
//     print("Exception caught: $e");
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Exception: $e')));
//   }
// }


//   @override
//   Widget build(BuildContext context) {

//     // 画面の大きさを取得する
//     _deviceWidth = MediaQuery.of(context).size.width;
//     _deviceHeight = MediaQuery.of(context).size.height;

//   return Scaffold(
//       appBar: AppBar(title: Text('アイデア投稿フォーム')),
//       body: SingleChildScrollView(
//         child: Center(  // Center widget added here
//           child: Padding(
//             padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
//             child: Container(
//               alignment: Alignment.center,
//               width: MediaQuery.of(context).size.width * 0.65,  // デバイス幅の65%を使用
//               constraints: BoxConstraints(
//                 minWidth: 400,
//                 maxWidth: 700,
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: <Widget>[
//                   TextField(
//                     controller: _nameController,
//                     decoration: InputDecoration(
//                       labelText: 'アイデアネーム',
//                       border: OutlineInputBorder(),  
//                     ),
//                   ),
//                   TextField(
//                     controller: _conceptController,
//                     decoration: InputDecoration(labelText: 'アイデアコンセプト'),
//                   ),
//                   Text('投稿時間: $_formattedDate'),
//                   DropdownButtonFormField(
//                     value: _tech1,
//                     onChanged: (String? newValue) {
//                       if (newValue != null) {
//                         setState(() {
//                           _tech1 = newValue;
//                         });
//                       }
//                     },
//                     items: <String>['Tech1', 'Tech2', 'Tech3', 'Tech4', 'Tech5']
//                         .map<DropdownMenuItem<String>>((String value) {
//                       return DropdownMenuItem<String>(
//                         value: value,
//                         child: Text(value),
//                       );
//                     }).toList(),
//                     decoration: InputDecoration(labelText: 'アイデアテクノロジー１'),
//                   ),
//                   DropdownButtonFormField(
//                     value: _tech2,
//                     onChanged: (String? newValue) {
//                       if (newValue != null) {
//                         setState(() {
//                           _tech2 = newValue;
//                         });
//                       }
//                     },
//                     items: <String>['Tech1', 'Tech2', 'Tech3', 'Tech4', 'Tech5']
//                         .map<DropdownMenuItem<String>>((String value) {
//                       return DropdownMenuItem<String>(
//                         value: value,
//                         child: Text(value),
//                       );
//                     }).toList(),
//                     decoration: InputDecoration(labelText: 'アイデアテクノロジー２（任意）'),
//                   ),
//                   DropdownButtonFormField(
//                     value: _tech3,
//                     onChanged: (String? newValue) {
//                       if (newValue != null) {
//                         setState(() {
//                           _tech3 = newValue;
//                         });
//                       }
//                     },
//                     items: <String>['Tech1', 'Tech2', 'Tech3', 'Tech4', 'Tech5']
//                         .map<DropdownMenuItem<String>>((String value) {
//                       return DropdownMenuItem<String>(
//                         value: value,
//                         child: Text(value),
//                       );
//                     }).toList(),
//                     decoration: InputDecoration(labelText: 'アイデアテクノロジー３（任意）'),
//                   ),
//                   Text('ユーザーID: $_userId'),
//                   ElevatedButton(
//                     onPressed: _saveToDatabase,
//                     child: Text('送信'),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
