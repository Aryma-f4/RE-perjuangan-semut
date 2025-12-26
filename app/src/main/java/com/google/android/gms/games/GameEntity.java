package com.google.android.gms.games;

import android.database.CharArrayBuffer;
import android.net.Uri;
import android.os.Parcel;
import android.os.Parcelable;
import com.google.android.gms.internal.ao;
import com.google.android.gms.internal.av;
import com.google.android.gms.internal.r;

/* loaded from: classes.dex */
public final class GameEntity extends av implements Game {
    public static final Parcelable.Creator<GameEntity> CREATOR = new a();
    private final int ab;
    private final String cl;
    private final String df;
    private final String dg;
    private final String dh;
    private final String di;
    private final String dj;
    private final Uri dk;
    private final Uri dl;
    private final Uri dm;
    private final boolean dn;

    /* renamed from: do, reason: not valid java name */
    private final boolean f0do;
    private final String dp;
    private final int dq;
    private final int dr;
    private final int ds;

    static final class a extends com.google.android.gms.games.a {
        a() {
        }

        @Override // com.google.android.gms.games.a, android.os.Parcelable.Creator
        /* renamed from: n */
        public GameEntity createFromParcel(Parcel parcel) {
            if (GameEntity.c(GameEntity.v()) || GameEntity.h(GameEntity.class.getCanonicalName())) {
                return super.createFromParcel(parcel);
            }
            String string = parcel.readString();
            String string2 = parcel.readString();
            String string3 = parcel.readString();
            String string4 = parcel.readString();
            String string5 = parcel.readString();
            String string6 = parcel.readString();
            String string7 = parcel.readString();
            Uri uri = string7 == null ? null : Uri.parse(string7);
            String string8 = parcel.readString();
            Uri uri2 = string8 == null ? null : Uri.parse(string8);
            String string9 = parcel.readString();
            return new GameEntity(1, string, string2, string3, string4, string5, string6, uri, uri2, string9 == null ? null : Uri.parse(string9), parcel.readInt() > 0, parcel.readInt() > 0, parcel.readString(), parcel.readInt(), parcel.readInt(), parcel.readInt());
        }
    }

    GameEntity(int versionCode, String applicationId, String displayName, String primaryCategory, String secondaryCategory, String description, String developerName, Uri iconImageUri, Uri hiResImageUri, Uri featuredImageUri, boolean playEnabledGame, boolean instanceInstalled, String instancePackageName, int gameplayAclStatus, int achievementTotalCount, int leaderboardCount) {
        this.ab = versionCode;
        this.df = applicationId;
        this.cl = displayName;
        this.dg = primaryCategory;
        this.dh = secondaryCategory;
        this.di = description;
        this.dj = developerName;
        this.dk = iconImageUri;
        this.dl = hiResImageUri;
        this.dm = featuredImageUri;
        this.dn = playEnabledGame;
        this.f0do = instanceInstalled;
        this.dp = instancePackageName;
        this.dq = gameplayAclStatus;
        this.dr = achievementTotalCount;
        this.ds = leaderboardCount;
    }

    public GameEntity(Game game) {
        this.ab = 1;
        this.df = game.getApplicationId();
        this.dg = game.getPrimaryCategory();
        this.dh = game.getSecondaryCategory();
        this.di = game.getDescription();
        this.dj = game.getDeveloperName();
        this.cl = game.getDisplayName();
        this.dk = game.getIconImageUri();
        this.dl = game.getHiResImageUri();
        this.dm = game.getFeaturedImageUri();
        this.dn = game.isPlayEnabledGame();
        this.f0do = game.isInstanceInstalled();
        this.dp = game.getInstancePackageName();
        this.dq = game.getGameplayAclStatus();
        this.dr = game.getAchievementTotalCount();
        this.ds = game.getLeaderboardCount();
    }

    static int a(Game game) {
        return r.hashCode(game.getApplicationId(), game.getDisplayName(), game.getPrimaryCategory(), game.getSecondaryCategory(), game.getDescription(), game.getDeveloperName(), game.getIconImageUri(), game.getHiResImageUri(), game.getFeaturedImageUri(), Boolean.valueOf(game.isPlayEnabledGame()), Boolean.valueOf(game.isInstanceInstalled()), game.getInstancePackageName(), Integer.valueOf(game.getGameplayAclStatus()), Integer.valueOf(game.getAchievementTotalCount()), Integer.valueOf(game.getLeaderboardCount()));
    }

    static boolean a(Game game, Object obj) {
        if (!(obj instanceof Game)) {
            return false;
        }
        if (game == obj) {
            return true;
        }
        Game game2 = (Game) obj;
        return r.a(game2.getApplicationId(), game.getApplicationId()) && r.a(game2.getDisplayName(), game.getDisplayName()) && r.a(game2.getPrimaryCategory(), game.getPrimaryCategory()) && r.a(game2.getSecondaryCategory(), game.getSecondaryCategory()) && r.a(game2.getDescription(), game.getDescription()) && r.a(game2.getDeveloperName(), game.getDeveloperName()) && r.a(game2.getIconImageUri(), game.getIconImageUri()) && r.a(game2.getHiResImageUri(), game.getHiResImageUri()) && r.a(game2.getFeaturedImageUri(), game.getFeaturedImageUri()) && r.a(Boolean.valueOf(game2.isPlayEnabledGame()), Boolean.valueOf(game.isPlayEnabledGame())) && r.a(Boolean.valueOf(game2.isInstanceInstalled()), Boolean.valueOf(game.isInstanceInstalled())) && r.a(game2.getInstancePackageName(), game.getInstancePackageName()) && r.a(Integer.valueOf(game2.getGameplayAclStatus()), Integer.valueOf(game.getGameplayAclStatus())) && r.a(Integer.valueOf(game2.getAchievementTotalCount()), Integer.valueOf(game.getAchievementTotalCount())) && r.a(Integer.valueOf(game2.getLeaderboardCount()), Integer.valueOf(game.getLeaderboardCount()));
    }

    static String b(Game game) {
        return r.c(game).a("ApplicationId", game.getApplicationId()).a("DisplayName", game.getDisplayName()).a("PrimaryCategory", game.getPrimaryCategory()).a("SecondaryCategory", game.getSecondaryCategory()).a("Description", game.getDescription()).a("DeveloperName", game.getDeveloperName()).a("IconImageUri", game.getIconImageUri()).a("HiResImageUri", game.getHiResImageUri()).a("FeaturedImageUri", game.getFeaturedImageUri()).a("PlayEnabledGame", Boolean.valueOf(game.isPlayEnabledGame())).a("InstanceInstalled", Boolean.valueOf(game.isInstanceInstalled())).a("InstancePackageName", game.getInstancePackageName()).a("GameplayAclStatus", Integer.valueOf(game.getGameplayAclStatus())).a("AchievementTotalCount", Integer.valueOf(game.getAchievementTotalCount())).a("LeaderboardCount", Integer.valueOf(game.getLeaderboardCount())).toString();
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
    public Game freeze() {
        return this;
    }

    @Override // com.google.android.gms.games.Game
    public int getAchievementTotalCount() {
        return this.dr;
    }

    @Override // com.google.android.gms.games.Game
    public String getApplicationId() {
        return this.df;
    }

    @Override // com.google.android.gms.games.Game
    public String getDescription() {
        return this.di;
    }

    @Override // com.google.android.gms.games.Game
    public void getDescription(CharArrayBuffer dataOut) {
        ao.b(this.di, dataOut);
    }

    @Override // com.google.android.gms.games.Game
    public String getDeveloperName() {
        return this.dj;
    }

    @Override // com.google.android.gms.games.Game
    public void getDeveloperName(CharArrayBuffer dataOut) {
        ao.b(this.dj, dataOut);
    }

    @Override // com.google.android.gms.games.Game
    public String getDisplayName() {
        return this.cl;
    }

    @Override // com.google.android.gms.games.Game
    public void getDisplayName(CharArrayBuffer dataOut) {
        ao.b(this.cl, dataOut);
    }

    @Override // com.google.android.gms.games.Game
    public Uri getFeaturedImageUri() {
        return this.dm;
    }

    @Override // com.google.android.gms.games.Game
    public int getGameplayAclStatus() {
        return this.dq;
    }

    @Override // com.google.android.gms.games.Game
    public Uri getHiResImageUri() {
        return this.dl;
    }

    @Override // com.google.android.gms.games.Game
    public Uri getIconImageUri() {
        return this.dk;
    }

    @Override // com.google.android.gms.games.Game
    public String getInstancePackageName() {
        return this.dp;
    }

    @Override // com.google.android.gms.games.Game
    public int getLeaderboardCount() {
        return this.ds;
    }

    @Override // com.google.android.gms.games.Game
    public String getPrimaryCategory() {
        return this.dg;
    }

    @Override // com.google.android.gms.games.Game
    public String getSecondaryCategory() {
        return this.dh;
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

    @Override // com.google.android.gms.games.Game
    public boolean isInstanceInstalled() {
        return this.f0do;
    }

    @Override // com.google.android.gms.games.Game
    public boolean isPlayEnabledGame() {
        return this.dn;
    }

    public String toString() {
        return b(this);
    }

    @Override // android.os.Parcelable
    public void writeToParcel(Parcel dest, int flags) {
        if (!w()) {
            com.google.android.gms.games.a.a(this, dest, flags);
            return;
        }
        dest.writeString(this.df);
        dest.writeString(this.cl);
        dest.writeString(this.dg);
        dest.writeString(this.dh);
        dest.writeString(this.di);
        dest.writeString(this.dj);
        dest.writeString(this.dk == null ? null : this.dk.toString());
        dest.writeString(this.dl == null ? null : this.dl.toString());
        dest.writeString(this.dm == null ? null : this.dm.toString());
        dest.writeInt(this.dn ? 1 : 0);
        dest.writeInt(this.f0do ? 1 : 0);
        dest.writeString(this.dp);
        dest.writeInt(this.dq);
        dest.writeInt(this.dr);
        dest.writeInt(this.ds);
    }
}
