package com.google.android.gms.maps;

import android.graphics.Bitmap;
import android.location.Location;
import android.os.RemoteException;
import android.view.View;
import com.google.android.gms.internal.s;
import com.google.android.gms.maps.LocationSource;
import com.google.android.gms.maps.internal.IGoogleMapDelegate;
import com.google.android.gms.maps.internal.ILocationSourceDelegate;
import com.google.android.gms.maps.internal.b;
import com.google.android.gms.maps.internal.d;
import com.google.android.gms.maps.internal.e;
import com.google.android.gms.maps.internal.f;
import com.google.android.gms.maps.internal.g;
import com.google.android.gms.maps.internal.h;
import com.google.android.gms.maps.internal.i;
import com.google.android.gms.maps.internal.j;
import com.google.android.gms.maps.internal.k;
import com.google.android.gms.maps.internal.l;
import com.google.android.gms.maps.internal.m;
import com.google.android.gms.maps.internal.n;
import com.google.android.gms.maps.model.CameraPosition;
import com.google.android.gms.maps.model.Circle;
import com.google.android.gms.maps.model.CircleOptions;
import com.google.android.gms.maps.model.GroundOverlay;
import com.google.android.gms.maps.model.GroundOverlayOptions;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.Marker;
import com.google.android.gms.maps.model.MarkerOptions;
import com.google.android.gms.maps.model.Polygon;
import com.google.android.gms.maps.model.PolygonOptions;
import com.google.android.gms.maps.model.Polyline;
import com.google.android.gms.maps.model.PolylineOptions;
import com.google.android.gms.maps.model.RuntimeRemoteException;
import com.google.android.gms.maps.model.TileOverlay;
import com.google.android.gms.maps.model.TileOverlayOptions;
import com.google.android.gms.maps.model.internal.c;
import com.google.android.gms.maps.model.internal.d;
import com.google.android.gms.maps.model.internal.f;

/* loaded from: classes.dex */
public final class GoogleMap {
    public static final int MAP_TYPE_HYBRID = 4;
    public static final int MAP_TYPE_NONE = 0;
    public static final int MAP_TYPE_NORMAL = 1;
    public static final int MAP_TYPE_SATELLITE = 2;
    public static final int MAP_TYPE_TERRAIN = 3;
    private final IGoogleMapDelegate fX;
    private UiSettings fY;

    public interface CancelableCallback {
        void onCancel();

        void onFinish();
    }

    public interface InfoWindowAdapter {
        View getInfoContents(Marker marker);

        View getInfoWindow(Marker marker);
    }

    public interface OnCameraChangeListener {
        void onCameraChange(CameraPosition cameraPosition);
    }

    public interface OnInfoWindowClickListener {
        void onInfoWindowClick(Marker marker);
    }

    public interface OnMapClickListener {
        void onMapClick(LatLng latLng);
    }

    public interface OnMapLongClickListener {
        void onMapLongClick(LatLng latLng);
    }

    public interface OnMarkerClickListener {
        boolean onMarkerClick(Marker marker);
    }

    public interface OnMarkerDragListener {
        void onMarkerDrag(Marker marker);

        void onMarkerDragEnd(Marker marker);

        void onMarkerDragStart(Marker marker);
    }

    public interface OnMyLocationButtonClickListener {
        boolean onMyLocationButtonClick();
    }

    @Deprecated
    public interface OnMyLocationChangeListener {
        void onMyLocationChange(Location location);
    }

    public interface SnapshotReadyCallback {
        void onSnapshotReady(Bitmap bitmap);
    }

    private static final class a extends b.a {
        private final CancelableCallback gn;

        a(CancelableCallback cancelableCallback) {
            this.gn = cancelableCallback;
        }

        @Override // com.google.android.gms.maps.internal.b
        public void onCancel() {
            this.gn.onCancel();
        }

        @Override // com.google.android.gms.maps.internal.b
        public void onFinish() {
            this.gn.onFinish();
        }
    }

    protected GoogleMap(IGoogleMapDelegate map) {
        this.fX = (IGoogleMapDelegate) s.d(map);
    }

    IGoogleMapDelegate aY() {
        return this.fX;
    }

    public final Circle addCircle(CircleOptions options) {
        try {
            return new Circle(this.fX.addCircle(options));
        } catch (RemoteException e) {
            throw new RuntimeRemoteException(e);
        }
    }

    public final GroundOverlay addGroundOverlay(GroundOverlayOptions options) {
        try {
            c cVarAddGroundOverlay = this.fX.addGroundOverlay(options);
            if (cVarAddGroundOverlay != null) {
                return new GroundOverlay(cVarAddGroundOverlay);
            }
            return null;
        } catch (RemoteException e) {
            throw new RuntimeRemoteException(e);
        }
    }

    public final Marker addMarker(MarkerOptions options) {
        try {
            d dVarAddMarker = this.fX.addMarker(options);
            if (dVarAddMarker != null) {
                return new Marker(dVarAddMarker);
            }
            return null;
        } catch (RemoteException e) {
            throw new RuntimeRemoteException(e);
        }
    }

    public final Polygon addPolygon(PolygonOptions options) {
        try {
            return new Polygon(this.fX.addPolygon(options));
        } catch (RemoteException e) {
            throw new RuntimeRemoteException(e);
        }
    }

    public final Polyline addPolyline(PolylineOptions options) {
        try {
            return new Polyline(this.fX.addPolyline(options));
        } catch (RemoteException e) {
            throw new RuntimeRemoteException(e);
        }
    }

    public final TileOverlay addTileOverlay(TileOverlayOptions options) {
        try {
            f fVarAddTileOverlay = this.fX.addTileOverlay(options);
            if (fVarAddTileOverlay != null) {
                return new TileOverlay(fVarAddTileOverlay);
            }
            return null;
        } catch (RemoteException e) {
            throw new RuntimeRemoteException(e);
        }
    }

    public final void animateCamera(CameraUpdate update) {
        try {
            this.fX.animateCamera(update.aW());
        } catch (RemoteException e) {
            throw new RuntimeRemoteException(e);
        }
    }

    public final void animateCamera(CameraUpdate update, int durationMs, CancelableCallback callback) {
        try {
            this.fX.animateCameraWithDurationAndCallback(update.aW(), durationMs, callback == null ? null : new a(callback));
        } catch (RemoteException e) {
            throw new RuntimeRemoteException(e);
        }
    }

    public final void animateCamera(CameraUpdate update, CancelableCallback callback) {
        try {
            this.fX.animateCameraWithCallback(update.aW(), callback == null ? null : new a(callback));
        } catch (RemoteException e) {
            throw new RuntimeRemoteException(e);
        }
    }

    public final void clear() {
        try {
            this.fX.clear();
        } catch (RemoteException e) {
            throw new RuntimeRemoteException(e);
        }
    }

    public final CameraPosition getCameraPosition() {
        try {
            return this.fX.getCameraPosition();
        } catch (RemoteException e) {
            throw new RuntimeRemoteException(e);
        }
    }

    public final int getMapType() {
        try {
            return this.fX.getMapType();
        } catch (RemoteException e) {
            throw new RuntimeRemoteException(e);
        }
    }

    public final float getMaxZoomLevel() {
        try {
            return this.fX.getMaxZoomLevel();
        } catch (RemoteException e) {
            throw new RuntimeRemoteException(e);
        }
    }

    public final float getMinZoomLevel() {
        try {
            return this.fX.getMinZoomLevel();
        } catch (RemoteException e) {
            throw new RuntimeRemoteException(e);
        }
    }

    @Deprecated
    public final Location getMyLocation() {
        try {
            return this.fX.getMyLocation();
        } catch (RemoteException e) {
            throw new RuntimeRemoteException(e);
        }
    }

    public final Projection getProjection() {
        try {
            return new Projection(this.fX.getProjection());
        } catch (RemoteException e) {
            throw new RuntimeRemoteException(e);
        }
    }

    public final UiSettings getUiSettings() {
        try {
            if (this.fY == null) {
                this.fY = new UiSettings(this.fX.getUiSettings());
            }
            return this.fY;
        } catch (RemoteException e) {
            throw new RuntimeRemoteException(e);
        }
    }

    public final boolean isIndoorEnabled() {
        try {
            return this.fX.isIndoorEnabled();
        } catch (RemoteException e) {
            throw new RuntimeRemoteException(e);
        }
    }

    public final boolean isMyLocationEnabled() {
        try {
            return this.fX.isMyLocationEnabled();
        } catch (RemoteException e) {
            throw new RuntimeRemoteException(e);
        }
    }

    public final boolean isTrafficEnabled() {
        try {
            return this.fX.isTrafficEnabled();
        } catch (RemoteException e) {
            throw new RuntimeRemoteException(e);
        }
    }

    public final void moveCamera(CameraUpdate update) {
        try {
            this.fX.moveCamera(update.aW());
        } catch (RemoteException e) {
            throw new RuntimeRemoteException(e);
        }
    }

    public final boolean setIndoorEnabled(boolean enabled) {
        try {
            return this.fX.setIndoorEnabled(enabled);
        } catch (RemoteException e) {
            throw new RuntimeRemoteException(e);
        }
    }

    public final void setInfoWindowAdapter(final InfoWindowAdapter adapter) {
        try {
            if (adapter == null) {
                this.fX.setInfoWindowAdapter(null);
            } else {
                this.fX.setInfoWindowAdapter(new d.a() { // from class: com.google.android.gms.maps.GoogleMap.10
                    @Override // com.google.android.gms.maps.internal.d
                    public com.google.android.gms.dynamic.b f(com.google.android.gms.maps.model.internal.d dVar) {
                        return com.google.android.gms.dynamic.c.f(adapter.getInfoWindow(new Marker(dVar)));
                    }

                    @Override // com.google.android.gms.maps.internal.d
                    public com.google.android.gms.dynamic.b g(com.google.android.gms.maps.model.internal.d dVar) {
                        return com.google.android.gms.dynamic.c.f(adapter.getInfoContents(new Marker(dVar)));
                    }
                });
            }
        } catch (RemoteException e) {
            throw new RuntimeRemoteException(e);
        }
    }

    public final void setLocationSource(final LocationSource source) {
        try {
            if (source == null) {
                this.fX.setLocationSource(null);
            } else {
                this.fX.setLocationSource(new ILocationSourceDelegate.a() { // from class: com.google.android.gms.maps.GoogleMap.1
                    @Override // com.google.android.gms.maps.internal.ILocationSourceDelegate
                    public void activate(final g listener) {
                        source.activate(new LocationSource.OnLocationChangedListener() { // from class: com.google.android.gms.maps.GoogleMap.1.1
                            @Override // com.google.android.gms.maps.LocationSource.OnLocationChangedListener
                            public void onLocationChanged(Location location) {
                                try {
                                    listener.e(com.google.android.gms.dynamic.c.f(location));
                                } catch (RemoteException e) {
                                    throw new RuntimeRemoteException(e);
                                }
                            }
                        });
                    }

                    @Override // com.google.android.gms.maps.internal.ILocationSourceDelegate
                    public void deactivate() {
                        source.deactivate();
                    }
                });
            }
        } catch (RemoteException e) {
            throw new RuntimeRemoteException(e);
        }
    }

    public final void setMapType(int type) {
        try {
            this.fX.setMapType(type);
        } catch (RemoteException e) {
            throw new RuntimeRemoteException(e);
        }
    }

    public final void setMyLocationEnabled(boolean enabled) {
        try {
            this.fX.setMyLocationEnabled(enabled);
        } catch (RemoteException e) {
            throw new RuntimeRemoteException(e);
        }
    }

    public final void setOnCameraChangeListener(final OnCameraChangeListener listener) {
        try {
            if (listener == null) {
                this.fX.setOnCameraChangeListener(null);
            } else {
                this.fX.setOnCameraChangeListener(new e.a() { // from class: com.google.android.gms.maps.GoogleMap.4
                    @Override // com.google.android.gms.maps.internal.e
                    public void onCameraChange(CameraPosition position) {
                        listener.onCameraChange(position);
                    }
                });
            }
        } catch (RemoteException e) {
            throw new RuntimeRemoteException(e);
        }
    }

    public final void setOnInfoWindowClickListener(final OnInfoWindowClickListener listener) {
        try {
            if (listener == null) {
                this.fX.setOnInfoWindowClickListener(null);
            } else {
                this.fX.setOnInfoWindowClickListener(new f.a() { // from class: com.google.android.gms.maps.GoogleMap.9
                    @Override // com.google.android.gms.maps.internal.f
                    public void e(com.google.android.gms.maps.model.internal.d dVar) {
                        listener.onInfoWindowClick(new Marker(dVar));
                    }
                });
            }
        } catch (RemoteException e) {
            throw new RuntimeRemoteException(e);
        }
    }

    public final void setOnMapClickListener(final OnMapClickListener listener) {
        try {
            if (listener == null) {
                this.fX.setOnMapClickListener(null);
            } else {
                this.fX.setOnMapClickListener(new h.a() { // from class: com.google.android.gms.maps.GoogleMap.5
                    @Override // com.google.android.gms.maps.internal.h
                    public void onMapClick(LatLng point) {
                        listener.onMapClick(point);
                    }
                });
            }
        } catch (RemoteException e) {
            throw new RuntimeRemoteException(e);
        }
    }

    public final void setOnMapLongClickListener(final OnMapLongClickListener listener) {
        try {
            if (listener == null) {
                this.fX.setOnMapLongClickListener(null);
            } else {
                this.fX.setOnMapLongClickListener(new i.a() { // from class: com.google.android.gms.maps.GoogleMap.6
                    @Override // com.google.android.gms.maps.internal.i
                    public void onMapLongClick(LatLng point) {
                        listener.onMapLongClick(point);
                    }
                });
            }
        } catch (RemoteException e) {
            throw new RuntimeRemoteException(e);
        }
    }

    public final void setOnMarkerClickListener(final OnMarkerClickListener listener) {
        try {
            if (listener == null) {
                this.fX.setOnMarkerClickListener(null);
            } else {
                this.fX.setOnMarkerClickListener(new j.a() { // from class: com.google.android.gms.maps.GoogleMap.7
                    @Override // com.google.android.gms.maps.internal.j
                    public boolean a(com.google.android.gms.maps.model.internal.d dVar) {
                        return listener.onMarkerClick(new Marker(dVar));
                    }
                });
            }
        } catch (RemoteException e) {
            throw new RuntimeRemoteException(e);
        }
    }

    public final void setOnMarkerDragListener(final OnMarkerDragListener listener) {
        try {
            if (listener == null) {
                this.fX.setOnMarkerDragListener(null);
            } else {
                this.fX.setOnMarkerDragListener(new k.a() { // from class: com.google.android.gms.maps.GoogleMap.8
                    @Override // com.google.android.gms.maps.internal.k
                    public void b(com.google.android.gms.maps.model.internal.d dVar) {
                        listener.onMarkerDragStart(new Marker(dVar));
                    }

                    @Override // com.google.android.gms.maps.internal.k
                    public void c(com.google.android.gms.maps.model.internal.d dVar) {
                        listener.onMarkerDragEnd(new Marker(dVar));
                    }

                    @Override // com.google.android.gms.maps.internal.k
                    public void d(com.google.android.gms.maps.model.internal.d dVar) {
                        listener.onMarkerDrag(new Marker(dVar));
                    }
                });
            }
        } catch (RemoteException e) {
            throw new RuntimeRemoteException(e);
        }
    }

    public final void setOnMyLocationButtonClickListener(final OnMyLocationButtonClickListener listener) {
        try {
            if (listener == null) {
                this.fX.setOnMyLocationButtonClickListener(null);
            } else {
                this.fX.setOnMyLocationButtonClickListener(new l.a() { // from class: com.google.android.gms.maps.GoogleMap.2
                    @Override // com.google.android.gms.maps.internal.l
                    public boolean onMyLocationButtonClick() throws RemoteException {
                        return listener.onMyLocationButtonClick();
                    }
                });
            }
        } catch (RemoteException e) {
            throw new RuntimeRemoteException(e);
        }
    }

    @Deprecated
    public final void setOnMyLocationChangeListener(final OnMyLocationChangeListener listener) {
        try {
            if (listener == null) {
                this.fX.setOnMyLocationChangeListener(null);
            } else {
                this.fX.setOnMyLocationChangeListener(new m.a() { // from class: com.google.android.gms.maps.GoogleMap.11
                    @Override // com.google.android.gms.maps.internal.m
                    public void b(com.google.android.gms.dynamic.b bVar) {
                        listener.onMyLocationChange((Location) com.google.android.gms.dynamic.c.a(bVar));
                    }
                });
            }
        } catch (RemoteException e) {
            throw new RuntimeRemoteException(e);
        }
    }

    public final void setPadding(int left, int top, int right, int bottom) {
        try {
            this.fX.setPadding(left, top, right, bottom);
        } catch (RemoteException e) {
            throw new RuntimeRemoteException(e);
        }
    }

    public final void setTrafficEnabled(boolean enabled) {
        try {
            this.fX.setTrafficEnabled(enabled);
        } catch (RemoteException e) {
            throw new RuntimeRemoteException(e);
        }
    }

    public final void snapshot(SnapshotReadyCallback callback) {
        snapshot(callback, null);
    }

    public final void snapshot(final SnapshotReadyCallback callback, Bitmap bitmap) {
        try {
            this.fX.snapshot(new n.a() { // from class: com.google.android.gms.maps.GoogleMap.3
                @Override // com.google.android.gms.maps.internal.n
                public void onSnapshotReady(Bitmap snapshot) throws RemoteException {
                    callback.onSnapshotReady(snapshot);
                }
            }, (com.google.android.gms.dynamic.c) (bitmap != null ? com.google.android.gms.dynamic.c.f(bitmap) : null));
        } catch (RemoteException e) {
            throw new RuntimeRemoteException(e);
        }
    }

    public final void stopAnimation() {
        try {
            this.fX.stopAnimation();
        } catch (RemoteException e) {
            throw new RuntimeRemoteException(e);
        }
    }
}
