import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  final String title;
  final String genre;
  final String ideaContent;
  final String photoUrl;

  DetailPage({
    Key? key,
    required this.title,
    required this.genre,
    required this.ideaContent,
    required this.photoUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('詳細ページ', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0.5,
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.grey[200],
              child: Column(
                children: [
                  _buildSideMenuItem('金属加工'),
                  _buildSideMenuItem('機械加工'),
                  _buildSideMenuItem('特集プラスチック加工'),
                  _buildSideMenuItem('番組エネルギー産業'),
                  _buildSideMenuItem('家具製造'),
                  _buildSideMenuItem('化学製品製造'),
                  _buildSideMenuItem('食品加工'),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 8,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailHeader(),
                  SizedBox(height: 20),
                  _buildDetailCard('タイトル', title),
                  SizedBox(height: 20),
                  _buildDetailCard('ジャンル', genre),
                  SizedBox(height: 20),
                  _buildDetailCard('アイデア内容', ideaContent),
                  SizedBox(height: 20),
                  _buildPhotoCard('写真', photoUrl),
                  SizedBox(height: 40),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      label: Text('リストに戻る', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.grey[100],
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('注目のコメント', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  SizedBox(height: 10),
                  _buildComment('小澤涼太', '株式会社有線ケーブル窃盗会社 専務執行役員', '複雑なことをそのまま複雑に考える人もいれば、複雑なことをもっと複雑にして考える人もいますね。'),
                  SizedBox(height: 20),
                  _buildComment('白倉一樹', '株式会社利きTENGA 取締役CFO', '物事を分かりやすく考えるために、どのような順番で何をどう考えればいいのか、そんなヒントを与えてくれます。'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSideMenuItem(String title) {
    return ListTile(
      title: Text(title, style: TextStyle(fontSize: 14)),
      dense: true,
    );
  }

  Widget _buildDetailHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('2024/5/17', style: TextStyle(color: Colors.grey, fontSize: 14)),
        SizedBox(height: 10),
        Text(
          '「モノづくりを単純に考える」',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        SizedBox(height: 10),
        Text('Nukaトピックス', style: TextStyle(color: Colors.grey, fontSize: 16)),
      ],
    );
  }

  Widget _buildDetailCard(String label, String content) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 0,
      color: Colors.grey[100],
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$label:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            SizedBox(height: 5),
            Text(
              content,
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoCard(String label, String photoUrl) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 0,
      color: Colors.grey[100],
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$label:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            SizedBox(height: 5),
            Image.network(photoUrl, height: 200, fit: BoxFit.cover),
          ],
        ),
      ),
    );
  }

  Widget _buildComment(String name, String position, String comment) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage('https://via.placeholder.com/150'),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
                Text(position, style: TextStyle(color: Colors.grey, fontSize: 12)),
                SizedBox(height: 5),
                Text(comment),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
