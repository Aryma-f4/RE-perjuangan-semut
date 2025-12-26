package com.adobe.air.location;

import android.location.Location;
import android.location.LocationListener;
import android.os.Bundle;

/* loaded from: classes.dex */
public class AIRLocationListener implements LocationListener {
    private static final int TIMEOUT_INTERVAL = 15000;
    private Geolocation m_geoObj;

    public AIRLocationListener(Geolocation geolocation) {
        this.m_geoObj = geolocation;
    }

    @Override // android.location.LocationListener
    public void onLocationChanged(Location location) {
        if (location != null) {
            String provider = location.getProvider();
            this.m_geoObj.m_currentTime.setToNow();
            double latitude = location.getLatitude();
            double longitude = location.getLongitude();
            double altitude = location.getAltitude();
            float accuracy = location.getAccuracy();
            float accuracy2 = location.getAccuracy();
            float speed = location.getSpeed();
            long millis = this.m_geoObj.m_currentTime.toMillis(false);
            if (provider.compareTo("gps") == 0) {
                this.m_geoObj.m_ignoreLastGPSValue = false;
                this.m_geoObj.m_gpsLatitude = latitude;
                this.m_geoObj.m_gpsLongitude = longitude;
                this.m_geoObj.m_gpsAltitude = altitude;
                this.m_geoObj.m_gpsHorizontalAaccuracy = accuracy;
                this.m_geoObj.m_gpsVerticalAccuracy = accuracy2;
                this.m_geoObj.m_gpsSpeed = speed;
                this.m_geoObj.m_gpsTimestamp = this.m_geoObj.m_currentTime.toMillis(false);
            } else if (provider.compareTo("network") == 0) {
                this.m_geoObj.m_networkLatitude = latitude;
                this.m_geoObj.m_networkLongitude = longitude;
                this.m_geoObj.m_networkAltitude = altitude;
                this.m_geoObj.m_networkHorizontalAaccuracy = accuracy;
                this.m_geoObj.m_networkVerticalAccuracy = accuracy2;
                this.m_geoObj.m_networkSpeed = speed;
                this.m_geoObj.m_networkTimestamp = this.m_geoObj.m_currentTime.toMillis(false);
                if (this.m_geoObj.m_ignoreLastGPSValue || this.m_geoObj.m_networkTimestamp - this.m_geoObj.m_gpsTimestamp >= 15000 || this.m_geoObj.m_networkHorizontalAaccuracy <= this.m_geoObj.m_gpsHorizontalAaccuracy || !isRegionFullyContained(this.m_geoObj.m_gpsLatitude, this.m_geoObj.m_gpsLongitude, this.m_geoObj.m_gpsHorizontalAaccuracy, this.m_geoObj.m_networkLatitude, this.m_geoObj.m_networkLongitude, this.m_geoObj.m_networkHorizontalAaccuracy)) {
                    this.m_geoObj.m_ignoreLastGPSValue = true;
                } else {
                    return;
                }
            }
            this.m_geoObj.m_latitude = latitude;
            this.m_geoObj.m_longitude = longitude;
            this.m_geoObj.m_altitude = altitude;
            this.m_geoObj.m_horizontalAaccuracy = accuracy;
            this.m_geoObj.m_verticalAccuracy = accuracy2;
            this.m_geoObj.m_speed = speed;
            this.m_geoObj.m_timestamp = millis;
            if (this.m_geoObj.m_EventSourceExists) {
                this.m_geoObj.updateGeolocationCache(this.m_geoObj.m_objectPointer);
            }
        }
    }

    @Override // android.location.LocationListener
    public void onProviderDisabled(String str) {
        boolean z = this.m_geoObj.m_isGPSProviderEnabled;
        boolean z2 = this.m_geoObj.m_isNetworkProviderEnabled;
        if (str.compareTo("gps") == 0) {
            this.m_geoObj.m_isGPSProviderEnabled = false;
        } else if (str.compareTo("network") == 0) {
            this.m_geoObj.m_isNetworkProviderEnabled = false;
        }
        if ((z != this.m_geoObj.m_isGPSProviderEnabled || z2 != this.m_geoObj.m_isNetworkProviderEnabled) && this.m_geoObj.m_EventSourceExists && !this.m_geoObj.m_isGPSProviderEnabled && !this.m_geoObj.m_isNetworkProviderEnabled) {
            this.m_geoObj.setGeolocationStatus(false, this.m_geoObj.m_objectPointer);
        }
    }

    @Override // android.location.LocationListener
    public void onProviderEnabled(String str) {
        boolean z = this.m_geoObj.m_isGPSProviderEnabled;
        boolean z2 = this.m_geoObj.m_isNetworkProviderEnabled;
        if (str.compareTo("gps") == 0) {
            this.m_geoObj.m_isGPSProviderEnabled = true;
            if (this.m_geoObj.m_EventSourceExists && !this.m_geoObj.m_isNetworkProviderEnabled && z != this.m_geoObj.m_isGPSProviderEnabled) {
                this.m_geoObj.setGeolocationStatus(true, this.m_geoObj.m_objectPointer);
                return;
            }
            return;
        }
        if (str.compareTo("network") == 0) {
            this.m_geoObj.m_isNetworkProviderEnabled = true;
            if (this.m_geoObj.m_EventSourceExists && !this.m_geoObj.m_isGPSProviderEnabled && z2 != this.m_geoObj.m_isNetworkProviderEnabled) {
                this.m_geoObj.setGeolocationStatus(true, this.m_geoObj.m_objectPointer);
            }
        }
    }

    @Override // android.location.LocationListener
    public void onStatusChanged(String str, int i, Bundle bundle) {
    }

    private boolean isRegionFullyContained(double d, double d2, float f, double d3, double d4, float f2) {
        float[] fArr = new float[5];
        Location.distanceBetween(d, d2, d3, d4, fArr);
        return fArr[0] <= Math.abs(f2 - f);
    }
}
