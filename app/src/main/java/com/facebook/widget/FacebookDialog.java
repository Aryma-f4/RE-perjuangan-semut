package com.facebook.widget;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.os.Bundle;
import android.os.Parcel;
import android.os.Parcelable;
import android.support.v4.app.Fragment;
import android.support.v4.widget.ExploreByTouchHelper;
import com.facebook.FacebookException;
import com.facebook.FacebookGraphObjectException;
import com.facebook.NativeAppCallAttachmentStore;
import com.facebook.NativeAppCallContentProvider;
import com.facebook.internal.NativeProtocol;
import com.facebook.internal.Utility;
import com.facebook.internal.Validate;
import com.facebook.model.GraphObject;
import com.facebook.model.GraphObjectList;
import com.facebook.model.OpenGraphAction;
import com.facebook.model.OpenGraphObject;
import java.io.File;
import java.util.ArrayList;
import java.util.EnumSet;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.UUID;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

/* loaded from: classes.dex */
public class FacebookDialog {
    public static final String COMPLETION_GESTURE_CANCEL = "cancel";
    private static final String EXTRA_DIALOG_COMPLETE_KEY = "com.facebook.platform.extra.DID_COMPLETE";
    private static final String EXTRA_DIALOG_COMPLETION_GESTURE_KEY = "com.facebook.platform.extra.COMPLETION_GESTURE";
    private static final String EXTRA_DIALOG_COMPLETION_ID_KEY = "com.facebook.platform.extra.POST_ID";
    private static final int MIN_NATIVE_SHARE_PROTOCOL_VERSION = 20130618;
    private static NativeAppCallAttachmentStore attachmentStore;
    private Activity activity;
    private PendingCall appCall;
    private Fragment fragment;
    private OnPresentCallback onPresentCallback;

    private static abstract class Builder<CONCRETE extends Builder<?>> {
        protected final Activity activity;
        protected final PendingCall appCall;
        protected final String applicationId;
        protected String applicationName;
        protected Fragment fragment;

        Builder(Activity activity, String str) {
            Validate.notNull(activity, "activity");
            this.activity = activity;
            this.applicationId = str;
            this.appCall = new PendingCall(NativeProtocol.DIALOG_REQUEST_CODE);
        }

        public FacebookDialog build() {
            validate();
            Bundle bundle = new Bundle();
            putExtra(bundle, NativeProtocol.EXTRA_APPLICATION_ID, this.applicationId);
            putExtra(bundle, NativeProtocol.EXTRA_APPLICATION_NAME, this.applicationName);
            Intent intentHandleBuild = handleBuild(bundle);
            if (intentHandleBuild == null) {
                throw new FacebookException("Unable to create Intent; this likely means the Facebook app is not installed.");
            }
            this.appCall.setRequestIntent(intentHandleBuild);
            return new FacebookDialog(this.activity, this.fragment, this.appCall, getOnPresentCallback());
        }

        public boolean canPresent() {
            return handleCanPresent();
        }

        OnPresentCallback getOnPresentCallback() {
            return null;
        }

        abstract Intent handleBuild(Bundle bundle);

        boolean handleCanPresent() {
            return FacebookDialog.getProtocolVersionForNativeDialog(this.activity, 20130618) != -1;
        }

        void putExtra(Bundle bundle, String str, String str2) {
            if (str2 != null) {
                bundle.putString(str, str2);
            }
        }

        /* JADX WARN: Multi-variable type inference failed */
        public CONCRETE setApplicationName(String str) {
            this.applicationName = str;
            return this;
        }

        /* JADX WARN: Multi-variable type inference failed */
        public CONCRETE setFragment(Fragment fragment) {
            this.fragment = fragment;
            return this;
        }

        /* JADX WARN: Multi-variable type inference failed */
        public CONCRETE setRequestCode(int i) {
            this.appCall.setRequestCode(i);
            return this;
        }

        void validate() {
        }
    }

    public interface Callback {
        void onComplete(PendingCall pendingCall, Bundle bundle);

        void onError(PendingCall pendingCall, Exception exc, Bundle bundle);
    }

    private interface DialogFeature {
        int getMinVersion();
    }

    interface OnPresentCallback {
        void onPresent(Context context) throws Exception;
    }

    public static class OpenGraphActionDialogBuilder extends Builder<OpenGraphActionDialogBuilder> {
        private OpenGraphAction action;
        private String actionType;
        private boolean dataErrorsFatal;
        private HashMap<String, File> imageAttachmentFiles;
        private HashMap<String, Bitmap> imageAttachments;
        private String previewPropertyName;

        public OpenGraphActionDialogBuilder(Activity activity, String str, OpenGraphAction openGraphAction, String str2) {
            super(activity, str);
            Validate.notNull(openGraphAction, "action");
            Validate.notNullOrEmpty(openGraphAction.getType(), "action.getType()");
            Validate.notNullOrEmpty(str2, "previewPropertyName");
            if (openGraphAction.getProperty(str2) == null) {
                throw new IllegalArgumentException("A property named \"" + str2 + "\" was not found on the action.  The name of the preview property must match the name of an action property.");
            }
            this.action = openGraphAction;
            this.actionType = openGraphAction.getType();
            this.previewPropertyName = str2;
        }

        @Deprecated
        public OpenGraphActionDialogBuilder(Activity activity, String str, OpenGraphAction openGraphAction, String str2, String str3) {
            super(activity, str);
            Validate.notNull(openGraphAction, "action");
            Validate.notNullOrEmpty(str2, "actionType");
            Validate.notNullOrEmpty(str3, "previewPropertyName");
            if (openGraphAction.getProperty(str3) == null) {
                throw new IllegalArgumentException("A property named \"" + str3 + "\" was not found on the action.  The name of the preview property must match the name of an action property.");
            }
            String type = openGraphAction.getType();
            if (!Utility.isNullOrEmpty(type) && !type.equals(str2)) {
                throw new IllegalArgumentException("'actionType' must match the type of 'action' if it is specified. Consider using OpenGraphActionDialogBuilder(Activity activity, OpenGraphAction action, String previewPropertyName) instead.");
            }
            this.action = openGraphAction;
            this.actionType = str2;
            this.previewPropertyName = str3;
        }

        private OpenGraphActionDialogBuilder addImageAttachment(String str, Bitmap bitmap) {
            if (this.imageAttachments == null) {
                this.imageAttachments = new HashMap<>();
            }
            this.imageAttachments.put(str, bitmap);
            return this;
        }

        private OpenGraphActionDialogBuilder addImageAttachment(String str, File file) {
            if (this.imageAttachmentFiles == null) {
                this.imageAttachmentFiles = new HashMap<>();
            }
            this.imageAttachmentFiles.put(str, file);
            return this;
        }

        private List<String> addImageAttachmentFiles(List<File> list) {
            ArrayList arrayList = new ArrayList();
            for (File file : list) {
                String string = UUID.randomUUID().toString();
                addImageAttachment(string, file);
                arrayList.add(NativeAppCallContentProvider.getAttachmentUrl(this.applicationId, this.appCall.getCallId(), string));
            }
            return arrayList;
        }

        private List<String> addImageAttachments(List<Bitmap> list) {
            ArrayList arrayList = new ArrayList();
            for (Bitmap bitmap : list) {
                String string = UUID.randomUUID().toString();
                addImageAttachment(string, bitmap);
                arrayList.add(NativeAppCallContentProvider.getAttachmentUrl(this.applicationId, this.appCall.getCallId(), string));
            }
            return arrayList;
        }

        private JSONObject flattenChildrenOfGraphObject(JSONObject jSONObject) throws JSONException {
            try {
                JSONObject jSONObject2 = new JSONObject(jSONObject.toString());
                Iterator<String> itKeys = jSONObject2.keys();
                while (itKeys.hasNext()) {
                    String next = itKeys.next();
                    if (!next.equalsIgnoreCase("image")) {
                        jSONObject2.put(next, flattenObject(jSONObject2.get(next)));
                    }
                }
                return jSONObject2;
            } catch (JSONException e) {
                throw new FacebookException(e);
            }
        }

        private Object flattenObject(Object obj) throws JSONException {
            if (obj == null) {
                return null;
            }
            if (obj instanceof JSONObject) {
                JSONObject jSONObject = (JSONObject) obj;
                if (jSONObject.optBoolean(NativeProtocol.OPEN_GRAPH_CREATE_OBJECT_KEY)) {
                    return obj;
                }
                if (jSONObject.has("id")) {
                    return jSONObject.getString("id");
                }
                if (jSONObject.has("url")) {
                    return jSONObject.getString("url");
                }
            } else if (obj instanceof JSONArray) {
                JSONArray jSONArray = (JSONArray) obj;
                JSONArray jSONArray2 = new JSONArray();
                int length = jSONArray.length();
                for (int i = 0; i < length; i++) {
                    jSONArray2.put(flattenObject(jSONArray.get(i)));
                }
                return jSONArray2;
            }
            return obj;
        }

        private void updateActionAttachmentUrls(List<String> list, boolean z) throws JSONException {
            List<JSONObject> image = this.action.getImage();
            List<JSONObject> arrayList = image == null ? new ArrayList(list.size()) : image;
            for (String str : list) {
                JSONObject jSONObject = new JSONObject();
                try {
                    jSONObject.put("url", str);
                    if (z) {
                        jSONObject.put(NativeProtocol.IMAGE_USER_GENERATED_KEY, true);
                    }
                    arrayList.add(jSONObject);
                } catch (JSONException e) {
                    throw new FacebookException("Unable to attach images", e);
                }
            }
            this.action.setImage(arrayList);
        }

        @Override // com.facebook.widget.FacebookDialog.Builder
        public /* bridge */ /* synthetic */ FacebookDialog build() {
            return super.build();
        }

        @Override // com.facebook.widget.FacebookDialog.Builder
        public /* bridge */ /* synthetic */ boolean canPresent() {
            return super.canPresent();
        }

        List<String> getImageAttachmentNames() {
            return new ArrayList(this.imageAttachments.keySet());
        }

        @Override // com.facebook.widget.FacebookDialog.Builder
        OnPresentCallback getOnPresentCallback() {
            return new OnPresentCallback() { // from class: com.facebook.widget.FacebookDialog.OpenGraphActionDialogBuilder.1
                @Override // com.facebook.widget.FacebookDialog.OnPresentCallback
                public void onPresent(Context context) throws Exception {
                    if (OpenGraphActionDialogBuilder.this.imageAttachments != null && OpenGraphActionDialogBuilder.this.imageAttachments.size() > 0) {
                        FacebookDialog.getAttachmentStore().addAttachmentsForCall(context, OpenGraphActionDialogBuilder.this.appCall.getCallId(), OpenGraphActionDialogBuilder.this.imageAttachments);
                    }
                    if (OpenGraphActionDialogBuilder.this.imageAttachmentFiles == null || OpenGraphActionDialogBuilder.this.imageAttachmentFiles.size() <= 0) {
                        return;
                    }
                    FacebookDialog.getAttachmentStore().addAttachmentFilesForCall(context, OpenGraphActionDialogBuilder.this.appCall.getCallId(), OpenGraphActionDialogBuilder.this.imageAttachmentFiles);
                }
            };
        }

        @Override // com.facebook.widget.FacebookDialog.Builder
        Intent handleBuild(Bundle bundle) {
            putExtra(bundle, NativeProtocol.EXTRA_PREVIEW_PROPERTY_NAME, this.previewPropertyName);
            putExtra(bundle, NativeProtocol.EXTRA_ACTION_TYPE, this.actionType);
            bundle.putBoolean(NativeProtocol.EXTRA_DATA_FAILURES_FATAL, this.dataErrorsFatal);
            putExtra(bundle, NativeProtocol.EXTRA_ACTION, flattenChildrenOfGraphObject(this.action.getInnerJSONObject()).toString());
            return NativeProtocol.createPlatformActivityIntent(this.activity, NativeProtocol.ACTION_OGACTIONPUBLISH_DIALOG, FacebookDialog.getProtocolVersionForNativeDialog(this.activity, 20130618), bundle);
        }

        @Override // com.facebook.widget.FacebookDialog.Builder
        boolean handleCanPresent() {
            return FacebookDialog.canPresentOpenGraphActionDialog(this.activity, OpenGraphActionDialogFeature.OG_ACTION_DIALOG);
        }

        public OpenGraphActionDialogBuilder setDataErrorsFatal(boolean z) {
            this.dataErrorsFatal = z;
            return this;
        }

        public OpenGraphActionDialogBuilder setImageAttachmentFilesForAction(List<File> list) {
            return setImageAttachmentFilesForAction(list, false);
        }

        public OpenGraphActionDialogBuilder setImageAttachmentFilesForAction(List<File> list, boolean z) throws JSONException {
            Validate.containsNoNulls(list, "bitmapFiles");
            if (this.action == null) {
                throw new FacebookException("Can not set attachments prior to setting action.");
            }
            updateActionAttachmentUrls(addImageAttachmentFiles(list), z);
            return this;
        }

        public OpenGraphActionDialogBuilder setImageAttachmentFilesForObject(String str, List<File> list) {
            return setImageAttachmentFilesForObject(str, list, false);
        }

        public OpenGraphActionDialogBuilder setImageAttachmentFilesForObject(String str, List<File> list, boolean z) {
            Validate.notNull(str, "objectProperty");
            Validate.containsNoNulls(list, "bitmapFiles");
            if (this.action == null) {
                throw new FacebookException("Can not set attachments prior to setting action.");
            }
            updateObjectAttachmentUrls(str, addImageAttachmentFiles(list), z);
            return this;
        }

        public OpenGraphActionDialogBuilder setImageAttachmentsForAction(List<Bitmap> list) {
            return setImageAttachmentsForAction(list, false);
        }

        public OpenGraphActionDialogBuilder setImageAttachmentsForAction(List<Bitmap> list, boolean z) throws JSONException {
            Validate.containsNoNulls(list, "bitmaps");
            if (this.action == null) {
                throw new FacebookException("Can not set attachments prior to setting action.");
            }
            updateActionAttachmentUrls(addImageAttachments(list), z);
            return this;
        }

        public OpenGraphActionDialogBuilder setImageAttachmentsForObject(String str, List<Bitmap> list) {
            return setImageAttachmentsForObject(str, list, false);
        }

        public OpenGraphActionDialogBuilder setImageAttachmentsForObject(String str, List<Bitmap> list, boolean z) {
            Validate.notNull(str, "objectProperty");
            Validate.containsNoNulls(list, "bitmaps");
            if (this.action == null) {
                throw new FacebookException("Can not set attachments prior to setting action.");
            }
            updateObjectAttachmentUrls(str, addImageAttachments(list), z);
            return this;
        }

        void updateObjectAttachmentUrls(String str, List<String> list, boolean z) {
            try {
                OpenGraphObject openGraphObject = (OpenGraphObject) this.action.getPropertyAs(str, OpenGraphObject.class);
                if (openGraphObject == null) {
                    throw new IllegalArgumentException("Action does not contain a property '" + str + "'");
                }
                if (!openGraphObject.getCreateObject()) {
                    throw new IllegalArgumentException("The Open Graph object in '" + str + "' is not marked for creation");
                }
                GraphObjectList<GraphObject> image = openGraphObject.getImage();
                GraphObjectList<GraphObject> graphObjectListCreateList = image == null ? GraphObject.Factory.createList(GraphObject.class) : image;
                for (String str2 : list) {
                    GraphObject graphObjectCreate = GraphObject.Factory.create();
                    graphObjectCreate.setProperty("url", str2);
                    if (z) {
                        graphObjectCreate.setProperty(NativeProtocol.IMAGE_USER_GENERATED_KEY, true);
                    }
                    graphObjectListCreateList.add(graphObjectCreate);
                }
                openGraphObject.setImage(graphObjectListCreateList);
            } catch (FacebookGraphObjectException e) {
                throw new IllegalArgumentException("Property '" + str + "' is not a graph object");
            }
        }
    }

    public enum OpenGraphActionDialogFeature implements DialogFeature {
        OG_ACTION_DIALOG(20130618);

        private int minVersion;

        OpenGraphActionDialogFeature(int i) {
            this.minVersion = i;
        }

        @Override // com.facebook.widget.FacebookDialog.DialogFeature
        public int getMinVersion() {
            return this.minVersion;
        }
    }

    public static class PendingCall implements Parcelable {
        public static final Parcelable.Creator<PendingCall> CREATOR = new Parcelable.Creator<PendingCall>() { // from class: com.facebook.widget.FacebookDialog.PendingCall.1
            /* JADX WARN: Can't rename method to resolve collision */
            @Override // android.os.Parcelable.Creator
            public PendingCall createFromParcel(Parcel parcel) {
                return new PendingCall(parcel);
            }

            /* JADX WARN: Can't rename method to resolve collision */
            @Override // android.os.Parcelable.Creator
            public PendingCall[] newArray(int i) {
                return new PendingCall[i];
            }
        };
        private UUID callId;
        private int requestCode;
        private Intent requestIntent;

        public PendingCall(int i) {
            this.callId = UUID.randomUUID();
            this.requestCode = i;
        }

        private PendingCall(Parcel parcel) {
            this.callId = UUID.fromString(parcel.readString());
            this.requestIntent = (Intent) parcel.readParcelable(null);
            this.requestCode = parcel.readInt();
        }

        /* JADX INFO: Access modifiers changed from: private */
        public void setRequestCode(int i) {
            this.requestCode = i;
        }

        /* JADX INFO: Access modifiers changed from: private */
        public void setRequestIntent(Intent intent) {
            this.requestIntent = intent;
            this.requestIntent.putExtra(NativeProtocol.EXTRA_PROTOCOL_CALL_ID, this.callId.toString());
        }

        @Override // android.os.Parcelable
        public int describeContents() {
            return 0;
        }

        public UUID getCallId() {
            return this.callId;
        }

        public int getRequestCode() {
            return this.requestCode;
        }

        public Intent getRequestIntent() {
            return this.requestIntent;
        }

        @Override // android.os.Parcelable
        public void writeToParcel(Parcel parcel, int i) {
            parcel.writeString(this.callId.toString());
            parcel.writeParcelable(this.requestIntent, 0);
            parcel.writeInt(this.requestCode);
        }
    }

    public static class ShareDialogBuilder extends Builder<ShareDialogBuilder> {
        private String caption;
        private boolean dataErrorsFatal;
        private String description;
        private ArrayList<String> friends;
        private String link;
        private String name;
        private String picture;
        private String place;
        private String ref;

        public ShareDialogBuilder(Activity activity, String str) {
            super(activity, str);
        }

        @Override // com.facebook.widget.FacebookDialog.Builder
        public /* bridge */ /* synthetic */ FacebookDialog build() {
            return super.build();
        }

        @Override // com.facebook.widget.FacebookDialog.Builder
        public /* bridge */ /* synthetic */ boolean canPresent() {
            return super.canPresent();
        }

        @Override // com.facebook.widget.FacebookDialog.Builder
        Intent handleBuild(Bundle bundle) {
            putExtra(bundle, NativeProtocol.EXTRA_APPLICATION_ID, this.applicationId);
            putExtra(bundle, NativeProtocol.EXTRA_APPLICATION_NAME, this.applicationName);
            putExtra(bundle, NativeProtocol.EXTRA_TITLE, this.name);
            putExtra(bundle, NativeProtocol.EXTRA_SUBTITLE, this.caption);
            putExtra(bundle, NativeProtocol.EXTRA_DESCRIPTION, this.description);
            putExtra(bundle, NativeProtocol.EXTRA_LINK, this.link);
            putExtra(bundle, NativeProtocol.EXTRA_IMAGE, this.picture);
            putExtra(bundle, NativeProtocol.EXTRA_PLACE_TAG, this.place);
            putExtra(bundle, NativeProtocol.EXTRA_TITLE, this.name);
            putExtra(bundle, NativeProtocol.EXTRA_REF, this.ref);
            bundle.putBoolean(NativeProtocol.EXTRA_DATA_FAILURES_FATAL, this.dataErrorsFatal);
            if (!Utility.isNullOrEmpty(this.friends)) {
                bundle.putStringArrayList(NativeProtocol.EXTRA_FRIEND_TAGS, this.friends);
            }
            return NativeProtocol.createPlatformActivityIntent(this.activity, NativeProtocol.ACTION_FEED_DIALOG, FacebookDialog.getProtocolVersionForNativeDialog(this.activity, 20130618), bundle);
        }

        @Override // com.facebook.widget.FacebookDialog.Builder
        boolean handleCanPresent() {
            return FacebookDialog.canPresentShareDialog(this.activity, ShareDialogFeature.SHARE_DIALOG);
        }

        public ShareDialogBuilder setCaption(String str) {
            this.caption = str;
            return this;
        }

        public ShareDialogBuilder setDataErrorsFatal(boolean z) {
            this.dataErrorsFatal = z;
            return this;
        }

        public ShareDialogBuilder setDescription(String str) {
            this.description = str;
            return this;
        }

        public ShareDialogBuilder setFriends(List<String> list) {
            this.friends = new ArrayList<>(list);
            return this;
        }

        public ShareDialogBuilder setLink(String str) {
            this.link = str;
            return this;
        }

        public ShareDialogBuilder setName(String str) {
            this.name = str;
            return this;
        }

        public ShareDialogBuilder setPicture(String str) {
            this.picture = str;
            return this;
        }

        public ShareDialogBuilder setPlace(String str) {
            this.place = str;
            return this;
        }

        public ShareDialogBuilder setRef(String str) {
            this.ref = str;
            return this;
        }
    }

    public enum ShareDialogFeature implements DialogFeature {
        SHARE_DIALOG(20130618);

        private int minVersion;

        ShareDialogFeature(int i) {
            this.minVersion = i;
        }

        @Override // com.facebook.widget.FacebookDialog.DialogFeature
        public int getMinVersion() {
            return this.minVersion;
        }
    }

    private FacebookDialog(Activity activity, Fragment fragment, PendingCall pendingCall, OnPresentCallback onPresentCallback) {
        this.activity = activity;
        this.fragment = fragment;
        this.appCall = pendingCall;
        this.onPresentCallback = onPresentCallback;
    }

    public static boolean canPresentOpenGraphActionDialog(Context context, OpenGraphActionDialogFeature... openGraphActionDialogFeatureArr) {
        return handleCanPresent(context, EnumSet.of(OpenGraphActionDialogFeature.OG_ACTION_DIALOG, openGraphActionDialogFeatureArr));
    }

    public static boolean canPresentShareDialog(Context context, ShareDialogFeature... shareDialogFeatureArr) {
        return handleCanPresent(context, EnumSet.of(ShareDialogFeature.SHARE_DIALOG, shareDialogFeatureArr));
    }

    /* JADX INFO: Access modifiers changed from: private */
    public static NativeAppCallAttachmentStore getAttachmentStore() {
        if (attachmentStore == null) {
            attachmentStore = new NativeAppCallAttachmentStore();
        }
        return attachmentStore;
    }

    private static int getMinVersionForFeatures(Iterable<? extends DialogFeature> iterable) {
        int iMax = ExploreByTouchHelper.INVALID_ID;
        Iterator<? extends DialogFeature> it = iterable.iterator();
        while (it.hasNext()) {
            iMax = Math.max(iMax, it.next().getMinVersion());
        }
        return iMax;
    }

    public static String getNativeDialogCompletionGesture(Bundle bundle) {
        return bundle.getString(EXTRA_DIALOG_COMPLETION_GESTURE_KEY);
    }

    public static boolean getNativeDialogDidComplete(Bundle bundle) {
        return bundle.getBoolean(EXTRA_DIALOG_COMPLETE_KEY, false);
    }

    public static String getNativeDialogPostId(Bundle bundle) {
        return bundle.getString(EXTRA_DIALOG_COMPLETION_ID_KEY);
    }

    /* JADX INFO: Access modifiers changed from: private */
    public static int getProtocolVersionForNativeDialog(Context context, Integer num) {
        return NativeProtocol.getLatestAvailableProtocolVersion(context, num.intValue());
    }

    public static boolean handleActivityResult(Context context, PendingCall pendingCall, int i, Intent intent, Callback callback) {
        if (i != pendingCall.getRequestCode()) {
            return false;
        }
        if (attachmentStore != null) {
            attachmentStore.cleanupAttachmentsForCall(context, pendingCall.getCallId());
        }
        if (callback != null) {
            if (NativeProtocol.isErrorResult(intent)) {
                callback.onError(pendingCall, NativeProtocol.getErrorFromResult(intent), intent.getExtras());
            } else {
                callback.onComplete(pendingCall, intent.getExtras());
            }
        }
        return true;
    }

    private static boolean handleCanPresent(Context context, Iterable<? extends DialogFeature> iterable) {
        return getProtocolVersionForNativeDialog(context, Integer.valueOf(getMinVersionForFeatures(iterable))) != -1;
    }

    public PendingCall present() {
        if (this.onPresentCallback != null) {
            try {
                this.onPresentCallback.onPresent(this.activity);
            } catch (Exception e) {
                throw new FacebookException(e);
            }
        }
        if (this.fragment != null) {
            this.fragment.startActivityForResult(this.appCall.getRequestIntent(), this.appCall.getRequestCode());
        } else {
            this.activity.startActivityForResult(this.appCall.getRequestIntent(), this.appCall.getRequestCode());
        }
        return this.appCall;
    }
}
