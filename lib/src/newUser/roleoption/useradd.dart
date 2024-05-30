import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestoreパッケージのインポート
import 'package:yaonukabase004/firebase_options.dart';
import 'package:yaonukabase004/src/user/addpage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YAONUKA.com',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const UserAddPage(),
    );
  }
}

class UserAddPage extends StatefulWidget {
  const UserAddPage({super.key});

  @override
  _UserAddPageState createState() => _UserAddPageState();
}

class _UserAddPageState extends State<UserAddPage> {
  String? _imagePath;
  String _userId = '';
  String _name = '';
  String _email = '';
  String _password = '';
  String _confirmPassword = '';
  String _profile = '';
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _uid;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final String _currentDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

  bool _isFormValid = false;
  void _validateForm() {
    setState(() {
      _isFormValid = _name.isNotEmpty &&
          _email.isNotEmpty &&
          _password.isNotEmpty &&
          _confirmPassword.isNotEmpty &&
          _profile.isNotEmpty;
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _imagePath = pickedFile.path;
      }
    });
  }

  Future<void> _submitForm() async {
    try {
      final UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _email,
        password: _password,
      );

      final User? user = userCredential.user;

      if (user != null) {
        print("ユーザ登録しました ${user.email} , ${user.uid}");
        setState(() {
          _uid = user.uid;
        });

        // Firestoreにデータを保存
        final usersCollection = _firestore.collection('users');
        final docRef = usersCollection.doc(_uid);

        await docRef.set({
          'uid': _uid,
          'role': 'user',
          'username': _name,
          'created_at': _currentDateTime,
          'profile': _profile,
        });

        print("Firestoreにデータを保存しました");

        // JSONデータを生成
        var requestBody = json.encode({
          'userid': _uid,
          'username': _name,
          'usertype': 'User',
          'createdat': _currentDateTime,
          'userprofile': _profile,
          'numberofpoints': 0,
          'companyname': '',
          'companyprofile': '',
          'companyfield': '',
          'companyskill': '',
          'coordinatorname': '',
          'coordinatorskillname': '',
          'coordinatorfieldname': '',
        });

        print("Sending JSON Data: $requestBody");

        final response = await http.post(
          Uri.parse('https://create-user.azurewebsites.net/api/create_user'),
          headers: {'Content-Type': 'application/json'},
          body: requestBody,
        );

        if (response.statusCode == 200) {
          print("データが正常に送信されました");
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddConPage()),
          );
        } else {
          print("エラーが発生しました: ${response.body}");
        }
      } else {
        print("ユーザー登録に失敗しました。");
      }
    } catch (e) {
      print("エラーが発生しました: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('アカウント作成'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double width = constraints.maxWidth * 0.5;
          if (constraints.maxWidth < 800) {
            width = constraints.maxWidth * 0.9;
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Container(
                  width: width,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          color: Colors.brown.shade100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                                child: Text(
                                  'プロフィール写真アップロード',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  '[任意]',
                                  style: TextStyle(
                                    color: Colors.red.shade700,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: _pickImage,
                        child: CircleAvatar(
                          radius: 40,
                          backgroundImage: _imagePath != null ? FileImage(File(_imagePath!)) : null,
                          child: _imagePath == null ? const Icon(Icons.person, size: 40) : null,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '▲',
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Text(
                          'アイコンをクリックして写真をアップロードしてください',
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          color: Colors.brown.shade100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                                child: Text(
                                  'UserID（自動入力）',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  '[自動]',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          _uid == null ? 'UserID作成中・・・' : 'あなたのUIDは $_uid です',
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          color: Colors.brown.shade100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                                child: Text(
                                  'UserNameを入力してください',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  '[必須]',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _name = value;
                          });
                          _validateForm();
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          color: Colors.brown.shade100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                                child: Text(
                                  '登録日時（自動入力）',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  '[自動]',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '登録日時: $_currentDateTime',
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          color: Colors.brown.shade100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                                child: Text(
                                  '登録メールアドレス',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  '[必須]',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'メールアドレス',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) {
                          setState(() {
                            _email = value;
                          });
                          _validateForm();
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          color: Colors.brown.shade100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                                child: Text(
                                  '登録パスワード',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  '[必須]',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'パスワード',
                          border: OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(
                                _obscurePassword ? Icons.visibility : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                        obscureText: _obscurePassword,
                        onChanged: (value) {
                          setState(() {
                            _password = value;
                          });
                          _validateForm();
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: '確認用パスワード',
                          border: OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(_obscureConfirmPassword
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _obscureConfirmPassword = !_obscureConfirmPassword;
                              });
                            },
                          ),
                        ),
                        obscureText: _obscureConfirmPassword,
                        onChanged: (value) {
                          setState(() {
                            _confirmPassword = value;
                          });
                          _validateForm();
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          color: Colors.brown.shade100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                                child: Text(
                                  'プロフィール文入力',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  '[必須]',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'プロフィール文（150文字以内）',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 5,
                        onChanged: (value) {
                          setState(() {
                            _profile = value;
                          });
                          _validateForm();
                        },
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _isFormValid ? _submitForm : null, // フォームの入力がすべて正しい場合のみボタン操作
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isFormValid ? Colors.red : Colors.grey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            '確定',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Image.asset(
                        'assets/images/bottomimage.png',
                        width: 50,
                        height: 50,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}


// import 'dart:convert';
// import 'dart:io';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
// import 'package:cloud_firestore/cloud_firestore.dart'; // Firestoreパッケージのインポート
// import 'package:yaonukabase004/firebase_options.dart';
// import 'package:yaonukabase004/src/user/addpage.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'YAONUKA.com',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const UserAddPage(),
//     );
//   }
// }

// class UserAddPage extends StatefulWidget {
//   const UserAddPage({super.key});

//   @override
//   _UserAddPageState createState() => _UserAddPageState();
// }

// class _UserAddPageState extends State<UserAddPage> {
//   String? _imagePath;
//   String _userId = '';
//   String _name = '';
//   String _email = '';
//   String _password = '';
//   String _confirmPassword = '';
//   String _profile = '';
//   bool _obscurePassword = true;
//   bool _obscureConfirmPassword = true;
//   String? _uid;

//   final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Firestoreのインスタンスを追加

//   final String _currentDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
  
//   // フォームのバリデーションメソッドの追加
//   // 各入力フィールドが空ではないか確認する
//   bool _isFormValid = false;
//   void _validateForm() {
//     setState(() {
//       _isFormValid = _name.isNotEmpty &&
//           _email.isNotEmpty &&
//           _password.isNotEmpty &&
//           _confirmPassword.isNotEmpty &&
//           _profile.isNotEmpty;
//     });
//   }

//   Future<void> _pickImage() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);

//     setState(() {
//       if (pickedFile != null) {
//         _imagePath = pickedFile.path;
//       }
//     });
//   }

//   Future<void> _submitForm() async {
//     try {
//       final UserCredential userCredential = await FirebaseAuth.instance
//           .createUserWithEmailAndPassword(
//         email: _email,
//         password: _password,
//       );

//       final User? user = userCredential.user;

//       if (user != null) {
//         print("ユーザ登録しました ${user.email} , ${user.uid}");
//         setState(() {
//           _uid = user.uid;
//         });

//         // Firestoreにデータを保存
//         final usersCollection = _firestore.collection('users'); // Firestoreコレクションの参照を取得
//         final docRef = usersCollection.doc(_uid);

//         // ドキュメントが存在しない場合に新規作成
//         await docRef.set({
//           'uid': _uid, // Firebase Authから取得
//           'role': 'user', // 固定値として設定
//           'username': _name,
//           'created_at': _currentDateTime,
//           'profile': _profile,
//         });

//         print("Firestoreにデータを保存しました");

//         // JSONデータを生成
//         var requestBody = json.encode({
//           'userid': _uid,
//           'username': _name,
//           'usertype': 'User',
//           'createdat': _currentDateTime,
//           'userprofile': _profile,
//           'numberofpoints': 0,
//           'companyname': '',
//           'companyprofile': '',
//           'companyfield': '',
//           'companyskill': '',
//           'coordinatorname': '',
//           'coordinatorskillname': '',
//           'coordinatorfieldname': '',
//         });

//         print("Sending JSON Data: $requestBody");

//         final response = await http.post(
//           Uri.parse('https://create-user.azurewebsites.net/api/create_user'),
//           headers: {'Content-Type': 'application/json'},
//           body: requestBody,
//         );

//         if (response.statusCode == 200) {
//           print("データが正常に送信されました");
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => const AddConPage()),
//           );
//         } else {
//           print("エラーが発生しました: ${response.body}");
//         }
//       } else {
//         print("ユーザー登録に失敗しました。");
//       }
//     } catch (e) {
//       print("エラーが発生しました: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('アカウント作成'),
//       ),
//       body: LayoutBuilder(
//         builder: (context, constraints) {
//           double width = constraints.maxWidth * 0.5;
//           if (constraints.maxWidth < 800) {
//             width = constraints.maxWidth * 0.9;
//           }
//           return SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Center(
//                 child: Container(
//                   width: width,
//                   child: Column(
//                     children: <Widget>[
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Container(
//                           color: Colors.brown.shade100,
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: <Widget>[
//                               Padding(
//                                 padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
//                                 child: Text(
//                                   'プロフィール写真アップロード',
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 15,
//                                   ),
//                                 ),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.all(10.0),
//                                 child: Text(
//                                   '[任意]',
//                                   style: TextStyle(
//                                     color: Colors.red.shade700,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       GestureDetector(
//                         onTap: _pickImage,
//                         child: CircleAvatar(
//                           radius: 40,
//                           backgroundImage:
//                               _imagePath != null ? FileImage(File(_imagePath!)) : null,
//                           child: _imagePath == null
//                               ? const Icon(Icons.person, size: 40)
//                               : null,
//                         ),
//                       ),
//                       const SizedBox(height: 2),
//                       Text(
//                         '▲',
//                         style: const TextStyle(
//                           color: Colors.black,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(0.0),
//                         child: Text(
//                           'アイコンをクリックして写真をアップロードしてください',
//                           style: const TextStyle(
//                             color: Colors.black,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                           ),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Container(
//                           color: Colors.brown.shade100,
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: <Widget>[
//                               Padding(
//                                 padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
//                                 child: Text(
//                                   'UserID（自動入力）',
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 15,
//                                   ),
//                                 ),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.all(10.0),
//                                 child: Text(
//                                   '[自動]',
//                                   style: TextStyle(
//                                     color: Colors.grey,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Text(
//                           _uid == null ? 'UserID作成中・・・' : 'あなたのUIDは $_uid です',
//                           style: const TextStyle(
//                             color: Colors.black,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                           ),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Container(
//                           color: Colors.brown.shade100,
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: <Widget>[
//                               Padding(
//                                 padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
//                                 child: Text(
//                                   'UserNameを入力してください',
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 15,
//                                   ),
//                                 ),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.all(10.0),
//                                 child: Text(
//                                   '[必須]',
//                                   style: TextStyle(
//                                     color: Colors.red,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       TextFormField(
//                         decoration: const InputDecoration(
//                           labelText: 'Name',
//                           border: OutlineInputBorder(),
//                         ),
//                         onChanged: (value) {
//                           setState(() {
//                             _name = value;
//                           });
//                           //バリテーションの更新：入力の確認
//                           _validateForm();
//                         },
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Container(
//                           color: Colors.brown.shade100,
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: <Widget>[
//                               Padding(
//                                 padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
//                                 child: Text(
//                                   '登録日時（自動入力）',
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 15,
//                                   ),
//                                 ),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.all(10.0),
//                                 child: Text(
//                                   '[自動]',
//                                   style: TextStyle(
//                                     color: Colors.grey,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Text(
//                           '登録日時: $_currentDateTime',
//                           style: const TextStyle(
//                             color: Colors.black,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                           ),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Container(
//                           color: Colors.brown.shade100,
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: <Widget>[
//                               Padding(
//                                 padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
//                                 child: Text(
//                                   '登録メールアドレス',
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 15,
//                                   ),
//                                 ),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.all(10.0),
//                                 child: Text(
//                                   '[必須]',
//                                   style: TextStyle(
//                                     color: Colors.red,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       TextFormField(
//                         decoration: const InputDecoration(
//                           labelText: 'メールアドレス',
//                           border: OutlineInputBorder(),
//                         ),
//                         keyboardType: TextInputType.emailAddress,
//                         onChanged: (value) {
//                           setState(() {
//                             _email = value;
//                           });
//                           _validateForm();
//                         },
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Container(
//                           color: Colors.brown.shade100,
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: <Widget>[
//                               Padding(
//                                 padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
//                                 child: Text(
//                                   '登録パスワード',
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 15,
//                                   ),
//                                 ),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.all(10.0),
//                                 child: Text(
//                                   '[必須]',
//                                   style: TextStyle(
//                                     color: Colors.red,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       TextFormField(
//                         decoration: InputDecoration(
//                           labelText: 'パスワード',
//                           border: OutlineInputBorder(),
//                           suffixIcon: IconButton(
//                             icon: Icon(
//                                 _obscurePassword ? Icons.visibility : Icons.visibility_off),
//                             onPressed: () {
//                               setState(() {
//                                 _obscurePassword = !_obscurePassword;
//                               });
//                             },
//                           ),
//                         ),
//                         obscureText: _obscurePassword,
//                         onChanged: (value) {
//                           setState(() {
//                             _password = value;
//                           });
//                           _validateForm();
//                         },
//                       ),
//                       const SizedBox(height: 16),
//                       TextFormField(
//                         decoration: InputDecoration(
//                           labelText: '確認用パスワード',
//                           border: OutlineInputBorder(),
//                           suffixIcon: IconButton(
//                             icon: Icon(_obscureConfirmPassword
//                                 ? Icons.visibility
//                                 : Icons.visibility_off),
//                             onPressed: () {
//                               setState(() {
//                                 _obscureConfirmPassword = !_obscureConfirmPassword;
//                               });
//                             },
//                           ),
//                         ),
//                         obscureText: _obscureConfirmPassword,
//                         onChanged: (value) {
//                           setState(() {
//                             _confirmPassword = value;
//                           });
//                           _validateForm();
//                         },
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Container(
//                           color: Colors.brown.shade100,
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: <Widget>[
//                               Padding(
//                                 padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
//                                 child: Text(
//                                   'プロフィール文入力',
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 15,
//                                   ),
//                                 ),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.all(10.0),
//                                 child: Text(
//                                   '[必須]',
//                                   style: TextStyle(
//                                     color: Colors.red,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       TextFormField(
//                         decoration: const InputDecoration(
//                           labelText: 'プロフィール文（150文字以内）',
//                           border: OutlineInputBorder(),
//                         ),
//                         maxLines: 5,
//                         onChanged: (value) {
//                           setState(() {
//                             _profile = value;
//                           });
//                           _validateForm();
//                         },
//                       ),
//                       const SizedBox(height: 16),
//                       SizedBox(
//                         width: double.infinity,
//                         height: 50,
//                         child: ElevatedButton(
//                           onPressed: _isFormValid ? _submitForm : null, // フォームの入力がすべて正しい場合のみボタン操作
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: _isFormValid ? Colors.red : Colors.grey,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                           ),
//                           child: const Text(
//                             '確定',
//                             style: TextStyle(color: Colors.white, fontSize: 18),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       Image.asset(
//                         'assets/images/bottomimage.png',
//                         width: 50,
//                         height: 50,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }


// // import 'dart:convert';
// // import 'dart:io';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:firebase_core/firebase_core.dart';
// // import 'package:flutter/material.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:image_picker/image_picker.dart';
// // import 'package:intl/intl.dart';
// // import 'package:yaonukabase004/firebase_options.dart';
// // import 'package:yaonukabase004/src/user/addpage.dart';

// // void main() async {
// //   WidgetsFlutterBinding.ensureInitialized();
// //   await Firebase.initializeApp(
// //     options: DefaultFirebaseOptions.currentPlatform,
// //   );
// //   runApp(const MyApp());
// // }

// // class MyApp extends StatelessWidget {
// //   const MyApp({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       title: 'YAONUKA.com',
// //       theme: ThemeData(
// //         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
// //         useMaterial3: true,
// //       ),
// //       home: const UserAddPage(),
// //     );
// //   }
// // }

// // class UserAddPage extends StatefulWidget {
// //   const UserAddPage({super.key});

// //   @override
// //   _UserAddPageState createState() => _UserAddPageState();
// // }

// // class _UserAddPageState extends State<UserAddPage> {
// //   String? _imagePath;
// //   String _userId = '';
// //   String _name = '';
// //   String _email = '';
// //   String _password = '';
// //   String _confirmPassword = '';
// //   String _profile = '';
// //   bool _obscurePassword = true;
// //   bool _obscureConfirmPassword = true;
// //   String? _uid;
  

// //   final String _currentDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
  
// //   // フォームのバリデーションメソッドの追加
// //   //　各入力フィールドが空ではないか確認する
// //   bool _isFormValid = false;
// //   void _validateForm() {
// //     setState(() {
// //       _isFormValid = _name.isNotEmpty &&
// //           _email.isNotEmpty &&
// //           _password.isNotEmpty &&
// //           _confirmPassword.isNotEmpty &&
// //           _profile.isNotEmpty;
// //     });
// //   }
// //   //////////////////////////////////////

// //   Future<void> _pickImage() async {
// //     final picker = ImagePicker();
// //     final pickedFile = await picker.pickImage(source: ImageSource.gallery);

// //     setState(() {
// //       if (pickedFile != null) {
// //         _imagePath = pickedFile.path;
// //       }
// //     });
// //   }

// //   Future<void> _submitForm() async {
// //     try {
// //       final UserCredential userCredential = await FirebaseAuth.instance
// //           .createUserWithEmailAndPassword(
// //         email: _email,
// //         password: _password,
// //       );

// //       final User? user = userCredential.user;

// //       if (user != null) {
// //         print("ユーザ登録しました ${user.email} , ${user.uid}");
// //         setState(() {
// //           _uid = user.uid;
// //         });

// //         // JSONデータを生成
// //         var requestBody = json.encode({
// //           'userid': _uid,
// //           'username':_name,
// //           'usertype': 'User',
// //           'createdat': _currentDateTime,
// //           'userprofile': _profile,
// //           'numberofpoints': 0,
// //           'companyname': '',
// //           'companyprofile': '',
// //           'companyfield': '',
// //           'companyskill': '',
// //           'coordinatorname': '',
// //           'coordinatorskillname': '',
// //           'coordinatorfieldname': '',
// //         });

// //         print("Sending JSON Data: $requestBody");

// //         final response = await http.post(
// //           Uri.parse('https://create-user.azurewebsites.net/api/create_user'),
// //           headers: {'Content-Type': 'application/json'},
// //           body: requestBody,
// //         );

// //         if (response.statusCode == 200) {
// //           print("データが正常に送信されました");
// //           Navigator.push(
// //             context,
// //             MaterialPageRoute(builder: (context) => const AddConPage()),
// //           );

// //         } else {
// //           print("エラーが発生しました: ${response.body}");
// //         }
// //       } else {
// //         print("ユーザー登録に失敗しました。");
// //       }
// //     } catch (e) {
// //       print("エラーが発生しました: $e");
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('アカウント作成'),
// //       ),
// //       body: LayoutBuilder(
// //         builder: (context, constraints) {
// //           double width = constraints.maxWidth * 0.5;
// //           if (constraints.maxWidth < 800) {
// //             width = constraints.maxWidth * 0.9;
// //           }
// //           return SingleChildScrollView(
// //             child: Padding(
// //               padding: const EdgeInsets.all(16.0),
// //               child: Center(
// //                 child: Container(
// //                   width: width,
// //                   child: Column(
// //                     children: <Widget>[
// //                       Padding(
// //                         padding: const EdgeInsets.all(8.0),
// //                         child: Container(
// //                           color: Colors.brown.shade100,
// //                           child: Row(
// //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                             children: <Widget>[
// //                               Padding(
// //                                 padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
// //                                 child: Text(
// //                                   'プロフィール写真アップロード',
// //                                   style: TextStyle(
// //                                     fontWeight: FontWeight.bold,
// //                                     fontSize: 15,
// //                                   ),
// //                                 ),
// //                               ),
// //                               Padding(
// //                                 padding: const EdgeInsets.all(10.0),
// //                                 child: Text(
// //                                   '[任意]',
// //                                   style: TextStyle(
// //                                     color: Colors.red.shade700,
// //                                     fontWeight: FontWeight.bold,
// //                                   ),
// //                                 ),
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                       ),
// //                       GestureDetector(
// //                         onTap: _pickImage,
// //                         child: CircleAvatar(
// //                           radius: 40,
// //                           backgroundImage:
// //                               _imagePath != null ? FileImage(File(_imagePath!)) : null,
// //                           child: _imagePath == null
// //                               ? const Icon(Icons.person, size: 40)
// //                               : null,
// //                         ),
// //                       ),
// //                       const SizedBox(height: 2),
// //                       Text(
// //                         '▲',
// //                         style: const TextStyle(
// //                           color: Colors.black,
// //                           fontWeight: FontWeight.bold,
// //                           fontSize: 16,
// //                         ),
// //                       ),
// //                       Padding(
// //                         padding: const EdgeInsets.all(0.0),
// //                         child: Text(
// //                           'アイコンをクリックして写真をアップロードしてください',
// //                           style: const TextStyle(
// //                             color: Colors.black,
// //                             fontWeight: FontWeight.bold,
// //                             fontSize: 16,
// //                           ),
// //                         ),
// //                       ),
// //                       Padding(
// //                         padding: const EdgeInsets.all(8.0),
// //                         child: Container(
// //                           color: Colors.brown.shade100,
// //                           child: Row(
// //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                             children: <Widget>[
// //                               Padding(
// //                                 padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
// //                                 child: Text(
// //                                   'UserID（自動入力）',
// //                                   style: TextStyle(
// //                                     fontWeight: FontWeight.bold,
// //                                     fontSize: 15,
// //                                   ),
// //                                 ),
// //                               ),
// //                               Padding(
// //                                 padding: const EdgeInsets.all(10.0),
// //                                 child: Text(
// //                                   '[自動]',
// //                                   style: TextStyle(
// //                                     color: Colors.grey,
// //                                     fontWeight: FontWeight.bold,
// //                                   ),
// //                                 ),
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                       ),
// //                       Padding(
// //                         padding: const EdgeInsets.all(8.0),
// //                         child: Text(
// //                           _uid == null ? 'UserID作成中・・・' : 'あなたのUIDは $_uid です',
// //                           style: const TextStyle(
// //                             color: Colors.black,
// //                             fontWeight: FontWeight.bold,
// //                             fontSize: 16,
// //                           ),
// //                         ),
// //                       ),
// //                       Padding(
// //                         padding: const EdgeInsets.all(8.0),
// //                         child: Container(
// //                           color: Colors.brown.shade100,
// //                           child: Row(
// //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                             children: <Widget>[
// //                               Padding(
// //                                 padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
// //                                 child: Text(
// //                                   'UserNameを入力してください',
// //                                   style: TextStyle(
// //                                     fontWeight: FontWeight.bold,
// //                                     fontSize: 15,
// //                                   ),
// //                                 ),
// //                               ),
// //                               Padding(
// //                                 padding: const EdgeInsets.all(10.0),
// //                                 child: Text(
// //                                   '[必須]',
// //                                   style: TextStyle(
// //                                     color: Colors.red,
// //                                     fontWeight: FontWeight.bold,
// //                                   ),
// //                                 ),
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                       ),
// //                       TextFormField(
// //                         decoration: const InputDecoration(
// //                           labelText: 'Name',
// //                           border: OutlineInputBorder(),
// //                         ),
// //                         onChanged: (value) {
// //                           setState(() {
// //                             _name = value;
// //                           });
// //                           //バリテーションの更新：入力の確認
// //                           _validateForm();
// //                         },
// //                       ),
// //                       Padding(
// //                         padding: const EdgeInsets.all(8.0),
// //                         child: Container(
// //                           color: Colors.brown.shade100,
// //                           child: Row(
// //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                             children: <Widget>[
// //                               Padding(
// //                                 padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
// //                                 child: Text(
// //                                   '登録日時（自動入力）',
// //                                   style: TextStyle(
// //                                     fontWeight: FontWeight.bold,
// //                                     fontSize: 15,
// //                                   ),
// //                                 ),
// //                               ),
// //                               Padding(
// //                                 padding: const EdgeInsets.all(10.0),
// //                                 child: Text(
// //                                   '[自動]',
// //                                   style: TextStyle(
// //                                     color: Colors.grey,
// //                                     fontWeight: FontWeight.bold,
// //                                   ),
// //                                 ),
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                       ),
// //                       Padding(
// //                         padding: const EdgeInsets.all(8.0),
// //                         child: Text(
// //                           '登録日時: $_currentDateTime',
// //                           style: const TextStyle(
// //                             color: Colors.black,
// //                             fontWeight: FontWeight.bold,
// //                             fontSize: 16,
// //                           ),
// //                         ),
// //                       ),
// //                       Padding(
// //                         padding: const EdgeInsets.all(8.0),
// //                         child: Container(
// //                           color: Colors.brown.shade100,
// //                           child: Row(
// //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                             children: <Widget>[
// //                               Padding(
// //                                 padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
// //                                 child: Text(
// //                                   '登録メールアドレス',
// //                                   style: TextStyle(
// //                                     fontWeight: FontWeight.bold,
// //                                     fontSize: 15,
// //                                   ),
// //                                 ),
// //                               ),
// //                               Padding(
// //                                 padding: const EdgeInsets.all(10.0),
// //                                 child: Text(
// //                                   '[必須]',
// //                                   style: TextStyle(
// //                                     color: Colors.red,
// //                                     fontWeight: FontWeight.bold,
// //                                   ),
// //                                 ),
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                       ),
// //                       TextFormField(
// //                         decoration: const InputDecoration(
// //                           labelText: 'メールアドレス',
// //                           border: OutlineInputBorder(),
// //                         ),
// //                         keyboardType: TextInputType.emailAddress,
// //                         onChanged: (value) {
// //                           setState(() {
// //                             _email = value;
// //                           });
// //                           _validateForm();
// //                         },
// //                       ),
// //                       Padding(
// //                         padding: const EdgeInsets.all(8.0),
// //                         child: Container(
// //                           color: Colors.brown.shade100,
// //                           child: Row(
// //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                             children: <Widget>[
// //                               Padding(
// //                                 padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
// //                                 child: Text(
// //                                   '登録パスワード',
// //                                   style: TextStyle(
// //                                     fontWeight: FontWeight.bold,
// //                                     fontSize: 15,
// //                                   ),
// //                                 ),
// //                               ),
// //                               Padding(
// //                                 padding: const EdgeInsets.all(10.0),
// //                                 child: Text(
// //                                   '[必須]',
// //                                   style: TextStyle(
// //                                     color: Colors.red,
// //                                     fontWeight: FontWeight.bold,
// //                                   ),
// //                                 ),
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                       ),
// //                       TextFormField(
// //                         decoration: InputDecoration(
// //                           labelText: 'パスワード',
// //                           border: OutlineInputBorder(),
// //                           suffixIcon: IconButton(
// //                             icon: Icon(
// //                                 _obscurePassword ? Icons.visibility : Icons.visibility_off),
// //                             onPressed: () {
// //                               setState(() {
// //                                 _obscurePassword = !_obscurePassword;
// //                               });
// //                             },
// //                           ),
// //                         ),
// //                         obscureText: _obscurePassword,
// //                         onChanged: (value) {
// //                           setState(() {
// //                             _password = value;
// //                           });
// //                           _validateForm();
// //                         },
// //                       ),
// //                       const SizedBox(height: 16),
// //                       TextFormField(
// //                         decoration: InputDecoration(
// //                           labelText: '確認用パスワード',
// //                           border: OutlineInputBorder(),
// //                           suffixIcon: IconButton(
// //                             icon: Icon(_obscureConfirmPassword
// //                                 ? Icons.visibility
// //                                 : Icons.visibility_off),
// //                             onPressed: () {
// //                               setState(() {
// //                                 _obscureConfirmPassword = !_obscureConfirmPassword;
// //                               });
// //                             },
// //                           ),
// //                         ),
// //                         obscureText: _obscureConfirmPassword,
// //                         onChanged: (value) {
// //                           setState(() {
// //                             _confirmPassword = value;
// //                           });
// //                           _validateForm();
// //                         },
// //                       ),
// //                       Padding(
// //                         padding: const EdgeInsets.all(8.0),
// //                         child: Container(
// //                           color: Colors.brown.shade100,
// //                           child: Row(
// //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                             children: <Widget>[
// //                               Padding(
// //                                 padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
// //                                 child: Text(
// //                                   'プロフィール文入力',
// //                                   style: TextStyle(
// //                                     fontWeight: FontWeight.bold,
// //                                     fontSize: 15,
// //                                   ),
// //                                 ),
// //                               ),
// //                               Padding(
// //                                 padding: const EdgeInsets.all(10.0),
// //                                 child: Text(
// //                                   '[必須]',
// //                                   style: TextStyle(
// //                                     color: Colors.red,
// //                                     fontWeight: FontWeight.bold,
// //                                   ),
// //                                 ),
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                       ),
// //                       TextFormField(
// //                         decoration: const InputDecoration(
// //                           labelText: 'プロフィール文（150文字以内）',
// //                           border: OutlineInputBorder(),
// //                         ),
// //                         maxLines: 5,
// //                         onChanged: (value) {
// //                           setState(() {
// //                             _profile = value;
// //                           });
// //                           _validateForm();
// //                         },
// //                       ),
// //                       const SizedBox(height: 16),
// //                       SizedBox(
// //                         width: double.infinity,
// //                         height: 50,
// //                         child: ElevatedButton(
// //                           onPressed: _isFormValid ? _submitForm : null, //フォームの入力がすべて正しい場合のみボタン操作
// //                           style: ElevatedButton.styleFrom(
// //                             backgroundColor: _isFormValid ? Colors.red : Colors.grey,
// //                             shape: RoundedRectangleBorder(
// //                               borderRadius: BorderRadius.circular(10),
// //                             ),
// //                           ),
// //                           child: const Text(
// //                             '確定',
// //                             style: TextStyle(color: Colors.white, fontSize: 18),
// //                           ),
// //                         ),
// //                       ),
// //                       const SizedBox(height: 16),
// //                       Image.asset(
// //                         'assets/images/bottomimage.png',
// //                         width: 50,
// //                         height: 50,
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //             ),
// //           );
// //         },
// //       ),
// //     );
// //   }
// // }

// // import 'dart:convert';
// // import 'dart:io';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:firebase_core/firebase_core.dart';
// // import 'package:flutter/material.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:image_picker/image_picker.dart';
// // import 'package:intl/intl.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:yaonukabase004/firebase_options.dart';

// // void main() async {
// //   WidgetsFlutterBinding.ensureInitialized();
// //   await Firebase.initializeApp(
// //     options: DefaultFirebaseOptions.currentPlatform,
// //   );
// //   runApp(const MyApp());
// // }

// // class MyApp extends StatelessWidget {
// //   const MyApp({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       title: 'YAONUKA.com',
// //       theme: ThemeData(
// //         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
// //         useMaterial3: true,
// //       ),
// //       home: const UserAddPage(),
// //     );
// //   }
// // }

// // class UserAddPage extends StatefulWidget {
// //   const UserAddPage({super.key});

// //   @override
// //   _UserAddPageState createState() => _UserAddPageState();
// // }

// // class _UserAddPageState extends State<UserAddPage> {
// //   String? _imagePath;
// //   String _userId = '';
// //   String _name = '';
// //   String _email = '';
// //   String _password = '';
// //   String _confirmPassword = '';
// //   String _profile = '';
// //   bool _obscurePassword = true;
// //   bool _obscureConfirmPassword = true;
// //   String? _uid;

// //   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

// //   final String _currentDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

// //   // フォームのバリデーションメソッドの追加
// //   // 各入力フィールドが空ではないか確認する
// //   bool _isFormValid = false;
// //   void _validateForm() {
// //     setState(() {
// //       _isFormValid = _name.isNotEmpty &&
// //           _email.isNotEmpty &&
// //           _password.isNotEmpty &&
// //           _confirmPassword.isNotEmpty;
// //     });
// //   }

// //   Future<void> _pickImage() async {
// //     final picker = ImagePicker();
// //     final pickedFile = await picker.pickImage(source: ImageSource.gallery);

// //     setState(() {
// //       if (pickedFile != null) {
// //         _imagePath = pickedFile.path;
// //       }
// //     });
// //   }

// //   Future<void> _submitForm() async {
// //     try {
// //       final UserCredential userCredential = await FirebaseAuth.instance
// //           .createUserWithEmailAndPassword(
// //         email: _email,
// //         password: _password,
// //       );

// //       final User? user = userCredential.user;

// //       if (user != null) {
// //         print("ユーザ登録しました ${user.email} , ${user.uid}");
// //         setState(() {
// //           _uid = user.uid;
// //         });

// //         // Firestoreにデータを保存
// //         final usersCollection = _firestore.collection('users');
// //         final docRef = usersCollection.doc(_uid);

// //         // ドキュメントが存在しない場合に新規作成
// //         await docRef.set({
// //           'uid': _uid, // Firebase Authから取得
// //           'role': 'user', // 固定値として設定
// //           'username': _name,
// //           'created_at': _currentDateTime,
// //         });

// //         print("Firestoreにデータを保存しました");
// //       } else {
// //         print("ユーザー登録に失敗しました。");
// //       }
// //     } catch (e) {
// //       print("エラーが発生しました: $e");
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('アカウント作成'),
// //       ),
// //       body: LayoutBuilder(
// //         builder: (context, constraints) {
// //           double width = constraints.maxWidth * 0.5;
// //           if (constraints.maxWidth < 800) {
// //             width = constraints.maxWidth * 0.9;
// //           }
// //           return SingleChildScrollView(
// //             child: Padding(
// //               padding: const EdgeInsets.all(16.0),
// //               child: Center(
// //                 child: Container(
// //                   width: width,
// //                   child: Column(
// //                     children: <Widget>[
// //                       Padding(
// //                         padding: const EdgeInsets.all(8.0),
// //                         child: Container(
// //                           color: Colors.brown.shade100,
// //                           child: Row(
// //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                             children: <Widget>[
// //                               Padding(
// //                                 padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
// //                                 child: Text(
// //                                   'プロフィール写真アップロード',
// //                                   style: TextStyle(
// //                                     fontWeight: FontWeight.bold,
// //                                     fontSize: 15,
// //                                   ),
// //                                 ),
// //                               ),
// //                               Padding(
// //                                 padding: const EdgeInsets.all(10.0),
// //                                 child: Text(
// //                                   '[任意]',
// //                                   style: TextStyle(
// //                                     color: Colors.red.shade700,
// //                                     fontWeight: FontWeight.bold,
// //                                   ),
// //                                 ),
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                       ),
// //                       GestureDetector(
// //                         onTap: _pickImage,
// //                         child: CircleAvatar(
// //                           radius: 40,
// //                           backgroundImage:
// //                               _imagePath != null ? FileImage(File(_imagePath!)) : null,
// //                           child: _imagePath == null
// //                               ? const Icon(Icons.person, size: 40)
// //                               : null,
// //                         ),
// //                       ),
// //                       const SizedBox(height: 2),
// //                       Text(
// //                         '▲',
// //                         style: const TextStyle(
// //                           color: Colors.black,
// //                           fontWeight: FontWeight.bold,
// //                           fontSize: 16,
// //                         ),
// //                       ),
// //                       Padding(
// //                         padding: const EdgeInsets.all(0.0),
// //                         child: Text(
// //                           'アイコンをクリックして写真をアップロードしてください',
// //                           style: const TextStyle(
// //                             color: Colors.black,
// //                             fontWeight: FontWeight.bold,
// //                             fontSize: 16,
// //                           ),
// //                         ),
// //                       ),
// //                       Padding(
// //                         padding: const EdgeInsets.all(8.0),
// //                         child: Container(
// //                           color: Colors.brown.shade100,
// //                           child: Row(
// //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                             children: <Widget>[
// //                               Padding(
// //                                 padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
// //                                 child: Text(
// //                                   'UserID（自動入力）',
// //                                   style: TextStyle(
// //                                     fontWeight: FontWeight.bold,
// //                                     fontSize: 15,
// //                                   ),
// //                                 ),
// //                               ),
// //                               Padding(
// //                                 padding: const EdgeInsets.all(10.0),
// //                                 child: Text(
// //                                   '[自動]',
// //                                   style: TextStyle(
// //                                     color: Colors.grey,
// //                                     fontWeight: FontWeight.bold,
// //                                   ),
// //                                 ),
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                       ),
// //                       Padding(
// //                         padding: const EdgeInsets.all(8.0),
// //                         child: Text(
// //                           _uid == null ? 'UserID作成中・・・' : 'あなたのUIDは $_uid です',
// //                           style: const TextStyle(
// //                             color: Colors.black,
// //                             fontWeight: FontWeight.bold,
// //                             fontSize: 16,
// //                           ),
// //                         ),
// //                       ),
// //                       Padding(
// //                         padding: const EdgeInsets.all(8.0),
// //                         child: Container(
// //                           color: Colors.brown.shade100,
// //                           child: Row(
// //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                             children: <Widget>[
// //                               Padding(
// //                                 padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
// //                                 child: Text(
// //                                   'UserNameを入力してください',
// //                                   style: TextStyle(
// //                                     fontWeight: FontWeight.bold,
// //                                     fontSize: 15,
// //                                   ),
// //                                 ),
// //                               ),
// //                               Padding(
// //                                 padding: const EdgeInsets.all(10.0),
// //                                 child: Text(
// //                                   '[必須]',
// //                                   style: TextStyle(
// //                                     color: Colors.red,
// //                                     fontWeight: FontWeight.bold,
// //                                   ),
// //                                 ),
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                       ),
// //                       TextFormField(
// //                         decoration: const InputDecoration(
// //                           labelText: 'Name',
// //                           border: OutlineInputBorder(),
// //                         ),
// //                         onChanged: (value) {
// //                           setState(() {
// //                             _name = value;
// //                           });
// //                           // バリテーションの更新：入力の確認
// //                           _validateForm();
// //                         },
// //                       ),
// //                       Padding(
// //                         padding: const EdgeInsets.all(8.0),
// //                         child: Container(
// //                           color: Colors.brown.shade100,
// //                           child: Row(
// //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                             children: <Widget>[
// //                               Padding(
// //                                 padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
// //                                 child: Text(
// //                                   '登録日時（自動入力）',
// //                                   style: TextStyle(
// //                                     fontWeight: FontWeight.bold,
// //                                     fontSize: 15,
// //                                   ),
// //                                 ),
// //                               ),
// //                               Padding(
// //                                 padding: const EdgeInsets.all(10.0),
// //                                 child: Text(
// //                                   '[自動]',
// //                                   style: TextStyle(
// //                                     color: Colors.grey,
// //                                     fontWeight: FontWeight.bold,
// //                                   ),
// //                                 ),
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                       ),
// //                       Padding(
// //                         padding: const EdgeInsets.all(8.0),
// //                         child: Text(
// //                           '登録日時: $_currentDateTime',
// //                           style: const TextStyle(
// //                             color: Colors.black,
// //                             fontWeight: FontWeight.bold,
// //                             fontSize: 16,
// //                           ),
// //                         ),
// //                       ),
// //                       Padding(
// //                         padding: const EdgeInsets.all(8.0),
// //                         child: Container(
// //                           color: Colors.brown.shade100,
// //                           child: Row(
// //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                             children: <Widget>[
// //                               Padding(
// //                                 padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
// //                                 child: Text(
// //                                   '登録メールアドレス',
// //                                   style: TextStyle(
// //                                     fontWeight: FontWeight.bold,
// //                                     fontSize: 15,
// //                                   ),
// //                                 ),
// //                               ),
// //                               Padding(
// //                                 padding: const EdgeInsets.all(10.0),
// //                                 child: Text(
// //                                   '[必須]',
// //                                   style: TextStyle(
// //                                     color: Colors.red,
// //                                     fontWeight: FontWeight.bold,
// //                                   ),
// //                                 ),
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                       ),
// //                       TextFormField(
// //                         decoration: const InputDecoration(
// //                           labelText: 'メールアドレス',
// //                           border: OutlineInputBorder(),
// //                         ),
// //                         keyboardType: TextInputType.emailAddress,
// //                         onChanged: (value) {
// //                           setState(() {
// //                             _email = value;
// //                           });
// //                           _validateForm();
// //                         },
// //                       ),
// //                       Padding(
// //                         padding: const EdgeInsets.all(8.0),
// //                         child: Container(
// //                           color: Colors.brown.shade100,
// //                           child: Row(
// //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                             children: <Widget>[
// //                               Padding(
// //                                 padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
// //                                 child: Text(
// //                                   '登録パスワード',
// //                                   style: TextStyle(
// //                                     fontWeight: FontWeight.bold,
// //                                     fontSize: 15,
// //                                   ),
// //                                 ),
// //                               ),
// //                               Padding(
// //                                 padding: const EdgeInsets.all(10.0),
// //                                 child: Text(
// //                                   '[必須]',
// //                                   style: TextStyle(
// //                                     color: Colors.red,
// //                                     fontWeight: FontWeight.bold,
// //                                   ),
// //                                 ),
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                       ),
// //                       TextFormField(
// //                         decoration: InputDecoration(
// //                           labelText: 'パスワード',
// //                           border: OutlineInputBorder(),
// //                           suffixIcon: IconButton(
// //                             icon: Icon(
// //                                 _obscurePassword ? Icons.visibility : Icons.visibility_off),
// //                             onPressed: () {
// //                               setState(() {
// //                                 _obscurePassword = !_obscurePassword;
// //                               });
// //                             },
// //                           ),
// //                         ),
// //                         obscureText: _obscurePassword,
// //                         onChanged: (value) {
// //                           setState(() {
// //                             _password = value;
// //                           });
// //                           _validateForm();
// //                         },
// //                       ),
// //                       const SizedBox(height: 16),
// //                       TextFormField(
// //                         decoration: InputDecoration(
// //                           labelText: '確認用パスワード',
// //                           border: OutlineInputBorder(),
// //                           suffixIcon: IconButton(
// //                             icon: Icon(_obscureConfirmPassword
// //                                 ? Icons.visibility
// //                                 : Icons.visibility_off),
// //                             onPressed: () {
// //                               setState(() {
// //                                 _obscureConfirmPassword = !_obscureConfirmPassword;
// //                               });
// //                             },
// //                           ),
// //                         ),
// //                         obscureText: _obscureConfirmPassword,
// //                         onChanged: (value) {
// //                           setState(() {
// //                             _confirmPassword = value;
// //                           });
// //                           _validateForm();
// //                         },
// //                       ),
// //                       Padding(
// //                         padding: const EdgeInsets.all(8.0),
// //                         child: Container(
// //                           color: Colors.brown.shade100,
// //                           child: Row(
// //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                             children: <Widget>[
// //                               Padding(
// //                                 padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
// //                                 child: Text(
// //                                   'プロフィール文入力',
// //                                   style: TextStyle(
// //                                     fontWeight: FontWeight.bold,
// //                                     fontSize: 15,
// //                                   ),
// //                                 ),
// //                               ),
// //                               Padding(
// //                                 padding: const EdgeInsets.all(10.0),
// //                                 child: Text(
// //                                   '[必須]',
// //                                   style: TextStyle(
// //                                     color: Colors.red,
// //                                     fontWeight: FontWeight.bold,
// //                                   ),
// //                                 ),
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                       ),
// //                       TextFormField(
// //                         decoration: const InputDecoration(
// //                           labelText: 'プロフィール文（150文字以内）',
// //                           border: OutlineInputBorder(),
// //                         ),
// //                         maxLines: 5,
// //                         onChanged: (value) {
// //                           setState(() {
// //                             _profile = value;
// //                           });
// //                           _validateForm();
// //                         },
// //                       ),
// //                       const SizedBox(height: 16),
// //                       SizedBox(
// //                         width: double.infinity,
// //                         height: 50,
// //                         child: ElevatedButton(
// //                           onPressed: _isFormValid ? _submitForm : null, // フォームの入力がすべて正しい場合のみボタン操作
// //                           style: ElevatedButton.styleFrom(
// //                             backgroundColor: _isFormValid ? Colors.red : Colors.grey,
// //                             shape: RoundedRectangleBorder(
// //                               borderRadius: BorderRadius.circular(10),
// //                             ),
// //                           ),
// //                           child: const Text(
// //                             '確定',
// //                             style: TextStyle(color: Colors.white, fontSize: 18),
// //                           ),
// //                         ),
// //                       ),
// //                       const SizedBox(height: 16),
// //                       Image.asset(
// //                         'assets/images/bottomimage.png',
// //                         width: 50,
// //                         height: 50,
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //             ),
// //           );
// //         },
// //       ),
// //     );
// //   }
// // }

// // // import 'dart:convert';
// // // import 'dart:io';
// // // import 'package:firebase_auth/firebase_auth.dart';
// // // import 'package:firebase_core/firebase_core.dart';
// // // import 'package:flutter/material.dart';
// // // import 'package:http/http.dart' as http;
// // // import 'package:image_picker/image_picker.dart';
// // // import 'package:intl/intl.dart';
// // // import 'package:cloud_firestore/cloud_firestore.dart';
// // // import 'package:yaonukabase004/firebase_options.dart';
// // // import 'package:yaonukabase004/src/user/addpage.dart';

// // // void main() async {
// // //   WidgetsFlutterBinding.ensureInitialized();
// // //   await Firebase.initializeApp(
// // //     options: DefaultFirebaseOptions.currentPlatform,
// // //   );
// // //   runApp(const MyApp());
// // // }

// // // class MyApp extends StatelessWidget {
// // //   const MyApp({super.key});

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return MaterialApp(
// // //       title: 'YAONUKA.com',
// // //       theme: ThemeData(
// // //         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
// // //         useMaterial3: true,
// // //       ),
// // //       home: const UserAddPage(),
// // //     );
// // //   }
// // // }

// // // class UserAddPage extends StatefulWidget {
// // //   const UserAddPage({super.key});

// // //   @override
// // //   _UserAddPageState createState() => _UserAddPageState();
// // // }

// // // class _UserAddPageState extends State<UserAddPage> {
// // //   String? _imagePath;
// // //   String _userId = '';
// // //   String _name = '';
// // //   String _email = '';
// // //   String _password = '';
// // //   String _confirmPassword = '';
// // //   String _profile = '';
// // //   bool _obscurePassword = true;
// // //   bool _obscureConfirmPassword = true;
// // //   String? _uid;

// // //   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

// // //   final String _currentDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

// // //   // フォームのバリデーションメソッドの追加
// // //   // 各入力フィールドが空ではないか確認する
// // //   bool _isFormValid = false;
// // //   void _validateForm() {
// // //     setState(() {
// // //       _isFormValid = _name.isNotEmpty &&
// // //           _email.isNotEmpty &&
// // //           _password.isNotEmpty &&
// // //           _confirmPassword.isNotEmpty;
// // //     });
// // //   }

// // //   Future<void> _pickImage() async {
// // //     final picker = ImagePicker();
// // //     final pickedFile = await picker.pickImage(source: ImageSource.gallery);

// // //     setState(() {
// // //       if (pickedFile != null) {
// // //         _imagePath = pickedFile.path;
// // //       }
// // //     });
// // //   }

// // //   Future<void> _submitForm() async {
// // //     try {
// // //       final UserCredential userCredential = await FirebaseAuth.instance
// // //           .createUserWithEmailAndPassword(
// // //         email: _email,
// // //         password: _password,
// // //       );

// // //       final User? user = userCredential.user;

// // //       if (user != null) {
// // //         print("ユーザ登録しました ${user.email} , ${user.uid}");
// // //         setState(() {
// // //           _uid = user.uid;
// // //         });

// // //         // Firestoreにデータを保存
// // //         final usersCollection = _firestore.collection('users');
// // //         final docRef = usersCollection.doc(_uid);

// // //         // ドキュメントが存在しない場合に新規作成
// // //         await docRef.set({
// // //           'uid': _uid, // Firebase Authから取得
// // //           'role': 'user', // 固定値として設定
// // //           'username': _name,
// // //           'created_at': _currentDateTime,
// // //         });

// // //         print("Firestoreにデータを保存しました");
// // //         Navigator.push(
// // //           context,
// // //           MaterialPageRoute(builder: (context) => const AddConPage()),
// // //         );

// // //       } else {
// // //         print("ユーザー登録に失敗しました。");
// // //       }
// // //     } catch (e) {
// // //       print("エラーが発生しました: $e");
// // //     }
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         title: const Text('アカウント作成'),
// // //       ),
// // //       body: LayoutBuilder(
// // //         builder: (context, constraints) {
// // //           double width = constraints.maxWidth * 0.5;
// // //           if (constraints.maxWidth < 800) {
// // //             width = constraints.maxWidth * 0.9;
// // //           }
// // //           return SingleChildScrollView(
// // //             child: Padding(
// // //               padding: const EdgeInsets.all(16.0),
// // //               child: Center(
// // //                 child: Container(
// // //                   width: width,
// // //                   child: Column(
// // //                     children: <Widget>[
// // //                       Padding(
// // //                         padding: const EdgeInsets.all(8.0),
// // //                         child: Container(
// // //                           color: Colors.brown.shade100,
// // //                           child: Row(
// // //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // //                             children: <Widget>[
// // //                               Padding(
// // //                                 padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
// // //                                 child: Text(
// // //                                   'プロフィール写真アップロード',
// // //                                   style: TextStyle(
// // //                                     fontWeight: FontWeight.bold,
// // //                                     fontSize: 15,
// // //                                   ),
// // //                                 ),
// // //                               ),
// // //                               Padding(
// // //                                 padding: const EdgeInsets.all(10.0),
// // //                                 child: Text(
// // //                                   '[任意]',
// // //                                   style: TextStyle(
// // //                                     color: Colors.red.shade700,
// // //                                     fontWeight: FontWeight.bold,
// // //                                   ),
// // //                                 ),
// // //                               ),
// // //                             ],
// // //                           ),
// // //                         ),
// // //                       ),
// // //                       GestureDetector(
// // //                         onTap: _pickImage,
// // //                         child: CircleAvatar(
// // //                           radius: 40,
// // //                           backgroundImage:
// // //                               _imagePath != null ? FileImage(File(_imagePath!)) : null,
// // //                           child: _imagePath == null
// // //                               ? const Icon(Icons.person, size: 40)
// // //                               : null,
// // //                         ),
// // //                       ),
// // //                       const SizedBox(height: 2),
// // //                       Text(
// // //                         '▲',
// // //                         style: const TextStyle(
// // //                           color: Colors.black,
// // //                           fontWeight: FontWeight.bold,
// // //                           fontSize: 16,
// // //                         ),
// // //                       ),
// // //                       Padding(
// // //                         padding: const EdgeInsets.all(0.0),
// // //                         child: Text(
// // //                           'アイコンをクリックして写真をアップロードしてください',
// // //                           style: const TextStyle(
// // //                             color: Colors.black,
// // //                             fontWeight: FontWeight.bold,
// // //                             fontSize: 16,
// // //                           ),
// // //                         ),
// // //                       ),
// // //                       Padding(
// // //                         padding: const EdgeInsets.all(8.0),
// // //                         child: Container(
// // //                           color: Colors.brown.shade100,
// // //                           child: Row(
// // //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // //                             children: <Widget>[
// // //                               Padding(
// // //                                 padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
// // //                                 child: Text(
// // //                                   'UserID（自動入力）',
// // //                                   style: TextStyle(
// // //                                     fontWeight: FontWeight.bold,
// // //                                     fontSize: 15,
// // //                                   ),
// // //                                 ),
// // //                               ),
// // //                               Padding(
// // //                                 padding: const EdgeInsets.all(10.0),
// // //                                 child: Text(
// // //                                   '[自動]',
// // //                                   style: TextStyle(
// // //                                     color: Colors.grey,
// // //                                     fontWeight: FontWeight.bold,
// // //                                   ),
// // //                                 ),
// // //                               ),
// // //                             ],
// // //                           ),
// // //                         ),
// // //                       ),
// // //                       Padding(
// // //                         padding: const EdgeInsets.all(8.0),
// // //                         child: Text(
// // //                           _uid == null ? 'UserID作成中・・・' : 'あなたのUIDは $_uid です',
// // //                           style: const TextStyle(
// // //                             color: Colors.black,
// // //                             fontWeight: FontWeight.bold,
// // //                             fontSize: 16,
// // //                           ),
// // //                         ),
// // //                       ),
// // //                       Padding(
// // //                         padding: const EdgeInsets.all(8.0),
// // //                         child: Container(
// // //                           color: Colors.brown.shade100,
// // //                           child: Row(
// // //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // //                             children: <Widget>[
// // //                               Padding(
// // //                                 padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
// // //                                 child: Text(
// // //                                   'UserNameを入力してください',
// // //                                   style: TextStyle(
// // //                                     fontWeight: FontWeight.bold,
// // //                                     fontSize: 15,
// // //                                   ),
// // //                                 ),
// // //                               ),
// // //                               Padding(
// // //                                 padding: const EdgeInsets.all(10.0),
// // //                                 child: Text(
// // //                                   '[必須]',
// // //                                   style: TextStyle(
// // //                                     color: Colors.red,
// // //                                     fontWeight: FontWeight.bold,
// // //                                   ),
// // //                                 ),
// // //                               ),
// // //                             ],
// // //                           ),
// // //                         ),
// // //                       ),
// // //                       TextFormField(
// // //                         decoration: const InputDecoration(
// // //                           labelText: 'Name',
// // //                           border: OutlineInputBorder(),
// // //                         ),
// // //                         onChanged: (value) {
// // //                           setState(() {
// // //                             _name = value;
// // //                           });
// // //                           // バリテーションの更新：入力の確認
// // //                           _validateForm();
// // //                         },
// // //                       ),
// // //                       Padding(
// // //                         padding: const EdgeInsets.all(8.0),
// // //                         child: Container(
// // //                           color: Colors.brown.shade100,
// // //                           child: Row(
// // //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // //                             children: <Widget>[
// // //                               Padding(
// // //                                 padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
// // //                                 child: Text(
// // //                                   '登録日時（自動入力）',
// // //                                   style: TextStyle(
// // //                                     fontWeight: FontWeight.bold,
// // //                                     fontSize: 15,
// // //                                   ),
// // //                                 ),
// // //                               ),
// // //                               Padding(
// // //                                 padding: const EdgeInsets.all(10.0),
// // //                                 child: Text(
// // //                                   '[自動]',
// // //                                   style: TextStyle(
// // //                                     color: Colors.grey,
// // //                                     fontWeight: FontWeight.bold,
// // //                                   ),
// // //                                 ),
// // //                               ),
// // //                             ],
// // //                           ),
// // //                         ),
// // //                       ),
// // //                       Padding(
// // //                         padding: const EdgeInsets.all(8.0),
// // //                         child: Text(
// // //                           '登録日時: $_currentDateTime',
// // //                           style: const TextStyle(
// // //                             color: Colors.black,
// // //                             fontWeight: FontWeight.bold,
// // //                             fontSize: 16,
// // //                           ),
// // //                         ),
// // //                       ),
// // //                       Padding(
// // //                         padding: const EdgeInsets.all(8.0),
// // //                         child: Container(
// // //                           color: Colors.brown.shade100,
// // //                           child: Row(
// // //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // //                             children: <Widget>[
// // //                               Padding(
// // //                                 padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
// // //                                 child: Text(
// // //                                   '登録メールアドレス',
// // //                                   style: TextStyle(
// // //                                     fontWeight: FontWeight.bold,
// // //                                     fontSize: 15,
// // //                                   ),
// // //                                 ),
// // //                               ),
// // //                               Padding(
// // //                                 padding: const EdgeInsets.all(10.0),
// // //                                 child: Text(
// // //                                   '[必須]',
// // //                                   style: TextStyle(
// // //                                     color: Colors.red,
// // //                                     fontWeight: FontWeight.bold,
// // //                                   ),
// // //                                 ),
// // //                               ),
// // //                             ],
// // //                           ),
// // //                         ),
// // //                       ),
// // //                       TextFormField(
// // //                         decoration: const InputDecoration(
// // //                           labelText: 'メールアドレス',
// // //                           border: OutlineInputBorder(),
// // //                         ),
// // //                         keyboardType: TextInputType.emailAddress,
// // //                         onChanged: (value) {
// // //                           setState(() {
// // //                             _email = value;
// // //                           });
// // //                           _validateForm();
// // //                         },
// // //                       ),
// // //                       Padding(
// // //                         padding: const EdgeInsets.all(8.0),
// // //                         child: Container(
// // //                           color: Colors.brown.shade100,
// // //                           child: Row(
// // //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // //                             children: <Widget>[
// // //                               Padding(
// // //                                 padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
// // //                                 child: Text(
// // //                                   '登録パスワード',
// // //                                   style: TextStyle(
// // //                                     fontWeight: FontWeight.bold,
// // //                                     fontSize: 15,
// // //                                   ),
// // //                                 ),
// // //                               ),
// // //                               Padding(
// // //                                 padding: const EdgeInsets.all(10.0),
// // //                                 child: Text(
// // //                                   '[必須]',
// // //                                   style: TextStyle(
// // //                                     color: Colors.red,
// // //                                     fontWeight: FontWeight.bold,
// // //                                   ),
// // //                                 ),
// // //                               ),
// // //                             ],
// // //                           ),
// // //                         ),
// // //                       ),
// // //                       TextFormField(
// // //                         decoration: InputDecoration(
// // //                           labelText: 'パスワード',
// // //                           border: OutlineInputBorder(),
// // //                           suffixIcon: IconButton(
// // //                             icon: Icon(
// // //                                 _obscurePassword ? Icons.visibility : Icons.visibility_off),
// // //                             onPressed: () {
// // //                               setState(() {
// // //                                 _obscurePassword = !_obscurePassword;
// // //                               });
// // //                             },
// // //                           ),
// // //                         ),
// // //                         obscureText: _obscurePassword,
// // //                         onChanged: (value) {
// // //                           setState(() {
// // //                             _password = value;
// // //                           });
// // //                           _validateForm();
// // //                         },
// // //                       ),
// // //                       const SizedBox(height: 16),
// // //                       TextFormField(
// // //                         decoration: InputDecoration(
// // //                           labelText: '確認用パスワード',
// // //                           border: OutlineInputBorder(),
// // //                           suffixIcon: IconButton(
// // //                             icon: Icon(_obscureConfirmPassword
// // //                                 ? Icons.visibility
// // //                                 : Icons.visibility_off),
// // //                             onPressed: () {
// // //                               setState(() {
// // //                                 _obscureConfirmPassword = !_obscureConfirmPassword;
// // //                               });
// // //                             },
// // //                           ),
// // //                         ),
// // //                         obscureText: _obscureConfirmPassword,
// // //                         onChanged: (value) {
// // //                           setState(() {
// // //                             _confirmPassword = value;
// // //                           });
// // //                           _validateForm();
// // //                         },
// // //                       ),
// // //                       Padding(
// // //                         padding: const EdgeInsets.all(8.0),
// // //                         child: Container(
// // //                           color: Colors.brown.shade100,
// // //                           child: Row(
// // //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // //                             children: <Widget>[
// // //                               Padding(
// // //                                 padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
// // //                                 child: Text(
// // //                                   'プロフィール文入力',
// // //                                   style: TextStyle(
// // //                                     fontWeight: FontWeight.bold,
// // //                                     fontSize: 15,
// // //                                   ),
// // //                                 ),
// // //                               ),
// // //                               Padding(
// // //                                 padding: const EdgeInsets.all(10.0),
// // //                                 child: Text(
// // //                                   '[必須]',
// // //                                   style: TextStyle(
// // //                                     color: Colors.red,
// // //                                     fontWeight: FontWeight.bold,
// // //                                   ),
// // //                                 ),
// // //                               ),
// // //                             ],
// // //                           ),
// // //                         ),
// // //                       ),
// // //                       TextFormField(
// // //                         decoration: const InputDecoration(
// // //                           labelText: 'プロフィール文（150文字以内）',
// // //                           border: OutlineInputBorder(),
// // //                         ),
// // //                         maxLines: 5,
// // //                         onChanged: (value) {
// // //                           setState(() {
// // //                             _profile = value;
// // //                           });
// // //                           _validateForm();
// // //                         },
// // //                       ),
// // //                       const SizedBox(height: 16),
// // //                       SizedBox(
// // //                         width: double.infinity,
// // //                         height: 50,
// // //                         child: ElevatedButton(
// // //                           onPressed: _isFormValid ? _submitForm : null, // フォームの入力がすべて正しい場合のみボタン操作
// // //                           style: ElevatedButton.styleFrom(
// // //                             backgroundColor: _isFormValid ? Colors.red : Colors.grey,
// // //                             shape: RoundedRectangleBorder(
// // //                               borderRadius: BorderRadius.circular(10),
// // //                             ),
// // //                           ),
// // //                           child: const Text(
// // //                             '確定',
// // //                             style: TextStyle(color: Colors.white, fontSize: 18),
// // //                           ),
// // //                         ),
// // //                       ),
// // //                       const SizedBox(height: 16),
// // //                       Image.asset(
// // //                         'assets/images/bottomimage.png',
// // //                         width: 50,
// // //                         height: 50,
// // //                       ),
// // //                     ],
// // //                   ),
// // //                 ),
// // //               ),
// // //             ),
// // //           );
// // //         },
// // //       ),
// // //     );
// // //   }
// // // }



