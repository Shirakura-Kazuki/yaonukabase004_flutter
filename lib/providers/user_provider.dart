import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user.dart';

class UserProvider with ChangeNotifier {
  User? _user;

  User? get user => _user;

  Future<void> fetchUserData() async {
    try {
      firebase_auth.User? firebaseUser = firebase_auth.FirebaseAuth.instance.currentUser;
      if (firebaseUser != null) {
        String uid = firebaseUser.uid;
        print('現在ログインしているユーザのUID: $uid');

        final url = Uri.parse('https://guser.azurewebsites.net/api/get_user?userid=$uid');
        print('アクセスするURL: $url');

        final response = await http.get(
          url,
          headers: {'Content-Type': 'application/json'},
        );

        if (response.statusCode == 201) {
          final data = json.decode(utf8.decode(response.bodyBytes));
          print('APIレスポンス: ${response.body}');
          print('usertype: ${data['usertype']}');
          print('createdat: ${data['createdat']}');
          print('icon: ${data['icon']}');
          print('profile: ${data['profile']}');
          print('numberofpoints: ${data['numberofpoints']}');
          print('companyname: ${data['companyname']}');
          print('username: ${data['username']}');

          _user = User(
            userid: uid,
            username: data['username'],
            usertype: data['usertype'],
            createdat: data['createdat'],
            icon: data['icon'],
            profile: data['profile'],
            numberofpoints: data['numberofpoints'],
            companyname: data['companyname'],
          );
          notifyListeners(); // 状態が変わったことを通知する
        } else {
          print('APIリクエスト失敗: ${response.statusCode}');
          print('レスポンスボディ: ${response.body}');
        }
      } else {
        print('ユーザーがログインしていません');
      }
    } catch (e) {
      print('エラーが発生しました: $e');
    }
  }
}
