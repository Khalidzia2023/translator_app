// import 'package:flutter/material.dart';
//
//
// class DeleteBtn extends StatefulWidget {
//   final TextEditingController controller;
//   const DeleteBtn({super.key, required this.controller});
//
//   @override
//   State<DeleteBtn> createState() => _DeleteBtnState();
// }
//
// class _DeleteBtnState extends State<DeleteBtn> {
//   // final TextEditingController _textController = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     void _showDeleteConfirmationDialog() {
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text('Confirm Delete'),
//             content: Text('Are you sure you want to delete the text?'),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop(); // Close the dialog
//                 },
//                 child: Text('Cancel'),
//               ),
//               TextButton(
//                 onPressed: () {
//                     controller.clear(); // Clear the text field
//                   Navigator.of(context).pop(); // Close the dialog
//                 },
//                 child: Text('Yes'),
//               ),
//             ],
//           );
//         },
//       );
//     }
//     return IconButton(
//       onPressed: _showDeleteConfirmationDialog, // Call the delete confirmation dialog
//       icon: Icon(
//         Icons.delete,
//         color: Colors.blueGrey,
//       ),
//     );
//   }
// }
//
//

///  seee the difference
///




import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../ads_screen/ad_helper/ad_helper.dart';


import 'package:flutter/material.dart';

class DeleteBtn extends StatefulWidget {
  final Color iconColor;
  final TextEditingController controller;

  const DeleteBtn({
    Key? key,
    required this.controller,
    required this.iconColor,
  }) : super(key: key);

  @override
  State<DeleteBtn> createState() => _DeleteBtnState();
}

class _DeleteBtnState extends State<DeleteBtn> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.delete,
        color: widget.iconColor,
      ),
      onPressed: () {
        // Clear the text in the controller when the button is tapped
        widget.controller.clear();
      },
    );
  }
}

