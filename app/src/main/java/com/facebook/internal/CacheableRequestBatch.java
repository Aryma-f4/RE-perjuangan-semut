package com.facebook.internal;

import com.facebook.Request;
import com.facebook.RequestBatch;

/* loaded from: classes.dex */
public class CacheableRequestBatch extends RequestBatch {
    private String cacheKey;
    private boolean forceRoundTrip;

    public CacheableRequestBatch() {
    }

    public CacheableRequestBatch(Request... requestArr) {
        super(requestArr);
    }

    public final String getCacheKeyOverride() {
        return this.cacheKey;
    }

    public final boolean getForceRoundTrip() {
        return this.forceRoundTrip;
    }

    public final void setCacheKeyOverride(String str) {
        this.cacheKey = str;
    }

    public final void setForceRoundTrip(boolean z) {
        this.forceRoundTrip = z;
    }
}
