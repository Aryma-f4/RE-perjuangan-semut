package com.google.android.gms.maps.model;

import android.os.Parcel;
import android.os.Parcelable;
import com.google.android.gms.common.internal.safeparcel.a;

/* loaded from: classes.dex */
public class VisibleRegionCreator implements Parcelable.Creator<VisibleRegion> {
    public static final int CONTENT_DESCRIPTION = 0;

    static void a(VisibleRegion visibleRegion, Parcel parcel, int i) {
        int iD = com.google.android.gms.common.internal.safeparcel.b.d(parcel);
        com.google.android.gms.common.internal.safeparcel.b.c(parcel, 1, visibleRegion.i());
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 2, (Parcelable) visibleRegion.nearLeft, i, false);
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 3, (Parcelable) visibleRegion.nearRight, i, false);
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 4, (Parcelable) visibleRegion.farLeft, i, false);
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 5, (Parcelable) visibleRegion.farRight, i, false);
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 6, (Parcelable) visibleRegion.latLngBounds, i, false);
        com.google.android.gms.common.internal.safeparcel.b.C(parcel, iD);
    }

    /* JADX WARN: Can't rename method to resolve collision */
    @Override // android.os.Parcelable.Creator
    public VisibleRegion createFromParcel(Parcel parcel) {
        int iF;
        LatLngBounds latLngBounds;
        LatLng latLng;
        LatLng latLng2;
        LatLng latLng3;
        LatLng latLng4;
        LatLng latLng5 = null;
        int iC = com.google.android.gms.common.internal.safeparcel.a.c(parcel);
        int i = 0;
        LatLngBounds latLngBounds2 = null;
        LatLng latLng6 = null;
        LatLng latLng7 = null;
        LatLng latLng8 = null;
        while (parcel.dataPosition() < iC) {
            int iB = com.google.android.gms.common.internal.safeparcel.a.b(parcel);
            switch (com.google.android.gms.common.internal.safeparcel.a.m(iB)) {
                case 1:
                    LatLngBounds latLngBounds3 = latLngBounds2;
                    iF = com.google.android.gms.common.internal.safeparcel.a.f(parcel, iB);
                    latLngBounds = latLngBounds3;
                    LatLng latLng9 = latLng7;
                    latLng = latLng8;
                    latLng2 = latLng9;
                    LatLng latLng10 = latLng5;
                    latLng3 = latLng6;
                    latLng4 = latLng10;
                    break;
                case 2:
                    latLng3 = latLng6;
                    latLng4 = (LatLng) com.google.android.gms.common.internal.safeparcel.a.a(parcel, iB, LatLng.CREATOR);
                    LatLng latLng11 = latLng7;
                    latLng = latLng8;
                    latLng2 = latLng11;
                    LatLngBounds latLngBounds4 = latLngBounds2;
                    iF = i;
                    latLngBounds = latLngBounds4;
                    break;
                case 3:
                    latLng2 = latLng7;
                    latLng = (LatLng) com.google.android.gms.common.internal.safeparcel.a.a(parcel, iB, LatLng.CREATOR);
                    LatLngBounds latLngBounds5 = latLngBounds2;
                    iF = i;
                    latLngBounds = latLngBounds5;
                    LatLng latLng12 = latLng5;
                    latLng3 = latLng6;
                    latLng4 = latLng12;
                    break;
                case 4:
                    latLng = latLng8;
                    latLng2 = (LatLng) com.google.android.gms.common.internal.safeparcel.a.a(parcel, iB, LatLng.CREATOR);
                    LatLng latLng13 = latLng6;
                    latLng4 = latLng5;
                    latLng3 = latLng13;
                    LatLngBounds latLngBounds6 = latLngBounds2;
                    iF = i;
                    latLngBounds = latLngBounds6;
                    break;
                case 5:
                    latLng4 = latLng5;
                    latLng3 = (LatLng) com.google.android.gms.common.internal.safeparcel.a.a(parcel, iB, LatLng.CREATOR);
                    LatLng latLng14 = latLng7;
                    latLng = latLng8;
                    latLng2 = latLng14;
                    LatLngBounds latLngBounds7 = latLngBounds2;
                    iF = i;
                    latLngBounds = latLngBounds7;
                    break;
                case 6:
                    iF = i;
                    latLngBounds = (LatLngBounds) com.google.android.gms.common.internal.safeparcel.a.a(parcel, iB, LatLngBounds.CREATOR);
                    LatLng latLng15 = latLng7;
                    latLng = latLng8;
                    latLng2 = latLng15;
                    LatLng latLng16 = latLng5;
                    latLng3 = latLng6;
                    latLng4 = latLng16;
                    break;
                default:
                    com.google.android.gms.common.internal.safeparcel.a.b(parcel, iB);
                    LatLngBounds latLngBounds8 = latLngBounds2;
                    iF = i;
                    latLngBounds = latLngBounds8;
                    LatLng latLng17 = latLng7;
                    latLng = latLng8;
                    latLng2 = latLng17;
                    LatLng latLng18 = latLng5;
                    latLng3 = latLng6;
                    latLng4 = latLng18;
                    break;
            }
            LatLngBounds latLngBounds9 = latLngBounds;
            i = iF;
            latLngBounds2 = latLngBounds9;
            LatLng latLng19 = latLng2;
            latLng8 = latLng;
            latLng7 = latLng19;
            LatLng latLng20 = latLng4;
            latLng6 = latLng3;
            latLng5 = latLng20;
        }
        if (parcel.dataPosition() != iC) {
            throw new a.C0003a("Overread allowed size end=" + iC, parcel);
        }
        return new VisibleRegion(i, latLng5, latLng8, latLng7, latLng6, latLngBounds2);
    }

    /* JADX WARN: Can't rename method to resolve collision */
    @Override // android.os.Parcelable.Creator
    public VisibleRegion[] newArray(int size) {
        return new VisibleRegion[size];
    }
}
