package com.google.android.gms.internal;

/* loaded from: classes.dex */
public final class bc {
    public static String G(int i) {
        switch (i) {
            case 0:
                return "PUBLIC";
            case 1:
                return "SOCIAL";
            default:
                throw new IllegalArgumentException("Unknown leaderboard collection: " + i);
        }
    }
}
