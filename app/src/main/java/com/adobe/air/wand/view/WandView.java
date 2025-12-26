package com.adobe.air.wand.view;

import android.content.res.Configuration;
import android.graphics.Bitmap;

/* loaded from: classes.dex */
public interface WandView {

    public interface Listener {
        String getConnectionToken();

        void onLoadCompanion(Configuration configuration) throws Exception;
    }

    void drawImage(Bitmap bitmap) throws Exception;

    TouchSensor getTouchSensor();

    void loadCompanionView() throws Exception;

    void loadDefaultView() throws Exception;

    void registerListener(Listener listener) throws Exception;

    void setScreenOrientation(ScreenOrientation screenOrientation) throws Exception;

    void unregisterListener();

    void updateConnectionToken(String str);

    public enum ScreenOrientation {
        LANDSCAPE("LANDSCAPE"),
        PORTRAIT("PORTRAIT"),
        REVERSE_LANDSCAPE("REVERSE_LANDSCAPE"),
        REVERSE_PORTRAIT("REVERSE_PORTRAIT"),
        AUTO("AUTO"),
        INHERIT("INHERIT");

        private final String mOrientation;

        ScreenOrientation(String str) {
            this.mOrientation = str;
        }

        @Override // java.lang.Enum
        public String toString() {
            return this.mOrientation;
        }

        public static ScreenOrientation getScreenOrientation(String str) throws Exception {
            if (LANDSCAPE.toString().equals(str)) {
                return LANDSCAPE;
            }
            if (PORTRAIT.toString().equals(str)) {
                return PORTRAIT;
            }
            if (REVERSE_LANDSCAPE.toString().equals(str)) {
                return REVERSE_LANDSCAPE;
            }
            if (REVERSE_PORTRAIT.toString().equals(str)) {
                return REVERSE_PORTRAIT;
            }
            if (AUTO.toString().equals(str)) {
                return AUTO;
            }
            if (INHERIT.toString().equals(str)) {
                return INHERIT;
            }
            throw new Exception("Unspported screen orientation");
        }
    }
}
