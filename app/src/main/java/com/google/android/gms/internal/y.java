package com.google.android.gms.internal;

import android.os.Parcel;
import android.os.Parcelable;
import com.google.android.gms.common.internal.safeparcel.a;

/* loaded from: classes.dex */
public class y implements Parcelable.Creator<x> {
    static void a(x xVar, Parcel parcel, int i) {
        int iD = com.google.android.gms.common.internal.safeparcel.b.d(parcel);
        com.google.android.gms.common.internal.safeparcel.b.c(parcel, 1, xVar.getType());
        com.google.android.gms.common.internal.safeparcel.b.c(parcel, 1000, xVar.i());
        com.google.android.gms.common.internal.safeparcel.b.c(parcel, 2, xVar.I());
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 3, xVar.J(), false);
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 4, xVar.K(), false);
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 5, xVar.getDisplayName(), false);
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 6, xVar.L(), false);
        com.google.android.gms.common.internal.safeparcel.b.C(parcel, iD);
    }

    @Override // android.os.Parcelable.Creator
    /* renamed from: e, reason: merged with bridge method [inline-methods] */
    public x createFromParcel(Parcel parcel) {
        int iF = 0;
        int iC = com.google.android.gms.common.internal.safeparcel.a.c(parcel);
        String strL = null;
        String strL2 = null;
        String strL3 = null;
        String strL4 = null;
        int iF2 = 0;
        int iF3 = 0;
        while (parcel.dataPosition() < iC) {
            int iB = com.google.android.gms.common.internal.safeparcel.a.b(parcel);
            switch (com.google.android.gms.common.internal.safeparcel.a.m(iB)) {
                case 1:
                    iF = com.google.android.gms.common.internal.safeparcel.a.f(parcel, iB);
                    break;
                case 2:
                    iF2 = com.google.android.gms.common.internal.safeparcel.a.f(parcel, iB);
                    break;
                case 3:
                    strL4 = com.google.android.gms.common.internal.safeparcel.a.l(parcel, iB);
                    break;
                case 4:
                    strL3 = com.google.android.gms.common.internal.safeparcel.a.l(parcel, iB);
                    break;
                case 5:
                    strL2 = com.google.android.gms.common.internal.safeparcel.a.l(parcel, iB);
                    break;
                case 6:
                    strL = com.google.android.gms.common.internal.safeparcel.a.l(parcel, iB);
                    break;
                case 1000:
                    iF3 = com.google.android.gms.common.internal.safeparcel.a.f(parcel, iB);
                    break;
                default:
                    com.google.android.gms.common.internal.safeparcel.a.b(parcel, iB);
                    break;
            }
            iF3 = iF3;
            strL = strL;
            iF2 = iF2;
            strL3 = strL3;
            strL2 = strL2;
            iF = iF;
        }
        if (parcel.dataPosition() != iC) {
            throw new a.C0003a("Overread allowed size end=" + iC, parcel);
        }
        return new x(iF3, iF, iF2, strL4, strL3, strL2, strL);
    }

    @Override // android.os.Parcelable.Creator
    /* renamed from: n, reason: merged with bridge method [inline-methods] */
    public x[] newArray(int i) {
        return new x[i];
    }
}
