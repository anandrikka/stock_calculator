import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ReviewOptionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ElevatedButton(
        child: Text('Click'),
        onPressed: () async {
          MethodChannel _channel = MethodChannel('in_app_review');
          await _channel.invokeMethod('requestReview');
        },
      ),
    );
  }
}
