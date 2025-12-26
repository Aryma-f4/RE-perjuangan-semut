package com.google.android.gms.games;

import android.database.CharArrayBuffer;
import android.net.Uri;
import android.os.Parcel;
import android.os.Parcelable;
import com.google.android.gms.internal.ao;
import com.google.android.gms.internal.av;
import com.google.android.gms.internal.h;
import com.google.android.gms.internal.r;

/* loaded from: classes.dex */
public final class PlayerEntity extends av implements Player {
    public static final Parcelable.Creator<PlayerEntity> CREATOR = new a();
    private final int ab;
    private final String cl;
    private final Uri dk;
    private final Uri dl;
    private final String dx;
    private final long dy;

    static final class a extends c {
        a() {
        }

        @Override // com.google.android.gms.games.c, android.os.Parcelable.Creator
        /* renamed from: o */
        public PlayerEntity createFromParcel(Parcel parcel) {
            if (PlayerEntity.c(PlayerEntity.v()) || PlayerEntity.h(PlayerEntity.class.getCanonicalName())) {
                return super.createFromParcel(parcel);
            }
            String string = parcel.readString();
            String string2 = parcel.readString();
            String string3 = parcel.readString();
            String string4 = parcel.readString();
            return new PlayerEntity(1, string, string2, string3 == null ? null : Uri.parse(string3), string4 != null ? Uri.parse(string4) : null, parcel.readLong());
        }
    }

    PlayerEntity(int versionCode, String playerId, String displayName, Uri iconImageUri, Uri hiResImageUri, long retrievedTimestamp) {
        this.ab = versionCode;
        this.dx = playerId;
        this.cl = displayName;
        this.dk = iconImageUri;
        this.dl = hiResImageUri;
        this.dy = retrievedTimestamp;
    }

    public PlayerEntity(Player player) {
        this.ab = 1;
        this.dx = player.getPlayerId();
        this.cl = player.getDisplayName();
        this.dk = player.getIconImageUri();
        this.dl = player.getHiResImageUri();
        this.dy = player.getRetrievedTimestamp();
        h.b(this.dx);
        h.b(this.cl);
        h.a(this.dy > 0);
    }

    static int a(Player player) {
        return r.hashCode(player.getPlayerId(), player.getDisplayName(), player.getIconImageUri(), player.getHiResImageUri(), Long.valueOf(player.getRetrievedTimestamp()));
    }

    static boolean a(Player player, Object obj) {
        if (!(obj instanceof Player)) {
            return false;
        }
        if (player == obj) {
            return true;
        }
        Player player2 = (Player) obj;
        return r.a(player2.getPlayerId(), player.getPlayerId()) && r.a(player2.getDisplayName(), player.getDisplayName()) && r.a(player2.getIconImageUri(), player.getIconImageUri()) && r.a(player2.getHiResImageUri(), player.getHiResImageUri()) && r.a(Long.valueOf(player2.getRetrievedTimestamp()), Long.valueOf(player.getRetrievedTimestamp()));
    }

    static String b(Player player) {
        return r.c(player).a("PlayerId", player.getPlayerId()).a("DisplayName", player.getDisplayName()).a("IconImageUri", player.getIconImageUri()).a("HiResImageUri", player.getHiResImageUri()).a("RetrievedTimestamp", Long.valueOf(player.getRetrievedTimestamp())).toString();
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
    public Player freeze() {
        return this;
    }

    @Override // com.google.android.gms.games.Player
    public String getDisplayName() {
        return this.cl;
    }

    @Override // com.google.android.gms.games.Player
    public void getDisplayName(CharArrayBuffer dataOut) {
        ao.b(this.cl, dataOut);
    }

    @Override // com.google.android.gms.games.Player
    public Uri getHiResImageUri() {
        return this.dl;
    }

    @Override // com.google.android.gms.games.Player
    public Uri getIconImageUri() {
        return this.dk;
    }

    @Override // com.google.android.gms.games.Player
    public String getPlayerId() {
        return this.dx;
    }

    @Override // com.google.android.gms.games.Player
    public long getRetrievedTimestamp() {
        return this.dy;
    }

    @Override // com.google.android.gms.games.Player
    public boolean hasHiResImage() {
        return getHiResImageUri() != null;
    }

    @Override // com.google.android.gms.games.Player
    public boolean hasIconImage() {
        return getIconImageUri() != null;
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
            c.a(this, dest, flags);
            return;
        }
        dest.writeString(this.dx);
        dest.writeString(this.cl);
        dest.writeString(this.dk == null ? null : this.dk.toString());
        dest.writeString(this.dl == null ? null : this.dl.toString());
        dest.writeLong(this.dy);
    }
}
