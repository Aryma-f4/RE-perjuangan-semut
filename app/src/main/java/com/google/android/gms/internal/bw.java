package com.google.android.gms.internal;

import android.os.Parcel;
import android.os.Parcelable;
import com.google.android.gms.common.internal.safeparcel.a;
import java.util.ArrayList;

/* loaded from: classes.dex */
public class bw implements Parcelable.Creator<bv> {
    static void a(bv bvVar, Parcel parcel, int i) {
        int iD = com.google.android.gms.common.internal.safeparcel.b.d(parcel);
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 1, bvVar.getDescription(), false);
        com.google.android.gms.common.internal.safeparcel.b.c(parcel, 1000, bvVar.i());
        com.google.android.gms.common.internal.safeparcel.b.b(parcel, 2, bvVar.bE(), false);
        com.google.android.gms.common.internal.safeparcel.b.b(parcel, 3, bvVar.bF(), false);
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 4, bvVar.bG());
        com.google.android.gms.common.internal.safeparcel.b.C(parcel, iD);
    }

    @Override // android.os.Parcelable.Creator
    /* renamed from: V, reason: merged with bridge method [inline-methods] */
    public bv[] newArray(int i) {
        return new bv[i];
    }

    @Override // android.os.Parcelable.Creator
    /* renamed from: v, reason: merged with bridge method [inline-methods] */
    public bv createFromParcel(Parcel parcel) {
        int iC = com.google.android.gms.common.internal.safeparcel.a.c(parcel);
        boolean zC = false;
        ArrayList arrayListC = null;
        ArrayList arrayListC2 = null;
        int iF = 0;
        String strL = null;
        while (parcel.dataPosition() < iC) {
            int iB = com.google.android.gms.common.internal.safeparcel.a.b(parcel);
            switch (com.google.android.gms.common.internal.safeparcel.a.m(iB)) {
                case 1:
                    strL = com.google.android.gms.common.internal.safeparcel.a.l(parcel, iB);
                    break;
                case 2:
                    arrayListC2 = com.google.android.gms.common.internal.safeparcel.a.c(parcel, iB, x.CREATOR);
                    break;
                case 3:
                    arrayListC = com.google.android.gms.common.internal.safeparcel.a.c(parcel, iB, x.CREATOR);
                    break;
                case 4:
                    zC = com.google.android.gms.common.internal.safeparcel.a.c(parcel, iB);
                    break;
                case 1000:
                    iF = com.google.android.gms.common.internal.safeparcel.a.f(parcel, iB);
                    break;
                default:
                    com.google.android.gms.common.internal.safeparcel.a.b(parcel, iB);
                    break;
            }
            iF = iF;
            zC = zC;
            arrayListC = arrayListC;
            strL = strL;
        }
        if (parcel.dataPosition() != iC) {
            throw new a.C0003a("Overread allowed size end=" + iC, parcel);
        }
        return new bv(iF, strL, arrayListC2, arrayListC, zC);
    }
}
