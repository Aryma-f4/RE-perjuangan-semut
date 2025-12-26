package com.adobe.air.wand.connection;

/* loaded from: classes.dex */
public interface Connection {

    public interface Listener {
        void onConnectError();

        void onConnectSuccess();

        void onConnectionClose();

        void onConnectionOpen(String str);

        void onDisconnectError();

        void onDisconnectSuccess();

        void onReceive(String str);

        void updateConnectionToken(String str);
    }

    void connect() throws Exception;

    void disconnect() throws Exception;

    String getConnectionToken() throws Exception;

    void onConnectionChanged();

    void onReadyForConnection() throws Exception;

    void registerListener(Listener listener) throws Exception;

    void send(String str) throws Exception;

    void unregisterListener();
}
