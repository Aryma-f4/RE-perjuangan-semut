package com.google.android.gms.internal;

import android.os.Parcel;
import android.os.Parcelable;
import com.google.android.gms.common.internal.safeparcel.a;
import com.google.android.gms.internal.ah;
import java.util.ArrayList;

/* loaded from: classes.dex */
public class ai implements Parcelable.Creator<ah> {
    static void a(ah ahVar, Parcel parcel, int i) {
        int iD = com.google.android.gms.common.internal.safeparcel.b.d(parcel);
        com.google.android.gms.common.internal.safeparcel.b.c(parcel, 1, ahVar.i());
        com.google.android.gms.common.internal.safeparcel.b.b(parcel, 2, ahVar.ai(), false);
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 3, ahVar.aj(), false);
        com.google.android.gms.common.internal.safeparcel.b.C(parcel, iD);
    }

    @Override // android.os.Parcelable.Creator
    /* renamed from: k, reason: merged with bridge method [inline-methods] */
    public ah createFromParcel(Parcel parcel) {
        ArrayList arrayListC = null;
        int iC = com.google.android.gms.common.internal.safeparcel.a.c(parcel);
        int iF = 0;
        String strL = null;
        while (parcel.dataPosition() < iC) {
            int iB = com.google.android.gms.common.internal.safeparcel.a.b(parcel);
            switch (com.google.android.gms.common.internal.safeparcel.a.m(iB)) {
                case 1:
                    iF = com.google.android.gms.common.internal.safeparcel.a.f(parcel, iB);
                    break;
                case 2:
                    arrayListC = com.google.android.gms.common.internal.safeparcel.a.c(parcel, iB, ah.a.CREATOR);
                    break;
                case 3:
                    strL = com.google.android.gms.common.internal.safeparcel.a.l(parcel, iB);
                    break;
                default:
                    com.google.android.gms.common.internal.safeparcel.a.b(parcel, iB);
                    break;
            }
        }
        if (parcel.dataPosition() != iC) {
            throw new a.C0003a("Overread allowed size end=" + iC, parcel);
        }
        return new ah(iF, arrayListC, strL);
    }

    @Override // android.os.Parcelable.Creator
    /* renamed from: t, reason: merged with bridge method [inline-methods] */
    public ah[] newArray(int i) {
        return new ah[i];
    }
}
