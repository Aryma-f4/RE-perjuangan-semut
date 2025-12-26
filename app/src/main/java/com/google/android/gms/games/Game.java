package com.google.android.gms.games;

import android.database.CharArrayBuffer;
import android.net.Uri;
import android.os.Parcelable;
import com.google.android.gms.common.data.Freezable;

/* loaded from: classes.dex */
public interface Game extends Parcelable, Freezable<Game> {
    int getAchievementTotalCount();

    String getApplicationId();

    String getDescription();

    void getDescription(CharArrayBuffer charArrayBuffer);

    String getDeveloperName();

    void getDeveloperName(CharArrayBuffer charArrayBuffer);

    String getDisplayName();

    void getDisplayName(CharArrayBuffer charArrayBuffer);

    Uri getFeaturedImageUri();

    int getGameplayAclStatus();

    Uri getHiResImageUri();

    Uri getIconImageUri();

    String getInstancePackageName();

    int getLeaderboardCount();

    String getPrimaryCategory();

    String getSecondaryCategory();

    boolean isInstanceInstalled();

    boolean isPlayEnabledGame();
}
