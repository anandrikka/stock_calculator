package com.techanand.stockcalculator;

import android.app.Activity;
import android.content.Context;
import android.content.pm.PackageManager;
import android.os.Build;
import android.util.Log;

import androidx.annotation.NonNull;

import com.google.android.play.core.review.ReviewInfo;
import com.google.android.play.core.review.ReviewManager;
import com.google.android.play.core.review.ReviewManagerFactory;
import com.google.android.play.core.tasks.Task;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

public class InAppReviewPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {

    private static final String TAG = "InAppReviewPlugin";
    private static final String APP_REVIEW_ID = "in_app_review";
    private static final String EC_NOT_AVIALABLE = "ERR_404";
    private static final String EC_ACTIVITY_NOT_AVAILABLE = "ERR_405";
    private static final String EC_CONTEXT_NOT_AVAILABLE = "ERR_406";
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
        Log.i(TAG, "onMethodCall: " + call.method);
        System.out.println("From Android class1: " + call.method);
        if (call.method.equals("requestReview")) {
            requestReview(result);
        } else if (call.method.equals("isRequestReviewAvailable")) {
            isRequestReviewAvailable(result);
        } else if (call.method.equals("isInAppReviewCompatible")) {
            isInAppReviewCompatible(result);
        } else {
            result.notImplemented();
        }
    }

    private void requestReview(Result result) {
        if (null == context) {
            result.error(EC_CONTEXT_NOT_AVAILABLE, "Context not available", null);
        }
        if (null == currentActivity) {
            result.error(EC_ACTIVITY_NOT_AVAILABLE, "Activity not found", null);
            return;
        }
        final ReviewManager reviewManager = ReviewManagerFactory.create(context);
        reviewManager
                .requestReviewFlow()
                .addOnCompleteListener(task -> {
                    if (task.isSuccessful()) {
                        reviewInfo = task.getResult();
                        reviewManager.launchReviewFlow(currentActivity, reviewInfo).addOnCompleteListener(task1 -> {
                            if (task1.isSuccessful()) {
                                result.success(true);
                            }
                        });
                    }
                });
    }

    private void isRequestReviewAvailable(Result result) {
        ReviewManager reviewManager = ReviewManagerFactory.create(context);
        Task<ReviewInfo> requestWorkflow = reviewManager.requestReviewFlow();
        requestWorkflow.addOnCompleteListener(task -> {
            if (task.isSuccessful()) {
                reviewInfo = task.getResult();
                result.success(true);
            } else {
                result.success(false);
            }
        });
    }

    private boolean isPlayStoreInstalled() {
        try {
            context.getPackageManager().getPackageInfo("com.android.vending", 0);
            return true;
        } catch (PackageManager.NameNotFoundException e) {
            Log.i(TAG, "playstore not installed");
            return false;
        }
    }

    private void isInAppReviewCompatible(final Result result) {
        final boolean isPlayStoreInstalled = isPlayStoreInstalled();
        final boolean isCompatibleVersion = Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP;
        Log.i(TAG, "isPlayStoreInstalled: " + isPlayStoreInstalled);
        Log.i(TAG, "isCompatibleVersion: " + isCompatibleVersion);
        if (!isCompatibleVersion || !isPlayStoreInstalled) {
            result.success(false);
            return;
        }
        result.success(true);
    }
}
