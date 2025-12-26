package com.mimopay.merchant;

import java.security.Key;
import javax.crypto.Cipher;
import javax.crypto.spec.SecretKeySpec;

/* loaded from: classes.dex */
public final class Merchant {
    private static final String ALGO = "AES";

    public static String get(boolean staging, String encryptedSecretKey) throws Exception {
        byte[] b = MerchantBase64.decode(staging ? MerchantKey.msKeyValueStaging : MerchantKey.msKeyValueGateway);
        Key key = new SecretKeySpec(b, ALGO);
        Cipher c = Cipher.getInstance(ALGO);
        c.init(2, key);
        byte[] decordedValue = MerchantBase64.decode(encryptedSecretKey);
        byte[] decValue = c.doFinal(decordedValue);
        String decryptedValue = new String(decValue);
        return decryptedValue;
    }
}
