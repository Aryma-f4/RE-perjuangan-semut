package com.google.android.gms.internal;

import android.net.Uri;
import android.widget.ImageView;

/* loaded from: classes.dex */
public final class g extends ImageView {
    private Uri bk;
    private int bl;

    public void a(Uri uri) {
        this.bk = uri;
    }

    public void k(int i) {
        this.bl = i;
    }

    public int t() {
        return this.bl;
    }
}
