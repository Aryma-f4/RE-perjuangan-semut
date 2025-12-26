package com.adobe.air.wand.view;

import android.content.Context;
import android.graphics.Rect;
import android.util.AttributeSet;
import android.view.GestureDetector;
import android.view.KeyEvent;
import android.view.ScaleGestureDetector;
import android.view.View;

/* loaded from: classes.dex */
public class CompanionView extends View {
    private static final String LOG_TAG = "CompanionView";
    static final int POST_TOUCH_MESSAGE_AFTER_DELAY = 0;
    public static final int kTouchActionBegin = 2;
    public static final int kTouchActionEnd = 4;
    public static final int kTouchActionMove = 1;
    public static final int kTouchMetaStateIsEraser = 67108864;
    public static final int kTouchMetaStateIsPen = 33554432;
    public static final int kTouchMetaStateMask = 234881024;
    public static final int kTouchMetaStateSideButton1 = 134217728;
    public final int kMultitouchGesture;
    public final int kMultitouchNone;
    public final int kMultitouchRaw;
    private int mBoundHeight;
    private int mBoundWidth;
    private int mCurrentOrientation;
    private GestureDetector mGestureDetector;
    private GestureListener mGestureListener;
    private boolean mIsFullScreen;
    private int mMultitouchMode;
    private ScaleGestureDetector mScaleGestureDetector;
    private int mSkipHeightFromTop;
    private TouchSensor mTouchSensor;
    private int mVisibleBoundHeight;
    private int mVisibleBoundWidth;

    public CompanionView(Context context) {
        super(context);
        this.kMultitouchNone = 0;
        this.kMultitouchRaw = 1;
        this.kMultitouchGesture = 2;
        this.mSkipHeightFromTop = 0;
        this.mBoundHeight = 0;
        this.mBoundWidth = 0;
        this.mVisibleBoundWidth = 0;
        this.mVisibleBoundHeight = 0;
        this.mMultitouchMode = 2;
        this.mCurrentOrientation = 0;
        this.mIsFullScreen = false;
        this.mTouchSensor = null;
        initView(context);
    }

    public CompanionView(Context context, AttributeSet attributeSet) {
        super(context, attributeSet);
        this.kMultitouchNone = 0;
        this.kMultitouchRaw = 1;
        this.kMultitouchGesture = 2;
        this.mSkipHeightFromTop = 0;
        this.mBoundHeight = 0;
        this.mBoundWidth = 0;
        this.mVisibleBoundWidth = 0;
        this.mVisibleBoundHeight = 0;
        this.mMultitouchMode = 2;
        this.mCurrentOrientation = 0;
        this.mIsFullScreen = false;
        this.mTouchSensor = null;
        initView(context);
    }

    private void initView(Context context) {
        this.mTouchSensor = new TouchSensor();
        this.mGestureListener = new GestureListener(context, this);
        this.mGestureDetector = new GestureDetector(context, this.mGestureListener, null, false);
        this.mScaleGestureDetector = new ScaleGestureDetector(context, this.mGestureListener);
        setWillNotDraw(false);
        setClickable(true);
        setEnabled(true);
        setFocusable(true);
        setFocusableInTouchMode(true);
    }

    public View returnThis() {
        return this;
    }

    @Override // android.view.View
    public void onWindowFocusChanged(boolean z) {
    }

    @Override // android.view.View, android.view.KeyEvent.Callback
    public boolean onKeyDown(int i, KeyEvent keyEvent) {
        return false;
    }

    @Override // android.view.View, android.view.KeyEvent.Callback
    public boolean onKeyUp(int i, KeyEvent keyEvent) {
        return false;
    }

    @Override // android.view.View
    protected void onFocusChanged(boolean z, int i, Rect rect) {
        super.onFocusChanged(z, i, rect);
    }

    /* JADX WARN: Can't fix incorrect switch cases order, some code will duplicate */
    /* JADX WARN: Removed duplicated region for block: B:101:0x0271  */
    /* JADX WARN: Removed duplicated region for block: B:103:0x027c A[PHI: r10
  0x027c: PHI (r10v1 int) = (r10v0 int), (r10v13 int) binds: [B:22:0x00cd, B:27:0x00e7] A[DONT_GENERATE, DONT_INLINE]] */
    /* JADX WARN: Removed duplicated region for block: B:66:0x01ca  */
    /* JADX WARN: Removed duplicated region for block: B:94:0x0264  */
    @Override // android.view.View
    /*
        Code decompiled incorrectly, please refer to instructions dump.
        To view partially-correct code enable 'Show inconsistent code' option in preferences
    */
    public boolean onTouchEvent(android.view.MotionEvent r24) {
        /*
            Method dump skipped, instructions count: 666
            To view this dump change 'Code comments level' option to 'DEBUG'
        */
        throw new UnsupportedOperationException("Method not decompiled: com.adobe.air.wand.view.CompanionView.onTouchEvent(android.view.MotionEvent):boolean");
    }

    public void onGestureListener(int i, int i2, boolean z, float f, float f2, float f3, float f4, float f5, float f6, float f7) {
        this.mTouchSensor.dispatchEvent(new GestureEventData(i, i2, z, f, f2, f3, f4, f5, f6, f7));
    }

    public TouchSensor getTouchSensor() {
        return this.mTouchSensor;
    }

    @Override // android.view.View
    protected void onSizeChanged(int i, int i2, int i3, int i4) {
        super.onSizeChanged(i, i2, i3, i4);
    }

    public void setMultitouchMode(int i) {
        this.mMultitouchMode = i;
    }

    public int getMultitouchMode() {
        return this.mMultitouchMode;
    }

    public boolean getIsFullScreen() {
        return this.mIsFullScreen;
    }

    public int getBoundWidth() {
        return this.mBoundWidth;
    }

    public int getBoundHeight() {
        return this.mBoundHeight;
    }

    public int getVisibleBoundWidth() {
        return this.mVisibleBoundWidth;
    }

    public int getVisibleBoundHeight() {
        return this.mVisibleBoundHeight;
    }

    public boolean IsLandScape() {
        return this.mCurrentOrientation == 2;
    }

    private boolean IsTouchEventHandlingAllowed(int i, float f, float f2) {
        return true;
    }

    public boolean IsTouchUpHandlingAllowed() {
        return true;
    }
}
