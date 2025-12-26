package com.google.android.gms.games.leaderboard;

import com.google.android.gms.internal.bc;
import com.google.android.gms.internal.bd;
import com.google.android.gms.internal.r;

/* loaded from: classes.dex */
public final class e extends com.google.android.gms.common.data.b implements LeaderboardVariant {
    e(com.google.android.gms.common.data.d dVar, int i) {
        super(dVar, i);
    }

    public String aI() {
        return getString("top_page_token_next");
    }

    public String aJ() {
        return getString("window_page_token_prev");
    }

    public String aK() {
        return getString("window_page_token_next");
    }

    @Override // com.google.android.gms.games.leaderboard.LeaderboardVariant
    public int getCollection() {
        return getInteger("collection");
    }

    @Override // com.google.android.gms.games.leaderboard.LeaderboardVariant
    public String getDisplayPlayerRank() {
        return getString("player_display_rank");
    }

    @Override // com.google.android.gms.games.leaderboard.LeaderboardVariant
    public String getDisplayPlayerScore() {
        return getString("player_display_score");
    }

    @Override // com.google.android.gms.games.leaderboard.LeaderboardVariant
    public long getNumScores() {
        if (e("total_scores")) {
            return -1L;
        }
        return getLong("total_scores");
    }

    @Override // com.google.android.gms.games.leaderboard.LeaderboardVariant
    public long getPlayerRank() {
        if (e("player_rank")) {
            return -1L;
        }
        return getLong("player_rank");
    }

    @Override // com.google.android.gms.games.leaderboard.LeaderboardVariant
    public long getRawPlayerScore() {
        if (e("player_raw_score")) {
            return -1L;
        }
        return getLong("player_raw_score");
    }

    @Override // com.google.android.gms.games.leaderboard.LeaderboardVariant
    public int getTimeSpan() {
        return getInteger("timespan");
    }

    @Override // com.google.android.gms.games.leaderboard.LeaderboardVariant
    public boolean hasPlayerInfo() {
        return !e("player_raw_score");
    }

    public String toString() {
        return r.c(this).a("TimeSpan", bd.G(getTimeSpan())).a("Collection", bc.G(getCollection())).a("RawPlayerScore", hasPlayerInfo() ? Long.valueOf(getRawPlayerScore()) : "none").a("DisplayPlayerScore", hasPlayerInfo() ? getDisplayPlayerScore() : "none").a("PlayerRank", hasPlayerInfo() ? Long.valueOf(getPlayerRank()) : "none").a("DisplayPlayerRank", hasPlayerInfo() ? getDisplayPlayerRank() : "none").a("NumScores", Long.valueOf(getNumScores())).a("TopPageNextToken", aI()).a("WindowPageNextToken", aK()).a("WindowPagePrevToken", aJ()).toString();
    }
}
