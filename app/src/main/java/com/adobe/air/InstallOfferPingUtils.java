package com.adobe.air;

import android.app.Activity;
import android.os.AsyncTask;
import android.os.Build;
import java.io.IOException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.Locale;

/* loaded from: classes.dex */
public class InstallOfferPingUtils {
    private static final String LOG_TAG = "InstallOfferPingUtils";

    public static void PingAndExit(Activity activity, String baseUrl, boolean installClicked, boolean update, final boolean exit) {
        String urlQueryStr;
        try {
            if (update) {
                urlQueryStr = "installOffer=" + (installClicked ? "ua" : "ur");
            } else {
                urlQueryStr = "installOffer=" + (installClicked ? "a" : "r");
            }
            String urlStr = baseUrl + URLEncoder.encode(((((((urlQueryStr + "&appid=" + activity.getPackageName()) + "&runtimeType=s") + "&lang=" + Locale.getDefault().getLanguage()) + "&model=" + Build.MODEL) + "&os=a") + "&osVer=" + Build.VERSION.RELEASE) + "&arch=" + System.getProperty("os.arch"), "UTF-8");
            AsyncTask<String, Integer, Integer> PingAndExitTask = new AsyncTask<String, Integer, Integer>() { // from class: com.adobe.air.InstallOfferPingUtils.1
                /* JADX INFO: Access modifiers changed from: protected */
                @Override // android.os.AsyncTask
                public Integer doInBackground(String... urls) throws IOException {
                    int resCode = 0;
                    try {
                        URL url = new URL(urls[0]);
                        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
                        conn.setConnectTimeout(10000);
                        conn.setRequestMethod("GET");
                        HttpURLConnection.setFollowRedirects(true);
                        resCode = conn.getResponseCode();
                        if (exit) {
                            System.exit(0);
                        }
                    } catch (Exception e) {
                    }
                    return Integer.valueOf(resCode);
                }
            };
            PingAndExitTask.execute(urlStr);
            activity.finish();
        } catch (Exception e) {
        }
    }
}
