package com.google.android.gms.common;

import android.content.ComponentName;
import android.content.ServiceConnection;
import android.os.IBinder;
import java.util.concurrent.BlockingQueue;
import java.util.concurrent.LinkedBlockingQueue;

/* loaded from: classes.dex */
public class a implements ServiceConnection {
    boolean z = false;
    private final BlockingQueue<IBinder> A = new LinkedBlockingQueue();

    public IBinder e() throws InterruptedException {
        if (this.z) {
            throw new IllegalStateException();
        }
        this.z = true;
        return this.A.take();
    }

    @Override // android.content.ServiceConnection
    public void onServiceConnected(ComponentName name, IBinder service) throws InterruptedException {
        try {
            this.A.put(service);
        } catch (InterruptedException e) {
        }
    }

    @Override // android.content.ServiceConnection
    public void onServiceDisconnected(ComponentName name) {
    }
}
