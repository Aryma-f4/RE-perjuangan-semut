package com.codapayments.sdk.pay;

import android.content.DialogInterface;

/* loaded from: classes.dex */
final class b implements DialogInterface.OnClickListener {
    private /* synthetic */ CodaWeb a;

    b(CodaWeb codaWeb) {
        this.a = codaWeb;
    }

    @Override // android.content.DialogInterface.OnClickListener
    public final void onClick(DialogInterface dialogInterface, int i) {
        new com.codapayments.sdk.b.b(this.a.f).execute(new String[0]);
    }
}
