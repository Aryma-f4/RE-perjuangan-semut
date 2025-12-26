package com.adobe.flashruntime.shared;

import android.content.Context;
import android.os.Build;
import android.util.Log;
import android.view.Surface;
import android.view.SurfaceHolder;
import android.view.SurfaceView;
import android.view.ViewGroup;

/* loaded from: classes.dex */
public class VideoView extends SurfaceView {
    private static final String TAG = "VideoSurfaceView";
    private boolean mAmCreated;
    private long mCPPInstance;
    private Context mContext;
    private boolean mPlanePositionSet;
    private Surface mSurface;
    private int mXmax;
    private int mXmin;
    private int mYmax;
    private int mYmin;

    private native void nativeSetJavaViewReady(long j, boolean z);

    public VideoView(Context context) {
        super(context);
        this.mXmin = 0;
        this.mYmin = 0;
        this.mXmax = 16;
        this.mYmax = 16;
        this.mAmCreated = false;
        this.mPlanePositionSet = false;
        this.mSurface = null;
        this.mContext = context;
        setLayoutParams(new ViewGroup.LayoutParams(-2, -2));
        if (useOverlay()) {
            getHolder().setFormat(842094169);
        }
        getHolder().addCallback(new SurfaceHolder.Callback() { // from class: com.adobe.flashruntime.shared.VideoView.1
            @Override // android.view.SurfaceHolder.Callback
            public void surfaceChanged(SurfaceHolder surfaceHolder, int i, int i2, int i3) {
                Log.v(VideoView.TAG, "surfaceChanged format=" + i + ", width=" + i2 + ", height=" + i3);
                if (VideoView.this.useOverlay() && VideoView.this.mPlanePositionSet) {
                    if (i2 != VideoView.this.mXmax - VideoView.this.mXmin || i3 != VideoView.this.mYmax - VideoView.this.mYmin) {
                        VideoView.this.setPlanePosition(VideoView.this.mXmin, VideoView.this.mYmin, VideoView.this.mXmax, VideoView.this.mYmax);
                    }
                }
            }

            @Override // android.view.SurfaceHolder.Callback
            public void surfaceCreated(SurfaceHolder surfaceHolder) {
                Log.v(VideoView.TAG, "surfaceCreated");
                VideoView.this.mSurface = surfaceHolder.getSurface();
                VideoView.this.mAmCreated = true;
                VideoView.this.notifyNativeReadyForVideo();
            }

            @Override // android.view.SurfaceHolder.Callback
            public void surfaceDestroyed(SurfaceHolder surfaceHolder) {
                Log.v(VideoView.TAG, "surfaceDestroyed");
                VideoView.this.mSurface.release();
                VideoView.this.mAmCreated = false;
                VideoView.this.notifyNativeReadyForVideo();
            }
        });
    }

    public void VideoPlaybackRestarted() {
    }

    public void setFPInstance(long j) {
        Log.d(TAG, "Changing FP Instance from " + this.mCPPInstance + " to " + j);
        this.mCPPInstance = j;
        notifyNativeReadyForVideo();
    }

    public long getFPInstance() {
        return this.mCPPInstance;
    }

    public void setPlanePosition(int i, int i2, int i3, int i4) {
        this.mXmin = i;
        this.mYmin = i2;
        this.mXmax = i3;
        this.mYmax = i4;
        this.mPlanePositionSet = true;
        getHandler().post(new Runnable() { // from class: com.adobe.flashruntime.shared.VideoView.2
            @Override // java.lang.Runnable
            public void run() {
                VideoView.this.layout(VideoView.this.mXmin, VideoView.this.mYmin, VideoView.this.mXmax, VideoView.this.mYmax);
            }
        });
    }

    protected boolean useOverlay() {
        return Build.VERSION.SDK_INT >= 14;
    }

    public Surface getSurface() {
        if (this.mAmCreated && useOverlay()) {
            return this.mSurface;
        }
        return null;
    }

    public void notifyNativeReadyForVideo() {
        if (this.mCPPInstance != 0) {
            nativeSetJavaViewReady(this.mCPPInstance, this.mAmCreated);
        }
    }
}
