package com.facebook.android;

/* loaded from: classes.dex */
public class DialogError extends Throwable {
    private static final long serialVersionUID = 1;
    private int mErrorCode;
    private String mFailingUrl;

    @Deprecated
    public DialogError(String str, int i, String str2) {
        super(str);
        this.mErrorCode = i;
        this.mFailingUrl = str2;
    }

    @Deprecated
    public int getErrorCode() {
        return this.mErrorCode;
    }

    @Deprecated
    public String getFailingUrl() {
        return this.mFailingUrl;
    }
}
