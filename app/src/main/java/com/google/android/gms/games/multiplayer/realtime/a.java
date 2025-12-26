package com.google.android.gms.games.multiplayer.realtime;

import com.google.android.gms.common.data.d;
import com.google.android.gms.common.data.f;

/* loaded from: classes.dex */
public final class a extends f<Room> {
    public a(d dVar) {
        super(dVar);
    }

    /* JADX INFO: Access modifiers changed from: protected */
    @Override // com.google.android.gms.common.data.f
    /* renamed from: b, reason: merged with bridge method [inline-methods] */
    public Room a(int i, int i2) {
        return new c(this.S, i, i2);
    }

    @Override // com.google.android.gms.common.data.f
    protected String getPrimaryDataMarkerColumn() {
        return "external_match_id";
    }
}
