package com.mimopay;

import android.content.Context;
import android.content.Intent;
import android.util.Log;
import com.facebook.AppEventsConstants;
import java.io.IOException;
import java.util.ArrayList;

/* loaded from: classes.dex */
public class Mimopay {
    public static MimopayInterface mMi = null;
    private Context mContext;
    private String mSdkVersion = "v1.3.1";
    private String mPhoneNumber = null;
    private String mAirtimeValue = null;
    private String sCode = null;
    private MimopayQuietModeCore mCore = null;

    /* JADX INFO: Access modifiers changed from: private */
    public void jprintf(String s) {
        if (MimopayStuff.mEnableLog) {
            Log.d("JimBas", "Mimopay: " + s);
        }
    }

    public Mimopay(Context context, String emailOrUserId, String merchantCode, String productName, String transactionId, String secretKeyStaging, String secretKeyGateway, String currency, MimopayInterface mi) {
        this.mContext = null;
        this.mContext = context;
        MimopayStuff.sEmailOrUserId = emailOrUserId;
        MimopayStuff.sMerchantCode = merchantCode;
        MimopayStuff.sProductName = productName;
        MimopayStuff.sTransactionId = transactionId;
        MimopayStuff.sSecretKeyStaging = secretKeyStaging;
        MimopayStuff.sSecretKeyGateway = secretKeyGateway;
        MimopayStuff.sSecretKey = secretKeyStaging;
        MimopayStuff.sCurrency = currency;
        MimopayStuff.sAmount = AppEventsConstants.EVENT_PARAM_VALUE_NO;
        mMi = mi;
    }

    private class MimopayQuietModeCore extends MimopayCore {
        private MimopayQuietModeCore() {
        }

        @Override // com.mimopay.MimopayCore
        public void onError(String serr) {
            ArrayList<String> als = new ArrayList<>();
            als.add(serr);
            if (Mimopay.mMi != null) {
                Mimopay.mMi.onReturn("ERROR", als);
            }
        }

        @Override // com.mimopay.MimopayCore
        public void onMerchantPaymentMethodRetrieved() {
            Mimopay.this.jprintf(String.format("%s %s %d", MimopayStuff.sPaymentMethod, MimopayStuff.sChannel, Integer.valueOf(Mimopay.this.mCore.mAlsActiveIdx)));
            if (MimopayStuff.sPaymentMethod.equals("Topup")) {
                Mimopay.this.mCore.setChannelActiveIndex(MimopayStuff.sChannel);
                Mimopay.this.mCore.mHttppostCode = Mimopay.this.sCode;
                Mimopay.this.mCore.executeBtnAction();
                return;
            }
            if (MimopayStuff.sPaymentMethod.equals("Airtime")) {
                Mimopay.this.mCore.mAlsActiveIdx = 0;
                Mimopay.this.mCore.mHttppostCode = Mimopay.this.mAirtimeValue;
                Mimopay.this.mCore.mHttppostPhoneNumber = Mimopay.this.mPhoneNumber;
                Mimopay.this.mCore.executeBtnAction();
                return;
            }
            if (MimopayStuff.sPaymentMethod.equals("ATM")) {
                Mimopay.this.mCore.setChannelActiveIndex(MimopayStuff.sChannel);
                Mimopay.this.mCore.mHttppostCode = Mimopay.this.mCore.alsDenomValue.get(Mimopay.this.mCore.mAlsActiveIdx);
                Mimopay.this.mCore.executeBtnAction();
            } else if (MimopayStuff.sPaymentMethod.equals("XL")) {
                Mimopay.this.mCore.setChannelActiveIndex(MimopayStuff.sChannel);
                if (MimopayStuff.sChannel.equals("xl_airtime")) {
                    Mimopay.this.mCore.mHttppostCode = Mimopay.this.mAirtimeValue;
                    Mimopay.this.mCore.mHttppostPhoneNumber = Mimopay.this.mPhoneNumber;
                } else if (MimopayStuff.sChannel.equals("xl_hrn")) {
                    Mimopay.this.mCore.mHttppostCode = Mimopay.this.sCode;
                }
                Mimopay.this.jprintf(String.format("%s %s %d", MimopayStuff.sPaymentMethod, MimopayStuff.sChannel, Integer.valueOf(Mimopay.this.mCore.mAlsActiveIdx)));
                Mimopay.this.mCore.executeBtnAction();
            }
        }

        @Override // com.mimopay.MimopayCore
        public void onResultUI(String channel, ArrayList<String> params) {
            if (channel.equals("smartfren") || channel.equals("sevelin") || channel.equals("xl_hrn")) {
                String fstopupres = params.get(0);
                String fstransid = params.get(1);
                ArrayList<String> als = new ArrayList<>();
                als.add(Mimopay.this.mCore.alsBtnAction.get(Mimopay.this.mCore.mAlsActiveIdx));
                als.add(fstopupres);
                als.add(fstransid);
                if (Mimopay.mMi != null) {
                    Mimopay.mMi.onReturn("SUCCESS", als);
                    return;
                }
                return;
            }
            if (channel.equals("atm_bca") || channel.equals("atm_bersama")) {
                String fcompanyCode = params.get(0);
                String ftotalBill = params.get(1);
                String ftransId = params.get(2);
                ArrayList<String> als2 = new ArrayList<>();
                als2.add(Mimopay.this.mCore.alsBtnAction.get(Mimopay.this.mCore.mAlsActiveIdx));
                als2.add(fcompanyCode);
                als2.add(ftotalBill);
                als2.add(ftransId);
                if (Mimopay.mMi != null) {
                    Mimopay.mMi.onReturn("SUCCESS", als2);
                    return;
                }
                return;
            }
            if (channel.equals("upoint_airtime")) {
                String fsmsContent = params.get(0);
                String fsmsNumber = params.get(1);
                ArrayList<String> als3 = new ArrayList<>();
                als3.add(Mimopay.this.mCore.alsBtnAction.get(Mimopay.this.mCore.mAlsActiveIdx));
                als3.add(fsmsContent);
                als3.add(fsmsNumber);
                if (Mimopay.mMi != null) {
                    Mimopay.mMi.onReturn("SUCCESS", als3);
                    return;
                }
                return;
            }
            if (channel.equals("xl_airtime")) {
                ArrayList<String> als4 = new ArrayList<>();
                als4.add(Mimopay.this.mCore.alsBtnAction.get(Mimopay.this.mCore.mAlsActiveIdx));
                int j = params.size();
                for (int i = 0; i < j; i++) {
                    als4.add(params.get(i));
                }
                if (Mimopay.mMi != null) {
                    Mimopay.mMi.onReturn("SUCCESS", als4);
                }
            }
        }

        @Override // com.mimopay.MimopayCore
        public void onSmsCompleted(boolean success, ArrayList<String> alsSms) {
            if (success) {
            }
        }
    }

    private void doDefaultUI(String paymentMethod, String channel) {
        Intent mimopayIntent = new Intent(this.mContext, (Class<?>) MimopayActivity.class);
        MimopayStuff.sPaymentMethod = paymentMethod;
        MimopayStuff.sChannel = channel;
        if (this.mPhoneNumber != null) {
            mimopayIntent.putExtra("PhoneNumber", this.mPhoneNumber);
            mimopayIntent.putExtra("AirtimeValue", this.mAirtimeValue);
        }
        mimopayIntent.setFlags(268435456);
        this.mContext.startActivity(mimopayIntent);
    }

    public void executeTopup() {
        doDefaultUI("Topup", "");
    }

    public void executeTopup(String channel) {
        doDefaultUI("Topup", channel);
    }

    public void executeTopup(String channel, String code) {
        this.mCore = new MimopayQuietModeCore();
        MimopayStuff.sPaymentMethod = "Topup";
        MimopayStuff.sChannel = channel;
        this.sCode = new String(code);
        this.mCore.executePayment();
    }

    public void executeATMs() {
        doDefaultUI("ATM", "");
    }

    public void executeATMs(String channel) {
        doDefaultUI("ATM", channel);
    }

    public void executeATMs(String channel, String amount) {
        this.mCore = new MimopayQuietModeCore();
        MimopayStuff.sPaymentMethod = "ATM";
        MimopayStuff.sChannel = channel;
        MimopayStuff.sAmount = amount;
        this.mCore.executePayment();
    }

    public void executeUPointAirtime() {
        doDefaultUI("Airtime", "upoint");
    }

    public void executeUPointAirtime(String amount, String phoneNumber, boolean autosendsms) {
        this.mAirtimeValue = amount;
        this.mPhoneNumber = phoneNumber;
        if (!autosendsms) {
            this.mCore = new MimopayQuietModeCore();
            MimopayStuff.sPaymentMethod = "Airtime";
            MimopayStuff.sChannel = "upoint";
            this.mCore.executePayment();
            return;
        }
        doDefaultUI("Airtime", "upoint");
    }

    public void executeXL() {
        doDefaultUI("XL", "");
    }

    public void executeXLAirtime() {
        doDefaultUI("XL", "xl_airtime");
    }

    public void executeXLHrn(String code) {
        this.mCore = new MimopayQuietModeCore();
        MimopayStuff.sPaymentMethod = "XL";
        MimopayStuff.sChannel = "xl_hrn";
        this.sCode = new String(code);
        this.mCore.executePayment();
    }

    public void executeXLHrn() {
        doDefaultUI("XL", "xl_hrn");
    }

    public void executeXLAirtime(String amount, String phoneNumber, boolean autosendsms) {
        this.mAirtimeValue = amount;
        this.mPhoneNumber = phoneNumber;
        if (!autosendsms) {
            this.mCore = new MimopayQuietModeCore();
            MimopayStuff.sPaymentMethod = "XL";
            MimopayStuff.sChannel = "xl_airtime";
            this.mCore.executePayment();
            return;
        }
        doDefaultUI("XL", "xl_airtime");
    }

    public String getSdkVersion() {
        return this.mSdkVersion;
    }

    public void enableGateway(boolean enable) {
        MimopayStuff.mMimopayUrlPoint = enable ? "gateway" : "staging";
        MimopayStuff.sSecretKey = enable ? MimopayStuff.sSecretKeyGateway : MimopayStuff.sSecretKeyStaging;
    }

    public void enableLog(boolean enable) {
        MimopayStuff.mEnableLog = enable;
    }

    public String[] getLastResult() throws IOException {
        String[] sarr = null;
        ArrayList<String> als = MimopayStuff.loadLastResult();
        if (als != null) {
            int ires = als.size();
            sarr = new String[ires];
            for (int i = 0; i < ires; i++) {
                sarr[i] = als.get(i);
            }
        }
        return sarr;
    }
}
