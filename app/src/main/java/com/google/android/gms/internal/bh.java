package com.google.android.gms.internal;

import android.app.PendingIntent;
import android.content.Context;
import android.location.Location;
import android.os.Bundle;
import android.os.IBinder;
import android.os.Looper;
import android.os.RemoteException;
import android.util.Log;
import com.google.android.gms.common.GooglePlayServicesClient;
import com.google.android.gms.common.GooglePlayServicesUtil;
import com.google.android.gms.internal.be;
import com.google.android.gms.internal.bf;
import com.google.android.gms.internal.k;
import com.google.android.gms.location.LocationClient;
import com.google.android.gms.location.LocationListener;
import com.google.android.gms.location.LocationRequest;
import com.google.android.gms.location.LocationStatusCodes;
import java.util.List;

/* loaded from: classes.dex */
public class bh extends k<bf> {
    private final bk<bf> fG;
    private final bg fM;
    private final String fN;

    private final class a extends k<bf>.b<LocationClient.OnAddGeofencesResultListener> {
        private final String[] fO;
        private final int p;

        public a(LocationClient.OnAddGeofencesResultListener onAddGeofencesResultListener, int i, String[] strArr) {
            super(onAddGeofencesResultListener);
            this.p = LocationStatusCodes.O(i);
            this.fO = strArr;
        }

        /* JADX INFO: Access modifiers changed from: protected */
        @Override // com.google.android.gms.internal.k.b
        public void a(LocationClient.OnAddGeofencesResultListener onAddGeofencesResultListener) {
            if (onAddGeofencesResultListener != null) {
                onAddGeofencesResultListener.onAddGeofencesResult(this.p, this.fO);
            }
        }

        @Override // com.google.android.gms.internal.k.b
        protected void d() {
        }
    }

    private static final class b extends be.a {
        private LocationClient.OnAddGeofencesResultListener fQ;
        private LocationClient.OnRemoveGeofencesResultListener fR;
        private bh fS;

        public b(LocationClient.OnAddGeofencesResultListener onAddGeofencesResultListener, bh bhVar) {
            this.fQ = onAddGeofencesResultListener;
            this.fR = null;
            this.fS = bhVar;
        }

        public b(LocationClient.OnRemoveGeofencesResultListener onRemoveGeofencesResultListener, bh bhVar) {
            this.fR = onRemoveGeofencesResultListener;
            this.fQ = null;
            this.fS = bhVar;
        }

        @Override // com.google.android.gms.internal.be
        public void onAddGeofencesResult(int statusCode, String[] geofenceRequestIds) throws RemoteException {
            if (this.fS == null) {
                Log.wtf("LocationClientImpl", "onAddGeofenceResult called multiple times");
                return;
            }
            bh bhVar = this.fS;
            bh bhVar2 = this.fS;
            bhVar2.getClass();
            bhVar.a(bhVar2.new a(this.fQ, statusCode, geofenceRequestIds));
            this.fS = null;
            this.fQ = null;
            this.fR = null;
        }

        @Override // com.google.android.gms.internal.be
        public void onRemoveGeofencesByPendingIntentResult(int statusCode, PendingIntent pendingIntent) {
            if (this.fS == null) {
                Log.wtf("LocationClientImpl", "onRemoveGeofencesByPendingIntentResult called multiple times");
                return;
            }
            bh bhVar = this.fS;
            bh bhVar2 = this.fS;
            bhVar2.getClass();
            bhVar.a(bhVar2.new d(1, this.fR, statusCode, pendingIntent));
            this.fS = null;
            this.fQ = null;
            this.fR = null;
        }

        @Override // com.google.android.gms.internal.be
        public void onRemoveGeofencesByRequestIdsResult(int statusCode, String[] geofenceRequestIds) {
            if (this.fS == null) {
                Log.wtf("LocationClientImpl", "onRemoveGeofencesByRequestIdsResult called multiple times");
                return;
            }
            bh bhVar = this.fS;
            bh bhVar2 = this.fS;
            bhVar2.getClass();
            bhVar.a(bhVar2.new d(2, this.fR, statusCode, geofenceRequestIds));
            this.fS = null;
            this.fQ = null;
            this.fR = null;
        }
    }

    private final class c implements bk<bf> {
        private c() {
        }

        @Override // com.google.android.gms.internal.bk
        public void B() {
            bh.this.B();
        }

        @Override // com.google.android.gms.internal.bk
        /* renamed from: aS, reason: merged with bridge method [inline-methods] */
        public bf C() {
            return (bf) bh.this.C();
        }
    }

    private final class d extends k<bf>.b<LocationClient.OnRemoveGeofencesResultListener> {
        private final String[] fO;
        private final int fT;
        private final PendingIntent mPendingIntent;
        private final int p;

        public d(int i, LocationClient.OnRemoveGeofencesResultListener onRemoveGeofencesResultListener, int i2, PendingIntent pendingIntent) {
            super(onRemoveGeofencesResultListener);
            h.a(i == 1);
            this.fT = i;
            this.p = LocationStatusCodes.O(i2);
            this.mPendingIntent = pendingIntent;
            this.fO = null;
        }

        public d(int i, LocationClient.OnRemoveGeofencesResultListener onRemoveGeofencesResultListener, int i2, String[] strArr) {
            super(onRemoveGeofencesResultListener);
            h.a(i == 2);
            this.fT = i;
            this.p = LocationStatusCodes.O(i2);
            this.fO = strArr;
            this.mPendingIntent = null;
        }

        /* JADX INFO: Access modifiers changed from: protected */
        @Override // com.google.android.gms.internal.k.b
        public void a(LocationClient.OnRemoveGeofencesResultListener onRemoveGeofencesResultListener) {
            if (onRemoveGeofencesResultListener != null) {
                switch (this.fT) {
                    case 1:
                        onRemoveGeofencesResultListener.onRemoveGeofencesByPendingIntentResult(this.p, this.mPendingIntent);
                        break;
                    case 2:
                        onRemoveGeofencesResultListener.onRemoveGeofencesByRequestIdsResult(this.p, this.fO);
                        break;
                    default:
                        Log.wtf("LocationClientImpl", "Unsupported action: " + this.fT);
                        break;
                }
            }
        }

        @Override // com.google.android.gms.internal.k.b
        protected void d() {
        }
    }

    public bh(Context context, GooglePlayServicesClient.ConnectionCallbacks connectionCallbacks, GooglePlayServicesClient.OnConnectionFailedListener onConnectionFailedListener, String str) {
        super(context, connectionCallbacks, onConnectionFailedListener, new String[0]);
        this.fG = new c();
        this.fM = new bg(context, this.fG);
        this.fN = str;
    }

    @Override // com.google.android.gms.internal.k
    protected void a(p pVar, k.d dVar) throws RemoteException {
        Bundle bundle = new Bundle();
        bundle.putString("client_name", this.fN);
        pVar.e(dVar, GooglePlayServicesUtil.GOOGLE_PLAY_SERVICES_VERSION_CODE, getContext().getPackageName(), bundle);
    }

    public void addGeofences(List<bi> geofences, PendingIntent pendingIntent, LocationClient.OnAddGeofencesResultListener listener) {
        b bVar;
        B();
        s.b(geofences != null && geofences.size() > 0, "At least one geofence must be specified.");
        s.b(pendingIntent, "PendingIntent must be specified.");
        s.b(listener, "OnAddGeofencesResultListener not provided.");
        if (listener == null) {
            bVar = null;
        } else {
            try {
                bVar = new b(listener, this);
            } catch (RemoteException e) {
                throw new IllegalStateException(e);
            }
        }
        C().a(geofences, pendingIntent, bVar, getContext().getPackageName());
    }

    @Override // com.google.android.gms.internal.k
    protected String b() {
        return "com.google.android.location.internal.GoogleLocationManagerService.START";
    }

    @Override // com.google.android.gms.internal.k
    protected String c() {
        return "com.google.android.gms.location.internal.IGoogleLocationManagerService";
    }

    @Override // com.google.android.gms.internal.k, com.google.android.gms.common.GooglePlayServicesClient
    public void disconnect() {
        synchronized (this.fM) {
            if (isConnected()) {
                this.fM.removeAllListeners();
                this.fM.aR();
            }
            super.disconnect();
        }
    }

    public Location getLastLocation() {
        return this.fM.getLastLocation();
    }

    public void removeActivityUpdates(PendingIntent callbackIntent) {
        B();
        s.d(callbackIntent);
        try {
            C().removeActivityUpdates(callbackIntent);
        } catch (RemoteException e) {
            throw new IllegalStateException(e);
        }
    }

    public void removeGeofences(PendingIntent pendingIntent, LocationClient.OnRemoveGeofencesResultListener listener) {
        b bVar;
        B();
        s.b(pendingIntent, "PendingIntent must be specified.");
        s.b(listener, "OnRemoveGeofencesResultListener not provided.");
        if (listener == null) {
            bVar = null;
        } else {
            try {
                bVar = new b(listener, this);
            } catch (RemoteException e) {
                throw new IllegalStateException(e);
            }
        }
        C().a(pendingIntent, bVar, getContext().getPackageName());
    }

    public void removeGeofences(List<String> geofenceRequestIds, LocationClient.OnRemoveGeofencesResultListener listener) {
        b bVar;
        B();
        s.b(geofenceRequestIds != null && geofenceRequestIds.size() > 0, "geofenceRequestIds can't be null nor empty.");
        s.b(listener, "OnRemoveGeofencesResultListener not provided.");
        String[] strArr = (String[]) geofenceRequestIds.toArray(new String[0]);
        if (listener == null) {
            bVar = null;
        } else {
            try {
                bVar = new b(listener, this);
            } catch (RemoteException e) {
                throw new IllegalStateException(e);
            }
        }
        C().a(strArr, bVar, getContext().getPackageName());
    }

    public void removeLocationUpdates(PendingIntent callbackIntent) {
        this.fM.removeLocationUpdates(callbackIntent);
    }

    public void removeLocationUpdates(LocationListener listener) {
        this.fM.removeLocationUpdates(listener);
    }

    public void requestActivityUpdates(long detectionIntervalMillis, PendingIntent callbackIntent) {
        B();
        s.d(callbackIntent);
        s.b(detectionIntervalMillis >= 0, "detectionIntervalMillis must be >= 0");
        try {
            C().a(detectionIntervalMillis, true, callbackIntent);
        } catch (RemoteException e) {
            throw new IllegalStateException(e);
        }
    }

    public void requestLocationUpdates(LocationRequest request, PendingIntent callbackIntent) {
        this.fM.requestLocationUpdates(request, callbackIntent);
    }

    public void requestLocationUpdates(LocationRequest request, LocationListener listener) {
        requestLocationUpdates(request, listener, null);
    }

    public void requestLocationUpdates(LocationRequest request, LocationListener listener, Looper looper) {
        synchronized (this.fM) {
            this.fM.requestLocationUpdates(request, listener, looper);
        }
    }

    /* JADX INFO: Access modifiers changed from: protected */
    @Override // com.google.android.gms.internal.k
    /* renamed from: s, reason: merged with bridge method [inline-methods] */
    public bf c(IBinder iBinder) {
        return bf.a.r(iBinder);
    }

    public void setMockLocation(Location mockLocation) {
        this.fM.setMockLocation(mockLocation);
    }

    public void setMockMode(boolean isMockMode) {
        this.fM.setMockMode(isMockMode);
    }
}
