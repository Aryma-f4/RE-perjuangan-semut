package com.google.android.gms.gcm;

import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.os.Message;
import android.os.Messenger;
import com.google.android.gms.common.GooglePlayServicesUtil;
import java.io.IOException;
import java.util.concurrent.BlockingQueue;
import java.util.concurrent.LinkedBlockingQueue;
import java.util.concurrent.TimeUnit;

/* loaded from: classes.dex */
public class GoogleCloudMessaging {
    public static final String ERROR_MAIN_THREAD = "MAIN_THREAD";
    public static final String ERROR_SERVICE_NOT_AVAILABLE = "SERVICE_NOT_AVAILABLE";
    public static final String MESSAGE_TYPE_DELETED = "deleted_messages";
    public static final String MESSAGE_TYPE_MESSAGE = "gcm";
    public static final String MESSAGE_TYPE_SEND_ERROR = "send_error";
    static GoogleCloudMessaging fh;
    private Context fi;
    private PendingIntent fj;
    final BlockingQueue<Intent> fk = new LinkedBlockingQueue();
    private Handler fl = new Handler(Looper.getMainLooper()) { // from class: com.google.android.gms.gcm.GoogleCloudMessaging.1
        @Override // android.os.Handler
        public void handleMessage(Message msg) {
            GoogleCloudMessaging.this.fk.add((Intent) msg.obj);
        }
    };
    private Messenger fm = new Messenger(this.fl);

    private void aO() {
        Intent intent = new Intent("com.google.android.c2dm.intent.UNREGISTER");
        intent.setPackage(GooglePlayServicesUtil.GOOGLE_PLAY_SERVICES_PACKAGE);
        this.fk.clear();
        intent.putExtra("google.messenger", this.fm);
        c(intent);
        this.fi.startService(intent);
    }

    private void b(String... strArr) {
        String strC = c(strArr);
        Intent intent = new Intent("com.google.android.c2dm.intent.REGISTER");
        intent.setPackage(GooglePlayServicesUtil.GOOGLE_PLAY_SERVICES_PACKAGE);
        intent.putExtra("google.messenger", this.fm);
        c(intent);
        intent.putExtra("sender", strC);
        this.fi.startService(intent);
    }

    public static synchronized GoogleCloudMessaging getInstance(Context context) {
        if (fh == null) {
            fh = new GoogleCloudMessaging();
            fh.fi = context;
        }
        return fh;
    }

    synchronized void aP() {
        if (this.fj != null) {
            this.fj.cancel();
            this.fj = null;
        }
    }

    String c(String... strArr) {
        if (strArr == null || strArr.length == 0) {
            throw new IllegalArgumentException("No senderIds");
        }
        StringBuilder sb = new StringBuilder(strArr[0]);
        for (int i = 1; i < strArr.length; i++) {
            sb.append(',').append(strArr[i]);
        }
        return sb.toString();
    }

    synchronized void c(Intent intent) {
        if (this.fj == null) {
            this.fj = PendingIntent.getBroadcast(this.fi, 0, new Intent(), 0);
        }
        intent.putExtra("app", this.fj);
    }

    public void close() {
        aP();
    }

    public String getMessageType(Intent intent) {
        if (!"com.google.android.c2dm.intent.RECEIVE".equals(intent.getAction())) {
            return null;
        }
        String stringExtra = intent.getStringExtra("message_type");
        return stringExtra == null ? MESSAGE_TYPE_MESSAGE : stringExtra;
    }

    public String register(String... senderIds) throws InterruptedException, IOException {
        if (Looper.getMainLooper() == Looper.myLooper()) {
            throw new IOException(ERROR_MAIN_THREAD);
        }
        this.fk.clear();
        b(senderIds);
        try {
            Intent intentPoll = this.fk.poll(5000L, TimeUnit.MILLISECONDS);
            if (intentPoll == null) {
                throw new IOException(ERROR_SERVICE_NOT_AVAILABLE);
            }
            String stringExtra = intentPoll.getStringExtra("registration_id");
            if (stringExtra != null) {
                return stringExtra;
            }
            intentPoll.getStringExtra("error");
            String stringExtra2 = intentPoll.getStringExtra("error");
            if (stringExtra2 != null) {
                throw new IOException(stringExtra2);
            }
            throw new IOException(ERROR_SERVICE_NOT_AVAILABLE);
        } catch (InterruptedException e) {
            throw new IOException(e.getMessage());
        }
    }

    public void send(String to, String msgId, long timeToLive, Bundle data) throws IOException {
        if (Looper.getMainLooper() == Looper.myLooper()) {
            throw new IOException(ERROR_MAIN_THREAD);
        }
        if (to == null) {
            throw new IllegalArgumentException("Missing 'to'");
        }
        Intent intent = new Intent("com.google.android.gcm.intent.SEND");
        intent.putExtras(data);
        c(intent);
        intent.putExtra("google.to", to);
        intent.putExtra("google.message_id", msgId);
        intent.putExtra("google.ttl", Long.toString(timeToLive));
        this.fi.sendOrderedBroadcast(intent, null);
    }

    public void send(String to, String msgId, Bundle data) throws IOException {
        send(to, msgId, -1L, data);
    }

    public void unregister() throws InterruptedException, IOException {
        if (Looper.getMainLooper() == Looper.myLooper()) {
            throw new IOException(ERROR_MAIN_THREAD);
        }
        aO();
        try {
            Intent intentPoll = this.fk.poll(5000L, TimeUnit.MILLISECONDS);
            if (intentPoll == null) {
                throw new IOException(ERROR_SERVICE_NOT_AVAILABLE);
            }
            if (intentPoll.getStringExtra("unregistered") != null) {
                return;
            }
            String stringExtra = intentPoll.getStringExtra("error");
            if (stringExtra == null) {
                throw new IOException(ERROR_SERVICE_NOT_AVAILABLE);
            }
            throw new IOException(stringExtra);
        } catch (InterruptedException e) {
            throw new IOException(e.getMessage());
        }
    }
}
