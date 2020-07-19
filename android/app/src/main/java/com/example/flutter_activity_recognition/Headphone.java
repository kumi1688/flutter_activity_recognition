package com.example.flutter_activity_recognition;

import io.flutter.embedding.android.FlutterActivity;

import android.annotation.TargetApi;
import android.content.BroadcastReceiver;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.os.Build;

import androidx.annotation.NonNull;

import com.google.android.gms.awareness.Awareness;
import com.google.android.gms.awareness.snapshot.HeadphoneStateResponse;
import com.google.android.gms.awareness.state.HeadphoneState;
import com.google.android.gms.tasks.OnSuccessListener;

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class Headphone extends FlutterActivity implements EventChannel.StreamHandler {
    private static final String STREAM = "com.example.flutter_activity_recognition/stream/headphone";

    private EventChannel eventChannel;
    private SensorEventListener sensorEventListener;
    private SensorManager sensorManager;
    private Sensor sensor;

    public static final String FENCE_RECEIVER_ACTION =
            "com.hitherejoe.aware.ui.fence.FenceReceiver.FENCE_RECEIVER_ACTION";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);


        Awareness.getSnapshotClient(this).getHeadphoneState()
                .addOnSuccessListener(new OnSuccessListener<HeadphoneStateResponse>() {
                    String _headphoneState;

                    @Override
                    public void onSuccess(HeadphoneStateResponse headphoneStateResponse) {
                        int state = headphoneStateResponse.getHeadphoneState().getState();

                        if(state == HeadphoneState.PLUGGED_IN){
                            _headphoneState = "헤드폰 연결 됨";
                        } else if( state == HeadphoneState.UNPLUGGED){
                            _headphoneState = "헤드폰 연결 안 됨";
                        }

                    }
                });


        final EventChannel eventChannel = new EventChannel(flutterEngine.getDartExecutor(), "com.example.flutter_activity_recognition/stream");
        eventChannel.setStreamHandler(this);
    }

    Headphone(FlutterEngine flutterEngine){
        eventChannel = new EventChannel(flutterEngine.getDartExecutor(), STREAM);
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

            @TargetApi(Build.VERSION_CODES.CUPCAKE)
            @Override
            public void onSensorChanged(SensorEvent event) {
                int lux = (int) event.values[0];
                events.success(lux);
            }
        };
    }
}
