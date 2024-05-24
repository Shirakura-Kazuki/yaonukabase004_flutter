import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'dart:math';
import 'detail_page.dart';

class HorizontalCardList extends StatefulWidget {
  final List<String> titles;
  final List<String> genres;
  final List<String> ideaContents;  // 追加
  final List<String> photoUrls;     // 追加

  const HorizontalCardList({
    Key? key,
    required this.titles,
    required this.genres,
    required this.ideaContents,  // 追加
    required this.photoUrls,     // 追加
  }) : super(key: key);

  @override
  _HorizontalCardListState createState() => _HorizontalCardListState();
}

class _HorizontalCardListState extends State<HorizontalCardList> {
  late final ScrollController titleController;
  late List<int> likes;
  late List<int> calls;
  late List<List<String>> comments;

  final List<String> callImages = [
    'assets/images/veg1.png',
    'assets/images/veg2.png',
  ];

  @override
  void initState() {
    super.initState();
    titleController = ScrollController();
    likes = List.generate(widget.titles.length, (index) => 0);
    calls = List.generate(widget.titles.length, (index) => 0);
    comments = List.generate(widget.titles.length, (index) => []);
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final minHeight = 200.0;
    final minWidth = 200.0;

    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      constraints: BoxConstraints(
        minHeight: minHeight,
      ),
      child: Column(
        children: [
          buildList(screenWidth, widget.titles, titleController, minHeight, minWidth),
        ],
      ),
    );
  }

  Widget buildList(double screenWidth, List<String> items, ScrollController controller, double minHeight, double minWidth) {
    return Expanded(
      child: Scrollbar(
        controller: controller,
        thumbVisibility: true,
        child: Listener(
          onPointerSignal: (pointerSignal) {
            if (pointerSignal is PointerScrollEvent) {
              final newOffset = controller.offset + pointerSignal.scrollDelta.dx;
              controller.jumpTo(newOffset.clamp(0.0, controller.position.maxScrollExtent));
            }
          },
          child: GestureDetector(
            onHorizontalDragUpdate: (details) {
              controller.position.moveTo(controller.offset - details.primaryDelta!);
            },
            child: ListView.builder(
              controller: controller,
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailPage(
                          title: widget.titles[index],
                          genre: widget.genres[index],
                          ideaContent: widget.ideaContents[index],  // 追加
                          photoUrl: widget.photoUrls[index],        // 追加
                        ),
                      ),
                    );
                  },
                  child: Card(
                    child: Container(
                      width: screenWidth * 0.13,
                      constraints: BoxConstraints(
                        minHeight: minHeight,
                        minWidth: minWidth,
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: <Widget>[
                              Icon(Icons.account_circle, size: 50),
                              SizedBox(width: 10),
                              Expanded(child: Text(items[index], style: TextStyle(fontSize: 20))),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('アイデア内容'),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(10, 20, 0, 20),
                                child: Container(
                                  width: 85,
                                  height: 85,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black, width: 2,
                                    ),
                                  ),
                                  child: Text('写真'),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    likes[index]++;
                                  });
                                },
                                child: buildScore(Icons.thumb_up, likes[index]),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    calls[index]++;
                                  });
                                },
                                child: buildRandomImageScore(callImages),
                              ),
                              GestureDetector(
                                onTap: () {
                                  _showCommentModal(context, index);
                                },
                                child: buildScore(Icons.check, comments[index].length),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    margin: EdgeInsets.all(10),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget buildScore(IconData icon, int count) {
    return Row(
      children: <Widget>[
        Icon(icon, color: Colors.blue),
        SizedBox(width: 4),
        Text('$count'),
      ],
    );
  }

  Widget buildRandomImageScore(List<String> images) {
    final random = Random();
    final imagePath = images[random.nextInt(images.length)];
    return Row(
      children: <Widget>[
        Image.asset(imagePath, width: 24, height: 24),
        SizedBox(width: 4),
        Text(''),
      ],
    );
  }

  void _showCommentModal(BuildContext context, int index) {
    final TextEditingController commentController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('コメントを追加'),
          content: TextField(
            controller: commentController,
            decoration: InputDecoration(hintText: 'コメントを入力してください'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('キャンセル'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('追加'),
              onPressed: () {
                setState(() {
                  comments[index].add(commentController.text);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
