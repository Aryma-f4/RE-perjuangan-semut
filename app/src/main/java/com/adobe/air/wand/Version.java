package com.adobe.air.wand;

/* loaded from: classes.dex */
public class Version {
    public static final String CURRENT = "1.1.0";
    public static final String V1_0_0 = "1.0.0";
    public static final String V1_1_0 = "1.1.0";

    public static boolean isGreaterThan(String str, String str2) throws Exception {
        String[] strArrSplit = str.split("\\.");
        String[] strArrSplit2 = str2.split("\\.");
        int i = 0;
        while (i < 2 && strArrSplit[i].equals(strArrSplit2[i])) {
            i++;
        }
        return Integer.valueOf(strArrSplit[i]).intValue() > Integer.valueOf(strArrSplit2[i]).intValue();
    }

    public static boolean isGreaterThanEqualTo(String str, String str2) throws Exception {
        return isGreaterThan(str, str2) || str.equals(str2);
    }
}
