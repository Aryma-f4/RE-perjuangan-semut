package com.freshplanet.ane.AirFacebook;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.view.KeyEvent;
import com.facebook.FacebookOperationCanceledException;
import com.facebook.Session;
import com.facebook.SessionState;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import org.json.JSONException;

/* loaded from: classes.dex */
public class LoginActivity extends Activity {
    public static String extraPrefix = "com.freshplanet.ane.AirFacebook.LoginActivity";
    private Handler delayHandler;
    private Session.StatusCallback _statusCallback = new SessionStatusCallback();
    private AirFacebookExtensionContext _context = null;
    private List<String> _permissions = null;
    private boolean _reauthorize = false;

    private class SessionStatusCallback implements Session.StatusCallback {
        private SessionStatusCallback() {
        }

        @Override // com.facebook.Session.StatusCallback
        public void call(Session session, SessionState sessionState, Exception exc) {
            if (LoginActivity.this._reauthorize || session.isOpened() || exc != null) {
                LoginActivity.this.finishLogin(exc);
            }
        }
    }

    private void finishLogin() {
        finishLogin(null);
    }

    /* JADX INFO: Access modifiers changed from: private */
    public void finishLogin(Exception exc) {
        if (exc != null) {
            exc.printStackTrace();
        }
        if (this._context == null) {
            AirFacebookExtension.log("Extension context is null");
            finish();
            return;
        }
        Session session = this._context.getSession();
        Boolean boolValueOf = Boolean.valueOf(exc instanceof FacebookOperationCanceledException);
        String str = this._reauthorize ? session.getPermissions().containsAll(this._permissions) ? "REAUTHORIZE_SESSION_SUCCESS" : (exc == null || boolValueOf.booleanValue()) ? "REAUTHORIZE_SESSION_CANCEL" : "REAUTHORIZE_SESSION_ERROR" : session.isOpened() ? "OPEN_SESSION_SUCCESS" : boolValueOf.booleanValue() ? "OPEN_SESSION_CANCEL" : exc != null ? "OPEN_SESSION_ERROR" : null;
        String message = "OK";
        if (exc != null) {
            exc.printStackTrace();
            if (exc.getMessage() != null) {
                message = exc.getMessage();
            }
        }
        if (str != null && message != null) {
            this._context.dispatchStatusEventAsync(str, message);
        }
        finish();
    }

    @Override // android.app.Activity
    protected void onActivityResult(int i, int i2, Intent intent) throws JSONException {
        super.onActivityResult(i, i2, intent);
        if (this._context != null) {
            this._context.getSession().onActivityResult(this, i, i2, intent);
        }
    }

    @Override // android.app.Activity
    public void onBackPressed() {
        finishLogin(new FacebookOperationCanceledException());
    }

    @Override // android.app.Activity
    protected void onCreate(Bundle bundle) {
        super.onCreate(bundle);
        this._context = AirFacebookExtension.context;
        if (this._context == null) {
            AirFacebookExtension.log("Extension context is null");
            finish();
            return;
        }
        requestWindowFeature(3);
        setContentView(this._context.getResourceId("layout.com_facebook_login_activity_layout"));
        Bundle extras = getIntent().getExtras();
        this._permissions = new ArrayList(Arrays.asList(extras.getStringArray(extraPrefix + ".permissions")));
        String string = extras.getString(extraPrefix + ".type");
        this._reauthorize = extras.getBoolean(extraPrefix + ".reauthorize", false);
        final Session session = this._context.getSession();
        if (this._reauthorize && !session.getPermissions().containsAll(this._permissions)) {
            Session.NewPermissionsRequest callback = new Session.NewPermissionsRequest(this, this._permissions).setCallback(this._statusCallback);
            try {
                if ("read".equals(string)) {
                    session.requestNewReadPermissions(callback);
                } else {
                    session.requestNewPublishPermissions(callback);
                }
                return;
            } catch (Exception e) {
                finishLogin(e);
                return;
            }
        }
        if (session.isOpened()) {
            finishLogin();
            return;
        }
        final Session.OpenRequest callback2 = new Session.OpenRequest(this).setPermissions(this._permissions).setCallback(this._statusCallback);
        if (!session.getState().equals(SessionState.CREATED) && !session.getState().equals(SessionState.CREATED_TOKEN_LOADED)) {
            this._context.closeSessionAndClearTokenInformation();
            this._context.getSession();
        }
        if (!this._context.usingStage3D) {
            try {
                if ("read".equals(string)) {
                    session.openForRead(callback2);
                } else {
                    session.openForPublish(callback2);
                }
                return;
            } catch (Exception e2) {
                finishLogin(e2);
                return;
            }
        }
        try {
            this.delayHandler = new Handler();
            if ("read".equals(string)) {
                this.delayHandler.postDelayed(new Runnable() { // from class: com.freshplanet.ane.AirFacebook.LoginActivity.1
                    @Override // java.lang.Runnable
                    public void run() {
                        try {
                            session.openForRead(callback2);
                        } catch (Exception e3) {
                            LoginActivity.this.finishLogin(e3);
                        }
                    }
                }, 1L);
            } else {
                this.delayHandler.postDelayed(new Runnable() { // from class: com.freshplanet.ane.AirFacebook.LoginActivity.2
                    @Override // java.lang.Runnable
                    public void run() {
                        try {
                            session.openForPublish(callback2);
                        } catch (Exception e3) {
                            LoginActivity.this.finishLogin(e3);
                        }
                    }
                }, 1L);
            }
        } catch (Exception e3) {
            finishLogin(e3);
        }
    }

    @Override // android.app.Activity, android.view.KeyEvent.Callback
    public boolean onKeyUp(int i, KeyEvent keyEvent) {
        if (i != 4) {
            return super.onKeyUp(i, keyEvent);
        }
        onBackPressed();
        return true;
    }

    @Override // android.app.Activity
    public void onStart() {
        super.onStart();
        if (this._context != null) {
            this._context.getSession().addCallback(this._statusCallback);
        }
    }

    @Override // android.app.Activity
    public void onStop() {
        super.onStop();
        if (this._context != null) {
            this._context.getSession().removeCallback(this._statusCallback);
        }
    }
}
