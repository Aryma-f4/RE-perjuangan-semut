package com.google.android.gms.plus;

import android.content.Context;
import android.net.Uri;
import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.GooglePlayServicesClient;
import com.google.android.gms.common.Scopes;
import com.google.android.gms.internal.bt;
import com.google.android.gms.plus.model.moments.Moment;
import com.google.android.gms.plus.model.moments.MomentBuffer;
import com.google.android.gms.plus.model.people.Person;
import com.google.android.gms.plus.model.people.PersonBuffer;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;

/* loaded from: classes.dex */
public class PlusClient implements GooglePlayServicesClient {

    @Deprecated
    public static final String KEY_REQUEST_VISIBLE_ACTIVITIES = "request_visible_actions";
    final bt hU;

    public static class Builder {
        private GooglePlayServicesClient.OnConnectionFailedListener e;
        private String g;
        private GooglePlayServicesClient.ConnectionCallbacks hV;
        private ArrayList<String> hW = new ArrayList<>();
        private String[] hX;
        private String[] hY;
        private String hZ;
        private String ia;
        private String ib;
        private Context mContext;

        public Builder(Context context, GooglePlayServicesClient.ConnectionCallbacks connectionCallbacks, GooglePlayServicesClient.OnConnectionFailedListener connectionFailedListener) {
            this.mContext = context;
            this.hV = connectionCallbacks;
            this.e = connectionFailedListener;
            this.ia = this.mContext.getPackageName();
            this.hZ = this.mContext.getPackageName();
            this.hW.add(Scopes.PLUS_LOGIN);
        }

        public PlusClient build() {
            if (this.g == null) {
                this.g = "<<default account>>";
            }
            return new PlusClient(new bt(this.mContext, new a(this.g, (String[]) this.hW.toArray(new String[this.hW.size()]), this.hX, this.hY, this.hZ, this.ia, this.ib), this.hV, this.e));
        }

        public Builder clearScopes() {
            this.hW.clear();
            return this;
        }

        public Builder setAccountName(String accountName) {
            this.g = accountName;
            return this;
        }

        public Builder setActions(String... actions) {
            this.hX = actions;
            return this;
        }

        public Builder setScopes(String... scopes) {
            this.hW.clear();
            this.hW.addAll(Arrays.asList(scopes));
            return this;
        }

        @Deprecated
        public Builder setVisibleActivities(String... actions) {
            setActions(actions);
            return this;
        }
    }

    public interface OnAccessRevokedListener {
        void onAccessRevoked(ConnectionResult connectionResult);
    }

    public interface OnMomentsLoadedListener {
        void onMomentsLoaded(ConnectionResult connectionResult, MomentBuffer momentBuffer, String str, String str2);
    }

    public interface OnPeopleLoadedListener {
        void onPeopleLoaded(ConnectionResult connectionResult, PersonBuffer personBuffer, String str);
    }

    public interface OrderBy {
        public static final int ALPHABETICAL = 0;
        public static final int BEST = 1;
    }

    PlusClient(bt plusClientImpl) {
        this.hU = plusClientImpl;
    }

    bt bu() {
        return this.hU;
    }

    public void clearDefaultAccount() {
        this.hU.clearDefaultAccount();
    }

    @Override // com.google.android.gms.common.GooglePlayServicesClient
    public void connect() {
        this.hU.connect();
    }

    @Override // com.google.android.gms.common.GooglePlayServicesClient
    public void disconnect() {
        this.hU.disconnect();
    }

    public String getAccountName() {
        return this.hU.getAccountName();
    }

    public Person getCurrentPerson() {
        return this.hU.getCurrentPerson();
    }

    @Override // com.google.android.gms.common.GooglePlayServicesClient
    public boolean isConnected() {
        return this.hU.isConnected();
    }

    @Override // com.google.android.gms.common.GooglePlayServicesClient
    public boolean isConnecting() {
        return this.hU.isConnecting();
    }

    @Override // com.google.android.gms.common.GooglePlayServicesClient
    public boolean isConnectionCallbacksRegistered(GooglePlayServicesClient.ConnectionCallbacks listener) {
        return this.hU.isConnectionCallbacksRegistered(listener);
    }

    @Override // com.google.android.gms.common.GooglePlayServicesClient
    public boolean isConnectionFailedListenerRegistered(GooglePlayServicesClient.OnConnectionFailedListener listener) {
        return this.hU.isConnectionFailedListenerRegistered(listener);
    }

    public void loadMoments(OnMomentsLoadedListener listener) {
        this.hU.loadMoments(listener);
    }

    public void loadMoments(OnMomentsLoadedListener listener, int maxResults, String pageToken, Uri targetUrl, String type, String userId) {
        this.hU.loadMoments(listener, maxResults, pageToken, targetUrl, type, userId);
    }

    public void loadPeople(OnPeopleLoadedListener listener, Collection<String> personIds) {
        this.hU.a(listener, personIds);
    }

    public void loadPeople(OnPeopleLoadedListener listener, String... personIds) {
        this.hU.a(listener, personIds);
    }

    public void loadVisiblePeople(OnPeopleLoadedListener listener, int orderBy, String pageToken) {
        this.hU.loadVisiblePeople(listener, orderBy, pageToken);
    }

    public void loadVisiblePeople(OnPeopleLoadedListener listener, String pageToken) {
        this.hU.loadVisiblePeople(listener, pageToken);
    }

    @Override // com.google.android.gms.common.GooglePlayServicesClient
    public void registerConnectionCallbacks(GooglePlayServicesClient.ConnectionCallbacks listener) {
        this.hU.registerConnectionCallbacks(listener);
    }

    @Override // com.google.android.gms.common.GooglePlayServicesClient
    public void registerConnectionFailedListener(GooglePlayServicesClient.OnConnectionFailedListener listener) {
        this.hU.registerConnectionFailedListener(listener);
    }

    public void removeMoment(String momentId) {
        this.hU.removeMoment(momentId);
    }

    public void revokeAccessAndDisconnect(OnAccessRevokedListener listener) {
        this.hU.revokeAccessAndDisconnect(listener);
    }

    @Override // com.google.android.gms.common.GooglePlayServicesClient
    public void unregisterConnectionCallbacks(GooglePlayServicesClient.ConnectionCallbacks listener) {
        this.hU.unregisterConnectionCallbacks(listener);
    }

    @Override // com.google.android.gms.common.GooglePlayServicesClient
    public void unregisterConnectionFailedListener(GooglePlayServicesClient.OnConnectionFailedListener listener) {
        this.hU.unregisterConnectionFailedListener(listener);
    }

    public void writeMoment(Moment moment) {
        this.hU.writeMoment(moment);
    }
}
