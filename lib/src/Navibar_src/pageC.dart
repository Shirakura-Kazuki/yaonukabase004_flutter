import 'package:flutter/material.dart';
import 'package:yaonukabase004/src/Card/card_copy.dart';

class PageC extends StatelessWidget {
  final List<Map<String, String>> companies = [
    {
      'name': '株式会社環境第一',
      'representative': '山田太郎',
      'established': '2001年4月',
      'employees': '100人',
      'business': '再生可能エネルギー事業',
      'photo': 'assets/images/image1.png',
      'technology': '太陽光発電, 風力発電',
      'craftconnect': '10件',
    },
    {
      'name': 'TOYODA(株)',
      'representative': '鈴木次郎',
      'established': '1950年5月',
      'employees': '5000人',
      'business': '自動車製造',
      'photo': 'assets/images/image2.png',
      'technology': 'エンジン製造, 車体設計',
      'craftconnect': '25件',
    },
    {
      'name': '株式会社りんご',
      'representative': '佐藤花子',
      'established': '1990年3月',
      'employees': '300人',
      'business': 'スマート農業',
      'photo': 'assets/images/image3.png',
      'technology': '精密農業, ドローン監視',
      'craftconnect': '12件',
    },
    {
      'name': 'テクノロジーソリューションズ株式会社',
      'representative': '中村修',
      'established': '2010年7月',
      'employees': '450人',
      'business': 'ITコンサルティング',
      'photo': 'assets/images/image4.png',
      'technology': 'クラウドコンピューティング, AI',
      'craftconnect': '30件',
    },
    {
      'name': 'バイオヘルスケア株式会社',
      'representative': '田中一郎',
      'established': '2005年2月',
      'employees': '250人',
      'business': '医療機器開発',
      'photo': 'assets/images/image5.png',
      'technology': 'バイオテクノロジー, 遺伝子解析',
      'craftconnect': '8件',
    },
    {
      'name': '未来エネルギー株式会社',
      'representative': '斉藤真一',
      'established': '1995年6月',
      'employees': '1200人',
      'business': 'ソーラーエネルギー',
      'photo': 'assets/images/image6.png',
      'technology': 'ソーラーパネル製造, エネルギー貯蔵',
      'craftconnect': '15件',
    },
    {
      'name': 'グリーンアグリ株式会社',
      'representative': '渡辺花',
      'established': '2012年11月',
      'employees': '150人',
      'business': '農業テクノロジー',
      'photo': 'assets/images/image7.png',
      'technology': '水耕栽培, 自動化農業',
      'craftconnect': '20件',
    },
    {
      'name': 'スマートハウス株式会社',
      'representative': '佐々木健',
      'established': '2008年9月',
      'employees': '600人',
      'business': 'スマートホームソリューション',
      'photo': 'assets/images/image8.png',
      'technology': 'ホームオートメーション, エネルギー効率化',
      'craftconnect': '18件',
    },
    {
      'name': 'クリーンテック株式会社',
      'representative': '加藤光',
      'established': '2003年3月',
      'employees': '350人',
      'business': '環境保護技術',
      'photo': 'assets/images/image9.png',
      'technology': '廃棄物処理, 水質浄化',
      'craftconnect': '22件',
    },
    {
      'name': '物流イノベーション株式会社',
      'representative': '高橋雅',
      'established': '1998年12月',
      'employees': '900人',
      'business': '物流システム開発',
      'photo': 'assets/images/image10.png',
      'technology': '自動運転, ドローン配送',
      'craftconnect': '16件',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(height: 40),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 0, 5),
                child: Text(
                  '企業リスト',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              CustomCompanyCardList(companies: companies),
            ],
          ),
        ),
      ),
    );
  }
}
