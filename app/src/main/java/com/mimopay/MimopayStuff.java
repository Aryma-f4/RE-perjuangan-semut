package com.mimopay;

import android.os.Environment;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.util.ArrayList;

/* loaded from: classes.dex */
final class MimopayStuff {
    public static String sPaymentMethod = "";
    public static String sChannel = "";
    public static String sEmailOrUserId = "";
    public static String sMerchantCode = "";
    public static String sProductName = "";
    public static String sTransactionId = "";
    public static String sSecretKey = "";
    public static String sSecretKeyStaging = "";
    public static String sSecretKeyGateway = "";
    public static String sCurrency = "";
    public static String sAmount = "";
    public static boolean mEnableLog = false;
    public static String mMimopayUrlPoint = "staging";

    MimopayStuff() {
    }

    public static void saveLastResult(ArrayList<String> als) throws IOException {
        boolean storageokay = Environment.getExternalStorageState().equals("mounted");
        if (storageokay) {
            String mlpath = Environment.getExternalStorageDirectory() + "/mimopay/lastresult";
            try {
                FileOutputStream fos = new FileOutputStream(mlpath);
                try {
                    ObjectOutputStream oos = new ObjectOutputStream(fos);
                    oos.writeObject(als);
                    fos.close();
                } catch (Exception e) {
                }
            } catch (Exception e2) {
            }
        }
    }

    public static ArrayList<String> loadLastResult() throws IOException {
        boolean storageokay = Environment.getExternalStorageState().equals("mounted");
        if (!storageokay) {
            return null;
        }
        String mlpath = Environment.getExternalStorageDirectory() + "/mimopay/lastresult";
        ArrayList<String> als = null;
        try {
            FileInputStream fis = new FileInputStream(mlpath);
            ObjectInputStream ois = new ObjectInputStream(fis);
            ArrayList<String> als2 = new ArrayList<>();
            try {
                als = (ArrayList) ois.readObject();
                fis.close();
            } catch (Exception e) {
                als = als2;
            }
        } catch (Exception e2) {
        }
        return als;
    }
}
