
import 'package:flutter/material.dart';
import 'package:mnh/utils/app_images.dart';
import 'package:mnh/widgets/text_widget.dart';

class SpellCheckBox extends StatefulWidget {
  const SpellCheckBox({super.key});

  @override
  State<SpellCheckBox> createState() => _SpellCheckBoxState();
}

class _SpellCheckBoxState extends State<SpellCheckBox> {

  List<String> tileNames = [
    'careful',
    'carefully',
    'carefulness',
    'carefree',
    'carefulest',
    'carefuled',
    'carful',
    'carefulling',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            SizedBox(height: 140,),
            Container(
              margin: EdgeInsets.only(left: 20, top: 80),
              height: 140, width: 400,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                border: Border(bottom: BorderSide(color: Colors.grey)),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Column(
                  spacing: 16,
                  children: [
                    Row(
                      spacing: 10,
                      children: [
                        Image.asset(AppImages.UKFlag, scale: 30),
                        regularText(title: 'English', textWeight: FontWeight.w600),

                      ],
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: RichText(text: TextSpan(
                          children: [
                            TextSpan(text: 'Be ', style: TextStyle(color: Colors.black, fontSize: 16)),
                            TextSpan(text: 'Carefu ', style: TextStyle(color: Colors.black, fontSize: 16, backgroundColor: Colors.red.shade400)),
                            TextSpan(text: 'for mistakes', style: TextStyle(color: Colors.black, fontSize: 16)),
                          ]
                      )),
                    ),
                  ],
                ),
              ),),
            Positioned(
              top: -140,
              child: Container(
                margin: EdgeInsets.only(left: 200),
                height: 200, width: 130,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.blueGrey)
                  ),
              child: Column(
                children: [
                  Text('Suggestions', style: TextStyle(color: Colors.black, fontSize: 18),),
                  Divider(color: Colors.black, thickness: 2,),
                  Flexible(
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                        itemCount: tileNames.length,
                        itemBuilder: (context, index){
                      return ListTile(
                        // dense: true,
                        minTileHeight: 20,
                        title: Text(tileNames[index], style: TextStyle(color: Colors.black, fontSize: 18),),
                      );
                    }),
                  ),
                ],
              ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
