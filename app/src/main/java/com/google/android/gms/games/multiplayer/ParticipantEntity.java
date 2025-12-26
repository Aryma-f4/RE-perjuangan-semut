package com.google.android.gms.games.multiplayer;

import android.database.CharArrayBuffer;
import android.net.Uri;
import android.os.Parcel;
import android.os.Parcelable;
import com.google.android.gms.games.Player;
import com.google.android.gms.games.PlayerEntity;
import com.google.android.gms.internal.ao;
import com.google.android.gms.internal.av;
import com.google.android.gms.internal.r;

/* loaded from: classes.dex */
public final class ParticipantEntity extends av implements Participant {
    public static final Parcelable.Creator<ParticipantEntity> CREATOR = new a();
    private final int ab;
    private final String cl;
    private final String dX;
    private final Uri dk;
    private final Uri dl;
    private final int eN;
    private final String eO;
    private final boolean eP;
    private final PlayerEntity eQ;
    private final int eR;

    static final class a extends c {
        a() {
        }

        @Override // com.google.android.gms.games.multiplayer.c, android.os.Parcelable.Creator
        /* renamed from: q, reason: merged with bridge method [inline-methods] */
        public ParticipantEntity createFromParcel(Parcel parcel) {
            if (ParticipantEntity.c(ParticipantEntity.v()) || ParticipantEntity.h(ParticipantEntity.class.getCanonicalName())) {
                return super.createFromParcel(parcel);
            }
            String string = parcel.readString();
            String string2 = parcel.readString();
            String string3 = parcel.readString();
            Uri uri = string3 == null ? null : Uri.parse(string3);
            String string4 = parcel.readString();
            return new ParticipantEntity(1, string, string2, uri, string4 == null ? null : Uri.parse(string4), parcel.readInt(), parcel.readString(), parcel.readInt() > 0, parcel.readInt() > 0 ? PlayerEntity.CREATOR.createFromParcel(parcel) : null, 7);
        }
    }

    ParticipantEntity(int versionCode, String participantId, String displayName, Uri iconImageUri, Uri hiResImageUri, int status, String clientAddress, boolean connectedToRoom, PlayerEntity player, int capabilities) {
        this.ab = versionCode;
        this.dX = participantId;
        this.cl = displayName;
        this.dk = iconImageUri;
        this.dl = hiResImageUri;
        this.eN = status;
        this.eO = clientAddress;
        this.eP = connectedToRoom;
        this.eQ = player;
        this.eR = capabilities;
    }

    public ParticipantEntity(Participant participant) {
        this.ab = 1;
        this.dX = participant.getParticipantId();
        this.cl = participant.getDisplayName();
        this.dk = participant.getIconImageUri();
        this.dl = participant.getHiResImageUri();
        this.eN = participant.getStatus();
        this.eO = participant.aM();
        this.eP = participant.isConnectedToRoom();
        Player player = participant.getPlayer();
        this.eQ = player == null ? null : new PlayerEntity(player);
        this.eR = participant.aN();
    }

    static int a(Participant participant) {
        return r.hashCode(participant.getPlayer(), Integer.valueOf(participant.getStatus()), participant.aM(), Boolean.valueOf(participant.isConnectedToRoom()), participant.getDisplayName(), participant.getIconImageUri(), participant.getHiResImageUri(), Integer.valueOf(participant.aN()));
    }

    static boolean a(Participant participant, Object obj) {
        if (!(obj instanceof Participant)) {
            return false;
        }
        if (participant == obj) {
            return true;
        }
        Participant participant2 = (Participant) obj;
        return r.a(participant2.getPlayer(), participant.getPlayer()) && r.a(Integer.valueOf(participant2.getStatus()), Integer.valueOf(participant.getStatus())) && r.a(participant2.aM(), participant.aM()) && r.a(Boolean.valueOf(participant2.isConnectedToRoom()), Boolean.valueOf(participant.isConnectedToRoom())) && r.a(participant2.getDisplayName(), participant.getDisplayName()) && r.a(participant2.getIconImageUri(), participant.getIconImageUri()) && r.a(participant2.getHiResImageUri(), participant.getHiResImageUri()) && r.a(Integer.valueOf(participant2.aN()), Integer.valueOf(participant.aN()));
    }

    static String b(Participant participant) {
        return r.c(participant).a("Player", participant.getPlayer()).a("Status", Integer.valueOf(participant.getStatus())).a("ClientAddress", participant.aM()).a("ConnectedToRoom", Boolean.valueOf(participant.isConnectedToRoom())).a("DisplayName", participant.getDisplayName()).a("IconImage", participant.getIconImageUri()).a("HiResImage", participant.getHiResImageUri()).a("Capabilities", Integer.valueOf(participant.aN())).toString();
    }

    @Override // com.google.android.gms.games.multiplayer.Participant
    public String aM() {
        return this.eO;
    }

    @Override // com.google.android.gms.games.multiplayer.Participant
    public int aN() {
        return this.eR;
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
    public Participant freeze() {
        return this;
    }

    @Override // com.google.android.gms.games.multiplayer.Participant
    public String getDisplayName() {
        return this.eQ == null ? this.cl : this.eQ.getDisplayName();
    }

    @Override // com.google.android.gms.games.multiplayer.Participant
    public void getDisplayName(CharArrayBuffer dataOut) {
        if (this.eQ == null) {
            ao.b(this.cl, dataOut);
        } else {
            this.eQ.getDisplayName(dataOut);
        }
    }

    @Override // com.google.android.gms.games.multiplayer.Participant
    public Uri getHiResImageUri() {
        return this.eQ == null ? this.dl : this.eQ.getHiResImageUri();
    }

    @Override // com.google.android.gms.games.multiplayer.Participant
    public Uri getIconImageUri() {
        return this.eQ == null ? this.dk : this.eQ.getIconImageUri();
    }

    @Override // com.google.android.gms.games.multiplayer.Participant
    public String getParticipantId() {
        return this.dX;
    }

    @Override // com.google.android.gms.games.multiplayer.Participant
    public Player getPlayer() {
        return this.eQ;
    }

    @Override // com.google.android.gms.games.multiplayer.Participant
    public int getStatus() {
        return this.eN;
    }

    public int hashCode() {
        return a(this);
    }

    public int i() {
        return this.ab;
    }

    @Override // com.google.android.gms.games.multiplayer.Participant
    public boolean isConnectedToRoom() {
        return this.eP;
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
            c.a(this, dest, flags);
            return;
        }
        dest.writeString(this.dX);
        dest.writeString(this.cl);
        dest.writeString(this.dk == null ? null : this.dk.toString());
        dest.writeString(this.dl == null ? null : this.dl.toString());
        dest.writeInt(this.eN);
        dest.writeString(this.eO);
        dest.writeInt(this.eP ? 1 : 0);
        dest.writeInt(this.eQ == null ? 0 : 1);
        if (this.eQ != null) {
            this.eQ.writeToParcel(dest, flags);
        }
    }
}
