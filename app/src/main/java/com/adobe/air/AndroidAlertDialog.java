package com.adobe.air;

import android.app.AlertDialog;
import android.content.Context;

/* loaded from: classes.dex */
public class AndroidAlertDialog {
    private AlertDialog mAlertDialog = null;
    private AlertDialog.Builder mDialogBuilder;

    public AndroidAlertDialog(Context context) {
        this.mDialogBuilder = null;
        this.mDialogBuilder = new AlertDialog.Builder(context);
    }

    public AlertDialog.Builder GetAlertDialogBuilder() {
        return this.mDialogBuilder;
    }

    public void show() {
        this.mAlertDialog = this.mDialogBuilder.create();
        this.mAlertDialog.setCanceledOnTouchOutside(false);
        this.mAlertDialog.show();
    }

    public void dismiss() {
        if (this.mAlertDialog != null) {
            this.mAlertDialog.dismiss();
        }
    }
}
