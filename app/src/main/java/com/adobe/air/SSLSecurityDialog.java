package com.adobe.air;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.res.Resources;
import android.net.http.SslCertificate;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.TextView;
import com.adobe.air.utils.Utils;
import java.util.concurrent.locks.Condition;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

/* loaded from: classes.dex */
public class SSLSecurityDialog {
    public static final String TAG = SSLSecurityDialog.class.toString();
    private static final String USER_ACTION_TRUST_ALWAYS = "always";
    private static final String USER_ACTION_TRUST_NONE = "none";
    private static final String USER_ACTION_TRUST_SESSION = "session";
    private String m_useraction = null;
    private Lock m_lock = new ReentrantLock();
    private Condition m_condition = this.m_lock.newCondition();

    public String show(String str, byte[] bArr) {
        ShowSSLDialog(str, bArr, null, false);
        if (this.m_useraction != null) {
        }
        return this.m_useraction;
    }

    public void ShowSSLDialog(String str, byte[] bArr, SslCertificate sslCertificate, boolean z) {
        Certificate certificate;
        AndroidActivityWrapper androidActivityWrapperGetAndroidActivityWrapper = AndroidActivityWrapper.GetAndroidActivityWrapper();
        Activity activity = androidActivityWrapperGetAndroidActivityWrapper.getActivity();
        if (activity == null) {
            activity = androidActivityWrapperGetAndroidActivityWrapper.WaitForNewActivity();
        }
        final AndroidAlertDialog androidAlertDialog = new AndroidAlertDialog(activity);
        AlertDialog.Builder builderGetAlertDialogBuilder = androidAlertDialog.GetAlertDialogBuilder();
        Context runtimeContext = androidActivityWrapperGetAndroidActivityWrapper.getRuntimeContext();
        LayoutInflater layoutInflaterFrom = LayoutInflater.from(runtimeContext);
        Resources resources = runtimeContext.getResources();
        View viewGetLayoutViewFromRuntime = Utils.GetLayoutViewFromRuntime("ssl_certificate_warning", resources, layoutInflaterFrom);
        if (viewGetLayoutViewFromRuntime != null) {
            Resources resources2 = viewGetLayoutViewFromRuntime.getResources();
            TextView textView = (TextView) Utils.GetWidgetInViewByName("ServerName", resources2, viewGetLayoutViewFromRuntime);
            textView.setText(((Object) textView.getText()) + " " + str);
            if (bArr != null) {
                certificate = new Certificate();
                certificate.setCertificate(bArr);
            } else {
                certificate = new Certificate(sslCertificate);
            }
            ((TextView) Utils.GetWidgetInViewByName("CertificateDetails", resources2, viewGetLayoutViewFromRuntime)).setText(String.format(Utils.GetResourceStringFromRuntime("IDA_CERTIFICATE_DETAILS", resources), certificate.getIssuedToCommonName(), certificate.getIssuedToOrganization(), certificate.getIssuedToOrganizationalUnit(), certificate.getIssuedByCommonName(), certificate.getIssuedByOrganization(), certificate.getIssuedByOrganizationalUnit(), certificate.getIssuedOn(), certificate.getExpiresOn()), TextView.BufferType.SPANNABLE);
            builderGetAlertDialogBuilder.setView(viewGetLayoutViewFromRuntime);
            if (z) {
                builderGetAlertDialogBuilder.setPositiveButton(Utils.GetResourceStringFromRuntime("IDA_CURL_INTERFACE_ALLSESS", resources), new DialogInterface.OnClickListener() { // from class: com.adobe.air.SSLSecurityDialog.1
                    @Override // android.content.DialogInterface.OnClickListener
                    public void onClick(DialogInterface dialogInterface, int i) {
                        SSLSecurityDialog.this.SetUserAction(SSLSecurityDialog.USER_ACTION_TRUST_ALWAYS);
                    }
                });
            }
            builderGetAlertDialogBuilder.setNeutralButton(Utils.GetResourceStringFromRuntime("IDA_CURL_INTERFACE_THISSESS", resources), new DialogInterface.OnClickListener() { // from class: com.adobe.air.SSLSecurityDialog.2
                @Override // android.content.DialogInterface.OnClickListener
                public void onClick(DialogInterface dialogInterface, int i) {
                    SSLSecurityDialog.this.SetUserAction(SSLSecurityDialog.USER_ACTION_TRUST_SESSION);
                }
            });
            builderGetAlertDialogBuilder.setNegativeButton(Utils.GetResourceStringFromRuntime("IDA_CURL_INTERFACE_NOSESS", resources), new DialogInterface.OnClickListener() { // from class: com.adobe.air.SSLSecurityDialog.3
                @Override // android.content.DialogInterface.OnClickListener
                public void onClick(DialogInterface dialogInterface, int i) {
                    SSLSecurityDialog.this.SetUserAction(SSLSecurityDialog.USER_ACTION_TRUST_NONE);
                }
            });
            builderGetAlertDialogBuilder.setOnKeyListener(new DialogInterface.OnKeyListener() { // from class: com.adobe.air.SSLSecurityDialog.4
                @Override // android.content.DialogInterface.OnKeyListener
                public boolean onKey(DialogInterface dialogInterface, int i, KeyEvent keyEvent) {
                    if (keyEvent.getKeyCode() == 4) {
                        SSLSecurityDialog.this.SetUserAction(SSLSecurityDialog.USER_ACTION_TRUST_NONE);
                        return false;
                    }
                    return false;
                }
            });
            activity.runOnUiThread(new Runnable() { // from class: com.adobe.air.SSLSecurityDialog.5
                @Override // java.lang.Runnable
                public void run() {
                    androidAlertDialog.show();
                }
            });
            this.m_lock.lock();
            try {
                if (this.m_useraction == null) {
                    this.m_condition.await();
                }
            } catch (InterruptedException e) {
            } finally {
                this.m_lock.unlock();
            }
        }
    }

    /* JADX INFO: Access modifiers changed from: private */
    public void SetUserAction(String str) {
        this.m_lock.lock();
        this.m_useraction = str;
        this.m_condition.signal();
        this.m_lock.unlock();
    }

    public String show(String str, SslCertificate sslCertificate) {
        ShowSSLDialog(str, null, sslCertificate, false);
        if (this.m_useraction != null) {
        }
        return this.m_useraction;
    }

    public String getUserAction() {
        return this.m_useraction;
    }
}
