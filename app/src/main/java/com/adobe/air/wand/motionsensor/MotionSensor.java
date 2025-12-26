package com.adobe.air.wand.motionsensor;

import android.app.Activity;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;

/* loaded from: classes.dex */
public abstract class MotionSensor {
    protected static final String LOG_TAG = "MotionSensor";
    protected Activity mActivity;
    protected Sensor mSensor;
    protected SensorManager mSensorManager;
    protected SensorEventListener mSensorEventListener = null;
    protected boolean mRegistered = false;
    protected int mSensorDelay = 1;

    public interface Listener {
        void onSensorChanged(float[] fArr, long j);
    }

    public MotionSensor(Activity activity, int i) {
        this.mSensorManager = null;
        this.mSensor = null;
        this.mActivity = null;
        this.mActivity = activity;
        this.mSensorManager = (SensorManager) this.mActivity.getSystemService("sensor");
        this.mSensor = this.mSensorManager.getDefaultSensor(i);
        if (this.mSensor != null) {
        }
    }

    /* JADX INFO: Access modifiers changed from: private */
    public float[] getScreenOrientedValues(float[] fArr) {
        float[] fArr2 = (float[]) fArr.clone();
        int rotation = this.mActivity.getWindowManager().getDefaultDisplay().getRotation();
        if (rotation != 0) {
            if (rotation == 2) {
                fArr2[0] = -fArr2[0];
                fArr2[1] = -fArr2[1];
            } else if (rotation == 1) {
                float f = fArr2[0];
                fArr2[0] = -fArr2[1];
                fArr2[1] = f;
            } else if (rotation == 3) {
                float f2 = -fArr2[0];
                fArr2[0] = fArr2[1];
                fArr2[1] = f2;
            }
        }
        return fArr2;
    }

    public void setListener(final Listener listener) {
        boolean z = this.mRegistered;
        stop();
        this.mSensorEventListener = listener == null ? null : new SensorEventListener() { // from class: com.adobe.air.wand.motionsensor.MotionSensor.1
            @Override // android.hardware.SensorEventListener
            public void onSensorChanged(SensorEvent sensorEvent) {
                listener.onSensorChanged(MotionSensor.this.getScreenOrientedValues(sensorEvent.values), sensorEvent.timestamp);
            }

            @Override // android.hardware.SensorEventListener
            public void onAccuracyChanged(Sensor sensor, int i) {
            }
        };
        if (z) {
            start();
        }
    }

    public void start(int i) {
        if (!this.mRegistered && this.mSensor != null) {
            this.mSensorDelay = i * 1000;
            start();
        }
    }

    public void start() {
        if (!this.mRegistered && this.mSensor != null) {
            this.mRegistered = this.mSensorManager.registerListener(this.mSensorEventListener, this.mSensor, this.mSensorDelay);
            if (this.mRegistered) {
            }
        }
    }

    public void stop() {
        if (this.mRegistered) {
            this.mSensorManager.unregisterListener(this.mSensorEventListener, this.mSensor);
            this.mRegistered = false;
        }
    }

    public boolean available() {
        return this.mSensor != null;
    }

    public boolean active() {
        return this.mRegistered;
    }

    public void dispose() {
        stop();
        setListener(null);
        this.mSensor = null;
        this.mSensorManager = null;
        this.mActivity = null;
    }
}
