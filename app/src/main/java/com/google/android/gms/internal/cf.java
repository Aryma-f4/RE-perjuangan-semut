package com.google.android.gms.internal;

import android.os.Parcel;
import android.os.Parcelable;
import com.google.android.gms.common.internal.safeparcel.a;
import com.google.android.gms.internal.cc;
import java.util.HashSet;
import java.util.Set;

/* loaded from: classes.dex */
public class cf implements Parcelable.Creator<cc.b> {
    static void a(cc.b bVar, Parcel parcel, int i) {
        int iD = com.google.android.gms.common.internal.safeparcel.b.d(parcel);
        Set<Integer> setBH = bVar.bH();
        if (setBH.contains(1)) {
            com.google.android.gms.common.internal.safeparcel.b.c(parcel, 1, bVar.i());
        }
        if (setBH.contains(2)) {
            com.google.android.gms.common.internal.safeparcel.b.a(parcel, 2, (Parcelable) bVar.cl(), i, true);
        }
        if (setBH.contains(3)) {
            com.google.android.gms.common.internal.safeparcel.b.a(parcel, 3, (Parcelable) bVar.cm(), i, true);
        }
        if (setBH.contains(4)) {
            com.google.android.gms.common.internal.safeparcel.b.c(parcel, 4, bVar.getLayout());
        }
        com.google.android.gms.common.internal.safeparcel.b.C(parcel, iD);
    }

    @Override // android.os.Parcelable.Creator
    /* renamed from: A, reason: merged with bridge method [inline-methods] */
    public cc.b createFromParcel(Parcel parcel) {
        int i;
        int i2;
        cc.b.C0019b c0019b;
        cc.b.a aVar;
        cc.b.a aVar2 = null;
        int i3 = 0;
        int iC = com.google.android.gms.common.internal.safeparcel.a.c(parcel);
        HashSet hashSet = new HashSet();
        int i4 = 0;
        cc.b.C0019b c0019b2 = null;
        while (parcel.dataPosition() < iC) {
            int iB = com.google.android.gms.common.internal.safeparcel.a.b(parcel);
            switch (com.google.android.gms.common.internal.safeparcel.a.m(iB)) {
                case 1:
                    int iF = com.google.android.gms.common.internal.safeparcel.a.f(parcel, iB);
                    hashSet.add(1);
                    int i5 = i4;
                    i = iF;
                    i2 = i5;
                    cc.b.a aVar3 = aVar2;
                    c0019b = c0019b2;
                    aVar = aVar3;
                    break;
                case 2:
                    cc.b.a aVar4 = (cc.b.a) com.google.android.gms.common.internal.safeparcel.a.a(parcel, iB, cc.b.a.CREATOR);
                    hashSet.add(2);
                    c0019b = c0019b2;
                    aVar = aVar4;
                    int i6 = i4;
                    i = i3;
                    i2 = i6;
                    break;
                case 3:
                    cc.b.C0019b c0019b3 = (cc.b.C0019b) com.google.android.gms.common.internal.safeparcel.a.a(parcel, iB, cc.b.C0019b.CREATOR);
                    hashSet.add(3);
                    aVar = aVar2;
                    c0019b = c0019b3;
                    int i7 = i4;
                    i = i3;
                    i2 = i7;
                    break;
                case 4:
                    int iF2 = com.google.android.gms.common.internal.safeparcel.a.f(parcel, iB);
                    hashSet.add(4);
                    i = i3;
                    i2 = iF2;
                    cc.b.a aVar5 = aVar2;
                    c0019b = c0019b2;
                    aVar = aVar5;
                    break;
                default:
                    com.google.android.gms.common.internal.safeparcel.a.b(parcel, iB);
                    int i8 = i4;
                    i = i3;
                    i2 = i8;
                    cc.b.a aVar6 = aVar2;
                    c0019b = c0019b2;
                    aVar = aVar6;
                    break;
            }
            int i9 = i2;
            i3 = i;
            i4 = i9;
            cc.b.a aVar7 = aVar;
            c0019b2 = c0019b;
            aVar2 = aVar7;
        }
        if (parcel.dataPosition() != iC) {
            throw new a.C0003a("Overread allowed size end=" + iC, parcel);
        }
        return new cc.b(hashSet, i3, aVar2, c0019b2, i4);
    }

    @Override // android.os.Parcelable.Creator
    /* renamed from: aa, reason: merged with bridge method [inline-methods] */
    public cc.b[] newArray(int i) {
        return new cc.b[i];
    }
}
