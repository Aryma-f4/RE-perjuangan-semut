package com.facebook.internal;

import android.content.Context;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Bundle;
import android.os.Parcelable;
import android.provider.Settings;
import android.text.TextUtils;
import android.util.Log;
import android.webkit.CookieManager;
import android.webkit.CookieSyncManager;
import com.facebook.FacebookException;
import com.facebook.Request;
import com.facebook.Session;
import com.facebook.model.GraphObject;
import java.io.BufferedInputStream;
import java.io.Closeable;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URLConnection;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.json.JSONTokener;

/* loaded from: classes.dex */
public final class Utility {
    private static final String APPLICATION_FIELDS = "fields";
    public static final int DEFAULT_STREAM_BUFFER_SIZE = 8192;
    private static final String HASH_ALGORITHM_MD5 = "MD5";
    private static final String HASH_ALGORITHM_SHA1 = "SHA-1";
    static final String LOG_TAG = "FacebookSDK";
    private static final String URL_SCHEME = "https";
    private static final String SUPPORTS_ATTRIBUTION = "supports_attribution";
    private static final String SUPPORTS_IMPLICIT_SDK_LOGGING = "supports_implicit_sdk_logging";
    private static final String[] APP_SETTING_FIELDS = {SUPPORTS_ATTRIBUTION, SUPPORTS_IMPLICIT_SDK_LOGGING};
    private static Map<String, FetchedAppSettings> fetchedAppSettings = new ConcurrentHashMap();

    public static class FetchedAppSettings {
        private boolean supportsAttribution;
        private boolean supportsImplicitLogging;

        private FetchedAppSettings(boolean z, boolean z2) {
            this.supportsAttribution = z;
            this.supportsImplicitLogging = z2;
        }

        public boolean supportsAttribution() {
            return this.supportsAttribution;
        }

        public boolean supportsImplicitLogging() {
            return this.supportsImplicitLogging;
        }
    }

    public static <T> boolean areObjectsEqual(T t, T t2) {
        return t == null ? t2 == null : t.equals(t2);
    }

    public static <T> ArrayList<T> arrayList(T... tArr) {
        ArrayList<T> arrayList = new ArrayList<>(tArr.length);
        for (T t : tArr) {
            arrayList.add(t);
        }
        return arrayList;
    }

    public static <T> List<T> asListNoNulls(T... tArr) {
        ArrayList arrayList = new ArrayList();
        for (T t : tArr) {
            if (t != null) {
                arrayList.add(t);
            }
        }
        return arrayList;
    }

    public static Uri buildUri(String str, String str2, Bundle bundle) {
        Uri.Builder builder = new Uri.Builder();
        builder.scheme(URL_SCHEME);
        builder.authority(str);
        builder.path(str2);
        for (String str3 : bundle.keySet()) {
            Object obj = bundle.get(str3);
            if (obj instanceof String) {
                builder.appendQueryParameter(str3, (String) obj);
            }
        }
        return builder.build();
    }

    public static void clearCaches(Context context) {
        ImageDownloader.clearCache(context);
    }

    private static void clearCookiesForDomain(Context context, String str) {
        CookieSyncManager.createInstance(context).sync();
        CookieManager cookieManager = CookieManager.getInstance();
        String cookie = cookieManager.getCookie(str);
        if (cookie == null) {
            return;
        }
        for (String str2 : cookie.split(";")) {
            String[] strArrSplit = str2.split("=");
            if (strArrSplit.length > 0) {
                cookieManager.setCookie(str, strArrSplit[0].trim() + "=;expires=Sat, 1 Jan 2000 00:00:01 UTC;");
            }
        }
        cookieManager.removeExpiredCookie();
    }

    public static void clearFacebookCookies(Context context) {
        clearCookiesForDomain(context, "facebook.com");
        clearCookiesForDomain(context, ".facebook.com");
        clearCookiesForDomain(context, "https://facebook.com");
        clearCookiesForDomain(context, "https://.facebook.com");
    }

    public static void closeQuietly(Closeable closeable) throws IOException {
        if (closeable != null) {
            try {
                closeable.close();
            } catch (IOException e) {
            }
        }
    }

    static Map<String, Object> convertJSONObjectToHashMap(JSONObject jSONObject) throws JSONException {
        HashMap map = new HashMap();
        JSONArray jSONArrayNames = jSONObject.names();
        int i = 0;
        while (true) {
            int i2 = i;
            if (i2 >= jSONArrayNames.length()) {
                return map;
            }
            try {
                String string = jSONArrayNames.getString(i2);
                Object objConvertJSONObjectToHashMap = jSONObject.get(string);
                if (objConvertJSONObjectToHashMap instanceof JSONObject) {
                    objConvertJSONObjectToHashMap = convertJSONObjectToHashMap((JSONObject) objConvertJSONObjectToHashMap);
                }
                map.put(string, objConvertJSONObjectToHashMap);
            } catch (JSONException e) {
            }
            i = i2 + 1;
        }
    }

    public static void deleteDirectory(File file) {
        if (file.exists()) {
            if (file.isDirectory()) {
                for (File file2 : file.listFiles()) {
                    deleteDirectory(file2);
                }
            }
            file.delete();
        }
    }

    public static void disconnectQuietly(URLConnection uRLConnection) {
        if (uRLConnection instanceof HttpURLConnection) {
            ((HttpURLConnection) uRLConnection).disconnect();
        }
    }

    public static String getHashedDeviceAndAppID(Context context, String str) {
        String string = Settings.Secure.getString(context.getContentResolver(), "android_id");
        if (string == null) {
            return null;
        }
        return sha1hash(string + str);
    }

    public static String getMetadataApplicationId(Context context) throws PackageManager.NameNotFoundException {
        Validate.notNull(context, "context");
        try {
            ApplicationInfo applicationInfo = context.getPackageManager().getApplicationInfo(context.getPackageName(), 128);
            if (applicationInfo.metaData != null) {
                return applicationInfo.metaData.getString(Session.APPLICATION_ID_PROPERTY);
            }
        } catch (PackageManager.NameNotFoundException e) {
        }
        return null;
    }

    public static Object getStringPropertyAsJSON(JSONObject jSONObject, String str, String str2) throws JSONException {
        Object objOpt = jSONObject.opt(str);
        Object objNextValue = (objOpt == null || !(objOpt instanceof String)) ? objOpt : new JSONTokener((String) objOpt).nextValue();
        if (objNextValue == null || (objNextValue instanceof JSONObject) || (objNextValue instanceof JSONArray)) {
            return objNextValue;
        }
        if (str2 == null) {
            throw new FacebookException("Got an unexpected non-JSON object.");
        }
        JSONObject jSONObject2 = new JSONObject();
        jSONObject2.putOpt(str2, objNextValue);
        return jSONObject2;
    }

    private static String hashWithAlgorithm(String str, String str2) throws NoSuchAlgorithmException {
        try {
            MessageDigest messageDigest = MessageDigest.getInstance(str);
            messageDigest.update(str2.getBytes());
            byte[] bArrDigest = messageDigest.digest();
            StringBuilder sb = new StringBuilder();
            for (byte b : bArrDigest) {
                sb.append(Integer.toHexString((b >> 4) & 15));
                sb.append(Integer.toHexString((b >> 0) & 15));
            }
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            return null;
        }
    }

    public static boolean isNullOrEmpty(String str) {
        return str == null || str.length() == 0;
    }

    public static <T> boolean isNullOrEmpty(Collection<T> collection) {
        return collection == null || collection.size() == 0;
    }

    public static <T> boolean isSubset(Collection<T> collection, Collection<T> collection2) {
        if (collection2 == null || collection2.size() == 0) {
            return collection == null || collection.size() == 0;
        }
        HashSet hashSet = new HashSet(collection2);
        Iterator<T> it = collection.iterator();
        while (it.hasNext()) {
            if (!hashSet.contains(it.next())) {
                return false;
            }
        }
        return true;
    }

    public static void logd(String str, Exception exc) {
        if (str == null || exc == null) {
            return;
        }
        Log.d(str, exc.getClass().getSimpleName() + ": " + exc.getMessage());
    }

    public static void logd(String str, String str2) {
        if (str == null || str2 == null) {
            return;
        }
        Log.d(str, str2);
    }

    static String md5hash(String str) {
        return hashWithAlgorithm(HASH_ALGORITHM_MD5, str);
    }

    public static void putObjectInBundle(Bundle bundle, String str, Object obj) {
        if (obj instanceof String) {
            bundle.putString(str, (String) obj);
        } else if (obj instanceof Parcelable) {
            bundle.putParcelable(str, (Parcelable) obj);
        } else {
            if (!(obj instanceof byte[])) {
                throw new FacebookException("attempted to add unsupported type to Bundle");
            }
            bundle.putByteArray(str, (byte[]) obj);
        }
    }

    public static FetchedAppSettings queryAppSettings(String str, boolean z) {
        if (!z && fetchedAppSettings.containsKey(str)) {
            return fetchedAppSettings.get(str);
        }
        Bundle bundle = new Bundle();
        bundle.putString(APPLICATION_FIELDS, TextUtils.join(",", APP_SETTING_FIELDS));
        Request requestNewGraphPathRequest = Request.newGraphPathRequest(null, str, null);
        requestNewGraphPathRequest.setParameters(bundle);
        GraphObject graphObject = requestNewGraphPathRequest.executeAndWait().getGraphObject();
        FetchedAppSettings fetchedAppSettings2 = new FetchedAppSettings(safeGetBooleanFromResponse(graphObject, SUPPORTS_ATTRIBUTION), safeGetBooleanFromResponse(graphObject, SUPPORTS_IMPLICIT_SDK_LOGGING));
        fetchedAppSettings.put(str, fetchedAppSettings2);
        return fetchedAppSettings2;
    }

    public static String readStreamToString(InputStream inputStream) throws Throwable {
        InputStreamReader inputStreamReader;
        BufferedInputStream bufferedInputStream;
        BufferedInputStream bufferedInputStream2 = null;
        try {
            bufferedInputStream = new BufferedInputStream(inputStream);
            try {
                inputStreamReader = new InputStreamReader(bufferedInputStream);
            } catch (Throwable th) {
                inputStreamReader = null;
                bufferedInputStream2 = bufferedInputStream;
                th = th;
            }
        } catch (Throwable th2) {
            th = th2;
            inputStreamReader = null;
        }
        try {
            StringBuilder sb = new StringBuilder();
            char[] cArr = new char[2048];
            while (true) {
                int i = inputStreamReader.read(cArr);
                if (i == -1) {
                    String string = sb.toString();
                    closeQuietly(bufferedInputStream);
                    closeQuietly(inputStreamReader);
                    return string;
                }
                sb.append(cArr, 0, i);
            }
        } catch (Throwable th3) {
            bufferedInputStream2 = bufferedInputStream;
            th = th3;
            closeQuietly(bufferedInputStream2);
            closeQuietly(inputStreamReader);
            throw th;
        }
    }

    private static boolean safeGetBooleanFromResponse(GraphObject graphObject, String str) {
        Object property = graphObject != null ? graphObject.getProperty(str) : false;
        return ((Boolean) (!(property instanceof Boolean) ? false : property)).booleanValue();
    }

    public static void setAppEventAttributionParameters(GraphObject graphObject, String str, String str2, boolean z) {
        if (str != null) {
            graphObject.setProperty("attribution", str);
        } else if (str2 != null) {
            graphObject.setProperty("advertiser_id", str2);
        }
        graphObject.setProperty("application_tracking_enabled", Boolean.valueOf(!z));
    }

    private static String sha1hash(String str) {
        return hashWithAlgorithm(HASH_ALGORITHM_SHA1, str);
    }

    public static boolean stringsEqualOrEmpty(String str, String str2) {
        boolean zIsEmpty = TextUtils.isEmpty(str);
        boolean zIsEmpty2 = TextUtils.isEmpty(str2);
        if (zIsEmpty && zIsEmpty2) {
            return true;
        }
        if (zIsEmpty || zIsEmpty2) {
            return false;
        }
        return str.equals(str2);
    }

    public static <T> Collection<T> unmodifiableCollection(T... tArr) {
        return Collections.unmodifiableCollection(Arrays.asList(tArr));
    }
}
