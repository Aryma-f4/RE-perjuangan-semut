package com.facebook;

import android.annotation.SuppressLint;
import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import com.facebook.internal.NativeProtocol;
import com.facebook.internal.Utility;
import com.facebook.internal.Validate;
import java.io.InvalidObjectException;
import java.io.ObjectInputStream;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.List;

/* loaded from: classes.dex */
public final class AccessToken implements Serializable {
    static final /* synthetic */ boolean $assertionsDisabled;
    static final String ACCESS_TOKEN_KEY = "access_token";
    private static final Date ALREADY_EXPIRED_EXPIRATION_TIME;
    private static final AccessTokenSource DEFAULT_ACCESS_TOKEN_SOURCE;
    private static final Date DEFAULT_EXPIRATION_TIME;
    private static final Date DEFAULT_LAST_REFRESH_TIME;
    static final String EXPIRES_IN_KEY = "expires_in";
    private static final Date MAX_DATE;
    private static final Date MIN_DATE;
    private static final long serialVersionUID = 1;
    private final Date expires;
    private final Date lastRefresh;
    private final List<String> permissions;
    private final AccessTokenSource source;
    private final String token;

    private static class SerializationProxyV1 implements Serializable {
        private static final long serialVersionUID = -2488473066578201069L;
        private final Date expires;
        private final Date lastRefresh;
        private final List<String> permissions;
        private final AccessTokenSource source;
        private final String token;

        private SerializationProxyV1(String str, Date date, List<String> list, AccessTokenSource accessTokenSource, Date date2) {
            this.expires = date;
            this.permissions = list;
            this.token = str;
            this.source = accessTokenSource;
            this.lastRefresh = date2;
        }

        private Object readResolve() {
            return new AccessToken(this.token, this.expires, this.permissions, this.source, this.lastRefresh);
        }
    }

    static {
        $assertionsDisabled = !AccessToken.class.desiredAssertionStatus();
        MIN_DATE = new Date(Long.MIN_VALUE);
        MAX_DATE = new Date(Long.MAX_VALUE);
        DEFAULT_EXPIRATION_TIME = MAX_DATE;
        DEFAULT_LAST_REFRESH_TIME = new Date();
        DEFAULT_ACCESS_TOKEN_SOURCE = AccessTokenSource.FACEBOOK_APPLICATION_WEB;
        ALREADY_EXPIRED_EXPIRATION_TIME = MIN_DATE;
    }

    AccessToken(String str, Date date, List<String> list, AccessTokenSource accessTokenSource, Date date2) {
        List<String> listEmptyList = list == null ? Collections.emptyList() : list;
        this.expires = date;
        this.permissions = Collections.unmodifiableList(listEmptyList);
        this.token = str;
        this.source = accessTokenSource;
        this.lastRefresh = date2;
    }

    private void appendPermissions(StringBuilder sb) {
        sb.append(" permissions:");
        if (this.permissions == null) {
            sb.append("null");
            return;
        }
        sb.append("[");
        sb.append(TextUtils.join(", ", this.permissions));
        sb.append("]");
    }

    static AccessToken createEmptyToken(List<String> list) {
        return new AccessToken("", ALREADY_EXPIRED_EXPIRATION_TIME, list, AccessTokenSource.NONE, DEFAULT_LAST_REFRESH_TIME);
    }

    private static AccessToken createFromBundle(List<String> list, Bundle bundle, AccessTokenSource accessTokenSource, Date date) throws NumberFormatException {
        String string = bundle.getString("access_token");
        Date bundleLongAsDate = getBundleLongAsDate(bundle, "expires_in", date);
        if (Utility.isNullOrEmpty(string) || bundleLongAsDate == null) {
            return null;
        }
        return new AccessToken(string, bundleLongAsDate, list, accessTokenSource, new Date());
    }

    static AccessToken createFromCache(Bundle bundle) {
        ArrayList<String> stringArrayList = bundle.getStringArrayList(TokenCachingStrategy.PERMISSIONS_KEY);
        return new AccessToken(bundle.getString(TokenCachingStrategy.TOKEN_KEY), TokenCachingStrategy.getDate(bundle, TokenCachingStrategy.EXPIRATION_DATE_KEY), stringArrayList == null ? Collections.emptyList() : Collections.unmodifiableList(new ArrayList(stringArrayList)), TokenCachingStrategy.getSource(bundle), TokenCachingStrategy.getDate(bundle, TokenCachingStrategy.LAST_REFRESH_DATE_KEY));
    }

    public static AccessToken createFromExistingAccessToken(String str, Date date, Date date2, AccessTokenSource accessTokenSource, List<String> list) {
        return new AccessToken(str, date == null ? DEFAULT_EXPIRATION_TIME : date, list, accessTokenSource == null ? DEFAULT_ACCESS_TOKEN_SOURCE : accessTokenSource, date2 == null ? DEFAULT_LAST_REFRESH_TIME : date2);
    }

    public static AccessToken createFromNativeLinkingIntent(Intent intent) {
        Validate.notNull(intent, "intent");
        if (intent.getExtras() == null) {
            return null;
        }
        return createFromBundle(null, intent.getExtras(), AccessTokenSource.FACEBOOK_APPLICATION_WEB, new Date());
    }

    static AccessToken createFromNativeLogin(Bundle bundle, AccessTokenSource accessTokenSource) throws NumberFormatException {
        return createNew(bundle.getStringArrayList(NativeProtocol.EXTRA_PERMISSIONS), bundle.getString(NativeProtocol.EXTRA_ACCESS_TOKEN), getBundleLongAsDate(bundle, NativeProtocol.EXTRA_EXPIRES_SECONDS_SINCE_EPOCH, new Date(0L)), accessTokenSource);
    }

    @SuppressLint({"FieldGetter"})
    static AccessToken createFromRefresh(AccessToken accessToken, Bundle bundle) throws NumberFormatException {
        if (!$assertionsDisabled && accessToken.source != AccessTokenSource.FACEBOOK_APPLICATION_WEB && accessToken.source != AccessTokenSource.FACEBOOK_APPLICATION_NATIVE && accessToken.source != AccessTokenSource.FACEBOOK_APPLICATION_SERVICE) {
            throw new AssertionError();
        }
        Date bundleLongAsDate = getBundleLongAsDate(bundle, "expires_in", new Date(0L));
        return createNew(accessToken.getPermissions(), bundle.getString("access_token"), bundleLongAsDate, accessToken.source);
    }

    static AccessToken createFromString(String str, List<String> list, AccessTokenSource accessTokenSource) {
        return new AccessToken(str, DEFAULT_EXPIRATION_TIME, list, accessTokenSource, DEFAULT_LAST_REFRESH_TIME);
    }

    static AccessToken createFromTokenWithRefreshedPermissions(AccessToken accessToken, List<String> list) {
        return new AccessToken(accessToken.token, accessToken.expires, list, accessToken.source, accessToken.lastRefresh);
    }

    static AccessToken createFromWebBundle(List<String> list, Bundle bundle, AccessTokenSource accessTokenSource) throws NumberFormatException {
        return createNew(list, bundle.getString("access_token"), getBundleLongAsDate(bundle, "expires_in", new Date()), accessTokenSource);
    }

    private static AccessToken createNew(List<String> list, String str, Date date, AccessTokenSource accessTokenSource) {
        return (Utility.isNullOrEmpty(str) || date == null) ? createEmptyToken(list) : new AccessToken(str, date, list, accessTokenSource, new Date());
    }

    private static Date getBundleLongAsDate(Bundle bundle, String str, Date date) throws NumberFormatException {
        long jLongValue;
        if (bundle == null) {
            return null;
        }
        Object obj = bundle.get(str);
        if (obj instanceof Long) {
            jLongValue = ((Long) obj).longValue();
        } else {
            if (!(obj instanceof String)) {
                return null;
            }
            try {
                jLongValue = Long.parseLong((String) obj);
            } catch (NumberFormatException e) {
                return null;
            }
        }
        if (jLongValue == 0) {
            return new Date(Long.MAX_VALUE);
        }
        return new Date((jLongValue * 1000) + date.getTime());
    }

    private void readObject(ObjectInputStream objectInputStream) throws InvalidObjectException {
        throw new InvalidObjectException("Cannot readObject, serialization proxy required");
    }

    private String tokenToString() {
        return this.token == null ? "null" : Settings.isLoggingBehaviorEnabled(LoggingBehavior.INCLUDE_ACCESS_TOKENS) ? this.token : "ACCESS_TOKEN_REMOVED";
    }

    private Object writeReplace() {
        return new SerializationProxyV1(this.token, this.expires, this.permissions, this.source, this.lastRefresh);
    }

    public Date getExpires() {
        return this.expires;
    }

    public Date getLastRefresh() {
        return this.lastRefresh;
    }

    public List<String> getPermissions() {
        return this.permissions;
    }

    public AccessTokenSource getSource() {
        return this.source;
    }

    public String getToken() {
        return this.token;
    }

    boolean isInvalid() {
        return Utility.isNullOrEmpty(this.token) || new Date().after(this.expires);
    }

    Bundle toCacheBundle() {
        Bundle bundle = new Bundle();
        bundle.putString(TokenCachingStrategy.TOKEN_KEY, this.token);
        TokenCachingStrategy.putDate(bundle, TokenCachingStrategy.EXPIRATION_DATE_KEY, this.expires);
        bundle.putStringArrayList(TokenCachingStrategy.PERMISSIONS_KEY, new ArrayList<>(this.permissions));
        bundle.putSerializable(TokenCachingStrategy.TOKEN_SOURCE_KEY, this.source);
        TokenCachingStrategy.putDate(bundle, TokenCachingStrategy.LAST_REFRESH_DATE_KEY, this.lastRefresh);
        return bundle;
    }

    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append("{AccessToken");
        sb.append(" token:").append(tokenToString());
        appendPermissions(sb);
        sb.append("}");
        return sb.toString();
    }
}
