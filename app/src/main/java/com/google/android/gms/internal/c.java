package com.google.android.gms.internal;

import android.content.Context;
import android.os.IBinder;
import android.os.RemoteException;
import android.util.Log;
import com.google.android.gms.appstate.AppState;
import com.google.android.gms.appstate.AppStateBuffer;
import com.google.android.gms.appstate.OnSignOutCompleteListener;
import com.google.android.gms.appstate.OnStateDeletedListener;
import com.google.android.gms.appstate.OnStateListLoadedListener;
import com.google.android.gms.appstate.OnStateLoadedListener;
import com.google.android.gms.common.GooglePlayServicesClient;
import com.google.android.gms.common.GooglePlayServicesUtil;
import com.google.android.gms.common.Scopes;
import com.google.android.gms.internal.e;
import com.google.android.gms.internal.k;

/* loaded from: classes.dex */
public final class c extends k<com.google.android.gms.internal.e> {
    private final String g;

    final class a extends com.google.android.gms.internal.b {
        private final OnStateDeletedListener n;

        public a(OnStateDeletedListener onStateDeletedListener) {
            this.n = (OnStateDeletedListener) s.b(onStateDeletedListener, "Listener must not be null");
        }

        @Override // com.google.android.gms.internal.b, com.google.android.gms.internal.d
        public void onStateDeleted(int statusCode, int stateKey) {
            c.this.a(c.this.new b(this.n, statusCode, stateKey));
        }
    }

    final class b extends k<com.google.android.gms.internal.e>.b<OnStateDeletedListener> {
        private final int p;
        private final int q;

        public b(OnStateDeletedListener onStateDeletedListener, int i, int i2) {
            super(onStateDeletedListener);
            this.p = i;
            this.q = i2;
        }

        @Override // com.google.android.gms.internal.k.b
        public void a(OnStateDeletedListener onStateDeletedListener) {
            onStateDeletedListener.onStateDeleted(this.p, this.q);
        }

        @Override // com.google.android.gms.internal.k.b
        protected void d() {
        }
    }

    /* renamed from: com.google.android.gms.internal.c$c, reason: collision with other inner class name */
    final class BinderC0018c extends com.google.android.gms.internal.b {
        private final OnStateListLoadedListener r;

        public BinderC0018c(OnStateListLoadedListener onStateListLoadedListener) {
            this.r = (OnStateListLoadedListener) s.b(onStateListLoadedListener, "Listener must not be null");
        }

        @Override // com.google.android.gms.internal.b, com.google.android.gms.internal.d
        public void a(com.google.android.gms.common.data.d dVar) {
            c.this.a(c.this.new d(this.r, dVar));
        }
    }

    final class d extends k<com.google.android.gms.internal.e>.c<OnStateListLoadedListener> {
        public d(OnStateListLoadedListener onStateListLoadedListener, com.google.android.gms.common.data.d dVar) {
            super(onStateListLoadedListener, dVar);
        }

        @Override // com.google.android.gms.internal.k.c
        public void a(OnStateListLoadedListener onStateListLoadedListener, com.google.android.gms.common.data.d dVar) {
            onStateListLoadedListener.onStateListLoaded(dVar.getStatusCode(), new AppStateBuffer(dVar));
        }
    }

    final class e extends com.google.android.gms.internal.b {
        private final OnStateLoadedListener s;

        public e(OnStateLoadedListener onStateLoadedListener) {
            this.s = (OnStateLoadedListener) s.b(onStateLoadedListener, "Listener must not be null");
        }

        @Override // com.google.android.gms.internal.b, com.google.android.gms.internal.d
        public void a(int i, com.google.android.gms.common.data.d dVar) {
            c.this.a(c.this.new f(this.s, i, dVar));
        }
    }

    final class f extends k<com.google.android.gms.internal.e>.c<OnStateLoadedListener> {
        private final int q;

        public f(OnStateLoadedListener onStateLoadedListener, int i, com.google.android.gms.common.data.d dVar) {
            super(onStateLoadedListener, dVar);
            this.q = i;
        }

        @Override // com.google.android.gms.internal.k.c
        public void a(OnStateLoadedListener onStateLoadedListener, com.google.android.gms.common.data.d dVar) {
            byte[] conflictData;
            String str;
            byte[] bArr = null;
            AppStateBuffer appStateBuffer = new AppStateBuffer(dVar);
            try {
                if (appStateBuffer.getCount() > 0) {
                    AppState appState = appStateBuffer.get(0);
                    String conflictVersion = appState.getConflictVersion();
                    byte[] localData = appState.getLocalData();
                    conflictData = appState.getConflictData();
                    str = conflictVersion;
                    bArr = localData;
                } else {
                    conflictData = null;
                    str = null;
                }
                appStateBuffer.close();
                int statusCode = dVar.getStatusCode();
                if (statusCode == 2000) {
                    onStateLoadedListener.onStateConflict(this.q, str, bArr, conflictData);
                } else {
                    onStateLoadedListener.onStateLoaded(statusCode, this.q, bArr);
                }
            } catch (Throwable th) {
                appStateBuffer.close();
                throw th;
            }
        }
    }

    final class g extends com.google.android.gms.internal.b {
        private final OnSignOutCompleteListener t;

        public g(OnSignOutCompleteListener onSignOutCompleteListener) {
            this.t = (OnSignOutCompleteListener) s.b(onSignOutCompleteListener, "Listener must not be null");
        }

        @Override // com.google.android.gms.internal.b, com.google.android.gms.internal.d
        public void onSignOutComplete() {
            c.this.a(c.this.new h(this.t));
        }
    }

    final class h extends k<com.google.android.gms.internal.e>.b<OnSignOutCompleteListener> {
        public h(OnSignOutCompleteListener onSignOutCompleteListener) {
            super(onSignOutCompleteListener);
        }

        @Override // com.google.android.gms.internal.k.b
        public void a(OnSignOutCompleteListener onSignOutCompleteListener) {
            onSignOutCompleteListener.onSignOutComplete();
        }

        @Override // com.google.android.gms.internal.k.b
        protected void d() {
        }
    }

    public c(Context context, GooglePlayServicesClient.ConnectionCallbacks connectionCallbacks, GooglePlayServicesClient.OnConnectionFailedListener onConnectionFailedListener, String str, String[] strArr) {
        super(context, connectionCallbacks, onConnectionFailedListener, strArr);
        this.g = (String) s.d(str);
    }

    public void a(OnStateLoadedListener onStateLoadedListener, int i, byte[] bArr) {
        e eVar;
        if (onStateLoadedListener == null) {
            eVar = null;
        } else {
            try {
                eVar = new e(onStateLoadedListener);
            } catch (RemoteException e2) {
                Log.w("AppStateClient", "service died");
                return;
            }
        }
        C().a(eVar, i, bArr);
    }

    @Override // com.google.android.gms.internal.k
    protected void a(p pVar, k.d dVar) throws RemoteException {
        pVar.a(dVar, GooglePlayServicesUtil.GOOGLE_PLAY_SERVICES_VERSION_CODE, getContext().getPackageName(), this.g, x());
    }

    @Override // com.google.android.gms.internal.k
    protected void a(String... strArr) {
        boolean z = false;
        for (String str : strArr) {
            if (str.equals(Scopes.APP_STATE)) {
                z = true;
            }
        }
        s.a(z, String.format("AppStateClient requires %s to function.", Scopes.APP_STATE));
    }

    /* JADX INFO: Access modifiers changed from: protected */
    @Override // com.google.android.gms.internal.k
    /* renamed from: b, reason: merged with bridge method [inline-methods] */
    public com.google.android.gms.internal.e c(IBinder iBinder) {
        return e.a.e(iBinder);
    }

    @Override // com.google.android.gms.internal.k
    protected String b() {
        return "com.google.android.gms.appstate.service.START";
    }

    @Override // com.google.android.gms.internal.k
    protected String c() {
        return "com.google.android.gms.appstate.internal.IAppStateService";
    }

    public void deleteState(OnStateDeletedListener listener, int stateKey) {
        try {
            C().b(new a(listener), stateKey);
        } catch (RemoteException e2) {
            Log.w("AppStateClient", "service died");
        }
    }

    public int getMaxNumKeys() {
        try {
            return C().getMaxNumKeys();
        } catch (RemoteException e2) {
            Log.w("AppStateClient", "service died");
            return 2;
        }
    }

    public int getMaxStateSize() {
        try {
            return C().getMaxStateSize();
        } catch (RemoteException e2) {
            Log.w("AppStateClient", "service died");
            return 2;
        }
    }

    public void listStates(OnStateListLoadedListener listener) {
        try {
            C().a(new BinderC0018c(listener));
        } catch (RemoteException e2) {
            Log.w("AppStateClient", "service died");
        }
    }

    public void loadState(OnStateLoadedListener listener, int stateKey) {
        try {
            C().a(new e(listener), stateKey);
        } catch (RemoteException e2) {
            Log.w("AppStateClient", "service died");
        }
    }

    public void resolveState(OnStateLoadedListener listener, int stateKey, String resolvedVersion, byte[] resolvedData) {
        try {
            C().a(new e(listener), stateKey, resolvedVersion, resolvedData);
        } catch (RemoteException e2) {
            Log.w("AppStateClient", "service died");
        }
    }

    public void signOut(OnSignOutCompleteListener listener) {
        g gVar;
        if (listener == null) {
            gVar = null;
        } else {
            try {
                gVar = new g(listener);
            } catch (RemoteException e2) {
                Log.w("AppStateClient", "service died");
                return;
            }
        }
        C().b(gVar);
    }
}
