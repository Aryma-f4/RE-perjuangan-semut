package com.boyaa.tools;

import com.boyaa.antwarsId.AntExtension;
import com.codapayments.sdk.interfaces.PaymentResultHandler;
import com.codapayments.sdk.model.PayResult;

/* loaded from: classes.dex */
public class CodaPayResultActitity implements PaymentResultHandler {
    @Override // com.codapayments.sdk.interfaces.PaymentResultHandler
    public void handleClose(PayResult payResult) {
        if (payResult.getResultCode() == 0) {
            payResult.getTotalPrice();
            payResult.getTxnId();
            StringBuffer itemName = new StringBuffer("Coins");
            String message = new StringBuffer("Success! ").append(payResult.getMsisdn()).append(" has been charged ").append(payResult.getTotalPrice()).append(" for ").append(itemName.toString()).append(".").toString();
            AntExtension.showToastMessage(message);
            AntExtension.logCodaPayMsg("Total Price : " + String.valueOf(payResult.getTotalPrice()));
            AntExtension.logCodaPayMsg("Transaction Id : " + String.valueOf(payResult.getTxnId()));
            return;
        }
        if (payResult.getResultDesc() != null && payResult.getResultDesc().length() > 0) {
            AntExtension.showToastMessage(payResult.getResultDesc());
        } else {
            AntExtension.showToastMessage("Transaction failed!");
        }
        AntExtension.showToastMessage("Result Header : " + String.valueOf(payResult.getResultDesc()));
    }

    @Override // com.codapayments.sdk.interfaces.PaymentResultHandler
    public void handleResult(PayResult payResult) {
        if (payResult.getResultCode() == 0) {
            payResult.getTotalPrice();
            payResult.getTxnId();
            StringBuffer itemName = new StringBuffer("Coins");
            String message = new StringBuffer("Success! ").append(payResult.getMsisdn()).append(" has been charged ").append(payResult.getTotalPrice()).append(" for ").append(itemName.toString()).append(".").toString();
            AntExtension.showToastMessage(message);
            AntExtension.logCodaPayMsg("Total Price : " + String.valueOf(payResult.getTotalPrice()));
            AntExtension.logCodaPayMsg("Transaction Id : " + String.valueOf(payResult.getTxnId()));
            return;
        }
        AntExtension.showToastMessage("Transaction failed!");
        AntExtension.logCodaPayMsg("Result Header : " + String.valueOf(payResult.getResultHeader()));
    }

    public static void main(String[] args) {
    }
}
