// import 'package:flutter/material.dart';
// import 'package:mnh/views/languages/languages.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:smooth_page_indicator/smooth_page_indicator.dart';
//
// import '../../../widgets/info_card.dart';
// import '../onBoarding_item/onBoarding_item.dart';
//
// class OnboardingView extends StatefulWidget {
//   const OnboardingView({super.key});
//
//   @override
//   State<OnboardingView> createState() => _OnboardingViewState();
// }
//
// class _OnboardingViewState extends State<OnboardingView> {
//   final controller = OnboardingItems();
//   final pageController = PageController();
//
//   bool isLastPage = false;
//   Future<void> completeOnboarding() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setBool('hasSeenOnboarding', true);
//     Navigator.pushReplacement(
//         context, MaterialPageRoute(builder: (_) => LanguagesScreen()));
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       bottomSheet: Container(
//         color: Colors.white,
//         padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
//         child: isLastPage? getStarted() : Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//
//             //Skip Button
//             TextButton(
//                 style: ButtonStyle(
//                   fixedSize: WidgetStatePropertyAll(Size.fromWidth(100)),
//                   backgroundColor: WidgetStatePropertyAll(Colors.grey),
//                   shape: WidgetStatePropertyAll(RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   )),
//                 ),
//                 onPressed: ()=>pageController.jumpToPage(controller.items.length-1),
//                 child: const Text("Skip", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),)),
//
//            // Indicator
//             SmoothPageIndicator(
//               controller: pageController,
//               count: controller.items.length,
//               onDotClicked: (index)=> pageController.animateToPage(index,
//                   duration: const Duration(milliseconds: 600), curve: Curves.easeIn),
//               effect: const WormEffect(
//                 dotHeight: 12,
//                 dotWidth: 12,
//                 activeDotColor: Colors.indigo,
//               ),
//             ),
//
//             //Next Button
//             TextButton(
//
//               style: ButtonStyle(
//                 fixedSize: WidgetStatePropertyAll(Size.fromWidth(100)),
//                 backgroundColor: WidgetStatePropertyAll(Color(0XFF4169E1).withOpacity(0.76),),
//                 shape: WidgetStatePropertyAll(RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 )),
//               ),
//                 onPressed: ()=>pageController.nextPage(
//                     duration: const Duration(milliseconds: 600), curve: Curves.easeIn),
//                 child: const Text("Next", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),)),
//
//
//           ],
//         ),
//       ),
//       body: Container(
//         margin: const EdgeInsets.symmetric(horizontal: 15),
//         child: PageView.builder(
//             onPageChanged: (index)=> setState(()=> isLastPage = controller.items.length-1 == index),
//             itemCount: controller.items.length,
//             controller: pageController,
//             itemBuilder: (context,index){
//               return Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 spacing: 25,
//                 children: [
//                   SizedBox(
//                       height: 200,
//                       child: InfoCard()),
//                   Text(controller.items[index].title,
//                     style: const TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
//
//                   Text(controller.items[index].descriptions,
//                       style: const TextStyle(color: Colors.grey,fontSize: 17), textAlign: TextAlign.center),
//                 ],
//               );
//
//             }),
//       ),
//     );
//   }
//
//   Widget getStarted(){
//     return Container(
//       decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(8),
//           color: Colors.green
//       ),
//       width: MediaQuery.of(context).size.width * .9,
//       height: 55,
//       child: TextButton(
//           onPressed: completeOnboarding,
//           child: const Text("Get started",style: TextStyle(color: Colors.white, fontSize: 22),)),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:mnh/views/languages/languages.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../new_test.dart';
import '../../../tts_service.dart';
import '../../../widgets/info_card.dart';
import '../onBoarding_item/onBoarding_item.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  TtsService ttsService = TtsService();
  final controller = OnboardingItems();
  final pageController = PageController();
  double _pitchSlider = 1.0;
  double _speechSlider = 1.0;

  bool isLastPage = false;


  @override
  void dispose() {
    ttsService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomSheet: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: isLastPage
            ? getStarted()
            : Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Skip Button
            TextButton(
              style: ButtonStyle(
                fixedSize: MaterialStateProperty.all(Size.fromWidth(100)),
                backgroundColor: MaterialStateProperty.all(Colors.grey),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                )),
              ),
              onPressed: () => pageController.jumpToPage(controller.items.length - 1),
              child: const Text(
                "Skip",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
              ),
            ),

            // Indicator
            SmoothPageIndicator(
              controller: pageController,
              count: controller.items.length,
              onDotClicked: (index) => pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeIn,
              ),
              effect: const WormEffect(
                dotHeight: 12,
                dotWidth: 12,
                activeDotColor: Colors.indigo,
              ),
            ),

            // Next Button
            TextButton(
              style: ButtonStyle(
                fixedSize: MaterialStateProperty.all(Size.fromWidth(100)),
                backgroundColor: MaterialStateProperty.all(Color(0XFF4169E1).withOpacity(0.76)),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                )),
              ),
              onPressed: () async{
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('hasSeenOnboarding', true);
                pageController.nextPage(
                    duration: const Duration(milliseconds: 600), curve: Curves.easeIn);
                if(controller.items.length == -1){
                  Navigator.of(context).push(MaterialPageRoute(builder:(context)=>LanguagesScreen()));
                }
    },
              child: const Text(
                "Next",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        child: PageView.builder(
          onPageChanged: (index) => setState(() => isLastPage = controller.items.length - 1 == index),
          itemCount: controller.items.length,
          controller: pageController,
          itemBuilder: (context, index) {
            var onboardingItem = controller.items[index];

            // Replace InfoCard with SpellCheckBox for the specific case
            if (onboardingItem.title == "Spell Checker") {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                spacing: 16,
                children: [
                  SizedBox(
                      height: 235,
                      child: SpellCheckBox()),
                  Text (
                    onboardingItem.title,
                    style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  Text (
                    onboardingItem.descriptions,
                    style: const TextStyle(color: Colors.grey, fontSize: 17),
                    textAlign: TextAlign.center,
                  ),

                ],
              );
            }

            // Default case: Show InfoCard for other items
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 16,
              children: [
                InfoCard(
                  title: onboardingItem.title,
                  description: onboardingItem.descriptions,
                  language1: onboardingItem.languagePairs[0].language,
                  sentence1: onboardingItem.languagePairs[0].sentence,
                  language2: onboardingItem.languagePairs[1].language,
                  sentence2: onboardingItem.languagePairs[1].sentence,
                  isPronunciation: onboardingItem.title == "Pronunciation",
                  speakText: (sentence) => ttsService.speakText(sentence, 'ar', _speechSlider, _pitchSlider ),
                  // speakText: (sentence) =>  ttsService.speakText(sentence, 'ar', _pitchSlider, _speechSlider),
                ),
                  Text (
                    onboardingItem.title,
                    style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  Text (
                    onboardingItem.descriptions,
                    style: const TextStyle(color: Colors.grey, fontSize: 17),
                    textAlign: TextAlign.center,
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget getStarted() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          style: ButtonStyle(
            fixedSize: MaterialStateProperty.all(Size.fromWidth(100)),
            backgroundColor: MaterialStateProperty.all(Colors.grey),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            )),
          ),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => LanguagesScreen()));
          },
          child: const Text(
            "Skip",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
          ),
        ),

        // Indicator
        SmoothPageIndicator(
          controller: pageController,
          count: controller.items.length,
          onDotClicked: (index) => pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeIn,
          ),
          effect: const WormEffect(
            dotHeight: 12,
            dotWidth: 12,
            activeDotColor: Colors.indigo,
          ),
        ),

        TextButton(
          style: ButtonStyle(
            fixedSize: MaterialStateProperty.all(Size.fromWidth(100)),
            backgroundColor: MaterialStateProperty.all(Color(0XFF4169E1).withOpacity(0.76)),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            )),
          ),
          onPressed: () {
    Navigator.push(context, MaterialPageRoute(builder: (context) => LanguagesScreen()));
    },
          child: const Text(
            "Finish",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
          ),
        ),
      ],
    );
  }
}


