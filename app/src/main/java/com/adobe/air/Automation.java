package com.adobe.air;

import android.os.Build;
import android.os.SystemClock;
import android.view.KeyEvent;
import android.view.MotionEvent;
import com.adobe.air.utils.AIRLogger;

/* loaded from: classes.dex */
public class Automation {
    public boolean dispatchTouchEvent(AIRWindowSurfaceView aIRWindowSurfaceView, int i, float f, float f2, float f3, int i2, float f4, float f5, boolean z, float[] fArr, int i3) {
        if (Build.VERSION.SDK_INT < 9) {
            return false;
        }
        try {
            aIRWindowSurfaceView.onTouchEvent(MotionEvent.obtain(SystemClock.uptimeMillis(), SystemClock.uptimeMillis(), i, f, f2, i3));
        } catch (Exception e) {
            AIRLogger.d("Automation", "[JP] dispatchTouchEvent caught " + e);
        }
        return true;
    }

    public boolean dispatchKeyEvent(AIRWindowSurfaceView aIRWindowSurfaceView, int i, int i2, int i3, boolean z, boolean z2, boolean z3) {
        if (Build.VERSION.SDK_INT < 9) {
            return false;
        }
        int i4 = z ? 0 | 2 : 0;
        if (z2) {
            i4 |= 1;
        }
        try {
            KeyEvent keyEvent = new KeyEvent(SystemClock.uptimeMillis(), SystemClock.uptimeMillis(), i, i2, 0, z3 ? i4 | 4 : i4);
            if (i == 0) {
                aIRWindowSurfaceView.onKeyDown(i2, keyEvent);
            } else if (i == 1) {
                aIRWindowSurfaceView.onKeyUp(i2, keyEvent);
            }
        } catch (Exception e) {
            AIRLogger.d("Automation", "[JP] dispatchKeyEvent caught " + e);
        }
        return true;
    }
}
