package com.adobe.air;

import android.view.SurfaceView;

/* loaded from: classes.dex */
public interface FlashEGL {
    int CreateDummySurfaceAndContext();

    int CreateGLContext(boolean z);

    int CreateWindowSurface(SurfaceView surfaceView, int i);

    boolean DestroyGLContext();

    boolean DestroyWindowSurface();

    int[] GetConfigs(boolean z, boolean z2);

    int[] GetNumConfigs();

    int GetSurfaceHeight();

    int GetSurfaceWidth();

    boolean HasGLContext();

    int InitEGL();

    boolean IsARGBSurface();

    boolean IsBufferPreserve();

    boolean IsEmulator();

    int MakeGLCurrent();

    void ReleaseGPUResources();

    void SetConfig(int i);

    void SwapEGLBuffers();

    void TerminateEGL();
}
