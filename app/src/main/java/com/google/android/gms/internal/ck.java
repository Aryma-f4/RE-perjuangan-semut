package com.google.android.gms.internal;

import android.os.Parcel;
import android.os.Parcelable;
import com.google.android.gms.common.internal.safeparcel.a;
import com.google.android.gms.internal.cc;
import java.util.HashSet;
import java.util.Set;

/* loaded from: classes.dex */
public class ck implements Parcelable.Creator<cc.f> {
    static void a(cc.f fVar, Parcel parcel, int i) {
        int iD = com.google.android.gms.common.internal.safeparcel.b.d(parcel);
        Set<Integer> setBH = fVar.bH();
        if (setBH.contains(1)) {
            com.google.android.gms.common.internal.safeparcel.b.c(parcel, 1, fVar.i());
        }
        if (setBH.contains(2)) {
            com.google.android.gms.common.internal.safeparcel.b.a(parcel, 2, fVar.getDepartment(), true);
        }
        if (setBH.contains(3)) {
            com.google.android.gms.common.internal.safeparcel.b.a(parcel, 3, fVar.getDescription(), true);
        }
        if (setBH.contains(4)) {
            com.google.android.gms.common.internal.safeparcel.b.a(parcel, 4, fVar.getEndDate(), true);
        }
        if (setBH.contains(5)) {
            com.google.android.gms.common.internal.safeparcel.b.a(parcel, 5, fVar.getLocation(), true);
        }
        if (setBH.contains(6)) {
            com.google.android.gms.common.internal.safeparcel.b.a(parcel, 6, fVar.getName(), true);
        }
        if (setBH.contains(7)) {
            com.google.android.gms.common.internal.safeparcel.b.a(parcel, 7, fVar.isPrimary());
        }
        if (setBH.contains(8)) {
            com.google.android.gms.common.internal.safeparcel.b.a(parcel, 8, fVar.getStartDate(), true);
        }
        if (setBH.contains(9)) {
            com.google.android.gms.common.internal.safeparcel.b.a(parcel, 9, fVar.getTitle(), true);
        }
        if (setBH.contains(10)) {
            com.google.android.gms.common.internal.safeparcel.b.c(parcel, 10, fVar.getType());
        }
        com.google.android.gms.common.internal.safeparcel.b.C(parcel, iD);
    }

    @Override // android.os.Parcelable.Creator
    /* renamed from: F, reason: merged with bridge method [inline-methods] */
    public cc.f createFromParcel(Parcel parcel) {
        int iC = com.google.android.gms.common.internal.safeparcel.a.c(parcel);
        HashSet hashSet = new HashSet();
        int iF = 0;
        String strL = null;
        String strL2 = null;
        String strL3 = null;
        String strL4 = null;
        String strL5 = null;
        boolean zC = false;
        String strL6 = null;
        String strL7 = null;
        int iF2 = 0;
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
                    strL2 = com.google.android.gms.common.internal.safeparcel.a.l(parcel, iB);
                    hashSet.add(3);
                    break;
                case 4:
                    strL3 = com.google.android.gms.common.internal.safeparcel.a.l(parcel, iB);
                    hashSet.add(4);
                    break;
                case 5:
                    strL4 = com.google.android.gms.common.internal.safeparcel.a.l(parcel, iB);
                    hashSet.add(5);
                    break;
                case 6:
                    strL5 = com.google.android.gms.common.internal.safeparcel.a.l(parcel, iB);
                    hashSet.add(6);
                    break;
                case 7:
                    zC = com.google.android.gms.common.internal.safeparcel.a.c(parcel, iB);
                    hashSet.add(7);
                    break;
                case 8:
                    strL6 = com.google.android.gms.common.internal.safeparcel.a.l(parcel, iB);
                    hashSet.add(8);
                    break;
                case 9:
                    strL7 = com.google.android.gms.common.internal.safeparcel.a.l(parcel, iB);
                    hashSet.add(9);
                    break;
                case 10:
                    iF2 = com.google.android.gms.common.internal.safeparcel.a.f(parcel, iB);
                    hashSet.add(10);
                    break;
                default:
                    com.google.android.gms.common.internal.safeparcel.a.b(parcel, iB);
                    break;
            }
            iF = iF;
            iF2 = iF2;
            strL2 = strL2;
            strL6 = strL6;
            strL4 = strL4;
            strL5 = strL5;
            zC = zC;
            strL3 = strL3;
            strL7 = strL7;
            strL = strL;
        }
        if (parcel.dataPosition() != iC) {
            throw new a.C0003a("Overread allowed size end=" + iC, parcel);
        }
        return new cc.f(hashSet, iF, strL, strL2, strL3, strL4, strL5, zC, strL6, strL7, iF2);
    }

    @Override // android.os.Parcelable.Creator
    /* renamed from: af, reason: merged with bridge method [inline-methods] */
    public cc.f[] newArray(int i) {
        return new cc.f[i];
    }
}
