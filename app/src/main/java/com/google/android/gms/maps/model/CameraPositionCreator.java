package com.google.android.gms.maps.model;

import android.os.Parcel;
import android.os.Parcelable;
import com.google.android.gms.common.internal.safeparcel.a;

/* loaded from: classes.dex */
public class CameraPositionCreator implements Parcelable.Creator<CameraPosition> {
    public static final int CONTENT_DESCRIPTION = 0;

    static void a(CameraPosition cameraPosition, Parcel parcel, int i) {
        int iD = com.google.android.gms.common.internal.safeparcel.b.d(parcel);
        com.google.android.gms.common.internal.safeparcel.b.c(parcel, 1, cameraPosition.i());
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 2, (Parcelable) cameraPosition.target, i, false);
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 3, cameraPosition.zoom);
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 4, cameraPosition.tilt);
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 5, cameraPosition.bearing);
        com.google.android.gms.common.internal.safeparcel.b.C(parcel, iD);
    }

    /* JADX WARN: Can't rename method to resolve collision */
    @Override // android.os.Parcelable.Creator
    public CameraPosition createFromParcel(Parcel parcel) {
        int iF;
        float fI;
        float fI2;
        LatLng latLng;
        float fI3 = 0.0f;
        int iC = com.google.android.gms.common.internal.safeparcel.a.c(parcel);
        int i = 0;
        LatLng latLng2 = null;
        float f = 0.0f;
        float f2 = 0.0f;
        while (parcel.dataPosition() < iC) {
            int iB = com.google.android.gms.common.internal.safeparcel.a.b(parcel);
            switch (com.google.android.gms.common.internal.safeparcel.a.m(iB)) {
                case 1:
                    float f3 = f;
                    iF = com.google.android.gms.common.internal.safeparcel.a.f(parcel, iB);
                    fI = f3;
                    LatLng latLng3 = latLng2;
                    fI2 = f2;
                    latLng = latLng3;
                    break;
                case 2:
                    fI2 = f2;
                    latLng = (LatLng) com.google.android.gms.common.internal.safeparcel.a.a(parcel, iB, LatLng.CREATOR);
                    float f4 = f;
                    iF = i;
                    fI = f4;
                    break;
                case 3:
                    fI3 = com.google.android.gms.common.internal.safeparcel.a.i(parcel, iB);
                    float f5 = f;
                    iF = i;
                    fI = f5;
                    LatLng latLng4 = latLng2;
                    fI2 = f2;
                    latLng = latLng4;
                    break;
                case 4:
                    float f6 = f;
                    iF = i;
                    fI = f6;
                    LatLng latLng5 = latLng2;
                    fI2 = com.google.android.gms.common.internal.safeparcel.a.i(parcel, iB);
                    latLng = latLng5;
                    break;
                case 5:
                    iF = i;
                    fI = com.google.android.gms.common.internal.safeparcel.a.i(parcel, iB);
                    LatLng latLng6 = latLng2;
                    fI2 = f2;
                    latLng = latLng6;
                    break;
                default:
                    com.google.android.gms.common.internal.safeparcel.a.b(parcel, iB);
                    float f7 = f;
                    iF = i;
                    fI = f7;
                    LatLng latLng7 = latLng2;
                    fI2 = f2;
                    latLng = latLng7;
                    break;
            }
            float f8 = fI;
            i = iF;
            f = f8;
            LatLng latLng8 = latLng;
            f2 = fI2;
            latLng2 = latLng8;
        }
        if (parcel.dataPosition() != iC) {
            throw new a.C0003a("Overread allowed size end=" + iC, parcel);
        }
        return new CameraPosition(i, latLng2, fI3, f2, f);
    }

    /* JADX WARN: Can't rename method to resolve collision */
    @Override // android.os.Parcelable.Creator
    public CameraPosition[] newArray(int size) {
        return new CameraPosition[size];
    }
}
