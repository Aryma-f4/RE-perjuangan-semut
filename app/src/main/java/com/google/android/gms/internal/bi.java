package com.google.android.gms.internal;

import android.os.Parcel;
import com.google.android.gms.common.internal.safeparcel.SafeParcelable;
import com.google.android.gms.location.Geofence;

/* loaded from: classes.dex */
public class bi implements SafeParcelable, Geofence {
    public static final bj CREATOR = new bj();
    private final int ab;
    private final float fA;
    private final long fU;
    private final String fu;
    private final int fv;
    private final short fx;
    private final double fy;
    private final double fz;

    public bi(int i, String str, int i2, short s, double d, double d2, float f, long j) {
        A(str);
        b(f);
        a(d, d2);
        int iP = P(i2);
        this.ab = i;
        this.fx = s;
        this.fu = str;
        this.fy = d;
        this.fz = d2;
        this.fA = f;
        this.fU = j;
        this.fv = iP;
    }

    public bi(String str, int i, short s, double d, double d2, float f, long j) {
        this(1, str, i, s, d, d2, f, j);
    }

    private static void A(String str) {
        if (str == null || str.length() > 100) {
            throw new IllegalArgumentException("requestId is null or too long: " + str);
        }
    }

    private static int P(int i) {
        int i2 = i & 3;
        if (i2 == 0) {
            throw new IllegalArgumentException("No supported transition specified: " + i);
        }
        return i2;
    }

    private static String Q(int i) {
        switch (i) {
            case 1:
                return "CIRCLE";
            default:
                return null;
        }
    }

    private static void a(double d, double d2) {
        if (d > 90.0d || d < -90.0d) {
            throw new IllegalArgumentException("invalid latitude: " + d);
        }
        if (d2 > 180.0d || d2 < -180.0d) {
            throw new IllegalArgumentException("invalid longitude: " + d2);
        }
    }

    private static void b(float f) {
        if (f <= 0.0f) {
            throw new IllegalArgumentException("invalid radius: " + f);
        }
    }

    public static bi c(byte[] bArr) {
        Parcel parcelObtain = Parcel.obtain();
        parcelObtain.unmarshall(bArr, 0, bArr.length);
        parcelObtain.setDataPosition(0);
        bi biVarCreateFromParcel = CREATOR.createFromParcel(parcelObtain);
        parcelObtain.recycle();
        return biVarCreateFromParcel;
    }

    public short aT() {
        return this.fx;
    }

    public float aU() {
        return this.fA;
    }

    public int aV() {
        return this.fv;
    }

    @Override // android.os.Parcelable
    public int describeContents() {
        bj bjVar = CREATOR;
        return 0;
    }

    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (obj != null && (obj instanceof bi)) {
            bi biVar = (bi) obj;
            if (this.fA == biVar.fA && this.fy == biVar.fy && this.fz == biVar.fz && this.fx == biVar.fx) {
                return true;
            }
            return false;
        }
        return false;
    }

    public long getExpirationTime() {
        return this.fU;
    }

    public double getLatitude() {
        return this.fy;
    }

    public double getLongitude() {
        return this.fz;
    }

    @Override // com.google.android.gms.location.Geofence
    public String getRequestId() {
        return this.fu;
    }

    public int hashCode() {
        long jDoubleToLongBits = Double.doubleToLongBits(this.fy);
        int i = 1 * 31;
        int i2 = ((int) (jDoubleToLongBits ^ (jDoubleToLongBits >>> 32))) + 31;
        long jDoubleToLongBits2 = Double.doubleToLongBits(this.fz);
        return (((((((i2 * 31) + ((int) (jDoubleToLongBits2 ^ (jDoubleToLongBits2 >>> 32)))) * 31) + Float.floatToIntBits(this.fA)) * 31) + this.fx) * 31) + this.fv;
    }

    public int i() {
        return this.ab;
    }

    public String toString() {
        return String.format("Geofence[%s id:%s transitions:%d %.6f, %.6f %.0fm, @%d]", Q(this.fx), this.fu, Integer.valueOf(this.fv), Double.valueOf(this.fy), Double.valueOf(this.fz), Float.valueOf(this.fA), Long.valueOf(this.fU));
    }

    @Override // android.os.Parcelable
    public void writeToParcel(Parcel parcel, int flags) {
        bj bjVar = CREATOR;
        bj.a(this, parcel, flags);
    }
}
