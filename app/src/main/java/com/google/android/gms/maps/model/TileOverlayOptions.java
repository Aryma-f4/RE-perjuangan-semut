package com.google.android.gms.maps.model;

import android.os.IBinder;
import android.os.Parcel;
import android.os.RemoteException;
import com.google.android.gms.common.internal.safeparcel.SafeParcelable;
import com.google.android.gms.maps.internal.q;
import com.google.android.gms.maps.model.internal.g;

/* loaded from: classes.dex */
public final class TileOverlayOptions implements SafeParcelable {
    public static final TileOverlayOptionsCreator CREATOR = new TileOverlayOptionsCreator();
    private final int ab;
    private com.google.android.gms.maps.model.internal.g hG;
    private TileProvider hH;
    private float hb;
    private boolean hc;

    public TileOverlayOptions() {
        this.hc = true;
        this.ab = 1;
    }

    TileOverlayOptions(int versionCode, IBinder delegate, boolean visible, float zIndex) {
        this.hc = true;
        this.ab = versionCode;
        this.hG = g.a.U(delegate);
        this.hH = this.hG == null ? null : new TileProvider() { // from class: com.google.android.gms.maps.model.TileOverlayOptions.1
            private final com.google.android.gms.maps.model.internal.g hI;

            {
                this.hI = TileOverlayOptions.this.hG;
            }

            @Override // com.google.android.gms.maps.model.TileProvider
            public Tile getTile(int x, int y, int zoom) {
                try {
                    return this.hI.getTile(x, y, zoom);
                } catch (RemoteException e) {
                    return null;
                }
            }
        };
        this.hc = visible;
        this.hb = zIndex;
    }

    IBinder bs() {
        return this.hG.asBinder();
    }

    @Override // android.os.Parcelable
    public int describeContents() {
        return 0;
    }

    public TileProvider getTileProvider() {
        return this.hH;
    }

    public float getZIndex() {
        return this.hb;
    }

    int i() {
        return this.ab;
    }

    public boolean isVisible() {
        return this.hc;
    }

    public TileOverlayOptions tileProvider(final TileProvider tileProvider) {
        this.hH = tileProvider;
        this.hG = this.hH == null ? null : new g.a() { // from class: com.google.android.gms.maps.model.TileOverlayOptions.2
            @Override // com.google.android.gms.maps.model.internal.g
            public Tile getTile(int x, int y, int zoom) {
                return tileProvider.getTile(x, y, zoom);
            }
        };
        return this;
    }

    public TileOverlayOptions visible(boolean visible) {
        this.hc = visible;
        return this;
    }

    @Override // android.os.Parcelable
    public void writeToParcel(Parcel out, int flags) {
        if (q.bn()) {
            j.a(this, out, flags);
        } else {
            TileOverlayOptionsCreator.a(this, out, flags);
        }
    }

    public TileOverlayOptions zIndex(float zIndex) {
        this.hb = zIndex;
        return this;
    }
}
