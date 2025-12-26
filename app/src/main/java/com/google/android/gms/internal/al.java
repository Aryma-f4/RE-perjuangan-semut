package com.google.android.gms.internal;

import android.os.Parcel;
import android.os.Parcelable;
import com.google.android.gms.common.internal.safeparcel.a;

/* loaded from: classes.dex */
public class al implements Parcelable.Creator<ak> {
    static void a(ak akVar, Parcel parcel, int i) {
        int iD = com.google.android.gms.common.internal.safeparcel.b.d(parcel);
        com.google.android.gms.common.internal.safeparcel.b.c(parcel, 1, akVar.i());
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 2, akVar.al(), false);
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 3, (Parcelable) akVar.am(), i, false);
        com.google.android.gms.common.internal.safeparcel.b.C(parcel, iD);
    }

    @Override // android.os.Parcelable.Creator
    /* renamed from: m, reason: merged with bridge method [inline-methods] */
    public ak createFromParcel(Parcel parcel) {
        Parcel parcelY = null;
        int iC = com.google.android.gms.common.internal.safeparcel.a.c(parcel);
        int iF = 0;
        ah ahVar = null;
        while (parcel.dataPosition() < iC) {
            int iB = com.google.android.gms.common.internal.safeparcel.a.b(parcel);
            switch (com.google.android.gms.common.internal.safeparcel.a.m(iB)) {
                case 1:
                    iF = com.google.android.gms.common.internal.safeparcel.a.f(parcel, iB);
                    break;
                case 2:
                    parcelY = com.google.android.gms.common.internal.safeparcel.a.y(parcel, iB);
                    break;
                case 3:
                    ahVar = (ah) com.google.android.gms.common.internal.safeparcel.a.a(parcel, iB, ah.CREATOR);
                    break;
                default:
                    com.google.android.gms.common.internal.safeparcel.a.b(parcel, iB);
                    break;
            }
        }
        if (parcel.dataPosition() != iC) {
            throw new a.C0003a("Overread allowed size end=" + iC, parcel);
        }
        return new ak(iF, parcelY, ahVar);
    }

    @Override // android.os.Parcelable.Creator
    /* renamed from: v, reason: merged with bridge method [inline-methods] */
    public ak[] newArray(int i) {
        return new ak[i];
    }
}
