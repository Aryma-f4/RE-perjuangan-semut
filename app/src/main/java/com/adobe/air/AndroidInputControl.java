package com.adobe.air;

/* compiled from: AndroidInputManager.java */
/* loaded from: classes.dex */
class AndroidInputControl {
    private int mCode;
    private long mInternalReference;
    private float mMaxValue;
    private float mMinValue;
    private ControlType mType;
    private float mValue = 0.0f;

    private native void OnValueChange(long j, float f);

    public AndroidInputControl(ControlType controlType, int i, float f, float f2) {
        this.mCode = 0;
        this.mMinValue = 0.0f;
        this.mMaxValue = 0.0f;
        this.mType = controlType;
        this.mCode = i;
        this.mMinValue = f;
        this.mMaxValue = f2;
    }

    public void setInternalReference(long j) {
        this.mInternalReference = j;
    }

    public int getType() {
        return this.mType.ordinal();
    }

    public int getCode() {
        return this.mCode;
    }

    public float getValue() {
        return this.mValue;
    }

    public float getMinValue() {
        return this.mMinValue;
    }

    public float getMaxValue() {
        return this.mMaxValue;
    }

    public String getId() {
        return this.mType.name() + "_" + this.mCode;
    }

    public void setData(float f) {
        if (this.mValue != f) {
            this.mValue = f;
            OnValueChange(this.mInternalReference, this.mValue);
        }
    }
}
