package com.boyaa.antwarsId;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import com.boyaa.tools.CodaPayResultActitity;
import com.codapayments.sdk.CodaSDK;
import com.codapayments.sdk.model.ItemInfo;
import com.codapayments.sdk.model.PayInfo;
import java.util.ArrayList;
import java.util.Date;

/* loaded from: classes.dex */
public class CodaPaymentActitity extends Activity {
    public static String ENVIRONMENT = "Sandbox";
    public static String SELECTED_COUNTRY = "Indonesia";
    public static String CURRENCY_RUPIAH = "RP";
    public static String IDN_API_KEY = "5a8ca8f31f19a23c41edd14b29a74fd2";
    public static short IDN_COUNTRY_CODE = 360;
    public static short IDN_CURRENCY_CODE = 360;

    public static void main(String[] args) {
    }

    @Override // android.app.Activity
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        AntExtension.logCodaPayMsg("jump in CodaActivity");
        startBuy();
    }

    private void startBuy() {
        AntExtension.logCodaPayMsg("codaPay startPurchase");
        ArrayList<ItemInfo> mItemInfos = new ArrayList<>();
        ItemInfo itemInfo = new ItemInfo("Coins", "Coins", 1000.0d, (short) 0);
        ItemInfo itemInfo1 = new ItemInfo("Coins", "Coins", 2000.0d, (short) 0);
        mItemInfos.add(itemInfo);
        mItemInfos.add(itemInfo1);
        String orderId = String.valueOf(new Date().getTime());
        try {
            CodaSDK codaPay = CodaSDK.getInstance(this, CodaPayResultActitity.class);
            PayInfo payInfo = new PayInfo(IDN_API_KEY, orderId, IDN_COUNTRY_CODE, IDN_CURRENCY_CODE, ENVIRONMENT, mItemInfos);
            codaPay.pay(payInfo);
        } catch (Exception e) {
            e.printStackTrace();
            AntExtension.logCodaPayMsg(e.getMessage());
        }
    }

    @Override // android.app.Activity
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        finish();
    }
}
