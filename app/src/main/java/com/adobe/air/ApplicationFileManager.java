package com.adobe.air;

import android.content.pm.PackageManager;
import android.os.Bundle;
import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.UUID;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;
import java.util.zip.ZipInputStream;

/* loaded from: classes.dex */
public final class ApplicationFileManager {
    private static final String APP_PREFIX = "app";
    private static final String APP_XML_PATH = "META-INF/AIR/application.xml";
    private static final String ASSET_STRING = "assets";
    public static String sAndroidPackageName;
    public static String sApkPath;
    public static String sAppDataPath;
    public static String sInitialContentName;
    private final int BUFFER_SIZE = 8192;
    private final int DEFAULT_SIZE = -1;
    private HashMap<Object, Object> mFileInfoMap = new HashMap<>();

    public static void setAndroidPackageName(String str) {
        sAndroidPackageName = str;
    }

    public static void setAndroidAPKPath(String str) {
        sApkPath = str;
    }

    private static void setAndroidDataPath(String str) {
        sAppDataPath = str;
    }

    public static String getAndroidApkPath() {
        return sApkPath;
    }

    public static String getAndroidAppDataPath() {
        return sAppDataPath;
    }

    public static String getAppXMLRoot() {
        return getAndroidUnzipContentPath() + File.separatorChar + APP_XML_PATH;
    }

    public static String getAppRoot() {
        return getAndroidUnzipContentPath() + File.separatorChar + ASSET_STRING;
    }

    public static String getAndroidUnzipContentPath() {
        return sAppDataPath;
    }

    private File getApkPathFile() {
        return new File(getAndroidApkPath());
    }

    private static void setInitialContentName(String str) {
        sInitialContentName = str;
    }

    ApplicationFileManager() throws IOException {
        procZipContents(getApkPathFile());
    }

    public static boolean deleteUnzippedContents(String str) {
        File file = new File(str);
        if (file.isDirectory()) {
            for (File file2 : file.listFiles()) {
                deleteUnzippedContents(file2.getAbsolutePath());
            }
        }
        return file.delete();
    }

    public void deleteFile(String str) {
        new File(str).delete();
    }

    public void procZipContents(File file) throws IOException {
        try {
            ZipFile zipFile = new ZipFile(file);
            Enumeration<? extends ZipEntry> enumerationEntries = zipFile.entries();
            while (enumerationEntries.hasMoreElements()) {
                ZipEntry zipEntryNextElement = enumerationEntries.nextElement();
                String name = zipEntryNextElement.getName();
                if (name.substring(0, ASSET_STRING.length()).equals(ASSET_STRING)) {
                    this.mFileInfoMap.put(name, new FileInfo(zipEntryNextElement.getSize(), true, false));
                    for (File file2 = new File(name); file2.getParent() != null && ((FileInfo) this.mFileInfoMap.get(file2.getParent())) == null; file2 = new File(file2.getParent())) {
                        this.mFileInfoMap.put(file2.getParent(), new FileInfo(-1L, false, true));
                    }
                }
            }
            zipFile.close();
        } catch (Exception e) {
        }
    }

    public boolean fileExists(String str) {
        return this.mFileInfoMap.containsKey(!str.equals("") ? new StringBuilder().append(ASSET_STRING).append(File.separator).append(str).toString() : ASSET_STRING);
    }

    public boolean isDirectory(String str) {
        FileInfo fileInfo = (FileInfo) this.mFileInfoMap.get(!str.equals("") ? ASSET_STRING + File.separator + str : ASSET_STRING);
        return fileInfo != null && fileInfo.mIsDirectory;
    }

    public long getLSize(String str) {
        FileInfo fileInfo = (FileInfo) this.mFileInfoMap.get(ASSET_STRING + File.separator + str);
        if (fileInfo == null || fileInfo.mFileSize == -1) {
            return 0L;
        }
        return fileInfo.mFileSize;
    }

    public boolean addToCache(String str) {
        return (sInitialContentName == null || str.indexOf(sInitialContentName) == -1) ? false : true;
    }

    public boolean readFileName(String str) throws Throwable {
        ZipFile zipFile;
        ZipFile zipFile2;
        String str2 = ASSET_STRING + File.separator + str;
        String str3 = getAndroidUnzipContentPath() + File.separatorChar;
        File file = new File(str3 + str2);
        if (file.exists()) {
            return true;
        }
        try {
            ZipFile zipFile3 = new ZipFile(getApkPathFile());
            try {
                Enumeration<? extends ZipEntry> enumerationEntries = zipFile3.entries();
                while (true) {
                    if (!enumerationEntries.hasMoreElements()) {
                        break;
                    }
                    ZipEntry zipEntryNextElement = enumerationEntries.nextElement();
                    String name = zipEntryNextElement.getName();
                    if (name.substring(0, ASSET_STRING.length()).equals(ASSET_STRING)) {
                        if (name.equals(str2)) {
                            InputStream inputStream = zipFile3.getInputStream(zipEntryNextElement);
                            new File(file.getParent()).mkdirs();
                            BufferedOutputStream bufferedOutputStream = new BufferedOutputStream(new FileOutputStream(file), 8192);
                            byte[] bArr = new byte[8192];
                            while (true) {
                                int i = inputStream.read(bArr);
                                if (i == -1) {
                                    break;
                                }
                                bufferedOutputStream.write(bArr, 0, i);
                            }
                            closeInputStream(inputStream);
                            closeOutputStream(bufferedOutputStream);
                        } else if (name.startsWith(str2 + "/")) {
                            new File(str3 + str2).mkdirs();
                            break;
                        }
                    }
                }
                if (zipFile3 != null) {
                    try {
                        zipFile3.close();
                    } catch (Exception e) {
                    }
                }
            } catch (Exception e2) {
                zipFile2 = zipFile3;
                if (zipFile2 != null) {
                    try {
                        zipFile2.close();
                    } catch (Exception e3) {
                    }
                }
                return true;
            } catch (Throwable th) {
                th = th;
                zipFile = zipFile3;
                if (zipFile != null) {
                    try {
                        zipFile.close();
                    } catch (Exception e4) {
                    }
                }
                throw th;
            }
        } catch (Exception e5) {
            zipFile2 = null;
        } catch (Throwable th2) {
            th = th2;
            zipFile = null;
        }
        return true;
    }

    public void copyFolder(String str) throws IOException {
        String str2 = !str.equals("") ? ASSET_STRING + File.separator + str : ASSET_STRING;
        String str3 = getAndroidUnzipContentPath() + File.separatorChar;
        try {
            ZipInputStream zipInputStream = new ZipInputStream(new BufferedInputStream(new FileInputStream(getApkPathFile()), 8192));
            while (true) {
                ZipEntry nextEntry = zipInputStream.getNextEntry();
                if (nextEntry != null) {
                    String name = nextEntry.getName();
                    if (name.substring(0, ASSET_STRING.length()).equals(ASSET_STRING) && name.startsWith(str2)) {
                        File file = new File(str3 + name);
                        new File(file.getParent()).mkdirs();
                        BufferedOutputStream bufferedOutputStream = new BufferedOutputStream(new FileOutputStream(file), 8192);
                        byte[] bArr = new byte[8192];
                        while (true) {
                            int i = zipInputStream.read(bArr, 0, 8192);
                            if (i == -1) {
                                break;
                            } else {
                                bufferedOutputStream.write(bArr, 0, i);
                            }
                        }
                        closeOutputStream(bufferedOutputStream);
                    }
                } else {
                    closeInputStream(zipInputStream);
                    return;
                }
            }
        } catch (Exception e) {
        }
    }

    public String[] appDirectoryNameList(String str) {
        String str2 = !str.equals("") ? ASSET_STRING + File.separator + str : ASSET_STRING;
        Iterator<Object> it = this.mFileInfoMap.keySet().iterator();
        ArrayList arrayList = new ArrayList();
        while (it.hasNext()) {
            String str3 = (String) it.next();
            if (!str3.equals(str2) && str3.startsWith(str2) && -1 == str3.indexOf(File.separator, str2.length() + 1)) {
                arrayList.add(str3.substring(str2.length() + 1));
            }
        }
        return (String[]) arrayList.toArray(new String[0]);
    }

    public boolean[] appDirectoryTypeList(String str) {
        String str2 = !str.equals("") ? ASSET_STRING + File.separator + str : ASSET_STRING;
        Iterator<Object> it = this.mFileInfoMap.keySet().iterator();
        ArrayList arrayList = new ArrayList();
        while (it.hasNext()) {
            String str3 = (String) it.next();
            if (!str3.equals(str2) && str3.startsWith(str2) && -1 == str3.indexOf(File.separator, str2.length() + 1)) {
                arrayList.add(new Boolean(((FileInfo) this.mFileInfoMap.get(str3)).mIsFile));
            }
        }
        boolean[] zArr = new boolean[arrayList.size()];
        for (int i = 0; i < zArr.length; i++) {
            zArr[i] = ((Boolean) arrayList.get(i)).booleanValue();
        }
        return zArr;
    }

    private static void RefreshAppCache(String str, String str2) {
        if (!new File(str + File.separator + str2).exists()) {
            deleteDir(new File(str));
        }
    }

    public static boolean deleteDir(File file) {
        if (file.isDirectory()) {
            for (File file2 : file.listFiles()) {
                if (!deleteDir(file2)) {
                    return false;
                }
            }
        }
        return file.delete();
    }

    public static void processAndroidDataPath(String str) {
        String str2;
        String str3 = str + File.separator + APP_PREFIX;
        String str4 = null;
        try {
            Bundle bundle = AndroidActivityWrapper.GetAndroidActivityWrapper().getActivity().getPackageManager().getActivityInfo(AndroidActivityWrapper.GetAndroidActivityWrapper().getActivity().getComponentName(), 128).metaData;
            if (bundle != null) {
                String str5 = (String) bundle.get("uniqueappversionid");
                try {
                    String string = AndroidActivityWrapper.IsGamePreviewMode() ? UUID.randomUUID().toString() : str5;
                    try {
                        RefreshAppCache(str3, string);
                        str4 = (String) bundle.get("initialcontent");
                        str2 = string;
                    } catch (PackageManager.NameNotFoundException e) {
                        str2 = string;
                    } catch (NullPointerException e2) {
                        str2 = string;
                    }
                } catch (PackageManager.NameNotFoundException e3) {
                    str2 = str5;
                } catch (NullPointerException e4) {
                    str2 = str5;
                }
            } else {
                str2 = APP_PREFIX;
            }
        } catch (PackageManager.NameNotFoundException e5) {
            str2 = APP_PREFIX;
        } catch (NullPointerException e6) {
            str2 = APP_PREFIX;
        }
        setAndroidDataPath(str3 + File.separator + str2);
        new File(str3 + File.separator + str2).mkdirs();
        setInitialContentName(str4);
    }

    private void closeInputStream(InputStream inputStream) throws Exception {
        inputStream.close();
    }

    private void closeOutputStream(OutputStream outputStream) throws Exception {
        outputStream.flush();
        outputStream.close();
    }

    public static void checkAndCreateAppDataDir() {
        File file = new File(sAppDataPath);
        if (!file.exists()) {
            try {
                file.mkdirs();
            } catch (SecurityException e) {
            }
        }
    }
}
