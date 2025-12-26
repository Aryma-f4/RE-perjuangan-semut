package com.google.android.gms.internal;

import android.net.Uri;
import android.os.Bundle;
import android.os.Parcel;
import android.os.Parcelable;
import com.google.android.gms.common.internal.safeparcel.a;
import java.util.ArrayList;

/* loaded from: classes.dex */
public class cp implements Parcelable.Creator<co> {
    static void a(co coVar, Parcel parcel, int i) {
        int iD = com.google.android.gms.common.internal.safeparcel.b.d(parcel);
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 1, coVar.getId(), false);
        com.google.android.gms.common.internal.safeparcel.b.c(parcel, 1000, coVar.i());
        com.google.android.gms.common.internal.safeparcel.b.b(parcel, 2, coVar.cB(), false);
        com.google.android.gms.common.internal.safeparcel.b.b(parcel, 3, coVar.cC(), false);
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 4, (Parcelable) coVar.cD(), i, false);
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 5, coVar.cE(), false);
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 6, coVar.cF(), false);
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 7, coVar.cG(), false);
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 8, coVar.cH(), false);
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 9, coVar.cI(), false);
        com.google.android.gms.common.internal.safeparcel.b.c(parcel, 10, coVar.cJ());
        com.google.android.gms.common.internal.safeparcel.b.C(parcel, iD);
    }

    @Override // android.os.Parcelable.Creator
    /* renamed from: I, reason: merged with bridge method [inline-methods] */
    public co createFromParcel(Parcel parcel) {
        int iF;
        int iF2;
        ArrayList arrayListC;
        Bundle bundleN;
        Uri uri;
        String strL;
        String strL2;
        ArrayList arrayListC2;
        Bundle bundleN2;
        String strL3;
        int iC = com.google.android.gms.common.internal.safeparcel.a.c(parcel);
        int i = 0;
        String str = null;
        ArrayList arrayList = null;
        ArrayList arrayList2 = null;
        Uri uri2 = null;
        String strL4 = null;
        String str2 = null;
        String str3 = null;
        Bundle bundle = null;
        Bundle bundle2 = null;
        int i2 = 0;
        while (parcel.dataPosition() < iC) {
            int iB = com.google.android.gms.common.internal.safeparcel.a.b(parcel);
            switch (com.google.android.gms.common.internal.safeparcel.a.m(iB)) {
                case 1:
                    int i3 = i2;
                    iF = i;
                    iF2 = i3;
                    Bundle bundle3 = bundle;
                    arrayListC = arrayList;
                    bundleN = bundle3;
                    String str4 = str2;
                    uri = uri2;
                    strL = str4;
                    ArrayList arrayList3 = arrayList2;
                    strL2 = str3;
                    arrayListC2 = arrayList3;
                    bundleN2 = bundle2;
                    strL3 = com.google.android.gms.common.internal.safeparcel.a.l(parcel, iB);
                    break;
                case 2:
                    int i4 = i2;
                    iF = i;
                    iF2 = i4;
                    Bundle bundle4 = bundle;
                    arrayListC = com.google.android.gms.common.internal.safeparcel.a.c(parcel, iB, x.CREATOR);
                    bundleN = bundle4;
                    String str5 = str2;
                    uri = uri2;
                    strL = str5;
                    ArrayList arrayList4 = arrayList2;
                    strL2 = str3;
                    arrayListC2 = arrayList4;
                    String str6 = str;
                    bundleN2 = bundle2;
                    strL3 = str6;
                    break;
                case 3:
                    int i5 = i2;
                    iF = i;
                    iF2 = i5;
                    Bundle bundle5 = bundle;
                    arrayListC = arrayList;
                    bundleN = bundle5;
                    String str7 = str2;
                    uri = uri2;
                    strL = str7;
                    strL2 = str3;
                    arrayListC2 = com.google.android.gms.common.internal.safeparcel.a.c(parcel, iB, Uri.CREATOR);
                    String str8 = str;
                    bundleN2 = bundle2;
                    strL3 = str8;
                    break;
                case 4:
                    strL = str2;
                    uri = (Uri) com.google.android.gms.common.internal.safeparcel.a.a(parcel, iB, Uri.CREATOR);
                    Bundle bundle6 = bundle;
                    arrayListC = arrayList;
                    bundleN = bundle6;
                    int i6 = i2;
                    iF = i;
                    iF2 = i6;
                    ArrayList arrayList5 = arrayList2;
                    strL2 = str3;
                    arrayListC2 = arrayList5;
                    String str9 = str;
                    bundleN2 = bundle2;
                    strL3 = str9;
                    break;
                case 5:
                    strL4 = com.google.android.gms.common.internal.safeparcel.a.l(parcel, iB);
                    int i7 = i2;
                    iF = i;
                    iF2 = i7;
                    Bundle bundle7 = bundle;
                    arrayListC = arrayList;
                    bundleN = bundle7;
                    String str10 = str2;
                    uri = uri2;
                    strL = str10;
                    ArrayList arrayList6 = arrayList2;
                    strL2 = str3;
                    arrayListC2 = arrayList6;
                    String str11 = str;
                    bundleN2 = bundle2;
                    strL3 = str11;
                    break;
                case 6:
                    int i8 = i2;
                    iF = i;
                    iF2 = i8;
                    Bundle bundle8 = bundle;
                    arrayListC = arrayList;
                    bundleN = bundle8;
                    uri = uri2;
                    strL = com.google.android.gms.common.internal.safeparcel.a.l(parcel, iB);
                    ArrayList arrayList7 = arrayList2;
                    strL2 = str3;
                    arrayListC2 = arrayList7;
                    String str12 = str;
                    bundleN2 = bundle2;
                    strL3 = str12;
                    break;
                case 7:
                    int i9 = i2;
                    iF = i;
                    iF2 = i9;
                    Bundle bundle9 = bundle;
                    arrayListC = arrayList;
                    bundleN = bundle9;
                    String str13 = str2;
                    uri = uri2;
                    strL = str13;
                    ArrayList arrayList8 = arrayList2;
                    strL2 = com.google.android.gms.common.internal.safeparcel.a.l(parcel, iB);
                    arrayListC2 = arrayList8;
                    String str14 = str;
                    bundleN2 = bundle2;
                    strL3 = str14;
                    break;
                case 8:
                    int i10 = i2;
                    iF = i;
                    iF2 = i10;
                    arrayListC = arrayList;
                    bundleN = com.google.android.gms.common.internal.safeparcel.a.n(parcel, iB);
                    String str15 = str2;
                    uri = uri2;
                    strL = str15;
                    ArrayList arrayList9 = arrayList2;
                    strL2 = str3;
                    arrayListC2 = arrayList9;
                    String str16 = str;
                    bundleN2 = bundle2;
                    strL3 = str16;
                    break;
                case 9:
                    int i11 = i2;
                    iF = i;
                    iF2 = i11;
                    Bundle bundle10 = bundle;
                    arrayListC = arrayList;
                    bundleN = bundle10;
                    String str17 = str2;
                    uri = uri2;
                    strL = str17;
                    ArrayList arrayList10 = arrayList2;
                    strL2 = str3;
                    arrayListC2 = arrayList10;
                    String str18 = str;
                    bundleN2 = com.google.android.gms.common.internal.safeparcel.a.n(parcel, iB);
                    strL3 = str18;
                    break;
                case 10:
                    iF = i;
                    iF2 = com.google.android.gms.common.internal.safeparcel.a.f(parcel, iB);
                    Bundle bundle11 = bundle;
                    arrayListC = arrayList;
                    bundleN = bundle11;
                    String str19 = str2;
                    uri = uri2;
                    strL = str19;
                    ArrayList arrayList11 = arrayList2;
                    strL2 = str3;
                    arrayListC2 = arrayList11;
                    String str20 = str;
                    bundleN2 = bundle2;
                    strL3 = str20;
                    break;
                case 1000:
                    int i12 = i2;
                    iF = com.google.android.gms.common.internal.safeparcel.a.f(parcel, iB);
                    iF2 = i12;
                    Bundle bundle12 = bundle;
                    arrayListC = arrayList;
                    bundleN = bundle12;
                    String str21 = str2;
                    uri = uri2;
                    strL = str21;
                    ArrayList arrayList12 = arrayList2;
                    strL2 = str3;
                    arrayListC2 = arrayList12;
                    String str22 = str;
                    bundleN2 = bundle2;
                    strL3 = str22;
                    break;
                default:
                    com.google.android.gms.common.internal.safeparcel.a.b(parcel, iB);
                    int i13 = i2;
                    iF = i;
                    iF2 = i13;
                    Bundle bundle13 = bundle;
                    arrayListC = arrayList;
                    bundleN = bundle13;
                    String str23 = str2;
                    uri = uri2;
                    strL = str23;
                    ArrayList arrayList13 = arrayList2;
                    strL2 = str3;
                    arrayListC2 = arrayList13;
                    String str24 = str;
                    bundleN2 = bundle2;
                    strL3 = str24;
                    break;
            }
            int i14 = iF2;
            i = iF;
            i2 = i14;
            Bundle bundle14 = bundleN;
            arrayList = arrayListC;
            bundle = bundle14;
            String str25 = strL;
            uri2 = uri;
            str2 = str25;
            ArrayList arrayList14 = arrayListC2;
            str3 = strL2;
            arrayList2 = arrayList14;
            String str26 = strL3;
            bundle2 = bundleN2;
            str = str26;
        }
        if (parcel.dataPosition() != iC) {
            throw new a.C0003a("Overread allowed size end=" + iC, parcel);
        }
        return new co(i, str, arrayList, arrayList2, uri2, strL4, str2, str3, bundle, bundle2, i2);
    }

    @Override // android.os.Parcelable.Creator
    /* renamed from: ai, reason: merged with bridge method [inline-methods] */
    public co[] newArray(int i) {
        return new co[i];
    }
}
