package com.adobe.air;

import android.content.Context;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;

/* loaded from: classes.dex */
public class Accelerometer implements SensorEventListener {
    private static final float STANDARD_GRAVITY = 9.81f;
    private Context mContext;
    private SensorManager mSensorManager;
    private float m_x;
    private float m_y;
    private float m_z;

    @Override // android.hardware.SensorEventListener
    public void onSensorChanged(SensorEvent sensorEvent) {
        this.m_x = sensorEvent.values[0] / STANDARD_GRAVITY;
        this.m_y = sensorEvent.values[1] / STANDARD_GRAVITY;
        this.m_z = sensorEvent.values[2] / STANDARD_GRAVITY;
    }

    @Override // android.hardware.SensorEventListener
    public void onAccuracyChanged(Sensor sensor, int i) {
    }

    public void removeListener() {
        if (this.mContext.getPackageManager().hasSystemFeature("android.hardware.sensor.accelerometer")) {
            this.mSensorManager.unregisterListener(this);
        }
    }

    public float getX() {
        return this.m_x;
    }

    public float getY() {
        return this.m_y;
    }

    public float getZ() {
        return this.m_z;
    }

    public Accelerometer(Context context) {
        this.mContext = context;
        if (this.mContext.getPackageManager().hasSystemFeature("android.hardware.sensor.accelerometer")) {
            this.mSensorManager = (SensorManager) context.getSystemService("sensor");
            this.mSensorManager.registerListener(this, this.mSensorManager.getDefaultSensor(1), 0);
        }
    }
}
