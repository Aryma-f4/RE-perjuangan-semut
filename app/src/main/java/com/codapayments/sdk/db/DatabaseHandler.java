package com.codapayments.sdk.db;

import android.content.ContentValues;
import android.content.Context;
import android.database.SQLException;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import android.util.Log;
import com.codapayments.sdk.c.f;

/* loaded from: classes.dex */
public class DatabaseHandler extends SQLiteOpenHelper {
    private static final int a = 1;
    private static final String b = "CodaPay.db";
    private static final String c = "PendingTxn";
    private static final String d = "TxnId";
    private static final String e = "Environment";
    private static final String f = "EncryptKey";
    private static final String g = "ClassName";

    public DatabaseHandler(Context context) {
        super(context, b, (SQLiteDatabase.CursorFactory) null, 1);
    }

    private void a(a aVar) {
        SQLiteDatabase writableDatabase = getWritableDatabase();
        try {
            ContentValues contentValues = new ContentValues();
            contentValues.put(d, Long.valueOf(aVar.a()));
            contentValues.put(e, aVar.b());
            contentValues.put(f, aVar.c());
            contentValues.put(g, aVar.d());
            Log.i(f.w, "id : " + writableDatabase.insert(c, null, contentValues));
        } catch (Exception e2) {
            e2.printStackTrace();
        } finally {
            writableDatabase.close();
        }
    }

    public static void main(String[] strArr) {
        System.out.println(f.w);
    }

    /* JADX WARN: Removed duplicated region for block: B:21:0x0065  */
    /*
        Code decompiled incorrectly, please refer to instructions dump.
        To view partially-correct code enable 'Show inconsistent code' option in preferences
    */
    public final java.util.List a() throws java.lang.Throwable {
        /*
            r11 = this;
            r9 = 0
            java.util.ArrayList r8 = new java.util.ArrayList
            r8.<init>()
            android.database.sqlite.SQLiteDatabase r0 = r11.getReadableDatabase()
            java.lang.String r1 = "PendingTxn"
            r2 = 0
            r3 = 0
            r4 = 0
            r5 = 0
            r6 = 0
            r7 = 0
            android.database.Cursor r1 = r0.query(r1, r2, r3, r4, r5, r6, r7)     // Catch: java.lang.Exception -> L53 java.lang.Throwable -> L61
            boolean r2 = r1.moveToFirst()     // Catch: java.lang.Throwable -> L6c java.lang.Exception -> L73
            if (r2 == 0) goto L4a
        L1c:
            com.codapayments.sdk.db.a r2 = new com.codapayments.sdk.db.a     // Catch: java.lang.Throwable -> L6c java.lang.Exception -> L73
            r2.<init>()     // Catch: java.lang.Throwable -> L6c java.lang.Exception -> L73
            r3 = 0
            long r3 = r1.getLong(r3)     // Catch: java.lang.Throwable -> L6c java.lang.Exception -> L73
            r2.a(r3)     // Catch: java.lang.Throwable -> L6c java.lang.Exception -> L73
            r3 = 1
            java.lang.String r3 = r1.getString(r3)     // Catch: java.lang.Throwable -> L6c java.lang.Exception -> L73
            r2.a(r3)     // Catch: java.lang.Throwable -> L6c java.lang.Exception -> L73
            r3 = 2
            java.lang.String r3 = r1.getString(r3)     // Catch: java.lang.Throwable -> L6c java.lang.Exception -> L73
            r2.b(r3)     // Catch: java.lang.Throwable -> L6c java.lang.Exception -> L73
            r3 = 3
            java.lang.String r3 = r1.getString(r3)     // Catch: java.lang.Throwable -> L6c java.lang.Exception -> L73
            r2.c(r3)     // Catch: java.lang.Throwable -> L6c java.lang.Exception -> L73
            r8.add(r2)     // Catch: java.lang.Throwable -> L6c java.lang.Exception -> L73
            boolean r2 = r1.moveToNext()     // Catch: java.lang.Throwable -> L6c java.lang.Exception -> L73
            if (r2 != 0) goto L1c
        L4a:
            if (r1 == 0) goto L4f
            r1.close()
        L4f:
            r0.close()
        L52:
            return r8
        L53:
            r1 = move-exception
            r2 = r9
        L55:
            r1.printStackTrace()     // Catch: java.lang.Throwable -> L71
            if (r2 == 0) goto L5d
            r2.close()
        L5d:
            r0.close()
            goto L52
        L61:
            r1 = move-exception
            r2 = r9
        L63:
            if (r2 == 0) goto L68
            r2.close()
        L68:
            r0.close()
            throw r1
        L6c:
            r2 = move-exception
            r10 = r2
            r2 = r1
            r1 = r10
            goto L63
        L71:
            r1 = move-exception
            goto L63
        L73:
            r2 = move-exception
            r10 = r2
            r2 = r1
            r1 = r10
            goto L55
        */
        throw new UnsupportedOperationException("Method not decompiled: com.codapayments.sdk.db.DatabaseHandler.a():java.util.List");
    }

    public final void a(long j) {
        SQLiteDatabase writableDatabase = getWritableDatabase();
        try {
            Log.i(f.w, "count : " + writableDatabase.delete(c, "TxnId = ?", new String[]{String.valueOf(j)}));
        } catch (Exception e2) {
            e2.printStackTrace();
        } finally {
            writableDatabase.close();
        }
    }

    public final void a(long j, String str, String str2, String str3) {
        SQLiteDatabase writableDatabase = getWritableDatabase();
        try {
            ContentValues contentValues = new ContentValues();
            contentValues.put(d, Long.valueOf(j));
            contentValues.put(e, str);
            contentValues.put(f, str2);
            contentValues.put(g, str3);
            Log.i(f.w, "id : " + writableDatabase.insert(c, null, contentValues));
        } catch (Exception e2) {
            e2.printStackTrace();
        } finally {
            writableDatabase.close();
        }
    }

    @Override // android.database.sqlite.SQLiteOpenHelper
    public void onCreate(SQLiteDatabase sQLiteDatabase) throws SQLException {
        sQLiteDatabase.execSQL("CREATE TABLE IF NOT EXISTS PendingTxn(TxnId INTEGER PRIMARY KEY, Environment TEXT, EncryptKey TEXT , ClassName TEXT )");
    }

    @Override // android.database.sqlite.SQLiteOpenHelper
    public void onUpgrade(SQLiteDatabase sQLiteDatabase, int i, int i2) throws SQLException {
        sQLiteDatabase.execSQL("DROP TABLE IF EXISTS PendingTxn");
        onCreate(sQLiteDatabase);
    }
}
