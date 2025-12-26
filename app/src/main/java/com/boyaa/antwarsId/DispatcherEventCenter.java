package com.boyaa.antwarsId;

/* loaded from: classes.dex */
public class DispatcherEventCenter {
    public static final String MIMOPAY_RESULT = "mimopay_result";

    public static void dispathEventToActionScript(String eventName, String value) throws IllegalStateException, IllegalArgumentException {
        AntExtension.context.dispatchStatusEventAsync(eventName, value);
    }
}
