package com.google.android.gms.maps.model;

import android.os.Parcel;
import android.support.v4.view.ViewCompat;
import com.google.android.gms.common.internal.safeparcel.SafeParcelable;
import com.google.android.gms.maps.internal.q;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Iterator;
import java.util.List;

/* loaded from: classes.dex */
public final class PolygonOptions implements SafeParcelable {
    public static final PolygonOptionsCreator CREATOR = new PolygonOptionsCreator();
    private final int ab;
    private float gY;
    private int gZ;
    private final List<LatLng> hB;
    private final List<List<LatLng>> hC;
    private boolean hD;
    private int ha;
    private float hb;
    private boolean hc;

    public PolygonOptions() {
        this.gY = 10.0f;
        this.gZ = ViewCompat.MEASURED_STATE_MASK;
        this.ha = 0;
        this.hb = 0.0f;
        this.hc = true;
        this.hD = false;
        this.ab = 1;
        this.hB = new ArrayList();
        this.hC = new ArrayList();
    }

    PolygonOptions(int versionCode, List<LatLng> points, List holes, float strokeWidth, int strokeColor, int fillColor, float zIndex, boolean visible, boolean geodesic) {
        this.gY = 10.0f;
        this.gZ = ViewCompat.MEASURED_STATE_MASK;
        this.ha = 0;
        this.hb = 0.0f;
        this.hc = true;
        this.hD = false;
        this.ab = versionCode;
        this.hB = points;
        this.hC = holes;
        this.gY = strokeWidth;
        this.gZ = strokeColor;
        this.ha = fillColor;
        this.hb = zIndex;
        this.hc = visible;
        this.hD = geodesic;
    }

    public PolygonOptions add(LatLng point) {
        this.hB.add(point);
        return this;
    }

    public PolygonOptions add(LatLng... points) {
        this.hB.addAll(Arrays.asList(points));
        return this;
    }

    public PolygonOptions addAll(Iterable<LatLng> points) {
        Iterator<LatLng> it = points.iterator();
        while (it.hasNext()) {
            this.hB.add(it.next());
        }
        return this;
    }

    public PolygonOptions addHole(Iterable<LatLng> points) {
        ArrayList arrayList = new ArrayList();
        Iterator<LatLng> it = points.iterator();
        while (it.hasNext()) {
            arrayList.add(it.next());
        }
        this.hC.add(arrayList);
        return this;
    }

    List br() {
        return this.hC;
    }

    @Override // android.os.Parcelable
    public int describeContents() {
        return 0;
    }

    public PolygonOptions fillColor(int color) {
        this.ha = color;
        return this;
    }

    public PolygonOptions geodesic(boolean geodesic) {
        this.hD = geodesic;
        return this;
    }

    public int getFillColor() {
        return this.ha;
    }

    public List<List<LatLng>> getHoles() {
        return this.hC;
    }

    public List<LatLng> getPoints() {
        return this.hB;
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

    public boolean isGeodesic() {
        return this.hD;
    }

    public boolean isVisible() {
        return this.hc;
    }

    public PolygonOptions strokeColor(int color) {
        this.gZ = color;
        return this;
    }

    public PolygonOptions strokeWidth(float width) {
        this.gY = width;
        return this;
    }

    public PolygonOptions visible(boolean visible) {
        this.hc = visible;
        return this;
    }

    @Override // android.os.Parcelable
    public void writeToParcel(Parcel out, int flags) {
        if (q.bn()) {
            g.a(this, out, flags);
        } else {
            PolygonOptionsCreator.a(this, out, flags);
        }
    }

    public PolygonOptions zIndex(float zIndex) {
        this.hb = zIndex;
        return this;
    }
}
