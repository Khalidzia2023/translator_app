import 'package:flutter/material.dart';
import 'package:mnh/widgets/text_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences/util/legacy_to_async_migration_util.dart';


class CustomTextBtn extends StatelessWidget {
  final TextEditingController? transController;
  final double height;
  final double width;
  VoidCallback? onTap;
  final String textTitle;
  final Decoration? decoration;


  CustomTextBtn({
    super.key,
    this.onTap,
    this.transController,
    required this.textTitle,
    this.decoration,
    required this.height,
    required this.width
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height, width: width,
        decoration: decoration,
        child: Center(child: regularText(title: textTitle, textSize: 22, textColor: Colors.white)),
      ),
    );
  }
}




