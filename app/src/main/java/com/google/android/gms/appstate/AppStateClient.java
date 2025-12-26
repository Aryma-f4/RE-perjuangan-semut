package com.google.android.gms.appstate;

import android.content.Context;
import com.google.android.gms.common.GooglePlayServicesClient;
import com.google.android.gms.common.Scopes;
import com.google.android.gms.internal.c;
import com.google.android.gms.internal.s;

/* loaded from: classes.dex */
public final class AppStateClient implements GooglePlayServicesClient {
    public static final int STATUS_CLIENT_RECONNECT_REQUIRED = 2;
    public static final int STATUS_DEVELOPER_ERROR = 7;
    public static final int STATUS_INTERNAL_ERROR = 1;
    public static final int STATUS_NETWORK_ERROR_NO_DATA = 4;
    public static final int STATUS_NETWORK_ERROR_OPERATION_DEFERRED = 5;
    public static final int STATUS_NETWORK_ERROR_OPERATION_FAILED = 6;
    public static final int STATUS_NETWORK_ERROR_STALE_DATA = 3;
    public static final int STATUS_OK = 0;
    public static final int STATUS_STATE_KEY_LIMIT_EXCEEDED = 2003;
    public static final int STATUS_STATE_KEY_NOT_FOUND = 2002;
    public static final int STATUS_WRITE_OUT_OF_DATE_VERSION = 2000;
    public static final int STATUS_WRITE_SIZE_EXCEEDED = 2001;
    private final c b;

    public static final class Builder {
        private static final String[] c = {Scopes.APP_STATE};
        private GooglePlayServicesClient.ConnectionCallbacks d;
        private GooglePlayServicesClient.OnConnectionFailedListener e;
        private String[] f = c;
        private String g = "<<default account>>";
        private Context mContext;

        public Builder(Context context, GooglePlayServicesClient.ConnectionCallbacks connectedListener, GooglePlayServicesClient.OnConnectionFailedListener connectionFailedListener) {
            this.mContext = context;
            this.d = connectedListener;
            this.e = connectionFailedListener;
        }

        public AppStateClient create() {
            return new AppStateClient(this.mContext, this.d, this.e, this.g, this.f);
        }

        public Builder setAccountName(String accountName) {
            this.g = (String) s.d(accountName);
            return this;
        }

        public Builder setScopes(String... scopes) {
            this.f = scopes;
            return this;
        }
    }

    private AppStateClient(Context context, GooglePlayServicesClient.ConnectionCallbacks connectedListener, GooglePlayServicesClient.OnConnectionFailedListener connectionFailedListener, String accountName, String[] scopes) {
        this.b = new c(context, connectedListener, connectionFailedListener, accountName, scopes);
    }

    @Override // com.google.android.gms.common.GooglePlayServicesClient
    public void connect() {
        this.b.connect();
    }

    public void deleteState(OnStateDeletedListener listener, int stateKey) {
        this.b.deleteState(listener, stateKey);
    }

    @Override // com.google.android.gms.common.GooglePlayServicesClient
    public void disconnect() {
        this.b.disconnect();
    }

    public int getMaxNumKeys() {
        return this.b.getMaxNumKeys();
    }

    public int getMaxStateSize() {
        return this.b.getMaxStateSize();
    }

    @Override // com.google.android.gms.common.GooglePlayServicesClient
    public boolean isConnected() {
        return this.b.isConnected();
    }

    @Override // com.google.android.gms.common.GooglePlayServicesClient
    public boolean isConnecting() {
        return this.b.isConnecting();
    }

    @Override // com.google.android.gms.common.GooglePlayServicesClient
    public boolean isConnectionCallbacksRegistered(GooglePlayServicesClient.ConnectionCallbacks listener) {
        return this.b.isConnectionCallbacksRegistered(listener);
    }

    @Override // com.google.android.gms.common.GooglePlayServicesClient
    public boolean isConnectionFailedListenerRegistered(GooglePlayServicesClient.OnConnectionFailedListener listener) {
        return this.b.isConnectionFailedListenerRegistered(listener);
    }

    public void listStates(OnStateListLoadedListener listener) {
        this.b.listStates(listener);
    }

    public void loadState(OnStateLoadedListener listener, int stateKey) {
        this.b.loadState(listener, stateKey);
    }

    public void reconnect() {
        this.b.disconnect();
        this.b.connect();
    }

    @Override // com.google.android.gms.common.GooglePlayServicesClient
    public void registerConnectionCallbacks(GooglePlayServicesClient.ConnectionCallbacks listener) {
        this.b.registerConnectionCallbacks(listener);
    }

    @Override // com.google.android.gms.common.GooglePlayServicesClient
    public void registerConnectionFailedListener(GooglePlayServicesClient.OnConnectionFailedListener listener) {
        this.b.registerConnectionFailedListener(listener);
    }

    public void resolveState(OnStateLoadedListener listener, int stateKey, String resolvedVersion, byte[] resolvedData) {
        this.b.resolveState(listener, stateKey, resolvedVersion, resolvedData);
    }

    public void signOut() {
        this.b.signOut(null);
    }

    public void signOut(OnSignOutCompleteListener listener) {
        s.b(listener, "Must provide a valid listener");
        this.b.signOut(listener);
    }

    @Override // com.google.android.gms.common.GooglePlayServicesClient
    public void unregisterConnectionCallbacks(GooglePlayServicesClient.ConnectionCallbacks listener) {
        this.b.unregisterConnectionCallbacks(listener);
    }

    @Override // com.google.android.gms.common.GooglePlayServicesClient
    public void unregisterConnectionFailedListener(GooglePlayServicesClient.OnConnectionFailedListener listener) {
        this.b.unregisterConnectionFailedListener(listener);
    }

    public void updateState(int stateKey, byte[] data) {
        this.b.a((OnStateLoadedListener) null, stateKey, data);
    }

    public void updateStateImmediate(OnStateLoadedListener listener, int stateKey, byte[] data) {
        s.b(listener, "Must provide a valid listener");
        this.b.a(listener, stateKey, data);
    }
}
