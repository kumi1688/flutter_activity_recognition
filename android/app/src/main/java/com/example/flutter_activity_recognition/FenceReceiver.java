package com.example.flutter_activity_recognition;


import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Bundle;
import android.text.TextUtils;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.google.android.gms.awareness.Awareness;
import com.google.android.gms.awareness.fence.AwarenessFence;
import com.google.android.gms.awareness.fence.FenceState;
import com.google.android.gms.awareness.fence.FenceUpdateRequest;
import com.google.android.gms.awareness.fence.HeadphoneFence;
import com.google.android.gms.awareness.state.HeadphoneState;
import com.google.android.gms.tasks.OnFailureListener;
import com.google.android.gms.tasks.OnSuccessListener;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

class FenceReceiver extends FlutterActivity implements EventChannel.StreamHandler {
    public static final String FENCE_RECEIVER_ACTION = "com.example.flutter_activity_recognition.FENCE_RECEIVER_ACTION";

    private static final String HEADPHONE_FENCE_KEY = "HEADPHONE_FENCE_KEY";

    private PendingIntent mPendingIntent;
    private HeadphoneFenceReceiver mHeadphoneFenceReceiver;


    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
    }

    @Override
    public void onListen(Object arguments, EventChannel.EventSink events){
        if(mHeadphoneFenceReceiver == null){
            System.out.println("시작");
            Intent intent = new Intent(HeadphoneFenceReceiver.FENCE_RECEIVER_ACTION);
            System.out.println("생성됨1");
            mPendingIntent = PendingIntent.getBroadcast(this.getBaseContext(),100,intent, PendingIntent.FLAG_UPDATE_CURRENT);
            System.out.println("생성됨2");
            registerFence();
            System.out.println("생성됨3");
            registerReceiver(mHeadphoneFenceReceiver,  new IntentFilter(HeadphoneFenceReceiver.FENCE_RECEIVER_ACTION));
            System.out.println("생성됨4");
            mHeadphoneFenceReceiver = new HeadphoneFenceReceiver(events);
        }
        else
            mHeadphoneFenceReceiver.setEvent(events);
    };

    @Override
    public void onCancel(Object arguments){ }

    private void registerFence() {
        System.out.println("펜스 등록 시도");
        AwarenessFence headphoneFence = HeadphoneFence.during(HeadphoneState.PLUGGED_IN);

        Awareness.getFenceClient(this).updateFences(
                new FenceUpdateRequest.Builder()
                        .addFence(HEADPHONE_FENCE_KEY, headphoneFence, mPendingIntent)
                        .build())
                .addOnSuccessListener(new OnSuccessListener<Void>() {
                    @Override
                    public void onSuccess(Void aVoid) {
                        System.out.println("헤드폰 펜스 등록 성공");
                    }
                })
                .addOnFailureListener(new OnFailureListener() {
                    @Override
                    public void onFailure(@NonNull Exception e) {
                        System.out.println("헤드폰 펜스 등록 실패");
                    }
                });
    }
}

class HeadphoneFenceReceiver extends BroadcastReceiver {
    public static final String FENCE_RECEIVER_ACTION =
            "com.example.flutter_activity_recognition.FENCE_RECEIVER_ACTION";

    private static final String HEADPHONE_FENCE_KEY = "HEADPHONE_FENCE_KEY";

    private EventChannel.EventSink events;

    HeadphoneFenceReceiver(EventChannel.EventSink event){
        this.events = event;
        System.out.println("해 생성");
    }

    public void setEvent(EventChannel.EventSink event){
        this.events = event;
        System.out.println("누구누구");
    }

    @Override
    public void onReceive(Context context, Intent intent) {
        FenceState fenceState = FenceState.extract(intent);
        System.out.println(fenceState.getCurrentState());

            switch(fenceState.getCurrentState()) {
                case FenceState.TRUE:
                    events.success("참");
//                    setHeadphoneState(HeadphoneState.PLUGGED_IN);
                    break;
                case FenceState.FALSE:
                    events.success("거짓");
                    break;
                case FenceState.UNKNOWN:
                    events.success("모름");
                    break;
            }
        }
    }