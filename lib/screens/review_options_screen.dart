import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stockcalculator/utils/alerts.dart';

class ReviewOptionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ElevatedButton(
        child: Text('Click'),
        onPressed: () async {
          MethodChannel _channel = MethodChannel('in_app_review');
          try {
            var isAvailable =
                await _channel.invokeMethod('isRequestReviewAvailable');
            if (isAvailable) {
              await _channel.invokeMethod('requestReview');
            } else {
              showAlert(
                context: context,
                message: 'App Review is not avaiable now!',
              );
            }
          } on Exception catch (e) {
            print('Review Plugin Error: ' + e.toString());
            showAlert(
              context: context,
              message: 'Cannot review app now!',
            );
          }
        },
      ),
    );
  }
}
