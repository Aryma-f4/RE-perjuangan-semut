package com.google.android.gms.location;

import android.os.Parcel;
import android.os.SystemClock;
import com.google.android.gms.common.internal.safeparcel.SafeParcelable;
import com.google.android.gms.internal.r;

/* loaded from: classes.dex */
public final class LocationRequest implements SafeParcelable {
    public static final LocationRequestCreator CREATOR = new LocationRequestCreator();
    public static final int PRIORITY_BALANCED_POWER_ACCURACY = 102;
    public static final int PRIORITY_HIGH_ACCURACY = 100;
    public static final int PRIORITY_LOW_POWER = 104;
    public static final int PRIORITY_NO_POWER = 105;
    private final int ab;
    long fB;
    long fC;
    boolean fD;
    int fE;
    float fF;
    long fw;
    int mPriority;

    public LocationRequest() {
        this.ab = 1;
        this.mPriority = PRIORITY_BALANCED_POWER_ACCURACY;
        this.fB = 3600000L;
        this.fC = 600000L;
        this.fD = false;
        this.fw = Long.MAX_VALUE;
        this.fE = Integer.MAX_VALUE;
        this.fF = 0.0f;
    }

    LocationRequest(int versionCode, int priority, long interval, long fastestInterval, boolean explicitFastestInterval, long expireAt, int numUpdates, float smallestDisplacement) {
        this.ab = versionCode;
        this.mPriority = priority;
        this.fB = interval;
        this.fC = fastestInterval;
        this.fD = explicitFastestInterval;
        this.fw = expireAt;
        this.fE = numUpdates;
        this.fF = smallestDisplacement;
    }

    private static void M(int i) {
        switch (i) {
            case 100:
            case PRIORITY_BALANCED_POWER_ACCURACY /* 102 */:
            case PRIORITY_LOW_POWER /* 104 */:
            case PRIORITY_NO_POWER /* 105 */:
                return;
            case 101:
            case 103:
            default:
                throw new IllegalArgumentException("invalid quality: " + i);
        }
    }

    public static String N(int i) {
        switch (i) {
            case 100:
                return "PRIORITY_HIGH_ACCURACY";
            case 101:
            case 103:
            default:
                return "???";
            case PRIORITY_BALANCED_POWER_ACCURACY /* 102 */:
                return "PRIORITY_BALANCED_POWER_ACCURACY";
            case PRIORITY_LOW_POWER /* 104 */:
                return "PRIORITY_LOW_POWER";
            case PRIORITY_NO_POWER /* 105 */:
                return "PRIORITY_NO_POWER";
        }
    }

    private static void a(float f) {
        if (f < 0.0f) {
            throw new IllegalArgumentException("invalid displacement: " + f);
        }
    }

    private static void c(long j) {
        if (j < 0) {
            throw new IllegalArgumentException("invalid interval: " + j);
        }
    }

    public static LocationRequest create() {
        return new LocationRequest();
    }

    @Override // android.os.Parcelable
    public int describeContents() {
        return 0;
    }

    public boolean equals(Object object) {
        if (this == object) {
            return true;
        }
        if (!(object instanceof LocationRequest)) {
            return false;
        }
        LocationRequest locationRequest = (LocationRequest) object;
        return this.mPriority == locationRequest.mPriority && this.fB == locationRequest.fB && this.fC == locationRequest.fC && this.fD == locationRequest.fD && this.fw == locationRequest.fw && this.fE == locationRequest.fE && this.fF == locationRequest.fF;
    }

    public long getExpirationTime() {
        return this.fw;
    }

    public long getFastestInterval() {
        return this.fC;
    }

    public long getInterval() {
        return this.fB;
    }

    public int getNumUpdates() {
        return this.fE;
    }

    public int getPriority() {
        return this.mPriority;
    }

    public float getSmallestDisplacement() {
        return this.fF;
    }

    public int hashCode() {
        return r.hashCode(Integer.valueOf(this.mPriority), Long.valueOf(this.fB), Long.valueOf(this.fC), Boolean.valueOf(this.fD), Long.valueOf(this.fw), Integer.valueOf(this.fE), Float.valueOf(this.fF));
    }

    int i() {
        return this.ab;
    }

    public LocationRequest setExpirationDuration(long millis) {
        long jElapsedRealtime = SystemClock.elapsedRealtime();
        if (millis > Long.MAX_VALUE - jElapsedRealtime) {
            this.fw = Long.MAX_VALUE;
        } else {
            this.fw = jElapsedRealtime + millis;
        }
        if (this.fw < 0) {
            this.fw = 0L;
        }
        return this;
    }

    public LocationRequest setExpirationTime(long millis) {
        this.fw = millis;
        if (this.fw < 0) {
            this.fw = 0L;
        }
        return this;
    }

    public LocationRequest setFastestInterval(long millis) {
        c(millis);
        this.fD = true;
        this.fC = millis;
        return this;
    }

    public LocationRequest setInterval(long millis) {
        c(millis);
        this.fB = millis;
        if (!this.fD) {
            this.fC = (long) (this.fB / 6.0d);
        }
        return this;
    }

    public LocationRequest setNumUpdates(int numUpdates) {
        if (numUpdates <= 0) {
            throw new IllegalArgumentException("invalid numUpdates: " + numUpdates);
        }
        this.fE = numUpdates;
        return this;
    }

    public LocationRequest setPriority(int priority) {
        M(priority);
        this.mPriority = priority;
        return this;
    }

    public LocationRequest setSmallestDisplacement(float smallestDisplacementMeters) {
        a(smallestDisplacementMeters);
        this.fF = smallestDisplacementMeters;
        return this;
    }

    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append("Request[").append(N(this.mPriority));
        if (this.mPriority != 105) {
            sb.append(" requested=");
            sb.append(this.fB + "ms");
        }
        sb.append(" fastest=");
        sb.append(this.fC + "ms");
        if (this.fw != Long.MAX_VALUE) {
            long jElapsedRealtime = this.fw - SystemClock.elapsedRealtime();
            sb.append(" expireIn=");
            sb.append(jElapsedRealtime + "ms");
        }
        if (this.fE != Integer.MAX_VALUE) {
            sb.append(" num=").append(this.fE);
        }
        sb.append(']');
        return sb.toString();
    }

    @Override // android.os.Parcelable
    public void writeToParcel(Parcel parcel, int flags) {
        LocationRequestCreator.a(this, parcel, flags);
    }
}
