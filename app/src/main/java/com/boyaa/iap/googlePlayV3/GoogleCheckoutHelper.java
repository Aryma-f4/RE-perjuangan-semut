package com.boyaa.iap.googlePlayV3;

import android.app.Activity;
import android.app.PendingIntent;
import android.content.ComponentName;
import android.content.Intent;
import android.content.IntentSender;
import android.content.ServiceConnection;
import android.os.Bundle;
import android.os.IBinder;
import android.os.RemoteException;
import android.text.TextUtils;
import android.util.Base64;
import android.util.Log;
import com.android.vending.billing.IInAppBillingService;
import com.boyaa.antwarsId.AntExtension;
import com.facebook.AppEventsConstants;
import java.util.ArrayList;
import org.json.JSONException;
import org.json.JSONObject;

/* loaded from: classes.dex */
public class GoogleCheckoutHelper {
    public static final int BILLING_RESPONSE_RESULT_BILLING_UNAVAILABLE = 3;
    public static final int BILLING_RESPONSE_RESULT_DEVELOPER_ERROR = 5;
    public static final int BILLING_RESPONSE_RESULT_ERROR = 6;
    public static final int BILLING_RESPONSE_RESULT_ITEM_ALREADY_OWNED = 7;
    public static final int BILLING_RESPONSE_RESULT_ITEM_NOT_OWNED = 8;
    public static final int BILLING_RESPONSE_RESULT_ITEM_UNAVAILABLE = 4;
    public static final int BILLING_RESPONSE_RESULT_OK = 0;
    public static final int BILLING_RESPONSE_RESULT_PURCHASE_ERROR = 9;
    public static final int BILLING_RESPONSE_RESULT_USER_CANCELED = 1;
    public static final int IABHELPER_BAD_RESPONSE = -1002;
    public static final int IABHELPER_ERROR_BASE = -1000;
    public static final int IABHELPER_MISSING_TOKEN = -1007;
    public static final int IABHELPER_REMOTE_EXCEPTION = -1001;
    public static final int IABHELPER_SEND_INTENT_FAILED = -1004;
    public static final int IABHELPER_UNKNOWN_ERROR = -1008;
    public static final int IABHELPER_UNKNOWN_PURCHASE_RESPONSE = -1006;
    public static final int IABHELPER_USER_CANCELLED = -1005;
    public static final int IABHELPER_VERIFICATION_FAILED = -1003;
    public static final String INAPP_CONTINUATION_TOKEN = "INAPP_CONTINUATION_TOKEN";
    public static final String ITEM_TYPE_INAPP = "inapp";
    public static final int REQUEST_CODE = 1001;
    public static final String RESPONSE_BUY_INTENT = "BUY_INTENT";
    public static final String RESPONSE_CODE = "RESPONSE_CODE";
    public static final String RESPONSE_GET_SKU_DETAILS_LIST = "DETAILS_LIST";
    public static final String RESPONSE_INAPP_ITEM_LIST = "INAPP_PURCHASE_ITEM_LIST";
    public static final String RESPONSE_INAPP_PURCHASE_DATA = "INAPP_PURCHASE_DATA";
    public static final String RESPONSE_INAPP_PURCHASE_DATA_LIST = "INAPP_PURCHASE_DATA_LIST";
    public static final String RESPONSE_INAPP_SIGNATURE = "INAPP_DATA_SIGNATURE";
    public static final String RESPONSE_INAPP_SIGNATURE_LIST = "INAPP_DATA_SIGNATURE_LIST";
    private static GoogleCheckoutHelper instance = null;
    public static final String kgooglecheckout = "googlecheckout";
    private IBindService iBindService;
    private boolean isConnected;
    private Activity mContext;
    private IInAppBillingService mService;
    private ServiceConnection mServiceConn;
    private String productId = "";
    private String orderId = "";
    private String base64EncodedPublicKey = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAlOHxfJWTyq9MWfxwIkRVjyUli/ZE5Kcj/RyHfBbVvA+jiAmTOAW+OLFiVaqECbLcmKDRmOTSajfDRU2IqgIJ5YgWsSScWhjSf5N89SF1Z7kHjwJbS/LAwa1lUicaP3IgsKs1tBsbLwaOq6K4H/GUYYsm2qq2H9dmoR0AMMir5qJ3ilpJcnisDlZBICVnMkUxDvtBqYjWKxCcLqqLcmxdCKAlj3Opx1jqqatFKZAmBFvEHewkpiicN2+Shn9OFsqckm8dJX3xIFvKO69gt4TQB/d9w+Qh4DhEDDLfmLuaTgRZ1bBFKzSw+BZZN41qY87mRZ9XvVm0dU1Fwsp97enzlQIDAQAB";

    private interface IBindService {
        void bindServiceSuccess();
    }

    public GoogleCheckoutHelper(Activity context) {
        this.mContext = context;
    }

    public static GoogleCheckoutHelper getInstance(Activity mContext) {
        if (instance == null) {
            instance = new GoogleCheckoutHelper(mContext);
        }
        return instance;
    }

    public void startPurchase(String param) throws IntentSender.SendIntentException {
        try {
            AntExtension.log("base64key:" + this.base64EncodedPublicKey);
            JSONObject payInfo = new JSONObject(param);
            this.productId = payInfo.getString("productId");
            this.orderId = payInfo.getString("orderId");
            AntExtension.log("googleCheckout productid:" + this.productId + " orderId:" + this.orderId);
            Log.e("startPurchase", "productId=" + this.productId + ",orderId=" + this.orderId + ",isConnected=" + this.isConnected);
            if (this.isConnected) {
                requestPurchase(this.productId, this.orderId);
            } else {
                this.iBindService = new IBindService() { // from class: com.boyaa.iap.googlePlayV3.GoogleCheckoutHelper.1
                    @Override // com.boyaa.iap.googlePlayV3.GoogleCheckoutHelper.IBindService
                    public void bindServiceSuccess() throws IntentSender.SendIntentException {
                        GoogleCheckoutHelper.this.iBindService = null;
                        GoogleCheckoutHelper.this.requestPurchase(GoogleCheckoutHelper.this.productId, GoogleCheckoutHelper.this.orderId);
                    }
                };
                bindService();
            }
        } catch (JSONException e) {
        }
    }

    private void bindService() {
        Log.d("startBindGoolgeService-isConnected", "isConnected:" + String.valueOf(this.isConnected));
        AntExtension.log("bindGoogleServerice isConnected:" + String.valueOf(this.isConnected));
        if (!this.isConnected) {
            this.mServiceConn = new ServiceConnection() { // from class: com.boyaa.iap.googlePlayV3.GoogleCheckoutHelper.2
                @Override // android.content.ServiceConnection
                public void onServiceDisconnected(ComponentName name) {
                    Log.d("onServiceDisconnected", "Billing service disconnected.");
                    AntExtension.log("onServiceDisconnected Billing service disconnected.");
                    GoogleCheckoutHelper.this.mService = null;
                }

                /* JADX WARN: Type inference failed for: r2v17, types: [com.boyaa.iap.googlePlayV3.GoogleCheckoutHelper$2$1] */
                @Override // android.content.ServiceConnection
                public void onServiceConnected(ComponentName name, IBinder service) {
                    Log.d("onServiceConnected", "Billing service connected.");
                    AntExtension.log("onServiceDisconnected Billing service connected.");
                    GoogleCheckoutHelper.this.mService = IInAppBillingService.Stub.asInterface(service);
                    String packageName = GoogleCheckoutHelper.this.mContext.getPackageName();
                    try {
                        Log.d("onServiceConnected", "Checking for in-app billing v3 support.");
                        int response = GoogleCheckoutHelper.this.mService.isBillingSupported(3, packageName, GoogleCheckoutHelper.ITEM_TYPE_INAPP);
                        if (response == 0) {
                            GoogleCheckoutHelper.this.isConnected = true;
                            Log.d("onServiceConnected", "In-app billing v3 supported for " + packageName);
                            AntExtension.log("In-app billing v3 supported for " + packageName);
                            new Thread() { // from class: com.boyaa.iap.googlePlayV3.GoogleCheckoutHelper.2.1
                                @Override // java.lang.Thread, java.lang.Runnable
                                public void run() {
                                    GoogleCheckoutHelper.this.consumeAll();
                                }
                            }.start();
                            if (GoogleCheckoutHelper.this.iBindService != null) {
                                GoogleCheckoutHelper.this.iBindService.bindServiceSuccess();
                                AntExtension.log("iBindService bindServericeSuccess.");
                            }
                        } else {
                            Log.d("onServiceConnected", "Error checking for billing v3 support.");
                            AntExtension.log("Error checking for billing v3 support.");
                        }
                    } catch (RemoteException e) {
                    }
                }
            };
            this.mContext.bindService(new Intent("com.android.vending.billing.InAppBillingService.BIND"), this.mServiceConn, 1);
        }
    }

    public void onDestroy() {
        this.isConnected = false;
        instance = null;
        if (this.mServiceConn != null) {
            if (this.mContext != null) {
                this.mContext.unbindService(this.mServiceConn);
            }
            this.mServiceConn = null;
            this.mService = null;
        }
    }

    /* JADX INFO: Access modifiers changed from: private */
    /* JADX WARN: Type inference failed for: r0v34, types: [com.boyaa.iap.googlePlayV3.GoogleCheckoutHelper$3] */
    public void requestPurchase(String productId, String orderId) throws IntentSender.SendIntentException {
        Log.d("requestPurchase", "productId:" + productId + " orderId:" + orderId);
        AntExtension.log("requestPurchase productId:" + productId + " orderId:" + orderId);
        if (!this.isConnected) {
            Log.d("requestPurchase", "connection is not connected");
            AntExtension.log("requestPurchase connection is not connected");
            return;
        }
        try {
            if (this.mService != null) {
                Bundle buyIntentBundle = this.mService.getBuyIntent(3, this.mContext.getPackageName(), productId, ITEM_TYPE_INAPP, orderId);
                Log.i("requestPurchase", "buyIntentBundle");
                int response = getResponseCodeFromBundle(buyIntentBundle);
                AntExtension.log("response:" + response);
                if (response != 0) {
                    new Thread() { // from class: com.boyaa.iap.googlePlayV3.GoogleCheckoutHelper.3
                        @Override // java.lang.Thread, java.lang.Runnable
                        public void run() {
                            GoogleCheckoutHelper.this.consumeAll();
                        }
                    }.start();
                } else {
                    Log.i("requestPurchase", "Request purchase with productId:" + productId + " orderId:" + orderId);
                    AntExtension.log("requestPurchase Request purchase with productId:" + productId + " orderId:" + orderId);
                    PendingIntent pendingIntent = (PendingIntent) buyIntentBundle.getParcelable(RESPONSE_BUY_INTENT);
                    Integer num = 0;
                    Integer num2 = 0;
                    Integer num3 = 0;
                    this.mContext.startIntentSenderForResult(pendingIntent.getIntentSender(), 1001, new Intent(), num.intValue(), num2.intValue(), num3.intValue());
                }
            }
        } catch (IntentSender.SendIntentException e) {
            e.printStackTrace();
            AntExtension.log("SendIntentException:" + e.getMessage());
        } catch (RemoteException e1) {
            e1.printStackTrace();
            AntExtension.log("RemoteException:" + e1.getMessage());
        }
    }

    public void onActivityResult(int requestCode, int resultCode, Intent data) throws JSONException {
        String codeStr;
        Exception e;
        JSONObject jsonObject;
        if (this.isConnected && requestCode == 1001 && data != null) {
            int responseCode = data.getIntExtra(RESPONSE_CODE, 0);
            String base64SignedData = "";
            String dataSignature = "";
            String clientVerify = AppEventsConstants.EVENT_PARAM_VALUE_NO;
            if (resultCode == -1 && responseCode == 0) {
                String purchaseData = data.getStringExtra(RESPONSE_INAPP_PURCHASE_DATA);
                dataSignature = data.getStringExtra(RESPONSE_INAPP_SIGNATURE);
                Log.d("onActivityResult", "purchaseDataAndSignature:" + purchaseData + "," + dataSignature);
                if (purchaseData != null && dataSignature != null) {
                    Boolean verify = Boolean.valueOf(Security.verifyPurchase(this.base64EncodedPublicKey, purchaseData, dataSignature));
                    if (verify.booleanValue()) {
                        clientVerify = AppEventsConstants.EVENT_PARAM_VALUE_YES;
                    }
                    Log.d("verifyPurchase", "verify base64EncodedPublicKey:" + verify);
                    base64SignedData = Base64.encodeToString(purchaseData.getBytes(), 2);
                    Log.d("onActivityResult", "postData:" + base64SignedData + ", " + dataSignature);
                    codeStr = AppEventsConstants.EVENT_PARAM_VALUE_YES;
                    try {
                        consume(new Purchase(purchaseData, dataSignature));
                    } catch (JSONException e2) {
                        e2.printStackTrace();
                    }
                } else {
                    return;
                }
            } else if (resultCode == -1) {
                Log.d("onActivityResult", "Purchase failed: Result code was OK but in-app billing response was not OK");
                codeStr = "2";
            } else if (resultCode == 0) {
                Log.d("onActivityResult", "Purchase failed: User canceled");
                codeStr = "3";
            } else {
                Log.d("onActivityResult", "Purchase failed: Unknown error");
                codeStr = "4";
            }
            try {
                jsonObject = new JSONObject("{}");
            } catch (Exception e3) {
                e = e3;
            }
            try {
                jsonObject.put("codeStr", codeStr);
                jsonObject.put("base64SignedData", base64SignedData);
                jsonObject.put("dataSignature", dataSignature);
                jsonObject.put("clientVerify", clientVerify);
                AntExtension.context.dispatchStatusEventAsync(AntExtension.GOOGLE_RESULT, jsonObject.toString());
                onDestroy();
            } catch (Exception e4) {
                e = e4;
                e.printStackTrace();
            }
        }
    }

    private void consume(Purchase purchase) {
        String token = purchase.getToken();
        String productId = purchase.getSku();
        if (TextUtils.isEmpty(token) || TextUtils.isEmpty(productId)) {
            Log.d("consume", "Consume Failed: token and productId may be null");
            AntExtension.log("consumeConsume Failed: token and productId may be null");
            return;
        }
        try {
            if (this.mService != null && this.mContext != null) {
                int response = this.mService.consumePurchase(3, this.mContext.getPackageName(), token);
                if (response == 0) {
                    Log.d("consume", "Consume Successed with productId: " + productId);
                    AntExtension.log("consumeConsume Successed with productId: " + productId);
                } else {
                    Log.d("consume", "Consume Failed: " + productId);
                    AntExtension.log("consumeConsume Failed: " + productId);
                }
            } else {
                Log.d("consume", "Consume Failed: BillingService is null");
                AntExtension.log("consumeConsume Failed: BillingService is null");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /* JADX INFO: Access modifiers changed from: private */
    public void consumeAll() {
        String continueToken = null;
        do {
            Log.d("consumeAll", "Calling getPurchases with continuation token: " + continueToken);
            AntExtension.log("consumeAllCalling getPurchases with continuation token: " + continueToken);
            Bundle ownedItems = null;
            try {
                ownedItems = this.mService.getPurchases(3, this.mContext.getPackageName(), ITEM_TYPE_INAPP, continueToken);
            } catch (RemoteException e) {
            }
            if (ownedItems != null) {
                int response = getResponseCodeFromBundle(ownedItems);
                Log.d("consumeAll", "Owned items response: " + String.valueOf(response));
                AntExtension.log("consumeAllOwned items response: " + String.valueOf(response));
                AntExtension.log("wonedItems:" + ownedItems.toString());
                if (response != 0) {
                    Log.d("consumeAll", "getPurchases() failed");
                    AntExtension.log("consumeAllgetPurchases() failed");
                    return;
                }
                if (!ownedItems.containsKey(RESPONSE_INAPP_ITEM_LIST) || !ownedItems.containsKey(RESPONSE_INAPP_PURCHASE_DATA_LIST) || !ownedItems.containsKey(RESPONSE_INAPP_SIGNATURE_LIST)) {
                    Log.d("consumeAll", "Bundle returned from getPurchases() doesn't contain required fields.");
                    AntExtension.log("consumeAllBundle returned from getPurchases() doesn't contain required fields.");
                    return;
                }
                ArrayList<String> ownedSkus = ownedItems.getStringArrayList(RESPONSE_INAPP_ITEM_LIST);
                ArrayList<String> purchaseDataList = ownedItems.getStringArrayList(RESPONSE_INAPP_PURCHASE_DATA_LIST);
                ArrayList<String> signatureList = ownedItems.getStringArrayList(RESPONSE_INAPP_SIGNATURE_LIST);
                for (int i = 0; i < purchaseDataList.size(); i++) {
                    String purchaseData = purchaseDataList.get(i);
                    String signature = signatureList.get(i);
                    String sku = ownedSkus.get(i);
                    Log.d("consumeAll", "Purchase signature verification **FAILED**. with product id " + sku);
                    Log.d("consumeAll", "   Purchase data: " + purchaseData);
                    Log.d("consumeAll", "   Signature: " + signature);
                    AntExtension.log("consumeAllPurchase signature verification **FAILED**. with product id " + sku);
                    AntExtension.log("consumeAll   Purchase data: " + purchaseData);
                    AntExtension.log("consumeAll   Signature: " + signature);
                    try {
                        consume(new Purchase(purchaseData, signature));
                    } catch (JSONException e2) {
                        e2.printStackTrace();
                    }
                }
                continueToken = ownedItems.getString(INAPP_CONTINUATION_TOKEN);
                Log.d("consumeAll", " Continuation token: " + continueToken);
                AntExtension.log("consumeAll Continuation token: " + continueToken);
            } else {
                return;
            }
        } while (!TextUtils.isEmpty(continueToken));
    }

    private int getResponseCodeFromBundle(Bundle b) {
        Object o = b.get(RESPONSE_CODE);
        if (o == null) {
            Log.d("getResponseCodeFromBundle", "Bundle with null response code, assuming OK (known issue)");
            AntExtension.log("getResponseCodeFromBundleBundle with null response code, assuming OK (known issue)");
            return 0;
        }
        if (o instanceof Integer) {
            return ((Integer) o).intValue();
        }
        if (o instanceof Long) {
            return (int) ((Long) o).longValue();
        }
        Log.d("getResponseCodeFromBundle", "Unexpected type for bundle response code.");
        AntExtension.log("getResponseCodeFromBundleUnexpected type for bundle response code.");
        return 6;
    }
}
