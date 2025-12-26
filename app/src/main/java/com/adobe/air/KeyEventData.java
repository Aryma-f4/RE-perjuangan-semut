package com.adobe.air;

/* loaded from: classes.dex */
public class KeyEventData {
    boolean mAlt;
    int mKeyAction;
    int mKeyCode;
    boolean mShift;
    boolean mSym;
    int mUnicode;

    public KeyEventData(int i, int i2, int i3, boolean z, boolean z2, boolean z3) {
        this.mKeyAction = i;
        this.mKeyCode = i2;
        this.mUnicode = i3;
        this.mAlt = z;
        this.mShift = z2;
        this.mSym = z3;
    }
}
