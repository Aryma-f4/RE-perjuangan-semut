package com.google.android.gms.internal;

import android.os.Parcel;
import android.os.Parcelable;
import com.google.android.gms.common.internal.safeparcel.a;
import com.google.android.gms.internal.ae;
import com.google.android.gms.internal.ah;

/* loaded from: classes.dex */
public class ag implements Parcelable.Creator<ah.b> {
    static void a(ah.b bVar, Parcel parcel, int i) {
        int iD = com.google.android.gms.common.internal.safeparcel.b.d(parcel);
        com.google.android.gms.common.internal.safeparcel.b.c(parcel, 1, bVar.versionCode);
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 2, bVar.cH, false);
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 3, (Parcelable) bVar.cI, i, false);
        com.google.android.gms.common.internal.safeparcel.b.C(parcel, iD);
    }

    @Override // android.os.Parcelable.Creator
    /* renamed from: j, reason: merged with bridge method [inline-methods] */
    public ah.b createFromParcel(Parcel parcel) {
        String strL = null;
        int iC = com.google.android.gms.common.internal.safeparcel.a.c(parcel);
        int iF = 0;
        ae.a aVar = null;
        while (parcel.dataPosition() < iC) {
            int iB = com.google.android.gms.common.internal.safeparcel.a.b(parcel);
            switch (com.google.android.gms.common.internal.safeparcel.a.m(iB)) {
                case 1:
                    iF = com.google.android.gms.common.internal.safeparcel.a.f(parcel, iB);
                    break;
                case 2:
                    strL = com.google.android.gms.common.internal.safeparcel.a.l(parcel, iB);
                    break;
                case 3:
                    aVar = (ae.a) com.google.android.gms.common.internal.safeparcel.a.a(parcel, iB, ae.a.CREATOR);
                    break;
                default:
                    com.google.android.gms.common.internal.safeparcel.a.b(parcel, iB);
                    break;
            }
        }
        if (parcel.dataPosition() != iC) {
            throw new a.C0003a("Overread allowed size end=" + iC, parcel);
        }
        return new ah.b(iF, strL, aVar);
    }

    @Override // android.os.Parcelable.Creator
    /* renamed from: s, reason: merged with bridge method [inline-methods] */
    public ah.b[] newArray(int i) {
        return new ah.b[i];
    }
}
