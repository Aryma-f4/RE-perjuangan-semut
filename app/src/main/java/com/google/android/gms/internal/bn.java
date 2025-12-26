package com.google.android.gms.internal;

import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.os.IBinder;
import android.os.RemoteException;
import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.GooglePlayServicesClient;
import com.google.android.gms.common.GooglePlayServicesUtil;
import com.google.android.gms.internal.bl;
import com.google.android.gms.internal.bm;
import com.google.android.gms.internal.k;
import com.google.android.gms.panorama.PanoramaClient;

/* loaded from: classes.dex */
public class bn extends k<bm> {

    final class a extends k<bm>.b<PanoramaClient.a> {
        public final ConnectionResult hO;
        public final Intent hP;
        public final int type;

        public a(PanoramaClient.a aVar, ConnectionResult connectionResult, int i, Intent intent) {
            super(aVar);
            this.hO = connectionResult;
            this.type = i;
            this.hP = intent;
        }

        /* JADX INFO: Access modifiers changed from: protected */
        @Override // com.google.android.gms.internal.k.b
        public void a(PanoramaClient.a aVar) {
            if (aVar != null) {
                aVar.a(this.hO, this.type, this.hP);
            }
        }

        @Override // com.google.android.gms.internal.k.b
        protected void d() {
        }
    }

    final class b extends bl.a {
        private final PanoramaClient.a hR = null;
        private final PanoramaClient.OnPanoramaInfoLoadedListener hS;
        private final Uri hT;

        public b(PanoramaClient.OnPanoramaInfoLoadedListener onPanoramaInfoLoadedListener, Uri uri) {
            this.hS = onPanoramaInfoLoadedListener;
            this.hT = uri;
        }

        @Override // com.google.android.gms.internal.bl
        public void a(int i, Bundle bundle, int i2, Intent intent) {
            if (this.hT != null) {
                bn.this.getContext().revokeUriPermission(this.hT, 1);
            }
            ConnectionResult connectionResult = new ConnectionResult(i, bundle != null ? (PendingIntent) bundle.getParcelable("pendingIntent") : null);
            if (this.hR != null) {
                bn.this.a(bn.this.new a(this.hR, connectionResult, i2, intent));
            } else {
                bn.this.a(bn.this.new c(this.hS, connectionResult, intent));
            }
        }
    }

    final class c extends k<bm>.b<PanoramaClient.OnPanoramaInfoLoadedListener> {
        private final ConnectionResult hO;
        private final Intent hP;

        public c(PanoramaClient.OnPanoramaInfoLoadedListener onPanoramaInfoLoadedListener, ConnectionResult connectionResult, Intent intent) {
            super(onPanoramaInfoLoadedListener);
            this.hO = connectionResult;
            this.hP = intent;
        }

        /* JADX INFO: Access modifiers changed from: protected */
        @Override // com.google.android.gms.internal.k.b
        public void a(PanoramaClient.OnPanoramaInfoLoadedListener onPanoramaInfoLoadedListener) {
            if (onPanoramaInfoLoadedListener != null) {
                onPanoramaInfoLoadedListener.onPanoramaInfoLoaded(this.hO, this.hP);
            }
        }

        @Override // com.google.android.gms.internal.k.b
        protected void d() {
        }
    }

    public bn(Context context, GooglePlayServicesClient.ConnectionCallbacks connectionCallbacks, GooglePlayServicesClient.OnConnectionFailedListener onConnectionFailedListener) {
        super(context, connectionCallbacks, onConnectionFailedListener, (String[]) null);
    }

    @Override // com.google.android.gms.internal.k
    /* renamed from: X, reason: merged with bridge method [inline-methods] */
    public bm c(IBinder iBinder) {
        return bm.a.W(iBinder);
    }

    public void a(b bVar, Uri uri, Bundle bundle, boolean z) {
        B();
        if (z) {
            getContext().grantUriPermission(GooglePlayServicesUtil.GOOGLE_PLAY_SERVICES_PACKAGE, uri, 1);
        }
        try {
            C().a(bVar, uri, bundle, z);
        } catch (RemoteException e) {
            bVar.a(8, null, 0, null);
        }
    }

    @Override // com.google.android.gms.internal.k
    protected void a(p pVar, k.d dVar) throws RemoteException {
        pVar.a(dVar, GooglePlayServicesUtil.GOOGLE_PLAY_SERVICES_VERSION_CODE, getContext().getPackageName(), new Bundle());
    }

    public void a(PanoramaClient.OnPanoramaInfoLoadedListener onPanoramaInfoLoadedListener, Uri uri, boolean z) {
        a(new b(onPanoramaInfoLoadedListener, z ? uri : null), uri, null, z);
    }

    @Override // com.google.android.gms.internal.k
    protected String b() {
        return "com.google.android.gms.panorama.service.START";
    }

    @Override // com.google.android.gms.internal.k
    protected String c() {
        return "com.google.android.gms.panorama.internal.IPanoramaService";
    }
}
