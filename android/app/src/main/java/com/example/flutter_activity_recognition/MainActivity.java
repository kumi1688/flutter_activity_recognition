package com.example.flutter_activity_recognition;

import android.annotation.TargetApi;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.os.Bundle;
import android.view.MotionEvent;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.google.android.gms.awareness.Awareness;
import com.google.android.gms.awareness.snapshot.DetectedActivityResponse;
import com.google.android.gms.location.ActivityRecognitionResult;
import com.google.android.gms.location.DetectedActivity;
import com.google.android.gms.tasks.OnFailureListener;
import com.google.android.gms.tasks.OnSuccessListener;

import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity implements EventChannel.StreamHandler {
    private String _headphoneState = "헤드폰 상태";
    final static String EVENT_CHANNEL_LIGHT = "com.example.flutter_activity_recognition/stream/light";
    final static String EVENT_CHANNEL_HEADPHONE = "com.example.flutter_activity_recognition/stream/headphone";

    private SensorEventListener sensorEventListener;
    private SensorManager sensorManager;
    private Sensor sensor;
    private FenceReceiver fenceReceiver;
    private MethodChannel methodChannel;

    private EventChannel eventChannel_light;
    private EventChannel eventChannel_headphone;

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        methodChannel = new MethodChannel(flutterEngine.getDartExecutor(), "com.example.flutter_activity_recognition");
        methodChannel.setMethodCallHandler(methodCallHandler);

        eventChannel_light = new EventChannel(flutterEngine.getDartExecutor(), EVENT_CHANNEL_LIGHT);
        eventChannel_headphone = new EventChannel(flutterEngine.getDartExecutor(), EVENT_CHANNEL_HEADPHONE);
        eventChannel_light.setStreamHandler(this);

//        eventChannel_headphone.setStreamHandler(new FenceReceiver());

        sensorManager = (SensorManager) this.getSystemService(this.SENSOR_SERVICE);
        sensor = sensorManager.getDefaultSensor(Sensor.TYPE_LIGHT);
    }

    private MethodChannel.MethodCallHandler methodCallHandler = (methodCall, result) -> {
      if(methodCall.method.equals("getHeadphoneState")){

      } else if (methodCall.method.equals("getActivityState")){
          getUserState(result);
      }
    };

    private void getUserState(MethodChannel.Result result) {
        System.out.println("사용자 상태 가져옴");
        Awareness.getSnapshotClient(this).getDetectedActivity()
                .addOnSuccessListener(new OnSuccessListener<DetectedActivityResponse>() {
                    @Override
                    public void onSuccess(DetectedActivityResponse dar) {
                        ActivityRecognitionResult arr = dar.getActivityRecognitionResult();
                        DetectedActivity probableActivity = arr.getMostProbableActivity();

                        int confidence = probableActivity.getConfidence();
                        int type = probableActivity.getType();

                        UserActivity userActivity = new UserActivity(type, confidence);
                        System.out.println(userActivity.toMap());
                        result.success(userActivity.toMap());
                    }
                })
                .addOnFailureListener(new OnFailureListener() {
                    @Override
                    public void onFailure(@NonNull Exception e) {
                        e.printStackTrace();
//                        _userState = "사용자 상태 가져올 수 없음";
                        result.notImplemented();
                    }
                });
    }

    @Override
    public void onListen(Object arguments, EventChannel.EventSink events){
        sensorEventListener = createSensorEventListener(events);
        sensorManager.registerListener(sensorEventListener, sensor, sensorManager.SENSOR_DELAY_NORMAL);
    };

    @Override
    public void onCancel(Object arguments){ sensorManager.unregisterListener(sensorEventListener);}

    private SensorEventListener createSensorEventListener(final EventChannel.EventSink events) {
        return new SensorEventListener() {
            @Override
            public void onAccuracyChanged(Sensor sensor, int accuracy) {
            }

            @Override
            public void onSensorChanged(SensorEvent event) {
                int lux = (int) event.values[0];
                events.success(lux);
            }
        };
    }



}