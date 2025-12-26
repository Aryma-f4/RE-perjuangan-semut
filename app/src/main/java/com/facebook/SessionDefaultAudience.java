package com.facebook;

import com.facebook.internal.NativeProtocol;

/* loaded from: classes.dex */
public enum SessionDefaultAudience {
    NONE(null),
    ONLY_ME(NativeProtocol.AUDIENCE_ME),
    FRIENDS(NativeProtocol.AUDIENCE_FRIENDS),
    EVERYONE(NativeProtocol.AUDIENCE_EVERYONE);

    private final String nativeProtocolAudience;

    SessionDefaultAudience(String str) {
        this.nativeProtocolAudience = str;
    }

    String getNativeProtocolAudience() {
        return this.nativeProtocolAudience;
    }
}
