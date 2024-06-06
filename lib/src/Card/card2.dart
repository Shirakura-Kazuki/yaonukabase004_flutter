import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

class HorizontalCardLists extends StatefulWidget {
  final List<String> titles;
  final List<int> colorNumbers;
  final List<int> ideaId;
  final List<int> likeNum;

  const HorizontalCardLists({
    Key? key,
    required this.titles,
    required this.colorNumbers,
    required this.ideaId,
    required this.likeNum,
  }) : super(key: key);

  @override
  _HorizontalCardListsState createState() => _HorizontalCardListsState();
}

class _HorizontalCardListsState extends State<HorizontalCardLists> {
  late final ScrollController titleController;
  late List<int> likes;
  late List<int> tapCounts;
  late List<int> tapNum;

   String imgpath = 'assets/images/mynukaadd.png'; 
  late List<String> imgPaths; //各ImageのPATH管理


  @override
  void initState() {
    super.initState();
    titleController = ScrollController();
    // likes = List.generate(widget.titles.length, (index) => 0);
    likes = List.generate(widget.likeNum.length, (index) => widget.likeNum[index]); // 変更
    tapCounts = List.generate(widget.titles.length, (index) => 0);
    tapNum = List.generate(widget.titles.length, (index) => 0);
    imgPaths = List.generate(widget.titles.length, (index) => 'assets/images/mynukaadd.png'); //初期イメージ画像path
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    double cardWidth = screenWidth / (screenWidth ~/ 200);
    cardWidth = cardWidth < 200 ? 380 : cardWidth;
    cardWidth = cardWidth > 400 ? 400 : cardWidth;
    final cardHeight = 320.0;
   

    return Container(
      height: MediaQuery.of(context).size.height,
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: screenWidth ~/ cardWidth,
          childAspectRatio: cardWidth / cardHeight,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: widget.titles.length,
        itemBuilder: (context, index) {
          return buildCard(widget.titles[index], cardWidth, index, widget.colorNumbers[index], widget.ideaId[index],widget.likeNum[index]);
        },
      ),
    );
  }

  Widget buildCard(String title, double width, int index, int colorNumber, int ideaId ,int likeNum) {
    Color borderColor = (colorNumber == 0) ? Colors.blue : Colors.red;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
        side: BorderSide(color: borderColor, width: 3.0),
      ),
      elevation: 5,
      child: Container(
        color: Colors.white, // 背景色を白に設定
        width: width,
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('No.$ideaId'),
            Icon(Icons.account_circle, size: 50,color: borderColor,),
            SizedBox(height: 10),
            Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                width: 85,
                height: 85,
                decoration: BoxDecoration(
                  border: Border.all(color: borderColor, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(child: Text('写真')),
              ),
            ),

            //デザインが崩れている
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () async {
                    setState(() {
                      likes[index] = likes[index] == likeNum ? likeNum+1 : likeNum;
                      tapCounts[index]++;
                    });
                    final likeStatus = likes[index];
                    final tapCount = tapCounts[index];
                    print('アイデアID: $ideaId, Like Status: $likeStatus , Tap Count: $tapCount');
                    if(tapCount %2 == 0){
                      print('いいねの取り消し');
                      await downdateLikeStatus(ideaId, likeStatus);
                    }else{
                      print('いいねの追加');
                      await updateLikeStatus(ideaId, likeStatus);
                    }
                  },
                  child: buildScore(Icons.thumb_up, likes[index],colorNumber),
                ),
                GestureDetector(
                  onTap: ()async{
                    // タップ数のカウント
                    setState(() {
                      tapNum[index]++;
                      imgPaths[index] = (tapNum[index] % 2 == 0) 
                        ? 'assets/images/mynukaadd.png'
                        : 'assets/images/notmynuka.png';
                    });
                      final tapNums = tapNum[index];
                    if(tapNums %2 == 0){
                      print('偶数の処理：ブックマーク');
                    }else{
                      print('奇数の処理：ブックマーク');
                    }
                  },
                  child: Image.asset(
                    imgPaths[index],
                    width: 45,
                    height: 45,  
                  ),
                  // child:buildScore(Icons.phone, 14,colorNumber) ,
                ),
              ],
            ),

            Text(DateFormat('yyyy/MM/dd HH:mm:ss').format(DateTime.now()), style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
  // いいね数の増加
  Future<void> updateLikeStatus(int ideaId, int likeStatus) async {
    final url = 'https://addlike.azurewebsites.net/api/add_like';
    final body = json.encode({"ideaid": ideaId.toString()});
    final headers = {'Content-Type': 'application/json'};
    try {
      final response = await http.patch(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        print('Like status updated successfully for ideaId: $ideaId');
      } else {
        print('Failed to update like status for ideaId: $ideaId');
      }
    } catch (e) {
      print('Error updating like status for ideaId: $ideaId: $e');
    }
  }

  // いいね数の減少
  Future<void> downdateLikeStatus(int ideaId, int likeStatus) async {
    final url = 'https://deletelike.azurewebsites.net/api/delete_like';
    final body = json.encode({"ideaid": ideaId.toString()});
    final headers = {'Content-Type': 'application/json'};
    try {
      final response = await http.patch(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        print('Like status downdated successfully for ideaId: $ideaId');
      } else {
        print('Failed to downdate like status for ideaId: $ideaId');
      }
    } catch (e) {
      print('Error downdating like status for ideaId: $ideaId: $e');
    }
  }

  Widget buildScore(IconData icon, int count , int colorNumber) {
    Color iconColor= (colorNumber == 0) ? Colors.blue : Colors.red;
    return Row(
      children: <Widget>[
        Icon(icon, color: iconColor),
        SizedBox(width: 4),
        Text('$count'),
      ],
    );
  }
}


