package com.google.android.gms.games.multiplayer;

import android.os.Parcel;
import android.os.Parcelable;
import com.google.android.gms.games.Game;
import com.google.android.gms.games.GameEntity;
import com.google.android.gms.internal.av;
import com.google.android.gms.internal.r;
import com.google.android.gms.internal.s;
import java.util.ArrayList;

/* loaded from: classes.dex */
public final class InvitationEntity extends av implements Invitation {
    public static final Parcelable.Creator<InvitationEntity> CREATOR = new a();
    private final int ab;
    private final GameEntity eE;
    private final String eF;
    private final long eG;
    private final int eH;
    private final ParticipantEntity eI;
    private final ArrayList<ParticipantEntity> eJ;
    private final int eK;

    static final class a extends com.google.android.gms.games.multiplayer.a {
        a() {
        }

        @Override // com.google.android.gms.games.multiplayer.a, android.os.Parcelable.Creator
        /* renamed from: p */
        public InvitationEntity createFromParcel(Parcel parcel) {
            if (InvitationEntity.c(InvitationEntity.v()) || InvitationEntity.h(InvitationEntity.class.getCanonicalName())) {
                return super.createFromParcel(parcel);
            }
            GameEntity gameEntityCreateFromParcel = GameEntity.CREATOR.createFromParcel(parcel);
            String string = parcel.readString();
            long j = parcel.readLong();
            int i = parcel.readInt();
            ParticipantEntity participantEntityCreateFromParcel = ParticipantEntity.CREATOR.createFromParcel(parcel);
            int i2 = parcel.readInt();
            ArrayList arrayList = new ArrayList(i2);
            for (int i3 = 0; i3 < i2; i3++) {
                arrayList.add(ParticipantEntity.CREATOR.createFromParcel(parcel));
            }
            return new InvitationEntity(1, gameEntityCreateFromParcel, string, j, i, participantEntityCreateFromParcel, arrayList, -1);
        }
    }

    InvitationEntity(int versionCode, GameEntity game, String invitationId, long creationTimestamp, int invitationType, ParticipantEntity inviter, ArrayList<ParticipantEntity> participants, int variant) {
        this.ab = versionCode;
        this.eE = game;
        this.eF = invitationId;
        this.eG = creationTimestamp;
        this.eH = invitationType;
        this.eI = inviter;
        this.eJ = participants;
        this.eK = variant;
    }

    InvitationEntity(Invitation invitation) {
        this.ab = 1;
        this.eE = new GameEntity(invitation.getGame());
        this.eF = invitation.getInvitationId();
        this.eG = invitation.getCreationTimestamp();
        this.eH = invitation.aL();
        this.eK = invitation.getVariant();
        String participantId = invitation.getInviter().getParticipantId();
        ArrayList<Participant> participants = invitation.getParticipants();
        int size = participants.size();
        this.eJ = new ArrayList<>(size);
        Participant participant = null;
        for (int i = 0; i < size; i++) {
            Participant participant2 = participants.get(i);
            if (participant2.getParticipantId().equals(participantId)) {
                participant = participant2;
            }
            this.eJ.add((ParticipantEntity) participant2.freeze());
        }
        s.b(participant, "Must have a valid inviter!");
        this.eI = (ParticipantEntity) participant.freeze();
    }

    static int a(Invitation invitation) {
        return r.hashCode(invitation.getGame(), invitation.getInvitationId(), Long.valueOf(invitation.getCreationTimestamp()), Integer.valueOf(invitation.aL()), invitation.getInviter(), invitation.getParticipants(), Integer.valueOf(invitation.getVariant()));
    }

    static boolean a(Invitation invitation, Object obj) {
        if (!(obj instanceof Invitation)) {
            return false;
        }
        if (invitation == obj) {
            return true;
        }
        Invitation invitation2 = (Invitation) obj;
        return r.a(invitation2.getGame(), invitation.getGame()) && r.a(invitation2.getInvitationId(), invitation.getInvitationId()) && r.a(Long.valueOf(invitation2.getCreationTimestamp()), Long.valueOf(invitation.getCreationTimestamp())) && r.a(Integer.valueOf(invitation2.aL()), Integer.valueOf(invitation.aL())) && r.a(invitation2.getInviter(), invitation.getInviter()) && r.a(invitation2.getParticipants(), invitation.getParticipants()) && r.a(Integer.valueOf(invitation2.getVariant()), Integer.valueOf(invitation.getVariant()));
    }

    static String b(Invitation invitation) {
        return r.c(invitation).a("Game", invitation.getGame()).a("InvitationId", invitation.getInvitationId()).a("CreationTimestamp", Long.valueOf(invitation.getCreationTimestamp())).a("InvitationType", Integer.valueOf(invitation.aL())).a("Inviter", invitation.getInviter()).a("Participants", invitation.getParticipants()).a("Variant", Integer.valueOf(invitation.getVariant())).toString();
    }

    @Override // com.google.android.gms.games.multiplayer.Invitation
    public int aL() {
        return this.eH;
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
    public Invitation freeze() {
        return this;
    }

    @Override // com.google.android.gms.games.multiplayer.Invitation
    public long getCreationTimestamp() {
        return this.eG;
    }

    @Override // com.google.android.gms.games.multiplayer.Invitation
    public Game getGame() {
        return this.eE;
    }

    @Override // com.google.android.gms.games.multiplayer.Invitation
    public String getInvitationId() {
        return this.eF;
    }

    @Override // com.google.android.gms.games.multiplayer.Invitation
    public Participant getInviter() {
        return this.eI;
    }

    @Override // com.google.android.gms.games.multiplayer.Participatable
    public ArrayList<Participant> getParticipants() {
        return new ArrayList<>(this.eJ);
    }

    @Override // com.google.android.gms.games.multiplayer.Invitation
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
            com.google.android.gms.games.multiplayer.a.a(this, dest, flags);
            return;
        }
        this.eE.writeToParcel(dest, flags);
        dest.writeString(this.eF);
        dest.writeLong(this.eG);
        dest.writeInt(this.eH);
        this.eI.writeToParcel(dest, flags);
        int size = this.eJ.size();
        dest.writeInt(size);
        for (int i = 0; i < size; i++) {
            this.eJ.get(i).writeToParcel(dest, flags);
        }
    }
}
