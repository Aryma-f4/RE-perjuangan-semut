package com.codapayments.sdk.c;

import air.com.boyaa.WARSFACEBOOKID.R;
import android.content.Context;
import android.webkit.WebView;
import android.widget.RelativeLayout;

/* loaded from: classes.dex */
public final class a extends RelativeLayout {
    private WebView a;

    public a(Context context) {
        super(context);
        this.a = new WebView(context);
        this.a.setId(R.attr.login_text);
        this.a.setScrollContainer(false);
        RelativeLayout.LayoutParams layoutParams = new RelativeLayout.LayoutParams(-1, -1);
        layoutParams.addRule(12);
        this.a.setLayoutParams(layoutParams);
        addView(this.a);
    }

    public final WebView a() {
        return this.a;
    }
}
