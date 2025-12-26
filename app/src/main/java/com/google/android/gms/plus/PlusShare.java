package com.google.android.gms.plus;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Bundle;
import android.support.v4.view.accessibility.AccessibilityEventCompat;
import android.text.TextUtils;
import android.util.Log;
import com.facebook.AppEventsConstants;
import com.google.android.gms.common.GooglePlayServicesUtil;
import com.google.android.gms.common.Scopes;
import com.google.android.gms.internal.cc;
import com.google.android.gms.internal.s;
import com.google.android.gms.plus.model.people.Person;
import java.util.ArrayList;
import java.util.List;

/* loaded from: classes.dex */
public final class PlusShare {
    public static final String EXTRA_CALL_TO_ACTION = "com.google.android.apps.plus.CALL_TO_ACTION";
    public static final String EXTRA_CONTENT_DEEP_LINK_ID = "com.google.android.apps.plus.CONTENT_DEEP_LINK_ID";
    public static final String EXTRA_CONTENT_DEEP_LINK_METADATA = "com.google.android.apps.plus.CONTENT_DEEP_LINK_METADATA";
    public static final String EXTRA_CONTENT_URL = "com.google.android.apps.plus.CONTENT_URL";
    public static final String EXTRA_IS_INTERACTIVE_POST = "com.google.android.apps.plus.GOOGLE_INTERACTIVE_POST";
    public static final String EXTRA_SENDER_ID = "com.google.android.apps.plus.SENDER_ID";
    public static final String KEY_CALL_TO_ACTION_DEEP_LINK_ID = "deepLinkId";
    public static final String KEY_CALL_TO_ACTION_LABEL = "label";
    public static final String KEY_CALL_TO_ACTION_URL = "url";
    public static final String KEY_CONTENT_DEEP_LINK_METADATA_DESCRIPTION = "description";
    public static final String KEY_CONTENT_DEEP_LINK_METADATA_THUMBNAIL_URL = "thumbnailUrl";
    public static final String KEY_CONTENT_DEEP_LINK_METADATA_TITLE = "title";
    public static final String PARAM_CONTENT_DEEP_LINK_ID = "deep_link_id";

    public static class Builder {
        private boolean im;
        private ArrayList<Uri> in;
        protected boolean io;
        private final Context mContext;
        private final Intent mIntent;

        public Builder(Activity launchingActivity) {
            this.mContext = launchingActivity;
            this.mIntent = new Intent().setAction("android.intent.action.SEND");
            this.mIntent.addFlags(AccessibilityEventCompat.TYPE_GESTURE_DETECTION_END);
            if (launchingActivity.getComponentName() != null) {
                this.im = true;
            }
        }

        public Builder(Activity launchingActivity, PlusClient plusClient) {
            this(launchingActivity);
            s.a(plusClient != null, "Must include the PlusClient object in PlusShare.Builder constructor to create an interactive post.");
            s.a(plusClient.isConnected(), "PlusClient must be connected to create an interactive post.");
            s.a(plusClient.bu().F(Scopes.PLUS_LOGIN), "Must request PLUS_LOGIN scope in PlusClient to create an interactive post.");
            Person currentPerson = plusClient.getCurrentPerson();
            this.mIntent.putExtra(PlusShare.EXTRA_SENDER_ID, currentPerson != null ? currentPerson.getId() : AppEventsConstants.EVENT_PARAM_VALUE_NO);
            this.io = true;
        }

        public Builder(Context context) {
            this.mContext = context;
            this.mIntent = new Intent().setAction("android.intent.action.SEND");
        }

        public Builder addCallToAction(String label, Uri uri, String deepLinkId) {
            s.a(this.im, "Must include the launching activity with PlusShare.Builder constructor before setting call-to-action");
            s.b((uri == null || TextUtils.isEmpty(uri.toString())) ? false : true, "Must provide a call to action URL");
            s.a(this.io, "Must include PlusClient in PlusShare.Builder constructor to create an interactive post");
            Bundle bundle = new Bundle();
            if (!TextUtils.isEmpty(label)) {
                bundle.putString(PlusShare.KEY_CALL_TO_ACTION_LABEL, label);
            }
            bundle.putString("url", uri.toString());
            if (!TextUtils.isEmpty(deepLinkId)) {
                s.a(PlusShare.isDeepLinkIdValid(deepLinkId), "The specified deep-link ID was malformed.");
                bundle.putString(PlusShare.KEY_CALL_TO_ACTION_DEEP_LINK_ID, deepLinkId);
            }
            this.mIntent.putExtra(PlusShare.EXTRA_CALL_TO_ACTION, bundle);
            this.mIntent.putExtra(PlusShare.EXTRA_IS_INTERACTIVE_POST, true);
            this.mIntent.setType("text/plain");
            return this;
        }

        public Builder addStream(Uri streamUri) {
            Uri uri = (Uri) this.mIntent.getParcelableExtra("android.intent.extra.STREAM");
            if (uri == null) {
                return setStream(streamUri);
            }
            if (this.in == null) {
                this.in = new ArrayList<>();
            }
            this.in.add(uri);
            this.in.add(streamUri);
            return this;
        }

        public Intent getIntent() {
            boolean z = this.in != null && this.in.size() > 1;
            boolean zEquals = "android.intent.action.SEND_MULTIPLE".equals(this.mIntent.getAction());
            boolean booleanExtra = this.mIntent.getBooleanExtra(PlusShare.EXTRA_IS_INTERACTIVE_POST, false);
            s.a((z && booleanExtra) ? false : true, "Call-to-action buttons are only available for URLs.");
            s.a(!booleanExtra || this.mIntent.hasExtra(PlusShare.EXTRA_CONTENT_URL), "The content URL is required for interactive posts.");
            s.a(!booleanExtra || this.mIntent.hasExtra(PlusShare.EXTRA_CONTENT_URL) || this.mIntent.hasExtra(PlusShare.EXTRA_CONTENT_DEEP_LINK_ID), "Must set content URL or content deep-link ID to use a call-to-action button.");
            if (this.mIntent.hasExtra(PlusShare.EXTRA_CONTENT_DEEP_LINK_ID)) {
                s.a(PlusShare.isDeepLinkIdValid(this.mIntent.getStringExtra(PlusShare.EXTRA_CONTENT_DEEP_LINK_ID)), "The specified deep-link ID was malformed.");
            }
            if (!z && zEquals) {
                this.mIntent.setAction("android.intent.action.SEND");
                if (this.in == null || this.in.isEmpty()) {
                    this.mIntent.removeExtra("android.intent.extra.STREAM");
                } else {
                    this.mIntent.putExtra("android.intent.extra.STREAM", this.in.get(0));
                }
                this.in = null;
            }
            if (z && !zEquals) {
                this.mIntent.setAction("android.intent.action.SEND_MULTIPLE");
                if (this.in == null || this.in.isEmpty()) {
                    this.mIntent.removeExtra("android.intent.extra.STREAM");
                } else {
                    this.mIntent.putParcelableArrayListExtra("android.intent.extra.STREAM", this.in);
                }
            }
            if (isGooglePlusAvailable() || this.mIntent.hasExtra("android.intent.extra.STREAM")) {
                this.mIntent.setPackage("com.google.android.apps.plus");
                return this.mIntent;
            }
            this.mIntent.setAction("com.google.android.gms.plus.action.SHARE_GOOGLE");
            this.mIntent.setPackage(GooglePlayServicesUtil.GOOGLE_PLAY_SERVICES_PACKAGE);
            return this.mIntent;
        }

        protected boolean isGooglePlusAvailable() throws PackageManager.NameNotFoundException {
            PackageManager packageManager = this.mContext.getPackageManager();
            if (packageManager == null) {
                return false;
            }
            try {
                ApplicationInfo applicationInfo = packageManager.getApplicationInfo("com.google.android.apps.plus", 0);
                if (applicationInfo != null) {
                    if (applicationInfo.enabled) {
                        return true;
                    }
                }
                return false;
            } catch (PackageManager.NameNotFoundException e) {
                return false;
            }
        }

        public Builder setContentDeepLinkId(String deepLinkId) {
            return setContentDeepLinkId(deepLinkId, null, null, null);
        }

        public Builder setContentDeepLinkId(String deepLinkId, String title, String description, Uri thumbnailUri) {
            s.b(this.im, "Must include the launching activity with PlusShare.Builder constructor before setting deep links");
            s.b(!TextUtils.isEmpty(deepLinkId), "The deepLinkId parameter is required.");
            Bundle bundleA = PlusShare.a(title, description, thumbnailUri);
            this.mIntent.putExtra(PlusShare.EXTRA_CONTENT_DEEP_LINK_ID, deepLinkId);
            this.mIntent.putExtra(PlusShare.EXTRA_CONTENT_DEEP_LINK_METADATA, bundleA);
            this.mIntent.setType("text/plain");
            return this;
        }

        public Builder setContentUrl(Uri uri) {
            String string = uri != null ? uri.toString() : null;
            if (TextUtils.isEmpty(string)) {
                this.mIntent.removeExtra(PlusShare.EXTRA_CONTENT_URL);
            } else {
                this.mIntent.putExtra(PlusShare.EXTRA_CONTENT_URL, string);
            }
            return this;
        }

        public Builder setRecipients(List<Person> recipientList) {
            int size = recipientList != null ? recipientList.size() : 0;
            if (size == 0) {
                this.mIntent.removeExtra("com.google.android.apps.plus.RECIPIENT_IDS");
                this.mIntent.removeExtra("com.google.android.apps.plus.RECIPIENT_DISPLAY_NAMES");
            } else {
                ArrayList<String> arrayList = new ArrayList<>(size);
                ArrayList<String> arrayList2 = new ArrayList<>(size);
                for (Person person : recipientList) {
                    arrayList.add(person.getId());
                    arrayList2.add(person.getDisplayName());
                }
                this.mIntent.putStringArrayListExtra("com.google.android.apps.plus.RECIPIENT_IDS", arrayList);
                this.mIntent.putStringArrayListExtra("com.google.android.apps.plus.RECIPIENT_DISPLAY_NAMES", arrayList2);
            }
            return this;
        }

        public Builder setStream(Uri streamUri) {
            this.in = null;
            this.mIntent.putExtra("android.intent.extra.STREAM", streamUri);
            return this;
        }

        public Builder setText(CharSequence text) {
            this.mIntent.putExtra("android.intent.extra.TEXT", text);
            return this;
        }

        public Builder setType(String mimeType) {
            this.mIntent.setType(mimeType);
            return this;
        }
    }

    @Deprecated
    protected PlusShare() {
        throw new AssertionError();
    }

    public static Bundle a(String str, String str2, Uri uri) {
        Bundle bundle = new Bundle();
        bundle.putString(KEY_CONTENT_DEEP_LINK_METADATA_TITLE, str);
        bundle.putString(KEY_CONTENT_DEEP_LINK_METADATA_DESCRIPTION, str2);
        if (uri != null) {
            bundle.putString(KEY_CONTENT_DEEP_LINK_METADATA_THUMBNAIL_URL, uri.toString());
        }
        return bundle;
    }

    public static Person createPerson(String id, String displayName) {
        if (TextUtils.isEmpty(id)) {
            throw new IllegalArgumentException("MinimalPerson ID must not be empty.");
        }
        if (TextUtils.isEmpty(displayName)) {
            throw new IllegalArgumentException("Display name must not be empty.");
        }
        return new cc(displayName, id, null, 0, null);
    }

    public static String getDeepLinkId(Intent intent) {
        if (intent == null || intent.getData() == null) {
            return null;
        }
        return intent.getData().getQueryParameter(PARAM_CONTENT_DEEP_LINK_ID);
    }

    protected static boolean isDeepLinkIdValid(String deepLinkId) {
        if (TextUtils.isEmpty(deepLinkId)) {
            Log.e("GooglePlusPlatform", "The provided deep-link ID is empty.");
            return false;
        }
        if (!deepLinkId.contains(" ")) {
            return true;
        }
        Log.e("GooglePlusPlatform", "Spaces are not allowed in deep-link IDs.");
        return false;
    }
}
