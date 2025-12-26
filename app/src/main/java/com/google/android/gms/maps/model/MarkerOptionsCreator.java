package com.google.android.gms.maps.model;

import android.os.IBinder;
import android.os.Parcel;
import android.os.Parcelable;
import com.google.android.gms.common.internal.safeparcel.a;

/* loaded from: classes.dex */
public class MarkerOptionsCreator implements Parcelable.Creator<MarkerOptions> {
    public static final int CONTENT_DESCRIPTION = 0;

    static void a(MarkerOptions markerOptions, Parcel parcel, int i) {
        int iD = com.google.android.gms.common.internal.safeparcel.b.d(parcel);
        com.google.android.gms.common.internal.safeparcel.b.c(parcel, 1, markerOptions.i());
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 2, (Parcelable) markerOptions.getPosition(), i, false);
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 3, markerOptions.getTitle(), false);
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 4, markerOptions.getSnippet(), false);
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 5, markerOptions.bq(), false);
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 6, markerOptions.getAnchorU());
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 7, markerOptions.getAnchorV());
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 8, markerOptions.isDraggable());
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 9, markerOptions.isVisible());
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 10, markerOptions.isFlat());
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 11, markerOptions.getRotation());
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 12, markerOptions.getInfoWindowAnchorU());
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 13, markerOptions.getInfoWindowAnchorV());
        com.google.android.gms.common.internal.safeparcel.b.C(parcel, iD);
    }

    /* JADX WARN: Can't rename method to resolve collision */
    @Override // android.os.Parcelable.Creator
    public MarkerOptions createFromParcel(Parcel parcel) {
        int iF;
        float fI;
        String strL;
        float fI2;
        IBinder iBinderM;
        boolean zC;
        boolean zC2;
        float fI3;
        boolean zC3;
        String strL2;
        float fI4;
        LatLng latLng;
        int iC = com.google.android.gms.common.internal.safeparcel.a.c(parcel);
        int i = 0;
        LatLng latLng2 = null;
        String str = null;
        String str2 = null;
        IBinder iBinder = null;
        float f = 0.0f;
        float fI5 = 0.0f;
        boolean z = false;
        boolean z2 = false;
        boolean z3 = false;
        float f2 = 0.0f;
        float f3 = 0.5f;
        float f4 = 0.0f;
        while (parcel.dataPosition() < iC) {
            int iB = com.google.android.gms.common.internal.safeparcel.a.b(parcel);
            switch (com.google.android.gms.common.internal.safeparcel.a.m(iB)) {
                case 1:
                    float f5 = f4;
                    iF = com.google.android.gms.common.internal.safeparcel.a.f(parcel, iB);
                    fI = f5;
                    float f6 = f2;
                    strL = str;
                    fI2 = f6;
                    boolean z4 = z2;
                    iBinderM = iBinder;
                    zC = z4;
                    float f7 = f;
                    zC2 = z;
                    fI3 = f7;
                    String str3 = str2;
                    zC3 = z3;
                    strL2 = str3;
                    LatLng latLng3 = latLng2;
                    fI4 = f3;
                    latLng = latLng3;
                    break;
                case 2:
                    fI4 = f3;
                    latLng = (LatLng) com.google.android.gms.common.internal.safeparcel.a.a(parcel, iB, LatLng.CREATOR);
                    float f8 = f2;
                    strL = str;
                    fI2 = f8;
                    boolean z5 = z2;
                    iBinderM = iBinder;
                    zC = z5;
                    float f9 = f;
                    zC2 = z;
                    fI3 = f9;
                    String str4 = str2;
                    zC3 = z3;
                    strL2 = str4;
                    float f10 = f4;
                    iF = i;
                    fI = f10;
                    break;
                case 3:
                    float f11 = f4;
                    iF = i;
                    fI = f11;
                    float f12 = f2;
                    strL = com.google.android.gms.common.internal.safeparcel.a.l(parcel, iB);
                    fI2 = f12;
                    boolean z6 = z2;
                    iBinderM = iBinder;
                    zC = z6;
                    float f13 = f;
                    zC2 = z;
                    fI3 = f13;
                    String str5 = str2;
                    zC3 = z3;
                    strL2 = str5;
                    LatLng latLng4 = latLng2;
                    fI4 = f3;
                    latLng = latLng4;
                    break;
                case 4:
                    float f14 = f4;
                    iF = i;
                    fI = f14;
                    float f15 = f2;
                    strL = str;
                    fI2 = f15;
                    boolean z7 = z2;
                    iBinderM = iBinder;
                    zC = z7;
                    float f16 = f;
                    zC2 = z;
                    fI3 = f16;
                    zC3 = z3;
                    strL2 = com.google.android.gms.common.internal.safeparcel.a.l(parcel, iB);
                    LatLng latLng5 = latLng2;
                    fI4 = f3;
                    latLng = latLng5;
                    break;
                case 5:
                    float f17 = f4;
                    iF = i;
                    fI = f17;
                    float f18 = f2;
                    strL = str;
                    fI2 = f18;
                    boolean z8 = z2;
                    iBinderM = com.google.android.gms.common.internal.safeparcel.a.m(parcel, iB);
                    zC = z8;
                    float f19 = f;
                    zC2 = z;
                    fI3 = f19;
                    String str6 = str2;
                    zC3 = z3;
                    strL2 = str6;
                    LatLng latLng6 = latLng2;
                    fI4 = f3;
                    latLng = latLng6;
                    break;
                case 6:
                    float f20 = f4;
                    iF = i;
                    fI = f20;
                    float f21 = f2;
                    strL = str;
                    fI2 = f21;
                    boolean z9 = z2;
                    iBinderM = iBinder;
                    zC = z9;
                    zC2 = z;
                    fI3 = com.google.android.gms.common.internal.safeparcel.a.i(parcel, iB);
                    String str7 = str2;
                    zC3 = z3;
                    strL2 = str7;
                    LatLng latLng7 = latLng2;
                    fI4 = f3;
                    latLng = latLng7;
                    break;
                case 7:
                    fI5 = com.google.android.gms.common.internal.safeparcel.a.i(parcel, iB);
                    float f22 = f4;
                    iF = i;
                    fI = f22;
                    float f23 = f2;
                    strL = str;
                    fI2 = f23;
                    boolean z10 = z2;
                    iBinderM = iBinder;
                    zC = z10;
                    float f24 = f;
                    zC2 = z;
                    fI3 = f24;
                    String str8 = str2;
                    zC3 = z3;
                    strL2 = str8;
                    LatLng latLng8 = latLng2;
                    fI4 = f3;
                    latLng = latLng8;
                    break;
                case 8:
                    float f25 = f4;
                    iF = i;
                    fI = f25;
                    float f26 = f2;
                    strL = str;
                    fI2 = f26;
                    boolean z11 = z2;
                    iBinderM = iBinder;
                    zC = z11;
                    float f27 = f;
                    zC2 = com.google.android.gms.common.internal.safeparcel.a.c(parcel, iB);
                    fI3 = f27;
                    String str9 = str2;
                    zC3 = z3;
                    strL2 = str9;
                    LatLng latLng9 = latLng2;
                    fI4 = f3;
                    latLng = latLng9;
                    break;
                case 9:
                    float f28 = f4;
                    iF = i;
                    fI = f28;
                    float f29 = f2;
                    strL = str;
                    fI2 = f29;
                    iBinderM = iBinder;
                    zC = com.google.android.gms.common.internal.safeparcel.a.c(parcel, iB);
                    float f30 = f;
                    zC2 = z;
                    fI3 = f30;
                    String str10 = str2;
                    zC3 = z3;
                    strL2 = str10;
                    LatLng latLng10 = latLng2;
                    fI4 = f3;
                    latLng = latLng10;
                    break;
                case 10:
                    float f31 = f4;
                    iF = i;
                    fI = f31;
                    float f32 = f2;
                    strL = str;
                    fI2 = f32;
                    boolean z12 = z2;
                    iBinderM = iBinder;
                    zC = z12;
                    float f33 = f;
                    zC2 = z;
                    fI3 = f33;
                    String str11 = str2;
                    zC3 = com.google.android.gms.common.internal.safeparcel.a.c(parcel, iB);
                    strL2 = str11;
                    LatLng latLng11 = latLng2;
                    fI4 = f3;
                    latLng = latLng11;
                    break;
                case 11:
                    float f34 = f4;
                    iF = i;
                    fI = f34;
                    strL = str;
                    fI2 = com.google.android.gms.common.internal.safeparcel.a.i(parcel, iB);
                    boolean z13 = z2;
                    iBinderM = iBinder;
                    zC = z13;
                    float f35 = f;
                    zC2 = z;
                    fI3 = f35;
                    String str12 = str2;
                    zC3 = z3;
                    strL2 = str12;
                    LatLng latLng12 = latLng2;
                    fI4 = f3;
                    latLng = latLng12;
                    break;
                case 12:
                    float f36 = f4;
                    iF = i;
                    fI = f36;
                    float f37 = f2;
                    strL = str;
                    fI2 = f37;
                    boolean z14 = z2;
                    iBinderM = iBinder;
                    zC = z14;
                    float f38 = f;
                    zC2 = z;
                    fI3 = f38;
                    String str13 = str2;
                    zC3 = z3;
                    strL2 = str13;
                    LatLng latLng13 = latLng2;
                    fI4 = com.google.android.gms.common.internal.safeparcel.a.i(parcel, iB);
                    latLng = latLng13;
                    break;
                case 13:
                    iF = i;
                    fI = com.google.android.gms.common.internal.safeparcel.a.i(parcel, iB);
                    float f39 = f2;
                    strL = str;
                    fI2 = f39;
                    boolean z15 = z2;
                    iBinderM = iBinder;
                    zC = z15;
                    float f40 = f;
                    zC2 = z;
                    fI3 = f40;
                    String str14 = str2;
                    zC3 = z3;
                    strL2 = str14;
                    LatLng latLng14 = latLng2;
                    fI4 = f3;
                    latLng = latLng14;
                    break;
                default:
                    com.google.android.gms.common.internal.safeparcel.a.b(parcel, iB);
                    float f41 = f4;
                    iF = i;
                    fI = f41;
                    float f42 = f2;
                    strL = str;
                    fI2 = f42;
                    boolean z16 = z2;
                    iBinderM = iBinder;
                    zC = z16;
                    float f43 = f;
                    zC2 = z;
                    fI3 = f43;
                    String str15 = str2;
                    zC3 = z3;
                    strL2 = str15;
                    LatLng latLng15 = latLng2;
                    fI4 = f3;
                    latLng = latLng15;
                    break;
            }
            float f44 = fI;
            i = iF;
            f4 = f44;
            float f45 = fI2;
            str = strL;
            f2 = f45;
            boolean z17 = zC;
            iBinder = iBinderM;
            z2 = z17;
            float f46 = fI3;
            z = zC2;
            f = f46;
            String str16 = strL2;
            z3 = zC3;
            str2 = str16;
            LatLng latLng16 = latLng;
            f3 = fI4;
            latLng2 = latLng16;
        }
        if (parcel.dataPosition() != iC) {
            throw new a.C0003a("Overread allowed size end=" + iC, parcel);
        }
        return new MarkerOptions(i, latLng2, str, str2, iBinder, f, fI5, z, z2, z3, f2, f3, f4);
    }

    /* JADX WARN: Can't rename method to resolve collision */
    @Override // android.os.Parcelable.Creator
    public MarkerOptions[] newArray(int size) {
        return new MarkerOptions[size];
    }
}
