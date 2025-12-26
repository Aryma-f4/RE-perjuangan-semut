package com.facebook.internal;

import com.facebook.Settings;
import com.facebook.android.Facebook;
import java.util.Collection;

/* loaded from: classes.dex */
public final class ServerProtocol {
    public static final String BATCHED_REST_METHOD_URL_BASE = "method/";
    private static final String DIALOG_AUTHORITY_FORMAT = "m.%s";
    public static final String DIALOG_PARAM_ACCESS_TOKEN = "access_token";
    public static final String DIALOG_PARAM_APP_ID = "app_id";
    public static final String DIALOG_PARAM_CLIENT_ID = "client_id";
    public static final String DIALOG_PARAM_DISPLAY = "display";
    public static final String DIALOG_PARAM_E2E = "e2e";
    public static final String DIALOG_PARAM_REDIRECT_URI = "redirect_uri";
    public static final String DIALOG_PARAM_SCOPE = "scope";
    public static final String DIALOG_PARAM_TYPE = "type";
    public static final String DIALOG_PATH = "dialog/";
    private static final String GRAPH_URL_FORMAT = "https://graph.%s";
    private static final String REST_URL_FORMAT = "https://api.%s/method";
    public static final Collection<String> errorsProxyAuthDisabled = Utility.unmodifiableCollection(Facebook.SINGLE_SIGN_ON_DISABLED, "AndroidAuthKillSwitchException");
    public static final Collection<String> errorsUserCanceled = Utility.unmodifiableCollection("access_denied", "OAuthAccessDeniedException");

    public static final String getDialogAuthority() {
        return String.format(DIALOG_AUTHORITY_FORMAT, Settings.getFacebookDomain());
    }

    public static final String getGraphUrlBase() {
        return String.format(GRAPH_URL_FORMAT, Settings.getFacebookDomain());
    }

    public static final String getRestUrlBase() {
        return String.format(REST_URL_FORMAT, Settings.getFacebookDomain());
    }
}
