package com.google.android.gms.games.leaderboard;

import com.google.android.gms.internal.bd;
import com.google.android.gms.internal.r;
import com.google.android.gms.internal.s;
import java.util.HashMap;

/* loaded from: classes.dex */
public final class SubmitScoreResult {
    private static final String[] eB = {"leaderboardId", "playerId", "timeSpan", "hasResult", "rawScore", "formattedScore", "newBest"};
    private String dx;
    private String eC;
    private HashMap<Integer, Result> eD;
    private int p;

    public static final class Result {
        public final String formattedScore;
        public final boolean newBest;
        public final long rawScore;

        public Result(long rawScore, String formattedScore, boolean newBest) {
            this.rawScore = rawScore;
            this.formattedScore = formattedScore;
            this.newBest = newBest;
        }

        public String toString() {
            return r.c(this).a("RawScore", Long.valueOf(this.rawScore)).a("FormattedScore", this.formattedScore).a("NewBest", Boolean.valueOf(this.newBest)).toString();
        }
    }

    public SubmitScoreResult(int statusCode, String leaderboardId, String playerId) {
        this(statusCode, leaderboardId, playerId, new HashMap());
    }

    public SubmitScoreResult(int statusCode, String leaderboardId, String playerId, HashMap<Integer, Result> results) {
        this.p = statusCode;
        this.eC = leaderboardId;
        this.dx = playerId;
        this.eD = results;
    }

    public SubmitScoreResult(com.google.android.gms.common.data.d dataHolder) {
        this.p = dataHolder.getStatusCode();
        this.eD = new HashMap<>();
        int count = dataHolder.getCount();
        s.c(count == 3);
        for (int i = 0; i < count; i++) {
            int iE = dataHolder.e(i);
            if (i == 0) {
                this.eC = dataHolder.c("leaderboardId", i, iE);
                this.dx = dataHolder.c("playerId", i, iE);
            }
            if (dataHolder.d("hasResult", i, iE)) {
                a(new Result(dataHolder.a("rawScore", i, iE), dataHolder.c("formattedScore", i, iE), dataHolder.d("newBest", i, iE)), dataHolder.b("timeSpan", i, iE));
            }
        }
    }

    private void a(Result result, int i) {
        this.eD.put(Integer.valueOf(i), result);
    }

    public String getLeaderboardId() {
        return this.eC;
    }

    public String getPlayerId() {
        return this.dx;
    }

    public Result getScoreResult(int timeSpan) {
        return this.eD.get(Integer.valueOf(timeSpan));
    }

    public int getStatusCode() {
        return this.p;
    }

    public String toString() {
        r.a aVarA = r.c(this).a("PlayerId", this.dx).a("StatusCode", Integer.valueOf(this.p));
        int i = 0;
        while (true) {
            int i2 = i;
            if (i2 >= 3) {
                return aVarA.toString();
            }
            Result result = this.eD.get(Integer.valueOf(i2));
            aVarA.a("TimesSpan", bd.G(i2));
            aVarA.a("Result", result == null ? "null" : result.toString());
            i = i2 + 1;
        }
    }
}
