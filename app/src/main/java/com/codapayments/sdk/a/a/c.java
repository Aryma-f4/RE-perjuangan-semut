package com.codapayments.sdk.a.a;

import android.util.Log;
import com.codapayments.sdk.c.f;
import com.codapayments.sdk.model.ItemInfo;
import com.codapayments.sdk.model.d;
import com.codapayments.sdk.model.e;
import com.facebook.internal.ServerProtocol;
import java.math.BigInteger;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

/* loaded from: classes.dex */
public final class c {
    public static d a(String str) {
        try {
            JSONObject jSONObject = new JSONObject(str);
            short s = jSONObject.isNull("rc") ? (short) 0 : (short) jSONObject.getInt("rc");
            String string = jSONObject.isNull("rd") ? "" : jSONObject.getString("rd");
            String string2 = jSONObject.isNull("rh") ? "" : jSONObject.getString("rh");
            String string3 = jSONObject.isNull("wvURL") ? "" : jSONObject.getString("wvURL");
            String string4 = jSONObject.isNull("ek") ? "" : jSONObject.getString("ek");
            String string5 = jSONObject.isNull("smsMsg") ? "" : jSONObject.getString("smsMsg");
            String string6 = jSONObject.isNull("sc") ? "" : jSONObject.getString("sc");
            String string7 = jSONObject.isNull("merName") ? "" : jSONObject.getString("merName");
            long j = jSONObject.isNull("txnId") ? 0L : jSONObject.getLong("txnId");
            String string8 = jSONObject.isNull("msisdn") ? "" : jSONObject.getString("msisdn");
            boolean z = jSONObject.isNull("csms") ? false : jSONObject.getBoolean("csms");
            boolean z2 = jSONObject.isNull("ssms") ? false : jSONObject.getBoolean("ssms");
            d dVar = new d();
            dVar.a(s);
            dVar.a(string);
            dVar.f(string2);
            dVar.b(string3);
            dVar.c(string4);
            dVar.d(string5);
            dVar.e(string6);
            dVar.g(string7);
            dVar.a(j);
            if (string8 != null && string8.length() > 0) {
                dVar.a(new BigInteger(string8));
            }
            dVar.a(z);
            dVar.b(z2);
            dVar.b(true);
            if (!jSONObject.isNull("prof")) {
                dVar.a(com.codapayments.sdk.message.a.a(jSONObject.getJSONObject("prof")));
            }
            return dVar;
        } catch (JSONException e) {
            e.printStackTrace();
            Log.i(f.A, "[ERROR] " + e);
            return null;
        }
    }

    public static String a(com.codapayments.sdk.model.c cVar) throws JSONException {
        try {
            JSONObject jSONObject = new JSONObject();
            jSONObject.put("ordId", cVar.d());
            jSONObject.put("country", cVar.a());
            jSONObject.put("currency", cVar.b());
            jSONObject.put("msisdn", cVar.c());
            jSONObject.put("pt", cVar.e());
            if (cVar.f() != null && cVar.f().size() > 0) {
                JSONArray jSONArray = new JSONArray();
                Iterator it = cVar.f().iterator();
                while (it.hasNext()) {
                    ItemInfo itemInfo = (ItemInfo) it.next();
                    JSONObject jSONObject2 = new JSONObject();
                    jSONObject2.put("code", itemInfo.getCode());
                    jSONObject2.put("name", itemInfo.getName());
                    jSONObject2.put("price", itemInfo.getPrice());
                    jSONObject2.put(ServerProtocol.DIALOG_PARAM_TYPE, (int) itemInfo.getType());
                    jSONArray.put(jSONObject2);
                }
                jSONObject.put("itms", jSONArray);
            }
            com.codapayments.sdk.model.a aVarH = cVar.h();
            if (aVarH != null) {
                JSONObject jSONObject3 = new JSONObject();
                jSONObject3.put("msisdn", aVarH.a());
                jSONObject3.put("dvId", aVarH.b());
                jSONObject3.put("dvType", aVarH.h());
                jSONObject3.put("oId", aVarH.j());
                jSONObject3.put("oName", aVarH.k());
                jSONObject3.put("so", aVarH.l());
                jSONObject3.put("soName", aVarH.m());
                jSONObject3.put("sv", aVarH.c());
                jSONObject3.put("lang", aVarH.d());
                jSONObject3.put("location", aVarH.e());
                jSONObject3.put("sh", aVarH.f());
                jSONObject3.put("sw", aVarH.g());
                jSONObject3.put("ir", aVarH.i());
                jSONObject3.put("isTab", aVarH.n());
                jSONObject3.put("pType", aVarH.p());
                jSONObject3.put("intType", aVarH.q());
                jSONObject3.put("simCntry", aVarH.r());
                jSONObject3.put("srlNum", aVarH.s());
                jSONObject3.put("ipAddress", aVarH.t());
                jSONObject3.put("subscrId", aVarH.u());
                jSONObject3.put("simState", aVarH.o());
                jSONObject.put("dvInf", jSONObject3);
            }
            HashMap mapG = cVar.g();
            if (mapG != null && mapG.size() > 0) {
                JSONObject jSONObject4 = new JSONObject();
                for (Map.Entry entry : mapG.entrySet()) {
                    try {
                        jSONObject4.put((String) entry.getKey(), entry.getValue());
                    } catch (JSONException e) {
                        e.printStackTrace();
                        Log.i(f.A, "[ERROR] " + e);
                    }
                }
                jSONObject.put("prof", jSONObject4);
            }
            return jSONObject.toString();
        } catch (JSONException e2) {
            e2.printStackTrace();
            Log.i(f.A, "[ERROR] " + e2);
            return null;
        }
    }

    public static Map a(JSONObject jSONObject) {
        HashMap map = new HashMap();
        if (jSONObject != null) {
            Iterator<String> itKeys = jSONObject.keys();
            while (itKeys.hasNext()) {
                String next = itKeys.next();
                map.put(next, (String) jSONObject.get(next));
            }
        }
        return map;
    }

    public static com.codapayments.sdk.model.b b(String str) throws JSONException {
        try {
            JSONObject jSONObject = new JSONObject(str);
            short s = jSONObject.isNull("rc") ? (short) 0 : (short) jSONObject.getInt("rc");
            String string = jSONObject.isNull("rd") ? "" : jSONObject.getString("rd");
            String string2 = jSONObject.isNull("rh") ? "" : jSONObject.getString("rh");
            long j = jSONObject.isNull("txnId") ? 0L : jSONObject.getLong("txnId");
            String string3 = jSONObject.isNull("msisdn") ? "" : jSONObject.getString("msisdn");
            double d = jSONObject.isNull("tp") ? 0.0d : jSONObject.getDouble("tp");
            String string4 = jSONObject.isNull("ordId") ? "" : jSONObject.getString("ordId");
            boolean z = jSONObject.isNull("ip") ? false : jSONObject.getBoolean("ip");
            boolean z2 = jSONObject.isNull("scn") ? false : jSONObject.getBoolean("scn");
            boolean z3 = jSONObject.isNull("ien") ? false : jSONObject.getBoolean("ien");
            String string5 = jSONObject.isNull("nMsg") ? "" : jSONObject.getString("nMsg");
            String string6 = jSONObject.isNull("nHdr") ? "" : jSONObject.getString("nHdr");
            com.codapayments.sdk.model.b bVar = new com.codapayments.sdk.model.b();
            bVar.a(s);
            bVar.c(string);
            bVar.d(string2);
            bVar.a(j);
            bVar.b(string3);
            bVar.a(d);
            bVar.a(string4);
            bVar.a(z);
            bVar.b(z2);
            bVar.c(z3);
            bVar.e(string5);
            bVar.f(string6);
            ArrayList arrayList = new ArrayList();
            JSONArray jSONArray = jSONObject.isNull("itms") ? null : jSONObject.getJSONArray("itms");
            for (int i = 0; jSONArray != null && i < jSONArray.length(); i++) {
                JSONObject jSONObject2 = jSONArray.getJSONObject(i);
                arrayList.add(new ItemInfo(jSONObject2.isNull("code") ? "" : jSONObject2.getString("code"), jSONObject2.isNull("name") ? "" : jSONObject2.getString("name"), jSONObject2.isNull("price") ? 0.0d : jSONObject2.getDouble("price"), jSONObject2.isNull(ServerProtocol.DIALOG_PARAM_TYPE) ? (short) 0 : (short) jSONObject2.getInt(ServerProtocol.DIALOG_PARAM_TYPE)));
            }
            bVar.a(arrayList);
            return bVar;
        } catch (JSONException e) {
            e.printStackTrace();
            Log.i(f.A, "[ERROR] " + e);
            return null;
        }
    }

    public static e c(String str) throws JSONException {
        try {
            JSONObject jSONObject = new JSONObject(str);
            short s = jSONObject.isNull("rc") ? (short) 0 : (short) jSONObject.getInt("rc");
            String string = jSONObject.isNull("rd") ? "" : jSONObject.getString("rd");
            String string2 = jSONObject.isNull("rh") ? "" : jSONObject.getString("rh");
            long j = jSONObject.isNull("txnId") ? 0L : jSONObject.getLong("txnId");
            String string3 = jSONObject.isNull("msisdn") ? "" : jSONObject.getString("msisdn");
            double d = jSONObject.isNull("tp") ? 0.0d : jSONObject.getDouble("tp");
            String string4 = jSONObject.isNull("ordId") ? "" : jSONObject.getString("ordId");
            boolean z = jSONObject.isNull("ip") ? false : jSONObject.getBoolean("ip");
            boolean z2 = jSONObject.isNull("scn") ? false : jSONObject.getBoolean("scn");
            boolean z3 = jSONObject.isNull("ien") ? false : jSONObject.getBoolean("ien");
            String string5 = jSONObject.isNull("nMsg") ? "" : jSONObject.getString("nMsg");
            String string6 = jSONObject.isNull("nHdr") ? "" : jSONObject.getString("nHdr");
            e eVar = new e();
            eVar.a(s);
            eVar.c(string);
            eVar.d(string2);
            eVar.a(j);
            eVar.b(string3);
            eVar.a(d);
            eVar.a(string4);
            eVar.a(z);
            eVar.b(z2);
            eVar.c(z3);
            eVar.e(string5);
            eVar.f(string6);
            ArrayList arrayList = new ArrayList();
            JSONArray jSONArray = jSONObject.isNull("itms") ? null : jSONObject.getJSONArray("itms");
            for (int i = 0; jSONArray != null && i < jSONArray.length(); i++) {
                JSONObject jSONObject2 = jSONArray.getJSONObject(i);
                arrayList.add(new ItemInfo(jSONObject2.isNull("code") ? "" : jSONObject2.getString("code"), jSONObject2.isNull("name") ? "" : jSONObject2.getString("name"), jSONObject2.isNull("price") ? 0.0d : jSONObject2.getDouble("price"), jSONObject2.isNull(ServerProtocol.DIALOG_PARAM_TYPE) ? (short) 0 : (short) jSONObject2.getInt(ServerProtocol.DIALOG_PARAM_TYPE)));
            }
            eVar.a(arrayList);
            return eVar;
        } catch (JSONException e) {
            e.printStackTrace();
            Log.i(f.A, "[ERROR] " + e);
            return null;
        }
    }

    public static com.codapayments.sdk.model.f d(String str) {
        try {
            JSONObject jSONObject = new JSONObject(str);
            short s = jSONObject.isNull("rc") ? (short) 0 : (short) jSONObject.getInt("rc");
            String string = jSONObject.isNull("rd") ? "" : jSONObject.getString("rd");
            String string2 = jSONObject.isNull("rh") ? "" : jSONObject.getString("rh");
            long j = jSONObject.isNull("txnId") ? 0L : jSONObject.getLong("txnId");
            String string3 = jSONObject.isNull("msisdn") ? "" : jSONObject.getString("msisdn");
            String string4 = jSONObject.isNull("otpURL") ? "" : jSONObject.getString("otpURL");
            com.codapayments.sdk.model.f fVar = new com.codapayments.sdk.model.f();
            fVar.a(s);
            fVar.b(string);
            fVar.d(string2);
            fVar.a(j);
            fVar.a(string3);
            fVar.c(string4);
            return fVar;
        } catch (JSONException e) {
            e.printStackTrace();
            Log.i(f.A, "[ERROR] " + e);
            return null;
        }
    }
}
