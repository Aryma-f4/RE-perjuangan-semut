package com.google.android.gms.internal;

import android.os.Parcel;
import android.os.Parcelable;
import com.google.android.gms.common.internal.safeparcel.a;
import com.google.android.gms.internal.cc;
import java.util.HashSet;
import java.util.Set;

/* loaded from: classes.dex */
public class ch implements Parcelable.Creator<cc.b.C0019b> {
    static void a(cc.b.C0019b c0019b, Parcel parcel, int i) {
        int iD = com.google.android.gms.common.internal.safeparcel.b.d(parcel);
        Set<Integer> setBH = c0019b.bH();
        if (setBH.contains(1)) {
            com.google.android.gms.common.internal.safeparcel.b.c(parcel, 1, c0019b.i());
        }
        if (setBH.contains(2)) {
            com.google.android.gms.common.internal.safeparcel.b.c(parcel, 2, c0019b.getHeight());
        }
        if (setBH.contains(3)) {
            com.google.android.gms.common.internal.safeparcel.b.a(parcel, 3, c0019b.getUrl(), true);
        }
        if (setBH.contains(4)) {
            com.google.android.gms.common.internal.safeparcel.b.c(parcel, 4, c0019b.getWidth());
        }
        com.google.android.gms.common.internal.safeparcel.b.C(parcel, iD);
    }

    @Override // android.os.Parcelable.Creator
    /* renamed from: C, reason: merged with bridge method [inline-methods] */
    public cc.b.C0019b createFromParcel(Parcel parcel) {
        int iF = 0;
        int iC = com.google.android.gms.common.internal.safeparcel.a.c(parcel);
        HashSet hashSet = new HashSet();
        int iF2 = 0;
        String strL = null;
        int iF3 = 0;
        while (parcel.dataPosition() < iC) {
            int iB = com.google.android.gms.common.internal.safeparcel.a.b(parcel);
            switch (com.google.android.gms.common.internal.safeparcel.a.m(iB)) {
                case 1:
                    iF3 = com.google.android.gms.common.internal.safeparcel.a.f(parcel, iB);
                    hashSet.add(1);
                    break;
                case 2:
                    iF = com.google.android.gms.common.internal.safeparcel.a.f(parcel, iB);
                    hashSet.add(2);
                    break;
                case 3:
                    strL = com.google.android.gms.common.internal.safeparcel.a.l(parcel, iB);
                    hashSet.add(3);
                    break;
                case 4:
                    iF2 = com.google.android.gms.common.internal.safeparcel.a.f(parcel, iB);
                    hashSet.add(4);
                    break;
                default:
                    com.google.android.gms.common.internal.safeparcel.a.b(parcel, iB);
                    break;
            }
            iF3 = iF3;
            iF2 = iF2;
            strL = strL;
            iF = iF;
        }
        if (parcel.dataPosition() != iC) {
            throw new a.C0003a("Overread allowed size end=" + iC, parcel);
        }
        return new cc.b.C0019b(hashSet, iF3, iF, strL, iF2);
    }

    @Override // android.os.Parcelable.Creator
    /* renamed from: ac, reason: merged with bridge method [inline-methods] */
    public cc.b.C0019b[] newArray(int i) {
        return new cc.b.C0019b[i];
    }
}
