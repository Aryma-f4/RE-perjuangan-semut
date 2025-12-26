package com.boyaa.iap.googlePlayV3;

import android.text.TextUtils;
import android.util.Base64;
import android.util.Log;
import com.boyaa.antwarsId.AntExtension;
import java.security.InvalidKeyException;
import java.security.KeyFactory;
import java.security.NoSuchAlgorithmException;
import java.security.PublicKey;
import java.security.Signature;
import java.security.SignatureException;
import java.security.spec.InvalidKeySpecException;
import java.security.spec.X509EncodedKeySpec;

/* loaded from: classes.dex */
public class Security {
    private static final String KEY_FACTORY_ALGORITHM = "RSA";
    private static final String SIGNATURE_ALGORITHM = "SHA1withRSA";
    private static final String TAG = "IABUtil/Security";

    public static boolean verifyPurchase(String base64PublicKey, String signedData, String signature) throws NoSuchAlgorithmException, SignatureException, InvalidKeyException {
        if (signedData == null) {
            Log.e(TAG, "data is null");
            AntExtension.log("Security data is null");
            return false;
        }
        if (!TextUtils.isEmpty(signature)) {
            PublicKey key = generatePublicKey(base64PublicKey);
            boolean verified = verify(key, signedData, signature);
            if (!verified) {
                Log.w(TAG, "signature does not match data.");
                AntExtension.log("Security signature does not match data.");
                return false;
            }
        }
        return true;
    }

    public static PublicKey generatePublicKey(String encodedPublicKey) throws NoSuchAlgorithmException {
        try {
            byte[] decodedKey = Base64.decode(encodedPublicKey, 0);
            KeyFactory keyFactory = KeyFactory.getInstance(KEY_FACTORY_ALGORITHM);
            return keyFactory.generatePublic(new X509EncodedKeySpec(decodedKey));
        } catch (IllegalArgumentException e) {
            Log.e(TAG, "Base64 decoding failed.");
            AntExtension.log("Security Base64 decoding failed.");
            throw new IllegalArgumentException(e);
        } catch (NoSuchAlgorithmException e2) {
            throw new RuntimeException(e2);
        } catch (InvalidKeySpecException e3) {
            Log.e(TAG, "Invalid key specification.");
            AntExtension.log("Security Invalid key specification.");
            throw new IllegalArgumentException(e3);
        }
    }

    public static boolean verify(PublicKey publicKey, String signedData, String signature) throws NoSuchAlgorithmException, SignatureException, InvalidKeyException {
        try {
            Signature sig = Signature.getInstance(SIGNATURE_ALGORITHM);
            sig.initVerify(publicKey);
            sig.update(signedData.getBytes());
            if (!sig.verify(Base64.decode(signature, 0))) {
                Log.e(TAG, "Signature verification failed.");
                AntExtension.log("Security Signature verification failed.");
                return false;
            }
            return true;
        } catch (IllegalArgumentException e) {
            Log.e(TAG, "Base64 decoding failed.");
            return false;
        } catch (InvalidKeyException e2) {
            Log.e(TAG, "Invalid key specification.");
            return false;
        } catch (NoSuchAlgorithmException e3) {
            Log.e(TAG, "NoSuchAlgorithmException.");
            return false;
        } catch (SignatureException e4) {
            Log.e(TAG, "Signature exception.");
            return false;
        }
    }
}
