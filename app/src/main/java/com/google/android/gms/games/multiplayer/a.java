package com.google.android.gms.games.multiplayer;

import android.os.Parcel;
import android.os.Parcelable;
import com.google.android.gms.common.internal.safeparcel.a;
import com.google.android.gms.games.GameEntity;
import java.util.ArrayList;

/* loaded from: classes.dex */
public class a implements Parcelable.Creator<InvitationEntity> {
    static void a(InvitationEntity invitationEntity, Parcel parcel, int i) {
        int iD = com.google.android.gms.common.internal.safeparcel.b.d(parcel);
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 1, (Parcelable) invitationEntity.getGame(), i, false);
        com.google.android.gms.common.internal.safeparcel.b.c(parcel, 1000, invitationEntity.i());
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 2, invitationEntity.getInvitationId(), false);
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 3, invitationEntity.getCreationTimestamp());
        com.google.android.gms.common.internal.safeparcel.b.c(parcel, 4, invitationEntity.aL());
        com.google.android.gms.common.internal.safeparcel.b.a(parcel, 5, (Parcelable) invitationEntity.getInviter(), i, false);
        com.google.android.gms.common.internal.safeparcel.b.b(parcel, 6, invitationEntity.getParticipants(), false);
        com.google.android.gms.common.internal.safeparcel.b.c(parcel, 7, invitationEntity.getVariant());
        com.google.android.gms.common.internal.safeparcel.b.C(parcel, iD);
    }

    @Override // android.os.Parcelable.Creator
    /* renamed from: H, reason: merged with bridge method [inline-methods] */
    public InvitationEntity[] newArray(int i) {
        return new InvitationEntity[i];
    }

    @Override // android.os.Parcelable.Creator
    /* renamed from: p, reason: merged with bridge method [inline-methods] */
    public InvitationEntity createFromParcel(Parcel parcel) {
        int iF;
        int iF2;
        String strL;
        ParticipantEntity participantEntity;
        int iF3;
        long jG;
        ArrayList arrayListC;
        GameEntity gameEntity;
        int iC = com.google.android.gms.common.internal.safeparcel.a.c(parcel);
        int i = 0;
        GameEntity gameEntity2 = null;
        String str = null;
        long j = 0;
        int i2 = 0;
        ParticipantEntity participantEntity2 = null;
        ArrayList arrayList = null;
        int i3 = 0;
        while (parcel.dataPosition() < iC) {
            int iB = com.google.android.gms.common.internal.safeparcel.a.b(parcel);
            switch (com.google.android.gms.common.internal.safeparcel.a.m(iB)) {
                case 1:
                    arrayListC = arrayList;
                    gameEntity = (GameEntity) com.google.android.gms.common.internal.safeparcel.a.a(parcel, iB, GameEntity.CREATOR);
                    ParticipantEntity participantEntity3 = participantEntity2;
                    strL = str;
                    participantEntity = participantEntity3;
                    long j2 = j;
                    iF3 = i2;
                    jG = j2;
                    int i4 = i3;
                    iF = i;
                    iF2 = i4;
                    break;
                case 2:
                    int i5 = i3;
                    iF = i;
                    iF2 = i5;
                    ParticipantEntity participantEntity4 = participantEntity2;
                    strL = com.google.android.gms.common.internal.safeparcel.a.l(parcel, iB);
                    participantEntity = participantEntity4;
                    long j3 = j;
                    iF3 = i2;
                    jG = j3;
                    GameEntity gameEntity3 = gameEntity2;
                    arrayListC = arrayList;
                    gameEntity = gameEntity3;
                    break;
                case 3:
                    int i6 = i3;
                    iF = i;
                    iF2 = i6;
                    ParticipantEntity participantEntity5 = participantEntity2;
                    strL = str;
                    participantEntity = participantEntity5;
                    iF3 = i2;
                    jG = com.google.android.gms.common.internal.safeparcel.a.g(parcel, iB);
                    GameEntity gameEntity4 = gameEntity2;
                    arrayListC = arrayList;
                    gameEntity = gameEntity4;
                    break;
                case 4:
                    int i7 = i3;
                    iF = i;
                    iF2 = i7;
                    ParticipantEntity participantEntity6 = participantEntity2;
                    strL = str;
                    participantEntity = participantEntity6;
                    long j4 = j;
                    iF3 = com.google.android.gms.common.internal.safeparcel.a.f(parcel, iB);
                    jG = j4;
                    GameEntity gameEntity5 = gameEntity2;
                    arrayListC = arrayList;
                    gameEntity = gameEntity5;
                    break;
                case 5:
                    strL = str;
                    participantEntity = (ParticipantEntity) com.google.android.gms.common.internal.safeparcel.a.a(parcel, iB, ParticipantEntity.CREATOR);
                    ArrayList arrayList2 = arrayList;
                    gameEntity = gameEntity2;
                    arrayListC = arrayList2;
                    long j5 = j;
                    iF3 = i2;
                    jG = j5;
                    int i8 = i3;
                    iF = i;
                    iF2 = i8;
                    break;
                case 6:
                    int i9 = i3;
                    iF = i;
                    iF2 = i9;
                    ParticipantEntity participantEntity7 = participantEntity2;
                    strL = str;
                    participantEntity = participantEntity7;
                    long j6 = j;
                    iF3 = i2;
                    jG = j6;
                    GameEntity gameEntity6 = gameEntity2;
                    arrayListC = com.google.android.gms.common.internal.safeparcel.a.c(parcel, iB, ParticipantEntity.CREATOR);
                    gameEntity = gameEntity6;
                    break;
                case 7:
                    iF = i;
                    iF2 = com.google.android.gms.common.internal.safeparcel.a.f(parcel, iB);
                    ParticipantEntity participantEntity8 = participantEntity2;
                    strL = str;
                    participantEntity = participantEntity8;
                    long j7 = j;
                    iF3 = i2;
                    jG = j7;
                    GameEntity gameEntity7 = gameEntity2;
                    arrayListC = arrayList;
                    gameEntity = gameEntity7;
                    break;
                case 1000:
                    int i10 = i3;
                    iF = com.google.android.gms.common.internal.safeparcel.a.f(parcel, iB);
                    iF2 = i10;
                    ParticipantEntity participantEntity9 = participantEntity2;
                    strL = str;
                    participantEntity = participantEntity9;
                    long j8 = j;
                    iF3 = i2;
                    jG = j8;
                    GameEntity gameEntity8 = gameEntity2;
                    arrayListC = arrayList;
                    gameEntity = gameEntity8;
                    break;
                default:
                    com.google.android.gms.common.internal.safeparcel.a.b(parcel, iB);
                    int i11 = i3;
                    iF = i;
                    iF2 = i11;
                    ParticipantEntity participantEntity10 = participantEntity2;
                    strL = str;
                    participantEntity = participantEntity10;
                    long j9 = j;
                    iF3 = i2;
                    jG = j9;
                    GameEntity gameEntity9 = gameEntity2;
                    arrayListC = arrayList;
                    gameEntity = gameEntity9;
                    break;
            }
            int i12 = iF2;
            i = iF;
            i3 = i12;
            ParticipantEntity participantEntity11 = participantEntity;
            str = strL;
            participantEntity2 = participantEntity11;
            i2 = iF3;
            j = jG;
            GameEntity gameEntity10 = gameEntity;
            arrayList = arrayListC;
            gameEntity2 = gameEntity10;
        }
        if (parcel.dataPosition() != iC) {
            throw new a.C0003a("Overread allowed size end=" + iC, parcel);
        }
        return new InvitationEntity(i, gameEntity2, str, j, i2, participantEntity2, arrayList, i3);
    }
}
