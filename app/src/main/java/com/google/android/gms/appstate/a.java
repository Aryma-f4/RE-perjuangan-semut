package com.google.android.gms.appstate;

import com.google.android.gms.internal.r;

/* loaded from: classes.dex */
public final class a implements AppState {
    private final int h;
    private final String i;
    private final byte[] j;
    private final boolean k;
    private final String l;
    private final byte[] m;

    public a(AppState appState) {
        this.h = appState.getKey();
        this.i = appState.getLocalVersion();
        this.j = appState.getLocalData();
        this.k = appState.hasConflict();
        this.l = appState.getConflictVersion();
        this.m = appState.getConflictData();
    }

    static int a(AppState appState) {
        return r.hashCode(Integer.valueOf(appState.getKey()), appState.getLocalVersion(), appState.getLocalData(), Boolean.valueOf(appState.hasConflict()), appState.getConflictVersion(), appState.getConflictData());
    }

    static boolean a(AppState appState, Object obj) {
        if (!(obj instanceof AppState)) {
            return false;
        }
        if (appState == obj) {
            return true;
        }
        AppState appState2 = (AppState) obj;
        return r.a(Integer.valueOf(appState2.getKey()), Integer.valueOf(appState.getKey())) && r.a(appState2.getLocalVersion(), appState.getLocalVersion()) && r.a(appState2.getLocalData(), appState.getLocalData()) && r.a(Boolean.valueOf(appState2.hasConflict()), Boolean.valueOf(appState.hasConflict())) && r.a(appState2.getConflictVersion(), appState.getConflictVersion()) && r.a(appState2.getConflictData(), appState.getConflictData());
    }

    static String b(AppState appState) {
        return r.c(appState).a("Key", Integer.valueOf(appState.getKey())).a("LocalVersion", appState.getLocalVersion()).a("LocalData", appState.getLocalData()).a("HasConflict", Boolean.valueOf(appState.hasConflict())).a("ConflictVersion", appState.getConflictVersion()).a("ConflictData", appState.getConflictData()).toString();
    }

    @Override // com.google.android.gms.common.data.Freezable
    /* renamed from: a, reason: merged with bridge method [inline-methods] */
    public AppState freeze() {
        return this;
    }

    public boolean equals(Object obj) {
        return a(this, obj);
    }

    @Override // com.google.android.gms.appstate.AppState
    public byte[] getConflictData() {
        return this.m;
    }

    @Override // com.google.android.gms.appstate.AppState
    public String getConflictVersion() {
        return this.l;
    }

    @Override // com.google.android.gms.appstate.AppState
    public int getKey() {
        return this.h;
    }

    @Override // com.google.android.gms.appstate.AppState
    public byte[] getLocalData() {
        return this.j;
    }

    @Override // com.google.android.gms.appstate.AppState
    public String getLocalVersion() {
        return this.i;
    }

    @Override // com.google.android.gms.appstate.AppState
    public boolean hasConflict() {
        return this.k;
    }

    public int hashCode() {
        return a(this);
    }

    @Override // com.google.android.gms.common.data.Freezable
    public boolean isDataValid() {
        return true;
    }

    public String toString() {
        return b(this);
    }
}
