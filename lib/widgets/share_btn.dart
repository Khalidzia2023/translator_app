import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mnh/utils/app_icons.dart';
import 'package:share_plus/share_plus.dart';

// class ShareBtn extends StatefulWidget {
//   final Color iconColor;
//   final TextEditingController controller;
//   const ShareBtn({super.key,
//     required this.controller,
//     required this.iconColor});
//
//   @override
//   State<ShareBtn> createState() => _ShareBtnState();
// }
//
// class _ShareBtnState extends State<ShareBtn> {
//
//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     double screenHeight = MediaQuery.of(context).size.height;
//     return IconButton(
//       onPressed: () {
//         final text = widget.controller.text.trim();
//         if (widget.controller.text.isEmpty) {
//           Fluttertoast.showToast(
//             msg: 'Please enter the text first to share',
//             toastLength: Toast.LENGTH_SHORT,
//             gravity: ToastGravity.BOTTOM,
//             webShowClose: true,
//             timeInSecForIosWeb: 1,
//             // backgroundColor: Colors.grey,
//             // textColor: Colors.white,
//
//             fontSize: 16.0,
//           );
//       }
//       else {
//           Share.share(text).then((_) {
//         });
//       }
//       },
//       icon: Image.asset(AppIcons.sharIcon, color: widget.iconColor, scale: screenWidth * 0.067,)
//     );
//   }
// }


class ShareBtn extends StatefulWidget {
  final Color iconColor;
  final TextEditingController controller;
  final VoidCallback onShare; // Add a callback to handle share action

  const ShareBtn({super.key,
    required this.controller,
    required this.iconColor,
    required this.onShare}); // Accept the callback as a parameter

  @override
  State<ShareBtn> createState() => _ShareBtnState();
}

class _ShareBtnState extends State<ShareBtn> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return IconButton(
        onPressed: () {
          final text = widget.controller.text.trim();
          if (text.isEmpty) {
            Fluttertoast.showToast(
              msg: 'Please enter the text first to share',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              webShowClose: true,
              timeInSecForIosWeb: 1,
              fontSize: 16.0,
            );
          } else {
            widget.onShare();
            Share.share(text).then((_) {

            });
          }
        },
        icon: Image.asset(AppIcons.sharIcon, color: widget.iconColor, scale: screenWidth * 0.067,)
    );
  }
}

