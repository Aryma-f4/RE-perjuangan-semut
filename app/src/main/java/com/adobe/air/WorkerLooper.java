package com.adobe.air;

import android.os.Handler;
import android.os.Looper;

/* loaded from: classes.dex */
public class WorkerLooper {
    private Handler mHandler;
    private Looper mLooper;

    public WorkerLooper() {
        Looper.prepare();
        this.mHandler = new customHandler();
        this.mLooper = Looper.myLooper();
    }

    public void start() {
        Looper.loop();
    }

    public Handler getHandler() {
        return this.mHandler;
    }

    public void quit() {
        this.mLooper.quit();
    }
}
