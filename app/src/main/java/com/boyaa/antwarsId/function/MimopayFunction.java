package com.boyaa.antwarsId.function;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.widget.EditText;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREInvalidObjectException;
import com.adobe.fre.FREObject;
import com.adobe.fre.FRETypeMismatchException;
import com.adobe.fre.FREWrongThreadException;
import com.boyaa.antwarsId.AntExtension;
import com.facebook.widget.FacebookDialog;
import com.mimopay.Mimopay;
import com.mimopay.MimopayInterface;
import com.mimopay.merchant.Merchant;
import java.io.IOException;
import java.util.ArrayList;

/* loaded from: classes.dex */
public class MimopayFunction implements FREFunction {
    private static String key = "";
    private final int TOPUP = 1;
    private final int SMARTFREN = 2;
    private final int SEVELIN = 3;
    private final int ATM = 4;
    private final int BCA = 5;
    private final int BERSAMA = 6;
    private final int UPOINT = 7;
    private final int XL = 8;
    private final int XLAIRTIME = 9;
    private final int XLHRN = 10;
    private final int LASTRESULT = 11;
    private FREContext _context = null;
    boolean mQuietMode = false;
    Mimopay mMimopay = null;
    MimopayInterface mMimopayInterface = new MimopayInterface() { // from class: com.boyaa.antwarsId.function.MimopayFunction.1
        @Override // com.mimopay.MimopayInterface
        public void onReturn(String info, ArrayList<String> params) {
            AntExtension.log("onReturn: " + info);
            if (params != null) {
                try {
                    String toastmsg = String.valueOf("") + info + "\n\n";
                    int j = params.size();
                    for (int i = 0; i < j; i++) {
                        String s = params.get(i);
                        toastmsg = String.valueOf(toastmsg) + s + "\n";
                        AntExtension.log("[" + i + "] ---- " + s);
                    }
                    if (MimopayFunction.this.mQuietMode) {
                        String ftoastmsg = toastmsg;
                        AntExtension.log(ftoastmsg);
                    }
                    MimopayFunction.this._context.dispatchStatusEventAsync(AntExtension.MIMOPAY_RESULT, toastmsg);
                } catch (Exception e) {
                    e.printStackTrace();
                    AntExtension.log(e.getMessage());
                }
            }
        }
    };
    String emailOrUserId = "1385479814";
    String merchantCode = "ID-0047";
    String productName = "Boyaa+TeaxsPoker";
    String transactionId = "";
    String currency = "IDR";
    String payCoin = "1000";
    String phoneNum = "082114078308";

    /* JADX INFO: Access modifiers changed from: private */
    public void mimopayPayment(int payId) throws IOException {
        String secretKeyStaging = null;
        String secretKeyGateway = null;
        try {
            secretKeyStaging = Merchant.get(true, "S1RGUfUjhIr6U8ubYOX9Mg==");
            secretKeyGateway = Merchant.get(false, "fhSI5b3fjMq7UfJFhWqXYA==");
        } catch (Exception e) {
            e.printStackTrace();
            AntExtension.log(e.getMessage());
        }
        AntExtension.log("secretKeyStaging:" + secretKeyStaging + "  secretKeyGateway:" + secretKeyGateway);
        if (secretKeyStaging == null || secretKeyGateway == null) {
            AntExtension.log("secretKey problem!");
        }
        this.mMimopay = new Mimopay(getAndroidContext(), this.emailOrUserId, this.merchantCode, this.productName, this.transactionId, secretKeyStaging, secretKeyGateway, this.currency, this.mMimopayInterface);
        AntExtension.log("init MimoPay Done, sdkVersion:" + this.mMimopay.getSdkVersion());
        this.mMimopay.enableGateway(true);
        this.mMimopay.enableLog(true);
        this.mQuietMode = true;
        switch (payId) {
            case 1:
                this.mMimopay.executeTopup();
                break;
            case 2:
                this.mMimopay.executeTopup("smartfren");
                break;
            case 3:
                this.mMimopay.executeTopup("sevelin");
                break;
            case 4:
                this.mMimopay.executeATMs();
                break;
            case 5:
                this.mMimopay.executeATMs("atm_bca");
                break;
            case 6:
                this.mMimopay.executeATMs("atm_bersama");
                break;
            case 7:
                try {
                    this.mQuietMode = true;
                    AntExtension.log("payCoin:" + this.payCoin + " phoneNum:" + this.phoneNum);
                    this.mMimopay.executeUPointAirtime(this.payCoin, this.phoneNum, true);
                    break;
                } catch (Exception e1) {
                    AntExtension.log(e1.getMessage());
                    return;
                }
            case 8:
                this.mMimopay.executeXL();
                break;
            case 9:
                AntExtension.log("XLAIRTIME----------");
                try {
                    this.mQuietMode = true;
                    this.mMimopay.executeXLAirtime(this.payCoin, this.phoneNum, false);
                    break;
                } catch (Exception e2) {
                    e2.printStackTrace();
                    AntExtension.log(e2.getMessage());
                    return;
                }
            case 10:
                this.mMimopay.executeXLHrn();
                break;
            case 11:
                String s = "";
                String[] sarr = this.mMimopay.getLastResult();
                if (sarr != null) {
                    for (String str : sarr) {
                        s = String.valueOf(s) + str + "\n";
                    }
                }
                AntExtension.log("LastResult:" + s);
                break;
        }
    }

    private Context getAndroidContext() {
        if (this._context != null) {
            return this._context.getActivity().getBaseContext();
        }
        return null;
    }

    @Override // com.adobe.fre.FREFunction
    public FREObject call(FREContext context, FREObject[] arg1) {
        this._context = context;
        try {
            this.emailOrUserId = arg1[0].getAsString();
            this.productName = arg1[1].getAsString();
            this.transactionId = arg1[2].getAsString();
            this.payCoin = arg1[3].getAsString();
            AntExtension.log("Mimopay's params");
            AntExtension.log("sid:" + this.emailOrUserId);
            AntExtension.log("product:" + this.productName);
            AntExtension.log("order:" + this.transactionId);
            AntExtension.log("money:" + this.payCoin);
            AntExtension.log("Mimopay's params end ---------------------------");
        } catch (FREInvalidObjectException e) {
            e.printStackTrace();
        } catch (FRETypeMismatchException e2) {
            e2.printStackTrace();
        } catch (FREWrongThreadException e3) {
            e3.printStackTrace();
        } catch (IllegalStateException e4) {
            e4.printStackTrace();
        }
        inputTitleDialog();
        return null;
    }

    private void inputTitleDialog() {
        final EditText inputServer = new EditText(this._context.getActivity());
        inputServer.setFocusable(true);
        if (!key.equals("")) {
            inputServer.setText(key);
        }
        AlertDialog.Builder builder = new AlertDialog.Builder(this._context.getActivity());
        builder.setTitle("tip");
        builder.setMessage("pls enter your phone num");
        builder.setView(inputServer);
        builder.setPositiveButton("enter", new DialogInterface.OnClickListener() { // from class: com.boyaa.antwarsId.function.MimopayFunction.2
            @Override // android.content.DialogInterface.OnClickListener
            public void onClick(DialogInterface dialog, int which) throws IOException {
                MimopayFunction.key = inputServer.getText().toString();
                MimopayFunction.this.phoneNum = MimopayFunction.key;
                AntExtension.log("user's phone num:" + inputServer.getText().toString());
                AntExtension.log("[call MimoPayFunction] begin");
                MimopayFunction.this.mimopayPayment(7);
                AntExtension.log("[call MimoPayFunction] Done");
            }
        });
        builder.setNegativeButton(FacebookDialog.COMPLETION_GESTURE_CANCEL, new DialogInterface.OnClickListener() { // from class: com.boyaa.antwarsId.function.MimopayFunction.3
            @Override // android.content.DialogInterface.OnClickListener
            public void onClick(DialogInterface dialog, int which) {
                AntExtension.log("user cancel the inputDlg");
            }
        });
        builder.show();
    }
}
