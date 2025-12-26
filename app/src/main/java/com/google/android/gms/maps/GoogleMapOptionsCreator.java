package com.google.android.gms.maps;

import android.os.Parcel;
import android.os.Parcelable;
import com.google.android.gms.common.internal.safeparcel.a;
import com.google.android.gms.common.internal.safeparcel.b;
import com.google.android.gms.maps.model.CameraPosition;

/* loaded from: classes.dex */
public class GoogleMapOptionsCreator implements Parcelable.Creator<GoogleMapOptions> {
    public static final int CONTENT_DESCRIPTION = 0;

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

    /* JADX WARN: Can't rename method to resolve collision */
    @Override // android.os.Parcelable.Creator
    public GoogleMapOptions createFromParcel(Parcel parcel) {
        int iF;
        byte bD;
        byte bD2;
        byte bD3;
        CameraPosition cameraPosition;
        byte bD4;
        byte bD5;
        int iF2;
        byte bD6;
        byte bD7;
        int iC = com.google.android.gms.common.internal.safeparcel.a.c(parcel);
        int i = 0;
        byte b = 0;
        byte b2 = 0;
        int i2 = 0;
        CameraPosition cameraPosition2 = null;
        byte bD8 = 0;
        byte b3 = 0;
        byte b4 = 0;
        byte b5 = 0;
        byte b6 = 0;
        byte b7 = 0;
        while (parcel.dataPosition() < iC) {
            int iB = com.google.android.gms.common.internal.safeparcel.a.b(parcel);
            switch (com.google.android.gms.common.internal.safeparcel.a.m(iB)) {
                case 1:
                    byte b8 = b7;
                    iF = com.google.android.gms.common.internal.safeparcel.a.f(parcel, iB);
                    bD = b8;
                    byte b9 = b5;
                    bD2 = b2;
                    bD3 = b9;
                    byte b10 = b3;
                    cameraPosition = cameraPosition2;
                    bD4 = b10;
                    int i3 = i2;
                    bD5 = b4;
                    iF2 = i3;
                    byte b11 = b;
                    bD6 = b6;
                    bD7 = b11;
                    break;
                case 2:
                    byte b12 = b7;
                    iF = i;
                    bD = b12;
                    byte b13 = b5;
                    bD2 = b2;
                    bD3 = b13;
                    byte b14 = b3;
                    cameraPosition = cameraPosition2;
                    bD4 = b14;
                    int i4 = i2;
                    bD5 = b4;
                    iF2 = i4;
                    bD6 = b6;
                    bD7 = com.google.android.gms.common.internal.safeparcel.a.d(parcel, iB);
                    break;
                case 3:
                    byte b15 = b7;
                    iF = i;
                    bD = b15;
                    byte b16 = b5;
                    bD2 = com.google.android.gms.common.internal.safeparcel.a.d(parcel, iB);
                    bD3 = b16;
                    byte b17 = b3;
                    cameraPosition = cameraPosition2;
                    bD4 = b17;
                    int i5 = i2;
                    bD5 = b4;
                    iF2 = i5;
                    byte b18 = b;
                    bD6 = b6;
                    bD7 = b18;
                    break;
                case 4:
                    byte b19 = b7;
                    iF = i;
                    bD = b19;
                    byte b20 = b5;
                    bD2 = b2;
                    bD3 = b20;
                    byte b21 = b3;
                    cameraPosition = cameraPosition2;
                    bD4 = b21;
                    bD5 = b4;
                    iF2 = com.google.android.gms.common.internal.safeparcel.a.f(parcel, iB);
                    byte b22 = b;
                    bD6 = b6;
                    bD7 = b22;
                    break;
                case 5:
                    bD4 = b3;
                    cameraPosition = (CameraPosition) com.google.android.gms.common.internal.safeparcel.a.a(parcel, iB, CameraPosition.CREATOR);
                    byte b23 = b5;
                    bD2 = b2;
                    bD3 = b23;
                    byte b24 = b7;
                    iF = i;
                    bD = b24;
                    int i6 = i2;
                    bD5 = b4;
                    iF2 = i6;
                    byte b25 = b;
                    bD6 = b6;
                    bD7 = b25;
                    break;
                case 6:
                    bD8 = com.google.android.gms.common.internal.safeparcel.a.d(parcel, iB);
                    byte b26 = b7;
                    iF = i;
                    bD = b26;
                    byte b27 = b5;
                    bD2 = b2;
                    bD3 = b27;
                    byte b28 = b3;
                    cameraPosition = cameraPosition2;
                    bD4 = b28;
                    int i7 = i2;
                    bD5 = b4;
                    iF2 = i7;
                    byte b29 = b;
                    bD6 = b6;
                    bD7 = b29;
                    break;
                case 7:
                    byte b30 = b7;
                    iF = i;
                    bD = b30;
                    byte b31 = b5;
                    bD2 = b2;
                    bD3 = b31;
                    cameraPosition = cameraPosition2;
                    bD4 = com.google.android.gms.common.internal.safeparcel.a.d(parcel, iB);
                    int i8 = i2;
                    bD5 = b4;
                    iF2 = i8;
                    byte b32 = b;
                    bD6 = b6;
                    bD7 = b32;
                    break;
                case 8:
                    byte b33 = b7;
                    iF = i;
                    bD = b33;
                    byte b34 = b5;
                    bD2 = b2;
                    bD3 = b34;
                    byte b35 = b3;
                    cameraPosition = cameraPosition2;
                    bD4 = b35;
                    int i9 = i2;
                    bD5 = com.google.android.gms.common.internal.safeparcel.a.d(parcel, iB);
                    iF2 = i9;
                    byte b36 = b;
                    bD6 = b6;
                    bD7 = b36;
                    break;
                case 9:
                    byte b37 = b7;
                    iF = i;
                    bD = b37;
                    bD2 = b2;
                    bD3 = com.google.android.gms.common.internal.safeparcel.a.d(parcel, iB);
                    byte b38 = b3;
                    cameraPosition = cameraPosition2;
                    bD4 = b38;
                    int i10 = i2;
                    bD5 = b4;
                    iF2 = i10;
                    byte b39 = b;
                    bD6 = b6;
                    bD7 = b39;
                    break;
                case 10:
                    byte b40 = b7;
                    iF = i;
                    bD = b40;
                    byte b41 = b5;
                    bD2 = b2;
                    bD3 = b41;
                    byte b42 = b3;
                    cameraPosition = cameraPosition2;
                    bD4 = b42;
                    int i11 = i2;
                    bD5 = b4;
                    iF2 = i11;
                    byte b43 = b;
                    bD6 = com.google.android.gms.common.internal.safeparcel.a.d(parcel, iB);
                    bD7 = b43;
                    break;
                case 11:
                    iF = i;
                    bD = com.google.android.gms.common.internal.safeparcel.a.d(parcel, iB);
                    byte b44 = b5;
                    bD2 = b2;
                    bD3 = b44;
                    byte b45 = b3;
                    cameraPosition = cameraPosition2;
                    bD4 = b45;
                    int i12 = i2;
                    bD5 = b4;
                    iF2 = i12;
                    byte b46 = b;
                    bD6 = b6;
                    bD7 = b46;
                    break;
                default:
                    com.google.android.gms.common.internal.safeparcel.a.b(parcel, iB);
                    byte b47 = b7;
                    iF = i;
                    bD = b47;
                    byte b48 = b5;
                    bD2 = b2;
                    bD3 = b48;
                    byte b49 = b3;
                    cameraPosition = cameraPosition2;
                    bD4 = b49;
                    int i13 = i2;
                    bD5 = b4;
                    iF2 = i13;
                    byte b50 = b;
                    bD6 = b6;
                    bD7 = b50;
                    break;
            }
            byte b51 = bD;
            i = iF;
            b7 = b51;
            byte b52 = bD3;
            b2 = bD2;
            b5 = b52;
            byte b53 = bD4;
            cameraPosition2 = cameraPosition;
            b3 = b53;
            int i14 = iF2;
            b4 = bD5;
            i2 = i14;
            byte b54 = bD7;
            b6 = bD6;
            b = b54;
        }
        if (parcel.dataPosition() != iC) {
            throw new a.C0003a("Overread allowed size end=" + iC, parcel);
        }
        return new GoogleMapOptions(i, b, b2, i2, cameraPosition2, bD8, b3, b4, b5, b6, b7);
    }

    /* JADX WARN: Can't rename method to resolve collision */
    @Override // android.os.Parcelable.Creator
    public GoogleMapOptions[] newArray(int size) {
        return new GoogleMapOptions[size];
    }
}
