package com.facebook;

/* loaded from: classes.dex */
public enum LoggingBehavior {
    REQUESTS,
    INCLUDE_ACCESS_TOKENS,
    INCLUDE_RAW_RESPONSES,
    CACHE,
    APP_EVENTS,
    DEVELOPER_ERRORS;


    @Deprecated
    public static final LoggingBehavior INSIGHTS = APP_EVENTS;
}
