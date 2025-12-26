package com.adobe.air;

/* loaded from: classes.dex */
public final class DebuggerSettings {
    private int debuggerPort;
    private String host;
    private boolean listenForConn;

    DebuggerSettings() {
        this.debuggerPort = -1;
        this.host = null;
        this.listenForConn = false;
    }

    DebuggerSettings(int i, String str, boolean z) {
        this.debuggerPort = -1;
        this.host = null;
        this.listenForConn = false;
        this.debuggerPort = i;
        this.host = str;
        this.listenForConn = z;
    }

    public int getDebuggerPort() {
        return this.debuggerPort;
    }

    public String getHost() {
        return this.host;
    }

    public boolean shouldListen() {
        return this.listenForConn;
    }

    public void setDebugerPort(int i) {
        this.debuggerPort = i;
    }

    public void setHost(String str) {
        this.host = str;
    }

    public void setListen(boolean z) {
        this.listenForConn = z;
    }
}
