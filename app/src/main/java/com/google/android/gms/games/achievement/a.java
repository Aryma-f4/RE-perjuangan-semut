package com.google.android.gms.games.achievement;

import android.database.CharArrayBuffer;
import android.net.Uri;
import com.facebook.internal.ServerProtocol;
import com.google.android.gms.common.data.b;
import com.google.android.gms.common.data.d;
import com.google.android.gms.games.Player;
import com.google.android.gms.internal.h;
import com.google.android.gms.internal.r;
import com.google.android.gms.plus.PlusShare;

/* loaded from: classes.dex */
public final class a extends b implements Achievement {
    a(d dVar, int i) {
        super(dVar, i);
    }

    @Override // com.google.android.gms.games.achievement.Achievement
    public String getAchievementId() {
        return getString("external_achievement_id");
    }

    @Override // com.google.android.gms.games.achievement.Achievement
    public int getCurrentSteps() {
        h.a(getType() == 1);
        return getInteger("current_steps");
    }

    @Override // com.google.android.gms.games.achievement.Achievement
    public String getDescription() {
        return getString(PlusShare.KEY_CONTENT_DEEP_LINK_METADATA_DESCRIPTION);
    }

    @Override // com.google.android.gms.games.achievement.Achievement
    public void getDescription(CharArrayBuffer dataOut) {
        a(PlusShare.KEY_CONTENT_DEEP_LINK_METADATA_DESCRIPTION, dataOut);
    }

    @Override // com.google.android.gms.games.achievement.Achievement
    public String getFormattedCurrentSteps() {
        h.a(getType() == 1);
        return getString("formatted_current_steps");
    }

    @Override // com.google.android.gms.games.achievement.Achievement
    public void getFormattedCurrentSteps(CharArrayBuffer dataOut) {
        h.a(getType() == 1);
        a("formatted_current_steps", dataOut);
    }

    @Override // com.google.android.gms.games.achievement.Achievement
    public String getFormattedTotalSteps() {
        h.a(getType() == 1);
        return getString("formatted_total_steps");
    }

    @Override // com.google.android.gms.games.achievement.Achievement
    public void getFormattedTotalSteps(CharArrayBuffer dataOut) {
        h.a(getType() == 1);
        a("formatted_total_steps", dataOut);
    }

    @Override // com.google.android.gms.games.achievement.Achievement
    public long getLastUpdatedTimestamp() {
        return getLong("last_updated_timestamp");
    }

    @Override // com.google.android.gms.games.achievement.Achievement
    public String getName() {
        return getString("name");
    }

    @Override // com.google.android.gms.games.achievement.Achievement
    public void getName(CharArrayBuffer dataOut) {
        a("name", dataOut);
    }

    @Override // com.google.android.gms.games.achievement.Achievement
    public Player getPlayer() {
        return new com.google.android.gms.games.d(this.S, this.V);
    }

    @Override // com.google.android.gms.games.achievement.Achievement
    public Uri getRevealedImageUri() {
        return d("revealed_icon_image_uri");
    }

    @Override // com.google.android.gms.games.achievement.Achievement
    public int getState() {
        return getInteger("state");
    }

    @Override // com.google.android.gms.games.achievement.Achievement
    public int getTotalSteps() {
        h.a(getType() == 1);
        return getInteger("total_steps");
    }

    @Override // com.google.android.gms.games.achievement.Achievement
    public int getType() {
        return getInteger(ServerProtocol.DIALOG_PARAM_TYPE);
    }

    @Override // com.google.android.gms.games.achievement.Achievement
    public Uri getUnlockedImageUri() {
        return d("unlocked_icon_image_uri");
    }

    public String toString() {
        r.a aVarA = r.c(this).a("id", getAchievementId()).a("name", getName()).a("state", Integer.valueOf(getState())).a(ServerProtocol.DIALOG_PARAM_TYPE, Integer.valueOf(getType()));
        if (getType() == 1) {
            aVarA.a("steps", getCurrentSteps() + "/" + getTotalSteps());
        }
        return aVarA.toString();
    }
}
