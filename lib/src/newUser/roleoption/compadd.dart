import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
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
      home: const CompaddPage(),
    );
  }
}

class CompaddPage extends StatefulWidget {
  const CompaddPage({super.key});

  @override
  _CompaddPageState createState() => _CompaddPageState();
}

class _CompaddPageState extends State<CompaddPage> {
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

  final String _currentDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

  // 入力フォームNULLチェック
  bool _isFormValid = false;

  void _validateForm(){
    setState(() {
      _isFormValid = _name.isNotEmpty &&
          _email.isNotEmpty &&
          _password.isNotEmpty &&
          _confirmPassword.isNotEmpty &&
          _profile.isNotEmpty;
    });
  }

  String _tech1 = '未選択';
  String _tech2 = '未選択';

  // プルダウンメニューの選択肢
  final List<String> menuItems1 = ['未選択', '機械加工', '金属加工', '電子機器製造', '航空宇宙製造', 'プラスチック加工', '繊維製造']; //主メニュー
  final List<String> menuItems2 = ['未選択']; //未設定
  final List<String> menuItems3 = [' ','未選択', '旋盤加工', 'フライス加工', '放電加工', '研削加工', '熱処理', '金型設計と製造', 'CAD/CAMプログラミング', 'CNC制御']; //機械加工
  final List<String> menuItems4 = [' ','未選択', '鋳造', '鍛造', '溶接', '板金加工', '金属プレス', 'パウダーメタル成形', '表面処理（メッキ、塗装）', 'レーザー切断']; //金属加工
  final List<String> menuItems5 = [' ','未選択', 'プリント基板（PCB）設計と製造', '表面実装技術（SMT）', 'はんだ付け', '組み立て・検査自動化', '半導体製造', 'エレクトロニクスパッケージング', '絶縁処理', '電磁適合性（EMC）設計']; //電子機器製造
  final List<String> menuItems6 = [' ','未選択', 'エアフレーム設計と製造', 'ジェットエンジン組立', 'コンポジット材成形', '航空電子機器（アビオニクス）', '精密機械加工', '熱シールド製造', '品質管理と試験', '航空機組立とメンテナンス']; //航空宇宙製造
  final List<String> menuItems7 = [' ','未選択', '射出成形', 'ブロー成形', '押出成形', '真空成形', '回転成形', 'ウルトラソニック溶接', '材料配合と改質', '表面処理と印刷']; //プラスチック加工
  final List<String> menuItems8 = ['','未選択', '紡績技術', '織布技術', '染色技術', '仕上げ加工', '不織布製造', '繊維強化プラスチック製造', '高機能繊維（アラミド、カーボンファイバー）', '繊維リサイクル技術']; //繊維製造






  List<String> _currentTechOptions = []; //選択された項目による動的なプルダウンメニューリスト

  @override
  void initState() {
    super.initState();
    _updateTechOptions(_tech1);
  }

  void _updateTechOptions(String tech1) {
    setState(() {
      switch (tech1) {
        case '機械加工':
          _currentTechOptions = menuItems3;
          break;
        case '金属加工':
          _currentTechOptions = menuItems4;
          break;
        case '電子機器製造':
          _currentTechOptions = menuItems5;
          break;
        case '航空宇宙製造':
          _currentTechOptions = menuItems6;
          break;
        case 'プラスチック加工':
          _currentTechOptions = menuItems7;
          break; 
        case '繊維製造':
          _currentTechOptions = menuItems8;
          break; 
        default:
          _currentTechOptions = menuItems2;
      }
      _tech2 = '未選択';
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
      final UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: _email,
        password: _password,
      );

      final User? user = userCredential.user;

      if (user != null) {
        print("ユーザ登録しました ${user.email} , ${user.uid}");
        setState(() {
          _uid = user.uid;
        });

        // JSONデータを生成
        var requestBody = json.encode({
          'userid': _uid,
          'username':'',
          'usertype': 'Company',
          'createdat': _currentDateTime,
          'userprofile': '',
          'numberofpoints': 0,
          'companyname': _name,  //企業名の入力
          'companyprofile': _profile,
          'companyfield': _tech1, //業種
          'companyskill': _tech2, //技術
          'coordinatorname': 'Sample Coordinator',
          'coordinatorskillname': 'Sample Coordinator Skill', 
          'coordinatorfieldname': 'Sample Coordinator Field', 
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
                  showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('ログイン失敗'),
              content: Text('メールアドレスまたはパスワードが正しくありません。\n再度入力し直してください。マジで'),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
        }
      } else {
        print("ユーザー登録に失敗しました。");
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('ログイン失敗'),
              content: Text('メールアドレスまたはパスワードが正しくありません。\n再度入力し直してください。マジで'),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print("エラーが発生しました: $e");
    }
  }

  DropdownButtonFormField<String> buildDropdown(String value, String label, List<String> items, void Function(String?)? onChanged) {
    return DropdownButtonFormField(
      value: value,
      onChanged: onChanged,
      items: items.map<DropdownMenuItem<String>>((String value) {
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

                      // プロフィール写真設定
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
                          backgroundImage:
                              _imagePath != null ? FileImage(File(_imagePath!)) : null,
                          child: _imagePath == null
                              ? const Icon(Icons.person, size: 40)
                              : null,
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

                      // UserID
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

                      // 企業名入力
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
                                  '企業名を入力してください',
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

                      // 登録日時
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

                      // 登録メールアドレス
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

                      // 登録パスワード（二度打ち）
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

                      // 会社詳細入力
                      const SizedBox(height: 16),
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
                                  '会社詳細',
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
                      buildDropdown(_tech1, '会社の業種', menuItems1, (String? newValue) {
                        setState(() {
                          _tech1 = newValue!;
                          _updateTechOptions(newValue);
                        });
                      }),
                      const SizedBox(height: 16),
                      buildDropdown(_tech2, '会社の技術', _currentTechOptions, (String? newValue) {
                        setState(() {
                          _tech2 = newValue!;
                        });
                      }),

                      // 企業プロフィール
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


                      // 確定ボタン
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed:_isFormValid ? _submitForm : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
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
