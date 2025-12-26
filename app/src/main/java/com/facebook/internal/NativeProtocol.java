package com.facebook.internal;

import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.content.pm.Signature;
import android.database.Cursor;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.text.TextUtils;
import com.facebook.FacebookException;
import com.facebook.FacebookOperationCanceledException;
import com.facebook.Session;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.UUID;

/* loaded from: classes.dex */
public final class NativeProtocol {
    public static final String ACTION_FEED_DIALOG = "com.facebook.platform.action.request.FEED_DIALOG";
    public static final String ACTION_FEED_DIALOG_REPLY = "com.facebook.platform.action.reply.FEED_DIALOG";
    public static final String ACTION_LOGIN_DIALOG = "com.facebook.platform.action.request.LOGIN_DIALOG";
    static final String ACTION_LOGIN_DIALOG_REPLY = "com.facebook.platform.action.reply.LOGIN_DIALOG";
    public static final String ACTION_OGACTIONPUBLISH_DIALOG = "com.facebook.platform.action.request.OGACTIONPUBLISH_DIALOG";
    public static final String ACTION_OGACTIONPUBLISH_DIALOG_REPLY = "com.facebook.platform.action.reply.OGACTIONPUBLISH_DIALOG";
    public static final String AUDIENCE_EVERYONE = "EVERYONE";
    public static final String AUDIENCE_FRIENDS = "ALL_FRIENDS";
    public static final String AUDIENCE_ME = "SELF";
    private static final String BASIC_INFO = "basic_info";
    public static final String CONTENT_SCHEME = "content://";
    public static final int DIALOG_REQUEST_CODE = 64207;
    public static final String ERROR_APPLICATION_ERROR = "ApplicationError";
    public static final String ERROR_NETWORK_ERROR = "NetworkError";
    public static final String ERROR_PERMISSION_DENIED = "PermissionDenied";
    public static final String ERROR_PROTOCOL_ERROR = "ProtocolError";
    public static final String ERROR_SERVICE_DISABLED = "ServiceDisabled";
    public static final String ERROR_UNKNOWN_ERROR = "UnknownError";
    public static final String ERROR_USER_CANCELED = "UserCanceled";
    public static final String EXTRA_ACCESS_TOKEN = "com.facebook.platform.extra.ACCESS_TOKEN";
    public static final String EXTRA_ACTION = "com.facebook.platform.extra.ACTION";
    public static final String EXTRA_ACTION_TYPE = "com.facebook.platform.extra.ACTION_TYPE";
    public static final String EXTRA_APPLICATION_ID = "com.facebook.platform.extra.APPLICATION_ID";
    public static final String EXTRA_APPLICATION_NAME = "com.facebook.platform.extra.APPLICATION_NAME";
    public static final String EXTRA_DATA_FAILURES_FATAL = "com.facebook.platform.extra.DATA_FAILURES_FATAL";
    public static final String EXTRA_DESCRIPTION = "com.facebook.platform.extra.DESCRIPTION";
    public static final String EXTRA_EXPIRES_SECONDS_SINCE_EPOCH = "com.facebook.platform.extra.EXPIRES_SECONDS_SINCE_EPOCH";
    public static final String EXTRA_FRIEND_TAGS = "com.facebook.platform.extra.FRIENDS";
    public static final String EXTRA_GET_INSTALL_DATA_PACKAGE = "com.facebook.platform.extra.INSTALLDATA_PACKAGE";
    public static final String EXTRA_IMAGE = "com.facebook.platform.extra.IMAGE";
    public static final String EXTRA_LINK = "com.facebook.platform.extra.LINK";
    public static final String EXTRA_PERMISSIONS = "com.facebook.platform.extra.PERMISSIONS";
    public static final String EXTRA_PLACE_TAG = "com.facebook.platform.extra.PLACE";
    public static final String EXTRA_PREVIEW_PROPERTY_NAME = "com.facebook.platform.extra.PREVIEW_PROPERTY_NAME";
    public static final String EXTRA_PROTOCOL_ACTION = "com.facebook.platform.protocol.PROTOCOL_ACTION";
    public static final String EXTRA_PROTOCOL_CALL_ID = "com.facebook.platform.protocol.CALL_ID";
    public static final String EXTRA_PROTOCOL_VERSION = "com.facebook.platform.protocol.PROTOCOL_VERSION";
    static final String EXTRA_PROTOCOL_VERSIONS = "com.facebook.platform.extra.PROTOCOL_VERSIONS";
    public static final String EXTRA_REF = "com.facebook.platform.extra.REF";
    public static final String EXTRA_SUBTITLE = "com.facebook.platform.extra.SUBTITLE";
    public static final String EXTRA_TITLE = "com.facebook.platform.extra.TITLE";
    public static final String EXTRA_WRITE_PRIVACY = "com.facebook.platform.extra.WRITE_PRIVACY";
    static final String FACEBOOK_PACKAGE = "com.facebook.katana";
    static final String FACEBOOK_PROXY_AUTH_ACTIVITY = "com.facebook.katana.ProxyAuth";
    public static final String FACEBOOK_PROXY_AUTH_APP_ID_KEY = "client_id";
    public static final String FACEBOOK_PROXY_AUTH_E2E_KEY = "e2e";
    public static final String FACEBOOK_PROXY_AUTH_PERMISSIONS_KEY = "scope";
    static final String FACEBOOK_TOKEN_REFRESH_ACTIVITY = "com.facebook.katana.platform.TokenRefreshService";
    public static final String IMAGE_URL_KEY = "url";
    public static final String IMAGE_USER_GENERATED_KEY = "user_generated";
    static final String INTENT_ACTION_PLATFORM_ACTIVITY = "com.facebook.platform.PLATFORM_ACTIVITY";
    static final String INTENT_ACTION_PLATFORM_SERVICE = "com.facebook.platform.PLATFORM_SERVICE";
    static final String KATANA_SIGNATURE = "30820268308201d102044a9c4610300d06092a864886f70d0101040500307a310b3009060355040613025553310b3009060355040813024341311230100603550407130950616c6f20416c746f31183016060355040a130f46616365626f6f6b204d6f62696c653111300f060355040b130846616365626f6f6b311d301b0603550403131446616365626f6f6b20436f72706f726174696f6e3020170d3039303833313231353231365a180f32303530303932353231353231365a307a310b3009060355040613025553310b3009060355040813024341311230100603550407130950616c6f20416c746f31183016060355040a130f46616365626f6f6b204d6f62696c653111300f060355040b130846616365626f6f6b311d301b0603550403131446616365626f6f6b20436f72706f726174696f6e30819f300d06092a864886f70d010101050003818d0030818902818100c207d51df8eb8c97d93ba0c8c1002c928fab00dc1b42fca5e66e99cc3023ed2d214d822bc59e8e35ddcf5f44c7ae8ade50d7e0c434f500e6c131f4a2834f987fc46406115de2018ebbb0d5a3c261bd97581ccfef76afc7135a6d59e8855ecd7eacc8f8737e794c60a761c536b72b11fac8e603f5da1a2d54aa103b8a13c0dbc10203010001300d06092a864886f70d0101040500038181005ee9be8bcbb250648d3b741290a82a1c9dc2e76a0af2f2228f1d9f9c4007529c446a70175c5a900d5141812866db46be6559e2141616483998211f4a673149fb2232a10d247663b26a9031e15f84bc1c74d141ff98a02d76f85b2c8ab2571b6469b232d8e768a7f7ca04f7abe4a775615916c07940656b58717457b42bd928a2";
    public static final int MESSAGE_GET_ACCESS_TOKEN_REPLY = 65537;
    public static final int MESSAGE_GET_ACCESS_TOKEN_REQUEST = 65536;
    public static final int MESSAGE_GET_INSTALL_DATA_REPLY = 65541;
    public static final int MESSAGE_GET_INSTALL_DATA_REQUEST = 65540;
    static final int MESSAGE_GET_PROTOCOL_VERSIONS_REPLY = 65539;
    static final int MESSAGE_GET_PROTOCOL_VERSIONS_REQUEST = 65538;
    public static final int NO_PROTOCOL_AVAILABLE = -1;
    public static final String OPEN_GRAPH_CREATE_OBJECT_KEY = "fbsdk:create_object";
    public static final String PLATFORM_PROVIDER = "com.facebook.katana.provider.PlatformProvider";
    public static final String PLATFORM_PROVIDER_VERSION_COLUMN = "version";
    public static final String STATUS_ERROR_CODE = "com.facebook.platform.status.ERROR_CODE";
    public static final String STATUS_ERROR_DESCRIPTION = "com.facebook.platform.status.ERROR_DESCRIPTION";
    public static final String STATUS_ERROR_JSON = "com.facebook.platform.status.ERROR_JSON";
    public static final String STATUS_ERROR_SUBCODE = "com.facebook.platform.status.ERROR_SUBCODE";
    public static final String STATUS_ERROR_TYPE = "com.facebook.platform.status.ERROR_TYPE";
    public static final Uri PLATFORM_PROVIDER_VERSIONS_URI = Uri.parse("content://com.facebook.katana.provider.PlatformProvider/versions");
    public static final int PROTOCOL_VERSION_20130618 = 20130618;
    public static final int PROTOCOL_VERSION_20130502 = 20130502;
    public static final int PROTOCOL_VERSION_20121101 = 20121101;
    private static final List<Integer> KNOWN_PROTOCOL_VERSIONS = Arrays.asList(Integer.valueOf(PROTOCOL_VERSION_20130618), Integer.valueOf(PROTOCOL_VERSION_20130502), Integer.valueOf(PROTOCOL_VERSION_20121101));

    public static Intent createLoginDialog20121101Intent(Context context, String str, ArrayList<String> arrayList, String str2) {
        return validateKatanaActivityIntent(context, new Intent().setAction(INTENT_ACTION_PLATFORM_ACTIVITY).setPackage(FACEBOOK_PACKAGE).addCategory("android.intent.category.DEFAULT").putExtra(EXTRA_PROTOCOL_VERSION, PROTOCOL_VERSION_20121101).putExtra(EXTRA_PROTOCOL_ACTION, ACTION_LOGIN_DIALOG).putExtra(EXTRA_APPLICATION_ID, str).putStringArrayListExtra(EXTRA_PERMISSIONS, ensureDefaultPermissions(arrayList)).putExtra(EXTRA_PROTOCOL_CALL_ID, generateCallId()).putExtra(EXTRA_WRITE_PRIVACY, ensureDefaultAudience(str2)));
    }

    public static Intent createPlatformActivityIntent(Context context, String str, int i, Bundle bundle) {
        return validateKatanaActivityIntent(context, new Intent().setAction(INTENT_ACTION_PLATFORM_ACTIVITY).setPackage(FACEBOOK_PACKAGE).addCategory("android.intent.category.DEFAULT").putExtras(bundle).putExtra(EXTRA_PROTOCOL_VERSION, i).putExtra(EXTRA_PROTOCOL_ACTION, str));
    }

    public static Intent createPlatformServiceIntent(Context context) {
        return validateKatanaServiceIntent(context, new Intent(INTENT_ACTION_PLATFORM_SERVICE).setPackage(FACEBOOK_PACKAGE).addCategory("android.intent.category.DEFAULT"));
    }

    public static Intent createProxyAuthIntent(Context context, String str, List<String> list, String str2) {
        Intent intentPutExtra = new Intent().setClassName(FACEBOOK_PACKAGE, FACEBOOK_PROXY_AUTH_ACTIVITY).putExtra("client_id", str);
        if (!Utility.isNullOrEmpty(list)) {
            intentPutExtra.putExtra("scope", TextUtils.join(",", list));
        }
        if (!Utility.isNullOrEmpty(str2)) {
            intentPutExtra.putExtra("e2e", str2);
        }
        return validateKatanaActivityIntent(context, intentPutExtra);
    }

    public static Intent createTokenRefreshIntent(Context context) {
        return validateKatanaServiceIntent(context, new Intent().setClassName(FACEBOOK_PACKAGE, FACEBOOK_TOKEN_REFRESH_ACTIVITY));
    }

    private static String ensureDefaultAudience(String str) {
        return Utility.isNullOrEmpty(str) ? AUDIENCE_ME : str;
    }

    private static ArrayList<String> ensureDefaultPermissions(ArrayList<String> arrayList) {
        ArrayList<String> arrayList2;
        if (Utility.isNullOrEmpty(arrayList)) {
            arrayList2 = new ArrayList<>();
        } else {
            Iterator<String> it = arrayList.iterator();
            while (it.hasNext()) {
                String next = it.next();
                if (Session.isPublishPermission(next) || BASIC_INFO.equals(next)) {
                    return arrayList;
                }
            }
            arrayList2 = new ArrayList<>(arrayList);
        }
        arrayList2.add(BASIC_INFO);
        return arrayList2;
    }

    private static String generateCallId() {
        return UUID.randomUUID().toString();
    }

    public static Exception getErrorFromResult(Intent intent) {
        if (!isErrorResult(intent)) {
            return null;
        }
        String stringExtra = intent.getStringExtra(STATUS_ERROR_TYPE);
        String stringExtra2 = intent.getStringExtra(STATUS_ERROR_DESCRIPTION);
        return stringExtra.equalsIgnoreCase(ERROR_USER_CANCELED) ? new FacebookOperationCanceledException(stringExtra2) : new FacebookException(stringExtra2);
    }

    public static int getLatestAvailableProtocolVersion(Context context, int i) {
        Cursor cursorQuery = context.getContentResolver().query(PLATFORM_PROVIDER_VERSIONS_URI, new String[]{PLATFORM_PROVIDER_VERSION_COLUMN}, null, null, null);
        if (cursorQuery == null) {
            return -1;
        }
        HashSet hashSet = new HashSet();
        while (cursorQuery.moveToNext()) {
            hashSet.add(Integer.valueOf(cursorQuery.getInt(cursorQuery.getColumnIndex(PLATFORM_PROVIDER_VERSION_COLUMN))));
        }
        for (Integer num : KNOWN_PROTOCOL_VERSIONS) {
            if (num.intValue() < i) {
                return -1;
            }
            if (hashSet.contains(num)) {
                return num.intValue();
            }
        }
        return -1;
    }

    public static boolean isErrorResult(Intent intent) {
        return intent.hasExtra(STATUS_ERROR_TYPE);
    }

    public static boolean isServiceDisabledResult20121101(Intent intent) {
        return 20121101 == intent.getIntExtra(EXTRA_PROTOCOL_VERSION, 0) && ERROR_SERVICE_DISABLED.equals(intent.getStringExtra(STATUS_ERROR_TYPE));
    }

    static Intent validateKatanaActivityIntent(Context context, Intent intent) {
        ResolveInfo resolveInfoResolveActivity;
        if (intent != null && (resolveInfoResolveActivity = context.getPackageManager().resolveActivity(intent, 0)) != null && validateSignature(context, resolveInfoResolveActivity.activityInfo.packageName)) {
            return intent;
        }
        return null;
    }

    static Intent validateKatanaServiceIntent(Context context, Intent intent) {
        ResolveInfo resolveInfoResolveService;
        if (intent != null && (resolveInfoResolveService = context.getPackageManager().resolveService(intent, 0)) != null && validateSignature(context, resolveInfoResolveService.serviceInfo.packageName)) {
            return intent;
        }
        return null;
    }

    static final boolean validateSignature(Context context, String str) {
        String str2 = Build.BRAND;
        int i = context.getApplicationInfo().flags;
        if (str2.startsWith("generic") && (i & 2) != 0) {
            return true;
        }
        try {
            for (Signature signature : context.getPackageManager().getPackageInfo(str, 64).signatures) {
                if (signature.toCharsString().equals("30820268308201d102044a9c4610300d06092a864886f70d0101040500307a310b3009060355040613025553310b3009060355040813024341311230100603550407130950616c6f20416c746f31183016060355040a130f46616365626f6f6b204d6f62696c653111300f060355040b130846616365626f6f6b311d301b0603550403131446616365626f6f6b20436f72706f726174696f6e3020170d3039303833313231353231365a180f32303530303932353231353231365a307a310b3009060355040613025553310b3009060355040813024341311230100603550407130950616c6f20416c746f31183016060355040a130f46616365626f6f6b204d6f62696c653111300f060355040b130846616365626f6f6b311d301b0603550403131446616365626f6f6b20436f72706f726174696f6e30819f300d06092a864886f70d010101050003818d0030818902818100c207d51df8eb8c97d93ba0c8c1002c928fab00dc1b42fca5e66e99cc3023ed2d214d822bc59e8e35ddcf5f44c7ae8ade50d7e0c434f500e6c131f4a2834f987fc46406115de2018ebbb0d5a3c261bd97581ccfef76afc7135a6d59e8855ecd7eacc8f8737e794c60a761c536b72b11fac8e603f5da1a2d54aa103b8a13c0dbc10203010001300d06092a864886f70d0101040500038181005ee9be8bcbb250648d3b741290a82a1c9dc2e76a0af2f2228f1d9f9c4007529c446a70175c5a900d5141812866db46be6559e2141616483998211f4a673149fb2232a10d247663b26a9031e15f84bc1c74d141ff98a02d76f85b2c8ab2571b6469b232d8e768a7f7ca04f7abe4a775615916c07940656b58717457b42bd928a2")) {
                    return true;
                }
            }
            return false;
        } catch (PackageManager.NameNotFoundException e) {
            return false;
        }
    }
}
