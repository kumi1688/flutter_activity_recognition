package com.example.flutter_activity_recognition;

import java.util.HashMap;
import java.util.Map;

public class UserActivity {
    private String type;
    private int confidence;

    public static final int IN_VEHICLE = 0;
    public static final int ON_BICYCLE = 1;
    public static final int ON_FOOT = 2;
    public static final int STILL = 3;
    public static final int UNKNOWN = 4;
    public static final int TILTING = 5;
    public static final int WALKING = 7;
    public static final int RUNNING = 8;

    public UserActivity(int type, int confidence){
        super();
        this.type = convertType(type);
        this.confidence = confidence;
    }

    public String convertType(int type){
        switch(type){
            case IN_VEHICLE:    return "IN_VEHICLE";
            case ON_BICYCLE:    return "ON_BICYCLE";
            case ON_FOOT:       return "ON_FOOT";
            case STILL:         return "STILL";
            case TILTING:       return "TILTING";
            case WALKING:       return "WALKING";
            case RUNNING:       return "RUNNING";
            default:            return "UNKNOWN";
        }
    }

    public String getType(){
        return this.type;
    }

    public int getConfidence(){
        return this.confidence;
    }

    public Map toMap(){
        Map map = new HashMap<String, String>();
        map.put("confidence", this.confidence);
        map.put("type", this.type);
        return map;
    }
}
