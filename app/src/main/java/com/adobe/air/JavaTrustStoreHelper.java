package com.adobe.air;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.RandomAccessFile;
import java.security.KeyStore;
import java.security.KeyStoreException;
import java.security.NoSuchAlgorithmException;
import java.security.cert.CertificateEncodingException;
import java.security.cert.CertificateException;
import java.security.cert.CertificateFactory;
import java.security.cert.X509Certificate;
import javax.net.ssl.TrustManager;
import javax.net.ssl.TrustManagerFactory;
import javax.net.ssl.X509TrustManager;

/* loaded from: classes.dex */
public final class JavaTrustStoreHelper {
    private static final String LOG_TAG = "JavaTrustStoreHelper";
    private static SystemKeyStoreManager mSystemKeyStoreMgr = initSystemKeyStoreMgr();

    private interface SystemKeyStoreManager {
        KeyStore getKeyStore();

        long getTimestamp();
    }

    private static class SystemKeyStoreManager_stub implements SystemKeyStoreManager {
        private SystemKeyStoreManager_stub() {
        }

        @Override // com.adobe.air.JavaTrustStoreHelper.SystemKeyStoreManager
        public KeyStore getKeyStore() {
            return null;
        }

        @Override // com.adobe.air.JavaTrustStoreHelper.SystemKeyStoreManager
        public long getTimestamp() {
            return 0L;
        }
    }

    private static class SystemKeyStoreManager_sysprop implements SystemKeyStoreManager {
        private static final String kTheProp = "javax.net.ssl.trustStore";

        private SystemKeyStoreManager_sysprop() {
        }

        public static boolean isValid() {
            return System.getProperty(kTheProp) != null;
        }

        @Override // com.adobe.air.JavaTrustStoreHelper.SystemKeyStoreManager
        public KeyStore getKeyStore() throws NoSuchAlgorithmException, IOException, KeyStoreException, CertificateException {
            File file;
            try {
                KeyStore keyStore = KeyStore.getInstance(KeyStore.getDefaultType());
                String property = System.getProperty(kTheProp);
                if (property != null && (file = new File(property)) != null) {
                    keyStore.load(new FileInputStream(file), null);
                    return keyStore;
                }
                return null;
            } catch (Exception e) {
                return null;
            }
        }

        @Override // com.adobe.air.JavaTrustStoreHelper.SystemKeyStoreManager
        public long getTimestamp() {
            return new File(System.getProperty(kTheProp)).lastModified();
        }
    }

    private static class SystemKeyStoreManager_files implements SystemKeyStoreManager {
        private static final String kDirectoryPath = "/system/etc/security/cacerts";
        private int mNumFilesWhenCreated;

        private SystemKeyStoreManager_files() {
            this.mNumFilesWhenCreated = -1;
        }

        public static boolean isValid() {
            return new File(kDirectoryPath).exists();
        }

        @Override // com.adobe.air.JavaTrustStoreHelper.SystemKeyStoreManager
        public long getTimestamp() {
            String[] fileListing = getFileListing();
            if (this.mNumFilesWhenCreated != -1 && fileListing.length != this.mNumFilesWhenCreated) {
                return Long.MAX_VALUE;
            }
            long jMax = 0;
            for (String str : fileListing) {
                jMax = Math.max(new File("/system/etc/security/cacerts/" + str).lastModified(), jMax);
            }
            return jMax;
        }

        private static String[] getFileListing() {
            return new File(kDirectoryPath).list();
        }

        @Override // com.adobe.air.JavaTrustStoreHelper.SystemKeyStoreManager
        public KeyStore getKeyStore() throws NoSuchAlgorithmException, IOException, KeyStoreException, CertificateException {
            try {
                KeyStore keyStore = KeyStore.getInstance(KeyStore.getDefaultType());
                keyStore.load(null);
                CertificateFactory certificateFactory = CertificateFactory.getInstance("X.509");
                String[] fileListing = getFileListing();
                this.mNumFilesWhenCreated = fileListing.length;
                for (int i = 0; i < fileListing.length; i++) {
                    keyStore.setCertificateEntry(String.valueOf(i), certificateFactory.generateCertificate(new FileInputStream(new File("/system/etc/security/cacerts/" + fileListing[i]))));
                }
                return keyStore;
            } catch (Exception e) {
                this.mNumFilesWhenCreated = -1;
                return null;
            }
        }
    }

    private static boolean isAirCertBundleStale(String str) {
        File file = new File(str);
        return !file.exists() || mSystemKeyStoreMgr.getTimestamp() > file.lastModified();
    }

    private static SystemKeyStoreManager initSystemKeyStoreMgr() {
        if (SystemKeyStoreManager_sysprop.isValid()) {
            return new SystemKeyStoreManager_sysprop();
        }
        if (SystemKeyStoreManager_files.isValid()) {
            return new SystemKeyStoreManager_files();
        }
        return new SystemKeyStoreManager_stub();
    }

    private static long getTrustStoreTimestamp() {
        return mSystemKeyStoreMgr.getTimestamp();
    }

    private static TrustManagerFactory getX509TrustManagerFactory() throws NoSuchAlgorithmException, KeyStoreException {
        try {
            TrustManagerFactory trustManagerFactory = TrustManagerFactory.getInstance("X509");
            trustManagerFactory.init(mSystemKeyStoreMgr.getKeyStore());
            return trustManagerFactory;
        } catch (Exception e) {
            return null;
        }
    }

    private static X509TrustManager getX509TrustManager() throws NoSuchAlgorithmException, KeyStoreException {
        TrustManagerFactory x509TrustManagerFactory = getX509TrustManagerFactory();
        if (x509TrustManagerFactory != null) {
            TrustManager[] trustManagers = x509TrustManagerFactory.getTrustManagers();
            for (int i = 0; i < trustManagers.length; i++) {
                if (trustManagers[i] instanceof X509TrustManager) {
                    return (X509TrustManager) trustManagers[i];
                }
            }
        }
        return null;
    }

    public static void copyTimestamp(String str, String str2) {
        try {
            new File(str2).setLastModified(new File(str).lastModified());
        } catch (IllegalArgumentException e) {
        } catch (SecurityException e2) {
        }
    }

    private static int dumpAcceptedIssuersToFile(X509TrustManager x509TrustManager, RandomAccessFile randomAccessFile) throws IOException, CertificateEncodingException {
        X509Certificate[] acceptedIssuers = x509TrustManager.getAcceptedIssuers();
        for (X509Certificate x509Certificate : acceptedIssuers) {
            byte[] encoded = x509Certificate.getEncoded();
            randomAccessFile.writeInt(encoded.length);
            randomAccessFile.write(encoded);
        }
        randomAccessFile.getFD().sync();
        return acceptedIssuers.length;
    }

    public static boolean enumerateRootCAs(String str, String str2) throws IOException {
        X509TrustManager x509TrustManager;
        if (isAirCertBundleStale(str) && (x509TrustManager = getX509TrustManager()) != null) {
            try {
                File file = new File(str2);
                RandomAccessFile randomAccessFile = new RandomAccessFile(file, "rw");
                randomAccessFile.setLength(0L);
                dumpAcceptedIssuersToFile(x509TrustManager, randomAccessFile);
                file.setLastModified(getTrustStoreTimestamp());
                randomAccessFile.close();
                return true;
            } catch (FileNotFoundException e) {
                return false;
            } catch (IOException e2) {
                return false;
            } catch (IllegalArgumentException e3) {
                return false;
            } catch (SecurityException e4) {
                return false;
            } catch (CertificateEncodingException e5) {
                return false;
            }
        }
        return false;
    }
}
