package com.google.android.gms.internal;

import android.os.Parcel;
import android.os.Parcelable;
import com.google.android.gms.common.internal.safeparcel.a;

/* loaded from: classes.dex */
public class bj implements Parcelable.Creator<bi> {
    static void a(bi biVar, Parcel parcel, int i) {
        int iD = com.google.android.gms.common.internal.safeparcel.b.d(parcel);
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 1, biVar.getRequestId(), false);
        com.google.android.gms.common.internal.safeparcel.b.c(parcel, 1000, biVar.i());
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 2, biVar.getExpirationTime());
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 3, biVar.aT());
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 4, biVar.getLatitude());
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 5, biVar.getLongitude());
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 6, biVar.aU());
        com.google.android.gms.common.internal.safeparcel.b.c(parcel, 7, biVar.aV());
        com.google.android.gms.common.internal.safeparcel.b.C(parcel, iD);
    }

    @Override // android.os.Parcelable.Creator
    /* renamed from: R, reason: merged with bridge method [inline-methods] */
    public bi[] newArray(int i) {
        return new bi[i];
    }

    @Override // android.os.Parcelable.Creator
    /* renamed from: t, reason: merged with bridge method [inline-methods] */
    public bi createFromParcel(Parcel parcel) {
        int iC = com.google.android.gms.common.internal.safeparcel.a.c(parcel);
        int iF = 0;
        String strL = null;
        int iF2 = 0;
        short sE = 0;
        double dJ = 0.0d;
        double dJ2 = 0.0d;
        float fI = 0.0f;
        long jG = 0;
        while (parcel.dataPosition() < iC) {
            int iB = com.google.android.gms.common.internal.safeparcel.a.b(parcel);
            switch (com.google.android.gms.common.internal.safeparcel.a.m(iB)) {
                case 1:
                    strL = com.google.android.gms.common.internal.safeparcel.a.l(parcel, iB);
                    break;
                case 2:
                    jG = com.google.android.gms.common.internal.safeparcel.a.g(parcel, iB);
                    break;
                case 3:
                    sE = com.google.android.gms.common.internal.safeparcel.a.e(parcel, iB);
                    break;
                case 4:
                    dJ = com.google.android.gms.common.internal.safeparcel.a.j(parcel, iB);
                    break;
                case 5:
                    dJ2 = com.google.android.gms.common.internal.safeparcel.a.j(parcel, iB);
                    break;
                case 6:
                    fI = com.google.android.gms.common.internal.safeparcel.a.i(parcel, iB);
                    break;
                case 7:
                    iF2 = com.google.android.gms.common.internal.safeparcel.a.f(parcel, iB);
                    break;
                case 1000:
                    iF = com.google.android.gms.common.internal.safeparcel.a.f(parcel, iB);
                    break;
                default:
                    com.google.android.gms.common.internal.safeparcel.a.b(parcel, iB);
                    break;
            }
            strL = strL;
            iF = iF;
            jG = jG;
            dJ2 = dJ2;
            dJ = dJ;
            sE = sE;
            fI = fI;
            iF2 = iF2;
        }
        if (parcel.dataPosition() != iC) {
            throw new a.C0003a("Overread allowed size end=" + iC, parcel);
        }
        return new bi(iF, strL, iF2, sE, dJ, dJ2, fI, jG);
    }
}
