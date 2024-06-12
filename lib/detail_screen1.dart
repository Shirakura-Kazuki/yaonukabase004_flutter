import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  final String originalTitle;
  final String originalGenre;
  final String originalIdeaContent;
  final String? originalPhotoUrl;
  final String otherTitle;
  final String otherGenre;
  final String otherIdeaContent;
  final String? otherPhotoUrl;

  DetailPage({
    Key? key,
    required this.originalTitle,
    required this.originalGenre,
    required this.originalIdeaContent,
    this.originalPhotoUrl,
    required this.otherTitle,
    required this.otherGenre,
    required this.otherIdeaContent,
    this.otherPhotoUrl,
  }) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isMobile = screenSize.width < 600;

    return Scaffold(
      appBar: AppBar(
        title: Text('詳細ページ', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        child: isMobile ? buildMobileLayout(context) : buildDesktopLayout(context),
      ),
    );
  }

  Widget buildMobileLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildToggleButtons(),
        _buildDetailContent(),
        SizedBox(height: 40),
        _buildCommentsSection(),
        SizedBox(height: 20),
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
    );
  }

  Widget buildDesktopLayout(BuildContext context) {
    return Row(
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
                _buildToggleButtons(),
                _buildDetailContent(),
                SizedBox(height: 40),
                _buildCommentsSection(),
                SizedBox(height: 20),
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
      ],
    );
  }

  Widget _buildToggleButtons() {
    return Center(
      child: ToggleButtons(
        isSelected: [_selectedIndex == 0, _selectedIndex == 1, _selectedIndex == 2],
        onPressed: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        borderRadius: BorderRadius.circular(20),
        selectedBorderColor: Colors.blue,
        selectedColor: Colors.white,
        fillColor: Colors.blue,
        color: Colors.grey,
        constraints: BoxConstraints(
          minHeight: 40.0,
          minWidth: 120.0,
        ),
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text('Original Idea', style: TextStyle(fontSize: 16)),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text('Other Idea', style: TextStyle(fontSize: 16)),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text('Comparison', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailContent() {
    final screenSize = MediaQuery.of(context).size;
    final isMobile = screenSize.width < 600;

    if (_selectedIndex == 0) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailHeader(),
          SizedBox(height: 20),
          _buildDetailCard('タイトル', widget.originalTitle),
          SizedBox(height: 20),
          _buildDetailCard('ジャンル', widget.originalGenre),
          SizedBox(height: 20),
          _buildDetailCard('アイデア内容', widget.originalIdeaContent),
          SizedBox(height: 20),
          _buildPhotoCard('写真', widget.originalPhotoUrl),
        ],
      );
    } else if (_selectedIndex == 1) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailHeader(),
          SizedBox(height: 20),
          _buildDetailCard('タイトル', widget.otherTitle),
          SizedBox(height: 20),
          _buildDetailCard('ジャンル', widget.otherGenre),
          SizedBox(height: 20),
          _buildDetailCard('アイデア内容', widget.otherIdeaContent),
          SizedBox(height: 20),
          _buildPhotoCard('写真', widget.otherPhotoUrl),
        ],
      );
    } else if (_selectedIndex == 2) {
      if (isMobile) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailHeader(),
            SizedBox(height: 20),
            _buildDetailCard('タイトル', widget.originalTitle),
            SizedBox(height: 20),
            _buildDetailCard('ジャンル', widget.originalGenre),
            SizedBox(height: 20),
            _buildDetailCard('アイデア内容', widget.originalIdeaContent),
            SizedBox(height: 20),
            _buildPhotoCard('写真', widget.originalPhotoUrl),
            SizedBox(height: 40),
            _buildDetailCard('タイトル', widget.otherTitle),
            SizedBox(height: 20),
            _buildDetailCard('ジャンル', widget.otherGenre),
            SizedBox(height: 20),
            _buildDetailCard('アイデア内容', widget.otherIdeaContent),
            SizedBox(height: 20),
            _buildPhotoCard('写真', widget.otherPhotoUrl),
          ],
        );
      } else {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailHeader(),
            SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildDetailCard('タイトル', widget.originalTitle)),
                SizedBox(width: 20),
                Expanded(child: _buildDetailCard('タイトル', widget.otherTitle)),
              ],
            ),
            SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildDetailCard('ジャンル', widget.originalGenre)),
                SizedBox(width: 20),
                Expanded(child: _buildDetailCard('ジャンル', widget.otherGenre)),
              ],
            ),
            SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildDetailCard('アイデア内容', widget.originalIdeaContent)),
                SizedBox(width: 20),
                Expanded(child: _buildDetailCard('アイデア内容', widget.otherIdeaContent)),
              ],
            ),
            SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildPhotoCard('写真', widget.originalPhotoUrl)),
                SizedBox(width: 20),
                Expanded(child: _buildPhotoCard('写真', widget.otherPhotoUrl)),
              ],
            ),
          ],
        );
      }
    } else {
      return Container();
    }
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
          '「マッチアイデア」',
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

  Widget _buildPhotoCard(String label, String? photoUrl) {
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
             Image.asset('assets/images/noimg.png', height: 200, fit: BoxFit.cover),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentsSection() {
    return Container(
      color: Colors.grey[100],
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('注目のコメント', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          SizedBox(height: 10),
          _buildComment('小澤涼太', '株式会社OZAWAX 執行役員', '実際のニーズを反映している点が評価できます。しかし、技術的な実現可能性やコスト面での詳細な検討が必要です。'),
          SizedBox(height: 20),
          _buildComment('白倉一樹', ' 村長 ', 'ユーザーからのフィードバックを収集することで、改善点を明確にしていくことが重要です。これにより、より実用的で効果的なソリューションに進化させることができるでしょう。'),
        ],
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
            // backgroundImage: NetworkImage('https://via.placeholder.com/150'),
            backgroundImage: AssetImage('assets/images/noimg.png'),

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

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.white,
        primaryColor: Colors.white,
        colorScheme: const ColorScheme.light().copyWith(
          secondary: Colors.blueAccent,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          titleTextStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
          iconTheme: IconThemeData(color: Colors.black),
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailPage(
                  originalTitle: 'Original Title',
                  originalGenre: 'Original Genre',
                  originalIdeaContent: 'Original Idea Content',
                  originalPhotoUrl: null, // nullに設定
                  otherTitle: 'Other Title',
                  otherGenre: 'Other Genre',
                  otherIdeaContent: 'Other Idea Content',
                  otherPhotoUrl: null, // nullに設定
                ),
              ),
            );
          },
          child: Text('詳細ページへ'),
        ),
      ),
    );
  }
}
