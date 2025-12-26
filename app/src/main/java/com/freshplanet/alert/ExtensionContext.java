package com.freshplanet.alert;

import android.content.DialogInterface;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.facebook.AppEventsConstants;
import com.freshplanet.alert.functions.AirAlertShowAlert;
import java.util.HashMap;
import java.util.Map;

/* loaded from: classes.dex */
public class ExtensionContext extends FREContext implements DialogInterface.OnClickListener {
    @Override // com.adobe.fre.FREContext
    public void dispose() {
    }

    @Override // com.adobe.fre.FREContext
    public Map<String, FREFunction> getFunctions() {
        HashMap map = new HashMap();
        map.put("AirAlertShowAlert", new AirAlertShowAlert());
        return map;
    }

    @Override // android.content.DialogInterface.OnClickListener
    public void onClick(DialogInterface dialogInterface, int i) {
        dispatchStatusEventAsync("CLICK", i == -1 ? AppEventsConstants.EVENT_PARAM_VALUE_YES : AppEventsConstants.EVENT_PARAM_VALUE_NO);
    }
}
