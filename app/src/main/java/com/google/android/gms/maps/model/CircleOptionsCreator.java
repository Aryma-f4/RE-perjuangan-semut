package com.google.android.gms.maps.model;

import android.os.Parcel;
import android.os.Parcelable;
import com.google.android.gms.common.internal.safeparcel.a;

/* loaded from: classes.dex */
public class CircleOptionsCreator implements Parcelable.Creator<CircleOptions> {
    public static final int CONTENT_DESCRIPTION = 0;

    static void a(CircleOptions circleOptions, Parcel parcel, int i) {
        int iD = com.google.android.gms.common.internal.safeparcel.b.d(parcel);
        com.google.android.gms.common.internal.safeparcel.b.c(parcel, 1, circleOptions.i());
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 2, (Parcelable) circleOptions.getCenter(), i, false);
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 3, circleOptions.getRadius());
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 4, circleOptions.getStrokeWidth());
        com.google.android.gms.common.internal.safeparcel.b.c(parcel, 5, circleOptions.getStrokeColor());
        com.google.android.gms.common.internal.safeparcel.b.c(parcel, 6, circleOptions.getFillColor());
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 7, circleOptions.getZIndex());
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 8, circleOptions.isVisible());
        com.google.android.gms.common.internal.safeparcel.b.C(parcel, iD);
    }

    /* JADX WARN: Can't rename method to resolve collision */
    @Override // android.os.Parcelable.Creator
    public CircleOptions createFromParcel(Parcel parcel) {
        int iF;
        boolean zC;
        double dJ;
        int iF2;
        int iF3;
        float fI;
        LatLng latLng;
        int iC = com.google.android.gms.common.internal.safeparcel.a.c(parcel);
        int i = 0;
        LatLng latLng2 = null;
        double d = 0.0d;
        float fI2 = 0.0f;
        int i2 = 0;
        int i3 = 0;
        float f = 0.0f;
        boolean z = false;
        while (parcel.dataPosition() < iC) {
            int iB = com.google.android.gms.common.internal.safeparcel.a.b(parcel);
            switch (com.google.android.gms.common.internal.safeparcel.a.m(iB)) {
                case 1:
                    boolean z2 = z;
                    iF = com.google.android.gms.common.internal.safeparcel.a.f(parcel, iB);
                    zC = z2;
                    int i4 = i2;
                    dJ = d;
                    iF2 = i3;
                    iF3 = i4;
                    LatLng latLng3 = latLng2;
                    fI = f;
                    latLng = latLng3;
                    break;
                case 2:
                    fI = f;
                    latLng = (LatLng) com.google.android.gms.common.internal.safeparcel.a.a(parcel, iB, LatLng.CREATOR);
                    int i5 = i2;
                    dJ = d;
                    iF2 = i3;
                    iF3 = i5;
                    boolean z3 = z;
                    iF = i;
                    zC = z3;
                    break;
                case 3:
                    boolean z4 = z;
                    iF = i;
                    zC = z4;
                    int i6 = i2;
                    dJ = com.google.android.gms.common.internal.safeparcel.a.j(parcel, iB);
                    iF2 = i3;
                    iF3 = i6;
                    LatLng latLng4 = latLng2;
                    fI = f;
                    latLng = latLng4;
                    break;
                case 4:
                    fI2 = com.google.android.gms.common.internal.safeparcel.a.i(parcel, iB);
                    boolean z5 = z;
                    iF = i;
                    zC = z5;
                    int i7 = i2;
                    dJ = d;
                    iF2 = i3;
                    iF3 = i7;
                    LatLng latLng5 = latLng2;
                    fI = f;
                    latLng = latLng5;
                    break;
                case 5:
                    boolean z6 = z;
                    iF = i;
                    zC = z6;
                    dJ = d;
                    iF2 = i3;
                    iF3 = com.google.android.gms.common.internal.safeparcel.a.f(parcel, iB);
                    LatLng latLng6 = latLng2;
                    fI = f;
                    latLng = latLng6;
                    break;
                case 6:
                    boolean z7 = z;
                    iF = i;
                    zC = z7;
                    int i8 = i2;
                    dJ = d;
                    iF2 = com.google.android.gms.common.internal.safeparcel.a.f(parcel, iB);
                    iF3 = i8;
                    LatLng latLng7 = latLng2;
                    fI = f;
                    latLng = latLng7;
                    break;
                case 7:
                    boolean z8 = z;
                    iF = i;
                    zC = z8;
                    int i9 = i2;
                    dJ = d;
                    iF2 = i3;
                    iF3 = i9;
                    LatLng latLng8 = latLng2;
                    fI = com.google.android.gms.common.internal.safeparcel.a.i(parcel, iB);
                    latLng = latLng8;
                    break;
                case 8:
                    iF = i;
                    zC = com.google.android.gms.common.internal.safeparcel.a.c(parcel, iB);
                    int i10 = i2;
                    dJ = d;
                    iF2 = i3;
                    iF3 = i10;
                    LatLng latLng9 = latLng2;
                    fI = f;
                    latLng = latLng9;
                    break;
                default:
                    com.google.android.gms.common.internal.safeparcel.a.b(parcel, iB);
                    boolean z9 = z;
                    iF = i;
                    zC = z9;
                    int i11 = i2;
                    dJ = d;
                    iF2 = i3;
                    iF3 = i11;
                    LatLng latLng10 = latLng2;
                    fI = f;
                    latLng = latLng10;
                    break;
            }
            boolean z10 = zC;
            i = iF;
            z = z10;
            int i12 = iF2;
            d = dJ;
            i3 = i12;
            i2 = iF3;
            LatLng latLng11 = latLng;
            f = fI;
            latLng2 = latLng11;
        }
        if (parcel.dataPosition() != iC) {
            throw new a.C0003a("Overread allowed size end=" + iC, parcel);
        }
        return new CircleOptions(i, latLng2, d, fI2, i2, i3, f, z);
    }

    /* JADX WARN: Can't rename method to resolve collision */
    @Override // android.os.Parcelable.Creator
    public CircleOptions[] newArray(int size) {
        return new CircleOptions[size];
    }
}
