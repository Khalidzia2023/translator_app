import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart' show Connectivity, ConnectivityResult;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mnh/widgets/text_widget.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/app_icons.dart';
import '../views/languages/languages.dart';
import '../views/languages/provider/language_provider.dart';


class CustomDrawer extends StatefulWidget {
  const CustomDrawer({
    super.key,
  });

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  void rateUs() async {
    final Uri playStoreUri = Uri.parse("https://play.google.com/store/apps/details?id=com.ma.spellpronuciationexpert");

    if (!await launchUrl(playStoreUri, mode: LaunchMode.externalApplication)) {
      final Uri fallbackUri = Uri.parse("https://play.google.com/store/apps/details?id=com.ma.spellpronuciationexpert");
      await launchUrl(fallbackUri, mode: LaunchMode.externalApplication);
    }
  } void MoreApp() async {
    final Uri playStoreUri = Uri.parse("https://play.google.com/store/apps/developer?id=Muslim+Applications");

    if (!await launchUrl(playStoreUri, mode: LaunchMode.externalApplication)) {
      final Uri fallbackUri = Uri.parse("https://play.google.com/store/apps/developer?id=Muslim+Applications");
      await launchUrl(fallbackUri, mode: LaunchMode.externalApplication);
    }
  }

  // void rateUs() async {
  //   final Uri _playStoreUrl = Uri.parse(
  //     "https://play.google.com/store/apps/details?id=com.ma.spellpronuciationexpert",
  //   );
  //
  //   if (!await launchUrl(_playStoreUrl, mode: LaunchMode.externalApplication)) {
  //     throw 'Could not launch $_playStoreUrl';
  //   }
  // }
  Future<void> openPrivacyPolicy() async {
    const String privacyPolicyUrl =
        "https://privacypolicymuslimapplications.blogspot.com/2020/04/privacy-policy-of-muslim-applications_22.html";

    if (await canLaunchUrl(Uri.parse(privacyPolicyUrl))) {
      await launchUrl(Uri.parse(privacyPolicyUrl), mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $privacyPolicyUrl';
    }
  }

  List<ConnectivityResult> _connectivityStatus = [ConnectivityResult.none];
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  bool _isOnline = false; //
  @override
  void initState() {
    super.initState();
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
    _checkInternetConnection();
    // loading ads

  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    setState(() {
      _connectivityStatus = result;
    });
    _checkInternetConnection();
  }

  Future<void> _checkInternetConnection() async {
    bool previousStatus = _isOnline;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result.first.rawAddress.isNotEmpty) {
        _isOnline = true;
      } else {
        _isOnline = false;
      }
    } on SocketException catch (_) {
      _isOnline = false;
    }

    if (_isOnline != previousStatus) {
      setState(() {});
      if (!_isOnline) {
        _showNoConnectionDialog();
      }
    }
  }


  void _showNoConnectionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                spacing: 10,
                children: [
                  Icon(Icons.wifi_off_outlined, color: Color(0XFF4169E1).withOpacity(0.76),),
                  regularText(title: 'No Internet connection', textSize: 18, textColor: Colors.black, textWeight: FontWeight.w400),
                  regularText( alignText: TextAlign.center,title: 'Please check your internet connection.', textSize: 16, textColor: Colors.black, textWeight: FontWeight.w200),
                  Container(
                    width: 100, height: 40,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Color(0XFF4169E1).withOpacity(0.76),
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _checkInternetConnection(); // Retry check on dialog dismiss
                      },
                      child: regularText(title: 'OK', textSize: 18, textColor: Colors.white, textWeight: FontWeight.w400),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    return Drawer(
      width: 240,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 210,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.indigo[400],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 10,
                children: [
                  Image.asset(AppIcons.appIcon2, scale: 4.9,),
                  Text(
                   languageProvider.translate('SPELL & PRONOUNCE'),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                ],
              ),
            ),
          ),
          ListTile(
            leading: Image.asset(AppIcons.transIcon1, scale: 20,),
            title: regularText(title: languageProvider.translate('Languages'), textWeight: FontWeight.w500, textSize: 18),
            onTap: () {
              // Navigate to Profile Screen
              Navigator.push(context, MaterialPageRoute(builder: (context) => LanguagesScreen()));
            },
          ),
          ListTile(
            leading: Image.asset(
              AppIcons.sarIcon,
              scale: 27,
              color: Colors.black,
            ),
            title: regularText(
              title: languageProvider.translate('Rate US'),
              textWeight: FontWeight.w500,
              textSize: 18,
            ),
            onTap: () {
              if (!_isOnline) {
                _showNoConnectionDialog();
                return;
              }
              rateUs();
            },
          ),

          ListTile(
            leading: Image.asset(AppIcons.settingIcon, scale: 25,),
            title: regularText(title: languageProvider.translate('More Apps'), textWeight: FontWeight.w500, textSize: 18),
            onTap: () {
              if (!_isOnline) {
                _showNoConnectionDialog();
                return;

              }
              MoreApp();
            },
          ),
          ListTile(
            leading: Image.asset(AppIcons.privPolIcon, scale: 22, ),
            title: regularText(title: languageProvider.translate('Privacy Policy'), textWeight: FontWeight.w500, textSize: 18),
            onTap: () {
              if (!_isOnline) {
                _showNoConnectionDialog();
                return;
              }
              openPrivacyPolicy();
              // Navigate to Profile Screen
              // Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
            },
          ),


        ],
      ),
    );
  }
}
