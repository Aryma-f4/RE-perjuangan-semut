package com.facebook;

import android.os.Bundle;

/* loaded from: classes.dex */
public class LegacyHelper {
    @Deprecated
    public static void extendTokenCompleted(Session session, Bundle bundle) {
        session.extendTokenCompleted(bundle);
    }
}
