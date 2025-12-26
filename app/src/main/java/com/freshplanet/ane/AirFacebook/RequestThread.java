package com.freshplanet.ane.AirFacebook;

import android.os.Bundle;
import com.facebook.HttpMethod;
import com.facebook.Request;
import com.facebook.Response;
import com.facebook.Session;

/* loaded from: classes.dex */
public class RequestThread extends Thread {
    private String _callback;
    private AirFacebookExtensionContext _context;
    private String _graphPath;
    private String _httpMethod;
    private Bundle _parameters;

    public RequestThread(AirFacebookExtensionContext airFacebookExtensionContext, String str, Bundle bundle, String str2, String str3) {
        this._context = airFacebookExtensionContext;
        this._graphPath = str;
        this._parameters = bundle;
        this._httpMethod = str2;
        this._callback = str3;
    }

    @Override // java.lang.Thread, java.lang.Runnable
    public void run() {
        String string;
        String string2;
        Session session = this._context.getSession();
        try {
            Response responseExecuteAndWait = (this._parameters != null ? new Request(session, this._graphPath, this._parameters, HttpMethod.valueOf(this._httpMethod)) : new Request(session, this._graphPath)).executeAndWait();
            if (responseExecuteAndWait.getGraphObject() != null) {
                string2 = responseExecuteAndWait.getGraphObject().getInnerJSONObject().toString();
                string = null;
            } else if (responseExecuteAndWait.getGraphObjectList() != null) {
                string2 = responseExecuteAndWait.getGraphObjectList().getInnerJSONArray().toString();
                string = null;
            } else if (responseExecuteAndWait.getError() == null) {
                string = null;
                string2 = null;
            } else if (responseExecuteAndWait.getError().getRequestResult() != null) {
                string = responseExecuteAndWait.getError().getRequestResult().toString();
                string2 = null;
            } else {
                string = "{\"error\":\"" + responseExecuteAndWait.getError().toString() + "\"}";
                string2 = null;
            }
        } catch (Exception e) {
            string = "{\"error\":\"" + e.toString() + "\"}";
            string2 = null;
        }
        if (string == null) {
            string = string2 != null ? string2 : "";
        }
        if (this._callback != null) {
            this._context.dispatchStatusEventAsync(this._callback, string);
        }
    }
}
