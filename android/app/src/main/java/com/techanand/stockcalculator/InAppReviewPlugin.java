package com.techanand.stockcalculator;

import android.app.Activity;
import android.content.Context;

import androidx.annotation.NonNull;

import com.google.android.play.core.review.ReviewInfo;

import java.lang.ref.WeakReference;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

public class InAppReviewPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {

    private static final String TAG = "InAppReview";
    private static final String APP_REVIEW_ID = "in_app_review";

    private MethodChannel channel;
    private Activity currentActivity;
    private ReviewInfo reviewInfo;
    private Context context;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        channel = new MethodChannel(binding.getBinaryMessenger(), "in_app_review");
        channel.setMethodCallHandler(this);
        context = binding.getApplicationContext();
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
        context = null;
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        currentActivity = binding.getActivity();
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        onDetachedFromActivity();
    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
        onAttachedToActivity(binding);
    }

    @Override
    public void onDetachedFromActivity() {
        currentActivity = null;
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        System.out.println("From Android class: " + call.method);
        if (call.method.equals("requestReview")) {
            requestReview(result);
        } else if (call.method.equals("isRequestAvilable")) {
            isRequestAvailable(result);
        } else {
            result.notImplemented();
        }
    }

    private void requestReview(Result result) {

    }

    private void isRequestAvailable(Result result) {

    }
}
