package com.google.android.gms.maps.model;

import android.os.Parcel;
import com.google.android.gms.common.internal.safeparcel.SafeParcelable;
import com.google.android.gms.internal.r;
import com.google.android.gms.internal.s;
import com.google.android.gms.maps.internal.q;

/* loaded from: classes.dex */
public final class LatLngBounds implements SafeParcelable {
    public static final LatLngBoundsCreator CREATOR = new LatLngBoundsCreator();
    private final int ab;
    public final LatLng northeast;
    public final LatLng southwest;

    public static final class Builder {
        private double hm = Double.POSITIVE_INFINITY;
        private double hn = Double.NEGATIVE_INFINITY;
        private double ho = Double.NaN;
        private double hp = Double.NaN;

        private boolean b(double d) {
            return this.ho <= this.hp ? this.ho <= d && d <= this.hp : this.ho <= d || d <= this.hp;
        }

        public LatLngBounds build() {
            s.a(!Double.isNaN(this.ho), "no included points");
            return new LatLngBounds(new LatLng(this.hm, this.ho), new LatLng(this.hn, this.hp));
        }

        public Builder include(LatLng point) {
            this.hm = Math.min(this.hm, point.latitude);
            this.hn = Math.max(this.hn, point.latitude);
            double d = point.longitude;
            if (Double.isNaN(this.ho)) {
                this.ho = d;
                this.hp = d;
            } else if (!b(d)) {
                if (LatLngBounds.b(this.ho, d) < LatLngBounds.c(this.hp, d)) {
                    this.ho = d;
                } else {
                    this.hp = d;
                }
            }
            return this;
        }
    }

    LatLngBounds(int versionCode, LatLng southwest, LatLng northeast) {
        s.b(southwest, "null southwest");
        s.b(northeast, "null northeast");
        s.a(northeast.latitude >= southwest.latitude, "southern latitude exceeds northern latitude (%s > %s)", Double.valueOf(southwest.latitude), Double.valueOf(northeast.latitude));
        this.ab = versionCode;
        this.southwest = southwest;
        this.northeast = northeast;
    }

    public LatLngBounds(LatLng southwest, LatLng northeast) {
        this(1, southwest, northeast);
    }

    private boolean a(double d) {
        return this.southwest.latitude <= d && d <= this.northeast.latitude;
    }

    /* JADX INFO: Access modifiers changed from: private */
    public static double b(double d, double d2) {
        return ((d - d2) + 360.0d) % 360.0d;
    }

    private boolean b(double d) {
        return this.southwest.longitude <= this.northeast.longitude ? this.southwest.longitude <= d && d <= this.northeast.longitude : this.southwest.longitude <= d || d <= this.northeast.longitude;
    }

    public static Builder builder() {
        return new Builder();
    }

    /* JADX INFO: Access modifiers changed from: private */
    public static double c(double d, double d2) {
        return ((d2 - d) + 360.0d) % 360.0d;
    }

    public boolean contains(LatLng point) {
        return a(point.latitude) && b(point.longitude);
    }

    @Override // android.os.Parcelable
    public int describeContents() {
        return 0;
    }

    public boolean equals(Object o) {
        if (this == o) {
            return true;
        }
        if (!(o instanceof LatLngBounds)) {
            return false;
        }
        LatLngBounds latLngBounds = (LatLngBounds) o;
        return this.southwest.equals(latLngBounds.southwest) && this.northeast.equals(latLngBounds.northeast);
    }

    public LatLng getCenter() {
        double d = (this.southwest.latitude + this.northeast.latitude) / 2.0d;
        double d2 = this.northeast.longitude;
        double d3 = this.southwest.longitude;
        return new LatLng(d, d3 <= d2 ? (d2 + d3) / 2.0d : ((d2 + 360.0d) + d3) / 2.0d);
    }

    public int hashCode() {
        return r.hashCode(this.southwest, this.northeast);
    }

    int i() {
        return this.ab;
    }

    public LatLngBounds including(LatLng point) {
        double d;
        double d2;
        double dMin = Math.min(this.southwest.latitude, point.latitude);
        double dMax = Math.max(this.northeast.latitude, point.latitude);
        double d3 = this.northeast.longitude;
        double d4 = this.southwest.longitude;
        double d5 = point.longitude;
        if (b(d5)) {
            d = d3;
            d2 = d4;
        } else if (b(d4, d5) < c(d3, d5)) {
            d = d3;
            d2 = d5;
        } else {
            d2 = d4;
            d = d5;
        }
        return new LatLngBounds(new LatLng(dMin, d2), new LatLng(dMax, d));
    }

    public String toString() {
        return r.c(this).a("southwest", this.southwest).a("northeast", this.northeast).toString();
    }

    @Override // android.os.Parcelable
    public void writeToParcel(Parcel out, int flags) {
        if (q.bn()) {
            d.a(this, out, flags);
        } else {
            LatLngBoundsCreator.a(this, out, flags);
        }
    }
}
