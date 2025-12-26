package com.google.android.gms.maps.model;

import android.content.Context;
import android.content.res.TypedArray;
import android.os.Parcel;
import android.util.AttributeSet;
import com.google.android.gms.R;
import com.google.android.gms.common.internal.safeparcel.SafeParcelable;
import com.google.android.gms.internal.r;
import com.google.android.gms.internal.s;
import com.google.android.gms.maps.internal.q;

/* loaded from: classes.dex */
public final class CameraPosition implements SafeParcelable {
    public static final CameraPositionCreator CREATOR = new CameraPositionCreator();
    private final int ab;
    public final float bearing;
    public final LatLng target;
    public final float tilt;
    public final float zoom;

    public static final class Builder {
        private LatLng gR;
        private float gS;
        private float gT;
        private float gU;

        public Builder() {
        }

        public Builder(CameraPosition previous) {
            this.gR = previous.target;
            this.gS = previous.zoom;
            this.gT = previous.tilt;
            this.gU = previous.bearing;
        }

        public Builder bearing(float bearing) {
            this.gU = bearing;
            return this;
        }

        public CameraPosition build() {
            return new CameraPosition(this.gR, this.gS, this.gT, this.gU);
        }

        public Builder target(LatLng location) {
            this.gR = location;
            return this;
        }

        public Builder tilt(float tilt) {
            this.gT = tilt;
            return this;
        }

        public Builder zoom(float zoom) {
            this.gS = zoom;
            return this;
        }
    }

    CameraPosition(int versionCode, LatLng target, float zoom, float tilt, float bearing) {
        s.b(target, "null camera target");
        s.b(0.0f <= tilt && tilt <= 90.0f, "Tilt needs to be between 0 and 90 inclusive");
        this.ab = versionCode;
        this.target = target;
        this.zoom = zoom;
        this.tilt = tilt + 0.0f;
        this.bearing = (((double) bearing) <= 0.0d ? (bearing % 360.0f) + 360.0f : bearing) % 360.0f;
    }

    public CameraPosition(LatLng target, float zoom, float tilt, float bearing) {
        this(1, target, zoom, tilt, bearing);
    }

    public static Builder builder() {
        return new Builder();
    }

    public static Builder builder(CameraPosition camera) {
        return new Builder(camera);
    }

    public static CameraPosition createFromAttributes(Context context, AttributeSet attrs) {
        if (attrs == null) {
            return null;
        }
        TypedArray typedArrayObtainAttributes = context.getResources().obtainAttributes(attrs, R.styleable.MapAttrs);
        LatLng latLng = new LatLng(typedArrayObtainAttributes.hasValue(2) ? typedArrayObtainAttributes.getFloat(2, 0.0f) : 0.0f, typedArrayObtainAttributes.hasValue(3) ? typedArrayObtainAttributes.getFloat(3, 0.0f) : 0.0f);
        Builder builder = builder();
        builder.target(latLng);
        if (typedArrayObtainAttributes.hasValue(5)) {
            builder.zoom(typedArrayObtainAttributes.getFloat(5, 0.0f));
        }
        if (typedArrayObtainAttributes.hasValue(1)) {
            builder.bearing(typedArrayObtainAttributes.getFloat(1, 0.0f));
        }
        if (typedArrayObtainAttributes.hasValue(4)) {
            builder.tilt(typedArrayObtainAttributes.getFloat(4, 0.0f));
        }
        return builder.build();
    }

    public static final CameraPosition fromLatLngZoom(LatLng target, float zoom) {
        return new CameraPosition(target, zoom, 0.0f, 0.0f);
    }

    @Override // android.os.Parcelable
    public int describeContents() {
        return 0;
    }

    public boolean equals(Object o) {
        if (this == o) {
            return true;
        }
        if (!(o instanceof CameraPosition)) {
            return false;
        }
        CameraPosition cameraPosition = (CameraPosition) o;
        return this.target.equals(cameraPosition.target) && Float.floatToIntBits(this.zoom) == Float.floatToIntBits(cameraPosition.zoom) && Float.floatToIntBits(this.tilt) == Float.floatToIntBits(cameraPosition.tilt) && Float.floatToIntBits(this.bearing) == Float.floatToIntBits(cameraPosition.bearing);
    }

    public int hashCode() {
        return r.hashCode(this.target, Float.valueOf(this.zoom), Float.valueOf(this.tilt), Float.valueOf(this.bearing));
    }

    int i() {
        return this.ab;
    }

    public String toString() {
        return r.c(this).a("target", this.target).a("zoom", Float.valueOf(this.zoom)).a("tilt", Float.valueOf(this.tilt)).a("bearing", Float.valueOf(this.bearing)).toString();
    }

    @Override // android.os.Parcelable
    public void writeToParcel(Parcel out, int flags) {
        if (q.bn()) {
            a.a(this, out, flags);
        } else {
            CameraPositionCreator.a(this, out, flags);
        }
    }
}
