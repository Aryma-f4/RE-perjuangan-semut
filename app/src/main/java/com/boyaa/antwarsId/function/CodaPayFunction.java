package com.boyaa.antwarsId.function;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREInvalidObjectException;
import com.adobe.fre.FREObject;
import com.adobe.fre.FRETypeMismatchException;
import com.adobe.fre.FREWrongThreadException;
import com.boyaa.antwarsId.AntExtension;
import com.boyaa.tools.CodaPayResultActitity;
import com.codapayments.sdk.CodaSDK;
import com.codapayments.sdk.model.ItemInfo;
import com.codapayments.sdk.model.PayInfo;
import java.util.ArrayList;

/* loaded from: classes.dex */
public class CodaPayFunction implements FREFunction {
    public static String ENVIRONMENT = "Production";
    public static String SELECTED_COUNTRY = "Indonesia";
    public static String CURRENCY_RUPIAH = "RP";
    public static String IDN_API_KEY = "5a8ca8f31f19a23c41edd14b29a74fd2";
    public static short IDN_COUNTRY_CODE = 360;
    public static short IDN_CURRENCY_CODE = 360;

    @Override // com.adobe.fre.FREFunction
    public FREObject call(FREContext context, FREObject[] arg1) {
        ArrayList<ItemInfo> mItemInfos = new ArrayList<>();
        try {
            String tag = arg1[0].getAsString();
            String orderId = arg1[1].getAsString();
            String apiKey = arg1[2].getAsString();
            int country = arg1[3].getAsInt();
            int currency = arg1[4].getAsInt();
            String itemInfos = arg1[5].getAsString();
            String[] infos = itemInfos.split("\\|");
            AntExtension.logCodaPayMsg(String.valueOf(tag) + "|" + orderId + "|" + apiKey + "|" + country + "|" + currency);
            AntExtension.logCodaPayMsg("itemInfos:" + itemInfos);
            AntExtension.logCodaPayMsg(String.valueOf(infos[0]) + "|" + infos[1] + "|" + infos[2] + "|" + infos[3]);
            ItemInfo itemInfo = new ItemInfo(infos[0], infos[1], Double.parseDouble(infos[2]), Short.parseShort(infos[3]));
            mItemInfos.add(itemInfo);
            AntExtension.logCodaPayMsg("init codaPay");
            CodaSDK codaPay = CodaSDK.getInstance(context.getActivity(), CodaPayResultActitity.class);
            PayInfo payInfo = new PayInfo(apiKey, orderId, (short) country, (short) currency, ENVIRONMENT, mItemInfos);
            codaPay.pay(payInfo);
            AntExtension.logCodaPayMsg("codaPay begin");
            return null;
        } catch (FREInvalidObjectException e) {
            e.printStackTrace();
            AntExtension.logCodaPayMsg(e.getMessage());
            return null;
        } catch (FRETypeMismatchException e2) {
            e2.printStackTrace();
            AntExtension.logCodaPayMsg(e2.getMessage());
            return null;
        } catch (FREWrongThreadException e3) {
            e3.printStackTrace();
            AntExtension.logCodaPayMsg(e3.getMessage());
            return null;
        } catch (IllegalStateException e4) {
            e4.printStackTrace();
            AntExtension.logCodaPayMsg(e4.getMessage());
            return null;
        } catch (Exception e5) {
            AntExtension.logCodaPayMsg(e5.getMessage());
            return null;
        }
    }

    public static void main(String[] args) {
    }
}
