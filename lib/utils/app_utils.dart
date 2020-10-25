import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

const CHANNEL_IN_APP_REVIEW = 'in_app_review';

Future<bool> isReviewRequestAvailable(BuildContext context) async {
  MethodChannel channel = MethodChannel(CHANNEL_IN_APP_REVIEW);
  var output = await channel.invokeMethod('isRequestReviewAvailable');
  return output as bool;
}

Future<bool> writeReview(BuildContext context) async {
  try {
    MethodChannel channel = MethodChannel(CHANNEL_IN_APP_REVIEW);
    var output = await channel.invokeMethod('requestReview');
    return output as bool;
  } on dynamic catch (e) {
    print('InappReview error: ' + e.toString());
    final bundle = (await PackageInfo.fromPlatform())?.packageName ?? '';
    try {
      final marketUrl = 'market://details?id=$bundle';
      var canBeLaunched = await canLaunch(marketUrl);
      if (canBeLaunched) {
        await launch(marketUrl);
        return true;
      }
    } on dynamic catch (e) {
      print('Error on opening playstore: ' + e.toString());
      await launch('https://play.google.com/store/apps/detailss?id=$bundle');
      return true;
    }
    return false;
  }
}
