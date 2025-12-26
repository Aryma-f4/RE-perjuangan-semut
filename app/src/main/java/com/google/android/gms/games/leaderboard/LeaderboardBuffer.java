package com.google.android.gms.games.leaderboard;

import com.google.android.gms.common.data.f;

/* loaded from: classes.dex */
public final class LeaderboardBuffer extends f<Leaderboard> {
    public LeaderboardBuffer(com.google.android.gms.common.data.d dataHolder) {
        super(dataHolder);
    }

    /* JADX INFO: Access modifiers changed from: protected */
    @Override // com.google.android.gms.common.data.f
    /* renamed from: getEntry, reason: merged with bridge method [inline-methods] */
    public Leaderboard a(int rowIndex, int numChildren) {
        return new a(this.S, rowIndex, numChildren);
    }

    @Override // com.google.android.gms.common.data.f
    protected String getPrimaryDataMarkerColumn() {
        return "external_leaderboard_id";
    }
}
