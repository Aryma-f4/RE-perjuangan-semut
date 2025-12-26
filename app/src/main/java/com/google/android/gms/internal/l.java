package com.google.android.gms.internal;

import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.ServiceConnection;
import android.os.Handler;
import android.os.IBinder;
import android.os.Message;
import com.google.android.gms.common.GooglePlayServicesUtil;
import com.google.android.gms.internal.k;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;

/* loaded from: classes.dex */
public final class l implements Handler.Callback {
    private static final Object bJ = new Object();
    private static l bK;
    private final Context bL;
    private final HashMap<String, a> bM = new HashMap<>();
    private final Handler mHandler;

    final class a {
        private final String bN;
        private boolean bQ;
        private IBinder bR;
        private ComponentName bS;
        private final ServiceConnectionC0023a bO = new ServiceConnectionC0023a();
        private final HashSet<k<?>.e> bP = new HashSet<>();
        private int mState = 0;

        /* renamed from: com.google.android.gms.internal.l$a$a, reason: collision with other inner class name */
        public class ServiceConnectionC0023a implements ServiceConnection {
            public ServiceConnectionC0023a() {
            }

            @Override // android.content.ServiceConnection
            public void onServiceConnected(ComponentName component, IBinder binder) {
                synchronized (l.this.bM) {
                    a.this.bR = binder;
                    a.this.bS = component;
                    Iterator it = a.this.bP.iterator();
                    while (it.hasNext()) {
                        ((k.e) it.next()).onServiceConnected(component, binder);
                    }
                    a.this.mState = 1;
                }
            }

            @Override // android.content.ServiceConnection
            public void onServiceDisconnected(ComponentName component) {
                synchronized (l.this.bM) {
                    a.this.bR = null;
                    a.this.bS = component;
                    Iterator it = a.this.bP.iterator();
                    while (it.hasNext()) {
                        ((k.e) it.next()).onServiceDisconnected(component);
                    }
                    a.this.mState = 2;
                }
            }
        }

        public a(String str) {
            this.bN = str;
        }

        public ServiceConnectionC0023a F() {
            return this.bO;
        }

        public String G() {
            return this.bN;
        }

        public boolean H() {
            return this.bP.isEmpty();
        }

        public void a(k<?>.e eVar) {
            this.bP.add(eVar);
        }

        public void b(k<?>.e eVar) {
            this.bP.remove(eVar);
        }

        public void b(boolean z) {
            this.bQ = z;
        }

        public boolean c(k<?>.e eVar) {
            return this.bP.contains(eVar);
        }

        public IBinder getBinder() {
            return this.bR;
        }

        public ComponentName getComponentName() {
            return this.bS;
        }

        public int getState() {
            return this.mState;
        }

        public boolean isBound() {
            return this.bQ;
        }
    }

    private l(Context context) {
        this.mHandler = new Handler(context.getMainLooper(), this);
        this.bL = context.getApplicationContext();
    }

    public static l g(Context context) {
        synchronized (bJ) {
            if (bK == null) {
                bK = new l(context.getApplicationContext());
            }
        }
        return bK;
    }

    public boolean a(String str, k<?>.e eVar) {
        boolean zIsBound;
        synchronized (this.bM) {
            a aVar = this.bM.get(str);
            if (aVar != null) {
                this.mHandler.removeMessages(0, aVar);
                if (!aVar.c(eVar)) {
                    aVar.a(eVar);
                    switch (aVar.getState()) {
                        case 1:
                            eVar.onServiceConnected(aVar.getComponentName(), aVar.getBinder());
                            break;
                        case 2:
                            aVar.b(this.bL.bindService(new Intent(str).setPackage(GooglePlayServicesUtil.GOOGLE_PLAY_SERVICES_PACKAGE), aVar.F(), 129));
                            break;
                    }
                } else {
                    throw new IllegalStateException("Trying to bind a GmsServiceConnection that was already connected before.  startServiceAction=" + str);
                }
            } else {
                aVar = new a(str);
                aVar.a(eVar);
                aVar.b(this.bL.bindService(new Intent(str).setPackage(GooglePlayServicesUtil.GOOGLE_PLAY_SERVICES_PACKAGE), aVar.F(), 129));
                this.bM.put(str, aVar);
            }
            zIsBound = aVar.isBound();
        }
        return zIsBound;
    }

    public void b(String str, k<?>.e eVar) {
        synchronized (this.bM) {
            a aVar = this.bM.get(str);
            if (aVar == null) {
                throw new IllegalStateException("Nonexistent connection status for service action: " + str);
            }
            if (!aVar.c(eVar)) {
                throw new IllegalStateException("Trying to unbind a GmsServiceConnection  that was not bound before.  startServiceAction=" + str);
            }
            aVar.b(eVar);
            if (aVar.H()) {
                this.mHandler.sendMessageDelayed(this.mHandler.obtainMessage(0, aVar), 5000L);
            }
        }
    }

    @Override // android.os.Handler.Callback
    public boolean handleMessage(Message msg) {
        switch (msg.what) {
            case 0:
                a aVar = (a) msg.obj;
                synchronized (this.bM) {
                    if (aVar.H()) {
                        this.bL.unbindService(aVar.F());
                        this.bM.remove(aVar.G());
                    }
                }
                return true;
            default:
                return false;
        }
    }
}
