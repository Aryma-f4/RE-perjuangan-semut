package com.google.android.gms.games.multiplayer;

import android.net.Uri;
import android.os.Parcel;
import android.os.Parcelable;
import com.google.android.gms.common.internal.safeparcel.a;
import com.google.android.gms.games.PlayerEntity;

/* loaded from: classes.dex */
public class c implements Parcelable.Creator<ParticipantEntity> {
    static void a(ParticipantEntity participantEntity, Parcel parcel, int i) {
        int iD = com.google.android.gms.common.internal.safeparcel.b.d(parcel);
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 1, participantEntity.getParticipantId(), false);
        com.google.android.gms.common.internal.safeparcel.b.c(parcel, 1000, participantEntity.i());
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 2, participantEntity.getDisplayName(), false);
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 3, (Parcelable) participantEntity.getIconImageUri(), i, false);
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 4, (Parcelable) participantEntity.getHiResImageUri(), i, false);
        com.google.android.gms.common.internal.safeparcel.b.c(parcel, 5, participantEntity.getStatus());
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 6, participantEntity.aM(), false);
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 7, participantEntity.isConnectedToRoom());
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 8, (Parcelable) participantEntity.getPlayer(), i, false);
        com.google.android.gms.common.internal.safeparcel.b.c(parcel, 9, participantEntity.aN());
        com.google.android.gms.common.internal.safeparcel.b.C(parcel, iD);
    }

    @Override // android.os.Parcelable.Creator
    /* renamed from: I, reason: merged with bridge method [inline-methods] */
    public ParticipantEntity[] newArray(int i) {
        return new ParticipantEntity[i];
    }

    @Override // android.os.Parcelable.Creator
    /* renamed from: q */
    public ParticipantEntity createFromParcel(Parcel parcel) {
        int iF;
        int iF2;
        String strL;
        boolean zC;
        Uri uri;
        int iF3;
        String strL2;
        Uri uri2;
        PlayerEntity playerEntity;
        String strL3;
        int iC = com.google.android.gms.common.internal.safeparcel.a.c(parcel);
        int i = 0;
        String str = null;
        String str2 = null;
        Uri uri3 = null;
        Uri uri4 = null;
        int i2 = 0;
        String str3 = null;
        boolean z = false;
        PlayerEntity playerEntity2 = null;
        int i3 = 0;
        while (parcel.dataPosition() < iC) {
            int iB = com.google.android.gms.common.internal.safeparcel.a.b(parcel);
            switch (com.google.android.gms.common.internal.safeparcel.a.m(iB)) {
                case 1:
                    int i4 = i3;
                    iF = i;
                    iF2 = i4;
                    boolean z2 = z;
                    strL = str2;
                    zC = z2;
                    int i5 = i2;
                    uri = uri4;
                    iF3 = i5;
                    Uri uri5 = uri3;
                    strL2 = str3;
                    uri2 = uri5;
                    playerEntity = playerEntity2;
                    strL3 = com.google.android.gms.common.internal.safeparcel.a.l(parcel, iB);
                    break;
                case 2:
                    int i6 = i3;
                    iF = i;
                    iF2 = i6;
                    boolean z3 = z;
                    strL = com.google.android.gms.common.internal.safeparcel.a.l(parcel, iB);
                    zC = z3;
                    int i7 = i2;
                    uri = uri4;
                    iF3 = i7;
                    Uri uri6 = uri3;
                    strL2 = str3;
                    uri2 = uri6;
                    String str4 = str;
                    playerEntity = playerEntity2;
                    strL3 = str4;
                    break;
                case 3:
                    strL2 = str3;
                    uri2 = (Uri) com.google.android.gms.common.internal.safeparcel.a.a(parcel, iB, Uri.CREATOR);
                    boolean z4 = z;
                    strL = str2;
                    zC = z4;
                    int i8 = i2;
                    uri = uri4;
                    iF3 = i8;
                    PlayerEntity playerEntity3 = playerEntity2;
                    strL3 = str;
                    playerEntity = playerEntity3;
                    int i9 = i3;
                    iF = i;
                    iF2 = i9;
                    break;
                case 4:
                    iF3 = i2;
                    uri = (Uri) com.google.android.gms.common.internal.safeparcel.a.a(parcel, iB, Uri.CREATOR);
                    boolean z5 = z;
                    strL = str2;
                    zC = z5;
                    int i10 = i3;
                    iF = i;
                    iF2 = i10;
                    Uri uri7 = uri3;
                    strL2 = str3;
                    uri2 = uri7;
                    String str5 = str;
                    playerEntity = playerEntity2;
                    strL3 = str5;
                    break;
                case 5:
                    int i11 = i3;
                    iF = i;
                    iF2 = i11;
                    boolean z6 = z;
                    strL = str2;
                    zC = z6;
                    uri = uri4;
                    iF3 = com.google.android.gms.common.internal.safeparcel.a.f(parcel, iB);
                    Uri uri8 = uri3;
                    strL2 = str3;
                    uri2 = uri8;
                    String str6 = str;
                    playerEntity = playerEntity2;
                    strL3 = str6;
                    break;
                case 6:
                    int i12 = i3;
                    iF = i;
                    iF2 = i12;
                    boolean z7 = z;
                    strL = str2;
                    zC = z7;
                    int i13 = i2;
                    uri = uri4;
                    iF3 = i13;
                    Uri uri9 = uri3;
                    strL2 = com.google.android.gms.common.internal.safeparcel.a.l(parcel, iB);
                    uri2 = uri9;
                    String str7 = str;
                    playerEntity = playerEntity2;
                    strL3 = str7;
                    break;
                case 7:
                    int i14 = i3;
                    iF = i;
                    iF2 = i14;
                    strL = str2;
                    zC = com.google.android.gms.common.internal.safeparcel.a.c(parcel, iB);
                    int i15 = i2;
                    uri = uri4;
                    iF3 = i15;
                    Uri uri10 = uri3;
                    strL2 = str3;
                    uri2 = uri10;
                    String str8 = str;
                    playerEntity = playerEntity2;
                    strL3 = str8;
                    break;
                case 8:
                    strL3 = str;
                    playerEntity = (PlayerEntity) com.google.android.gms.common.internal.safeparcel.a.a(parcel, iB, PlayerEntity.CREATOR);
                    boolean z8 = z;
                    strL = str2;
                    zC = z8;
                    int i16 = i2;
                    uri = uri4;
                    iF3 = i16;
                    Uri uri11 = uri3;
                    strL2 = str3;
                    uri2 = uri11;
                    int i17 = i3;
                    iF = i;
                    iF2 = i17;
                    break;
                case 9:
                    iF = i;
                    iF2 = com.google.android.gms.common.internal.safeparcel.a.f(parcel, iB);
                    boolean z9 = z;
                    strL = str2;
                    zC = z9;
                    int i18 = i2;
                    uri = uri4;
                    iF3 = i18;
                    Uri uri12 = uri3;
                    strL2 = str3;
                    uri2 = uri12;
                    String str9 = str;
                    playerEntity = playerEntity2;
                    strL3 = str9;
                    break;
                case 1000:
                    int i19 = i3;
                    iF = com.google.android.gms.common.internal.safeparcel.a.f(parcel, iB);
                    iF2 = i19;
                    boolean z10 = z;
                    strL = str2;
                    zC = z10;
                    int i20 = i2;
                    uri = uri4;
                    iF3 = i20;
                    Uri uri13 = uri3;
                    strL2 = str3;
                    uri2 = uri13;
                    String str10 = str;
                    playerEntity = playerEntity2;
                    strL3 = str10;
                    break;
                default:
                    com.google.android.gms.common.internal.safeparcel.a.b(parcel, iB);
                    int i21 = i3;
                    iF = i;
                    iF2 = i21;
                    boolean z11 = z;
                    strL = str2;
                    zC = z11;
                    int i22 = i2;
                    uri = uri4;
                    iF3 = i22;
                    Uri uri14 = uri3;
                    strL2 = str3;
                    uri2 = uri14;
                    String str11 = str;
                    playerEntity = playerEntity2;
                    strL3 = str11;
                    break;
            }
            int i23 = iF2;
            i = iF;
            i3 = i23;
            boolean z12 = zC;
            str2 = strL;
            z = z12;
            int i24 = iF3;
            uri4 = uri;
            i2 = i24;
            Uri uri15 = uri2;
            str3 = strL2;
            uri3 = uri15;
            String str12 = strL3;
            playerEntity2 = playerEntity;
            str = str12;
        }
        if (parcel.dataPosition() != iC) {
            throw new a.C0003a("Overread allowed size end=" + iC, parcel);
        }
        return new ParticipantEntity(i, str, str2, uri3, uri4, i2, str3, z, playerEntity2, i3);
    }
}
