// ----------------------------------------------------------------------------------
// プログラム説明
// -YouTube風チャンネルデータ画面
// -登録者数、公式マークの有無、チャンネルネーム、チャンネル画像の要素を持つcontainer
//                   -例-
// final sns = SnsChannelNum(
//   registrant: 27000, //登録者数
//   channelname: '大谷翔平 otani_shohei_official',  //チャンネル名
//   channelimage:'assets/images/ootani.png', //チャンネル画像
//   official: 1,  //公式マークの有り無し（有：1 、無：それ以外（0））
// );
// ----------------------------------------------------------------------------------

import 'package:flutter/material.dart';

// snstチャンネル登録者数表示(StatelessWidget)
class SnsChannelNum extends StatelessWidget {
  
  // 変数宣言
  final int registrant;
  final int official;
  final String channelname; 
  final String channelimage;


  // keyの設定
  const SnsChannelNum({
    super.key , 
    required this.registrant ,
    required this.channelname ,
    required this.channelimage,
    required this.official,
     });

  @override
  Widget build(BuildContext context) {

  String tRegistrant;
  double registrantValue = registrant.toDouble();

    if( registrant >= 100000){
      registrantValue /= 10000;
      tRegistrant = '${registrantValue.toStringAsFixed(0)}万';
    }else if(registrant >= 10000 && registrant <100000){
      registrantValue /= 10000;
      tRegistrant = '${registrantValue.toStringAsFixed(1)}万';
    }else{
      tRegistrant = registrant.toString();
    }


  Color colorValue;

    if(official == 1){
      colorValue = Colors.grey.shade500;
    }else{
      colorValue = Colors.grey.shade200;

    }

    // 画像とテキストの横並び
    final row = Row(
      children: [
        // 画像を丸く表示する
        Padding(
          padding:const EdgeInsets.fromLTRB(5,5,0,0,),
          child: Container(
            width: 60,
            height: 60,
            decoration:  BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage(channelimage), 
              )
            ),
          ),
        ),
       

        // テキスト縦並び
         Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

             Row(children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Text(channelname,
                  style: const TextStyle(fontWeight: FontWeight.bold,
                  fontSize: 16),
                ),
              ),
               Padding(
                padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                child: Icon(Icons.check_circle,
                  color: colorValue,
                  size: 17,
                ),
              ),
            ],),

            Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(10,0,0,0),
                    child: Text('チャンネル登録者数',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10,0, 0, 0),
                    child: Text('$tRegistrant人'),
                  ),
                ],
            )
          ],
        )
      ],
    );

    //final img = Image.asset(channelimage);

    
    final mywidget = Container(
      color: Colors.grey.shade200,
      width: 380,
      height: 75,
      child: Column(
        children: [row,],
      )
    );

    return  mywidget;
  }
}

