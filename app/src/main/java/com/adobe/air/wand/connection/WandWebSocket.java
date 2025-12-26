package com.adobe.air.wand.connection;

import android.app.Activity;
import android.net.wifi.WifiInfo;
import android.net.wifi.WifiManager;
import android.os.AsyncTask;
import android.support.v4.view.MotionEventCompat;
import com.adobe.air.wand.Version;
import com.adobe.air.wand.connection.Connection;
import java.io.IOException;
import java.net.InetAddress;
import java.net.InetSocketAddress;
import java.net.URL;
import java.net.URLEncoder;
import java.net.UnknownHostException;
import java.nio.channels.CancelledKeyException;
import java.util.Timer;
import java.util.TimerTask;
import java.util.regex.Pattern;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.DefaultHttpClient;
import org.java_websocket.WebSocket;
import org.java_websocket.handshake.ClientHandshake;
import org.java_websocket.server.WebSocketServer;
import org.json.JSONObject;

/* loaded from: classes.dex */
public class WandWebSocket implements Connection {
    private static final String CONNECT_PING_URL = "http://dh8vjmvwgc27o.cloudfront.net/AIRGamepad/connect_ping.txt";
    private static final String LOG_TAG = "WandWebSocket";
    private static final String WEBSOCKET_PROTOCOL = "WEBSOCKET";
    private Activity mActivity;
    private Timer mHandshakeTimer;
    private final String OPEN_SYNCHRONIZER = "OPEN_SYNCHRONIZER";
    private final String HANDSHAKE_SYNCHRONIZER = "HANDSHAKE_SYNCHRONIZER";
    private Connection.Listener mConnectionListener = null;
    private WebSocket mConnection = null;
    private boolean mAllowIncomingConnection = false;
    private String mConnectionToken = null;
    private String mLocalID = null;
    private Handshake mHandshake = null;
    private WandSocketServer mWandSocketServer = null;
    private boolean mIsDisposed = false;

    private static class Handshake {
        private static final String APPLICATION_URL = "applicationURL";
        private static final String DESTINATION_ID = "destinationID";
        private static final String PROTOCOL = "protocol";
        private static final String PUBLISHER = "publisher";
        private static final String SOURCE_ID = "sourceID";
        private static final String STATUS = "status";
        private static final String STATUS_SUCCESS = "SUCCESS";
        public static final int TIMEOUT_MILLISECONDS = 30000;
        private static final String VERSION = "version";
        private String mProtocol = WandWebSocket.WEBSOCKET_PROTOCOL;
        private String mVersion = null;
        private String mSourceID = null;
        private String mDestinationID = null;
        private String mPublisher = null;
        private String mApplicationURL = null;

        public String getProtocol() {
            return this.mProtocol;
        }

        public String getVersion() {
            return this.mVersion;
        }

        public String getSourceID() {
            return this.mSourceID;
        }

        public String getDestinationID() {
            return this.mDestinationID;
        }

        public String getPublisher() {
            return this.mPublisher;
        }

        public String getApplicationURL() {
            return this.mApplicationURL;
        }

        private Handshake() {
        }

        public static Handshake parse(String str) throws Exception {
            JSONObject jSONObject = new JSONObject(str);
            Handshake handshake = new Handshake();
            handshake.mProtocol = jSONObject.getString(PROTOCOL);
            handshake.mVersion = jSONObject.getString("version");
            handshake.mSourceID = jSONObject.getString(SOURCE_ID);
            handshake.mDestinationID = jSONObject.getString(DESTINATION_ID);
            if (jSONObject.has(PUBLISHER)) {
                handshake.mPublisher = jSONObject.getString(PUBLISHER);
            }
            if (jSONObject.has(APPLICATION_URL)) {
                handshake.mApplicationURL = jSONObject.getString(APPLICATION_URL);
            }
            return handshake;
        }

        public String getSuccessResponse(String str) throws Exception {
            JSONObject jSONObject = new JSONObject();
            jSONObject.put(PROTOCOL, WandWebSocket.WEBSOCKET_PROTOCOL);
            jSONObject.put("version", this.mVersion);
            jSONObject.put(SOURCE_ID, str);
            jSONObject.put(DESTINATION_ID, this.mSourceID);
            jSONObject.put(STATUS, STATUS_SUCCESS);
            if (Version.isGreaterThanEqualTo(this.mVersion, "1.1.0")) {
                jSONObject.put(PUBLISHER, this.mPublisher);
                jSONObject.put(APPLICATION_URL, this.mApplicationURL);
            }
            return jSONObject.toString();
        }
    }

    private class WandSocketServer extends WebSocketServer {
        private boolean mHasStartedServer;

        public WandSocketServer(InetSocketAddress inetSocketAddress) throws UnknownHostException {
            super(inetSocketAddress);
            this.mHasStartedServer = false;
        }

        public void start() {
            if (!this.mHasStartedServer) {
                super.start();
                this.mHasStartedServer = true;
            }
        }

        public void stop() throws InterruptedException, IOException {
            if (this.mHasStartedServer) {
                try {
                    super.stop();
                } catch (CancelledKeyException e) {
                }
                this.mHasStartedServer = false;
                if (WandWebSocket.this.mWandSocketServer != null) {
                    if (WandWebSocket.this.mConnection != null) {
                        WandWebSocket.this.forceCloseConnection();
                    }
                    WandWebSocket.this.mWandSocketServer = null;
                    try {
                        WandWebSocket.this.startSocketServer();
                    } catch (Exception e2) {
                    }
                }
            }
        }

        public void onOpen(WebSocket webSocket, ClientHandshake clientHandshake) {
            synchronized ("OPEN_SYNCHRONIZER") {
                if (WandWebSocket.this.mAllowIncomingConnection && WandWebSocket.this.mConnection == null) {
                    WandWebSocket.this.mConnection = webSocket;
                    scheduleHandshakeTimer();
                } else {
                    webSocket.close(1003, "AIR Gamepad is already connected");
                }
            }
        }

        private void scheduleHandshakeTimer() {
            try {
                WandWebSocket.this.mHandshakeTimer.schedule(new TimerTask() { // from class: com.adobe.air.wand.connection.WandWebSocket.WandSocketServer.1
                    @Override // java.util.TimerTask, java.lang.Runnable
                    public void run() {
                        synchronized ("OPEN_SYNCHRONIZER") {
                            if (WandWebSocket.this.mConnection != null) {
                                synchronized ("HANDSHAKE_SYNCHRONIZER") {
                                    if (WandWebSocket.this.mHandshake == null) {
                                        WandWebSocket.this.mConnection.close(1003, "AIR Gamepad handshake timedout");
                                    }
                                }
                            }
                        }
                    }
                }, 30000L);
            } catch (Exception e) {
            }
        }

        public void onClose(WebSocket webSocket, int i, String str, boolean z) {
            synchronized ("OPEN_SYNCHRONIZER") {
                if (WandWebSocket.this.mConnection == webSocket) {
                    WandWebSocket.this.mConnection = null;
                    synchronized ("HANDSHAKE_SYNCHRONIZER") {
                        if (WandWebSocket.this.mHandshake != null) {
                            WandWebSocket.this.mHandshake = null;
                            if (WandWebSocket.this.mConnectionListener != null) {
                                WandWebSocket.this.mConnectionListener.onConnectionClose();
                            }
                        }
                    }
                }
            }
        }

        public void onMessage(WebSocket webSocket, String str) {
            Handshake handshake;
            synchronized ("OPEN_SYNCHRONIZER") {
                if (webSocket == WandWebSocket.this.mConnection) {
                    synchronized ("HANDSHAKE_SYNCHRONIZER") {
                        if (WandWebSocket.this.mHandshake != null) {
                            if (!str.equals("NO_OP")) {
                                if (WandWebSocket.this.mConnectionListener != null) {
                                    WandWebSocket.this.mConnectionListener.onReceive(str);
                                }
                                return;
                            }
                            return;
                        }
                        String message = "";
                        try {
                            try {
                                handshake = Handshake.parse(str);
                                WandWebSocket.this.validateHandshake(handshake);
                            } catch (Exception e) {
                                throw new Exception("Unable to parse the handshake");
                            }
                        } catch (Exception e2) {
                            message = e2.getMessage();
                            handshake = null;
                        }
                        if (handshake != null) {
                            WandWebSocket.this.mHandshake = handshake;
                            try {
                                if (WandWebSocket.this.mConnectionListener != null) {
                                    WandWebSocket.this.mConnectionListener.onConnectionOpen(handshake.getVersion());
                                }
                            } catch (Exception e3) {
                                WandWebSocket.this.mHandshake = null;
                            }
                            return;
                        }
                        webSocket.close(1003, "Invalid AIR Gamepad handshake : " + message);
                    }
                }
            }
        }

        public void onError(WebSocket webSocket, Exception exc) {
            if (WandWebSocket.this.mConnection != null && WandWebSocket.this.mConnection != webSocket && webSocket != null) {
                try {
                    webSocket.close(1003, "AIR Gamepad is already connected");
                } catch (Exception e) {
                }
            }
        }
    }

    public WandWebSocket(Activity activity) throws UnknownHostException {
        this.mHandshakeTimer = null;
        this.mActivity = null;
        this.mActivity = activity;
        this.mHandshakeTimer = new Timer();
    }

    /* JADX INFO: Access modifiers changed from: private */
    public void startSocketServer() throws Exception {
        if (this.mWandSocketServer == null) {
            this.mWandSocketServer = new WandSocketServer(new InetSocketAddress(getLocalIpAddress(), getPreferredPort()));
            this.mWandSocketServer.start();
        }
    }

    private void stopSocketServer() {
        WandSocketServer wandSocketServer = this.mWandSocketServer;
        this.mWandSocketServer = null;
        if (wandSocketServer != null) {
            try {
                wandSocketServer.stop();
            } catch (Exception e) {
            }
        }
    }

    private String constructLocalID() throws Exception {
        InetAddress localIpAddress = getLocalIpAddress();
        if (localIpAddress == null) {
            return null;
        }
        byte[] address = localIpAddress.getAddress();
        return Long.toString((getUnsignedByte(address[3]) * 1) + (getUnsignedByte(address[2]) * 256) + (getUnsignedByte(address[1]) * 65536) + (getUnsignedByte(address[0]) * 16777216), 32).toUpperCase();
    }

    @Override // com.adobe.air.wand.connection.Connection
    public void connect() throws Exception {
        if (this.mIsDisposed) {
            throw new Exception("Connection has been disposed");
        }
        if (this.mAllowIncomingConnection) {
            throw new Exception("Connection is already established");
        }
        this.mAllowIncomingConnection = true;
        if (this.mWandSocketServer == null) {
            startSocketServer();
        }
        this.mLocalID = constructLocalID();
        this.mConnectionToken = this.mLocalID;
        if (this.mConnectionListener != null) {
            this.mConnectionListener.updateConnectionToken(getConnectionToken());
        }
        if (this.mConnectionListener != null) {
            this.mConnectionListener.onConnectSuccess();
        }
    }

    /* JADX INFO: Access modifiers changed from: private */
    public void forceCloseConnection() {
        WebSocket webSocket = this.mConnection;
        this.mWandSocketServer.onClose(this.mConnection, 1001, "AIR Gamepad has closed", false);
        webSocket.close(1001, "AIR Gamepad has closed");
    }

    @Override // com.adobe.air.wand.connection.Connection
    public void disconnect() throws Exception {
        if (this.mIsDisposed) {
            throw new Exception("Connection has been disposed");
        }
        if (!this.mAllowIncomingConnection) {
            throw new Exception("Connection is not established");
        }
        if (this.mConnection != null) {
            forceCloseConnection();
        }
        stopSocketServer();
        this.mAllowIncomingConnection = false;
        if (this.mConnectionListener != null) {
            this.mConnectionListener.onDisconnectSuccess();
        }
    }

    @Override // com.adobe.air.wand.connection.Connection
    public String getConnectionToken() throws Exception {
        if (this.mIsDisposed) {
            throw new Exception("Connection has been disposed");
        }
        if (this.mAllowIncomingConnection) {
            return this.mConnectionToken == null ? "" : this.mConnectionToken;
        }
        throw new Exception("Connection is not established");
    }

    @Override // com.adobe.air.wand.connection.Connection
    public void registerListener(Connection.Listener listener) throws Exception {
        if (this.mIsDisposed) {
            throw new Exception("Connection has been disposed");
        }
        if (listener == null) {
            throw new Exception("Invalid Connection.Listener");
        }
        if (this.mConnectionListener != null) {
            throw new Exception("A listener is already registered");
        }
        this.mConnectionListener = listener;
    }

    @Override // com.adobe.air.wand.connection.Connection
    public void unregisterListener() {
        this.mConnectionListener = null;
    }

    @Override // com.adobe.air.wand.connection.Connection
    public void send(String str) throws Exception {
        if (this.mIsDisposed) {
            throw new Exception("Connection has been disposed");
        }
        if (this.mConnection != null) {
            try {
                this.mConnection.send(str);
            } catch (Throwable th) {
                throw new Exception("Unable to send Message");
            }
        }
    }

    private InetAddress getWiFiIpAddress() throws UnknownHostException {
        WifiInfo connectionInfo;
        int ipAddress;
        WifiManager wifiManager = (WifiManager) this.mActivity.getSystemService("wifi");
        if (wifiManager != null && (connectionInfo = wifiManager.getConnectionInfo()) != null && (ipAddress = connectionInfo.getIpAddress()) != 0) {
            return InetAddress.getByName(String.format("%d.%d.%d.%d", Integer.valueOf(ipAddress & MotionEventCompat.ACTION_MASK), Integer.valueOf((ipAddress >> 8) & MotionEventCompat.ACTION_MASK), Integer.valueOf((ipAddress >> 16) & MotionEventCompat.ACTION_MASK), Integer.valueOf((ipAddress >> 24) & MotionEventCompat.ACTION_MASK)));
        }
        return null;
    }

    /* JADX WARN: Removed duplicated region for block: B:70:0x0104  */
    /*
        Code decompiled incorrectly, please refer to instructions dump.
        To view partially-correct code enable 'Show inconsistent code' option in preferences
    */
    private java.net.InetAddress getWiFiHotspotIpAddress() throws java.net.SocketException, java.lang.SecurityException, java.net.UnknownHostException {
        /*
            Method dump skipped, instructions count: 263
            To view this dump change 'Code comments level' option to 'DEBUG'
        */
        throw new UnsupportedOperationException("Method not decompiled: com.adobe.air.wand.connection.WandWebSocket.getWiFiHotspotIpAddress():java.net.InetAddress");
    }

    private InetAddress getLocalIpAddress() {
        try {
            InetAddress wiFiIpAddress = getWiFiIpAddress();
            return wiFiIpAddress == null ? getWiFiHotspotIpAddress() : wiFiIpAddress;
        } catch (Exception e) {
            return null;
        }
    }

    private int getPreferredPort() {
        return 1234;
    }

    private int getUnsignedByte(byte b) {
        return b >= 0 ? b : b + 256;
    }

    /* JADX INFO: Access modifiers changed from: private */
    public void validateHandshake(Handshake handshake) throws Exception {
        if (handshake == null) {
            throw new Exception("Handshake is null");
        }
        String version = handshake.getVersion();
        if (!Pattern.matches("\\d+\\.\\d+\\.\\d+", version)) {
            throw new Exception("Invalid version format");
        }
        if (Version.isGreaterThan(version, "1.1.0") || !Version.isGreaterThanEqualTo(version, Version.V1_0_0)) {
            throw new Exception("Unsupported version");
        }
        if (!WEBSOCKET_PROTOCOL.equals(handshake.getProtocol())) {
            throw new Exception("Invalid protocol");
        }
        if (!this.mLocalID.equals(handshake.getDestinationID())) {
            throw new Exception("Invalid destinationID");
        }
        if (Version.isGreaterThanEqualTo(version, "1.1.0")) {
            if (handshake.getPublisher() == null) {
                throw new Exception("Invalid publisher");
            }
            String applicationURL = handshake.getApplicationURL();
            if (applicationURL == null) {
                throw new Exception("Invalid applicationURL");
            }
            try {
                new URL(applicationURL);
            } catch (Exception e) {
                throw new Exception("Invalid applicationURL");
            }
        }
    }

    @Override // com.adobe.air.wand.connection.Connection
    public void onConnectionChanged() {
        if (!this.mIsDisposed && this.mAllowIncomingConnection) {
            try {
                String strConstructLocalID = constructLocalID();
                if (this.mLocalID != null || strConstructLocalID != null) {
                    if (this.mLocalID == null || strConstructLocalID == null || !this.mLocalID.equals(strConstructLocalID)) {
                        disconnect();
                        connect();
                    }
                }
            } catch (Exception e) {
            }
        }
    }

    private class ConnectPingTask extends AsyncTask<String, Integer, Long> {
        private ConnectPingTask() {
        }

        /* JADX INFO: Access modifiers changed from: protected */
        @Override // android.os.AsyncTask
        public Long doInBackground(String... strArr) throws IOException {
            if (strArr == null || strArr.length < 1) {
                return 0L;
            }
            try {
                new DefaultHttpClient().execute(new HttpGet(strArr[0]));
                return 0L;
            } catch (Exception e) {
                return -1L;
            }
        }

        /* JADX INFO: Access modifiers changed from: protected */
        @Override // android.os.AsyncTask
        public void onProgressUpdate(Integer... numArr) {
        }

        /* JADX INFO: Access modifiers changed from: protected */
        @Override // android.os.AsyncTask
        public void onPostExecute(Long l) {
        }
    }

    private void pingServerOnConnect(String str, String str2) throws Exception {
        if (str == null || str2 == null) {
            new ConnectPingTask().execute(CONNECT_PING_URL);
        } else {
            new ConnectPingTask().execute("http://dh8vjmvwgc27o.cloudfront.net/AIRGamepad/connect_ping.txt?publisher=" + URLEncoder.encode(str, "UTF-8") + "&applicationURL=" + URLEncoder.encode(str2, "UTF-8"));
        }
    }

    @Override // com.adobe.air.wand.connection.Connection
    public void onReadyForConnection() throws Exception {
        if (this.mHandshake == null || this.mLocalID == null) {
            throw new Exception("Invalid state at onReadyForConnection callback.");
        }
        this.mConnection.send(this.mHandshake.getSuccessResponse(this.mLocalID));
        pingServerOnConnect(this.mHandshake.mPublisher, this.mHandshake.mApplicationURL);
    }

    public void dispose() throws Exception {
        if (!this.mIsDisposed) {
            this.mIsDisposed = true;
            if (this.mAllowIncomingConnection) {
                disconnect();
            }
            unregisterListener();
            if (this.mConnection != null) {
                this.mConnection.close(1001, "AIR Gamepad has closed");
            }
            this.mConnection = null;
            this.mHandshake = null;
            if (this.mHandshakeTimer != null) {
                this.mHandshakeTimer.cancel();
                this.mHandshakeTimer.purge();
            }
            this.mHandshakeTimer = null;
            this.mWandSocketServer = null;
            this.mActivity = null;
        }
    }
}
