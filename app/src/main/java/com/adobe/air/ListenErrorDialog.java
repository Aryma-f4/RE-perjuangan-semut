package com.adobe.air;

import air.com.boyaa.WARSFACEBOOKID.R;
import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.TextView;
import com.adobe.air.AndroidLocale;

/* loaded from: classes.dex */
public final class ListenErrorDialog {
    private final Activity mActivity;
    private final String mDebuggerPort;
    private final int PADDING_LENGTH = 20;
    private final int ICON_ERROR = R.drawable.com_facebook_button_blue;

    ListenErrorDialog(Activity activity, int i) {
        this.mActivity = activity;
        this.mDebuggerPort = Integer.toString(i);
    }

    public void createAndShowDialog() {
        LinearLayout linearLayout = new LinearLayout(this.mActivity);
        linearLayout.setLayoutParams(new ViewGroup.LayoutParams(-1, -1));
        TextView textView = new TextView(this.mActivity);
        textView.setText(AndroidLocale.GetLocalizedString(AndroidLocale.STRING_ID.IDA_DEBUGGER_LISTEN_ERROR_MESSAGE).replaceFirst("%1", this.mDebuggerPort));
        textView.setLayoutParams(new ViewGroup.LayoutParams(-2, -1));
        textView.setPadding(20, 20, 20, 20);
        linearLayout.addView(textView);
        AlertDialog.Builder builder = new AlertDialog.Builder(this.mActivity);
        builder.setIcon(R.drawable.com_facebook_button_blue);
        builder.setView(linearLayout);
        builder.setTitle(AndroidLocale.GetLocalizedString(AndroidLocale.STRING_ID.IDA_DEBUGGER_LISTEN_ERROR_TITLE));
        builder.setPositiveButton(AndroidLocale.GetLocalizedString(AndroidLocale.STRING_ID.IDA_CANCEL), new DialogInterface.OnClickListener() { // from class: com.adobe.air.ListenErrorDialog.1
            @Override // android.content.DialogInterface.OnClickListener
            public void onClick(DialogInterface dialogInterface, int i) {
                ListenErrorDialog.this.gotResultFromDialog(false);
            }
        });
        builder.setNegativeButton(AndroidLocale.GetLocalizedString(AndroidLocale.STRING_ID.IDA_CONTINUE), new DialogInterface.OnClickListener() { // from class: com.adobe.air.ListenErrorDialog.2
            @Override // android.content.DialogInterface.OnClickListener
            public void onClick(DialogInterface dialogInterface, int i) {
                ListenErrorDialog.this.gotResultFromDialog(true);
            }
        });
        builder.setOnCancelListener(new DialogInterface.OnCancelListener() { // from class: com.adobe.air.ListenErrorDialog.3
            @Override // android.content.DialogInterface.OnCancelListener
            public void onCancel(DialogInterface dialogInterface) {
                ListenErrorDialog.this.gotResultFromDialog(false);
            }
        });
        builder.show();
    }

    public void gotResultFromDialog(boolean z) {
        AndroidActivityWrapper androidActivityWrapperGetAndroidActivityWrapper = AndroidActivityWrapper.GetAndroidActivityWrapper();
        if (z) {
            androidActivityWrapperGetAndroidActivityWrapper.gotResultFromDialog(false, "");
        } else {
            exitGracefully();
        }
    }

    private void exitGracefully() {
        System.exit(0);
    }
}
