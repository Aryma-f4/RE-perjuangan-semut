package com.google.android.gms.maps.model;

import android.os.Parcel;
import android.support.v4.view.ViewCompat;
import com.google.android.gms.common.internal.safeparcel.SafeParcelable;
import com.google.android.gms.maps.internal.q;

/* loaded from: classes.dex */
public final class CircleOptions implements SafeParcelable {
    public static final CircleOptionsCreator CREATOR = new CircleOptionsCreator();
    private final int ab;
    private LatLng gW;
    private double gX;
    private float gY;
    private int gZ;
    private int ha;
    private float hb;
    private boolean hc;

    public CircleOptions() {
        this.gW = null;
        this.gX = 0.0d;
        this.gY = 10.0f;
        this.gZ = ViewCompat.MEASURED_STATE_MASK;
        this.ha = 0;
        this.hb = 0.0f;
        this.hc = true;
        this.ab = 1;
    }

    CircleOptions(int versionCode, LatLng center, double radius, float strokeWidth, int strokeColor, int fillColor, float zIndex, boolean visible) {
        this.gW = null;
        this.gX = 0.0d;
        this.gY = 10.0f;
        this.gZ = ViewCompat.MEASURED_STATE_MASK;
        this.ha = 0;
        this.hb = 0.0f;
        this.hc = true;
        this.ab = versionCode;
        this.gW = center;
        this.gX = radius;
        this.gY = strokeWidth;
        this.gZ = strokeColor;
        this.ha = fillColor;
        this.hb = zIndex;
        this.hc = visible;
    }

    public CircleOptions center(LatLng center) {
        this.gW = center;
        return this;
    }

    @Override // android.os.Parcelable
    public int describeContents() {
        return 0;
    }

    public CircleOptions fillColor(int color) {
        this.ha = color;
        return this;
    }

    public LatLng getCenter() {
        return this.gW;
    }

    public int getFillColor() {
        return this.ha;
    }

    public double getRadius() {
        return this.gX;
    }

    public int getStrokeColor() {
        return this.gZ;
    }

    public float getStrokeWidth() {
        return this.gY;
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

    public CircleOptions radius(double radius) {
        this.gX = radius;
        return this;
    }

    public CircleOptions strokeColor(int color) {
        this.gZ = color;
        return this;
    }

    public CircleOptions strokeWidth(float width) {
        this.gY = width;
        return this;
    }

    public CircleOptions visible(boolean visible) {
        this.hc = visible;
        return this;
    }

    @Override // android.os.Parcelable
    public void writeToParcel(Parcel out, int flags) {
        if (q.bn()) {
            b.a(this, out, flags);
        } else {
            CircleOptionsCreator.a(this, out, flags);
        }
    }

    public CircleOptions zIndex(float zIndex) {
        this.hb = zIndex;
        return this;
    }
}
