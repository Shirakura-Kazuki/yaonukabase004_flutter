import 'package:flutter/material.dart';
import 'package:yaonukabase004/src/Card/card.dart';

class PageA extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 画面描画
    return Scaffold(  
      body: SingleChildScrollView(  //画面より大きい場合スクロールする
        scrollDirection: Axis.vertical, //垂直方向にスクロール
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: //Center(
            Column(
            //child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(25, 10, 0, 0),
                  child: Text('今すぐ確認',
                    style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),
                  ),),
                  const Divider(
                    height: 40,
                  ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 0, 5),
                  child: Text('ピックアップアイデア',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                HorizontalCardList(
                  titles: List.generate(10, (index) => 'ユーザー名 $index'),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 5, 0, 5),
                  child: Text('CRAFTCONNECTS成功事例',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                HorizontalCardList(
                  titles: List.generate(10, (index) => '事例タイトル $index'),
                ),
              ],
            ),
          //),
        ),
      ),
    );
  }
}


// つよつよコード

// import 'package:flutter/material.dart';
// import 'package:flutter/gestures.dart';

// class HorizontalCardList extends StatefulWidget {
//   @override
//   _HorizontalCardListState createState() => _HorizontalCardListState();
// }

// class _HorizontalCardListState extends State<HorizontalCardList> {
//   final ScrollController titleController = ScrollController();
//   final ScrollController genreController = ScrollController();

//   @override
//   void dispose() {
//     titleController.dispose();
//     genreController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;

//     return Container(
//       height: screenHeight * 0.4,
//       child: Column(
//         children: [
//           buildList(screenWidth, "タイトル", titleController),
//           buildList(screenWidth, "ジャンル", genreController),
//         ],
//       ),
//     );
//   }

//   Widget buildList(double screenWidth, String label, ScrollController controller) {
//     return Expanded(
//       child: Scrollbar(
//         controller: controller,
//         thumbVisibility: true,
//         child: Listener(
//           onPointerSignal: (pointerSignal) {
//             if (pointerSignal is PointerScrollEvent) {
//               final newOffset = controller.offset + pointerSignal.scrollDelta.dx;
//               controller.jumpTo(newOffset.clamp(0.0, controller.position.maxScrollExtent));
//             }
//           },
//           child: GestureDetector(
//             onHorizontalDragUpdate: (details) {
//               controller.position.moveTo(controller.offset - details.primaryDelta!);
//             },
//             child: ListView.builder(
//               controller: controller,
//               scrollDirection: Axis.horizontal,
//               itemCount: 10,
//               itemBuilder: (context, index) {
//                 return InkWell(
//                   onTap: () => print('$label $index タップされました'),
//                   child: Card(
//                     child: Container(
//                       width: screenWidth * 0.3,
//                       child: Center(child: Text('$label $index')),
//                     ),
//                     margin: EdgeInsets.all(10),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }