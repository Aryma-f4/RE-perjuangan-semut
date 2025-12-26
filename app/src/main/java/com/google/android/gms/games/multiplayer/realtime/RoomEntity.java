package com.google.android.gms.games.multiplayer.realtime;

import android.database.CharArrayBuffer;
import android.os.Bundle;
import android.os.Parcel;
import android.os.Parcelable;
import com.google.android.gms.games.Player;
import com.google.android.gms.games.multiplayer.Participant;
import com.google.android.gms.games.multiplayer.ParticipantEntity;
import com.google.android.gms.internal.ao;
import com.google.android.gms.internal.av;
import com.google.android.gms.internal.r;
import java.util.ArrayList;

/* loaded from: classes.dex */
public final class RoomEntity extends av implements Room {
    public static final Parcelable.Creator<RoomEntity> CREATOR = new a();
    private final int ab;
    private final String dV;
    private final String di;
    private final long eG;
    private final ArrayList<ParticipantEntity> eJ;
    private final int eK;
    private final Bundle fa;
    private final String fe;
    private final int ff;
    private final int fg;

    static final class a extends b {
        a() {
        }

        @Override // com.google.android.gms.games.multiplayer.realtime.b, android.os.Parcelable.Creator
        /* renamed from: s, reason: merged with bridge method [inline-methods] */
        public RoomEntity createFromParcel(Parcel parcel) {
            if (RoomEntity.c(RoomEntity.v()) || RoomEntity.h(RoomEntity.class.getCanonicalName())) {
                return super.createFromParcel(parcel);
            }
            String string = parcel.readString();
            String string2 = parcel.readString();
            long j = parcel.readLong();
            int i = parcel.readInt();
            String string3 = parcel.readString();
            int i2 = parcel.readInt();
            Bundle bundle = parcel.readBundle();
            int i3 = parcel.readInt();
            ArrayList arrayList = new ArrayList(i3);
            for (int i4 = 0; i4 < i3; i4++) {
                arrayList.add(ParticipantEntity.CREATOR.createFromParcel(parcel));
            }
            return new RoomEntity(2, string, string2, j, i, string3, i2, bundle, arrayList, -1);
        }
    }

    RoomEntity(int versionCode, String roomId, String creatorId, long creationTimestamp, int roomStatus, String description, int variant, Bundle autoMatchCriteria, ArrayList<ParticipantEntity> participants, int autoMatchWaitEstimateSeconds) {
        this.ab = versionCode;
        this.dV = roomId;
        this.fe = creatorId;
        this.eG = creationTimestamp;
        this.ff = roomStatus;
        this.di = description;
        this.eK = variant;
        this.fa = autoMatchCriteria;
        this.eJ = participants;
        this.fg = autoMatchWaitEstimateSeconds;
    }

    public RoomEntity(Room room) {
        this.ab = 2;
        this.dV = room.getRoomId();
        this.fe = room.getCreatorId();
        this.eG = room.getCreationTimestamp();
        this.ff = room.getStatus();
        this.di = room.getDescription();
        this.eK = room.getVariant();
        this.fa = room.getAutoMatchCriteria();
        ArrayList<Participant> participants = room.getParticipants();
        int size = participants.size();
        this.eJ = new ArrayList<>(size);
        for (int i = 0; i < size; i++) {
            this.eJ.add((ParticipantEntity) participants.get(i).freeze());
        }
        this.fg = room.getAutoMatchWaitEstimateSeconds();
    }

    static int a(Room room) {
        return r.hashCode(room.getRoomId(), room.getCreatorId(), Long.valueOf(room.getCreationTimestamp()), Integer.valueOf(room.getStatus()), room.getDescription(), Integer.valueOf(room.getVariant()), room.getAutoMatchCriteria(), room.getParticipants(), Integer.valueOf(room.getAutoMatchWaitEstimateSeconds()));
    }

    static boolean a(Room room, Object obj) {
        if (!(obj instanceof Room)) {
            return false;
        }
        if (room == obj) {
            return true;
        }
        Room room2 = (Room) obj;
        return r.a(room2.getRoomId(), room.getRoomId()) && r.a(room2.getCreatorId(), room.getCreatorId()) && r.a(Long.valueOf(room2.getCreationTimestamp()), Long.valueOf(room.getCreationTimestamp())) && r.a(Integer.valueOf(room2.getStatus()), Integer.valueOf(room.getStatus())) && r.a(room2.getDescription(), room.getDescription()) && r.a(Integer.valueOf(room2.getVariant()), Integer.valueOf(room.getVariant())) && r.a(room2.getAutoMatchCriteria(), room.getAutoMatchCriteria()) && r.a(room2.getParticipants(), room.getParticipants()) && r.a(Integer.valueOf(room2.getAutoMatchWaitEstimateSeconds()), Integer.valueOf(room.getAutoMatchWaitEstimateSeconds()));
    }

    static String b(Room room) {
        return r.c(room).a("RoomId", room.getRoomId()).a("CreatorId", room.getCreatorId()).a("CreationTimestamp", Long.valueOf(room.getCreationTimestamp())).a("RoomStatus", Integer.valueOf(room.getStatus())).a("Description", room.getDescription()).a("Variant", Integer.valueOf(room.getVariant())).a("AutoMatchCriteria", room.getAutoMatchCriteria()).a("Participants", room.getParticipants()).a("AutoMatchWaitEstimateSeconds", Integer.valueOf(room.getAutoMatchWaitEstimateSeconds())).toString();
    }

    @Override // android.os.Parcelable
    public int describeContents() {
        return 0;
    }

    public boolean equals(Object obj) {
        return a(this, obj);
    }

    /* JADX WARN: Can't rename method to resolve collision */
    @Override // com.google.android.gms.common.data.Freezable
    public Room freeze() {
        return this;
    }

    @Override // com.google.android.gms.games.multiplayer.realtime.Room
    public Bundle getAutoMatchCriteria() {
        return this.fa;
    }

    @Override // com.google.android.gms.games.multiplayer.realtime.Room
    public int getAutoMatchWaitEstimateSeconds() {
        return this.fg;
    }

    @Override // com.google.android.gms.games.multiplayer.realtime.Room
    public long getCreationTimestamp() {
        return this.eG;
    }

    @Override // com.google.android.gms.games.multiplayer.realtime.Room
    public String getCreatorId() {
        return this.fe;
    }

    @Override // com.google.android.gms.games.multiplayer.realtime.Room
    public String getDescription() {
        return this.di;
    }

    @Override // com.google.android.gms.games.multiplayer.realtime.Room
    public void getDescription(CharArrayBuffer dataOut) {
        ao.b(this.di, dataOut);
    }

    @Override // com.google.android.gms.games.multiplayer.realtime.Room
    public String getParticipantId(String playerId) {
        int size = this.eJ.size();
        for (int i = 0; i < size; i++) {
            ParticipantEntity participantEntity = this.eJ.get(i);
            Player player = participantEntity.getPlayer();
            if (player != null && player.getPlayerId().equals(playerId)) {
                return participantEntity.getParticipantId();
            }
        }
        return null;
    }

    @Override // com.google.android.gms.games.multiplayer.realtime.Room
    public ArrayList<String> getParticipantIds() {
        int size = this.eJ.size();
        ArrayList<String> arrayList = new ArrayList<>(size);
        for (int i = 0; i < size; i++) {
            arrayList.add(this.eJ.get(i).getParticipantId());
        }
        return arrayList;
    }

    @Override // com.google.android.gms.games.multiplayer.realtime.Room
    public int getParticipantStatus(String participantId) {
        int size = this.eJ.size();
        for (int i = 0; i < size; i++) {
            ParticipantEntity participantEntity = this.eJ.get(i);
            if (participantEntity.getParticipantId().equals(participantId)) {
                return participantEntity.getStatus();
            }
        }
        throw new IllegalStateException("Participant " + participantId + " is not in room " + getRoomId());
    }

    @Override // com.google.android.gms.games.multiplayer.Participatable
    public ArrayList<Participant> getParticipants() {
        return new ArrayList<>(this.eJ);
    }

    @Override // com.google.android.gms.games.multiplayer.realtime.Room
    public String getRoomId() {
        return this.dV;
    }

    @Override // com.google.android.gms.games.multiplayer.realtime.Room
    public int getStatus() {
        return this.ff;
    }

    @Override // com.google.android.gms.games.multiplayer.realtime.Room
    public int getVariant() {
        return this.eK;
    }

    public int hashCode() {
        return a(this);
    }

    public int i() {
        return this.ab;
    }

    @Override // com.google.android.gms.common.data.Freezable
    public boolean isDataValid() {
        return true;
    }

    public String toString() {
        return b(this);
    }

    @Override // android.os.Parcelable
    public void writeToParcel(Parcel dest, int flags) {
        if (!w()) {
            b.a(this, dest, flags);
            return;
        }
        dest.writeString(this.dV);
        dest.writeString(this.fe);
        dest.writeLong(this.eG);
        dest.writeInt(this.ff);
        dest.writeString(this.di);
        dest.writeInt(this.eK);
        dest.writeBundle(this.fa);
        int size = this.eJ.size();
        dest.writeInt(size);
        for (int i = 0; i < size; i++) {
            this.eJ.get(i).writeToParcel(dest, flags);
        }
    }
}
