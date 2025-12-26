package com.codapayments.sdk.c;

import android.util.Log;
import com.codapayments.sdk.interfaces.PaymentResultHandler;
import com.codapayments.sdk.model.PayResult;

/* loaded from: classes.dex */
public final class i {
    public static void a(PayResult payResult, Class cls) {
        try {
            ((PaymentResultHandler) cls.newInstance()).handleResult(payResult);
        } catch (IllegalAccessException e) {
            Log.e(f.J, e + " Interpreter class must have a no-arg constructor.");
        } catch (InstantiationException e2) {
            Log.e(f.J, e2 + " Interpreter class must be concrete.");
        }
    }

    public static void a(PayResult payResult, String str) {
        try {
            ((PaymentResultHandler) Class.forName(str).newInstance()).handleResult(payResult);
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } catch (IllegalAccessException e2) {
            Log.e(f.J, e2 + " Interpreter class must have a no-arg constructor.");
        } catch (InstantiationException e3) {
            Log.e(f.J, e3 + " Interpreter class must be concrete.");
        }
    }

    public static void b(PayResult payResult, Class cls) {
        try {
            ((PaymentResultHandler) cls.newInstance()).handleClose(payResult);
        } catch (IllegalAccessException e) {
            Log.e(f.J, e + " Interpreter class must have a no-arg constructor.");
        } catch (InstantiationException e2) {
            Log.e(f.J, e2 + " Interpreter class must be concrete.");
        }
    }
}
