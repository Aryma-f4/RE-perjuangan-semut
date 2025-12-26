package com.adobe.air.wand.view;

/* loaded from: classes.dex */
public class GestureEventData {
    public boolean mIsTransform;
    public float mOffsetX;
    public float mOffsetY;
    public int mPhase;
    public float mRotation;
    public float mScaleX;
    public float mScaleY;
    public int mType;
    public float mXCoord;
    public float mYCoord;

    public GestureEventData(int i, int i2, boolean z, float f, float f2, float f3, float f4, float f5, float f6, float f7) {
        this.mPhase = 2;
        this.mType = 0;
        this.mXCoord = 0.0f;
        this.mYCoord = 0.0f;
        this.mScaleX = 1.0f;
        this.mScaleY = 1.0f;
        this.mIsTransform = true;
        this.mRotation = 0.0f;
        this.mOffsetX = 0.0f;
        this.mOffsetY = 0.0f;
        this.mPhase = i;
        this.mType = i2;
        this.mIsTransform = z;
        this.mXCoord = f;
        this.mYCoord = f2;
        this.mScaleX = f3;
        this.mScaleY = f4;
        this.mRotation = f5;
        this.mOffsetX = f6;
        this.mOffsetY = f7;
    }
}
