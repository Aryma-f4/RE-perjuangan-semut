package com.google.android.gms.internal;

import android.os.Parcel;
import android.os.Parcelable;
import com.google.android.gms.common.internal.safeparcel.a;
import java.util.HashSet;
import java.util.Set;

/* loaded from: classes.dex */
public class ca implements Parcelable.Creator<bz> {
    static void a(bz bzVar, Parcel parcel, int i) {
        int iD = com.google.android.gms.common.internal.safeparcel.b.d(parcel);
        Set<Integer> setBH = bzVar.bH();
        if (setBH.contains(1)) {
            com.google.android.gms.common.internal.safeparcel.b.c(parcel, 1, bzVar.i());
        }
        if (setBH.contains(2)) {
            com.google.android.gms.common.internal.safeparcel.b.a(parcel, 2, bzVar.getId(), true);
        }
        if (setBH.contains(4)) {
            com.google.android.gms.common.internal.safeparcel.b.a(parcel, 4, (Parcelable) bzVar.bY(), i, true);
        }
        if (setBH.contains(5)) {
            com.google.android.gms.common.internal.safeparcel.b.a(parcel, 5, bzVar.getStartDate(), true);
        }
        if (setBH.contains(6)) {
            com.google.android.gms.common.internal.safeparcel.b.a(parcel, 6, (Parcelable) bzVar.bZ(), i, true);
        }
        if (setBH.contains(7)) {
            com.google.android.gms.common.internal.safeparcel.b.a(parcel, 7, bzVar.getType(), true);
        }
        com.google.android.gms.common.internal.safeparcel.b.C(parcel, iD);
    }

    @Override // android.os.Parcelable.Creator
    /* renamed from: X, reason: merged with bridge method [inline-methods] */
    public bz[] newArray(int i) {
        return new bz[i];
    }

    @Override // android.os.Parcelable.Creator
    /* renamed from: x, reason: merged with bridge method [inline-methods] */
    public bz createFromParcel(Parcel parcel) {
        int i;
        String str;
        bx bxVar;
        String str2;
        bx bxVar2;
        String str3;
        String str4 = null;
        int iC = com.google.android.gms.common.internal.safeparcel.a.c(parcel);
        HashSet hashSet = new HashSet();
        int i2 = 0;
        String str5 = null;
        bx bxVar3 = null;
        String str6 = null;
        bx bxVar4 = null;
        while (parcel.dataPosition() < iC) {
            int iB = com.google.android.gms.common.internal.safeparcel.a.b(parcel);
            switch (com.google.android.gms.common.internal.safeparcel.a.m(iB)) {
                case 1:
                    int iF = com.google.android.gms.common.internal.safeparcel.a.f(parcel, iB);
                    hashSet.add(1);
                    String str7 = str5;
                    i = iF;
                    str = str7;
                    String str8 = str6;
                    bxVar = bxVar4;
                    str2 = str8;
                    String str9 = str4;
                    bxVar2 = bxVar3;
                    str3 = str9;
                    break;
                case 2:
                    String strL = com.google.android.gms.common.internal.safeparcel.a.l(parcel, iB);
                    hashSet.add(2);
                    String str10 = str5;
                    i = i2;
                    str = str10;
                    String str11 = str6;
                    bxVar = bxVar4;
                    str2 = str11;
                    bxVar2 = bxVar3;
                    str3 = strL;
                    break;
                case 3:
                default:
                    com.google.android.gms.common.internal.safeparcel.a.b(parcel, iB);
                    String str12 = str5;
                    i = i2;
                    str = str12;
                    String str13 = str6;
                    bxVar = bxVar4;
                    str2 = str13;
                    String str14 = str4;
                    bxVar2 = bxVar3;
                    str3 = str14;
                    break;
                case 4:
                    bx bxVar5 = (bx) com.google.android.gms.common.internal.safeparcel.a.a(parcel, iB, bx.CREATOR);
                    hashSet.add(4);
                    str2 = str6;
                    bxVar = bxVar5;
                    String str15 = str5;
                    i = i2;
                    str = str15;
                    String str16 = str4;
                    bxVar2 = bxVar3;
                    str3 = str16;
                    break;
                case 5:
                    String strL2 = com.google.android.gms.common.internal.safeparcel.a.l(parcel, iB);
                    hashSet.add(5);
                    String str17 = str5;
                    i = i2;
                    str = str17;
                    bxVar = bxVar4;
                    str2 = strL2;
                    String str18 = str4;
                    bxVar2 = bxVar3;
                    str3 = str18;
                    break;
                case 6:
                    bx bxVar6 = (bx) com.google.android.gms.common.internal.safeparcel.a.a(parcel, iB, bx.CREATOR);
                    hashSet.add(6);
                    str3 = str4;
                    bxVar2 = bxVar6;
                    String str19 = str6;
                    bxVar = bxVar4;
                    str2 = str19;
                    String str20 = str5;
                    i = i2;
                    str = str20;
                    break;
                case 7:
                    String strL3 = com.google.android.gms.common.internal.safeparcel.a.l(parcel, iB);
                    hashSet.add(7);
                    i = i2;
                    str = strL3;
                    String str21 = str6;
                    bxVar = bxVar4;
                    str2 = str21;
                    String str22 = str4;
                    bxVar2 = bxVar3;
                    str3 = str22;
                    break;
            }
            String str23 = str;
            i2 = i;
            str5 = str23;
            String str24 = str2;
            bxVar4 = bxVar;
            str6 = str24;
            String str25 = str3;
            bxVar3 = bxVar2;
            str4 = str25;
        }
        if (parcel.dataPosition() != iC) {
            throw new a.C0003a("Overread allowed size end=" + iC, parcel);
        }
        return new bz(hashSet, i2, str4, bxVar4, str6, bxVar3, str5);
    }
}
