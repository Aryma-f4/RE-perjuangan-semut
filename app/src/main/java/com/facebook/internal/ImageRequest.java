package com.facebook.internal;

import android.content.Context;
import android.net.Uri;
import java.net.URI;
import java.net.URISyntaxException;

/* loaded from: classes.dex */
public class ImageRequest {
    private static final String HEIGHT_PARAM = "height";
    private static final String MIGRATION_PARAM = "migration_overrides";
    private static final String MIGRATION_VALUE = "{october_2012:true}";
    private static final String PROFILEPIC_URL_FORMAT = "https://graph.facebook.com/%s/picture";
    public static final int UNSPECIFIED_DIMENSION = 0;
    private static final String WIDTH_PARAM = "width";
    private boolean allowCachedRedirects;
    private Callback callback;
    private Object callerTag;
    private Context context;
    private URI imageUri;

    public static class Builder {
        private boolean allowCachedRedirects;
        private Callback callback;
        private Object callerTag;
        private Context context;
        private URI imageUrl;

        public Builder(Context context, URI uri) {
            Validate.notNull(uri, "imageUrl");
            this.context = context;
            this.imageUrl = uri;
        }

        public ImageRequest build() {
            return new ImageRequest(this);
        }

        public Builder setAllowCachedRedirects(boolean z) {
            this.allowCachedRedirects = z;
            return this;
        }

        public Builder setCallback(Callback callback) {
            this.callback = callback;
            return this;
        }

        public Builder setCallerTag(Object obj) {
            this.callerTag = obj;
            return this;
        }
    }

    public interface Callback {
        void onCompleted(ImageResponse imageResponse);
    }

    private ImageRequest(Builder builder) {
        this.context = builder.context;
        this.imageUri = builder.imageUrl;
        this.callback = builder.callback;
        this.allowCachedRedirects = builder.allowCachedRedirects;
        this.callerTag = builder.callerTag == null ? new Object() : builder.callerTag;
    }

    public static URI getProfilePictureUrl(String str, int i, int i2) throws URISyntaxException {
        Validate.notNullOrEmpty(str, "userId");
        int iMax = Math.max(i, 0);
        int iMax2 = Math.max(i2, 0);
        if (iMax == 0 && iMax2 == 0) {
            throw new IllegalArgumentException("Either width or height must be greater than 0");
        }
        Uri.Builder builderEncodedPath = new Uri.Builder().encodedPath(String.format(PROFILEPIC_URL_FORMAT, str));
        if (iMax2 != 0) {
            builderEncodedPath.appendQueryParameter(HEIGHT_PARAM, String.valueOf(iMax2));
        }
        if (iMax != 0) {
            builderEncodedPath.appendQueryParameter(WIDTH_PARAM, String.valueOf(iMax));
        }
        builderEncodedPath.appendQueryParameter(MIGRATION_PARAM, MIGRATION_VALUE);
        return new URI(builderEncodedPath.toString());
    }

    public Callback getCallback() {
        return this.callback;
    }

    public Object getCallerTag() {
        return this.callerTag;
    }

    public Context getContext() {
        return this.context;
    }

    public URI getImageUri() {
        return this.imageUri;
    }

    public boolean isCachedRedirectAllowed() {
        return this.allowCachedRedirects;
    }
}
