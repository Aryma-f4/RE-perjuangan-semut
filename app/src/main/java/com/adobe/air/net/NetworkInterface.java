package com.adobe.air.net;

import java.util.Vector;

/* loaded from: classes.dex */
public class NetworkInterface {
    public boolean active = false;
    public String displayName = "";
    public String hardwareAddress = "";
    public int mtu = -1;
    public String name = "";
    public NetworkInterface parent = null;
    public NetworkInterface subInterfaces = null;
    private Vector<InterfaceAddress> addresses = new Vector<>();

    public void addAddress(InterfaceAddress interfaceAddress) {
        this.addresses.add(interfaceAddress);
    }

    public int GetAddressesCount() {
        return this.addresses.size();
    }

    public InterfaceAddress GetAddress(int i) {
        return this.addresses.elementAt(i);
    }
}
