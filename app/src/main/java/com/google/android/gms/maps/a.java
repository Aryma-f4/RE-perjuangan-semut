package com.google.android.gms.maps;

import android.os.Parcel;
import android.os.Parcelable;
import com.google.android.gms.common.internal.safeparcel.b;

/* loaded from: classes.dex */
public class a {
    static void a(GoogleMapOptions googleMapOptions, Parcel parcel, int i) {
        int iD = b.d(parcel);
        b.c(parcel, 1, googleMapOptions.i());
        b.a(parcel, 2, googleMapOptions.aZ());
        b.a(parcel, 3, googleMapOptions.ba());
        b.c(parcel, 4, googleMapOptions.getMapType());
        b.a(parcel, 5, (Parcelable) googleMapOptions.getCamera(), i, false);
        b.a(parcel, 6, googleMapOptions.bb());
        b.a(parcel, 7, googleMapOptions.bc());
        b.a(parcel, 8, googleMapOptions.bd());
        b.a(parcel, 9, googleMapOptions.be());
        b.a(parcel, 10, googleMapOptions.bf());
        b.a(parcel, 11, googleMapOptions.bg());
        b.C(parcel, iD);
    }
}
