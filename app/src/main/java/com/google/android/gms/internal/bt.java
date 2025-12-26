package com.google.android.gms.internal;

import android.app.PendingIntent;
import android.content.Context;
import android.net.Uri;
import android.os.Bundle;
import android.os.IBinder;
import android.os.RemoteException;
import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.GooglePlayServicesClient;
import com.google.android.gms.common.GooglePlayServicesUtil;
import com.google.android.gms.internal.bs;
import com.google.android.gms.internal.k;
import com.google.android.gms.plus.PlusClient;
import com.google.android.gms.plus.model.moments.Moment;
import com.google.android.gms.plus.model.moments.MomentBuffer;
import com.google.android.gms.plus.model.people.Person;
import com.google.android.gms.plus.model.people.PersonBuffer;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;

/* loaded from: classes.dex */
public class bt extends k<bs> {
    private Person ip;
    private com.google.android.gms.plus.a iq;

    final class a extends bo {
        private final PlusClient.OnMomentsLoadedListener ir;

        public a(PlusClient.OnMomentsLoadedListener onMomentsLoadedListener) {
            this.ir = onMomentsLoadedListener;
        }

        @Override // com.google.android.gms.internal.bo, com.google.android.gms.internal.bp
        public void a(com.google.android.gms.common.data.d dVar, String str, String str2) {
            com.google.android.gms.common.data.d dVar2;
            ConnectionResult connectionResult = new ConnectionResult(dVar.getStatusCode(), dVar.l() != null ? (PendingIntent) dVar.l().getParcelable("pendingIntent") : null);
            if (connectionResult.isSuccess() || dVar == null) {
                dVar2 = dVar;
            } else {
                if (!dVar.isClosed()) {
                    dVar.close();
                }
                dVar2 = null;
            }
            bt.this.a(bt.this.new b(this.ir, connectionResult, dVar2, str, str2));
        }
    }

    final class b extends k<bs>.c<PlusClient.OnMomentsLoadedListener> {
        private final ConnectionResult it;
        private final String iu;
        private final String iv;

        public b(PlusClient.OnMomentsLoadedListener onMomentsLoadedListener, ConnectionResult connectionResult, com.google.android.gms.common.data.d dVar, String str, String str2) {
            super(onMomentsLoadedListener, dVar);
            this.it = connectionResult;
            this.iu = str;
            this.iv = str2;
        }

        /* JADX INFO: Access modifiers changed from: protected */
        @Override // com.google.android.gms.internal.k.c
        public void a(PlusClient.OnMomentsLoadedListener onMomentsLoadedListener, com.google.android.gms.common.data.d dVar) {
            onMomentsLoadedListener.onMomentsLoaded(this.it, dVar != null ? new MomentBuffer(dVar) : null, this.iu, this.iv);
        }
    }

    final class c extends bo {
        private final PlusClient.OnPeopleLoadedListener iw;

        public c(PlusClient.OnPeopleLoadedListener onPeopleLoadedListener) {
            this.iw = onPeopleLoadedListener;
        }

        @Override // com.google.android.gms.internal.bo, com.google.android.gms.internal.bp
        public void a(com.google.android.gms.common.data.d dVar, String str) {
            com.google.android.gms.common.data.d dVar2;
            ConnectionResult connectionResult = new ConnectionResult(dVar.getStatusCode(), dVar.l() != null ? (PendingIntent) dVar.l().getParcelable("pendingIntent") : null);
            if (connectionResult.isSuccess() || dVar == null) {
                dVar2 = dVar;
            } else {
                if (!dVar.isClosed()) {
                    dVar.close();
                }
                dVar2 = null;
            }
            bt.this.a(bt.this.new d(this.iw, connectionResult, dVar2, str));
        }
    }

    final class d extends k<bs>.c<PlusClient.OnPeopleLoadedListener> {
        private final ConnectionResult it;
        private final String iu;

        public d(PlusClient.OnPeopleLoadedListener onPeopleLoadedListener, ConnectionResult connectionResult, com.google.android.gms.common.data.d dVar, String str) {
            super(onPeopleLoadedListener, dVar);
            this.it = connectionResult;
            this.iu = str;
        }

        /* JADX INFO: Access modifiers changed from: protected */
        @Override // com.google.android.gms.internal.k.c
        public void a(PlusClient.OnPeopleLoadedListener onPeopleLoadedListener, com.google.android.gms.common.data.d dVar) {
            onPeopleLoadedListener.onPeopleLoaded(this.it, dVar != null ? new PersonBuffer(dVar) : null, this.iu);
        }
    }

    final class e extends bo {
        private final PlusClient.OnAccessRevokedListener ix;

        public e(PlusClient.OnAccessRevokedListener onAccessRevokedListener) {
            this.ix = onAccessRevokedListener;
        }

        @Override // com.google.android.gms.internal.bo, com.google.android.gms.internal.bp
        public void b(int i, Bundle bundle) {
            bt.this.a(bt.this.new f(this.ix, new ConnectionResult(i, bundle != null ? (PendingIntent) bundle.getParcelable("pendingIntent") : null)));
        }
    }

    final class f extends k<bs>.b<PlusClient.OnAccessRevokedListener> {
        private final ConnectionResult it;

        public f(PlusClient.OnAccessRevokedListener onAccessRevokedListener, ConnectionResult connectionResult) {
            super(onAccessRevokedListener);
            this.it = connectionResult;
        }

        /* JADX INFO: Access modifiers changed from: protected */
        @Override // com.google.android.gms.internal.k.b
        public void a(PlusClient.OnAccessRevokedListener onAccessRevokedListener) {
            bt.this.disconnect();
            if (onAccessRevokedListener != null) {
                onAccessRevokedListener.onAccessRevoked(this.it);
            }
        }

        @Override // com.google.android.gms.internal.k.b
        protected void d() {
        }
    }

    public bt(Context context, com.google.android.gms.plus.a aVar, GooglePlayServicesClient.ConnectionCallbacks connectionCallbacks, GooglePlayServicesClient.OnConnectionFailedListener onConnectionFailedListener) {
        super(context, connectionCallbacks, onConnectionFailedListener, aVar.by());
        this.iq = aVar;
    }

    public boolean F(String str) {
        return Arrays.asList(x()).contains(str);
    }

    @Override // com.google.android.gms.internal.k
    protected void a(int i, IBinder iBinder, Bundle bundle) {
        if (i == 0 && bundle != null && bundle.containsKey("loaded_person")) {
            this.ip = cc.d(bundle.getByteArray("loaded_person"));
        }
        super.a(i, iBinder, bundle);
    }

    @Override // com.google.android.gms.internal.k
    protected void a(p pVar, k.d dVar) throws RemoteException {
        Bundle bundle = new Bundle();
        bundle.putBoolean("skip_oob", false);
        bundle.putStringArray("request_visible_actions", this.iq.bz());
        if (this.iq.bA() != null) {
            bundle.putStringArray("required_features", this.iq.bA());
        }
        if (this.iq.bD() != null) {
            bundle.putString("application_name", this.iq.bD());
        }
        pVar.a(dVar, GooglePlayServicesUtil.GOOGLE_PLAY_SERVICES_VERSION_CODE, this.iq.bC(), this.iq.bB(), x(), this.iq.getAccountName(), bundle);
    }

    public void a(PlusClient.OnPeopleLoadedListener onPeopleLoadedListener, Collection<String> collection) {
        B();
        c cVar = new c(onPeopleLoadedListener);
        try {
            C().a(cVar, new ArrayList(collection));
        } catch (RemoteException e2) {
            cVar.a(com.google.android.gms.common.data.d.f(8), null);
        }
    }

    public void a(PlusClient.OnPeopleLoadedListener onPeopleLoadedListener, String[] strArr) {
        a(onPeopleLoadedListener, Arrays.asList(strArr));
    }

    /* JADX INFO: Access modifiers changed from: protected */
    @Override // com.google.android.gms.internal.k
    /* renamed from: ac, reason: merged with bridge method [inline-methods] */
    public bs c(IBinder iBinder) {
        return bs.a.ab(iBinder);
    }

    @Override // com.google.android.gms.internal.k
    protected String b() {
        return "com.google.android.gms.plus.service.START";
    }

    @Override // com.google.android.gms.internal.k
    protected String c() {
        return "com.google.android.gms.plus.internal.IPlusService";
    }

    public void clearDefaultAccount() {
        B();
        try {
            this.ip = null;
            C().clearDefaultAccount();
        } catch (RemoteException e2) {
            throw new IllegalStateException(e2);
        }
    }

    public String getAccountName() {
        B();
        try {
            return C().getAccountName();
        } catch (RemoteException e2) {
            throw new IllegalStateException(e2);
        }
    }

    public Person getCurrentPerson() {
        B();
        return this.ip;
    }

    public void loadMoments(PlusClient.OnMomentsLoadedListener listener) {
        loadMoments(listener, 20, null, null, null, "me");
    }

    public void loadMoments(PlusClient.OnMomentsLoadedListener listener, int maxResults, String pageToken, Uri targetUrl, String type, String userId) {
        B();
        a aVar = listener != null ? new a(listener) : null;
        try {
            C().a(aVar, maxResults, pageToken, targetUrl, type, userId);
        } catch (RemoteException e2) {
            aVar.a(com.google.android.gms.common.data.d.f(8), (String) null, (String) null);
        }
    }

    public void loadVisiblePeople(PlusClient.OnPeopleLoadedListener listener, int orderBy, String pageToken) {
        B();
        c cVar = new c(listener);
        try {
            C().a(cVar, 1, orderBy, -1, pageToken);
        } catch (RemoteException e2) {
            cVar.a(com.google.android.gms.common.data.d.f(8), null);
        }
    }

    public void loadVisiblePeople(PlusClient.OnPeopleLoadedListener listener, String pageToken) {
        loadVisiblePeople(listener, 0, pageToken);
    }

    public void removeMoment(String momentId) {
        B();
        try {
            C().removeMoment(momentId);
        } catch (RemoteException e2) {
            throw new IllegalStateException(e2);
        }
    }

    public void revokeAccessAndDisconnect(PlusClient.OnAccessRevokedListener listener) {
        B();
        clearDefaultAccount();
        e eVar = new e(listener);
        try {
            C().c(eVar);
        } catch (RemoteException e2) {
            eVar.b(8, (Bundle) null);
        }
    }

    public void writeMoment(Moment moment) {
        B();
        try {
            C().a(ak.a((bz) moment));
        } catch (RemoteException e2) {
            throw new IllegalStateException(e2);
        }
    }
}
