package com.google.android.gms.location;

import android.os.SystemClock;
import com.google.android.gms.internal.bi;

/* loaded from: classes.dex */
public interface Geofence {
    public static final int GEOFENCE_TRANSITION_ENTER = 1;
    public static final int GEOFENCE_TRANSITION_EXIT = 2;
    public static final long NEVER_EXPIRE = -1;

    public static final class Builder {
        private float fA;
        private String fu = null;
        private int fv = 0;
        private long fw = Long.MIN_VALUE;
        private short fx = -1;
        private double fy;
        private double fz;

        public Geofence build() {
            if (this.fu == null) {
                throw new IllegalArgumentException("Request ID not set.");
            }
            if (this.fv == 0) {
                throw new IllegalArgumentException("Transitions types not set.");
            }
            if (this.fw == Long.MIN_VALUE) {
                throw new IllegalArgumentException("Expiration not set.");
            }
            if (this.fx == -1) {
                throw new IllegalArgumentException("Geofence region not set.");
            }
            return new bi(this.fu, this.fv, (short) 1, this.fy, this.fz, this.fA, this.fw);
        }

        public Builder setCircularRegion(double latitude, double longitude, float radius) {
            this.fx = (short) 1;
            this.fy = latitude;
            this.fz = longitude;
            this.fA = radius;
            return this;
        }

        public Builder setExpirationDuration(long durationMillis) {
            if (durationMillis < 0) {
                this.fw = -1L;
            } else {
                this.fw = SystemClock.elapsedRealtime() + durationMillis;
            }
            return this;
        }

        public Builder setRequestId(String requestId) {
            this.fu = requestId;
            return this;
        }

        public Builder setTransitionTypes(int transitionTypes) {
            this.fv = transitionTypes;
            return this;
        }
    }

    String getRequestId();
}
