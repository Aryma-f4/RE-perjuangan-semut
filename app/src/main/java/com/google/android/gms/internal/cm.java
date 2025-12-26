package com.google.android.gms.internal;

import android.os.Parcel;
import android.os.Parcelable;
import com.google.android.gms.common.internal.safeparcel.a;
import com.google.android.gms.internal.cc;
import java.util.HashSet;
import java.util.Set;

/* loaded from: classes.dex */
public class cm implements Parcelable.Creator<cc.h> {
    static void a(cc.h hVar, Parcel parcel, int i) {
        int iD = com.google.android.gms.common.internal.safeparcel.b.d(parcel);
        Set<Integer> setBH = hVar.bH();
        if (setBH.contains(1)) {
            com.google.android.gms.common.internal.safeparcel.b.c(parcel, 1, hVar.i());
        }
        if (setBH.contains(3)) {
            com.google.android.gms.common.internal.safeparcel.b.c(parcel, 3, hVar.cu());
        }
        if (setBH.contains(4)) {
            com.google.android.gms.common.internal.safeparcel.b.a(parcel, 4, hVar.getValue(), true);
        }
        if (setBH.contains(5)) {
            com.google.android.gms.common.internal.safeparcel.b.a(parcel, 5, hVar.getLabel(), true);
        }
        if (setBH.contains(6)) {
            com.google.android.gms.common.internal.safeparcel.b.c(parcel, 6, hVar.getType());
        }
        com.google.android.gms.common.internal.safeparcel.b.C(parcel, iD);
    }

    @Override // android.os.Parcelable.Creator
    /* renamed from: H, reason: merged with bridge method [inline-methods] */
    public cc.h createFromParcel(Parcel parcel) {
        String strL = null;
        int iF = 0;
        int iC = com.google.android.gms.common.internal.safeparcel.a.c(parcel);
        HashSet hashSet = new HashSet();
        int iF2 = 0;
        String strL2 = null;
        int iF3 = 0;
        while (parcel.dataPosition() < iC) {
            int iB = com.google.android.gms.common.internal.safeparcel.a.b(parcel);
            switch (com.google.android.gms.common.internal.safeparcel.a.m(iB)) {
                case 1:
                    iF = com.google.android.gms.common.internal.safeparcel.a.f(parcel, iB);
                    hashSet.add(1);
                    break;
                case 2:
                default:
                    com.google.android.gms.common.internal.safeparcel.a.b(parcel, iB);
                    break;
                case 3:
                    iF2 = com.google.android.gms.common.internal.safeparcel.a.f(parcel, iB);
                    hashSet.add(3);
                    break;
                case 4:
                    strL2 = com.google.android.gms.common.internal.safeparcel.a.l(parcel, iB);
                    hashSet.add(4);
                    break;
                case 5:
                    strL = com.google.android.gms.common.internal.safeparcel.a.l(parcel, iB);
                    hashSet.add(5);
                    break;
                case 6:
                    iF3 = com.google.android.gms.common.internal.safeparcel.a.f(parcel, iB);
                    hashSet.add(6);
                    break;
            }
            iF = iF;
            iF2 = iF2;
            strL2 = strL2;
            strL = strL;
        }
        if (parcel.dataPosition() != iC) {
            throw new a.C0003a("Overread allowed size end=" + iC, parcel);
        }
        return new cc.h(hashSet, iF, strL, iF3, strL2, iF2);
    }

    @Override // android.os.Parcelable.Creator
    /* renamed from: ah, reason: merged with bridge method [inline-methods] */
    public cc.h[] newArray(int i) {
        return new cc.h[i];
    }
}
