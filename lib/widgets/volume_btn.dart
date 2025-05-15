
import 'package:flutter/material.dart';
import 'package:mnh/utils/app_icons.dart';
import 'package:share_plus/share_plus.dart';

class VolumeBtn extends StatelessWidget {
  final TextEditingController controller;

  const VolumeBtn({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return IconButton(
        onPressed: () {
          final text = controller.text.trim(); // Trim whitespace for cleaner sharing
          if (text.isNotEmpty) {
            Share.share(text);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('No text to share!'),
                duration: Duration(seconds: 2),
              ),
            );
          }
        },
        icon: Image.asset(AppIcons.volumeIcon, color: Colors.green, scale: screenHeight * 0.03,)
    );
  }
}
