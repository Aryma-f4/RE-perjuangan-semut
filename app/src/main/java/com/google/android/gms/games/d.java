package com.google.android.gms.games;

import android.database.CharArrayBuffer;
import android.net.Uri;
import android.os.Parcel;

/* loaded from: classes.dex */
public final class d extends com.google.android.gms.common.data.b implements Player {
    public d(com.google.android.gms.common.data.d dVar, int i) {
        super(dVar, i);
    }

    @Override // android.os.Parcelable
    public int describeContents() {
        return 0;
    }

    @Override // com.google.android.gms.common.data.b
    public boolean equals(Object obj) {
        return PlayerEntity.a(this, obj);
    }

    /* JADX WARN: Can't rename method to resolve collision */
    @Override // com.google.android.gms.common.data.Freezable
    public Player freeze() {
        return new PlayerEntity(this);
    }

    @Override // com.google.android.gms.games.Player
    public String getDisplayName() {
        return getString("profile_name");
    }

    @Override // com.google.android.gms.games.Player
    public void getDisplayName(CharArrayBuffer dataOut) {
        a("profile_name", dataOut);
    }

    @Override // com.google.android.gms.games.Player
    public Uri getHiResImageUri() {
        return d("profile_hi_res_image_uri");
    }

    @Override // com.google.android.gms.games.Player
    public Uri getIconImageUri() {
        return d("profile_icon_image_uri");
    }

    @Override // com.google.android.gms.games.Player
    public String getPlayerId() {
        return getString("external_player_id");
    }

    @Override // com.google.android.gms.games.Player
    public long getRetrievedTimestamp() {
        return getLong("last_updated");
    }

    @Override // com.google.android.gms.games.Player
    public boolean hasHiResImage() {
        return getHiResImageUri() != null;
    }

    @Override // com.google.android.gms.games.Player
    public boolean hasIconImage() {
        return getIconImageUri() != null;
    }

    @Override // com.google.android.gms.common.data.b
    public int hashCode() {
        return PlayerEntity.a(this);
    }

    public String toString() {
        return PlayerEntity.b(this);
    }

    @Override // android.os.Parcelable
    public void writeToParcel(Parcel dest, int flags) {
        ((PlayerEntity) freeze()).writeToParcel(dest, flags);
    }
}
