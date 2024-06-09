import 'package:flutter/material.dart';

class IdeaDataSpecial extends StatelessWidget {
  final int id;
  final String ideaname;
  final String ideaconcept;
  final String ideatechnology1;
  final String? ideatechnology2;
  final String? ideatechnology3;
  final String ideadate;
  final int numberoflikes;
  final bool isBookmarked;

  const IdeaDataSpecial({
    Key? key,
    required this.id,
    required this.ideaname,
    required this.ideaconcept,
    required this.ideatechnology1,
    this.ideatechnology2,
    this.ideatechnology3,
    required this.ideadate,
    required this.numberoflikes,
    required this.isBookmarked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('アイデア詳細'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('アイデア詳細', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Row(
              children: [
                Text('タイトル: ', style: TextStyle(fontSize: 18)),
                Text(ideaname, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(width: 10),
                Text('ID: ', style: TextStyle(fontSize: 18)),
                Text('$id', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 16),
            Text('アイデアコンセプト: ', style: TextStyle(fontSize: 18)),
            Text(ideaconcept, style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),
            Row(
              children: [
                Text('技術ジャンル1: ', style: TextStyle(fontSize: 18)),
                Text(ideatechnology1, style: TextStyle(fontSize: 16)),
              ],
            ),
            if (ideatechnology2 != null) ...[
              SizedBox(height: 8),
              Row(
                children: [
                  Text('技術ジャンル2: ', style: TextStyle(fontSize: 18)),
                  Text(ideatechnology2!, style: TextStyle(fontSize: 16)),
                ],
              ),
            ],
            if (ideatechnology3 != null) ...[
              SizedBox(height: 8),
              Row(
                children: [
                  Text('技術ジャンル3: ', style: TextStyle(fontSize: 18)),
                  Text(ideatechnology3!, style: TextStyle(fontSize: 16)),
                ],
              ),
            ],
            SizedBox(height: 16),
            Text('アイデア追加日時: ', style: TextStyle(fontSize: 18)),
            Text(ideadate, style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),
            Row(
              children: [
                Text('いいね数: ', style: TextStyle(fontSize: 18)),
                Text('$numberoflikes', style: TextStyle(fontSize: 16)),
                SizedBox(width: 20),
                Text('ブックマーク: ', style: TextStyle(fontSize: 18)),
                Text(isBookmarked ? 'true' : 'false', style: TextStyle(fontSize: 16)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
