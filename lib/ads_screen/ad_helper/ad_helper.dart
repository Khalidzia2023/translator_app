// // import 'dart:io';
// //
// // class AdHelper {
// //   static String get bannerAdUnitID {
// //     if (Platform.isAndroid) {
// //       // Test ad unit for Android
// //       return 'ca-app-pub-3940256099942544/9214589741';
// //     }else {
// //       throw UnsupportedError('Unsupported platform');
// //     }
// //   }
// //   static String get interstitialAdUnitID {
// //     if (Platform.isAndroid) {
// //       // Test ad unit for Android
// //       return 'ca-app-pub-6640234604191024/6559489743';
// //     }else {
// //       throw UnsupportedError('Unsupported platform');
// //     }
// //   }
// //
// //   static String get openAppAdUnitID {
// //     if (Platform.isAndroid) {
// //       // Test ad unit for Android
// //       return 'ca-app-pub-6640234604191024/9056588749';
// //     }else {
// //       throw UnsupportedError('Unsupported platform');
// //     }
// //   }
// // }
// //
//
//
//
//

import 'dart:io';

class AdHelper {
  // static String get bannerAdUnitID {
  //   if (Platform.isAndroid) {
  //     // Test ad unit for Android
  //     return 'ca-app-pub-3940256099942544/9214589741';
  //   } else {
  //     throw UnsupportedError('Unsupported platform');
  //   }
  // }
  static String bannerAdUnitID = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/9214589741'
      : throw UnsupportedError('Unsupported platform');

  // static String get interstitialAdUnitID {
  //   if (Platform.isAndroid) {
  //     // Test ad unit for Android
  //     return 'ca-app-pub-3940256099942544/1033173712'; // Use a valid test ID
  //   } else {
  //     throw UnsupportedError('Unsupported platform');
  //   }
  // }


  // static String interstitialAdUnitID = 'ca-app-pub-3940256099942544/1033173712';


  static String openAppAdUnitID = 'ca-app-pub-3940256099942544/1033173712';


}