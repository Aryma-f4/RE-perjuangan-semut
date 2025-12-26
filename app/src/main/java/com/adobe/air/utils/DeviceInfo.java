package com.adobe.air.utils;

import java.io.IOException;
import java.io.InputStream;

/* loaded from: classes.dex */
public class DeviceInfo {
    static String getHardwareInfo() throws IOException {
        byte[] bArr;
        InputStream inputStream;
        int i;
        String str;
        int iIndexOf;
        int iIndexOf2;
        try {
            bArr = new byte[1024];
            inputStream = new ProcessBuilder("/system/bin/cat", "/proc/cpuinfo").start().getInputStream();
            i = inputStream.read(bArr, 0, 1024);
        } catch (IOException e) {
        }
        if (i >= 0 && (iIndexOf = (str = new String(bArr, 0, i)).indexOf("Hardware")) >= 0 && (iIndexOf2 = str.indexOf(58, iIndexOf)) >= 0) {
            return str.substring(iIndexOf2 + 1, str.indexOf(10, iIndexOf2 + 1)).trim();
        }
        inputStream.close();
        return new String("");
    }

    static String getTotalMemory() throws IOException {
        byte[] bArr;
        InputStream inputStream;
        int i;
        String str;
        int iIndexOf;
        int iIndexOf2;
        try {
            bArr = new byte[1024];
            inputStream = new ProcessBuilder("/system/bin/cat", "/proc/meminfo").start().getInputStream();
            i = inputStream.read(bArr, 0, 1024);
        } catch (IOException e) {
        }
        if (i >= 0 && (iIndexOf = (str = new String(bArr, 0, i)).indexOf("MemTotal")) >= 0 && (iIndexOf2 = str.indexOf(58, iIndexOf)) >= 0) {
            return str.substring(iIndexOf2 + 1, str.indexOf(10, iIndexOf2 + 1)).trim();
        }
        inputStream.close();
        return new String("");
    }

    static String getCPUCount() throws IOException {
        byte[] bArr;
        InputStream inputStream;
        int i;
        try {
            bArr = new byte[1024];
            inputStream = new ProcessBuilder("/system/bin/cat", "/sys/devices/system/cpu/present").start().getInputStream();
            i = inputStream.read(bArr, 0, 1024);
        } catch (IOException e) {
        }
        if (i >= 0) {
            String str = new String(bArr, 0, i);
            int iIndexOf = str.indexOf("-");
            if (iIndexOf >= 0) {
                return Integer.toString(Integer.parseInt(str.substring(iIndexOf + 1, iIndexOf + 2)) + 1);
            }
            return Integer.toString(Integer.parseInt(str.substring(0, 1)) + 1);
        }
        inputStream.close();
        return new String("");
    }
}
