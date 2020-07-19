package com.example.flutter_activity_recognition;

import android.annotation.TargetApi;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.os.Build;

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.EventChannel;

public class MyPlugin implements EventChannel.StreamHandler {
    private static final String STREAM = "com.example.flutter_activity_recognition";
    private EventChannel eventChannel;

    MyPlugin(FlutterEngine flutterEngine){
        eventChannel = new EventChannel(flutterEngine.getDartExecutor(), STREAM);
    }

    @Override
    public void onListen(Object arguments, EventChannel.EventSink events){

    }

    @Override
    public void onCancel(Object arguments) {

    }

//    public static void registerWith(PluginRegistry.Registrar registrar) {
//        final EventChannel eventChannel =
//                new EventChannel(registrar.messenger(), STEP_COUNT_CHANNEL_NAME);
//        eventChannel.setStreamHandler(
//                new cachet.sensors.light.LightPlugin(registrar.context(), Sensor.TYPE_LIGHT));
//    }

//    private SensorEventListener sensorEventListener;
//    private final SensorManager sensorManager;
//    private final Sensor sensor;

//    @TargetApi(Build.VERSION_CODES.CUPCAKE)
//    private MyPlugin(Context context, int sensorType) {
//        sensorManager = (SensorManager) context.getSystemService(context.SENSOR_SERVICE);
//        sensor = sensorManager.getDefaultSensor(sensorType);
//    }

//    @TargetApi(Build.VERSION_CODES.CUPCAKE)
//    @Override
//    public void onListen(Object arguments, EventChannel.EventSink events) {
//        sensorEventListener = createSensorEventListener(events);
//        sensorManager.registerListener(sensorEventListener, sensor, sensorManager.SENSOR_DELAY_NORMAL);
//    }

//    @TargetApi(Build.VERSION_CODES.CUPCAKE)
//    @Override
//    public void onCancel(Object arguments) {
//        sensorManager.unregisterListener(sensorEventListener);
//    }

//    SensorEventListener createSensorEventListener(final EventChannel.EventSink events) {
//        return new SensorEventListener() {
//            @Override
//            public void onAccuracyChanged(Sensor sensor, int accuracy) {
//            }
//
//            @TargetApi(Build.VERSION_CODES.CUPCAKE)
//            @Override
//            public void onSensorChanged(SensorEvent event) {
//                int lux = (int) event.values[0];
//                events.success(lux);
//            }
//        };
//    }
}
