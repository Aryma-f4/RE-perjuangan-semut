package com.codapayments.sdk.a.a;

import android.app.Activity;
import android.util.Log;
import com.codapayments.sdk.c.f;
import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.ProtocolException;
import java.net.URL;
import java.util.Properties;

/* loaded from: classes.dex */
public class b {
    private static final String a = "Mozilla/5.0";
    private Activity b;
    private Properties c;

    public b() {
    }

    private b(Activity activity) {
        this.b = activity;
        this.c = new Properties();
    }

    public static String a(String str, String str2) throws IOException {
        try {
            HttpURLConnection httpURLConnection = (HttpURLConnection) new URL(str).openConnection();
            httpURLConnection.setRequestMethod("POST");
            httpURLConnection.setRequestProperty("User-Agent", a);
            httpURLConnection.setRequestProperty("Accept-Language", "en-US,en;q=0.5");
            httpURLConnection.setDoOutput(true);
            DataOutputStream dataOutputStream = new DataOutputStream(httpURLConnection.getOutputStream());
            dataOutputStream.writeBytes(str2);
            dataOutputStream.flush();
            dataOutputStream.close();
            Log.i(f.z, "Response Code : " + httpURLConnection.getResponseCode());
            BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(httpURLConnection.getInputStream()));
            StringBuffer stringBuffer = new StringBuffer();
            while (true) {
                String line = bufferedReader.readLine();
                if (line == null) {
                    bufferedReader.close();
                    return stringBuffer.toString();
                }
                stringBuffer.append(line);
            }
        } catch (MalformedURLException e) {
            e.printStackTrace();
            Log.i(f.z, "[ERROR] " + e);
            return null;
        } catch (ProtocolException e2) {
            e2.printStackTrace();
            Log.i(f.z, "[ERROR] " + e2);
            return null;
        } catch (IOException e3) {
            e3.printStackTrace();
            Log.i(f.z, "[ERROR] " + e3);
            return null;
        }
    }

    public String a(String str) throws IOException {
        String str2;
        String property;
        try {
            this.c.load(this.b.getAssets().open("codapayment.properties"));
            property = "apikey";
        } catch (Exception e) {
            e = e;
            str2 = str;
        }
        try {
            if (str == "apikey") {
                property = this.c.getProperty("apikey");
                Log.i(f.c, "API Key : " + property);
            } else if (str == "merchant") {
                property = this.c.getProperty("merchant");
                Log.i(f.c, "Merchant : " + property);
            } else if (str == "country") {
                property = this.c.getProperty("country");
                Log.i(f.c, "Country : " + property);
            } else {
                if (str != "currency") {
                    property = str;
                    return property;
                }
                property = this.c.getProperty("currency");
                Log.i(f.c, "Currency : " + property);
            }
            return property;
        } catch (Exception e2) {
            str2 = property;
            e = e2;
            e.printStackTrace();
            return str2;
        }
    }
}
