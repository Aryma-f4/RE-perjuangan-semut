package com.google.android.gms.games;

import android.net.Uri;
import android.os.Parcel;
import android.os.Parcelable;
import com.google.android.gms.common.internal.safeparcel.a;

/* loaded from: classes.dex */
public class c implements Parcelable.Creator<PlayerEntity> {
    static void a(PlayerEntity playerEntity, Parcel parcel, int i) {
        int iD = com.google.android.gms.common.internal.safeparcel.b.d(parcel);
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 1, playerEntity.getPlayerId(), false);
        com.google.android.gms.common.internal.safeparcel.b.c(parcel, 1000, playerEntity.i());
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 2, playerEntity.getDisplayName(), false);
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 3, (Parcelable) playerEntity.getIconImageUri(), i, false);
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 4, (Parcelable) playerEntity.getHiResImageUri(), i, false);
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 5, playerEntity.getRetrievedTimestamp());
        com.google.android.gms.common.internal.safeparcel.b.C(parcel, iD);
    }

    @Override // android.os.Parcelable.Creator
    /* renamed from: A, reason: merged with bridge method [inline-methods] */
    public PlayerEntity[] newArray(int i) {
        return new PlayerEntity[i];
    }

    @Override // android.os.Parcelable.Creator
    /* renamed from: o, reason: merged with bridge method [inline-methods] */
    public PlayerEntity createFromParcel(Parcel parcel) {
        String strL;
        int iF;
        long jG;
        Uri uri;
        String strL2;
        Uri uri2 = null;
        int iC = com.google.android.gms.common.internal.safeparcel.a.c(parcel);
        int i = 0;
        long j = 0;
        Uri uri3 = null;
        String str = null;
        String str2 = null;
        while (parcel.dataPosition() < iC) {
            int iB = com.google.android.gms.common.internal.safeparcel.a.b(parcel);
            switch (com.google.android.gms.common.internal.safeparcel.a.m(iB)) {
                case 1:
                    long j2 = j;
                    strL = com.google.android.gms.common.internal.safeparcel.a.l(parcel, iB);
                    iF = i;
                    jG = j2;
                    String str3 = str;
                    uri = uri3;
                    strL2 = str3;
                    break;
                case 2:
                    long j3 = j;
                    strL = str2;
                    iF = i;
                    jG = j3;
                    uri = uri3;
                    strL2 = com.google.android.gms.common.internal.safeparcel.a.l(parcel, iB);
                    break;
                case 3:
                    uri2 = (Uri) com.google.android.gms.common.internal.safeparcel.a.a(parcel, iB, Uri.CREATOR);
                    Uri uri4 = uri3;
                    strL2 = str;
                    uri = uri4;
                    long j4 = j;
                    strL = str2;
                    iF = i;
                    jG = j4;
                    break;
                case 4:
                    strL2 = str;
                    uri = (Uri) com.google.android.gms.common.internal.safeparcel.a.a(parcel, iB, Uri.CREATOR);
                    long j5 = j;
                    strL = str2;
                    iF = i;
                    jG = j5;
                    break;
                case 5:
                    strL = str2;
                    iF = i;
                    jG = com.google.android.gms.common.internal.safeparcel.a.g(parcel, iB);
                    String str4 = str;
                    uri = uri3;
                    strL2 = str4;
                    break;
                case 1000:
                    long j6 = j;
                    strL = str2;
                    iF = com.google.android.gms.common.internal.safeparcel.a.f(parcel, iB);
                    jG = j6;
                    String str5 = str;
                    uri = uri3;
                    strL2 = str5;
                    break;
                default:
                    com.google.android.gms.common.internal.safeparcel.a.b(parcel, iB);
                    long j7 = j;
                    strL = str2;
                    iF = i;
                    jG = j7;
                    String str6 = str;
                    uri = uri3;
                    strL2 = str6;
                    break;
            }
            long j8 = jG;
            str2 = strL;
            i = iF;
            j = j8;
            String str7 = strL2;
            uri3 = uri;
            str = str7;
        }
        if (parcel.dataPosition() != iC) {
            throw new a.C0003a("Overread allowed size end=" + iC, parcel);
        }
        return new PlayerEntity(i, str2, str, uri2, uri3, j);
    }
}
