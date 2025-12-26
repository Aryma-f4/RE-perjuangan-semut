package com.google.android.gms.common.data;

import android.database.CursorWindow;
import android.os.Bundle;
import android.os.Parcel;
import android.os.Parcelable;
import com.google.android.gms.common.internal.safeparcel.a;

/* loaded from: classes.dex */
public class e implements Parcelable.Creator<d> {
    static void a(d dVar, Parcel parcel, int i) {
        int iD = com.google.android.gms.common.internal.safeparcel.b.d(parcel);
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 1, dVar.j(), false);
        com.google.android.gms.common.internal.safeparcel.b.c(parcel, 1000, dVar.i());
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 2, (Parcelable[]) dVar.k(), i, false);
        com.google.android.gms.common.internal.safeparcel.b.c(parcel, 3, dVar.getStatusCode());
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 4, dVar.l(), false);
        com.google.android.gms.common.internal.safeparcel.b.C(parcel, iD);
    }

    @Override // android.os.Parcelable.Creator
    /* renamed from: a, reason: merged with bridge method [inline-methods] */
    public d createFromParcel(Parcel parcel) {
        int iF;
        Bundle bundleN;
        int iF2;
        String[] strArrW;
        int iC = com.google.android.gms.common.internal.safeparcel.a.c(parcel);
        Bundle bundle = null;
        int i = 0;
        CursorWindow[] cursorWindowArr = null;
        int i2 = 0;
        String[] strArr = null;
        while (parcel.dataPosition() < iC) {
            int iB = com.google.android.gms.common.internal.safeparcel.a.b(parcel);
            switch (com.google.android.gms.common.internal.safeparcel.a.m(iB)) {
                case 1:
                    Bundle bundle2 = bundle;
                    iF = i2;
                    bundleN = bundle2;
                    iF2 = i;
                    strArrW = com.google.android.gms.common.internal.safeparcel.a.w(parcel, iB);
                    break;
                case 2:
                    cursorWindowArr = (CursorWindow[]) com.google.android.gms.common.internal.safeparcel.a.b(parcel, iB, CursorWindow.CREATOR);
                    int i3 = i;
                    strArrW = strArr;
                    iF2 = i3;
                    Bundle bundle3 = bundle;
                    iF = i2;
                    bundleN = bundle3;
                    break;
                case 3:
                    Bundle bundle4 = bundle;
                    iF = i2;
                    bundleN = bundle4;
                    String[] strArr2 = strArr;
                    iF2 = com.google.android.gms.common.internal.safeparcel.a.f(parcel, iB);
                    strArrW = strArr2;
                    break;
                case 4:
                    iF = i2;
                    bundleN = com.google.android.gms.common.internal.safeparcel.a.n(parcel, iB);
                    String[] strArr3 = strArr;
                    iF2 = i;
                    strArrW = strArr3;
                    break;
                case 1000:
                    Bundle bundle5 = bundle;
                    iF = com.google.android.gms.common.internal.safeparcel.a.f(parcel, iB);
                    bundleN = bundle5;
                    String[] strArr4 = strArr;
                    iF2 = i;
                    strArrW = strArr4;
                    break;
                default:
                    com.google.android.gms.common.internal.safeparcel.a.b(parcel, iB);
                    Bundle bundle6 = bundle;
                    iF = i2;
                    bundleN = bundle6;
                    String[] strArr5 = strArr;
                    iF2 = i;
                    strArrW = strArr5;
                    break;
            }
            Bundle bundle7 = bundleN;
            i2 = iF;
            bundle = bundle7;
            String[] strArr6 = strArrW;
            i = iF2;
            strArr = strArr6;
        }
        if (parcel.dataPosition() != iC) {
            throw new a.C0003a("Overread allowed size end=" + iC, parcel);
        }
        d dVar = new d(i2, strArr, cursorWindowArr, i, bundle);
        dVar.h();
        return dVar;
    }

    @Override // android.os.Parcelable.Creator
    /* renamed from: g, reason: merged with bridge method [inline-methods] */
    public d[] newArray(int i) {
        return new d[i];
    }
}
