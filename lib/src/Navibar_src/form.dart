import 'dart:convert';  //JSONのエンコード/デコードを行うためのライブラリ
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:yaonukabase004/providers/user_provider.dart';



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
  String _userrole = 'Loading...'; // ユーザー役割名を表示するための変数
  late String _formattedDate;
  
  @override
  void initState() {
    super.initState();
    _formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    _initializeUser();
  }
void _initializeUser(){
  final User?user = _auth.currentUser;
  if(user != null){
    setState(() {
      _userId = user.uid;
    });
    // _fetchUserRole(user.uid);
    _fetchUserData();
    _fetchUserData_AZ();
  }
}

// Azureからユーザー情報の取得
Future<void> _fetchUserData_AZ() async {
    await Provider.of<UserProvider>(context, listen: false).fetchUserData();
}

Future<void> _fetchUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // APIからデータを取得
        final response = await http.get(
          Uri.parse('https://guser.azurewebsites.net/api/get_user?userid=${user.uid}'),
          headers: {'Content-Type': 'application/json'},
        );

        if (response.statusCode == 201) {
          final data = json.decode(response.body);
          print('APIレスポンス: ${response.body}');
          setState(() {
            _userrole = data['usertype'] ?? 'No userrole found';
          });
        } else {
          print('APIリクエスト失敗: ${response.statusCode}');
          setState(() {
            _userrole = 'Error fetching userrole';
          });
        }
      }
    } catch (e) {
      print('エラーが発生しました: $e');
      setState(() {
        _userrole = 'Error fetching userrole';
      });
    }
  }

  // void _initializeUser() {
  //   final User? user = _auth.currentUser;
  //   setState(() {
  //     _userId = user?.uid ?? 'PEsrLPjXDOXnLqHTkYDFkIt2Fbo1';  //テスト用ユーザーID
  //   });
  // }
  //   // firebaseデータ取得
  // Future<void> _fetchUserRole(String uid) async {
  //   try {
  //     DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
  //     setState(() {
  //       _userrole = userDoc['role'] ?? 'No userrole found'; // Firestoreからユーザー役割を取得
  //     });
  //   } catch (e) {
  //     print('エラーが発生しました: $e');
  //     setState(() {
  //       _userrole = 'Error fetching userrole';
  //     });
  //   }
  // }


  Future<void> _saveToDatabase() async {
    var body = json.encode({
      'ideaname': _nameController.text,
      'ideaconcept': _conceptController.text,
      'ideadate': _formattedDate,
      'ideaimage': '0xFFD8FFE000104A46494600010100000100010000FFE201D84943435F50524F46494C45000101000001C80000000004300000',
      'ideatechnology1': _tech1,
      'ideatechnology2': _tech2,
      'ideatechnology3': _tech3,
      // 'userid': 'PEsrLPjXDOXnLqHTkYDFkIt2Fbo1'
      'userid': _userId,
      "usertype":_userrole,
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

     final user = Provider.of<UserProvider>(context).user;

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

                  // Text('アカウントタイプ:$_userrole'),  //APIで取得する
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Text(
                      'アカウントタイプ：${user?.usertype ?? 'Loading...'}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        // fontSize: constraints.maxHeight * 0.09,
                      ),
                    ),
                  ),

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
      items: <String>['未選択', '機械加工', '金属加工', '電子機器製造', '航空宇宙製造', 'プラスチック加工', '繊維製造']
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


