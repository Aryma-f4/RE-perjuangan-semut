package com.boyaa.antwarsId;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.boyaa.antwarsId.function.CodaPayFunction;
import com.boyaa.antwarsId.function.GoogleCheckFunction;
import com.boyaa.antwarsId.function.MimopayFunction;
import com.boyaa.antwarsId.function.SayHello;
import java.util.HashMap;
import java.util.Map;

/* loaded from: classes.dex */
public class AntContext extends FREContext {
    public static final String CODAPAY = "codePay";
    public static final String GOOGLEPAY = "googlepayment";
    public static final String MIMOPAY = "mimopayment";
    public static final String SAY_HELLO = "sayhello";
    private Map<String, FREFunction> map = null;

    @Override // com.adobe.fre.FREContext
    public void dispose() {
    }

    @Override // com.adobe.fre.FREContext
    public Map<String, FREFunction> getFunctions() {
        if (this.map == null) {
            AntExtension.log("Register function map");
            this.map = new HashMap();
            this.map.put(SAY_HELLO, new SayHello());
            this.map.put(MIMOPAY, new MimopayFunction());
            this.map.put(GOOGLEPAY, new GoogleCheckFunction());
            this.map.put(CODAPAY, new CodaPayFunction());
            AntExtension.log("Register function map done!");
        }
        return this.map;
    }
}
