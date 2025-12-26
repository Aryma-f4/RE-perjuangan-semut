package com.codapayments.sdk.b;

import android.app.AlarmManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.database.sqlite.SQLiteDatabase;
import android.os.AsyncTask;
import android.util.Log;
import com.adobe.air.wand.view.CompanionView;
import com.codapayments.sdk.c.f;
import com.codapayments.sdk.c.h;
import com.codapayments.sdk.db.DatabaseHandler;
import com.codapayments.sdk.interfaces.PaymentResultHandler;
import com.codapayments.sdk.model.PayResult;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

/* loaded from: classes.dex */
public final class e extends AsyncTask {
    private Context a;
    private Intent b;
    private int c = 0;
    private int d = 0;
    private ArrayList e = new ArrayList();
    private Map f = new HashMap();
    private DatabaseHandler g = null;

    public e(Context context, Intent intent) {
        this.a = context;
        this.b = intent;
    }

    private String a() throws Throwable {
        this.g = new DatabaseHandler(this.a);
        List<com.codapayments.sdk.db.a> listA = this.g.a();
        if (listA.size() <= 0) {
            return null;
        }
        this.c = listA.size();
        for (com.codapayments.sdk.db.a aVar : listA) {
            com.codapayments.sdk.model.e eVarA = com.codapayments.sdk.a.a.a(aVar.b()).a(aVar.a(), aVar.c());
            if (!eVarA.b()) {
                this.e.add(eVarA);
                this.f.put(Long.valueOf(eVarA.a()), aVar.d());
            }
        }
        return null;
    }

    private void a(String str) {
        super.onPostExecute(str);
        if (this.e != null && this.e.size() > 0) {
            Iterator it = this.e.iterator();
            while (it.hasNext()) {
                com.codapayments.sdk.model.e eVar = (com.codapayments.sdk.model.e) it.next();
                PayResult payResultC = eVar.c();
                String str2 = (String) this.f.get(Long.valueOf(payResultC.getTxnId()));
                if (str2 != null && str2.length() > 0) {
                    try {
                        ((PaymentResultHandler) Class.forName(str2).newInstance()).handleResult(payResultC);
                    } catch (ClassNotFoundException e) {
                        e.printStackTrace();
                    } catch (IllegalAccessException e2) {
                        Log.e(f.J, e2 + " Interpreter class must have a no-arg constructor.");
                    } catch (InstantiationException e3) {
                        Log.e(f.J, e3 + " Interpreter class must be concrete.");
                    }
                    if (eVar.d()) {
                        if (eVar.e()) {
                            h.a(this.a, eVar.g(), eVar.f(), true);
                        } else {
                            h.a(this.a, eVar.g(), eVar.f(), false);
                        }
                    }
                }
                DatabaseHandler databaseHandler = this.g;
                long txnId = payResultC.getTxnId();
                SQLiteDatabase writableDatabase = databaseHandler.getWritableDatabase();
                try {
                    Log.i(f.w, "count : " + writableDatabase.delete("PendingTxn", "TxnId = ?", new String[]{String.valueOf(txnId)}));
                } catch (Exception e4) {
                    e4.printStackTrace();
                } finally {
                    writableDatabase.close();
                }
                this.d++;
            }
        }
        PendingIntent broadcast = PendingIntent.getBroadcast(this.a, 0, this.b, CompanionView.kTouchMetaStateSideButton1);
        AlarmManager alarmManager = (AlarmManager) this.a.getSystemService("alarm");
        if (this.c > this.d) {
            alarmManager.set(0, System.currentTimeMillis() + f.u, broadcast);
        } else if (broadcast != null) {
            alarmManager.cancel(broadcast);
        }
    }

    @Override // android.os.AsyncTask
    protected final /* synthetic */ Object doInBackground(Object... objArr) throws Throwable {
        this.g = new DatabaseHandler(this.a);
        List<com.codapayments.sdk.db.a> listA = this.g.a();
        if (listA.size() <= 0) {
            return null;
        }
        this.c = listA.size();
        for (com.codapayments.sdk.db.a aVar : listA) {
            com.codapayments.sdk.model.e eVarA = com.codapayments.sdk.a.a.a(aVar.b()).a(aVar.a(), aVar.c());
            if (!eVarA.b()) {
                this.e.add(eVarA);
                this.f.put(Long.valueOf(eVarA.a()), aVar.d());
            }
        }
        return null;
    }

    @Override // android.os.AsyncTask
    protected final /* synthetic */ void onPostExecute(Object obj) {
        super.onPostExecute((String) obj);
        if (this.e != null && this.e.size() > 0) {
            Iterator it = this.e.iterator();
            while (it.hasNext()) {
                com.codapayments.sdk.model.e eVar = (com.codapayments.sdk.model.e) it.next();
                PayResult payResultC = eVar.c();
                String str = (String) this.f.get(Long.valueOf(payResultC.getTxnId()));
                if (str != null && str.length() > 0) {
                    try {
                        ((PaymentResultHandler) Class.forName(str).newInstance()).handleResult(payResultC);
                    } catch (ClassNotFoundException e) {
                        e.printStackTrace();
                    } catch (IllegalAccessException e2) {
                        Log.e(f.J, e2 + " Interpreter class must have a no-arg constructor.");
                    } catch (InstantiationException e3) {
                        Log.e(f.J, e3 + " Interpreter class must be concrete.");
                    }
                    if (eVar.d()) {
                        if (eVar.e()) {
                            h.a(this.a, eVar.g(), eVar.f(), true);
                        } else {
                            h.a(this.a, eVar.g(), eVar.f(), false);
                        }
                    }
                }
                DatabaseHandler databaseHandler = this.g;
                long txnId = payResultC.getTxnId();
                SQLiteDatabase writableDatabase = databaseHandler.getWritableDatabase();
                try {
                    Log.i(f.w, "count : " + writableDatabase.delete("PendingTxn", "TxnId = ?", new String[]{String.valueOf(txnId)}));
                } catch (Exception e4) {
                    e4.printStackTrace();
                } finally {
                    writableDatabase.close();
                }
                this.d++;
            }
        }
        PendingIntent broadcast = PendingIntent.getBroadcast(this.a, 0, this.b, CompanionView.kTouchMetaStateSideButton1);
        AlarmManager alarmManager = (AlarmManager) this.a.getSystemService("alarm");
        if (this.c > this.d) {
            alarmManager.set(0, System.currentTimeMillis() + f.u, broadcast);
        } else if (broadcast != null) {
            alarmManager.cancel(broadcast);
        }
    }
}
