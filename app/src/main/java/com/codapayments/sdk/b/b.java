package com.codapayments.sdk.b;

import android.app.AlarmManager;
import android.app.PendingIntent;
import android.content.ContentValues;
import android.content.Intent;
import android.database.sqlite.SQLiteDatabase;
import android.os.AsyncTask;
import android.util.Log;
import com.adobe.air.wand.view.CompanionView;
import com.codapayments.sdk.CodaSDK;
import com.codapayments.sdk.c.f;
import com.codapayments.sdk.c.h;
import com.codapayments.sdk.db.DatabaseHandler;
import com.codapayments.sdk.interfaces.PaymentResultHandler;
import com.codapayments.sdk.message.PendingTxnReceiver;
import com.codapayments.sdk.model.PayResult;

/* loaded from: classes.dex */
public final class b extends AsyncTask {
    private com.codapayments.sdk.model.b a;
    private CodaSDK b;

    public b(CodaSDK codaSDK) {
        this.b = codaSDK;
    }

    private String a() {
        com.codapayments.sdk.a.a aVarA = this.b.a();
        com.codapayments.sdk.model.d dVarB = aVarA.b();
        long jA = dVarB.a();
        String strE = dVarB.e();
        Log.i(f.G, "CodaSDK Transaction Id : " + String.valueOf(jA));
        Log.i(f.G, "CodaSDK Encrypted Key : " + strE);
        this.a = aVarA.a();
        return null;
    }

    private void a(String str) {
        super.onPostExecute(str);
        PayResult payResultA = this.a.a();
        Log.i(f.G, "ProcessFinit PayResult : " + payResultA.toString());
        try {
            ((PaymentResultHandler) this.b.d().newInstance()).handleClose(payResultA);
        } catch (IllegalAccessException e) {
            Log.e(f.J, e + " Interpreter class must have a no-arg constructor.");
        } catch (InstantiationException e2) {
            Log.e(f.J, e2 + " Interpreter class must be concrete.");
        }
        if (this.a.b()) {
            if (this.a.c()) {
                h.a(this.b.b(), this.a.e(), this.a.d(), true);
            } else {
                h.a(this.b.b(), this.a.e(), this.a.d(), false);
            }
        }
        if (payResultA.isInProgress()) {
            com.codapayments.sdk.a.a aVarA = this.b.a();
            com.codapayments.sdk.model.d dVarB = aVarA.b();
            DatabaseHandler databaseHandler = new DatabaseHandler(this.b.c());
            long jA = dVarB.a();
            String strC = aVarA.c();
            String strE = dVarB.e();
            String name = this.b.d().getName();
            SQLiteDatabase writableDatabase = databaseHandler.getWritableDatabase();
            try {
                ContentValues contentValues = new ContentValues();
                contentValues.put("TxnId", Long.valueOf(jA));
                contentValues.put("Environment", strC);
                contentValues.put("EncryptKey", strE);
                contentValues.put("ClassName", name);
                Log.i(f.w, "id : " + writableDatabase.insert("PendingTxn", null, contentValues));
            } catch (Exception e3) {
                e3.printStackTrace();
            } finally {
                writableDatabase.close();
            }
            ((AlarmManager) this.b.c().getSystemService("alarm")).set(0, System.currentTimeMillis() + f.u, PendingIntent.getBroadcast(this.b.b(), 0, new Intent(this.b.b(), (Class<?>) PendingTxnReceiver.class), CompanionView.kTouchMetaStateSideButton1));
        }
        this.b.c().finish();
    }

    @Override // android.os.AsyncTask
    protected final /* synthetic */ Object doInBackground(Object... objArr) {
        com.codapayments.sdk.a.a aVarA = this.b.a();
        com.codapayments.sdk.model.d dVarB = aVarA.b();
        long jA = dVarB.a();
        String strE = dVarB.e();
        Log.i(f.G, "CodaSDK Transaction Id : " + String.valueOf(jA));
        Log.i(f.G, "CodaSDK Encrypted Key : " + strE);
        this.a = aVarA.a();
        return null;
    }

    /* JADX WARN: Multi-variable type inference failed */
    /* JADX WARN: Type inference failed for: r2v12, types: [long] */
    /* JADX WARN: Type inference failed for: r2v6, types: [android.database.sqlite.SQLiteDatabase] */
    @Override // android.os.AsyncTask
    protected final /* synthetic */ void onPostExecute(Object obj) {
        super.onPostExecute((String) obj);
        PayResult payResultA = this.a.a();
        Log.i(f.G, "ProcessFinit PayResult : " + payResultA.toString());
        try {
            ((PaymentResultHandler) this.b.d().newInstance()).handleClose(payResultA);
        } catch (IllegalAccessException e) {
            Log.e(f.J, e + " Interpreter class must have a no-arg constructor.");
        } catch (InstantiationException e2) {
            Log.e(f.J, e2 + " Interpreter class must be concrete.");
        }
        if (this.a.b()) {
            if (this.a.c()) {
                h.a(this.b.b(), this.a.e(), this.a.d(), true);
            } else {
                h.a(this.b.b(), this.a.e(), this.a.d(), false);
            }
        }
        if (payResultA.isInProgress()) {
            com.codapayments.sdk.a.a aVarA = this.b.a();
            com.codapayments.sdk.model.d dVarB = aVarA.b();
            DatabaseHandler databaseHandler = new DatabaseHandler(this.b.c());
            long jA = dVarB.a();
            String strC = aVarA.c();
            String strE = dVarB.e();
            String name = this.b.d().getName();
            SQLiteDatabase writableDatabase = databaseHandler.getWritableDatabase();
            try {
                ContentValues contentValues = new ContentValues();
                contentValues.put("TxnId", Long.valueOf(jA));
                contentValues.put("Environment", strC);
                contentValues.put("EncryptKey", strE);
                contentValues.put("ClassName", name);
                Log.i(f.w, "id : " + writableDatabase.insert("PendingTxn", null, contentValues));
            } catch (Exception e3) {
                e3.printStackTrace();
            } finally {
                writableDatabase.close();
            }
            PendingIntent broadcast = PendingIntent.getBroadcast(this.b.b(), 0, new Intent(this.b.b(), (Class<?>) PendingTxnReceiver.class), CompanionView.kTouchMetaStateSideButton1);
            AlarmManager alarmManager = (AlarmManager) this.b.c().getSystemService("alarm");
            writableDatabase = System.currentTimeMillis() + f.u;
            alarmManager.set(0, writableDatabase, broadcast);
        }
        this.b.c().finish();
    }
}
