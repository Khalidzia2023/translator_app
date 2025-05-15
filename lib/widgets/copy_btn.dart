// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
//
//
// class CopyBtn extends StatefulWidget {
//   const CopyBtn({super.key});
//
//   @override
//   State<CopyBtn> createState() => _CopyBtnState();
// }
//
// class _CopyBtnState extends State<CopyBtn> {
//   final TextEditingController _textController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return  IconButton(
//       onPressed: () {
//         Clipboard.setData(
//           ClipboardData(text: _textController.text),
//         );
//       },
//       icon: Icon(
//         Icons.copy,
//         color: Colors.blueGrey,
//       ),
//     );
//   }
// }

/// see the difference

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../ads_screen/ad_helper/ad_helper.dart';
import '../utils/app_colors.dart';
import '../utils/app_icons.dart';
//
// class CopyBtn extends StatelessWidget {
//   final Color iconColor;
//   final TextEditingController controller;
//
//
//   CopyBtn({
//     super.key,
//     required this.iconColor,
//     required this.controller,
//
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     double screenHeight = MediaQuery.of(context).size.height;
//     return IconButton(
//       onPressed: () {
//         Clipboard.setData(
//           ClipboardData(text: controller.text),
//         ).then((_) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Text copied to clipboard')),
//           );
//         });
//       },
//       icon: Image.asset(AppIcons.copyIcon, color: iconColor, scale: screenHeight * 0.05,)
//     );
//   }
// }
//

import 'package:fluttertoast/fluttertoast.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';

class CopyBtn extends StatefulWidget {
  final Color iconColor;
  final TextEditingController controller;

  CopyBtn({
    super.key,
    required this.iconColor,
    required this.controller,
  });

  @override
  State<CopyBtn> createState() => _CopyBtnState();
}

class _CopyBtnState extends State<CopyBtn> {


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return IconButton(
      onPressed: () {
        // Check if the controller text is empty
        if (widget.controller.text.isEmpty) {
          // Show a Toast for empty text
          Fluttertoast.showToast(
            msg: 'Please enter the text first to copy',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            webShowClose: true,
            timeInSecForIosWeb: 1,
            // backgroundColor: Colors.grey,
            // textColor: Colors.white,

            fontSize: 16.0,
          );
        }
        else {
          Fluttertoast.showToast(
            msg: "Text copied to clipboard",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            // backgroundColor: AppColors.kGrey83,
            // textColor: Colors.white,
            fontSize: 16.0,
          );

        }
      },
      icon: Image.asset(
        AppIcons.copyIcon, // Update this path if necessary
        color: widget.iconColor,
        scale: screenWidth * 0.067,
      ),
    );
  }
}
