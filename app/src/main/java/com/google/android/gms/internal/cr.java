package com.google.android.gms.internal;

import android.os.Bundle;
import android.os.Parcel;
import android.os.Parcelable;
import com.google.android.gms.common.internal.safeparcel.a;
import java.util.ArrayList;

/* loaded from: classes.dex */
public class cr implements Parcelable.Creator<cq> {
    static void a(cq cqVar, Parcel parcel, int i) {
        int iD = com.google.android.gms.common.internal.safeparcel.b.d(parcel);
        com.google.android.gms.common.internal.safeparcel.b.c(parcel, 1000, cqVar.i());
        com.google.android.gms.common.internal.safeparcel.b.b(parcel, 2, cqVar.cK(), false);
        com.google.android.gms.common.internal.safeparcel.b.b(parcel, 3, cqVar.cL(), false);
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 4, cqVar.cM(), false);
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 5, cqVar.cN());
        com.google.android.gms.common.internal.safeparcel.b.c(parcel, 6, cqVar.cJ());
        com.google.android.gms.common.internal.safeparcel.b.C(parcel, iD);
    }

    @Override // android.os.Parcelable.Creator
    /* renamed from: J, reason: merged with bridge method [inline-methods] */
    public cq createFromParcel(Parcel parcel) {
        ArrayList arrayListC = null;
        int iF = 0;
        int iC = com.google.android.gms.common.internal.safeparcel.a.c(parcel);
        int iF2 = 0;
        boolean zC = false;
        Bundle bundleN = null;
        ArrayList arrayListC2 = null;
        while (parcel.dataPosition() < iC) {
            int iB = com.google.android.gms.common.internal.safeparcel.a.b(parcel);
            switch (com.google.android.gms.common.internal.safeparcel.a.m(iB)) {
                case 2:
                    arrayListC = com.google.android.gms.common.internal.safeparcel.a.c(parcel, iB, x.CREATOR);
                    break;
                case 3:
                    arrayListC2 = com.google.android.gms.common.internal.safeparcel.a.c(parcel, iB, x.CREATOR);
                    break;
                case 4:
                    bundleN = com.google.android.gms.common.internal.safeparcel.a.n(parcel, iB);
                    break;
                case 5:
                    zC = com.google.android.gms.common.internal.safeparcel.a.c(parcel, iB);
                    break;
                case 6:
                    iF2 = com.google.android.gms.common.internal.safeparcel.a.f(parcel, iB);
                    break;
                case 1000:
                    iF = com.google.android.gms.common.internal.safeparcel.a.f(parcel, iB);
                    break;
                default:
                    com.google.android.gms.common.internal.safeparcel.a.b(parcel, iB);
                    break;
            }
            iF = iF;
            iF2 = iF2;
            arrayListC2 = arrayListC2;
            bundleN = bundleN;
            zC = zC;
            arrayListC = arrayListC;
        }
        if (parcel.dataPosition() != iC) {
            throw new a.C0003a("Overread allowed size end=" + iC, parcel);
        }
        return new cq(iF, arrayListC, arrayListC2, bundleN, zC, iF2);
    }

    @Override // android.os.Parcelable.Creator
    /* renamed from: aj, reason: merged with bridge method [inline-methods] */
    public cq[] newArray(int i) {
        return new cq[i];
    }
}
