package com.google.android.gms.maps.model;

import android.os.Parcel;
import com.google.android.gms.common.internal.safeparcel.SafeParcelable;
import com.google.android.gms.maps.internal.q;

/* loaded from: classes.dex */
public final class Tile implements SafeParcelable {
    public static final TileCreator CREATOR = new TileCreator();
    private final int ab;
    public final byte[] data;
    public final int height;
    public final int width;

    Tile(int versionCode, int width, int height, byte[] data) {
        this.ab = versionCode;
        this.width = width;
        this.height = height;
        this.data = data;
    }

    public Tile(int width, int height, byte[] data) {
        this(1, width, height, data);
    }

    @Override // android.os.Parcelable
    public int describeContents() {
        return 0;
    }

    int i() {
        return this.ab;
    }

    @Override // android.os.Parcelable
    public void writeToParcel(Parcel out, int flags) {
        if (q.bn()) {
            i.a(this, out, flags);
        } else {
            TileCreator.a(this, out, flags);
        }
    }
}
