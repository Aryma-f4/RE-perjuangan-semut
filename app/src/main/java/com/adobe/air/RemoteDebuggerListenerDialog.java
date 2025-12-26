package com.adobe.air;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Handler;
import android.support.v7.appcompat.R;
import android.view.KeyEvent;
import java.io.IOException;
import java.net.InetAddress;
import java.net.Socket;

/* loaded from: classes.dex */
public class RemoteDebuggerListenerDialog extends Activity {
    private BroadcastReceiver mReceiver;
    private int debuggerPort = -1;
    private int count = 0;
    private Handler mHandler = new Handler();
    private AlertDialog mWaitDialog = null;
    private Runnable mCheckAgain = null;
    private Activity mActivity = null;
    private final String LOG_TAG = getClass().getName();

    private enum DialogState {
        StateRuntimeNotReady,
        StateRuntimeWaitingForDebugger,
        StateRuntimeTimedOut
    }

    static /* synthetic */ int access$608(RemoteDebuggerListenerDialog remoteDebuggerListenerDialog) {
        int i = remoteDebuggerListenerDialog.count;
        remoteDebuggerListenerDialog.count = i + 1;
        return i;
    }

    @Override // android.app.Activity
    public void onCreate(Bundle bundle) {
        final String string = getString(R.string.IDA_APP_WAITING_DEBUGGER_WARNING);
        final String string2 = getString(R.string.IDA_APP_DEBUGGER_TIMEOUT_INFO);
        this.mActivity = this;
        super.onCreate(bundle);
        Bundle extras = getIntent().getExtras();
        this.debuggerPort = extras != null ? extras.getInt("debuggerPort") : 7936;
        this.mWaitDialog = new AlertDialog.Builder(this).create();
        String str = String.format(string, 60);
        this.mReceiver = new BroadcastReceiver() { // from class: com.adobe.air.RemoteDebuggerListenerDialog.1
            @Override // android.content.BroadcastReceiver
            public void onReceive(Context context, Intent intent) {
                if (!isInitialStickyBroadcast()) {
                    Bundle extras2 = RemoteDebuggerListenerDialog.this.getIntent().getExtras();
                    if ((extras2 != null ? extras2.getInt("debuggerPort") : 7936) == RemoteDebuggerListenerDialog.this.debuggerPort) {
                        RemoteDebuggerListenerDialog.this.dismissDialog();
                    }
                }
            }
        };
        IntentFilter intentFilter = new IntentFilter("android.intent.action.MAIN");
        intentFilter.addCategory("RemoteDebuggerListenerDialogClose");
        registerReceiver(this.mReceiver, intentFilter);
        this.mWaitDialog = createDialog(getString(R.string.IDA_APP_WAITING_DEBUGGER_TITLE), str, getString(R.string.button_cancel), new DialogInterface.OnClickListener() { // from class: com.adobe.air.RemoteDebuggerListenerDialog.2
            @Override // android.content.DialogInterface.OnClickListener
            public void onClick(DialogInterface dialogInterface, int i) {
                RemoteDebuggerListenerDialog.this.mHandler.removeCallbacks(RemoteDebuggerListenerDialog.this.mCheckAgain);
                RemoteDebuggerListenerDialog.this.closeListeningDebuggerSocket();
                RemoteDebuggerListenerDialog.this.unregisterReceiver(RemoteDebuggerListenerDialog.this.mReceiver);
                RemoteDebuggerListenerDialog.this.mReceiver = null;
                dialogInterface.cancel();
                RemoteDebuggerListenerDialog.this.finish();
            }
        }, new DialogInterface.OnKeyListener() { // from class: com.adobe.air.RemoteDebuggerListenerDialog.3
            @Override // android.content.DialogInterface.OnKeyListener
            public boolean onKey(DialogInterface dialogInterface, int i, KeyEvent keyEvent) {
                if (i == 4) {
                    RemoteDebuggerListenerDialog.this.mHandler.removeCallbacks(RemoteDebuggerListenerDialog.this.mCheckAgain);
                    RemoteDebuggerListenerDialog.this.closeListeningDebuggerSocket();
                    RemoteDebuggerListenerDialog.this.unregisterReceiver(RemoteDebuggerListenerDialog.this.mReceiver);
                    RemoteDebuggerListenerDialog.this.mReceiver = null;
                    dialogInterface.cancel();
                    RemoteDebuggerListenerDialog.this.finish();
                    return false;
                }
                return false;
            }
        });
        this.count = 0;
        this.mCheckAgain = new Runnable() { // from class: com.adobe.air.RemoteDebuggerListenerDialog.4
            @Override // java.lang.Runnable
            public void run() {
                if (RemoteDebuggerListenerDialog.this.count >= 60) {
                    RemoteDebuggerListenerDialog.this.mHandler.removeCallbacks(this);
                    RemoteDebuggerListenerDialog.this.mWaitDialog.cancel();
                    if (RemoteDebuggerListenerDialog.this.mReceiver != null) {
                        RemoteDebuggerListenerDialog.this.unregisterReceiver(RemoteDebuggerListenerDialog.this.mReceiver);
                        RemoteDebuggerListenerDialog.this.mReceiver = null;
                    }
                    final DialogInterface.OnClickListener onClickListener = new DialogInterface.OnClickListener() { // from class: com.adobe.air.RemoteDebuggerListenerDialog.4.1
                        @Override // android.content.DialogInterface.OnClickListener
                        public void onClick(DialogInterface dialogInterface, int i) {
                            RemoteDebuggerListenerDialog.this.closeListeningDebuggerSocket();
                            dialogInterface.cancel();
                            RemoteDebuggerListenerDialog.this.finish();
                        }
                    };
                    RemoteDebuggerListenerDialog.this.mWaitDialog = RemoteDebuggerListenerDialog.this.createDialog(AndroidConstants.ADOBE_AIR, string2, RemoteDebuggerListenerDialog.this.getString(R.string.button_continue), onClickListener, new DialogInterface.OnKeyListener() { // from class: com.adobe.air.RemoteDebuggerListenerDialog.4.2
                        @Override // android.content.DialogInterface.OnKeyListener
                        public boolean onKey(DialogInterface dialogInterface, int i, KeyEvent keyEvent) {
                            if (i == 4) {
                                onClickListener.onClick(dialogInterface, -1);
                                return false;
                            }
                            return false;
                        }
                    });
                    RemoteDebuggerListenerDialog.this.mWaitDialog.show();
                    return;
                }
                String str2 = String.format(string, Integer.valueOf(60 - RemoteDebuggerListenerDialog.this.count));
                RemoteDebuggerListenerDialog.access$608(RemoteDebuggerListenerDialog.this);
                RemoteDebuggerListenerDialog.this.mWaitDialog.setMessage(str2);
                RemoteDebuggerListenerDialog.this.mHandler.postDelayed(this, 1000L);
            }
        };
        this.mHandler.postDelayed(this.mCheckAgain, 1000L);
        this.mWaitDialog.show();
    }

    /* JADX INFO: Access modifiers changed from: private */
    public AlertDialog createDialog(CharSequence charSequence, CharSequence charSequence2, CharSequence charSequence3, DialogInterface.OnClickListener onClickListener, DialogInterface.OnKeyListener onKeyListener) {
        AlertDialog alertDialogCreate = new AlertDialog.Builder(this.mActivity).create();
        alertDialogCreate.setTitle(charSequence);
        alertDialogCreate.setMessage(charSequence2);
        alertDialogCreate.setButton(-1, charSequence3, onClickListener);
        alertDialogCreate.setOnKeyListener(onKeyListener);
        alertDialogCreate.setCancelable(true);
        return alertDialogCreate;
    }

    /* JADX INFO: Access modifiers changed from: private */
    public void closeListeningDebuggerSocket() {
        new AsyncTask<Integer, Integer, Integer>() { // from class: com.adobe.air.RemoteDebuggerListenerDialog.5
            /* JADX INFO: Access modifiers changed from: protected */
            @Override // android.os.AsyncTask
            public Integer doInBackground(Integer... numArr) throws IOException {
                try {
                    new Socket(InetAddress.getLocalHost(), numArr[0].intValue()).close();
                } catch (Exception e) {
                }
                return 0;
            }
        }.execute(Integer.valueOf(this.debuggerPort));
    }

    /* JADX INFO: Access modifiers changed from: private */
    public void dismissDialog() {
        if (this.mWaitDialog != null) {
            this.mWaitDialog.cancel();
        }
        if (this.mReceiver != null) {
            unregisterReceiver(this.mReceiver);
        }
        this.mReceiver = null;
        this.mHandler.removeCallbacks(this.mCheckAgain);
        this.mActivity.finish();
    }

    @Override // android.app.Activity, android.view.KeyEvent.Callback
    public boolean onKeyDown(int i, KeyEvent keyEvent) {
        if (i == 4) {
            closeListeningDebuggerSocket();
            dismissDialog();
        }
        return super.onKeyDown(i, keyEvent);
    }

    @Override // android.app.Activity
    public void onStop() {
        closeListeningDebuggerSocket();
        dismissDialog();
        super.onStop();
    }
}
