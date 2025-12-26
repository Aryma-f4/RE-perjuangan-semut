package com.freshplanet.ane.AirFacebook;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import com.facebook.internal.NativeProtocol;
import com.facebook.widget.FacebookDialog;
import java.util.UUID;

/* loaded from: classes.dex */
public class DialogLifecycleHelper {
    private static final String DIALOG_CALL_ID_PROPERTY = "com.freshplanet.ane.AirFacebook.DialogLifecycleHelper.DIALOG_CALL_ID";
    Activity activity;
    FacebookDialog.PendingCall dialogCall;
    DialogFactory dialogFactory;
    FacebookDialog.Callback onDialogReturn;

    public DialogLifecycleHelper(Activity activity, DialogFactory dialogFactory, FacebookDialog.Callback callback) {
        this.activity = activity;
        this.dialogFactory = dialogFactory;
        this.onDialogReturn = callback;
    }

    private void cancelDialogCall() {
        Intent requestIntent = this.dialogCall.getRequestIntent();
        Intent intent = new Intent();
        intent.putExtra(NativeProtocol.EXTRA_PROTOCOL_CALL_ID, requestIntent.getStringExtra(NativeProtocol.EXTRA_PROTOCOL_CALL_ID));
        intent.putExtra(NativeProtocol.EXTRA_PROTOCOL_ACTION, requestIntent.getStringExtra(NativeProtocol.EXTRA_PROTOCOL_ACTION));
        intent.putExtra(NativeProtocol.EXTRA_PROTOCOL_VERSION, requestIntent.getIntExtra(NativeProtocol.EXTRA_PROTOCOL_VERSION, 0));
        intent.putExtra(NativeProtocol.STATUS_ERROR_TYPE, NativeProtocol.ERROR_UNKNOWN_ERROR);
        FacebookDialog.handleActivityResult(this.activity, this.dialogCall, this.dialogCall.getRequestCode(), intent, this.onDialogReturn);
        this.dialogCall = null;
    }

    private void retreivePendingCall(Bundle bundle) {
        if (bundle == null) {
            return;
        }
        this.dialogCall = (FacebookDialog.PendingCall) bundle.getParcelable(DIALOG_CALL_ID_PROPERTY);
    }

    public void onActivityResult(int i, int i2, Intent intent) {
        UUID uuidFromString;
        if (this.dialogCall == null || this.dialogCall.getRequestCode() != i) {
            return;
        }
        if (intent == null) {
            cancelDialogCall();
        }
        String stringExtra = intent.getStringExtra(NativeProtocol.EXTRA_PROTOCOL_CALL_ID);
        if (stringExtra != null) {
            try {
                uuidFromString = UUID.fromString(stringExtra);
            } catch (IllegalArgumentException e) {
                uuidFromString = null;
            }
        } else {
            uuidFromString = null;
        }
        if (uuidFromString == null || !this.dialogCall.getCallId().equals(uuidFromString)) {
            cancelDialogCall();
        } else {
            FacebookDialog.handleActivityResult(this.activity, this.dialogCall, i, intent, this.onDialogReturn);
        }
        this.dialogCall = null;
    }

    public void onCreate(Bundle bundle) {
        retreivePendingCall(bundle);
        if (this.dialogCall == null) {
            this.dialogCall = this.dialogFactory.createDialog();
        }
    }

    public void onSaveInstanceState(Bundle bundle) {
        bundle.putParcelable(DIALOG_CALL_ID_PROPERTY, this.dialogCall);
    }
}
