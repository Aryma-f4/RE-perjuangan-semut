package com.google.android.gms.plus;

import android.os.Parcel;
import android.os.Parcelable;
import com.google.android.gms.common.internal.safeparcel.a;

/* loaded from: classes.dex */
public class b implements Parcelable.Creator<a> {
    static void a(a aVar, Parcel parcel, int i) {
        int iD = com.google.android.gms.common.internal.safeparcel.b.d(parcel);
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 1, aVar.getAccountName(), false);
        com.google.android.gms.common.internal.safeparcel.b.c(parcel, 1000, aVar.i());
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 2, aVar.by(), false);
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 3, aVar.bz(), false);
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 4, aVar.bA(), false);
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 5, aVar.bB(), false);
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 6, aVar.bC(), false);
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 7, aVar.bD(), false);
        com.google.android.gms.common.internal.safeparcel.b.C(parcel, iD);
    }

    @Override // android.os.Parcelable.Creator
    /* renamed from: U, reason: merged with bridge method [inline-methods] */
    public a[] newArray(int i) {
        return new a[i];
    }

    @Override // android.os.Parcelable.Creator
    /* renamed from: u, reason: merged with bridge method [inline-methods] */
    public a createFromParcel(Parcel parcel) {
        int iC = com.google.android.gms.common.internal.safeparcel.a.c(parcel);
        int iF = 0;
        String strL = null;
        String[] strArrW = null;
        String[] strArrW2 = null;
        String[] strArrW3 = null;
        String strL2 = null;
        String strL3 = null;
        String strL4 = null;
        while (parcel.dataPosition() < iC) {
            int iB = com.google.android.gms.common.internal.safeparcel.a.b(parcel);
            switch (com.google.android.gms.common.internal.safeparcel.a.m(iB)) {
                case 1:
                    strL = com.google.android.gms.common.internal.safeparcel.a.l(parcel, iB);
                    break;
                case 2:
                    strArrW = com.google.android.gms.common.internal.safeparcel.a.w(parcel, iB);
                    break;
                case 3:
                    strArrW2 = com.google.android.gms.common.internal.safeparcel.a.w(parcel, iB);
                    break;
                case 4:
                    strArrW3 = com.google.android.gms.common.internal.safeparcel.a.w(parcel, iB);
                    break;
                case 5:
                    strL2 = com.google.android.gms.common.internal.safeparcel.a.l(parcel, iB);
                    break;
                case 6:
                    strL3 = com.google.android.gms.common.internal.safeparcel.a.l(parcel, iB);
                    break;
                case 7:
                    strL4 = com.google.android.gms.common.internal.safeparcel.a.l(parcel, iB);
                    break;
                case 1000:
                    iF = com.google.android.gms.common.internal.safeparcel.a.f(parcel, iB);
                    break;
                default:
                    com.google.android.gms.common.internal.safeparcel.a.b(parcel, iB);
                    break;
            }
            iF = iF;
            strL4 = strL4;
            strArrW = strArrW;
            strL2 = strL2;
            strArrW3 = strArrW3;
            strArrW2 = strArrW2;
            strL3 = strL3;
            strL = strL;
        }
        if (parcel.dataPosition() != iC) {
            throw new a.C0003a("Overread allowed size end=" + iC, parcel);
        }
        return new a(iF, strL, strArrW, strArrW2, strArrW3, strL2, strL3, strL4);
    }
}
