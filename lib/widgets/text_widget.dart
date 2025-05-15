import 'package:flutter/material.dart';

Widget regularText ({

required String title,
  VoidCallback? ontap ,
double textSize = 12,
Color textColor = Colors.black,
 String? textFamily,
FontWeight textWeight = FontWeight.normal,
TextAlign alignText = TextAlign.start,
})
{
  return GestureDetector(
    onTap: ontap,
    child: Text(title,
      maxLines: null,
      textAlign: alignText,
      style: TextStyle(
      fontSize: textSize,
      color: textColor,
      fontWeight: textWeight,
        wordSpacing: 0,
        letterSpacing: 0.3,
        fontFamily: 'Poppins',
    ),),
  );
}