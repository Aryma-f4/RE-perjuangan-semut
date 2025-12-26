package com.adobe.air;

import android.content.Context;
import android.graphics.Bitmap;
import android.view.SurfaceHolder;
import java.util.concurrent.Semaphore;

/* loaded from: classes.dex */
public class AIRWindowThreadedSurfaceView extends AIRWindowSurfaceView {
    public final Semaphore drawSemaphore;
    private DrawThread thread;

    public AIRWindowThreadedSurfaceView(Context context, AndroidActivityWrapper androidActivityWrapper) {
        super(context, androidActivityWrapper);
        this.thread = null;
        this.drawSemaphore = new Semaphore(0);
        Init(context);
    }

    protected void Init(Context context) {
        this.thread = new DrawThread(this, this.mSurfaceHolder, context);
    }

    @Override // com.adobe.air.AIRWindowSurfaceView, android.view.SurfaceHolder.Callback
    public void surfaceCreated(SurfaceHolder surfaceHolder) {
        super.surfaceCreated(surfaceHolder);
        this.thread.setRunning(true);
        if (!this.thread.isAlive()) {
            try {
                this.thread.start();
            } catch (Exception e) {
            }
        }
    }

    @Override // com.adobe.air.AIRWindowSurfaceView, android.view.SurfaceHolder.Callback
    public void surfaceChanged(SurfaceHolder surfaceHolder, int i, int i2, int i3) {
        super.surfaceChanged(surfaceHolder, i, i2, i3);
    }

    @Override // com.adobe.air.AIRWindowSurfaceView, android.view.SurfaceHolder.Callback
    public void surfaceDestroyed(SurfaceHolder surfaceHolder) {
        super.surfaceDestroyed(surfaceHolder);
        boolean z = true;
        this.thread.setRunning(false);
        while (z && this.thread.isAlive()) {
            try {
                this.thread.join();
                z = false;
            } catch (InterruptedException e) {
            }
        }
    }

    @Override // com.adobe.air.AIRWindowSurfaceView
    public void drawBitmap(int i, int i2, int i3, int i4, Bitmap bitmap) throws InterruptedException {
        this.thread.requestDraw(i, i2, i3, i4, bitmap);
        try {
            this.drawSemaphore.acquire();
        } catch (Exception e) {
        }
    }

    @Override // com.adobe.air.AIRWindowSurfaceView
    public void drawBitmap(int i, int i2, int i3, int i4, Bitmap bitmap, int i5, int i6, int i7, int i8, boolean z, int i9) throws InterruptedException {
        this.thread.requestDraw(i, i2, i3, i4, bitmap, i5, i6, i7, i8, z, i9);
        try {
            this.drawSemaphore.acquire();
        } catch (Exception e) {
        }
    }
}
