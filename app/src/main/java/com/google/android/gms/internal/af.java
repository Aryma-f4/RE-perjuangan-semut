package com.google.android.gms.internal;

import android.os.Parcel;
import android.os.Parcelable;
import com.google.android.gms.common.internal.safeparcel.a;
import com.google.android.gms.internal.ae;

/* loaded from: classes.dex */
public class af implements Parcelable.Creator<ae.a> {
    static void a(ae.a aVar, Parcel parcel, int i) {
        int iD = com.google.android.gms.common.internal.safeparcel.b.d(parcel);
        com.google.android.gms.common.internal.safeparcel.b.c(parcel, 1, aVar.i());
        com.google.android.gms.common.internal.safeparcel.b.c(parcel, 2, aVar.R());
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 3, aVar.X());
        com.google.android.gms.common.internal.safeparcel.b.c(parcel, 4, aVar.S());
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 5, aVar.Y());
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 6, aVar.Z(), false);
        com.google.android.gms.common.internal.safeparcel.b.c(parcel, 7, aVar.aa());
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 8, aVar.ac(), false);
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 9, (Parcelable) aVar.ae(), i, false);
        com.google.android.gms.common.internal.safeparcel.b.C(parcel, iD);
    }

    @Override // android.os.Parcelable.Creator
    /* renamed from: i, reason: merged with bridge method [inline-methods] */
    public ae.a createFromParcel(Parcel parcel) {
        int iF;
        z zVar;
        boolean zC;
        int iF2;
        String strL;
        int iF3;
        String strL2;
        int iF4;
        int iC = com.google.android.gms.common.internal.safeparcel.a.c(parcel);
        int i = 0;
        int i2 = 0;
        boolean z = false;
        int i3 = 0;
        boolean zC2 = false;
        String str = null;
        int i4 = 0;
        String str2 = null;
        z zVar2 = null;
        while (parcel.dataPosition() < iC) {
            int iB = com.google.android.gms.common.internal.safeparcel.a.b(parcel);
            switch (com.google.android.gms.common.internal.safeparcel.a.m(iB)) {
                case 1:
                    z zVar3 = zVar2;
                    iF = com.google.android.gms.common.internal.safeparcel.a.f(parcel, iB);
                    zVar = zVar3;
                    int i5 = i4;
                    zC = z;
                    iF2 = i5;
                    int i6 = i3;
                    strL = str;
                    iF3 = i6;
                    int i7 = i2;
                    strL2 = str2;
                    iF4 = i7;
                    break;
                case 2:
                    z zVar4 = zVar2;
                    iF = i;
                    zVar = zVar4;
                    int i8 = i4;
                    zC = z;
                    iF2 = i8;
                    int i9 = i3;
                    strL = str;
                    iF3 = i9;
                    strL2 = str2;
                    iF4 = com.google.android.gms.common.internal.safeparcel.a.f(parcel, iB);
                    break;
                case 3:
                    z zVar5 = zVar2;
                    iF = i;
                    zVar = zVar5;
                    int i10 = i4;
                    zC = com.google.android.gms.common.internal.safeparcel.a.c(parcel, iB);
                    iF2 = i10;
                    int i11 = i3;
                    strL = str;
                    iF3 = i11;
                    int i12 = i2;
                    strL2 = str2;
                    iF4 = i12;
                    break;
                case 4:
                    z zVar6 = zVar2;
                    iF = i;
                    zVar = zVar6;
                    int i13 = i4;
                    zC = z;
                    iF2 = i13;
                    strL = str;
                    iF3 = com.google.android.gms.common.internal.safeparcel.a.f(parcel, iB);
                    int i14 = i2;
                    strL2 = str2;
                    iF4 = i14;
                    break;
                case 5:
                    zC2 = com.google.android.gms.common.internal.safeparcel.a.c(parcel, iB);
                    z zVar7 = zVar2;
                    iF = i;
                    zVar = zVar7;
                    int i15 = i4;
                    zC = z;
                    iF2 = i15;
                    int i16 = i3;
                    strL = str;
                    iF3 = i16;
                    int i17 = i2;
                    strL2 = str2;
                    iF4 = i17;
                    break;
                case 6:
                    z zVar8 = zVar2;
                    iF = i;
                    zVar = zVar8;
                    int i18 = i4;
                    zC = z;
                    iF2 = i18;
                    int i19 = i3;
                    strL = com.google.android.gms.common.internal.safeparcel.a.l(parcel, iB);
                    iF3 = i19;
                    int i20 = i2;
                    strL2 = str2;
                    iF4 = i20;
                    break;
                case 7:
                    z zVar9 = zVar2;
                    iF = i;
                    zVar = zVar9;
                    zC = z;
                    iF2 = com.google.android.gms.common.internal.safeparcel.a.f(parcel, iB);
                    int i21 = i3;
                    strL = str;
                    iF3 = i21;
                    int i22 = i2;
                    strL2 = str2;
                    iF4 = i22;
                    break;
                case 8:
                    z zVar10 = zVar2;
                    iF = i;
                    zVar = zVar10;
                    int i23 = i4;
                    zC = z;
                    iF2 = i23;
                    int i24 = i3;
                    strL = str;
                    iF3 = i24;
                    int i25 = i2;
                    strL2 = com.google.android.gms.common.internal.safeparcel.a.l(parcel, iB);
                    iF4 = i25;
                    break;
                case 9:
                    iF = i;
                    zVar = (z) com.google.android.gms.common.internal.safeparcel.a.a(parcel, iB, z.CREATOR);
                    int i26 = i4;
                    zC = z;
                    iF2 = i26;
                    int i27 = i3;
                    strL = str;
                    iF3 = i27;
                    int i28 = i2;
                    strL2 = str2;
                    iF4 = i28;
                    break;
                default:
                    com.google.android.gms.common.internal.safeparcel.a.b(parcel, iB);
                    z zVar11 = zVar2;
                    iF = i;
                    zVar = zVar11;
                    int i29 = i4;
                    zC = z;
                    iF2 = i29;
                    int i30 = i3;
                    strL = str;
                    iF3 = i30;
                    int i31 = i2;
                    strL2 = str2;
                    iF4 = i31;
                    break;
            }
            z zVar12 = zVar;
            i = iF;
            zVar2 = zVar12;
            int i32 = iF2;
            z = zC;
            i4 = i32;
            int i33 = iF3;
            str = strL;
            i3 = i33;
            int i34 = iF4;
            str2 = strL2;
            i2 = i34;
        }
        if (parcel.dataPosition() != iC) {
            throw new a.C0003a("Overread allowed size end=" + iC, parcel);
        }
        return new ae.a(i, i2, z, i3, zC2, str, i4, str2, zVar2);
    }

    @Override // android.os.Parcelable.Creator
    /* renamed from: r, reason: merged with bridge method [inline-methods] */
    public ae.a[] newArray(int i) {
        return new ae.a[i];
    }
}
