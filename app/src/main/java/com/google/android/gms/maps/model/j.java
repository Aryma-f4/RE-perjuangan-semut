package com.google.android.gms.maps.model;

import android.os.Parcel;

/* loaded from: classes.dex */
public class j {
    static void a(TileOverlayOptions tileOverlayOptions, Parcel parcel, int i) {
        int iD = com.google.android.gms.common.internal.safeparcel.b.d(parcel);
        com.google.android.gms.common.internal.safeparcel.b.c(parcel, 1, tileOverlayOptions.i());
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 2, tileOverlayOptions.bs(), false);
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 3, tileOverlayOptions.isVisible());
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 4, tileOverlayOptions.getZIndex());
        com.google.android.gms.common.internal.safeparcel.b.C(parcel, iD);
    }
}
