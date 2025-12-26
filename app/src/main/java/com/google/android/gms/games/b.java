package com.google.android.gms.games;

import android.database.CharArrayBuffer;
import android.net.Uri;
import android.os.Parcel;

/* loaded from: classes.dex */
public final class b extends com.google.android.gms.common.data.b implements Game {
    public b(com.google.android.gms.common.data.d dVar, int i) {
        super(dVar, i);
    }

    @Override // android.os.Parcelable
    public int describeContents() {
        return 0;
    }

    @Override // com.google.android.gms.common.data.b
    public boolean equals(Object obj) {
        return GameEntity.a(this, obj);
    }

    /* JADX WARN: Can't rename method to resolve collision */
    @Override // com.google.android.gms.common.data.Freezable
    public Game freeze() {
        return new GameEntity(this);
    }

    @Override // com.google.android.gms.games.Game
    public int getAchievementTotalCount() {
        return getInteger("achievement_total_count");
    }

    @Override // com.google.android.gms.games.Game
    public String getApplicationId() {
        return getString("external_game_id");
    }

    @Override // com.google.android.gms.games.Game
    public String getDescription() {
        return getString("game_description");
    }

    @Override // com.google.android.gms.games.Game
    public void getDescription(CharArrayBuffer dataOut) {
        a("game_description", dataOut);
    }

    @Override // com.google.android.gms.games.Game
    public String getDeveloperName() {
        return getString("developer_name");
    }

    @Override // com.google.android.gms.games.Game
    public void getDeveloperName(CharArrayBuffer dataOut) {
        a("developer_name", dataOut);
    }

    @Override // com.google.android.gms.games.Game
    public String getDisplayName() {
        return getString("display_name");
    }

    @Override // com.google.android.gms.games.Game
    public void getDisplayName(CharArrayBuffer dataOut) {
        a("display_name", dataOut);
    }

    @Override // com.google.android.gms.games.Game
    public Uri getFeaturedImageUri() {
        return d("featured_image_uri");
    }

    @Override // com.google.android.gms.games.Game
    public int getGameplayAclStatus() {
        return getInteger("gameplay_acl_status");
    }

    @Override // com.google.android.gms.games.Game
    public Uri getHiResImageUri() {
        return d("game_hi_res_image_uri");
    }

    @Override // com.google.android.gms.games.Game
    public Uri getIconImageUri() {
        return d("game_icon_image_uri");
    }

    @Override // com.google.android.gms.games.Game
    public String getInstancePackageName() {
        return getString("package_name");
    }

    @Override // com.google.android.gms.games.Game
    public int getLeaderboardCount() {
        return getInteger("leaderboard_count");
    }

    @Override // com.google.android.gms.games.Game
    public String getPrimaryCategory() {
        return getString("primary_category");
    }

    @Override // com.google.android.gms.games.Game
    public String getSecondaryCategory() {
        return getString("secondary_category");
    }

    @Override // com.google.android.gms.common.data.b
    public int hashCode() {
        return GameEntity.a(this);
    }

    @Override // com.google.android.gms.games.Game
    public boolean isInstanceInstalled() {
        return getInteger("installed") > 0;
    }

    @Override // com.google.android.gms.games.Game
    public boolean isPlayEnabledGame() {
        return getBoolean("play_enabled_game");
    }

    public String toString() {
        return GameEntity.b(this);
    }

    @Override // android.os.Parcelable
    public void writeToParcel(Parcel dest, int flags) {
        ((GameEntity) freeze()).writeToParcel(dest, flags);
    }
}
