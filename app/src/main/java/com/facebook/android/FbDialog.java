package com.facebook.android;

import android.content.Context;
import android.os.Bundle;
import com.facebook.FacebookDialogException;
import com.facebook.FacebookException;
import com.facebook.FacebookOperationCanceledException;
import com.facebook.android.Facebook;
import com.facebook.widget.WebDialog;

@Deprecated
/* loaded from: classes.dex */
public class FbDialog extends WebDialog {
    private Facebook.DialogListener mListener;

    public FbDialog(Context context, String str, Bundle bundle, Facebook.DialogListener dialogListener) {
        super(context, str, bundle, 16973840, null);
        setDialogListener(dialogListener);
    }

    public FbDialog(Context context, String str, Bundle bundle, Facebook.DialogListener dialogListener, int i) {
        super(context, str, bundle, i, null);
        setDialogListener(dialogListener);
    }

    public FbDialog(Context context, String str, Facebook.DialogListener dialogListener) {
        this(context, str, dialogListener, 16973840);
    }

    public FbDialog(Context context, String str, Facebook.DialogListener dialogListener, int i) {
        super(context, str, i);
        setDialogListener(dialogListener);
    }

    /* JADX INFO: Access modifiers changed from: private */
    public void callDialogListener(Bundle bundle, FacebookException facebookException) {
        if (this.mListener == null) {
            return;
        }
        if (bundle != null) {
            this.mListener.onComplete(bundle);
            return;
        }
        if (facebookException instanceof FacebookDialogException) {
            FacebookDialogException facebookDialogException = (FacebookDialogException) facebookException;
            this.mListener.onError(new DialogError(facebookDialogException.getMessage(), facebookDialogException.getErrorCode(), facebookDialogException.getFailingUrl()));
        } else if (facebookException instanceof FacebookOperationCanceledException) {
            this.mListener.onCancel();
        } else {
            this.mListener.onFacebookError(new FacebookError(facebookException.getMessage()));
        }
    }

    private void setDialogListener(Facebook.DialogListener dialogListener) {
        this.mListener = dialogListener;
        setOnCompleteListener(new WebDialog.OnCompleteListener() { // from class: com.facebook.android.FbDialog.1
            @Override // com.facebook.widget.WebDialog.OnCompleteListener
            public void onComplete(Bundle bundle, FacebookException facebookException) {
                FbDialog.this.callDialogListener(bundle, facebookException);
            }
        });
    }
}
