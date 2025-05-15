import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mnh/ads_manager/native_as.dart';
import 'package:mnh/tts_service2.dart';
import 'package:mnh/views/languages/provider/language_provider.dart';
import 'package:mnh/views/onBoarding_screens/onBoarding_view/onBoarding_view.dart';
import 'package:mnh/views/spell_pronounce/spell_pronounce.dart';
import 'package:mnh/views/splash_screen/splash_screen.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ads_manager/banner_cnrtl.dart';
import 'ads_manager/interstitial_contrl.dart';
import 'ads_manager/openApp_controller.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  await Firebase.initializeApp(
  );

  final prefs = await SharedPreferences.getInstance();
  final isOnboardingCompleted = prefs.getBool('onboarding_completed') ?? false;

  Get.put(OpenAppAdController());
  Get.put(InterstitialAdController()..showAd());
  Get.put(NativeAdController());
  Get.put(BannerAdController());


  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
      ],
      child: VoiceAssistance(isOnboardingCompleted: isOnboardingCompleted),
    ),
  );

  // Initialize OneSignal
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.initialize("8edee785-f2a9-4e5d-aee7-e8ac85ea91e3");
  OneSignal.Notifications.requestPermission(true);
}

class VoiceAssistance extends StatefulWidget {
  final bool isOnboardingCompleted;

  const VoiceAssistance({super.key, required this.isOnboardingCompleted});

  @override
  State<VoiceAssistance> createState() => _VoiceAssistanceState();
}

class _VoiceAssistanceState extends State<VoiceAssistance> {


  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      locale: Locale('en'),
      supportedLocales: [
        Locale('en'),
        Locale('es'),
      ],
      debugShowCheckedModeBanner: false,

      title: 'SharedPreferencesWithCache Demo',

        home: SplashScreen()

    );
  }
}
