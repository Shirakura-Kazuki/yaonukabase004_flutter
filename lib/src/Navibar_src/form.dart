import 'dart:convert';  // JSONのエンコード/デコードを行うためのライブラリ
import 'dart:typed_data';  // バイナリデータを扱うためのライブラリ
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
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
  Uint8List? _selectedImage; // 変更: FileからUint8Listへ変更
  String _imageHex = ''; // 追加: 16進数文字列

  @override
  void initState() {
    super.initState();
    _formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    _initializeUser();
  }

  void _initializeUser() {
    final User? user = _auth.currentUser;
    if (user != null) {
      setState(() {
        _userId = user.uid;
      });
      _fetchUserData();
      _fetchUserData_AZ();
    }
  }

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

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes(); // 変更: Fileからバイナリデータへ変更
        setState(() {
          _selectedImage = bytes;
          _convertImageToHex(bytes); // 16進数に変換する関数を呼び出す
        });
      }
    } catch (e) {
      print("Error picking image: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error picking image: $e')));
    }
  }

  void _convertImageToHex(Uint8List imageBytes) {
    setState(() {
      _imageHex = imageBytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
    });
  }

  Future<void> _saveToDatabase() async {
    var body = json.encode({
      'ideaname': _nameController.text,
      'ideaconcept': _conceptController.text,
      'ideadate': _formattedDate,
      'ideaimage': _imageHex, // 16進数文字列を送信
      'ideatechnology1': _tech1,
      'ideatechnology2': _tech2,
      'ideatechnology3': _tech3,
      'userid': _userId,
      'usertype': _userrole,
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

  // ボタン活性化
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
        title: Text('アイデア投稿フォーム'),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'アイデア投稿フォーム',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      shadows: <Shadow>[
                        Shadow(
                          color: Colors.grey,
                          offset: Offset(5, 5),
                          blurRadius: 3,
                        )
                      ],
                    ),
                  ),
                  // アイデアネーム
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      color: Colors.brown.shade100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
                            child: Text(
                              '①アイデアネーム（アイデアのタイトルは？）',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('[必須]',
                                style: TextStyle(color: Colors.red)),
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
                            child: Text(
                              '②アイデアコンセプト（どんなアイデア？）',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('[必須]',
                                style: TextStyle(color: Colors.red)),
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

                  // アイデア画像
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      color: Colors.brown.shade100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
                            child: Text(
                              '③アイデア画像を選択',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('[任意]',
                                style: TextStyle(color: Colors.grey)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage: _selectedImage != null
                          ? MemoryImage(_selectedImage!)
                          : null, // 変更: FileImageからMemoryImageへ変更
                      child: _selectedImage == null
                          ? const Icon(Icons.add_a_photo, size: 40)
                          : null,
                    ),
                  ),
                  SizedBox(height: 20),

                  // テクノロジー選択1
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      color: Colors.brown.shade100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
                            child: Text(
                              '④アイデア実現に必要なテクノロジー選択',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('[必須]',
                                style: TextStyle(color: Colors.red)),
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

                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Text(
                      'アカウントタイプ：${user?.usertype ?? 'Loading...'}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // 送信ボタン
                  SizedBox(
                    width: 200,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isFormValid ? _saveToDatabase : null,
                      // 条件に基づく活性・非活性制御
                      child: Text(
                        '送信',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                          // backgroundColor: Colors.deepPurple, // ボタンの背景色
                          ),
                    ),
                  ),
                ],
              ),
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
      items: <String>[
        '未選択',
        '機械加工',
        '金属加工',
        '電子機器製造',
        '自動車製造',
        '航空宇宙製造',
        'プラスチック加工',
        '繊維製造',
        '食品加工',
        '化学製品製造',
        '製薬産業',
        '建設業',
        'エネルギー産業',
        '家具製造'
      ].map<DropdownMenuItem<String>>((String value) {
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





// import 'dart:convert';  // JSONのエンコード/デコードを行うためのライブラリ
// import 'dart:typed_data';  // バイナリデータを扱うためのライブラリ
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:provider/provider.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:yaonukabase004/providers/user_provider.dart';

// class form_page extends StatefulWidget {
//   const form_page({super.key});

//   @override
//   State<form_page> createState() => _form_pageState();
// }

// class _form_pageState extends State<form_page> {
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _conceptController = TextEditingController();
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   double? _deviceWidth;
//   String _tech1 = '未選択';
//   String _tech2 = '未選択';
//   String _tech3 = '未選択';
//   String _userId = 'guest';
//   String _userrole = 'Loading...'; // ユーザー役割名を表示するための変数
//   late String _formattedDate;
//   Uint8List? _selectedImage; // 変更: FileからUint8Listへ変更
//   String _imageHex = ''; // 追加: 16進数文字列

//   @override
//   void initState() {
//     super.initState();
//     _formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
//     _initializeUser();
//   }

//   void _initializeUser() {
//     final User? user = _auth.currentUser;
//     if (user != null) {
//       setState(() {
//         _userId = user.uid;
//       });
//       _fetchUserData();
//       _fetchUserData_AZ();
//     }
//   }

//   Future<void> _fetchUserData_AZ() async {
//     await Provider.of<UserProvider>(context, listen: false).fetchUserData();
//   }

//   Future<void> _fetchUserData() async {
//     try {
//       User? user = FirebaseAuth.instance.currentUser;
//       if (user != null) {
//         // APIからデータを取得
//         final response = await http.get(
//           Uri.parse('https://guser.azurewebsites.net/api/get_user?userid=${user.uid}'),
//           headers: {'Content-Type': 'application/json'},
//         );

//         if (response.statusCode == 201) {
//           final data = json.decode(response.body);
//           print('APIレスポンス: ${response.body}');
//           setState(() {
//             _userrole = data['usertype'] ?? 'No userrole found';
//           });
//         } else {
//           print('APIリクエスト失敗: ${response.statusCode}');
//           setState(() {
//             _userrole = 'Error fetching userrole';
//           });
//         }
//       }
//     } catch (e) {
//       print('エラーが発生しました: $e');
//       setState(() {
//         _userrole = 'Error fetching userrole';
//       });
//     }
//   }

//   Future<void> _pickImage() async {
//     try {
//       final picker = ImagePicker();
//       final pickedFile = await picker.pickImage(source: ImageSource.gallery);

//       if (pickedFile != null) {
//         final bytes = await pickedFile.readAsBytes(); // 変更: Fileからバイナリデータへ変更
//         setState(() {
//           _selectedImage = bytes;
//           _convertImageToHex(bytes); // 16進数に変換する関数を呼び出す
//         });
//       }
//     } catch (e) {
//       print("Error picking image: $e");
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error picking image: $e')));
//     }
//   }

//   void _convertImageToHex(Uint8List imageBytes) {
//     setState(() {
//       _imageHex = imageBytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
//     });
//   }

//   Future<void> _saveToDatabase() async {
//     var body = json.encode({
//       'ideaname': _nameController.text,
//       'ideaconcept': _conceptController.text,
//       'ideadate': _formattedDate,
//       // 'ideaimage': 'ffd8ffe000104a46494600010101006000600000fffe003c43524541544f523a2067642d6a7065672076312e3020287573696e6720494a47204a50454720763830292c207175616c697479203d203130300affdb00430001010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101ffdb00430101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101ffc000110800a000f003012200021101031101ffc4001f0000010501010101010100000000000000000102030405060708090a0bffc400b5100002010303020403050504040000017d01020300041105122131410613516107227114328191a1082342b1c11552d1f02433627282090a161718191a25262728292a3435363738393a434445464748494a535455565758595a636465666768696a737475767778797a838485868788898a92939495969798999aa2a3a4a5a6a7a8a9aab2b3b4b5b6b7b8b9bac2c3c4c5c6c7c8c9cad2d3d4d5d6d7d8d9dae1e2e3e4e5e6e7e8e9eaf1f2f3f4f5f6f7f8f9faffc4001f0100030101010101010101010000000000000102030405060708090a0bffc400b51100020102040403040705040400010277000102031104052131061241510761711322328108144291a1b1c109233352f0156272d10a162434e125f11718191a262728292a35363738393a434445464748494a535455565758595a636465666768696a737475767778797a82838485868788898a92939495969798999aa2a3a4a5a6a7a8a9aab2b3b4b5b6b7b8b9bac2c3c4c5c6c7c8c9cad2d3d4d5d6d7d8d9dae2e3e4e5e6e7e8e9eaf2f3f4f5f6f7f8f9faffda000c03010002110311003f0028a28a0028a28a0028a28a0028a28a0028a28a0028a28a0028a28a0028a28a0028a28a0028a28a0028a28a0028a28a0028a28a0028a28a0028a28a0028a28a0028a28a0028a28a0028a28a0028a28a0028a28a0028a28a0028a28a0028a28a0028a28a0028a28a0028a28a0028a28a0028a28a0028a28a0028a28a0028a28a0028a28a0028a28a0028a28a0028a28a0028a28a0028a28a0028a28a0028a28a0028a28a0028a28a0028a28a0028a28a0028a28a0028a28a0028a28a0028a28a0028a28a0028a28a0028a28a0028af6af06fc218bc55f03be3f7c689bc49269a9f03a7f8396cbe1c8b455bf6f14cbf17be20a78060ceacfac580d0e3d0a6923d4a561a6eb0da8445ed923b375599fb6d57e0c7c2af057c22f809f13be227c49f89f6b7bf1f2c3e276a5a37873e1efc1bf06f8c6dbc3969f0c3c743c11a949adebbe2bf8fbf0ca59bfb426b9d3f50b44d3343bb92349eeeda4426d229ef003e5fa2beb5bbfd964ffc271fb32699a27c42b0d7fe1b7ed55e25d3bc3ff0ff00e21dbf87af6c752d3e44f1ce8be02f18db7883c11a86a104f6baf782b56d72c9aff4cb7d7ee74bd4a3b8b43a6f88a58ae1e7b7f43f127ecfdfb0c784bc49e23f096bdff0505d66db5ef09f8835bf0b6bf696dfb157c7bd560b2d77c39aa5de8bad58c7a9691797da5df8b2d4ec6ead4dd69d7b77653b42d25b5ccd0b248c01f03d15ef3f027e016bff001ffc41e2583c33ade8be16f87fe07d2efbc51e3bf8a9f111e5f08f84bc15e0bb39e78e2d7fc4ad79e6cfa75cea30c0f269da1b96be96459c4cd6f6761a95fd9fb4a7ecbdf01fc75a76b56dfb3f7ed99e01f8b1e3bd0f48d4f5a6f057897e1c78ebe0cc5e22b6d12ce7d4756b7f0478bbc7657c39e2abe82c2dae6f6de1b4b9821b8b5b79ae9ee6ded62927500f8768a647224a892c4eb247222c91c88c191d1c064746048656521958120820838a7d001451450014514500145145001451450014514500145145001451450014514500145145001451450014514f8d82488ed1a4aa8eac6293788e40ac098dcc6f1c9b1c0dade5c88fb49daead86001f64fc25207ec31fb7ce4e33ac7ec5aa33c658fed136cc147ab154760073b558e30a48ee3e2ceb3f0d349fd93bfe09f67c75f0efc6de3cd465f0afed56da47fc231f18744f859a7585947f1e6c3fb4e3d561d4be08fc5cbcd727bc9df4d366f6379e1b4b082def9661a849796f258f85fc59fdaabe257c58f00c5f0a13c23f033e12fc3597c43a2f89fc45e1bf819f0a22f8793f8eb56f0cc924fe1b9bc6faa3f8875d7d5e3d1af5a3d42086cedb4a8e5beb7b79a75758638d7c77c49e3ef1978b7c3bf0dbc1faf6b8d79e14f847a4f8c748f00e86ba76916b1e8b078f7c4d078b7c552c9a85ad843abea936a5acdb41321d56fef63b18a3f22c23b689dd5803eacf855f1975af8b5fb51fec47e1f8fc2da07c3bf867f06fe2dfc3bf0d7c30f877e1fd4b54f117f657fc263f177c1fe21f1b7893c47e2dd6a1b2bff12f8a7c55abe9ba74b7f770e93a1e976b6d616d6fa7e916c4dc493f63f1cbe3dfecad17c47f8eba15a7fc13fb44bbf1441f137e3168b278f6f3f6bbf8c76725ff008b6dfc6de27d3eff00c6b37842dbc1175a55a0bff104771e20ff00846adf537d3add271a54372b6a88cbf127c3df1aeabf0d7c7de07f88da15be9f77adf803c61e1af1ae8f6bab45733e9573aaf8575ab2d774fb7d4e0b3bbb0bb9b4f9aeec218ef62b5beb3b992d9a4482eede52b327d6f7bfb7ef8db53bed4354d47f650ff82756a1a9eaba85f6adaa6a37bfb29ead777da96a9aa5dcd7fa9ea5a85dcff1864b8bcd4351beb8b8bdbebcb8924b9bbbb9e6b9b89249a5776009fe1de8faaf8b7fe09c7fb46f87bc2b09bef1068df1bfe0df8c3e2d695a52cb35cdff00c29d3ed2ebec134f6681ae6f3c3fa3f8e2d9758bf322496f61656775a85f7956d04d28f21fd993c09f0afe2e7c51f00fc1ff00881e11f1feaf73f127c6fa4f85ff00e124f08fc4cf0e784ecfc37a2ea8d15b5d5d5c784f5af833f1164f14dcdb137177247ff093785ad1ad5441214daf7478af85ff001dfe2afc1ef1fdefc4df877e21b2f07f8a753bad65f51b4f0e6896567e0fb9d2b5cd425bebaf0ab783f503ab6953785205786d2c747d43edff00628acecae20b95d46d2def63f6df127ede3f1e752b0d4ad7c0fe1dfd9ebe046adadda5c69fadf8ff00e03fc0dd1fc0bf14b53b2be8e487508ffe137bfd6fc493695757d1c8e25d4f40d3b48d4addcf9fa7dd594e164500f9275ab3b3d375dd7f4ad3e3962b0d23c41aee8d6293c914d38b3d2357bcd36d8cd2416f690bcad0daa34861b5b78b79611c31a61466d416b6d15a5bc56d0eff002e25daa659649a573925a4966959e59a591cb3cb2c8ed2492333bb16624cf40051451400514514005145140051451400514514005145140051451400514514005145140057ddda17fc13e7e2d6a63c3fa4ebff0011ff0067af875f127c59a7596a9e16f825f117e2fe91e1cf8c9af5bea70acfa54765e081677b7115e6a513a1b7b1d42eecaee191bc8be8ad2e125893e1347789d248dda39236578e44628e8e84323a3290cacac032b2905480410457d39a1782f47f046a1a17ed0dfb4e78afc50b79e33bfb1f1d7853c1506a37de27fda07e3b7f664d6e9a76af6f71adde4f37837c012b6991588f899e36d46d34e8ac6d82f8334bf11cd1c50c601e03e2cf0af887c0de26d7fc1be2dd2ae743f13785f56bfd0b5ed22f3cbfb469daa69b7125ade5ac8d0bcb04be5cd1b049ede596de74db35bcb2c32248debbe2dfd9c7c7de06f817e0ef8fbe28bbf0de97e1bf1df8bb49f09787bc2d2dfea0de3d946bfe1ef17f89f41f12dee889a4b69fa6785f5dd2bc0be239f47bdbed660bfd4a3b6b6bcb4d325d36fecefa6fa1be0bf803e217ed77f147e3d7ed61e39f867ab7c45d3bc3fe2093c7dac7c1ff008791dc5f5f78d3c59aec8b63f0e7e0f69572221736fe1c86d74cb25f1cf8c6e2da3fb2786b4ad5afc469aa6ab62a3d23e297c11fdaefc59fb2578afc45f157e137c44bdf8a7e28fdb4fc3df14bc4fa6e9de0dd55a1d0fc11a47ece3f143c3315c693a3584376da0fc38f04a4ba27843472e12c34cb58f4db5966fb45c66400f96be137ec91e3cf8a5e067f8a1a978d7e107c18f8692eb4fe1ad1bc79f1dfe2158fc38f0df8a3c4710633689e19b9bbb5beb9d5af6164685a48ed52c9aea3b9b38aee4bab2be86dbcbbe32fc18f1f7c05f1c5d7803e23697069fad456365ac69f77a7de41aa689e20d0354591f4af11787757b626db55d1752586616d7716d649e0b9b3ba8adefad2eada1fa0bf6d18e51e19fd86348b405fc0fa2fec7be18f10f87a0505b4d87c7de33f1978aa4f89f7b6c9cc2356927d1bc391ea5327fa42878d5caacb836ff69cb9b9bbfd973fe09dd7fad3bc9e26bbf02fed2ba33cb383f6e9bc11e11f8a3e0fb2f014575b809174fd2ad352d56cf415c794d63348602caac6803e1da2bebbfd91ecbc27f11bc4dae7ece7e2ef0a697a80f8e9650f87bc17e3db7f0b59eafe32f861f1174f326a3e14f11e9faac3652ebb0f832e2ee13a77c44d26d2eedad27f0dcf71aacf2db0d2a495f1ff006aad3b48f867e2ed1bf66af0cf8634bd362f81960b69f123e215cf85acacbc5bf173e2c78a34fd3f5cd7751b6d7b51d361f11a7c2bf09d8ded9e87f0f34e864b2d3f5a8bedbe29993524bed3aee803c63e1cfc34f19fc57f118f0af8174bb7d575916177aacc97bad687e1eb0b3d2ec0466fb51d4359f11ea5a4e8fa7d95a2ca8d3dc5e5fc11a2b649c035d77c73f819e24f801e20f07f86fc53e23f037896f7c6df0e742f8a1a45efc3ef10bf8af421e19f116b3e23d0f4d2dafc3616ba3dfdd4979e16d51d9f42bcd634c6b6fb34d06a5309b6a7884f0417313c1730c571048312433c692c52004101e3903230040386046403d457d97fb6722477bfb20471a2a227ec0bf015511142a22af8d3e31055555002a81c000000700500711f06bf65ff001dfc64f0e6bfe3c4f127c35f85bf0c3c33a841a2eb3f15be34f8dac7e1e7c3db6d7eea15b9b7d022d72fa1ba96f3567b678ee24b6b2b2b84b58a5b637b2db35e59acfcafc4ff00821e25f865e30f0ef8393c43f0fbe255cf8cacacf50f05eb1f07bc6ba3fc47d0fc5b69a86a72e8b66fa2cfa1c8f7ef2dceaf04da75bdb5ee9b65757374852da1994ab9faa3e3cea7e0ff0007fecc1fb025b5d782f4ef8936ba87837e34f8ab4bf0b789f50f15693f0e2d7c56ff00112decbc61e2ef142f81bc41e13f1478b3c596905d691e19f09d9d9f8a74387c2fa7a6bd25f497f1ea9656b6deb1fb347c28f861a7fed3bfb007c64f0fe849e14f0e7c7eb8f89fa8bf82ef2f6e759b7f0e78ff00e084977a25e8d0f59d55a5d62efc33a8f88b55f09eafe188359bed5b56d36f2e2ff4ebbd5b5092ce2b89403c2753ff0082797c6cd3ed358d3edbc5df03f5ff008a9e1cf0fb789fc45fb3df86fe2ae8dad7c78d0f478ad23be9e7bdf025a40cb2490da4a938b7b1d5af26badd1c3a7a5e5c4d6f0cbf0875e95f4afec99abf8ed7f6c4f835e279e5d43fe1657897f687f0fea7e33bb93cd3aa5eeb7e2cf1d247e3d8f55948370c9716baa6b9a7eabe69fdd69cf73139489081e7bf1e61d26d3e3f7ed0561a02c2ba0e97f1fbe37693a1c76c145a43a3e95f14bc59a7e996f67b3e43676b656d05ada327c8d6f0c6cb9520d007965145140051451400514514005145140051451400514514005145140051451401aba0df59697ae68da9ea5a645ade9da76aba75f5fe8d34c6de1d5ecad2f21b8bad325b8114e608afe08e4b4926104c62594bf9526dd8df7978f3f6c1fd987e2578e7c45f117c69ff0004e8d17c41e2ff0013cb64756d6ee7f6d5f8cf62f35b697636fa5e936369a669bf0cedf49d134ad334db4b6b3d3b43d16d6cf48d3608c45656b1a962df9f145007a078dfc7767aff008c7c51acfc38f07de7c0af02ead7ba4cfa0fc34f0c7c51f1af8ca0d0e2b0f0ee95a75f497de31d620f0feafafddea7aec3adeb68d77a7431e996dab43a4db79b0d92cf2f4d75f1bfc5337c027f80eafe20960d47e3569ff15f57f18dcf8fb5f3792e93a6fc38f15f818782068ad6b3c97761a85ff88ed75dbaba97c476b69136951c0da3de4b325d5bf8cd1401f607c38fdaaf40d03e167873e0f7c66fd9f3c17fb467827c017dab5f7c32b7d7bc6de28f869e25f028d7a78af359d234ff0018f8534fd62feebc2f7fa84116a171e1eb8d3c453dde0cf792416d616f67e31f1c3e3678c7e3ff008eed3c67e2ad2fc35e12d23c33e15d2fe1ff00c35f86de08b7b8b6f067c37f0168b24d359683a38badb73a85edddd4ef7badeb7750dbcda85c2dbc305a58e9b6361616be4d45007b0f807e315f7c2df037c50d1fc17e1b8adfe257c4cd057c0b6bf16a5f11496da87c38f016acfe5f8ead7c19e1d8740b8cf8b7c61a517d0478b24f1169f73e1ed2e7b9fec9b65bab89a792cfc4ef8ceff147c13f08bc3fae783adcf8dfe18787a5f03dd7c525f12cc6ff00c59e00d3001e08f0f6bbe177f0f4ab7babf83a26974bb0f161f15437573a0b41a6ea5a5dfcd67677d078ad140057aefc65f8bb75f182ff00e144b278660f0ddafc27f805f0f7e07db3a6bd26b53f891bc15acf8cf589fc4d3c0da1e8f1e862fdbc58b6b168d1dceb6605b169df5590dc8820f22a2803eb8f859fb54699e13f86507c1af8bff03bc21fb457c32d1b5dbff13783741f1178b7c45f0efc45e0ad63570a7594f0df8f7c2d65aa6ada7e89ac4c8b7baae87fd9b35bdedf8174d2c6d956e33e257ed39f113e227c4ef875f10f47d2bc39f08349f821a769fa3fc0af877f0fa4bbbad03e1ad8d8eb36de22b8bffed3d5a086ebc49e25d775ab2b0bcf106b57ba7d947a9ae9d650cda79db3bcff003d51401fa0ba87edf367a7eb1acfc4ef875fb27fc17f047ed2be20b6d54ddfc7b8fc53e2fd52c74ad7bc416f3db6b7e32f0e7c19bdd3e4f0b699e2cbafb65ede0d51fc4771f68d46e67b8d562d460bbbeb3bafcf2b581ede058e5bababeb866966bbbfbd99ee2f6fef6e657b8bdbfbdb890b3cf797b752cd75753392d2cf348ec72d5628a0028a28a0028a28a0028a28a0028a28a0028a28a0028a28a0028a28a0028a28a0028a28a0028a28a0028a28a0028a28a0028a28a0028a28a0028a28a0028a28a0028a28a0028a28a0028a28a0028a28a0028a28a0028a28a0028a28a0028a28a0028a28a0028a28a0028a28a0028a28a0028a28a0028a28a0028a28a0028a28a0028a28a0028a28a0028a28a0028a28a0028a28a0028a28a0028a28a0028a28a0028a28a0028a28a0028a28a0028a28a0028a28a0028a28a0028a28a0028a28a0028a28a00fffd9',
//       'ideaimage':'0xFFD8FFE000104A46494600010100000100010000FFE201D84943435F50524F46494C45000101000001C80000000004300000',
//       // 'ideaimage': _imageHex, // 16進数文字列を送信
//       'ideatechnology1': _tech1,
//       'ideatechnology2': _tech2,
//       'ideatechnology3': _tech3,
//       'userid': _userId,
//       'usertype': _userrole,
//     });

//     print("Sending Data: $body");

//     try {
//       final response = await http.post(
//         Uri.parse('https://craftsconnect.azurewebsites.net/api/create_idea_record'),
//         headers: {'Content-Type': 'application/json'},
//         body: body,
//       );

//       if (response.statusCode == 200) {
//         // 成功した場合、ダイアログを表示
//         await showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title: Text('送信されました'),
//               content: Text('投稿ホームに戻ります'),
//               actions: <Widget>[
//                 TextButton(
//                   onPressed: () {
//                     Navigator.of(context).pop(); // ダイアログを閉じる
//                     Navigator.of(context).pop(); // 前のページに戻る
//                   },
//                   child: Text('OK'),
//                 ),
//               ],
//             );
//           },
//         );
//       } else {
//         print("Error from the server: ${response.body}");
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${response.body}')));
//       }
//     } catch (e) {
//       print("Exception caught: $e");
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Exception: $e')));
//     }
//   }

//   // ボタン活性化
//   bool get _isFormValid {
//     return _nameController.text.isNotEmpty &&
//         _conceptController.text.isNotEmpty &&
//         _tech1 != 'なし';
//   }

//   @override
//   Widget build(BuildContext context) {
//     _deviceWidth = MediaQuery.of(context).size.width;

//     final user = Provider.of<UserProvider>(context).user;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('アイデア投稿フォーム'),
//         backgroundColor: Colors.red.shade100,
//       ),
//       body: SingleChildScrollView(
//         child: Center(
//           child: Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: Container(
//               alignment: Alignment.center,
//               width: _deviceWidth! * 0.65,
//               constraints: BoxConstraints(
//                 minWidth: 400,
//                 maxWidth: 700,
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: <Widget>[
//                   Text(
//                     'アイデア投稿フォーム',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 30,
//                       shadows: <Shadow>[
//                         Shadow(
//                           color: Colors.grey,
//                           offset: Offset(5, 5),
//                           blurRadius: 3,
//                         )
//                       ],
//                     ),
//                   ),
//                   // アイデアネーム
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Container(
//                       color: Colors.brown.shade100,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: <Widget>[
//                           Padding(
//                             padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
//                             child: Text(
//                               '①アイデアネーム（アイデアのタイトルは？）',
//                               style: TextStyle(
//                                   fontWeight: FontWeight.bold, fontSize: 15),
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Text('[必須]',
//                                 style: TextStyle(color: Colors.red)),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   TextField(
//                     controller: _nameController,
//                     decoration: InputDecoration(
//                       labelText: 'アイデアネームを入力',
//                       labelStyle: TextStyle(color: Colors.grey[600]),
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                   SizedBox(height: 20),

//                   // アイデアコンセプト
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Container(
//                       color: Colors.brown.shade100,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: <Widget>[
//                           Padding(
//                             padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
//                             child: Text(
//                               '②アイデアコンセプト（どんなアイデア？）',
//                               style: TextStyle(
//                                   fontWeight: FontWeight.bold, fontSize: 15),
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Text('[必須]',
//                                 style: TextStyle(color: Colors.red)),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   TextField(
//                     controller: _conceptController,
//                     decoration: InputDecoration(
//                       labelText: 'アイデアコンセプトを入力',
//                       labelStyle: TextStyle(color: Colors.grey[600]),
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                   SizedBox(height: 20),

//                   // アイデア画像
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Container(
//                       color: Colors.brown.shade100,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: <Widget>[
//                           Padding(
//                             padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
//                             child: Text(
//                               '③アイデア画像を選択',
//                               style: TextStyle(
//                                   fontWeight: FontWeight.bold, fontSize: 15),
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Text('[任意]',
//                                 style: TextStyle(color: Colors.grey)),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: _pickImage,
//                     child: CircleAvatar(
//                       radius: 40,
//                       backgroundImage: _selectedImage != null
//                           ? MemoryImage(_selectedImage!)
//                           : null, // 変更: FileImageからMemoryImageへ変更
//                       child: _selectedImage == null
//                           ? const Icon(Icons.add_a_photo, size: 40)
//                           : null,
//                     ),
//                   ),
//                   SizedBox(height: 20),

//                   // テクノロジー選択1
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Container(
//                       color: Colors.brown.shade100,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: <Widget>[
//                           Padding(
//                             padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
//                             child: Text(
//                               '④アイデア実現に必要なテクノロジー選択',
//                               style: TextStyle(
//                                   fontWeight: FontWeight.bold, fontSize: 15),
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Text('[必須]',
//                                 style: TextStyle(color: Colors.red)),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: <Widget>[
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Text('アイデアテクノロジー１'),
//                       ),
//                       Text('[必須]', style: TextStyle(color: Colors.red)),
//                     ],
//                   ),
//                   buildDropdown(_tech1, 'アイデアテクノロジー１'),
//                   SizedBox(height: 20),

//                   // テクノロジー選択2
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: <Widget>[
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Text('アイデアテクノロジー２'),
//                       ),
//                       Text('[任意]', style: TextStyle(color: Colors.grey)),
//                     ],
//                   ),
//                   buildDropdown(_tech2, 'アイデアテクノロジー２（任意）'),
//                   SizedBox(height: 20),

//                   // テクノロジー選択3
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: <Widget>[
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Text('アイデアテクノロジー３'),
//                       ),
//                       Text('[任意]', style: TextStyle(color: Colors.grey)),
//                     ],
//                   ),
//                   buildDropdown(_tech3, 'アイデアテクノロジー３（任意）'),
//                   SizedBox(height: 20),

//                   // ユーザーID
//                   Text('ユーザーID: $_userId'),
//                   SizedBox(height: 30),
//                   // 投稿時間
//                   Text('投稿時間: $_formattedDate'),
//                   SizedBox(height: 20),

//                   Padding(
//                     padding: const EdgeInsets.all(0.0),
//                     child: Text(
//                       'アカウントタイプ：${user?.usertype ?? 'Loading...'}',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),

//                   // 送信ボタン
//                   SizedBox(
//                     width: 200,
//                     height: 50,
//                     child: ElevatedButton(
//                       onPressed: _isFormValid ? _saveToDatabase : null,
//                       // 条件に基づく活性・非活性制御
//                       child: Text(
//                         '送信',
//                         style: TextStyle(
//                             fontSize: 20, fontWeight: FontWeight.bold),
//                       ),
//                       style: ElevatedButton.styleFrom(
//                           // backgroundColor: Colors.deepPurple, // ボタンの背景色
//                           ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   DropdownButtonFormField<String> buildDropdown(String value, String label) {
//     return DropdownButtonFormField(
//       value: value,
//       onChanged: (String? newValue) {
//         if (newValue != null) {
//           setState(() {
//             switch (label) {
//               case 'アイデアテクノロジー１':
//                 _tech1 = newValue;
//                 break;
//               case 'アイデアテクノロジー２（任意）':
//                 _tech2 = newValue;
//                 break;
//               case 'アイデアテクノロジー３（任意）':
//                 _tech3 = newValue;
//                 break;
//             }
//           });
//         }
//       },
//       items: <String>[
//         '未選択',
//         '機械加工',
//         '金属加工',
//         '電子機器製造',
//         '自動車製造',
//         '航空宇宙製造',
//         'プラスチック加工',
//         '繊維製造',
//         '食品加工',
//         '化学製品製造',
//         '製薬産業',
//         '建設業',
//         'エネルギー産業',
//         '家具製造'
//       ].map<DropdownMenuItem<String>>((String value) {
//         return DropdownMenuItem<String>(
//           value: value,
//           child: Text(value),
//         );
//       }).toList(),
//       decoration: InputDecoration(
//         labelText: label,
//         border: OutlineInputBorder(
//           borderSide: BorderSide(color: Colors.red),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderSide: BorderSide(color: Colors.red, width: 2.0),
//         ),
//       ),
//     );
//   }
// }


