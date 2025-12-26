package com.adobe.air.wand.view;

import android.content.Context;
import android.os.Build;
import android.util.DisplayMetrics;
import android.view.GestureDetector;
import android.view.MotionEvent;
import android.view.ScaleGestureDetector;
import android.view.ViewConfiguration;

/* loaded from: classes.dex */
public class GestureListener implements GestureDetector.OnGestureListener, GestureDetector.OnDoubleTapListener, ScaleGestureDetector.OnScaleGestureListener {
    private static final String LOG_TAG = "GestureListener";
    private static final int MAX_TOUCH_POINTS = 2;
    private static final float MM_PER_INCH = 25.4f;
    private static final float _FP_GESTURE_PAN_THRESHOLD_MM = 3.0f;
    private static final float _FP_GESTURE_ROTATION_THRESHOLD_DEGREES = 15.0f;
    private static final float _FP_GESTURE_SWIPE_PRIMARY_AXIS_MIN_MM = 10.0f;
    private static final float _FP_GESTURE_SWIPE_SECONDARY_AXIS_MAX_MM = 5.0f;
    private static final float _FP_GESTURE_ZOOM_PER_AXIS_THRESHOLD_MM = 3.0f;
    private static final float _FP_GESTURE_ZOOM_THRESHOLD_MM = 8.0f;
    public static final int kGestureAll = 8;
    public static final int kGestureBegin = 2;
    public static final int kGestureEnd = 4;
    public static final int kGesturePan = 1;
    public static final int kGestureRotate = 2;
    public static final int kGestureSwipe = 4;
    public static final int kGestureTap = 3;
    public static final int kGestureUpdate = 1;
    public static final int kGestureZoom = 0;
    private static int screenPPI = 0;
    private CompanionView mCompanionView;
    private TouchPoint mSecondaryPointOfTwoFingerTap;
    private float mPreviousAbsoluteRotation = 0.0f;
    private boolean mInRotateTransformGesture = false;
    private boolean mInZoomTransformGesture = false;
    private boolean mInZoomTransformGestureX = false;
    private boolean mInZoomTransformGestureY = false;
    private boolean mInPanTransformGesture = false;
    private float mPreviousRotateLocX = 0.0f;
    private float mPreviousRotateLocY = 0.0f;
    private float mPreviousZoomLocX = 0.0f;
    private float mPreviousZoomLocY = 0.0f;
    private float mPreviousPanLocX = 0.0f;
    private float mPreviousPanLocY = 0.0f;
    private long mTwoFingerTapStartTime = 0;
    private boolean mDidOccurTwoFingerGesture = false;
    private int mCouldBeTwoFingerTap = 0;
    private TouchPoint mPrimaryPointOfTwoFingerTap = null;
    private boolean mCheckForSwipe = true;
    private TouchPoint[] mDownTouchPoints = new TouchPoint[2];

    private class TouchPoint {
        private int pid;
        private float x;
        private float y;

        TouchPoint() {
            this.x = 0.0f;
            this.y = 0.0f;
            this.pid = 0;
        }

        TouchPoint(float f, float f2, int i) {
            this.x = f;
            this.y = f2;
            this.pid = i;
        }

        /* JADX INFO: Access modifiers changed from: private */
        public void assign(float f, float f2, int i) {
            this.x = f;
            this.y = f2;
            this.pid = i;
        }
    }

    public GestureListener(Context context, CompanionView companionView) {
        this.mCompanionView = null;
        this.mSecondaryPointOfTwoFingerTap = null;
        this.mCompanionView = companionView;
        for (int i = 0; i < 2; i++) {
            this.mDownTouchPoints[i] = new TouchPoint();
        }
        this.mSecondaryPointOfTwoFingerTap = new TouchPoint();
        DisplayMetrics displayMetrics = context.getResources().getDisplayMetrics();
        screenPPI = (int) ((displayMetrics.ydpi + displayMetrics.xdpi) / 2.0f);
    }

    public TouchPoint getDownTouchPoint(int i) {
        if (i < 0 || i >= 2) {
            return null;
        }
        return this.mDownTouchPoints[i];
    }

    public void setDownTouchPoint(float f, float f2, int i) {
        if (i >= 0 && i < 2) {
            this.mDownTouchPoints[i].assign(f, f2, i);
        }
    }

    public void setCouldBeTwoFingerTap(int i) {
        this.mCouldBeTwoFingerTap = i;
        if (i == 0) {
            this.mTwoFingerTapStartTime = System.currentTimeMillis();
            this.mDidOccurTwoFingerGesture = false;
        }
    }

    public int getCouldBeTwoFingerTap() {
        return this.mCouldBeTwoFingerTap;
    }

    public void setSecondaryPointOfTwoFingerTap(float f, float f2, int i) {
        this.mSecondaryPointOfTwoFingerTap = new TouchPoint(f, f2, i);
    }

    public void setPrimaryPointOfTwoFingerTap(float f, float f2, int i) {
        this.mPrimaryPointOfTwoFingerTap = new TouchPoint(f, f2, i);
    }

    public void mayStartNewTransformGesture() {
        this.mInRotateTransformGesture = false;
        this.mInZoomTransformGesture = false;
        this.mInZoomTransformGestureX = false;
        this.mInZoomTransformGestureY = false;
        this.mInPanTransformGesture = false;
    }

    public boolean getCheckForSwipe() {
        return this.mCheckForSwipe;
    }

    public void setCheckForSwipe(boolean z) {
        this.mCheckForSwipe = z;
    }

    public boolean endTwoFingerGesture() {
        int multitouchMode = this.mCompanionView.getMultitouchMode();
        this.mCompanionView.getClass();
        if (multitouchMode != 2) {
            return true;
        }
        long jCurrentTimeMillis = System.currentTimeMillis();
        if (!this.mDidOccurTwoFingerGesture && this.mCouldBeTwoFingerTap == 3 && jCurrentTimeMillis - this.mTwoFingerTapStartTime < ViewConfiguration.getTapTimeout()) {
            onTwoFingerTap();
        }
        endRotateGesture();
        endPanGesture();
        return true;
    }

    private void endRotateGesture() {
        int multitouchMode = this.mCompanionView.getMultitouchMode();
        this.mCompanionView.getClass();
        if (multitouchMode == 2 && this.mInRotateTransformGesture) {
            this.mCompanionView.onGestureListener(4, 2, true, this.mPreviousRotateLocX, this.mPreviousRotateLocY, 1.0f, 1.0f, 0.0f, 0.0f, 0.0f);
            this.mInRotateTransformGesture = false;
        }
    }

    private void endZoomGesture() {
        int multitouchMode = this.mCompanionView.getMultitouchMode();
        this.mCompanionView.getClass();
        if (multitouchMode == 2 && this.mInZoomTransformGesture) {
            this.mCompanionView.onGestureListener(4, 0, true, this.mPreviousZoomLocX, this.mPreviousZoomLocY, 1.0f, 1.0f, 0.0f, 0.0f, 0.0f);
            this.mInZoomTransformGesture = false;
            this.mInZoomTransformGestureX = false;
            this.mInZoomTransformGestureY = false;
        }
    }

    private void endPanGesture() {
        int multitouchMode = this.mCompanionView.getMultitouchMode();
        this.mCompanionView.getClass();
        if (multitouchMode == 2 && this.mInPanTransformGesture) {
            this.mCompanionView.onGestureListener(4, 1, true, this.mPreviousPanLocX, this.mPreviousPanLocY, 1.0f, 1.0f, 0.0f, 0.0f, 0.0f);
            this.mInPanTransformGesture = false;
        }
    }

    @Override // android.view.GestureDetector.OnGestureListener
    public boolean onDown(MotionEvent motionEvent) {
        return true;
    }

    @Override // android.view.GestureDetector.OnGestureListener
    public boolean onFling(MotionEvent motionEvent, MotionEvent motionEvent2, float f, float f2) {
        return true;
    }

    @Override // android.view.GestureDetector.OnGestureListener
    public void onLongPress(MotionEvent motionEvent) {
    }

    @Override // android.view.GestureDetector.OnGestureListener
    public boolean onScroll(MotionEvent motionEvent, MotionEvent motionEvent2, float f, float f2) {
        int pointerId;
        boolean z;
        float f3;
        float f4;
        int multitouchMode = this.mCompanionView.getMultitouchMode();
        this.mCompanionView.getClass();
        if (multitouchMode != 2) {
            return true;
        }
        float f5 = 0.0f;
        float f6 = 0.0f;
        float f7 = 0.0f;
        if (motionEvent2.getPointerCount() == 2) {
            int i = 1;
            float x = (motionEvent2.getX(0) + motionEvent2.getX(1)) / 2.0f;
            float y = (motionEvent2.getY(0) + motionEvent2.getY(1)) / 2.0f;
            TouchPoint[] touchPointArr = new TouchPoint[2];
            for (int i2 = 0; i2 < 2; i2++) {
                touchPointArr[i2] = new TouchPoint(motionEvent2.getX(i2), motionEvent2.getY(i2), motionEvent2.getPointerId(i2));
            }
            int i3 = touchPointArr[0].pid;
            int i4 = touchPointArr[1].pid;
            if (i3 >= 0 && i3 < 2 && i4 >= 0 && i4 < 2) {
                if (!this.mInPanTransformGesture) {
                    float rotation = getRotation(this.mDownTouchPoints[i3], this.mDownTouchPoints[i4], touchPointArr[0], touchPointArr[1]);
                    if (Math.abs(rotation) > 180.0f) {
                        f3 = rotation > 0.0f ? (360.0f - rotation) * (-1.0f) : rotation + 360.0f;
                    } else {
                        f3 = rotation;
                    }
                    if (this.mInRotateTransformGesture || Math.abs(f3) > _FP_GESTURE_ROTATION_THRESHOLD_DEGREES) {
                        if (!this.mInRotateTransformGesture) {
                            i = 2;
                            this.mInRotateTransformGesture = true;
                            this.mPreviousAbsoluteRotation = 0.0f;
                            this.mDidOccurTwoFingerGesture = true;
                        }
                        int i5 = i;
                        float f8 = f3 - this.mPreviousAbsoluteRotation;
                        if (Math.abs(f8) > 180.0f) {
                            f4 = f8 > 0.0f ? (360.0f - f8) * (-1.0f) : f8 + 360.0f;
                        } else {
                            f4 = f8;
                        }
                        this.mPreviousAbsoluteRotation = f3;
                        this.mPreviousRotateLocX = x;
                        this.mPreviousRotateLocY = y;
                        this.mCompanionView.onGestureListener(i5, 2, true, x, y, 1.0f, 1.0f, f4, 0.0f, 0.0f);
                        f5 = 0.0f;
                        i = i5;
                    }
                }
                if (!this.mInZoomTransformGesture && !this.mInRotateTransformGesture) {
                    if (isPanGesture(this.mDownTouchPoints[i3], this.mDownTouchPoints[i4], touchPointArr[0], touchPointArr[1])) {
                        if (!this.mInPanTransformGesture) {
                            i = 2;
                            this.mInPanTransformGesture = true;
                            this.mDidOccurTwoFingerGesture = true;
                        }
                        this.mPreviousPanLocX = x;
                        this.mPreviousPanLocY = y;
                        this.mCompanionView.onGestureListener(i, 1, true, x, y, 1.0f, 1.0f, f5, (-1.0f) * f, (-1.0f) * f2);
                    } else if (this.mInPanTransformGesture) {
                        endPanGesture();
                        setDownTouchPoint(touchPointArr[0].x, touchPointArr[0].y, touchPointArr[0].pid);
                        setDownTouchPoint(touchPointArr[1].x, touchPointArr[1].y, touchPointArr[1].pid);
                    }
                }
            }
        } else if (motionEvent2.getPointerCount() == 1 && (pointerId = motionEvent2.getPointerId(0)) >= 0 && pointerId < 2 && this.mCheckForSwipe && motionEvent.getPointerCount() == 1) {
            float x2 = motionEvent2.getX(0) - this.mDownTouchPoints[pointerId].x;
            float y2 = motionEvent2.getY(0) - this.mDownTouchPoints[pointerId].y;
            if ((Math.abs(x2) * MM_PER_INCH) / screenPPI >= _FP_GESTURE_SWIPE_PRIMARY_AXIS_MIN_MM && (Math.abs(y2) * MM_PER_INCH) / screenPPI <= _FP_GESTURE_SWIPE_SECONDARY_AXIS_MAX_MM) {
                z = true;
                f7 = 0.0f;
                f6 = x2 > 0.0f ? 1.0f : -1.0f;
            } else if ((Math.abs(y2) * MM_PER_INCH) / screenPPI >= _FP_GESTURE_SWIPE_PRIMARY_AXIS_MIN_MM && (Math.abs(x2) * MM_PER_INCH) / screenPPI <= _FP_GESTURE_SWIPE_SECONDARY_AXIS_MAX_MM) {
                f7 = y2 > 0.0f ? 1.0f : -1.0f;
                f6 = 0.0f;
                z = true;
            } else {
                z = false;
            }
            if (z) {
                this.mCompanionView.onGestureListener(8, 4, true, motionEvent.getX(0), motionEvent2.getY(0), 1.0f, 1.0f, 0.0f, f6, f7);
                this.mCheckForSwipe = false;
            }
        }
        return true;
    }

    @Override // android.view.GestureDetector.OnGestureListener
    public void onShowPress(MotionEvent motionEvent) {
    }

    public boolean onTwoFingerTap() {
        int multitouchMode = this.mCompanionView.getMultitouchMode();
        this.mCompanionView.getClass();
        if (multitouchMode == 2) {
            this.mCompanionView.onGestureListener(8, 3, false, (this.mSecondaryPointOfTwoFingerTap.x + this.mPrimaryPointOfTwoFingerTap.x) / 2.0f, (this.mSecondaryPointOfTwoFingerTap.y + this.mPrimaryPointOfTwoFingerTap.y) / 2.0f, 1.0f, 1.0f, 0.0f, 0.0f, 0.0f);
            this.mCouldBeTwoFingerTap = 0;
            return true;
        }
        return true;
    }

    @Override // android.view.GestureDetector.OnDoubleTapListener
    public boolean onSingleTapConfirmed(MotionEvent motionEvent) {
        return true;
    }

    @Override // android.view.GestureDetector.OnGestureListener
    public boolean onSingleTapUp(MotionEvent motionEvent) {
        return true;
    }

    @Override // android.view.GestureDetector.OnDoubleTapListener
    public boolean onDoubleTapEvent(MotionEvent motionEvent) {
        return true;
    }

    @Override // android.view.ScaleGestureDetector.OnScaleGestureListener
    public boolean onScaleBegin(ScaleGestureDetector scaleGestureDetector) {
        if (this.mInZoomTransformGesture) {
            endZoomGesture();
            return true;
        }
        return true;
    }

    @Override // android.view.ScaleGestureDetector.OnScaleGestureListener
    public boolean onScale(ScaleGestureDetector scaleGestureDetector) {
        double dAbs;
        double dAbs2;
        float f;
        float f2;
        float fAbs;
        int multitouchMode = this.mCompanionView.getMultitouchMode();
        this.mCompanionView.getClass();
        if (multitouchMode != 2) {
            return true;
        }
        int i = 1;
        float focusX = scaleGestureDetector.getFocusX();
        float focusY = scaleGestureDetector.getFocusY();
        double previousSpan = scaleGestureDetector.getPreviousSpan();
        double dAbs3 = Math.abs(scaleGestureDetector.getCurrentSpan() - previousSpan);
        if (Build.VERSION.SDK_INT < 11) {
            dAbs = 0.0d;
            dAbs2 = 0.0d;
        } else {
            dAbs = Math.abs(scaleGestureDetector.getCurrentSpanX() - scaleGestureDetector.getPreviousSpanX());
            dAbs2 = Math.abs(scaleGestureDetector.getCurrentSpanY() - scaleGestureDetector.getPreviousSpanY());
        }
        if (previousSpan != 0.0d) {
            if (this.mInZoomTransformGesture || (25.399999618530273d * dAbs3) / screenPPI > 8.0d) {
                if (!this.mInZoomTransformGesture) {
                    this.mInZoomTransformGesture = true;
                    i = 2;
                    this.mDidOccurTwoFingerGesture = true;
                }
                int i2 = i;
                if (Build.VERSION.SDK_INT >= 11) {
                    if (scaleGestureDetector.getPreviousSpanX() == 0.0f || scaleGestureDetector.getCurrentSpanX() == 0.0f || (!this.mInZoomTransformGestureX && (25.399999618530273d * dAbs) / screenPPI <= 3.0d)) {
                        fAbs = 1.0f;
                    } else {
                        fAbs = Math.abs(scaleGestureDetector.getCurrentSpanX() / scaleGestureDetector.getPreviousSpanX());
                        this.mInZoomTransformGestureX = true;
                    }
                    if (scaleGestureDetector.getPreviousSpanY() == 0.0f || scaleGestureDetector.getCurrentSpanY() == 0.0f || (!this.mInZoomTransformGestureY && (25.399999618530273d * dAbs2) / screenPPI <= 3.0d)) {
                        f = 1.0f;
                        f2 = fAbs;
                    } else {
                        float fAbs2 = Math.abs(scaleGestureDetector.getCurrentSpanY() / scaleGestureDetector.getPreviousSpanY());
                        this.mInZoomTransformGestureY = true;
                        f = fAbs2;
                        f2 = fAbs;
                    }
                } else {
                    float scaleFactor = scaleGestureDetector.getScaleFactor();
                    f = scaleFactor;
                    f2 = scaleFactor;
                }
                this.mPreviousZoomLocX = focusX;
                this.mPreviousZoomLocY = focusY;
                this.mCompanionView.onGestureListener(i2, 0, true, focusX, focusY, f2, f, 0.0f, 0.0f, 0.0f);
                return true;
            }
            return false;
        }
        return false;
    }

    @Override // android.view.ScaleGestureDetector.OnScaleGestureListener
    public void onScaleEnd(ScaleGestureDetector scaleGestureDetector) {
        int multitouchMode = this.mCompanionView.getMultitouchMode();
        this.mCompanionView.getClass();
        if (multitouchMode == 2 && this.mInZoomTransformGesture) {
            float scaleFactor = scaleGestureDetector.getScaleFactor();
            this.mCompanionView.onGestureListener(4, 0, true, this.mPreviousZoomLocX, this.mPreviousZoomLocY, scaleFactor, scaleFactor, 0.0f, 0.0f, 0.0f);
        }
    }

    private float getRotation(TouchPoint touchPoint, TouchPoint touchPoint2, TouchPoint touchPoint3, TouchPoint touchPoint4) {
        if (touchPoint.pid == touchPoint3.pid && touchPoint2.pid == touchPoint4.pid) {
            return (float) (((Math.atan2(touchPoint4.y - touchPoint3.y, touchPoint4.x - touchPoint3.x) * 180.0d) / 3.141592653589793d) - ((Math.atan2(touchPoint2.y - touchPoint.y, touchPoint2.x - touchPoint.x) * 180.0d) / 3.141592653589793d));
        }
        return 0.0f;
    }

    private boolean isPanGesture(TouchPoint touchPoint, TouchPoint touchPoint2, TouchPoint touchPoint3, TouchPoint touchPoint4) {
        float f = touchPoint3.x - touchPoint.x;
        float f2 = touchPoint3.y - touchPoint.y;
        float f3 = touchPoint4.x - touchPoint2.x;
        float f4 = touchPoint4.y - touchPoint2.y;
        float fMin = Math.min(Math.abs(f), Math.abs(f3));
        float fMin2 = Math.min(Math.abs(f2), Math.abs(f4));
        return ((f >= 0.0f && f3 >= 0.0f) || (f <= 0.0f && f3 <= 0.0f)) && ((f2 >= 0.0f && f4 >= 0.0f) || (f2 <= 0.0f && f4 <= 0.0f)) && (this.mInPanTransformGesture || Math.sqrt((double) ((fMin * fMin) + (fMin2 * fMin2))) > ((double) ((3.0f * ((float) screenPPI)) / MM_PER_INCH)));
    }

    @Override // android.view.GestureDetector.OnDoubleTapListener
    public boolean onDoubleTap(MotionEvent motionEvent) {
        return false;
    }
}
