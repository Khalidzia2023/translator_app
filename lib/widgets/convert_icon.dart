import 'package:flutter/material.dart';
import 'package:mnh/utils/app_icons.dart';

class ConvertIcon extends StatelessWidget {
  const ConvertIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(child: Image.asset(AppIcons.convertIcon, scale: 38,color: Colors.blue,),radius: 18, backgroundColor: Colors.white,);
  }
}
