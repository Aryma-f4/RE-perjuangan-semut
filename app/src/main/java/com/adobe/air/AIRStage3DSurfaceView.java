package com.adobe.air;

import android.content.Context;
import android.view.SurfaceHolder;
import android.view.SurfaceView;
import android.view.ViewGroup;
import android.view.ViewTreeObserver;

/* loaded from: classes.dex */
public class AIRStage3DSurfaceView extends SurfaceView implements SurfaceHolder.Callback {
    private static final String TAG = "com.adobe.air";
    private AndroidActivityWrapper mActivityWrapper;
    private long mFPInstance;
    private boolean mInit;
    private boolean mSurfaceValid;
    private int mXmax;
    private int mXmin;
    private int mYmax;
    private int mYmin;
    private ViewTreeObserver.OnGlobalLayoutListener m_layOutListener;

    private native void nativeSurfaceChanged(long j, int i, int i2);

    private native void nativeSurfaceCreated(long j);

    /* JADX INFO: Access modifiers changed from: private */
    public native void nativeSurfaceLayoutChanged(long j);

    private native void nativeSurfaceLost(long j);

    public AIRStage3DSurfaceView(Context context, AndroidActivityWrapper androidActivityWrapper, long j) {
        super(context);
        this.mActivityWrapper = null;
        this.mFPInstance = 0L;
        this.mInit = false;
        this.mSurfaceValid = false;
        this.mXmin = 0;
        this.mYmin = 0;
        this.mXmax = 16;
        this.mYmax = 16;
        this.m_layOutListener = null;
        setFPInstance(context, androidActivityWrapper, j);
        setWillNotDraw(false);
        setEnabled(true);
        setClickable(false);
        setFocusable(false);
        setFocusableInTouchMode(false);
        setLayoutParams(new ViewGroup.LayoutParams(-2, -2));
        if (AndroidActivityWrapper.isGingerbread()) {
            getHolder().setFormat(2);
        } else {
            getHolder().setFormat(1);
        }
        getHolder().addCallback(this);
        setZOrderOnTop(false);
        this.mActivityWrapper.registerPlane(this, 6);
    }

    @Override // android.view.SurfaceView, android.view.View
    protected void onMeasure(int i, int i2) {
        setMeasuredDimension(this.mXmax - this.mXmin, this.mYmax - this.mYmin);
    }

    public void setPlanePosition(int i, int i2, int i3, int i4) {
        this.mXmin = i;
        this.mYmin = i2;
        this.mXmax = i3;
        this.mYmax = i4;
        layout(i, i2, i3, i4);
    }

    public boolean setFPInstance(Context context, AndroidActivityWrapper androidActivityWrapper, long j) {
        this.mActivityWrapper = androidActivityWrapper;
        this.mFPInstance = j;
        if (this.mFPInstance != 0) {
            this.mActivityWrapper.registerPlane(this, 6);
        } else {
            this.mActivityWrapper.unregisterPlane(6);
        }
        return this.mSurfaceValid;
    }

    @Override // android.view.SurfaceHolder.Callback
    public void surfaceChanged(SurfaceHolder surfaceHolder, int i, int i2, int i3) {
        if (this.mFPInstance != 0) {
            nativeSurfaceChanged(this.mFPInstance, i2, i3);
        }
    }

    @Override // android.view.SurfaceHolder.Callback
    public void surfaceCreated(SurfaceHolder surfaceHolder) {
        this.mSurfaceValid = true;
        if (this.mFPInstance != 0) {
            nativeSurfaceCreated(this.mFPInstance);
        }
        this.mActivityWrapper.planeStepCascade();
        ViewTreeObserver viewTreeObserver = getViewTreeObserver();
        if (viewTreeObserver.isAlive()) {
            if (this.m_layOutListener == null) {
                this.m_layOutListener = new ViewTreeObserver.OnGlobalLayoutListener() { // from class: com.adobe.air.AIRStage3DSurfaceView.1
                    @Override // android.view.ViewTreeObserver.OnGlobalLayoutListener
                    public void onGlobalLayout() {
                        if (AIRStage3DSurfaceView.this.mFPInstance != 0) {
                            AIRStage3DSurfaceView.this.nativeSurfaceLayoutChanged(AIRStage3DSurfaceView.this.mFPInstance);
                        }
                    }
                };
            }
            if (this.m_layOutListener != null) {
                viewTreeObserver.addOnGlobalLayoutListener(this.m_layOutListener);
            }
        }
    }

    @Override // android.view.SurfaceHolder.Callback
    public void surfaceDestroyed(SurfaceHolder surfaceHolder) {
        this.mSurfaceValid = false;
        if (this.mFPInstance != 0) {
            nativeSurfaceLost(this.mFPInstance);
        }
        this.mActivityWrapper.planeBreakCascade();
        ViewTreeObserver viewTreeObserver = getViewTreeObserver();
        if (viewTreeObserver.isAlive() && this.m_layOutListener != null) {
            viewTreeObserver.removeGlobalOnLayoutListener(this.m_layOutListener);
        }
    }
}
