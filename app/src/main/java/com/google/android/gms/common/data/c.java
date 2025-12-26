package com.google.android.gms.common.data;

import android.os.Parcel;
import android.os.Parcelable;
import com.google.android.gms.common.internal.safeparcel.SafeParcelable;

/* loaded from: classes.dex */
public class c<T extends SafeParcelable> extends DataBuffer<T> {
    private static final String[] X = {"data"};
    private final Parcelable.Creator<T> Y;

    public c(d dVar, Parcelable.Creator<T> creator) {
        super(dVar);
        this.Y = creator;
    }

    @Override // com.google.android.gms.common.data.DataBuffer
    /* renamed from: d, reason: merged with bridge method [inline-methods] */
    public T get(int i) {
        byte[] bArrE = this.S.e("data", i, 0);
        Parcel parcelObtain = Parcel.obtain();
        parcelObtain.unmarshall(bArrE, 0, bArrE.length);
        parcelObtain.setDataPosition(0);
        T tCreateFromParcel = this.Y.createFromParcel(parcelObtain);
        parcelObtain.recycle();
        return tCreateFromParcel;
    }
}
