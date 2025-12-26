package com.google.android.gms.maps.model;

import android.os.Parcel;
import android.os.Parcelable;
import com.google.android.gms.common.internal.safeparcel.a;
import java.util.ArrayList;

/* loaded from: classes.dex */
public class PolylineOptionsCreator implements Parcelable.Creator<PolylineOptions> {
    public static final int CONTENT_DESCRIPTION = 0;

    static void a(PolylineOptions polylineOptions, Parcel parcel, int i) {
        int iD = com.google.android.gms.common.internal.safeparcel.b.d(parcel);
        com.google.android.gms.common.internal.safeparcel.b.c(parcel, 1, polylineOptions.i());
        com.google.android.gms.common.internal.safeparcel.b.b(parcel, 2, polylineOptions.getPoints(), false);
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 3, polylineOptions.getWidth());
        com.google.android.gms.common.internal.safeparcel.b.c(parcel, 4, polylineOptions.getColor());
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 5, polylineOptions.getZIndex());
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 6, polylineOptions.isVisible());
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 7, polylineOptions.isGeodesic());
        com.google.android.gms.common.internal.safeparcel.b.C(parcel, iD);
    }

    /* JADX WARN: Can't rename method to resolve collision */
    @Override // android.os.Parcelable.Creator
    public PolylineOptions createFromParcel(Parcel parcel) {
        float fI = 0.0f;
        int iC = com.google.android.gms.common.internal.safeparcel.a.c(parcel);
        boolean zC = false;
        boolean zC2 = false;
        float fI2 = 0.0f;
        int iF = 0;
        int iF2 = 0;
        ArrayList arrayListC = null;
        while (parcel.dataPosition() < iC) {
            int iB = com.google.android.gms.common.internal.safeparcel.a.b(parcel);
            switch (com.google.android.gms.common.internal.safeparcel.a.m(iB)) {
                case 1:
                    iF2 = com.google.android.gms.common.internal.safeparcel.a.f(parcel, iB);
                    break;
                case 2:
                    arrayListC = com.google.android.gms.common.internal.safeparcel.a.c(parcel, iB, LatLng.CREATOR);
                    break;
                case 3:
                    fI = com.google.android.gms.common.internal.safeparcel.a.i(parcel, iB);
                    break;
                case 4:
                    iF = com.google.android.gms.common.internal.safeparcel.a.f(parcel, iB);
                    break;
                case 5:
                    fI2 = com.google.android.gms.common.internal.safeparcel.a.i(parcel, iB);
                    break;
                case 6:
                    zC2 = com.google.android.gms.common.internal.safeparcel.a.c(parcel, iB);
                    break;
                case 7:
                    zC = com.google.android.gms.common.internal.safeparcel.a.c(parcel, iB);
                    break;
                default:
                    com.google.android.gms.common.internal.safeparcel.a.b(parcel, iB);
                    break;
            }
            iF2 = iF2;
            zC = zC;
            fI = fI;
            fI2 = fI2;
            zC2 = zC2;
            arrayListC = arrayListC;
        }
        if (parcel.dataPosition() != iC) {
            throw new a.C0003a("Overread allowed size end=" + iC, parcel);
        }
        return new PolylineOptions(iF2, arrayListC, fI, iF, fI2, zC2, zC);
    }

    /* JADX WARN: Can't rename method to resolve collision */
    @Override // android.os.Parcelable.Creator
    public PolylineOptions[] newArray(int size) {
        return new PolylineOptions[size];
    }
}
