package com.google.android.gms.internal;

import android.content.Intent;
import android.net.Uri;
import com.facebook.internal.NativeProtocol;
import com.google.android.gms.common.GooglePlayServicesUtil;

/* loaded from: classes.dex */
public final class aw {
    public static final Intent b(Intent intent) {
        intent.setData(Uri.fromParts(NativeProtocol.PLATFORM_PROVIDER_VERSION_COLUMN, Integer.toString(GooglePlayServicesUtil.GOOGLE_PLAY_SERVICES_VERSION_CODE), null));
        return intent;
    }
}
