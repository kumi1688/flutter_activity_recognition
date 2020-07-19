package com.example.flutter_activity_recognition;

import android.annotation.TargetApi;
import android.content.Context;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.os.Build;
import android.os.Bundle;

import androidx.annotation.NonNull;

import com.google.android.gms.awareness.Awareness;
import com.google.android.gms.awareness.snapshot.HeadphoneStateResponse;
import com.google.android.gms.awareness.state.HeadphoneState;
import com.google.android.gms.tasks.OnFailureListener;
import com.google.android.gms.tasks.OnSuccessListener;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity implements EventChannel.StreamHandler {
    private String _headphoneState = "헤드폰 상태";

    private SensorEventListener sensorEventListener;
    private SensorManager sensorManager;
    private Sensor sensor;

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        final MethodChannel methodChannel = new MethodChannel(flutterEngine.getDartExecutor(), "com.example.flutter_activity_recognition");
        methodChannel.setMethodCallHandler(methodCallHandler);

        sensorManager = (SensorManager) this.getSystemService(this.SENSOR_SERVICE);
        sensor = sensorManager.getDefaultSensor(Sensor.TYPE_LIGHT);

        final EventChannel eventChannel = new EventChannel(flutterEngine.getDartExecutor(), "com.example.flutter_activity_recognition/stream");
        eventChannel.setStreamHandler(this);
    }

    private MethodChannel.MethodCallHandler methodCallHandler = (methodCall, result) -> {
      if(methodCall.method.equals("getHeadphoneState")){
          getHeadphoneState(result);
      }
    };

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

            @TargetApi(Build.VERSION_CODES.CUPCAKE)
            @Override
            public void onSensorChanged(SensorEvent event) {
                int lux = (int) event.values[0];
                events.success(lux);
            }
        };
    }

    private void getHeadphoneState(MethodChannel.Result result) {
        Awareness.getSnapshotClient(this).getHeadphoneState()
                .addOnSuccessListener(new OnSuccessListener<HeadphoneStateResponse>() {
                    @Override
                    public void onSuccess(HeadphoneStateResponse headphoneStateResponse) {
                        int state = headphoneStateResponse.getHeadphoneState().getState();

                        if (state == HeadphoneState.PLUGGED_IN) {
                            _headphoneState = "헤드폰 연결 됨";
                        } else if (state == HeadphoneState.UNPLUGGED) {
                            _headphoneState = "헤드폰 연결 되지 않음";
                        }

                        result.success(_headphoneState);
                    }
                })
                .addOnFailureListener(new OnFailureListener() {
                    @Override
                    public void onFailure(@NonNull Exception e) {
                        e.printStackTrace();
                        _headphoneState = "헤드폰 상태 가져올 수 없음";
                        result.success(_headphoneState);
                    }
                });
    }
}