package com.google.android.gms.internal;

import android.app.PendingIntent;
import android.content.ComponentName;
import android.content.Context;
import android.content.ServiceConnection;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.os.Handler;
import android.os.IBinder;
import android.os.IInterface;
import android.os.Looper;
import android.os.Message;
import android.os.RemoteException;
import android.util.Log;
import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.GooglePlayServicesClient;
import com.google.android.gms.common.GooglePlayServicesUtil;
import com.google.android.gms.internal.o;
import com.google.android.gms.internal.p;
import java.security.cert.CertificateException;
import java.util.ArrayList;

/* loaded from: classes.dex */
public abstract class k<T extends IInterface> implements GooglePlayServicesClient {
    public static final String[] bD = {"service_esmobile", "service_googleme"};
    private T bs;
    private ArrayList<GooglePlayServicesClient.OnConnectionFailedListener> bw;
    private k<T>.e bz;
    private final String[] f;
    private final Context mContext;
    final Handler mHandler;
    final ArrayList<GooglePlayServicesClient.ConnectionCallbacks> bu = new ArrayList<>();
    private boolean bv = false;
    private boolean bx = false;
    private final ArrayList<k<T>.b<?>> by = new ArrayList<>();
    boolean bA = false;
    boolean bB = false;
    private final Object bC = new Object();
    private ArrayList<GooglePlayServicesClient.ConnectionCallbacks> bt = new ArrayList<>();

    final class a extends Handler {
        public a(Looper looper) {
            super(looper);
        }

        @Override // android.os.Handler
        public void handleMessage(Message msg) {
            if (msg.what == 1 && !k.this.isConnecting()) {
                b bVar = (b) msg.obj;
                bVar.d();
                bVar.unregister();
                return;
            }
            synchronized (k.this.bC) {
                k.this.bB = false;
            }
            if (msg.what == 3) {
                k.this.a(new ConnectionResult(((Integer) msg.obj).intValue(), null));
                return;
            }
            if (msg.what == 4) {
                synchronized (k.this.bt) {
                    if (k.this.bA && k.this.isConnected() && k.this.bt.contains(msg.obj)) {
                        ((GooglePlayServicesClient.ConnectionCallbacks) msg.obj).onConnected(k.this.z());
                    }
                }
                return;
            }
            if (msg.what == 2 && !k.this.isConnected()) {
                b bVar2 = (b) msg.obj;
                bVar2.d();
                bVar2.unregister();
            } else if (msg.what == 2 || msg.what == 1) {
                ((b) msg.obj).D();
            } else {
                Log.wtf("GmsClient", "Don't know how to handle this message.");
            }
        }
    }

    protected abstract class b<TListener> {
        private boolean bF = false;
        private TListener mListener;

        public b(TListener tlistener) {
            this.mListener = tlistener;
        }

        public void D() {
            TListener tlistener;
            synchronized (this) {
                tlistener = this.mListener;
                if (this.bF) {
                    Log.w("GmsClient", "Callback proxy " + this + " being reused. This is not safe.");
                }
            }
            if (tlistener != null) {
                try {
                    a(tlistener);
                } catch (RuntimeException e) {
                    d();
                    throw e;
                }
            } else {
                d();
            }
            synchronized (this) {
                this.bF = true;
            }
            unregister();
        }

        public void E() {
            synchronized (this) {
                this.mListener = null;
            }
        }

        protected abstract void a(TListener tlistener);

        protected abstract void d();

        public void unregister() {
            E();
            synchronized (k.this.by) {
                k.this.by.remove(this);
            }
        }
    }

    public abstract class c<TListener> extends k<T>.b<TListener> {
        private final com.google.android.gms.common.data.d S;

        public c(TListener tlistener, com.google.android.gms.common.data.d dVar) {
            super(tlistener);
            this.S = dVar;
        }

        @Override // com.google.android.gms.internal.k.b
        public /* bridge */ /* synthetic */ void D() {
            super.D();
        }

        @Override // com.google.android.gms.internal.k.b
        public /* bridge */ /* synthetic */ void E() {
            super.E();
        }

        @Override // com.google.android.gms.internal.k.b
        protected final void a(TListener tlistener) {
            a(tlistener, this.S);
        }

        protected abstract void a(TListener tlistener, com.google.android.gms.common.data.d dVar);

        @Override // com.google.android.gms.internal.k.b
        protected void d() {
            if (this.S != null) {
                this.S.close();
            }
        }

        @Override // com.google.android.gms.internal.k.b
        public /* bridge */ /* synthetic */ void unregister() {
            super.unregister();
        }
    }

    public static final class d extends o.a {
        private k bG;

        public d(k kVar) {
            this.bG = kVar;
        }

        @Override // com.google.android.gms.internal.o
        public void b(int i, IBinder iBinder, Bundle bundle) {
            s.b("onPostInitComplete can be called only once per call to getServiceFromBroker", this.bG);
            this.bG.a(i, iBinder, bundle);
            this.bG = null;
        }
    }

    final class e implements ServiceConnection {
        e() {
        }

        @Override // android.content.ServiceConnection
        public void onServiceConnected(ComponentName component, IBinder binder) {
            k.this.f(binder);
        }

        @Override // android.content.ServiceConnection
        public void onServiceDisconnected(ComponentName component) {
            k.this.bs = null;
            k.this.A();
        }
    }

    protected final class f extends k<T>.b<Boolean> {
        public final Bundle bH;
        public final IBinder bI;
        public final int statusCode;

        public f(int i, IBinder iBinder, Bundle bundle) {
            super(true);
            this.statusCode = i;
            this.bI = iBinder;
            this.bH = bundle;
        }

        /* JADX INFO: Access modifiers changed from: protected */
        @Override // com.google.android.gms.internal.k.b
        public void a(Boolean bool) {
            if (bool == null) {
                return;
            }
            switch (this.statusCode) {
                case 0:
                    try {
                        if (k.this.c().equals(this.bI.getInterfaceDescriptor())) {
                            k.this.bs = k.this.c(this.bI);
                            if (k.this.bs != null) {
                                k.this.y();
                                return;
                            }
                        }
                    } catch (RemoteException e) {
                    }
                    l.g(k.this.mContext).b(k.this.b(), k.this.bz);
                    k.this.bz = null;
                    k.this.bs = null;
                    k.this.a(new ConnectionResult(8, null));
                    return;
                case 10:
                    throw new IllegalStateException("A fatal developer error has occurred. Check the logs for further information.");
                default:
                    PendingIntent pendingIntent = this.bH != null ? (PendingIntent) this.bH.getParcelable("pendingIntent") : null;
                    if (k.this.bz != null) {
                        l.g(k.this.mContext).b(k.this.b(), k.this.bz);
                        k.this.bz = null;
                    }
                    k.this.bs = null;
                    k.this.a(new ConnectionResult(this.statusCode, pendingIntent));
                    return;
            }
        }

        @Override // com.google.android.gms.internal.k.b
        protected void d() {
        }
    }

    /* JADX WARN: Multi-variable type inference failed */
    protected k(Context context, GooglePlayServicesClient.ConnectionCallbacks connectionCallbacks, GooglePlayServicesClient.OnConnectionFailedListener onConnectionFailedListener, String... strArr) {
        this.mContext = (Context) s.d(context);
        this.bt.add(s.d(connectionCallbacks));
        this.bw = new ArrayList<>();
        this.bw.add(s.d(onConnectionFailedListener));
        this.mHandler = new a(context.getMainLooper());
        a(strArr);
        this.f = strArr;
    }

    protected final void A() {
        this.mHandler.removeMessages(4);
        synchronized (this.bt) {
            this.bv = true;
            ArrayList<GooglePlayServicesClient.ConnectionCallbacks> arrayList = this.bt;
            int size = arrayList.size();
            for (int i = 0; i < size && this.bA; i++) {
                if (this.bt.contains(arrayList.get(i))) {
                    arrayList.get(i).onDisconnected();
                }
            }
            this.bv = false;
        }
    }

    protected final void B() {
        if (!isConnected()) {
            throw new IllegalStateException("Not connected. Call connect() and wait for onConnected() to be called.");
        }
    }

    protected final T C() {
        B();
        return this.bs;
    }

    protected void a(int i, IBinder iBinder, Bundle bundle) {
        this.mHandler.sendMessage(this.mHandler.obtainMessage(1, new f(i, iBinder, bundle)));
    }

    protected void a(ConnectionResult connectionResult) {
        this.mHandler.removeMessages(4);
        synchronized (this.bw) {
            this.bx = true;
            ArrayList<GooglePlayServicesClient.OnConnectionFailedListener> arrayList = this.bw;
            int size = arrayList.size();
            for (int i = 0; i < size; i++) {
                if (!this.bA) {
                    return;
                }
                if (this.bw.contains(arrayList.get(i))) {
                    arrayList.get(i).onConnectionFailed(connectionResult);
                }
            }
            this.bx = false;
        }
    }

    public final void a(k<T>.b<?> bVar) {
        synchronized (this.by) {
            this.by.add(bVar);
        }
        this.mHandler.sendMessage(this.mHandler.obtainMessage(2, bVar));
    }

    protected abstract void a(p pVar, d dVar) throws RemoteException;

    protected void a(String... strArr) {
    }

    protected abstract String b();

    protected abstract T c(IBinder iBinder);

    protected abstract String c();

    @Override // com.google.android.gms.common.GooglePlayServicesClient
    public void connect() throws PackageManager.NameNotFoundException, CertificateException {
        this.bA = true;
        synchronized (this.bC) {
            this.bB = true;
        }
        int iIsGooglePlayServicesAvailable = GooglePlayServicesUtil.isGooglePlayServicesAvailable(this.mContext);
        if (iIsGooglePlayServicesAvailable != 0) {
            this.mHandler.sendMessage(this.mHandler.obtainMessage(3, Integer.valueOf(iIsGooglePlayServicesAvailable)));
            return;
        }
        if (this.bz != null) {
            Log.e("GmsClient", "Calling connect() while still connected, missing disconnect().");
            this.bs = null;
            l.g(this.mContext).b(b(), this.bz);
        }
        this.bz = new e();
        if (l.g(this.mContext).a(b(), this.bz)) {
            return;
        }
        Log.e("GmsClient", "unable to connect to service: " + b());
        this.mHandler.sendMessage(this.mHandler.obtainMessage(3, 9));
    }

    @Override // com.google.android.gms.common.GooglePlayServicesClient
    public void disconnect() {
        this.bA = false;
        synchronized (this.bC) {
            this.bB = false;
        }
        synchronized (this.by) {
            int size = this.by.size();
            for (int i = 0; i < size; i++) {
                this.by.get(i).E();
            }
            this.by.clear();
        }
        this.bs = null;
        if (this.bz != null) {
            l.g(this.mContext).b(b(), this.bz);
            this.bz = null;
        }
    }

    protected final void f(IBinder iBinder) {
        try {
            a(p.a.h(iBinder), new d(this));
        } catch (RemoteException e2) {
            Log.w("GmsClient", "service died");
        }
    }

    public final Context getContext() {
        return this.mContext;
    }

    @Override // com.google.android.gms.common.GooglePlayServicesClient
    public boolean isConnected() {
        return this.bs != null;
    }

    @Override // com.google.android.gms.common.GooglePlayServicesClient
    public boolean isConnecting() {
        boolean z;
        synchronized (this.bC) {
            z = this.bB;
        }
        return z;
    }

    @Override // com.google.android.gms.common.GooglePlayServicesClient
    public boolean isConnectionCallbacksRegistered(GooglePlayServicesClient.ConnectionCallbacks listener) {
        boolean zContains;
        s.d(listener);
        synchronized (this.bt) {
            zContains = this.bt.contains(listener);
        }
        return zContains;
    }

    @Override // com.google.android.gms.common.GooglePlayServicesClient
    public boolean isConnectionFailedListenerRegistered(GooglePlayServicesClient.OnConnectionFailedListener listener) {
        boolean zContains;
        s.d(listener);
        synchronized (this.bw) {
            zContains = this.bw.contains(listener);
        }
        return zContains;
    }

    @Override // com.google.android.gms.common.GooglePlayServicesClient
    public void registerConnectionCallbacks(GooglePlayServicesClient.ConnectionCallbacks listener) {
        s.d(listener);
        synchronized (this.bt) {
            if (this.bt.contains(listener)) {
                Log.w("GmsClient", "registerConnectionCallbacks(): listener " + listener + " is already registered");
            } else {
                if (this.bv) {
                    this.bt = new ArrayList<>(this.bt);
                }
                this.bt.add(listener);
            }
        }
        if (isConnected()) {
            this.mHandler.sendMessage(this.mHandler.obtainMessage(4, listener));
        }
    }

    @Override // com.google.android.gms.common.GooglePlayServicesClient
    public void registerConnectionFailedListener(GooglePlayServicesClient.OnConnectionFailedListener listener) {
        s.d(listener);
        synchronized (this.bw) {
            if (this.bw.contains(listener)) {
                Log.w("GmsClient", "registerConnectionFailedListener(): listener " + listener + " is already registered");
            } else {
                if (this.bx) {
                    this.bw = new ArrayList<>(this.bw);
                }
                this.bw.add(listener);
            }
        }
    }

    @Override // com.google.android.gms.common.GooglePlayServicesClient
    public void unregisterConnectionCallbacks(GooglePlayServicesClient.ConnectionCallbacks listener) {
        s.d(listener);
        synchronized (this.bt) {
            if (this.bt != null) {
                if (this.bv) {
                    this.bt = new ArrayList<>(this.bt);
                }
                if (!this.bt.remove(listener)) {
                    Log.w("GmsClient", "unregisterConnectionCallbacks(): listener " + listener + " not found");
                } else if (this.bv && !this.bu.contains(listener)) {
                    this.bu.add(listener);
                }
            }
        }
    }

    @Override // com.google.android.gms.common.GooglePlayServicesClient
    public void unregisterConnectionFailedListener(GooglePlayServicesClient.OnConnectionFailedListener listener) {
        s.d(listener);
        synchronized (this.bw) {
            if (this.bw != null) {
                if (this.bx) {
                    this.bw = new ArrayList<>(this.bw);
                }
                if (!this.bw.remove(listener)) {
                    Log.w("GmsClient", "unregisterConnectionFailedListener(): listener " + listener + " not found");
                }
            }
        }
    }

    public final String[] x() {
        return this.f;
    }

    protected void y() {
        synchronized (this.bt) {
            s.a(!this.bv);
            this.mHandler.removeMessages(4);
            this.bv = true;
            s.a(this.bu.size() == 0);
            Bundle bundleZ = z();
            ArrayList<GooglePlayServicesClient.ConnectionCallbacks> arrayList = this.bt;
            int size = arrayList.size();
            for (int i = 0; i < size && this.bA && isConnected(); i++) {
                this.bu.size();
                if (!this.bu.contains(arrayList.get(i))) {
                    arrayList.get(i).onConnected(bundleZ);
                }
            }
            this.bu.clear();
            this.bv = false;
        }
    }

    protected Bundle z() {
        return null;
    }
}
