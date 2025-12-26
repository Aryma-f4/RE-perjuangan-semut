package com.google.android.gms.games.multiplayer;

import android.database.CharArrayBuffer;
import android.net.Uri;
import android.os.Parcel;
import com.google.android.gms.games.Player;

/* loaded from: classes.dex */
public final class d extends com.google.android.gms.common.data.b implements Participant {
    private final com.google.android.gms.games.d eS;

    public d(com.google.android.gms.common.data.d dVar, int i) {
        super(dVar, i);
        this.eS = new com.google.android.gms.games.d(dVar, i);
    }

    @Override // com.google.android.gms.games.multiplayer.Participant
    public String aM() {
        return getString("client_address");
    }

    @Override // com.google.android.gms.games.multiplayer.Participant
    public int aN() {
        return getInteger("capabilities");
    }

    @Override // android.os.Parcelable
    public int describeContents() {
        return 0;
    }

    @Override // com.google.android.gms.common.data.b
    public boolean equals(Object obj) {
        return ParticipantEntity.a(this, obj);
    }

    /* JADX WARN: Can't rename method to resolve collision */
    @Override // com.google.android.gms.common.data.Freezable
    public Participant freeze() {
        return new ParticipantEntity(this);
    }

    @Override // com.google.android.gms.games.multiplayer.Participant
    public String getDisplayName() {
        return e("external_player_id") ? getString("default_display_name") : this.eS.getDisplayName();
    }

    @Override // com.google.android.gms.games.multiplayer.Participant
    public void getDisplayName(CharArrayBuffer dataOut) {
        if (e("external_player_id")) {
            a("default_display_name", dataOut);
        } else {
            this.eS.getDisplayName(dataOut);
        }
    }

    @Override // com.google.android.gms.games.multiplayer.Participant
    public Uri getHiResImageUri() {
        if (e("external_player_id")) {
            return null;
        }
        return this.eS.getHiResImageUri();
    }

    @Override // com.google.android.gms.games.multiplayer.Participant
    public Uri getIconImageUri() {
        return e("external_player_id") ? d("default_display_image_uri") : this.eS.getIconImageUri();
    }

    @Override // com.google.android.gms.games.multiplayer.Participant
    public String getParticipantId() {
        return getString("external_participant_id");
    }

    @Override // com.google.android.gms.games.multiplayer.Participant
    public Player getPlayer() {
        if (e("external_player_id")) {
            return null;
        }
        return this.eS;
    }

    @Override // com.google.android.gms.games.multiplayer.Participant
    public int getStatus() {
        return getInteger("player_status");
    }

    @Override // com.google.android.gms.common.data.b
    public int hashCode() {
        return ParticipantEntity.a(this);
    }

    @Override // com.google.android.gms.games.multiplayer.Participant
    public boolean isConnectedToRoom() {
        return getInteger("connected") > 0;
    }

    public String toString() {
        return ParticipantEntity.b(this);
    }

    @Override // android.os.Parcelable
    public void writeToParcel(Parcel dest, int flags) {
        ((ParticipantEntity) freeze()).writeToParcel(dest, flags);
    }
}
