package com.adobe.air.utils;

import android.content.Context;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.content.res.Resources;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.os.Environment;
import android.os.Process;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.lang.reflect.Field;
import java.util.HashMap;
import java.util.Scanner;

/* loaded from: classes.dex */
public class Utils {
    private static String sRuntimePackageName;

    public static native boolean nativeConnectDebuggerSocket(String str);

    public static String getRuntimePackageName() {
        return sRuntimePackageName;
    }

    public static void setRuntimePackageName(String str) {
        sRuntimePackageName = str;
    }

    public static boolean hasCaptiveRuntime() {
        return !"com.adobe.air".equals(sRuntimePackageName);
    }

    static void KillProcess() {
        Process.killProcess(Process.myPid());
    }

    public static boolean writeStringToFile(String str, String str2) throws IOException {
        File file = new File(str2);
        if (!file.exists()) {
            try {
                file.createNewFile();
            } catch (IOException e) {
                return false;
            }
        }
        byte[] bytes = str.getBytes();
        try {
            FileOutputStream fileOutputStream = new FileOutputStream(file);
            fileOutputStream.write(bytes, 0, bytes.length);
            fileOutputStream.close();
            return true;
        } catch (IOException e2) {
            return false;
        }
    }

    public static void writeOut(InputStream inputStream, File file) throws IOException {
        FileOutputStream fileOutputStream = new FileOutputStream(file);
        writeThrough(inputStream, fileOutputStream);
        fileOutputStream.close();
    }

    public static void writeThrough(InputStream inputStream, OutputStream outputStream) throws IOException {
        byte[] bArr = new byte[4096];
        while (true) {
            int i = inputStream.read(bArr);
            if (i != -1) {
                if (outputStream != null) {
                    outputStream.write(bArr, 0, i);
                    outputStream.flush();
                }
            } else {
                return;
            }
        }
    }

    public static void copyTo(File file, File file2) throws IOException {
        if (file.isDirectory()) {
            file2.mkdirs();
            for (File file3 : file.listFiles()) {
                copyTo(file3, new File(file2, file3.getName()));
            }
            return;
        }
        FileInputStream fileInputStream = new FileInputStream(file);
        FileOutputStream fileOutputStream = new FileOutputStream(file2);
        copyTo(fileInputStream, fileOutputStream);
        fileInputStream.close();
        fileOutputStream.close();
    }

    public static void copyTo(InputStream inputStream, OutputStream outputStream) throws IOException {
        byte[] bArr = new byte[1024];
        while (true) {
            int i = inputStream.read(bArr);
            if (i > 0) {
                outputStream.write(bArr, 0, i);
            } else {
                return;
            }
        }
    }

    public static void writeBufferToFile(StringBuffer stringBuffer, File file) throws IOException {
        FileWriter fileWriter = new FileWriter(file);
        fileWriter.write(stringBuffer.toString());
        fileWriter.close();
    }

    public static HashMap<String, String> parseKeyValuePairFile(File file, String str) throws IllegalStateException, FileNotFoundException {
        return parseKeyValuePairFile(new FileInputStream(file), str);
    }

    public static HashMap<String, String> parseKeyValuePairFile(InputStream inputStream, String str) throws IllegalStateException {
        HashMap<String, String> map = new HashMap<>();
        Scanner scanner = new Scanner(inputStream);
        while (scanner.hasNextLine()) {
            Scanner scanner2 = new Scanner(scanner.nextLine());
            scanner2.useDelimiter(str);
            if (scanner2.hasNext()) {
                map.put(scanner2.next().trim(), scanner2.next().trim());
            }
            scanner2.close();
        }
        scanner.close();
        return map;
    }

    public static void writeStringToFile(String str, File file) throws IOException {
        FileWriter fileWriter = new FileWriter(file);
        fileWriter.write(str);
        fileWriter.close();
    }

    public static String ReplaceTextContentWithStars(String str) {
        int length = str.length();
        char[] cArr = new char[length];
        for (int i = 0; i < length; i++) {
            cArr[i] = '*';
        }
        return new String(cArr);
    }

    public static String GetResourceStringFromRuntime(String str, Resources resources) {
        return resources.getString(resources.getIdentifier(str, "string", sRuntimePackageName));
    }

    public static View GetWidgetInViewByName(String str, Resources resources, View view) {
        return view.findViewById(resources.getIdentifier(str, "id", sRuntimePackageName));
    }

    public static View GetLayoutViewFromRuntime(String str, Resources resources, LayoutInflater layoutInflater) {
        int identifier = resources.getIdentifier(str, "layout", sRuntimePackageName);
        if (identifier != 0) {
            return layoutInflater.inflate(identifier, (ViewGroup) null);
        }
        return null;
    }

    public static String GetExternalStorageDirectory() {
        return Environment.getExternalStorageDirectory().getAbsolutePath();
    }

    public static String GetSharedDataDirectory() {
        return Environment.getDataDirectory().getAbsolutePath();
    }

    public static String GetLibCorePath(Context context) {
        return GetNativeLibraryPath(context, "libCore.so");
    }

    public static String GetLibSTLPath(Context context) {
        return GetNativeLibraryPath(context, "libstlport_shared.so");
    }

    public static String GetNativeLibraryPath(Context context, String str) throws NoSuchFieldException, PackageManager.NameNotFoundException {
        String strConcat = null;
        try {
            ApplicationInfo applicationInfo = context.getPackageManager().getApplicationInfo(sRuntimePackageName, 0);
            Field field = ApplicationInfo.class.getField("nativeLibraryDir");
            Field field2 = ApplicationInfo.class.getField("sourceDir");
            if (field != null) {
                if (((String) field2.get(applicationInfo)).startsWith("/system/app/")) {
                    strConcat = new String("/system/lib/" + sRuntimePackageName + "/" + str);
                } else {
                    strConcat = ((String) field.get(applicationInfo)).concat("/" + str);
                }
            }
        } catch (Exception e) {
        }
        if (strConcat == null) {
            return new String("/data/data/" + sRuntimePackageName + "/lib/" + str);
        }
        return strConcat;
    }

    public static String GetNativeExtensionPath(Context context, String str) throws NoSuchFieldException, PackageManager.NameNotFoundException {
        String str2;
        try {
            ApplicationInfo applicationInfo = context.getPackageManager().getApplicationInfo(sRuntimePackageName, 0);
            Field field = ApplicationInfo.class.getField("nativeLibraryDir");
            Field field2 = ApplicationInfo.class.getField("sourceDir");
            if (field == null) {
                str2 = null;
            } else if (((String) field2.get(applicationInfo)).startsWith("/system/app/")) {
                str2 = new String("/system/lib/" + sRuntimePackageName + "/" + str);
            } else {
                str2 = new String("/data/data/" + context.getPackageName() + "/lib/" + str);
            }
        } catch (Exception e) {
            str2 = null;
        }
        if (str2 == null) {
            return new String("/data/data/" + sRuntimePackageName + "/lib/" + str);
        }
        return str2;
    }

    /* JADX WARN: Removed duplicated region for block: B:12:0x0027  */
    /* JADX WARN: Removed duplicated region for block: B:59:? A[RETURN, SYNTHETIC] */
    /*
        Code decompiled incorrectly, please refer to instructions dump.
        To view partially-correct code enable 'Show inconsistent code' option in preferences
    */
    public static java.lang.String GetTelemetrySettings(android.content.Context r5, java.lang.String r6, java.lang.String r7) throws java.lang.Throwable {
        /*
            r3 = 0
            android.content.res.Resources r0 = r5.getResources()     // Catch: java.lang.Exception -> L3f java.lang.Throwable -> L51
            android.content.res.AssetManager r0 = r0.getAssets()     // Catch: java.lang.Exception -> L3f java.lang.Throwable -> L51
            r1 = 1
            java.io.InputStream r0 = r0.open(r6, r1)     // Catch: java.lang.Exception -> L3f java.lang.Throwable -> L51
            java.io.ByteArrayOutputStream r1 = new java.io.ByteArrayOutputStream     // Catch: java.lang.Throwable -> L63 java.lang.Exception -> L6f
            r1.<init>()     // Catch: java.lang.Throwable -> L63 java.lang.Exception -> L6f
            copyTo(r0, r1)     // Catch: java.lang.Throwable -> L69 java.lang.Exception -> L72
            java.lang.String r2 = r1.toString()     // Catch: java.lang.Throwable -> L69 java.lang.Exception -> L72
            if (r0 == 0) goto L1f
            r0.close()     // Catch: java.lang.Exception -> L3c
        L1f:
            if (r1 == 0) goto L24
            r1.close()     // Catch: java.lang.Exception -> L3c
        L24:
            r0 = r2
        L25:
            if (r0 != 0) goto L3b
            r1 = 0
            android.content.Context r1 = r5.createPackageContext(r7, r1)     // Catch: java.lang.Exception -> L5f
            java.lang.String r2 = "telemetry"
            r3 = 1
            android.content.SharedPreferences r1 = r1.getSharedPreferences(r2, r3)     // Catch: java.lang.Exception -> L5f
            java.lang.String r2 = "content"
            java.lang.String r3 = ""
            java.lang.String r0 = r1.getString(r2, r3)     // Catch: java.lang.Exception -> L5f
        L3b:
            return r0
        L3c:
            r0 = move-exception
            r0 = r2
            goto L25
        L3f:
            r0 = move-exception
            r0 = r3
            r1 = r3
        L42:
            if (r0 == 0) goto L47
            r0.close()     // Catch: java.lang.Exception -> L4e
        L47:
            if (r1 == 0) goto L4c
            r1.close()     // Catch: java.lang.Exception -> L4e
        L4c:
            r0 = r3
            goto L25
        L4e:
            r0 = move-exception
            r0 = r3
            goto L25
        L51:
            r0 = move-exception
            r1 = r3
            r2 = r3
        L54:
            if (r1 == 0) goto L59
            r1.close()     // Catch: java.lang.Exception -> L61
        L59:
            if (r2 == 0) goto L5e
            r2.close()     // Catch: java.lang.Exception -> L61
        L5e:
            throw r0
        L5f:
            r1 = move-exception
            goto L3b
        L61:
            r1 = move-exception
            goto L5e
        L63:
            r1 = move-exception
            r2 = r3
            r4 = r0
            r0 = r1
            r1 = r4
            goto L54
        L69:
            r2 = move-exception
            r4 = r2
            r2 = r1
            r1 = r0
            r0 = r4
            goto L54
        L6f:
            r1 = move-exception
            r1 = r3
            goto L42
        L72:
            r2 = move-exception
            goto L42
        */
        throw new UnsupportedOperationException("Method not decompiled: com.adobe.air.utils.Utils.GetTelemetrySettings(android.content.Context, java.lang.String, java.lang.String):java.lang.String");
    }

    public static boolean isNetworkAvailable(Context context) {
        NetworkInfo activeNetworkInfo = ((ConnectivityManager) context.getSystemService("connectivity")).getActiveNetworkInfo();
        if (activeNetworkInfo == null || !activeNetworkInfo.isConnected()) {
            return false;
        }
        return true;
    }
}
