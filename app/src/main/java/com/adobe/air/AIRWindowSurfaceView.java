package com.adobe.air;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.PixelFormat;
import android.graphics.PorterDuff;
import android.graphics.PorterDuffXfermode;
import android.graphics.Rect;
import android.graphics.Region;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.os.ResultReceiver;
import android.provider.Settings;
import android.support.v4.util.TimeUtils;
import android.support.v4.view.ViewCompat;
import android.text.ClipboardManager;
import android.text.util.Linkify;
import android.view.ContextMenu;
import android.view.Display;
import android.view.GestureDetector;
import android.view.KeyEvent;
import android.view.MenuItem;
import android.view.MotionEvent;
import android.view.ScaleGestureDetector;
import android.view.SurfaceHolder;
import android.view.SurfaceView;
import android.view.View;
import android.view.ViewConfiguration;
import android.view.Window;
import android.view.WindowManager;
import android.view.inputmethod.EditorInfo;
import android.view.inputmethod.ExtractedText;
import android.view.inputmethod.InputConnection;
import android.view.inputmethod.InputMethodManager;
import android.widget.RelativeLayout;
import android.widget.TextView;
import com.adobe.air.AndroidLocale;
import com.adobe.air.gestures.AIRGestureListener;
import com.adobe.air.utils.AIRLogger;
import com.adobe.air.utils.Utils;
import com.adobe.flashruntime.air.VideoViewAIR;
import com.adobe.flashruntime.shared.VideoView;

/* loaded from: classes.dex */
public class AIRWindowSurfaceView extends SurfaceView implements SurfaceHolder.Callback {
    static final int CURSOR_POS_END_DOCUMENT = 3;
    static final int CURSOR_POS_END_LINE = 1;
    static final int CURSOR_POS_START_DOCUMENT = 2;
    static final int CURSOR_POS_START_LINE = 0;
    static final int ID_COPY = 3;
    static final int ID_COPY_ALL = 4;
    static final int ID_CUT = 1;
    static final int ID_CUT_ALL = 2;
    static final int ID_PASTE = 5;
    static final int ID_SELECT_ALL = 0;
    static final int ID_START_SELECTING = 7;
    static final int ID_STOP_SELECTING = 8;
    static final int ID_SWITCH_INPUT_METHOD = 6;
    private static final String LOG_TAG = "AIRWindowSurfaceView";
    static final int LONG_PRESS_DELAY = 500;
    static final int MAX_MOVE_ACTION_ALLOWED = 4;
    static final int POST_TOUCH_MESSAGE_AFTER_DELAY = 0;
    private static final int kDefaultBitsPerPixel = 32;
    private static final int kMotionEventButtonSecondary = 2;
    private static final int kMotionEventToolTypeEraser = 4;
    private static final int kMotionEventToolTypeStylus = 2;
    private static final int kTouchActionBegin = 2;
    private static final int kTouchActionEnd = 4;
    private static final int kTouchActionHoverBegin = 16;
    private static final int kTouchActionHoverEnd = 32;
    private static final int kTouchActionHoverMove = 8;
    private static final int kTouchActionMove = 1;
    private static final int kTouchMetaStateIsEraser = 67108864;
    private static final int kTouchMetaStateIsPen = 33554432;
    private static final int kTouchMetaStateMask = 234881024;
    private static final int kTouchMetaStateSideButton1 = 134217728;
    private boolean inTouch;
    public final int kMultitouchGesture;
    public final int kMultitouchNone;
    public final int kMultitouchRaw;
    private final float kSampleSize;
    private AndroidActivityWrapper mActivityWrapper;
    private int mBoundHeight;
    private int mBoundWidth;
    private boolean mContextMenuVisible;
    private int mCurrentOrientation;
    private int mCurrentSurfaceFormat;
    private boolean mDispatchUserTriggeredSkDeactivate;
    private float mDownX;
    private float mDownY;
    private boolean mEatTouchRelease;
    protected FlashEGL mFlashEGL;
    private AndroidStageText mFocusedStageText;
    private AndroidWebView mFocusedWebView;
    private GestureDetector mGestureDetector;
    private AIRGestureListener mGestureListener;
    private boolean mHideSoftKeyboardOnWindowFocusChange;
    private boolean mHoverInProgress;
    private int mHoverMetaState;
    private HoverTimeoutHandler mHoverTimeoutHandler;
    private int mHt;
    private AndroidInputConnection mInputConnection;
    InputMethodReceiver mInputMethodReceiver;
    private boolean mIsFullScreen;
    private float mLastTouchedXCoord;
    private float mLastTouchedYCoord;
    private CheckLongPress mLongPressCheck;
    private boolean mMaliWorkaround;
    private MetaKeyState mMetaAltState;
    private MetaKeyState mMetaShiftState;
    private int mMultitouchMode;
    private boolean mNeedsCompositingSurface;
    private Paint mPaint;
    private Paint mPaintScaled;
    private AndroidStageText mResizedStageText;
    private AndroidWebView mResizedWebView;
    private ScaleGestureDetector mScaleGestureDetector;
    private int mScaledTouchSlop;
    private int mSkipHeightFromTop;
    private boolean mSurfaceChangedForSoftKeyboard;
    protected SurfaceHolder mSurfaceHolder;
    private boolean mSurfaceValid;
    private Rect mTextBoxBounds;
    private boolean mTrackBallPressed;
    private VideoView mVideoView;
    private int mVisibleBoundHeight;
    private int mVisibleBoundWidth;
    private int mWd;
    private boolean mWindowHasFocus;

    private enum MetaKeyState {
        INACTIVE,
        ACTIVE,
        PRESSED,
        LOCKED
    }

    private native void nativeCutText(boolean z);

    private native void nativeDeleteTextLine();

    /* JADX INFO: Access modifiers changed from: private */
    public native void nativeDispatchFullScreenEvent(boolean z);

    private native void nativeDispatchSelectionChangeEvent(boolean z);

    private native void nativeForceReDraw();

    private native int nativeGetMultitouchMode();

    private native String nativeGetSelectedText();

    private native Rect nativeGetTextBoxBounds();

    private native void nativeInsertText(String str);

    private native boolean nativeIsEditable();

    private native boolean nativeIsFullScreenInteractive();

    private native boolean nativeIsMultiLineTextField();

    private native boolean nativeIsPasswordField();

    private native boolean nativeIsTextFieldInSelectionMode();

    private native boolean nativeIsTextFieldSelectable();

    private native void nativeMoveCursor(int i);

    private native void nativeOnFormatChangeListener(int i);

    private native void nativeOnSizeChangedListener(int i, int i2, boolean z);

    private native boolean nativePerformWindowPanning(int i, int i2);

    private native void nativeSelectAllText();

    /* JADX INFO: Access modifiers changed from: private */
    public native void nativeSetKeyboardVisible(boolean z);

    private native void nativeSurfaceCreated();

    public native void nativeDispatchUserTriggeredSkDeactivateEvent();

    public native ExtractedText nativeGetTextContent();

    public native int nativeGetTextContentLength();

    public native boolean nativeIsTextSelected();

    public native boolean nativeOnDoubleClickListener(float f, float f2);

    public native boolean nativeOnKeyListener(int i, int i2, int i3, boolean z, boolean z2, boolean z3);

    public native void nativeShowOriginalRect();

    class HoverTimeoutHandler extends Handler {
        static final int INTERVAL = 500;
        private AIRWindowSurfaceView mAIRWindowSurfaceView;
        private long mLastMove;

        public HoverTimeoutHandler(AIRWindowSurfaceView aIRWindowSurfaceView) {
            this.mAIRWindowSurfaceView = aIRWindowSurfaceView;
        }

        @Override // android.os.Handler
        public void handleMessage(Message message) {
            if (System.currentTimeMillis() - this.mLastMove >= 500) {
                AIRWindowSurfaceView.this.mHoverInProgress = false;
                Entrypoints.registerTouchCallback(0, new TouchEventData(32, this.mAIRWindowSurfaceView.mLastTouchedXCoord, this.mAIRWindowSurfaceView.mLastTouchedYCoord, 0.0f, 0, 0.0f, 0.0f, true, null, this.mAIRWindowSurfaceView.mHoverMetaState), null);
            } else {
                AIRWindowSurfaceView.this.mHoverTimeoutHandler.sendEmptyMessageDelayed(0, 500L);
            }
        }

        public void setLastMove(long j) {
            this.mLastMove = j;
        }
    }

    public AIRWindowSurfaceView(Context context, AndroidActivityWrapper androidActivityWrapper) {
        super(context);
        this.kMultitouchNone = 0;
        this.kMultitouchRaw = 1;
        this.kMultitouchGesture = 2;
        this.kSampleSize = 4.0f;
        this.mWd = 0;
        this.mHt = 0;
        this.mSurfaceValid = false;
        this.mSkipHeightFromTop = 0;
        this.mSurfaceHolder = null;
        this.mFlashEGL = null;
        this.mBoundHeight = 0;
        this.mBoundWidth = 0;
        this.mVisibleBoundWidth = 0;
        this.mVisibleBoundHeight = 0;
        this.mMultitouchMode = 0;
        this.mPaint = null;
        this.mPaintScaled = null;
        this.mMaliWorkaround = false;
        this.mHoverInProgress = false;
        this.mHoverMetaState = 0;
        this.mCurrentOrientation = 0;
        this.mEatTouchRelease = false;
        this.mContextMenuVisible = false;
        this.mLongPressCheck = null;
        this.mIsFullScreen = false;
        this.mSurfaceChangedForSoftKeyboard = false;
        this.mDispatchUserTriggeredSkDeactivate = true;
        this.mHideSoftKeyboardOnWindowFocusChange = false;
        this.mTrackBallPressed = false;
        this.mWindowHasFocus = true;
        this.mNeedsCompositingSurface = false;
        this.mCurrentSurfaceFormat = -1;
        this.mFocusedWebView = null;
        this.mResizedWebView = null;
        this.mFocusedStageText = null;
        this.mResizedStageText = null;
        this.inTouch = false;
        this.mMetaShiftState = MetaKeyState.INACTIVE;
        this.mMetaAltState = MetaKeyState.INACTIVE;
        this.mHoverTimeoutHandler = new HoverTimeoutHandler(this);
        this.mInputMethodReceiver = new InputMethodReceiver();
        this.mSurfaceHolder = getHolder();
        this.mActivityWrapper = androidActivityWrapper;
        setSurfaceFormat(false);
        this.mGestureListener = new AIRGestureListener(context, this);
        this.mGestureDetector = new GestureDetector(context, this.mGestureListener, null, false);
        this.mScaleGestureDetector = new ScaleGestureDetector(context, this.mGestureListener);
        setWillNotDraw(false);
        setClickable(true);
        setEnabled(true);
        setFocusable(true);
        setFocusableInTouchMode(true);
        this.mScaledTouchSlop = ViewConfiguration.get(context).getScaledTouchSlop();
        this.mSurfaceHolder.addCallback(this);
        setZOrderMediaOverlay(true);
        this.mActivityWrapper.registerPlane(this, 3);
    }

    public AndroidActivityWrapper getActivityWrapper() {
        return this.mActivityWrapper;
    }

    public View returnThis() {
        return this;
    }

    @Override // android.view.View
    public void onWindowFocusChanged(boolean z) {
        this.mWindowHasFocus = z;
        if (this.mLongPressCheck != null) {
            removeCallbacks(this.mLongPressCheck);
        }
        if (this.mHideSoftKeyboardOnWindowFocusChange) {
            InputMethodManager inputMethodManager = getInputMethodManager();
            if (inputMethodManager != null) {
                inputMethodManager.hideSoftInputFromWindow(getWindowToken(), 0);
            }
            this.mHideSoftKeyboardOnWindowFocusChange = false;
        }
        if (z) {
            this.mContextMenuVisible = false;
        }
    }

    @Override // android.view.View, android.view.KeyEvent.Callback
    public boolean onKeyDown(int i, KeyEvent keyEvent) {
        if (AllowOSToHandleKeys(i)) {
            return false;
        }
        int iGetMetaKeyCharacter = (this.mMetaShiftState == MetaKeyState.ACTIVE || this.mMetaShiftState == MetaKeyState.LOCKED || this.mMetaAltState == MetaKeyState.ACTIVE || this.mMetaAltState == MetaKeyState.LOCKED) ? GetMetaKeyCharacter(keyEvent) : keyEvent.getUnicodeChar();
        HandleMetaKeyAction(keyEvent);
        if (!this.mTrackBallPressed && this.mLongPressCheck != null) {
            removeCallbacks(this.mLongPressCheck);
        }
        if (!this.mActivityWrapper.isApplicationLaunched() || HandleShortCuts(i, keyEvent)) {
            return false;
        }
        boolean zNativeOnKeyListener = nativeOnKeyListener(keyEvent.getAction(), i, iGetMetaKeyCharacter, keyEvent.isAltPressed(), keyEvent.isShiftPressed(), keyEvent.isSymPressed());
        if (this.mInputConnection != null) {
            this.mInputConnection.updateIMEText();
            return zNativeOnKeyListener;
        }
        return zNativeOnKeyListener;
    }

    @Override // android.view.View, android.view.KeyEvent.Callback
    public boolean onKeyUp(int i, KeyEvent keyEvent) {
        if (AllowOSToHandleKeys(i)) {
            return false;
        }
        int iGetMetaKeyCharacter = (this.mMetaShiftState == MetaKeyState.ACTIVE || this.mMetaShiftState == MetaKeyState.LOCKED || this.mMetaAltState == MetaKeyState.ACTIVE || this.mMetaAltState == MetaKeyState.LOCKED) ? GetMetaKeyCharacter(keyEvent) : keyEvent.getUnicodeChar();
        if (this.mLongPressCheck != null) {
            removeCallbacks(this.mLongPressCheck);
        }
        if (i == 23) {
            this.mTrackBallPressed = false;
        }
        if (!this.mActivityWrapper.isApplicationLaunched()) {
            return false;
        }
        boolean zNativeOnKeyListener = nativeOnKeyListener(keyEvent.getAction(), i, iGetMetaKeyCharacter, keyEvent.isAltPressed(), keyEvent.isShiftPressed(), keyEvent.isSymPressed());
        if (this.mInputConnection != null) {
            this.mInputConnection.updateIMEText();
        }
        if (!zNativeOnKeyListener && keyEvent.getKeyCode() == 4 && keyEvent.isTracking() && !keyEvent.isCanceled()) {
            this.mActivityWrapper.getActivity().moveTaskToBack(false);
            return true;
        }
        return zNativeOnKeyListener;
    }

    @Override // android.view.View
    public boolean onGenericMotionEvent(MotionEvent motionEvent) {
        if (motionEvent.getAction() == 9 || motionEvent.getAction() == 10 || motionEvent.getAction() == 7) {
            return onTouchEvent(motionEvent);
        }
        return false;
    }

    @Override // android.view.SurfaceView, android.view.View
    protected void onFocusChanged(boolean z, int i, Rect rect) {
        AIRLogger.d(LOG_TAG, "*** *** onFocusChanged: AIR");
        if (z && this.mFocusedStageText != null && !this.inTouch) {
            this.mDispatchUserTriggeredSkDeactivate = true;
            forceSoftKeyboardDown();
        }
        super.onFocusChanged(z, i, rect);
    }

    /* JADX WARN: Can't fix incorrect switch cases order, some code will duplicate */
    /* JADX WARN: Removed duplicated region for block: B:131:0x0339  */
    /* JADX WARN: Removed duplicated region for block: B:135:0x033f A[PHI: r17
  0x033f: PHI (r17v2 boolean) = (r17v1 boolean), (r17v4 boolean), (r17v4 boolean) binds: [B:49:0x0150, B:100:0x02c5, B:102:0x02cb] A[DONT_GENERATE, DONT_INLINE]] */
    /* JADX WARN: Removed duplicated region for block: B:136:0x0342  */
    @Override // android.view.View
    /*
        Code decompiled incorrectly, please refer to instructions dump.
        To view partially-correct code enable 'Show inconsistent code' option in preferences
    */
    public boolean onTouchEvent(android.view.MotionEvent r25) {
        /*
            Method dump skipped, instructions count: 892
            To view this dump change 'Code comments level' option to 'DEBUG'
        */
        throw new UnsupportedOperationException("Method not decompiled: com.adobe.air.AIRWindowSurfaceView.onTouchEvent(android.view.MotionEvent):boolean");
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

    @Override // android.view.SurfaceHolder.Callback
    public void surfaceCreated(SurfaceHolder surfaceHolder) {
        this.mActivityWrapper.planeStepCascade();
        if (this.mIsFullScreen) {
            setFullScreen();
        }
        if (this.mActivityWrapper.isStarted() || this.mActivityWrapper.isResumed() || (Build.MANUFACTURER.equalsIgnoreCase("SAMSUNG") && Build.MODEL.equalsIgnoreCase("GT-I9300"))) {
            nativeSurfaceCreated();
        }
    }

    @Override // android.view.SurfaceHolder.Callback
    public void surfaceChanged(SurfaceHolder surfaceHolder, int i, int i2, int i3) {
        Display defaultDisplay = ((WindowManager) this.mActivityWrapper.getActivity().getSystemService("window")).getDefaultDisplay();
        this.mBoundHeight = defaultDisplay.getHeight();
        this.mBoundWidth = defaultDisplay.getWidth();
        this.mVisibleBoundHeight = i3;
        this.mVisibleBoundWidth = i2;
        nativeOnFormatChangeListener(i);
        if (!this.mSurfaceValid) {
            this.mSurfaceValid = true;
            this.mActivityWrapper.onSurfaceInitialized();
            setMultitouchMode(nativeGetMultitouchMode());
        }
        if (this.mSurfaceValid) {
            int i4 = getResources().getConfiguration().orientation;
            if (i4 == this.mCurrentOrientation) {
                if ((i4 == 1 || i4 == 2) && i3 < this.mHt) {
                    if (i3 != 0) {
                        if (nativePerformWindowPanning(i4, this.mHt - i3)) {
                            this.mSurfaceChangedForSoftKeyboard = true;
                            return;
                        }
                    } else {
                        return;
                    }
                }
            } else {
                showSoftKeyboard(false);
                nativeDispatchUserTriggeredSkDeactivateEvent();
                this.mDispatchUserTriggeredSkDeactivate = false;
            }
            boolean z = this.mCurrentOrientation != i4;
            this.mCurrentOrientation = i4;
            this.mWd = i2;
            this.mHt = i3;
            nativeOnSizeChangedListener(this.mWd, this.mHt, z);
            OrientationManager orientationManager = OrientationManager.getOrientationManager();
            if (orientationManager.mDispatchOrientationChangePending) {
                orientationManager.nativeOrientationChanged(orientationManager.mBeforeOrientation, orientationManager.mAfterOrientation);
                orientationManager.mDispatchOrientationChangePending = false;
            }
            nativeForceReDraw();
            forceSoftKeyboardDown();
        }
    }

    public void forceSoftKeyboardDown() {
        nativeShowOriginalRect();
        setScrollTo(0);
        if (this.mDispatchUserTriggeredSkDeactivate && this.mSurfaceChangedForSoftKeyboard) {
            nativeDispatchUserTriggeredSkDeactivateEvent();
        }
        nativeSetKeyboardVisible(false);
        this.mDispatchUserTriggeredSkDeactivate = true;
        this.mSurfaceChangedForSoftKeyboard = false;
    }

    public boolean isSurfaceValid() {
        return this.mSurfaceValid;
    }

    @Override // android.view.SurfaceHolder.Callback
    public void surfaceDestroyed(SurfaceHolder surfaceHolder) {
        this.mSurfaceValid = false;
        if (this.mFlashEGL != null) {
            this.mFlashEGL.DestroyWindowSurface();
        }
        this.mActivityWrapper.onSurfaceDestroyed();
        this.mActivityWrapper.planeBreakCascade();
    }

    class InputMethodReceiver extends ResultReceiver {
        public InputMethodReceiver() {
            super(AIRWindowSurfaceView.this.getHandler());
        }

        @Override // android.os.ResultReceiver
        protected void onReceiveResult(int i, Bundle bundle) {
            if (i != 1 && i != 3) {
                AIRWindowSurfaceView.this.nativeSetKeyboardVisible(true);
            } else {
                AIRWindowSurfaceView.this.nativeShowOriginalRect();
            }
        }
    }

    public void showSoftKeyboard(boolean z, View view) {
        AIRLogger.d(LOG_TAG, "showSoftKeyboard show: " + z);
        InputMethodManager inputMethodManager = getInputMethodManager();
        if (!z) {
            if (this.mSurfaceChangedForSoftKeyboard) {
                this.mDispatchUserTriggeredSkDeactivate = false;
            }
            inputMethodManager.hideSoftInputFromWindow(getWindowToken(), 0);
            if (this.mInputConnection != null) {
                this.mInputConnection.Reset();
            }
            nativeSetKeyboardVisible(false);
            return;
        }
        inputMethodManager.showSoftInput(view, 0, this.mInputMethodReceiver);
    }

    public void showSoftKeyboard(boolean z) {
        showSoftKeyboard(z, this);
    }

    public void updateFocusedStageWebView(AndroidWebView androidWebView, boolean z) {
        if (z) {
            this.mFocusedWebView = androidWebView;
        } else if (this.mFocusedWebView == androidWebView) {
            this.mFocusedWebView = null;
        }
    }

    public boolean isStageWebViewInFocus() {
        if (this.mFocusedWebView != null) {
            return this.mFocusedWebView.isInTextEditingMode();
        }
        return false;
    }

    public long panStageWebViewInFocus() {
        if (this.mFocusedWebView == null) {
            return 0L;
        }
        this.mResizedWebView = this.mFocusedWebView;
        return this.mFocusedWebView.updateViewBoundsWithKeyboard(this.mHt);
    }

    public void updateFocusedStageText(AndroidStageText androidStageText, boolean z) {
        if (z) {
            this.mFocusedStageText = androidStageText;
        } else if (this.mFocusedStageText == androidStageText) {
            this.mFocusedStageText = null;
        }
    }

    public boolean isStageTextInFocus() {
        return this.mFocusedStageText != null;
    }

    public long panStageTextInFocus() {
        if (this.mFocusedStageText == null) {
            return 0L;
        }
        this.mResizedStageText = this.mFocusedStageText;
        return this.mFocusedStageText.updateViewBoundsWithKeyboard(this.mHt);
    }

    private boolean IsIMEInFullScreen() {
        return getInputMethodManager().isFullscreenMode();
    }

    public boolean setScrollTo(final int i) {
        this.mSkipHeightFromTop = i;
        final RelativeLayout overlaysLayout = this.mActivityWrapper.getOverlaysLayout(false);
        if (overlaysLayout != null) {
            post(new Runnable() { // from class: com.adobe.air.AIRWindowSurfaceView.1
                @Override // java.lang.Runnable
                public void run() {
                    if (i == 0 && AIRWindowSurfaceView.this.mResizedWebView != null) {
                        AIRWindowSurfaceView.this.mResizedWebView.resetGlobalBounds();
                        AIRWindowSurfaceView.this.mResizedWebView = null;
                    }
                    if (i == 0 && AIRWindowSurfaceView.this.mResizedStageText != null) {
                        AIRWindowSurfaceView.this.mResizedStageText.resetGlobalBounds();
                        AIRWindowSurfaceView.this.mResizedStageText = null;
                    }
                    overlaysLayout.setPadding(0, -i, 0, 0);
                    overlaysLayout.requestLayout();
                }
            });
            return true;
        }
        return true;
    }

    private void setSurfaceFormatImpl(boolean z, final int i) {
        if (z) {
            post(new Runnable() { // from class: com.adobe.air.AIRWindowSurfaceView.2
                @Override // java.lang.Runnable
                public void run() {
                    AIRWindowSurfaceView.this.mSurfaceHolder.setFormat(i);
                    AIRWindowSurfaceView.this.mCurrentSurfaceFormat = i;
                }
            });
        } else {
            this.mSurfaceHolder.setFormat(i);
            this.mCurrentSurfaceFormat = i;
        }
    }

    public void setSurfaceFormat(boolean z) {
        if (!this.mActivityWrapper.useRGB565()) {
            if (!this.mNeedsCompositingSurface && !this.mActivityWrapper.needsCompositingSurface()) {
                AndroidActivityWrapper androidActivityWrapper = this.mActivityWrapper;
                if (AndroidActivityWrapper.isGingerbread()) {
                    setSurfaceFormatImpl(z, 2);
                    return;
                }
            }
            setSurfaceFormatImpl(z, 1);
            return;
        }
        if (this.mNeedsCompositingSurface) {
            setSurfaceFormatImpl(z, 1);
        } else {
            setSurfaceFormatImpl(z, 4);
        }
    }

    public void setCompositingHint(boolean z) {
        this.mNeedsCompositingSurface = z;
        if (z && this.mCurrentSurfaceFormat == 1) {
            return;
        }
        if (z || this.mCurrentSurfaceFormat != 2) {
            setSurfaceFormat(true);
        }
    }

    protected void draw(int i, int i2, int i3, int i4, Bitmap bitmap) {
        Rect rect;
        Canvas canvasLockCanvas;
        if (this.mSurfaceValid) {
            Rect rect2 = new Rect(i, i2, i + i3, i2 + i4);
            int i5 = this.mSkipHeightFromTop;
            if (i5 != 0) {
                Rect rect3 = new Rect(0, i5, this.mWd, this.mHt);
                if (Rect.intersects(rect2, rect3)) {
                    Rect rect4 = new Rect(rect2);
                    rect4.intersect(rect3);
                    rect4.top -= i5;
                    rect4.bottom -= i5;
                    if (this.mIsFullScreen) {
                        rect4.union(new Rect(0, rect4.bottom, this.mWd, this.mHt));
                    }
                    canvasLockCanvas = this.mSurfaceHolder.lockCanvas(rect4);
                    if (!this.mIsFullScreen && rect4.bottom > this.mHt - i5) {
                        rect4.bottom = this.mHt - i5;
                    }
                    rect = rect4;
                } else {
                    return;
                }
            } else {
                rect = rect2;
                canvasLockCanvas = this.mSurfaceHolder.lockCanvas(rect2);
            }
            try {
                synchronized (this.mSurfaceHolder) {
                    canvasLockCanvas.clipRect(rect);
                    if (i5 != 0 && this.mIsFullScreen) {
                        canvasLockCanvas.drawColor(ViewCompat.MEASURED_STATE_MASK);
                    }
                    if (this.mMaliWorkaround) {
                        this.mPaint = null;
                        canvasLockCanvas.drawColor(0, PorterDuff.Mode.CLEAR);
                    } else if (this.mPaint == null && this.mCurrentSurfaceFormat != 4) {
                        this.mPaint = new Paint();
                        this.mPaint.setXfermode(new PorterDuffXfermode(PorterDuff.Mode.SRC));
                        this.mPaint.setFilterBitmap(false);
                    }
                    canvasLockCanvas.drawBitmap(bitmap, 0.0f, -i5, this.mPaint);
                }
                if (canvasLockCanvas != null) {
                    this.mSurfaceHolder.unlockCanvasAndPost(canvasLockCanvas);
                }
            } catch (Exception e) {
                if (canvasLockCanvas != null) {
                    this.mSurfaceHolder.unlockCanvasAndPost(canvasLockCanvas);
                }
            } catch (Throwable th) {
                if (canvasLockCanvas != null) {
                    this.mSurfaceHolder.unlockCanvasAndPost(canvasLockCanvas);
                }
                throw th;
            }
            if (this.mInputConnection != null) {
                this.mInputConnection.updateIMEText();
            }
        }
    }

    protected void drawScaled(int i, int i2, int i3, int i4, Bitmap bitmap, int i5, int i6, int i7, int i8, boolean z, int i9) throws Throwable {
        Canvas canvas;
        Throwable th;
        Rect rect;
        Rect rect2;
        Rect rect3;
        Canvas canvasLockCanvas;
        if (this.mSurfaceValid) {
            try {
                try {
                    Rect rect4 = new Rect(i5, i6, i5 + i7, i6 + i8);
                    Rect rect5 = z ? new Rect(0, 0, this.mWd, this.mHt) : new Rect(i5, i6, i5 + i7, i6 + i8);
                    if (this.mSkipHeightFromTop != 0) {
                        int i10 = this.mSkipHeightFromTop;
                        Rect rect6 = new Rect(0, i10, this.mWd, this.mHt);
                        if (!Rect.intersects(rect4, rect6)) {
                            if (0 != 0) {
                                this.mSurfaceHolder.unlockCanvasAndPost(null);
                                return;
                            }
                            return;
                        }
                        Rect rect7 = new Rect(rect4);
                        rect7.intersect(rect6);
                        rect7.top -= i10;
                        rect7.bottom -= i10;
                        rect2 = !z ? rect7 : rect5;
                        if (!z && rect7.bottom > this.mHt - i10) {
                            rect7.bottom = this.mHt - i10;
                        }
                        rect = rect7;
                    } else {
                        Rect rect8 = rect5;
                        rect = rect4;
                        rect2 = rect8;
                    }
                    rect3 = new Rect(i, i2, i + i3, i2 + i4);
                    canvasLockCanvas = this.mSurfaceHolder.lockCanvas(rect2);
                } catch (Exception e) {
                    if (0 != 0) {
                        this.mSurfaceHolder.unlockCanvasAndPost(null);
                    }
                }
            } catch (Throwable th2) {
                canvas = null;
                th = th2;
            }
            try {
                synchronized (this.mSurfaceHolder) {
                    if (z) {
                        canvasLockCanvas.drawRGB(Color.red(i9), Color.green(i9), Color.blue(i9));
                    }
                    if (this.mMaliWorkaround) {
                        this.mPaint = null;
                        canvasLockCanvas.drawColor(0, PorterDuff.Mode.CLEAR);
                    } else if (this.mPaintScaled == null && this.mCurrentSurfaceFormat != 4) {
                        this.mPaintScaled = new Paint();
                        this.mPaintScaled.setXfermode(new PorterDuffXfermode(PorterDuff.Mode.SRC));
                    }
                    canvasLockCanvas.drawBitmap(bitmap, rect3, rect, this.mPaintScaled);
                }
                if (canvasLockCanvas != null) {
                    this.mSurfaceHolder.unlockCanvasAndPost(canvasLockCanvas);
                }
                if (this.mInputConnection != null) {
                    this.mInputConnection.updateIMEText();
                }
            } catch (Throwable th3) {
                canvas = canvasLockCanvas;
                th = th3;
                if (canvas == null) {
                    throw th;
                }
                this.mSurfaceHolder.unlockCanvasAndPost(canvas);
                throw th;
            }
        }
    }

    public void drawBitmap(int i, int i2, int i3, int i4, Bitmap bitmap) {
        draw(i, i2, i3, i4, bitmap);
    }

    public void drawBitmap(int i, int i2, int i3, int i4, Bitmap bitmap, int i5, int i6, int i7, int i8, boolean z, int i9) throws Throwable {
        drawScaled(i, i2, i3, i4, bitmap, i5, i6, i7, i8, z, i9);
    }

    public boolean getIsFullScreen() {
        return this.mIsFullScreen;
    }

    private static boolean supportsSystemUiVisibilityAPI() {
        return Build.VERSION.SDK_INT >= 11;
    }

    private static boolean supportsSystemUiFlags() {
        return Build.VERSION.SDK_INT >= 14;
    }

    private boolean hasStatusBar(Window window) {
        Rect rect = new Rect();
        window.getDecorView().getWindowVisibleDisplayFrame(rect);
        return rect.top > 0;
    }

    private void DoSetOnSystemUiVisibilityChangeListener() {
        setOnSystemUiVisibilityChangeListener(new View.OnSystemUiVisibilityChangeListener() { // from class: com.adobe.air.AIRWindowSurfaceView.3
            @Override // android.view.View.OnSystemUiVisibilityChangeListener
            public void onSystemUiVisibilityChange(int i) {
                this.setOnSystemUiVisibilityChangeListener(null);
                if (this.getIsFullScreen()) {
                    this.nativeDispatchFullScreenEvent(true);
                } else {
                    this.nativeDispatchFullScreenEvent(false);
                }
            }
        });
    }

    public void setFullScreen() {
        if (!this.mIsFullScreen) {
            this.mIsFullScreen = true;
            this.mActivityWrapper.setIsFullScreen(this.mIsFullScreen);
            if (supportsSystemUiVisibilityAPI()) {
                int i = supportsSystemUiFlags() ? 1 : 1;
                DoSetOnSystemUiVisibilityChangeListener();
                setSystemUiVisibility(i);
            }
            this.mActivityWrapper.planeBreakCascade();
        }
        Activity activity = this.mActivityWrapper.getActivity();
        if (activity != null) {
            Window window = activity.getWindow();
            if (!supportsSystemUiVisibilityAPI() || hasStatusBar(window)) {
                window.setFlags(1024, 1024);
            }
        }
    }

    public void clearFullScreen() {
        this.mIsFullScreen = false;
        this.mActivityWrapper.setIsFullScreen(this.mIsFullScreen);
        if (supportsSystemUiVisibilityAPI()) {
            int i = supportsSystemUiFlags() ? 0 : 0;
            DoSetOnSystemUiVisibilityChangeListener();
            setSystemUiVisibility(i);
        }
        Activity activity = this.mActivityWrapper.getActivity();
        if (activity != null) {
            activity.getWindow().clearFlags(1024);
        }
        this.mActivityWrapper.planeBreakCascade();
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

    public int getColorDepth() {
        if (this.mCurrentSurfaceFormat == 4) {
            return 16;
        }
        Activity activity = this.mActivityWrapper.getActivity();
        if (activity == null) {
            return 32;
        }
        Display defaultDisplay = ((WindowManager) activity.getSystemService("window")).getDefaultDisplay();
        PixelFormat pixelFormat = new PixelFormat();
        PixelFormat.getPixelFormatInfo(defaultDisplay.getPixelFormat(), pixelFormat);
        return pixelFormat.bitsPerPixel;
    }

    public int getAppSpecifiedPixelFormat() {
        return this.mActivityWrapper.useRGB565() ? 16 : 32;
    }

    public void showActionScript2Warning() {
        Activity activity = this.mActivityWrapper.getActivity();
        if (activity != null) {
            AlertDialog.Builder builder = new AlertDialog.Builder(activity);
            TextView textView = new TextView(activity);
            textView.setText("Your application is attempting to run ActionScript2.0, which is not supported on smart phone profile. \nSee the Adobe Developer Connection for more info www.adobe.com/devnet");
            Linkify.addLinks(textView, 1);
            builder.setView(textView);
            builder.setTitle("Action Script 2.0");
            builder.setNeutralButton("OK", new DialogInterface.OnClickListener() { // from class: com.adobe.air.AIRWindowSurfaceView.4
                @Override // android.content.DialogInterface.OnClickListener
                public void onClick(DialogInterface dialogInterface, int i) {
                }
            });
            builder.show();
        }
    }

    public boolean IsLandScape() {
        return this.mCurrentOrientation == 2;
    }

    @Override // android.view.View
    public boolean onCheckIsTextEditor() {
        return true;
    }

    @Override // android.view.View
    public InputConnection onCreateInputConnection(EditorInfo editorInfo) {
        if (this.mActivityWrapper.isApplicationLaunched() && nativeIsEditable()) {
            editorInfo.imeOptions |= 1073741824;
            editorInfo.imeOptions |= 6;
            editorInfo.inputType |= 1;
            if (nativeIsPasswordField()) {
                editorInfo.inputType |= 128;
            }
            if (nativeIsMultiLineTextField()) {
                editorInfo.inputType |= 131072;
            }
            this.mInputConnection = new AndroidInputConnection(this);
            editorInfo.initialSelStart = -1;
            editorInfo.initialSelEnd = -1;
            editorInfo.initialCapsMode = 0;
        } else {
            this.mInputConnection = null;
        }
        return this.mInputConnection;
    }

    public void RestartInput() {
        this.mMetaShiftState = MetaKeyState.INACTIVE;
        this.mMetaAltState = MetaKeyState.INACTIVE;
        InputMethodManager inputMethodManager = getInputMethodManager();
        if (inputMethodManager != null) {
            inputMethodManager.restartInput(this);
        }
        if (this.mInputConnection != null) {
            this.mInputConnection.Reset();
        }
    }

    public InputMethodManager getInputMethodManager() {
        return (InputMethodManager) getContext().getSystemService("input_method");
    }

    @Override // android.view.View
    public boolean performLongClick() {
        Rect rectNativeGetTextBoxBounds;
        if (this.mWindowHasFocus && (rectNativeGetTextBoxBounds = nativeGetTextBoxBounds()) != null && ((this.mLastTouchedXCoord > rectNativeGetTextBoxBounds.left && this.mLastTouchedXCoord < rectNativeGetTextBoxBounds.right && this.mLastTouchedYCoord > rectNativeGetTextBoxBounds.top && this.mLastTouchedYCoord < rectNativeGetTextBoxBounds.bottom) || this.mTrackBallPressed)) {
            this.mTrackBallPressed = false;
            if (super.performLongClick()) {
                return true;
            }
        }
        return false;
    }

    @Override // android.view.View
    protected void onCreateContextMenu(ContextMenu contextMenu) {
        super.onCreateContextMenu(contextMenu);
        if (!this.mIsFullScreen || nativeIsFullScreenInteractive()) {
            ClipboardManager clipboardManager = (ClipboardManager) getContext().getSystemService("clipboard");
            MenuHandler menuHandler = new MenuHandler();
            boolean zNativeIsEditable = nativeIsEditable();
            boolean zNativeIsTextFieldSelectable = nativeIsTextFieldSelectable();
            if (zNativeIsTextFieldSelectable || zNativeIsEditable) {
                if (zNativeIsTextFieldSelectable) {
                    boolean z = nativeGetTextContentLength() > 0;
                    if (z) {
                        contextMenu.add(0, 0, 0, AndroidLocale.GetLocalizedString(AndroidLocale.STRING_ID.IDA_SELECT_ALL)).setOnMenuItemClickListener(menuHandler).setAlphabeticShortcut('a');
                        if (nativeIsTextFieldInSelectionMode()) {
                            contextMenu.add(0, 8, 0, AndroidLocale.GetLocalizedString(AndroidLocale.STRING_ID.IDA_STOP_SELECTING_TEXT)).setOnMenuItemClickListener(menuHandler);
                        } else {
                            contextMenu.add(0, 7, 0, AndroidLocale.GetLocalizedString(AndroidLocale.STRING_ID.IDA_SELECT_TEXT)).setOnMenuItemClickListener(menuHandler);
                        }
                    }
                    if (!nativeIsPasswordField() && z) {
                        boolean zNativeIsTextSelected = nativeIsTextSelected();
                        if (zNativeIsEditable) {
                            if (zNativeIsTextSelected) {
                                contextMenu.add(0, 1, 0, AndroidLocale.GetLocalizedString(AndroidLocale.STRING_ID.IDA_CUT_STRING)).setOnMenuItemClickListener(menuHandler).setAlphabeticShortcut('x');
                            } else {
                                contextMenu.add(0, 2, 0, AndroidLocale.GetLocalizedString(AndroidLocale.STRING_ID.IDA_CUT_ALL_STRING)).setOnMenuItemClickListener(menuHandler);
                            }
                        }
                        if (zNativeIsTextSelected) {
                            contextMenu.add(0, 3, 0, AndroidLocale.GetLocalizedString(AndroidLocale.STRING_ID.IDA_COPY_STRING)).setOnMenuItemClickListener(menuHandler).setAlphabeticShortcut('c');
                        } else {
                            contextMenu.add(0, 4, 0, AndroidLocale.GetLocalizedString(AndroidLocale.STRING_ID.IDA_COPY_ALL_STRING)).setOnMenuItemClickListener(menuHandler);
                        }
                    }
                }
                if (zNativeIsEditable) {
                    if (clipboardManager != null && clipboardManager.hasText()) {
                        contextMenu.add(0, 5, 0, AndroidLocale.GetLocalizedString(AndroidLocale.STRING_ID.IDA_PASTE_STRING)).setOnMenuItemClickListener(menuHandler).setAlphabeticShortcut('v');
                    }
                    contextMenu.add(0, 6, 0, AndroidLocale.GetLocalizedString(AndroidLocale.STRING_ID.IDA_INPUT_METHOD_STRING)).setOnMenuItemClickListener(menuHandler);
                }
                this.mEatTouchRelease = true;
                this.mContextMenuVisible = true;
                contextMenu.setHeaderTitle(AndroidLocale.GetLocalizedString(AndroidLocale.STRING_ID.IDA_CONTEXT_MENU_TITLE_STRING));
            }
        }
    }

    private void postCheckLongPress() {
        if (this.mLongPressCheck == null) {
            this.mLongPressCheck = new CheckLongPress();
        }
        postDelayed(this.mLongPressCheck, 500L);
    }

    class CheckLongPress implements Runnable {
        CheckLongPress() {
        }

        @Override // java.lang.Runnable
        public void run() {
            AIRWindowSurfaceView.this.performLongClick();
        }
    }

    private class MenuHandler implements MenuItem.OnMenuItemClickListener {
        private MenuHandler() {
        }

        @Override // android.view.MenuItem.OnMenuItemClickListener
        public boolean onMenuItemClick(MenuItem menuItem) {
            return AIRWindowSurfaceView.this.onTextBoxContextMenuItem(menuItem.getItemId());
        }
    }

    public boolean onTextBoxContextMenuItem(int i) {
        ClipboardManager clipboardManager = (ClipboardManager) getContext().getSystemService("clipboard");
        switch (i) {
            case 0:
                nativeSelectAllText();
                break;
            case 1:
                String strNativeGetSelectedText = nativeGetSelectedText();
                if (strNativeGetSelectedText != null) {
                    nativeCutText(false);
                    if (nativeIsPasswordField()) {
                        strNativeGetSelectedText = Utils.ReplaceTextContentWithStars(strNativeGetSelectedText);
                    }
                    clipboardManager.setText(strNativeGetSelectedText);
                }
                SetSelectionMode(false);
                break;
            case 2:
                CharSequence charSequenceReplaceTextContentWithStars = nativeGetTextContent().text;
                if (charSequenceReplaceTextContentWithStars != null) {
                    nativeCutText(true);
                    if (nativeIsPasswordField()) {
                        charSequenceReplaceTextContentWithStars = Utils.ReplaceTextContentWithStars(charSequenceReplaceTextContentWithStars.toString());
                    }
                    clipboardManager.setText(charSequenceReplaceTextContentWithStars);
                    break;
                }
                break;
            case 3:
                String strNativeGetSelectedText2 = nativeGetSelectedText();
                if (strNativeGetSelectedText2 != null) {
                    if (nativeIsPasswordField()) {
                        strNativeGetSelectedText2 = Utils.ReplaceTextContentWithStars(strNativeGetSelectedText2);
                    }
                    clipboardManager.setText(strNativeGetSelectedText2);
                }
                SetSelectionMode(false);
                break;
            case 4:
                CharSequence charSequenceReplaceTextContentWithStars2 = nativeGetTextContent().text;
                if (charSequenceReplaceTextContentWithStars2 != null) {
                    if (nativeIsPasswordField()) {
                        charSequenceReplaceTextContentWithStars2 = Utils.ReplaceTextContentWithStars(charSequenceReplaceTextContentWithStars2.toString());
                    }
                    clipboardManager.setText(charSequenceReplaceTextContentWithStars2);
                    break;
                }
                break;
            case 5:
                CharSequence text = clipboardManager.getText();
                if (text != null) {
                    nativeInsertText(text.toString());
                }
                SetSelectionMode(false);
                break;
            case 6:
                InputMethodManager inputMethodManager = getInputMethodManager();
                if (inputMethodManager != null) {
                    inputMethodManager.showInputMethodPicker();
                    break;
                }
                break;
            case 7:
                SetSelectionMode(true);
                break;
            case 8:
                SetSelectionMode(false);
                break;
            default:
                return false;
        }
        if (this.mInputConnection != null) {
            this.mInputConnection.updateIMEText();
        }
        return true;
    }

    private boolean IsTouchEventHandlingAllowed(int i, float f, float f2) {
        boolean zIsPointInTextBox = IsPointInTextBox(f, f2, i);
        if (i == 2) {
            this.mDownX = f;
            this.mDownY = f2;
            this.mEatTouchRelease = false;
            if (zIsPointInTextBox) {
                postCheckLongPress();
                return true;
            }
        } else if (i == 1) {
            if (zIsPointInTextBox) {
                if (!IsTouchMove(f, f2)) {
                    return false;
                }
                if (this.mLongPressCheck != null) {
                    removeCallbacks(this.mLongPressCheck);
                    return true;
                }
            }
        } else if (i == 4 && this.mLongPressCheck != null) {
            removeCallbacks(this.mLongPressCheck);
        }
        return true;
    }

    private boolean IsTouchMove(float f, float f2) {
        float f3 = this.mDownX - f;
        float f4 = this.mDownY - f2;
        return ((float) Math.sqrt((double) ((f3 * f3) + (f4 * f4)))) >= ((float) this.mScaledTouchSlop);
    }

    private boolean IsPointInTextBox(float f, float f2, int i) {
        boolean z;
        if (i == 2) {
            this.mTextBoxBounds = nativeGetTextBoxBounds();
        }
        if (this.mTextBoxBounds != null && ((int) f) > this.mTextBoxBounds.left && ((int) f) < this.mTextBoxBounds.right && ((int) f2) > this.mTextBoxBounds.top && ((int) f2) < this.mTextBoxBounds.bottom) {
            z = true;
        } else {
            z = false;
        }
        if (i == 4) {
            this.mTextBoxBounds = null;
        }
        return z;
    }

    private void HandleMetaKeyAction(KeyEvent keyEvent) {
        switch (keyEvent.getKeyCode()) {
            case 57:
            case 58:
                if (keyEvent.getRepeatCount() == 0) {
                    this.mMetaAltState = GetMetaKeyState(this.mMetaAltState, keyEvent.isAltPressed(), false);
                    break;
                }
                break;
            case 59:
            case 60:
                if (keyEvent.getRepeatCount() == 0) {
                    this.mMetaShiftState = GetMetaKeyState(this.mMetaShiftState, keyEvent.isShiftPressed(), false);
                    break;
                }
                break;
            default:
                this.mMetaShiftState = GetMetaKeyState(this.mMetaShiftState, keyEvent.isShiftPressed(), true);
                this.mMetaAltState = GetMetaKeyState(this.mMetaAltState, keyEvent.isAltPressed(), true);
                break;
        }
    }

    private MetaKeyState GetMetaKeyState(MetaKeyState metaKeyState, boolean z, boolean z2) {
        if (z2) {
            switch (metaKeyState) {
                case INACTIVE:
                case PRESSED:
                    return z ? MetaKeyState.PRESSED : MetaKeyState.INACTIVE;
                case ACTIVE:
                    return z ? MetaKeyState.PRESSED : MetaKeyState.INACTIVE;
                case LOCKED:
                    return MetaKeyState.LOCKED;
                default:
                    return MetaKeyState.INACTIVE;
            }
        }
        if (z) {
            switch (metaKeyState) {
                case INACTIVE:
                case PRESSED:
                    return MetaKeyState.ACTIVE;
                case ACTIVE:
                    return MetaKeyState.LOCKED;
                default:
                    return MetaKeyState.INACTIVE;
            }
        }
        return MetaKeyState.INACTIVE;
    }

    int GetMetaKeyCharacter(KeyEvent keyEvent) {
        int i = 0;
        if (this.mMetaShiftState == MetaKeyState.LOCKED || this.mMetaShiftState == MetaKeyState.ACTIVE) {
            i = 0 | 1;
        }
        if (this.mMetaAltState == MetaKeyState.LOCKED || this.mMetaAltState == MetaKeyState.ACTIVE) {
            i |= 2;
        }
        return keyEvent.getUnicodeChar(i);
    }

    private boolean AllowOSToHandleKeys(int i) {
        switch (i) {
            case 24:
            case 25:
            case 26:
                return true;
            default:
                return false;
        }
    }

    public void HideSoftKeyboardOnWindowFocusChange() {
        this.mHideSoftKeyboardOnWindowFocusChange = true;
    }

    private boolean HandleShortCuts(int i, KeyEvent keyEvent) {
        if (i == 23) {
            if (this.mTrackBallPressed || this.mContextMenuVisible) {
                return true;
            }
            this.mTrackBallPressed = true;
            postCheckLongPress();
            return false;
        }
        if (!keyEvent.isAltPressed()) {
            return false;
        }
        switch (i) {
            case TimeUtils.HUNDRED_DAY_FIELD_LEN /* 19 */:
                nativeMoveCursor(2);
                return true;
            case 20:
                nativeMoveCursor(3);
                return true;
            case 21:
                nativeMoveCursor(0);
                return true;
            case 22:
                nativeMoveCursor(1);
                return true;
            case 67:
                nativeDeleteTextLine();
                return true;
            default:
                return false;
        }
    }

    public void setInputConnection(AndroidInputConnection androidInputConnection) {
        this.mInputConnection = androidInputConnection;
    }

    public void setFlashEGL(FlashEGL flashEGL) {
        this.mFlashEGL = flashEGL;
    }

    public boolean IsPasswordVisibleSettingEnabled() {
        try {
            return Settings.System.getInt(getContext().getContentResolver(), "show_password") == 1;
        } catch (Exception e) {
            return false;
        }
    }

    public boolean IsTouchUpHandlingAllowed() {
        return !this.mEatTouchRelease;
    }

    public void SetSelectionMode(boolean z) {
        nativeDispatchSelectionChangeEvent(z);
    }

    @Override // android.view.View
    public boolean onKeyPreIme(int i, KeyEvent keyEvent) {
        if (i == 4 && keyEvent.getAction() == 0) {
            DispatchSoftKeyboardEventOnBackKey();
            return false;
        }
        return false;
    }

    public void DispatchSoftKeyboardEventOnBackKey() {
        if ((this.mIsFullScreen && !this.mSurfaceChangedForSoftKeyboard) || this.mFlashEGL != null || IsIMEInFullScreen() || (!this.mSurfaceChangedForSoftKeyboard && !nativeIsEditable())) {
            nativeDispatchUserTriggeredSkDeactivateEvent();
            if (!this.mSurfaceChangedForSoftKeyboard && !nativeIsEditable()) {
                nativeShowOriginalRect();
            }
        }
    }

    public boolean IsSurfaceChangedForSoftKeyboard() {
        return this.mSurfaceChangedForSoftKeyboard;
    }

    public int getKeyboardHeight() {
        return this.mHt - getVisibleBoundHeight();
    }

    public void SetSurfaceChangedForSoftKeyboard(boolean z) {
        this.mSurfaceChangedForSoftKeyboard = z;
    }

    public VideoView getVideoView() {
        if (this.mVideoView == null) {
            this.mVideoView = new VideoViewAIR(getContext(), this.mActivityWrapper);
        }
        return this.mVideoView;
    }

    @Override // android.view.SurfaceView, android.view.View
    public boolean gatherTransparentRegion(Region region) {
        int[] iArr = new int[2];
        getLocationInWindow(iArr);
        region.op(iArr[0], iArr[1], this.mVisibleBoundWidth, this.mVisibleBoundHeight, Region.Op.REPLACE);
        return false;
    }
}
