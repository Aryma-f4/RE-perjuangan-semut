package com.google.android.gms.maps.model;

import android.os.IBinder;
import android.os.Parcel;
import android.os.Parcelable;
import com.google.android.gms.common.internal.safeparcel.a;

/* loaded from: classes.dex */
public class GroundOverlayOptionsCreator implements Parcelable.Creator<GroundOverlayOptions> {
    public static final int CONTENT_DESCRIPTION = 0;

    static void a(GroundOverlayOptions groundOverlayOptions, Parcel parcel, int i) {
        int iD = com.google.android.gms.common.internal.safeparcel.b.d(parcel);
        com.google.android.gms.common.internal.safeparcel.b.c(parcel, 1, groundOverlayOptions.i());
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 2, groundOverlayOptions.bp(), false);
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 3, (Parcelable) groundOverlayOptions.getLocation(), i, false);
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 4, groundOverlayOptions.getWidth());
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 5, groundOverlayOptions.getHeight());
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 6, (Parcelable) groundOverlayOptions.getBounds(), i, false);
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 7, groundOverlayOptions.getBearing());
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 8, groundOverlayOptions.getZIndex());
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 9, groundOverlayOptions.isVisible());
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 10, groundOverlayOptions.getTransparency());
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 11, groundOverlayOptions.getAnchorU());
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 12, groundOverlayOptions.getAnchorV());
        com.google.android.gms.common.internal.safeparcel.b.C(parcel, iD);
    }

    /* JADX WARN: Can't rename method to resolve collision */
    @Override // android.os.Parcelable.Creator
    public GroundOverlayOptions createFromParcel(Parcel parcel) {
        int iF;
        float fI;
        LatLng latLng;
        float fI2;
        float fI3;
        float fI4;
        float fI5;
        LatLngBounds latLngBounds;
        boolean zC;
        float fI6;
        float fI7;
        IBinder iBinderM;
        int iC = com.google.android.gms.common.internal.safeparcel.a.c(parcel);
        int i = 0;
        IBinder iBinder = null;
        LatLng latLng2 = null;
        float f = 0.0f;
        float f2 = 0.0f;
        LatLngBounds latLngBounds2 = null;
        float f3 = 0.0f;
        float f4 = 0.0f;
        boolean z = false;
        float f5 = 0.0f;
        float f6 = 0.0f;
        float f7 = 0.0f;
        while (parcel.dataPosition() < iC) {
            int iB = com.google.android.gms.common.internal.safeparcel.a.b(parcel);
            switch (com.google.android.gms.common.internal.safeparcel.a.m(iB)) {
                case 1:
                    float f8 = f7;
                    iF = com.google.android.gms.common.internal.safeparcel.a.f(parcel, iB);
                    fI = f8;
                    float f9 = f5;
                    latLng = latLng2;
                    fI2 = f9;
                    float f10 = f4;
                    fI3 = f2;
                    fI4 = f10;
                    LatLngBounds latLngBounds3 = latLngBounds2;
                    fI5 = f3;
                    latLngBounds = latLngBounds3;
                    float f11 = f;
                    zC = z;
                    fI6 = f11;
                    IBinder iBinder2 = iBinder;
                    fI7 = f6;
                    iBinderM = iBinder2;
                    break;
                case 2:
                    float f12 = f7;
                    iF = i;
                    fI = f12;
                    float f13 = f5;
                    latLng = latLng2;
                    fI2 = f13;
                    float f14 = f4;
                    fI3 = f2;
                    fI4 = f14;
                    LatLngBounds latLngBounds4 = latLngBounds2;
                    fI5 = f3;
                    latLngBounds = latLngBounds4;
                    float f15 = f;
                    zC = z;
                    fI6 = f15;
                    fI7 = f6;
                    iBinderM = com.google.android.gms.common.internal.safeparcel.a.m(parcel, iB);
                    break;
                case 3:
                    fI2 = f5;
                    latLng = (LatLng) com.google.android.gms.common.internal.safeparcel.a.a(parcel, iB, LatLng.CREATOR);
                    float f16 = f7;
                    iF = i;
                    fI = f16;
                    float f17 = f4;
                    fI3 = f2;
                    fI4 = f17;
                    LatLngBounds latLngBounds5 = latLngBounds2;
                    fI5 = f3;
                    latLngBounds = latLngBounds5;
                    float f18 = f;
                    zC = z;
                    fI6 = f18;
                    IBinder iBinder3 = iBinder;
                    fI7 = f6;
                    iBinderM = iBinder3;
                    break;
                case 4:
                    float f19 = f7;
                    iF = i;
                    fI = f19;
                    float f20 = f5;
                    latLng = latLng2;
                    fI2 = f20;
                    float f21 = f4;
                    fI3 = f2;
                    fI4 = f21;
                    LatLngBounds latLngBounds6 = latLngBounds2;
                    fI5 = f3;
                    latLngBounds = latLngBounds6;
                    zC = z;
                    fI6 = com.google.android.gms.common.internal.safeparcel.a.i(parcel, iB);
                    IBinder iBinder4 = iBinder;
                    fI7 = f6;
                    iBinderM = iBinder4;
                    break;
                case 5:
                    float f22 = f7;
                    iF = i;
                    fI = f22;
                    float f23 = f5;
                    latLng = latLng2;
                    fI2 = f23;
                    float f24 = f4;
                    fI3 = com.google.android.gms.common.internal.safeparcel.a.i(parcel, iB);
                    fI4 = f24;
                    LatLngBounds latLngBounds7 = latLngBounds2;
                    fI5 = f3;
                    latLngBounds = latLngBounds7;
                    float f25 = f;
                    zC = z;
                    fI6 = f25;
                    IBinder iBinder5 = iBinder;
                    fI7 = f6;
                    iBinderM = iBinder5;
                    break;
                case 6:
                    fI5 = f3;
                    latLngBounds = (LatLngBounds) com.google.android.gms.common.internal.safeparcel.a.a(parcel, iB, LatLngBounds.CREATOR);
                    float f26 = f5;
                    latLng = latLng2;
                    fI2 = f26;
                    float f27 = f4;
                    fI3 = f2;
                    fI4 = f27;
                    float f28 = f6;
                    iBinderM = iBinder;
                    fI7 = f28;
                    float f29 = f;
                    zC = z;
                    fI6 = f29;
                    float f30 = f7;
                    iF = i;
                    fI = f30;
                    break;
                case 7:
                    float f31 = f7;
                    iF = i;
                    fI = f31;
                    float f32 = f5;
                    latLng = latLng2;
                    fI2 = f32;
                    float f33 = f4;
                    fI3 = f2;
                    fI4 = f33;
                    LatLngBounds latLngBounds8 = latLngBounds2;
                    fI5 = com.google.android.gms.common.internal.safeparcel.a.i(parcel, iB);
                    latLngBounds = latLngBounds8;
                    float f34 = f;
                    zC = z;
                    fI6 = f34;
                    IBinder iBinder6 = iBinder;
                    fI7 = f6;
                    iBinderM = iBinder6;
                    break;
                case 8:
                    float f35 = f7;
                    iF = i;
                    fI = f35;
                    float f36 = f5;
                    latLng = latLng2;
                    fI2 = f36;
                    fI3 = f2;
                    fI4 = com.google.android.gms.common.internal.safeparcel.a.i(parcel, iB);
                    LatLngBounds latLngBounds9 = latLngBounds2;
                    fI5 = f3;
                    latLngBounds = latLngBounds9;
                    float f37 = f;
                    zC = z;
                    fI6 = f37;
                    IBinder iBinder7 = iBinder;
                    fI7 = f6;
                    iBinderM = iBinder7;
                    break;
                case 9:
                    float f38 = f7;
                    iF = i;
                    fI = f38;
                    float f39 = f5;
                    latLng = latLng2;
                    fI2 = f39;
                    float f40 = f4;
                    fI3 = f2;
                    fI4 = f40;
                    LatLngBounds latLngBounds10 = latLngBounds2;
                    fI5 = f3;
                    latLngBounds = latLngBounds10;
                    float f41 = f;
                    zC = com.google.android.gms.common.internal.safeparcel.a.c(parcel, iB);
                    fI6 = f41;
                    IBinder iBinder8 = iBinder;
                    fI7 = f6;
                    iBinderM = iBinder8;
                    break;
                case 10:
                    float f42 = f7;
                    iF = i;
                    fI = f42;
                    latLng = latLng2;
                    fI2 = com.google.android.gms.common.internal.safeparcel.a.i(parcel, iB);
                    float f43 = f4;
                    fI3 = f2;
                    fI4 = f43;
                    LatLngBounds latLngBounds11 = latLngBounds2;
                    fI5 = f3;
                    latLngBounds = latLngBounds11;
                    float f44 = f;
                    zC = z;
                    fI6 = f44;
                    IBinder iBinder9 = iBinder;
                    fI7 = f6;
                    iBinderM = iBinder9;
                    break;
                case 11:
                    float f45 = f7;
                    iF = i;
                    fI = f45;
                    float f46 = f5;
                    latLng = latLng2;
                    fI2 = f46;
                    float f47 = f4;
                    fI3 = f2;
                    fI4 = f47;
                    LatLngBounds latLngBounds12 = latLngBounds2;
                    fI5 = f3;
                    latLngBounds = latLngBounds12;
                    float f48 = f;
                    zC = z;
                    fI6 = f48;
                    IBinder iBinder10 = iBinder;
                    fI7 = com.google.android.gms.common.internal.safeparcel.a.i(parcel, iB);
                    iBinderM = iBinder10;
                    break;
                case 12:
                    iF = i;
                    fI = com.google.android.gms.common.internal.safeparcel.a.i(parcel, iB);
                    float f49 = f5;
                    latLng = latLng2;
                    fI2 = f49;
                    float f50 = f4;
                    fI3 = f2;
                    fI4 = f50;
                    LatLngBounds latLngBounds13 = latLngBounds2;
                    fI5 = f3;
                    latLngBounds = latLngBounds13;
                    float f51 = f;
                    zC = z;
                    fI6 = f51;
                    IBinder iBinder11 = iBinder;
                    fI7 = f6;
                    iBinderM = iBinder11;
                    break;
                default:
                    com.google.android.gms.common.internal.safeparcel.a.b(parcel, iB);
                    float f52 = f7;
                    iF = i;
                    fI = f52;
                    float f53 = f5;
                    latLng = latLng2;
                    fI2 = f53;
                    float f54 = f4;
                    fI3 = f2;
                    fI4 = f54;
                    LatLngBounds latLngBounds14 = latLngBounds2;
                    fI5 = f3;
                    latLngBounds = latLngBounds14;
                    float f55 = f;
                    zC = z;
                    fI6 = f55;
                    IBinder iBinder12 = iBinder;
                    fI7 = f6;
                    iBinderM = iBinder12;
                    break;
            }
            float f56 = fI;
            i = iF;
            f7 = f56;
            float f57 = fI2;
            latLng2 = latLng;
            f5 = f57;
            float f58 = fI4;
            f2 = fI3;
            f4 = f58;
            LatLngBounds latLngBounds15 = latLngBounds;
            f3 = fI5;
            latLngBounds2 = latLngBounds15;
            float f59 = fI6;
            z = zC;
            f = f59;
            IBinder iBinder13 = iBinderM;
            f6 = fI7;
            iBinder = iBinder13;
        }
        if (parcel.dataPosition() != iC) {
            throw new a.C0003a("Overread allowed size end=" + iC, parcel);
        }
        return new GroundOverlayOptions(i, iBinder, latLng2, f, f2, latLngBounds2, f3, f4, z, f5, f6, f7);
    }

    /* JADX WARN: Can't rename method to resolve collision */
    @Override // android.os.Parcelable.Creator
    public GroundOverlayOptions[] newArray(int size) {
        return new GroundOverlayOptions[size];
    }
}
