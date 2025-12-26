package com.google.android.gms.internal;

import android.os.Parcel;
import android.os.Parcelable;
import com.google.android.gms.common.internal.safeparcel.a;
import com.google.android.gms.internal.cc;
import java.util.HashSet;
import java.util.Set;

/* loaded from: classes.dex */
public class cj implements Parcelable.Creator<cc.d> {
    static void a(cc.d dVar, Parcel parcel, int i) {
        int iD = com.google.android.gms.common.internal.safeparcel.b.d(parcel);
        Set<Integer> setBH = dVar.bH();
        if (setBH.contains(1)) {
            com.google.android.gms.common.internal.safeparcel.b.c(parcel, 1, dVar.i());
        }
        if (setBH.contains(2)) {
            com.google.android.gms.common.internal.safeparcel.b.a(parcel, 2, dVar.getFamilyName(), true);
        }
        if (setBH.contains(3)) {
            com.google.android.gms.common.internal.safeparcel.b.a(parcel, 3, dVar.getFormatted(), true);
        }
        if (setBH.contains(4)) {
            com.google.android.gms.common.internal.safeparcel.b.a(parcel, 4, dVar.getGivenName(), true);
        }
        if (setBH.contains(5)) {
            com.google.android.gms.common.internal.safeparcel.b.a(parcel, 5, dVar.getHonorificPrefix(), true);
        }
        if (setBH.contains(6)) {
            com.google.android.gms.common.internal.safeparcel.b.a(parcel, 6, dVar.getHonorificSuffix(), true);
        }
        if (setBH.contains(7)) {
            com.google.android.gms.common.internal.safeparcel.b.a(parcel, 7, dVar.getMiddleName(), true);
        }
        com.google.android.gms.common.internal.safeparcel.b.C(parcel, iD);
    }

    @Override // android.os.Parcelable.Creator
    /* renamed from: E, reason: merged with bridge method [inline-methods] */
    public cc.d createFromParcel(Parcel parcel) {
        String strL = null;
        int iC = com.google.android.gms.common.internal.safeparcel.a.c(parcel);
        HashSet hashSet = new HashSet();
        int iF = 0;
        String strL2 = null;
        String strL3 = null;
        String strL4 = null;
        String strL5 = null;
        String strL6 = null;
        while (parcel.dataPosition() < iC) {
            int iB = com.google.android.gms.common.internal.safeparcel.a.b(parcel);
            switch (com.google.android.gms.common.internal.safeparcel.a.m(iB)) {
                case 1:
                    iF = com.google.android.gms.common.internal.safeparcel.a.f(parcel, iB);
                    hashSet.add(1);
                    break;
                case 2:
                    strL = com.google.android.gms.common.internal.safeparcel.a.l(parcel, iB);
                    hashSet.add(2);
                    break;
                case 3:
                    strL6 = com.google.android.gms.common.internal.safeparcel.a.l(parcel, iB);
                    hashSet.add(3);
                    break;
                case 4:
                    strL5 = com.google.android.gms.common.internal.safeparcel.a.l(parcel, iB);
                    hashSet.add(4);
                    break;
                case 5:
                    strL4 = com.google.android.gms.common.internal.safeparcel.a.l(parcel, iB);
                    hashSet.add(5);
                    break;
                case 6:
                    strL3 = com.google.android.gms.common.internal.safeparcel.a.l(parcel, iB);
                    hashSet.add(6);
                    break;
                case 7:
                    strL2 = com.google.android.gms.common.internal.safeparcel.a.l(parcel, iB);
                    hashSet.add(7);
                    break;
                default:
                    com.google.android.gms.common.internal.safeparcel.a.b(parcel, iB);
                    break;
            }
            iF = iF;
            strL2 = strL2;
            strL6 = strL6;
            strL4 = strL4;
            strL3 = strL3;
            strL = strL;
        }
        if (parcel.dataPosition() != iC) {
            throw new a.C0003a("Overread allowed size end=" + iC, parcel);
        }
        return new cc.d(hashSet, iF, strL, strL6, strL5, strL4, strL3, strL2);
    }

    @Override // android.os.Parcelable.Creator
    /* renamed from: ae, reason: merged with bridge method [inline-methods] */
    public cc.d[] newArray(int i) {
        return new cc.d[i];
    }
}
