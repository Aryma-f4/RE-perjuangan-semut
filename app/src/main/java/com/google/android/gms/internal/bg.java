package com.google.android.gms.internal;

import android.app.PendingIntent;
import android.content.ContentProviderClient;
import android.content.ContentResolver;
import android.content.Context;
import android.location.Location;
import android.os.Handler;
import android.os.Looper;
import android.os.Message;
import android.os.RemoteException;
import android.util.Log;
import com.google.android.gms.location.LocationListener;
import com.google.android.gms.location.LocationRequest;
import com.google.android.gms.location.a;
import java.util.HashMap;

/* loaded from: classes.dex */
public class bg {
    private final bk<bf> fG;
    private ContentProviderClient fH = null;
    private boolean fI = false;
    private HashMap<LocationListener, b> fJ = new HashMap<>();
    private final ContentResolver mContentResolver;

    private static class a extends Handler {
        private final LocationListener fK;

        public a(LocationListener locationListener) {
            this.fK = locationListener;
        }

        public a(LocationListener locationListener, Looper looper) {
            super(looper);
            this.fK = locationListener;
        }

        @Override // android.os.Handler
        public void handleMessage(Message msg) {
            switch (msg.what) {
                case 1:
                    this.fK.onLocationChanged(new Location((Location) msg.obj));
                    break;
                default:
                    Log.e("LocationClientHelper", "unknown message in LocationHandler.handleMessage");
                    break;
            }
        }
    }

    private static class b extends a.AbstractBinderC0027a {
        private Handler fL;

        b(LocationListener locationListener, Looper looper) {
            this.fL = looper == null ? new a(locationListener) : new a(locationListener, looper);
        }

        @Override // com.google.android.gms.location.a
        public void onLocationChanged(Location location) {
            if (this.fL == null) {
                Log.e("LocationClientHelper", "Received a location in client after calling removeLocationUpdates.");
                return;
            }
            Message messageObtain = Message.obtain();
            messageObtain.what = 1;
            messageObtain.obj = location;
            this.fL.sendMessage(messageObtain);
        }

        public void release() {
            this.fL = null;
        }
    }

    public bg(Context context, bk<bf> bkVar) {
        this.fG = bkVar;
        this.mContentResolver = context.getContentResolver();
    }

    public void aR() {
        if (this.fI) {
            setMockMode(false);
        }
    }

    public Location getLastLocation() {
        this.fG.B();
        try {
            return ((bf) this.fG.C()).aQ();
        } catch (RemoteException e) {
            throw new IllegalStateException(e);
        }
    }

    public void removeAllListeners() {
        try {
            synchronized (this.fJ) {
                for (b bVar : this.fJ.values()) {
                    if (bVar != null) {
                        ((bf) this.fG.C()).a(bVar);
                    }
                }
                this.fJ.clear();
            }
        } catch (RemoteException e) {
            throw new IllegalStateException(e);
        }
    }

    public void removeLocationUpdates(PendingIntent callbackIntent) {
        this.fG.B();
        try {
            ((bf) this.fG.C()).a(callbackIntent);
        } catch (RemoteException e) {
            throw new IllegalStateException(e);
        }
    }

    public void removeLocationUpdates(LocationListener listener) {
        this.fG.B();
        s.b(listener, "Invalid null listener");
        synchronized (this.fJ) {
            b bVarRemove = this.fJ.remove(listener);
            if (this.fH != null && this.fJ.isEmpty()) {
                this.fH.release();
                this.fH = null;
            }
            if (bVarRemove != null) {
                bVarRemove.release();
                try {
                    ((bf) this.fG.C()).a(bVarRemove);
                } catch (RemoteException e) {
                    throw new IllegalStateException(e);
                }
            }
        }
    }

    public void requestLocationUpdates(LocationRequest request, PendingIntent callbackIntent) {
        this.fG.B();
        try {
            ((bf) this.fG.C()).a(request, callbackIntent);
        } catch (RemoteException e) {
            throw new IllegalStateException(e);
        }
    }

    public void requestLocationUpdates(LocationRequest request, LocationListener listener, Looper looper) {
        this.fG.B();
        if (looper == null) {
            s.b(Looper.myLooper(), "Can't create handler inside thread that has not called Looper.prepare()");
        }
        synchronized (this.fJ) {
            b bVar = this.fJ.get(listener);
            if (bVar == null) {
                bVar = new b(listener, looper);
            }
            this.fJ.put(listener, bVar);
            try {
                ((bf) this.fG.C()).a(request, bVar);
            } catch (RemoteException e) {
                throw new IllegalStateException(e);
            }
        }
    }

    public void setMockLocation(Location mockLocation) {
        this.fG.B();
        try {
            ((bf) this.fG.C()).setMockLocation(mockLocation);
        } catch (RemoteException e) {
            throw new IllegalStateException(e);
        }
    }

    public void setMockMode(boolean isMockMode) {
        this.fG.B();
        try {
            ((bf) this.fG.C()).setMockMode(isMockMode);
            this.fI = isMockMode;
        } catch (RemoteException e) {
            throw new IllegalStateException(e);
        }
    }
}
