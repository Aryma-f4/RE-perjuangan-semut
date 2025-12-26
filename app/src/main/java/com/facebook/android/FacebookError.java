package com.facebook.android;

/* loaded from: classes.dex */
public class FacebookError extends RuntimeException {
    private static final long serialVersionUID = 1;
    private int mErrorCode;
    private String mErrorType;

    @Deprecated
    public FacebookError(String str) {
        super(str);
        this.mErrorCode = 0;
    }

    @Deprecated
    public FacebookError(String str, String str2, int i) {
        super(str);
        this.mErrorCode = 0;
        this.mErrorType = str2;
        this.mErrorCode = i;
    }

    @Deprecated
    public int getErrorCode() {
        return this.mErrorCode;
    }

    @Deprecated
    public String getErrorType() {
        return this.mErrorType;
    }
}
