package com.codapayments.sdk.c;

import android.R;
import android.app.Notification;
import android.app.NotificationManager;
import android.content.Context;
import java.util.Random;

/* loaded from: classes.dex */
public final class h {
    private static final Random a = new Random();

    public static void a(Context context, String str, String str2, boolean z) {
        NotificationManager notificationManager = (NotificationManager) context.getSystemService("notification");
        int i = R.drawable.star_big_on;
        if (z) {
            i = R.drawable.stat_notify_error;
        }
        Notification notification = new Notification(i, null, System.currentTimeMillis());
        notification.ledARGB = -16711936;
        notification.ledOnMS = 300;
        notification.ledOffMS = 1000;
        notification.defaults = -1;
        notification.setLatestEventInfo(context, str, str2, null);
        notificationManager.notify(a.nextInt(1000), notification);
    }
}
