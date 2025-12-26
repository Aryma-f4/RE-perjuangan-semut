package com.facebook;

import android.content.Context;
import android.os.Bundle;
import com.facebook.internal.Logger;
import java.math.BigDecimal;
import java.util.Currency;

@Deprecated
/* loaded from: classes.dex */
public class InsightsLogger {
    private static final String EVENT_NAME_LOG_CONVERSION_PIXEL = "fb_log_offsite_pixel";
    private static final String EVENT_PARAMETER_PIXEL_ID = "fb_offsite_pixel_id";
    private static final String EVENT_PARAMETER_PIXEL_VALUE = "fb_offsite_pixel_value";
    private AppEventsLogger appEventsLogger;

    private InsightsLogger(Context context, String str, Session session) {
        this.appEventsLogger = AppEventsLogger.newLogger(context, str, session);
    }

    public static InsightsLogger newLogger(Context context, String str) {
        return new InsightsLogger(context, null, null);
    }

    public static InsightsLogger newLogger(Context context, String str, String str2) {
        return new InsightsLogger(context, str2, null);
    }

    public static InsightsLogger newLogger(Context context, String str, String str2, Session session) {
        return new InsightsLogger(context, str2, session);
    }

    public void logConversionPixel(String str, double d) {
        if (str == null) {
            Logger.log(LoggingBehavior.DEVELOPER_ERRORS, "Insights", "pixelID cannot be null");
            return;
        }
        Bundle bundle = new Bundle();
        bundle.putString(EVENT_PARAMETER_PIXEL_ID, str);
        bundle.putDouble(EVENT_PARAMETER_PIXEL_VALUE, d);
        this.appEventsLogger.logEvent(EVENT_NAME_LOG_CONVERSION_PIXEL, d, bundle);
        AppEventsLogger.eagerFlush();
    }

    public void logPurchase(BigDecimal bigDecimal, Currency currency) {
        logPurchase(bigDecimal, currency, null);
    }

    public void logPurchase(BigDecimal bigDecimal, Currency currency, Bundle bundle) {
        this.appEventsLogger.logPurchase(bigDecimal, currency, bundle);
    }
}
