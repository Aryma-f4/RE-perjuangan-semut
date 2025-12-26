package com.adobe.air.net;

import android.content.Context;
import android.net.ConnectivityManager;
import android.net.DhcpInfo;
import android.net.NetworkInfo;
import android.net.wifi.WifiInfo;
import android.net.wifi.WifiManager;
import android.text.format.Formatter;
import java.util.Vector;

/* loaded from: classes.dex */
class AndroidNetworkInfo {
    private static final String LOG_TAG = "AndroidNetworkInfo";
    private static AndroidNetworkInfo sAndroidNetworkInfo = null;
    private Context mContext;
    private Vector<NetworkInterface> mInterfaces = new Vector<>();

    public static AndroidNetworkInfo GetAndroidNetworkInfo(Context context) {
        if (sAndroidNetworkInfo == null) {
            sAndroidNetworkInfo = new AndroidNetworkInfo(context);
        }
        return sAndroidNetworkInfo;
    }

    private AndroidNetworkInfo(Context context) {
        this.mContext = context;
    }

    public int GetNetworkInterfacesCount() {
        this.mInterfaces.clear();
        enumerateNetworkInterfaces();
        return this.mInterfaces.size();
    }

    public void InterfacesReadComplete() {
        this.mInterfaces.clear();
    }

    private void enumerateNetworkInterfaces() {
        NetworkInterface wifiData;
        try {
            for (NetworkInfo networkInfo : ((ConnectivityManager) this.mContext.getSystemService("connectivity")).getAllNetworkInfo()) {
                switch (networkInfo.getType()) {
                    case 1:
                        wifiData = getWifiData(networkInfo);
                        break;
                    default:
                        wifiData = getDefaultData(networkInfo);
                        break;
                }
                this.mInterfaces.add(wifiData);
            }
        } catch (Exception e) {
            this.mInterfaces.clear();
        }
    }

    public NetworkInterface GetNetworkInterface(int i) {
        if (i < 0 || i >= this.mInterfaces.size()) {
            return null;
        }
        return this.mInterfaces.elementAt(i);
    }

    NetworkInterface getWifiData(NetworkInfo networkInfo) {
        NetworkInterface networkInterface = new NetworkInterface();
        WifiManager wifiManager = (WifiManager) this.mContext.getSystemService("wifi");
        if (wifiManager == null) {
        }
        WifiInfo connectionInfo = wifiManager.getConnectionInfo();
        if (connectionInfo == null) {
        }
        networkInterface.active = networkInfo.isConnected();
        networkInterface.displayName = networkInfo.getTypeName();
        networkInterface.name = networkInfo.getTypeName();
        if (connectionInfo != null) {
            String macAddress = connectionInfo.getMacAddress();
            if (macAddress == null) {
                macAddress = "";
            }
            networkInterface.hardwareAddress = macAddress;
        }
        networkInterface.addAddress(getAddress(networkInfo));
        return networkInterface;
    }

    NetworkInterface getDefaultData(NetworkInfo networkInfo) {
        NetworkInterface networkInterface = new NetworkInterface();
        networkInterface.active = networkInfo.isConnected();
        networkInterface.displayName = networkInfo.getTypeName();
        networkInterface.name = networkInfo.getTypeName();
        return networkInterface;
    }

    InterfaceAddress getAddress(NetworkInfo networkInfo) {
        WifiManager wifiManager;
        InterfaceAddress interfaceAddress = new InterfaceAddress();
        if (networkInfo.isConnected() && (wifiManager = (WifiManager) this.mContext.getSystemService("wifi")) != null) {
            DhcpInfo dhcpInfo = wifiManager.getDhcpInfo();
            if (dhcpInfo != null) {
                interfaceAddress.address = Formatter.formatIpAddress(dhcpInfo.ipAddress);
                interfaceAddress.prefixLength = Integer.bitCount(dhcpInfo.netmask);
                interfaceAddress.broadcast = Formatter.formatIpAddress((dhcpInfo.netmask ^ (-1)) | dhcpInfo.ipAddress);
                interfaceAddress.ipVersion = "IPv4";
                return interfaceAddress;
            }
            WifiInfo connectionInfo = wifiManager.getConnectionInfo();
            if (connectionInfo == null) {
                return null;
            }
            interfaceAddress.address = Formatter.formatIpAddress(connectionInfo.getIpAddress());
            interfaceAddress.ipVersion = "IPv4";
            return interfaceAddress;
        }
        return null;
    }
}
