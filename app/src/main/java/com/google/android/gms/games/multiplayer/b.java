package com.google.android.gms.games.multiplayer;

import android.os.Parcel;
import com.facebook.internal.ServerProtocol;
import com.google.android.gms.games.Game;
import com.google.android.gms.internal.s;
import java.util.ArrayList;

/* loaded from: classes.dex */
public final class b extends com.google.android.gms.common.data.b implements Invitation {
    private final ArrayList<Participant> eJ;
    private final Game eL;
    private final d eM;

    b(com.google.android.gms.common.data.d dVar, int i, int i2) {
        super(dVar, i);
        this.eL = new com.google.android.gms.games.b(dVar, i);
        this.eJ = new ArrayList<>(i2);
        String string = getString("external_inviter_id");
        d dVar2 = null;
        for (int i3 = 0; i3 < i2; i3++) {
            d dVar3 = new d(this.S, this.V + i3);
            if (dVar3.getParticipantId().equals(string)) {
                dVar2 = dVar3;
            }
            this.eJ.add(dVar3);
        }
        this.eM = (d) s.b(dVar2, "Must have a valid inviter!");
    }

    @Override // com.google.android.gms.games.multiplayer.Invitation
    public int aL() {
        return getInteger(ServerProtocol.DIALOG_PARAM_TYPE);
    }

    @Override // android.os.Parcelable
    public int describeContents() {
        return 0;
    }

    @Override // com.google.android.gms.common.data.b
    public boolean equals(Object obj) {
        return InvitationEntity.a(this, obj);
    }

    /* JADX WARN: Can't rename method to resolve collision */
    @Override // com.google.android.gms.common.data.Freezable
    public Invitation freeze() {
        return new InvitationEntity(this);
    }

    @Override // com.google.android.gms.games.multiplayer.Invitation
    public long getCreationTimestamp() {
        return getLong("creation_timestamp");
    }

    @Override // com.google.android.gms.games.multiplayer.Invitation
    public Game getGame() {
        return this.eL;
    }

    @Override // com.google.android.gms.games.multiplayer.Invitation
    public String getInvitationId() {
        return getString("external_invitation_id");
    }

    @Override // com.google.android.gms.games.multiplayer.Invitation
    public Participant getInviter() {
        return this.eM;
    }

    @Override // com.google.android.gms.games.multiplayer.Participatable
    public ArrayList<Participant> getParticipants() {
        return this.eJ;
    }

    @Override // com.google.android.gms.games.multiplayer.Invitation
    public int getVariant() {
        return getInteger("variant");
    }

    @Override // com.google.android.gms.common.data.b
    public int hashCode() {
        return InvitationEntity.a(this);
    }

    public String toString() {
        return InvitationEntity.b(this);
    }

    @Override // android.os.Parcelable
    public void writeToParcel(Parcel dest, int flags) {
        ((InvitationEntity) freeze()).writeToParcel(dest, flags);
    }
}
