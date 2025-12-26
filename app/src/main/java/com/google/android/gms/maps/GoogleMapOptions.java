package com.google.android.gms.maps;

import android.content.Context;
import android.content.res.TypedArray;
import android.os.Parcel;
import android.util.AttributeSet;
import com.google.android.gms.R;
import com.google.android.gms.common.internal.safeparcel.SafeParcelable;
import com.google.android.gms.maps.internal.q;
import com.google.android.gms.maps.model.CameraPosition;

/* loaded from: classes.dex */
public final class GoogleMapOptions implements SafeParcelable {
    public static final GoogleMapOptionsCreator CREATOR = new GoogleMapOptionsCreator();
    private final int ab;
    private Boolean go;
    private Boolean gp;
    private int gq;
    private CameraPosition gr;
    private Boolean gs;
    private Boolean gt;
    private Boolean gu;
    private Boolean gv;
    private Boolean gw;
    private Boolean gx;

    public GoogleMapOptions() {
        this.gq = -1;
        this.ab = 1;
    }

    GoogleMapOptions(int versionCode, byte zOrderOnTop, byte useViewLifecycleInFragment, int mapType, CameraPosition camera, byte zoomControlsEnabled, byte compassEnabled, byte scrollGesturesEnabled, byte zoomGesturesEnabled, byte tiltGesturesEnabled, byte rotateGesturesEnabled) {
        this.gq = -1;
        this.ab = versionCode;
        this.go = com.google.android.gms.maps.internal.a.a(zOrderOnTop);
        this.gp = com.google.android.gms.maps.internal.a.a(useViewLifecycleInFragment);
        this.gq = mapType;
        this.gr = camera;
        this.gs = com.google.android.gms.maps.internal.a.a(zoomControlsEnabled);
        this.gt = com.google.android.gms.maps.internal.a.a(compassEnabled);
        this.gu = com.google.android.gms.maps.internal.a.a(scrollGesturesEnabled);
        this.gv = com.google.android.gms.maps.internal.a.a(zoomGesturesEnabled);
        this.gw = com.google.android.gms.maps.internal.a.a(tiltGesturesEnabled);
        this.gx = com.google.android.gms.maps.internal.a.a(rotateGesturesEnabled);
    }

    public static GoogleMapOptions createFromAttributes(Context context, AttributeSet attrs) {
        if (attrs == null) {
            return null;
        }
        TypedArray typedArrayObtainAttributes = context.getResources().obtainAttributes(attrs, R.styleable.MapAttrs);
        GoogleMapOptions googleMapOptions = new GoogleMapOptions();
        if (typedArrayObtainAttributes.hasValue(0)) {
            googleMapOptions.mapType(typedArrayObtainAttributes.getInt(0, -1));
        }
        if (typedArrayObtainAttributes.hasValue(13)) {
            googleMapOptions.zOrderOnTop(typedArrayObtainAttributes.getBoolean(13, false));
        }
        if (typedArrayObtainAttributes.hasValue(12)) {
            googleMapOptions.useViewLifecycleInFragment(typedArrayObtainAttributes.getBoolean(12, false));
        }
        if (typedArrayObtainAttributes.hasValue(6)) {
            googleMapOptions.compassEnabled(typedArrayObtainAttributes.getBoolean(6, true));
        }
        if (typedArrayObtainAttributes.hasValue(7)) {
            googleMapOptions.rotateGesturesEnabled(typedArrayObtainAttributes.getBoolean(7, true));
        }
        if (typedArrayObtainAttributes.hasValue(8)) {
            googleMapOptions.scrollGesturesEnabled(typedArrayObtainAttributes.getBoolean(8, true));
        }
        if (typedArrayObtainAttributes.hasValue(9)) {
            googleMapOptions.tiltGesturesEnabled(typedArrayObtainAttributes.getBoolean(9, true));
        }
        if (typedArrayObtainAttributes.hasValue(11)) {
            googleMapOptions.zoomGesturesEnabled(typedArrayObtainAttributes.getBoolean(11, true));
        }
        if (typedArrayObtainAttributes.hasValue(10)) {
            googleMapOptions.zoomControlsEnabled(typedArrayObtainAttributes.getBoolean(10, true));
        }
        googleMapOptions.camera(CameraPosition.createFromAttributes(context, attrs));
        typedArrayObtainAttributes.recycle();
        return googleMapOptions;
    }

    byte aZ() {
        return com.google.android.gms.maps.internal.a.b(this.go);
    }

    byte ba() {
        return com.google.android.gms.maps.internal.a.b(this.gp);
    }

    byte bb() {
        return com.google.android.gms.maps.internal.a.b(this.gs);
    }

    byte bc() {
        return com.google.android.gms.maps.internal.a.b(this.gt);
    }

    byte bd() {
        return com.google.android.gms.maps.internal.a.b(this.gu);
    }

    byte be() {
        return com.google.android.gms.maps.internal.a.b(this.gv);
    }

    byte bf() {
        return com.google.android.gms.maps.internal.a.b(this.gw);
    }

    byte bg() {
        return com.google.android.gms.maps.internal.a.b(this.gx);
    }

    public GoogleMapOptions camera(CameraPosition camera) {
        this.gr = camera;
        return this;
    }

    public GoogleMapOptions compassEnabled(boolean enabled) {
        this.gt = Boolean.valueOf(enabled);
        return this;
    }

    @Override // android.os.Parcelable
    public int describeContents() {
        return 0;
    }

    public CameraPosition getCamera() {
        return this.gr;
    }

    public Boolean getCompassEnabled() {
        return this.gt;
    }

    public int getMapType() {
        return this.gq;
    }

    public Boolean getRotateGesturesEnabled() {
        return this.gx;
    }

    public Boolean getScrollGesturesEnabled() {
        return this.gu;
    }

    public Boolean getTiltGesturesEnabled() {
        return this.gw;
    }

    public Boolean getUseViewLifecycleInFragment() {
        return this.gp;
    }

    public Boolean getZOrderOnTop() {
        return this.go;
    }

    public Boolean getZoomControlsEnabled() {
        return this.gs;
    }

    public Boolean getZoomGesturesEnabled() {
        return this.gv;
    }

    int i() {
        return this.ab;
    }

    public GoogleMapOptions mapType(int mapType) {
        this.gq = mapType;
        return this;
    }

    public GoogleMapOptions rotateGesturesEnabled(boolean enabled) {
        this.gx = Boolean.valueOf(enabled);
        return this;
    }

    public GoogleMapOptions scrollGesturesEnabled(boolean enabled) {
        this.gu = Boolean.valueOf(enabled);
        return this;
    }

    public GoogleMapOptions tiltGesturesEnabled(boolean enabled) {
        this.gw = Boolean.valueOf(enabled);
        return this;
    }

    public GoogleMapOptions useViewLifecycleInFragment(boolean useViewLifecycleInFragment) {
        this.gp = Boolean.valueOf(useViewLifecycleInFragment);
        return this;
    }

    @Override // android.os.Parcelable
    public void writeToParcel(Parcel out, int flags) {
        if (q.bn()) {
            a.a(this, out, flags);
        } else {
            GoogleMapOptionsCreator.a(this, out, flags);
        }
    }

    public GoogleMapOptions zOrderOnTop(boolean zOrderOnTop) {
        this.go = Boolean.valueOf(zOrderOnTop);
        return this;
    }

    public GoogleMapOptions zoomControlsEnabled(boolean enabled) {
        this.gs = Boolean.valueOf(enabled);
        return this;
    }

    public GoogleMapOptions zoomGesturesEnabled(boolean enabled) {
        this.gv = Boolean.valueOf(enabled);
        return this;
    }
}
