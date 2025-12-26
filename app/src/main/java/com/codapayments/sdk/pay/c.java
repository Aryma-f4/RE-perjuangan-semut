package com.codapayments.sdk.pay;

import android.content.DialogInterface;

/* loaded from: classes.dex */
final class c implements DialogInterface.OnClickListener {
    private /* synthetic */ CodaWeb a;

    c(CodaWeb codaWeb) {
    }

    @Override // android.content.DialogInterface.OnClickListener
    public final void onClick(DialogInterface dialogInterface, int i) {
        dialogInterface.cancel();
    }
}
