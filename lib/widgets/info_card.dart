// import 'package:flutter/material.dart';
// import 'package:mnh/utils/app_images.dart';
// import 'package:mnh/widgets/extensions/empty_space.dart';
// import 'package:mnh/widgets/text_widget.dart';
//
// import '../utils/app_icons.dart';
//
// class InfoCard extends StatelessWidget {
//   const InfoCard({
//     super.key,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Flexible(
//       child: ListView.builder(
//         itemCount: 3,
//       itemBuilder: (context, index){
//           if(index == 0){
//             return Container(
//               height: MediaQuery.of(context).size.height * 0.25,
//               width:  MediaQuery.of(context).size.width * 2.30,
//               decoration: BoxDecoration(
//                 color: Colors.grey.shade100,
//                 border: Border(bottom: BorderSide(color: Colors.grey)),
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
//                 child: Column(
//                   spacing: 10,
//                   children: [
//                     Row(
//                       spacing: 10,
//                       children: [
//                         Image.asset(AppImages.UKFlag, scale: 30,),
//                         regularText(title: 'English', textWeight: FontWeight.w600,)
//                       ],
//                     ),
//                     regularText(
//                       title: 'I am not afraid of storms. for I am learning how to sail my ship.',
//                     ),
//
//                     Row(
//                       children: [
//                         Flexible(child: Divider(color: Colors.grey, thickness: 2)),
//                         6.asWidthBox,
//                         Image.asset(AppIcons.convertIcon, scale: 40,),
//                         6.asWidthBox,
//                         Flexible(child: Divider(color: Colors.grey, thickness: 2)),
//                       ],
//                     ),
//
//                     Row(
//                       spacing: 10,
//                       children: [
//                         Image.asset(AppImages.spainFlag, scale: 30,),
//                         regularText(title: 'Spanish',textWeight: FontWeight.w600,)
//                       ],
//                     ),
//                     regularText(
//                         title: 'No tengo miedo a las tormentas, porque estoy aprendiendo a navegar mi barco.'
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           } else if(index == 1){
//             Text('d');
//           }else if(index == 2){
//             Container(
//               height: MediaQuery.of(context).size.height * 0.25,
//               width:  MediaQuery.of(context).size.width * 2.30,
//               decoration: BoxDecoration(
//                 color: Colors.grey.shade100,
//                 border: Border(bottom: BorderSide(color: Colors.grey)),
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
//                 child: Column(
//                   spacing: 10,
//                   children: [
//                     Row(
//                       spacing: 10,
//                       children: [
//                         Image.asset(AppImages.UKFlag, scale: 30,),
//                         regularText(title: 'English', textWeight: FontWeight.w600,)
//                       ],
//                     ),
//                     regularText(
//                       title: 'I am not afraid of storms. for I am learning how to sail my ship.',
//                     ),
//
//                     Row(
//                       children: [
//                         Flexible(child: Divider(color: Colors.grey, thickness: 2)),
//                         6.asWidthBox,
//                         Image.asset(AppIcons.convertIcon, scale: 40,),
//                         6.asWidthBox,
//                         Flexible(child: Divider(color: Colors.grey, thickness: 2)),
//                       ],
//                     ),
//
//                     Row(
//                       spacing: 10,
//                       children: [
//                         Image.asset(AppImages.spainFlag, scale: 30,),
//                         regularText(title: 'Spanish',textWeight: FontWeight.w600,)
//                       ],
//                     ),
//                     regularText(
//                         title: 'No tengo miedo a las tormentas, porque estoy aprendiendo a navegar mi barco.'
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           }
//
//
//       },
//       ),
//     );
//   }
// }
//



import 'package:flutter/material.dart';
import '../utils/app_icons.dart';
import '../utils/app_images.dart';
import '../widgets/text_widget.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final String description;
  final String language1;
  final String sentence1;
  final String language2;
  final String sentence2;
  final bool isPronunciation;
  final Function(String) speakText;
  final Widget? additionalContent;

  const InfoCard({
    Key? key,
    required this.title,
    required this.description,
    required this.language1,
    required this.sentence1,
    required this.language2,
    required this.sentence2,
    this.isPronunciation = false,
    required this.speakText,
    this.additionalContent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.28,
      width: MediaQuery.of(context).size.width * 2.30,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        border: Border(bottom: BorderSide(color: Colors.grey)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 10,
          children: [
            Row(
              spacing: 10,
              children: [
                Image.asset(AppImages.UKFlag, scale: 30),
                regularText(title: language1, textWeight: FontWeight.w600),

              ],
            ),
            regularText(title: sentence1),
            Row(
              children: [
                Flexible(child: Divider(color: Colors.grey, thickness: 2)),
                SizedBox(width: 6),
                // Assuming you have an appropriate convert icon in your assets
                Image.asset(AppIcons.convertIcon, scale: 40),
                SizedBox(width: 6),
                Flexible(child: Divider(color: Colors.grey, thickness: 2)),
              ],
            ),
            Column(
              children: [
                Row(spacing: 10,
                  children: [
                    Image.asset(AppImages.spainFlag, scale: 30),
                    regularText(title: language2, textWeight: FontWeight.w600),

                  ],
                ),
              ],
            ),
            Row(
              children: [
                if (isPronunciation)
                  Row(
                    children: [
                      IconButton(
                        onPressed:  () => speakText(sentence2),
                        icon: Icon(Icons.volume_up, color: Colors.blue),
                      ),
                      SizedBox(width: 40,)
                    ],
                  ),
                // Spacer(),
                Flexible(child: regularText(title: sentence2, )),
              ],
            ),
            if (additionalContent != null) // Display additional content if provided
              additionalContent!,
          ],
        ),
      ),
    );
  }
}
