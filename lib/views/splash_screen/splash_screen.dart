
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mnh/utils/app_images.dart';
import 'package:mnh/views/onBoarding_screens/onBoarding_view/onBoarding_view.dart';
import 'package:mnh/views/spell_pronounce/spell_pronounce.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../ads_manager/splash_interstitial.dart';
import '../languages/languages.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final SplashInterstitialAd splashInterstitialAd = Get.put(SplashInterstitialAd());

  @override
  void initState() {
    super.initState();
    Get.find<SplashInterstitialAd>().checkAndShowAdOnVisit();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppImages.splashBg),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Stack(
                children: [
                  Image.asset(AppImages.splashBtn),
                  Positioned(
                    left: 130,
                    top: 40,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () async {
                          // Show interstitial ad when Get Started is tapped
                          final prefs = await SharedPreferences.getInstance();
                          bool hasSeenOnboarding = prefs.getBool("hasSeenOnboarding") ?? false;

                          if (hasSeenOnboarding) {
                            splashInterstitialAd.checkAndShowAdOnVisit();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const SpellPronounce()),
                            );
                          } else {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const OnboardingView()),
                            );
                          }
                        },
                        child: Text(
                          'Get Started',
                          style: TextStyle(
                            color: Color(0XFFBE4D36),
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 38),
            ],
          ),
        ),
      ),
    );
  }
}

