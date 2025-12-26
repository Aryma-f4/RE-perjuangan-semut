package com.adobe.air;

/* loaded from: classes.dex */
public class TouchEventData {
    public float mContactX;
    public float mContactY;
    public float[] mHistory;
    public boolean mIsPrimaryPoint;
    public int mMetaState;
    public int mPointerID;
    public float mPressure;
    public int mTouchEventType;
    public float mXCoord;
    public float mYCoord;

    public TouchEventData(int i, float f, float f2, float f3, int i2, float f4, float f5, boolean z, float[] fArr, int i3) {
        this.mTouchEventType = i;
        this.mXCoord = f;
        this.mYCoord = f2;
        this.mPressure = f3;
        this.mPointerID = i2;
        this.mContactX = f4;
        this.mContactY = f5;
        this.mIsPrimaryPoint = z;
        this.mHistory = fArr;
        this.mMetaState = i3;
    }
}
