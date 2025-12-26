package com.adobe.air.wand.view;

import android.app.Activity;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Typeface;
import android.support.v7.appcompat.R;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.ViewFlipper;
import com.adobe.air.wand.view.WandView;

/* loaded from: classes.dex */
public class WandViewFlipper extends ViewFlipper implements WandView {
    private static final String ACTIVE_WIFI_ASSIST_MESSAGE = "Enter this PIN in the desktop game and press 'Connect'";
    private static final String DEFAULT_VIEW_FONT_ASSET = "AdobeClean-Light.ttf";
    private static final String INACTIVE_WIFI_ASSIST_MESSAGE = "Connect this device to WiFi to get the pairing PIN";
    private static final String LOG_TAG = "WandViewFlipper";
    private static final String PIN_TITLE = "PIN : ";
    private static final String TITLE_DESCRIPTION_STRING = "Use this device as a Wireless Gamepad";
    private CompanionView mCompanionView;
    private View mCompanionViewHolder;
    private int mCurrentViewIndex;
    private View mDefaultView;
    private WandView.Listener mListener;
    private TouchSensor mTouchSensor;

    public WandViewFlipper(Context context) {
        super(context);
        this.mCurrentViewIndex = 0;
        this.mDefaultView = null;
        this.mCompanionViewHolder = null;
        this.mCompanionView = null;
        this.mTouchSensor = null;
        this.mListener = null;
        initView(context);
    }

    public WandViewFlipper(Context context, AttributeSet attributeSet) {
        super(context, attributeSet);
        this.mCurrentViewIndex = 0;
        this.mDefaultView = null;
        this.mCompanionViewHolder = null;
        this.mCompanionView = null;
        this.mTouchSensor = null;
        this.mListener = null;
        initView(context);
    }

    private void initView(Context context) {
        this.mListener = null;
        try {
            setKeepScreenOn(true);
            LayoutInflater layoutInflaterFrom = LayoutInflater.from(context);
            this.mDefaultView = layoutInflaterFrom.inflate(R.layout.wand_default, (ViewGroup) null);
            this.mCompanionViewHolder = layoutInflaterFrom.inflate(R.layout.wand_companion, (ViewGroup) null);
            this.mDefaultView.getBackground().setDither(true);
            TextView textView = (TextView) this.mDefaultView.findViewById(R.id.title_string);
            Typeface typefaceCreateFromAsset = Typeface.createFromAsset(context.getAssets(), DEFAULT_VIEW_FONT_ASSET);
            textView.setTypeface(typefaceCreateFromAsset);
            ((TextView) this.mDefaultView.findViewById(R.id.token_string)).setTypeface(typefaceCreateFromAsset);
            ((TextView) this.mDefaultView.findViewById(R.id.token_desc)).setTypeface(typefaceCreateFromAsset);
            TextView textView2 = (TextView) this.mDefaultView.findViewById(R.id.title_desc);
            textView2.setTypeface(typefaceCreateFromAsset);
            textView2.setText(TITLE_DESCRIPTION_STRING);
            addView(this.mDefaultView, 0);
            addView(this.mCompanionViewHolder, 1);
            this.mCompanionView = (CompanionView) this.mCompanionViewHolder.findViewById(R.id.companion_view);
            this.mTouchSensor = this.mCompanionView.getTouchSensor();
            this.mCurrentViewIndex = 0;
        } catch (Exception e) {
        }
    }

    @Override // com.adobe.air.wand.view.WandView
    public void setScreenOrientation(WandView.ScreenOrientation screenOrientation) throws Exception {
        int i;
        switch (screenOrientation) {
            case LANDSCAPE:
                i = 0;
                break;
            case PORTRAIT:
                i = 1;
                break;
            case REVERSE_PORTRAIT:
                i = 9;
                break;
            case REVERSE_LANDSCAPE:
                i = 8;
                break;
            default:
                i = -1;
                break;
        }
        Activity activity = (Activity) getContext();
        if (activity == null) {
            throw new IllegalArgumentException("Wand cannot find activity while loading companion.");
        }
        activity.setRequestedOrientation(i);
    }

    @Override // com.adobe.air.wand.view.WandView
    public void drawImage(Bitmap bitmap) throws Exception {
        final Bitmap bitmapCreateBitmap;
        if (this.mCurrentViewIndex == 0) {
            throw new Exception("Companion view is not yet loaded.");
        }
        final ImageView imageView = (ImageView) this.mCompanionViewHolder.findViewById(R.id.skin);
        Bitmap bitmapCreateScaledBitmap = Bitmap.createScaledBitmap(bitmap, imageView.getWidth(), (bitmap.getHeight() * imageView.getWidth()) / bitmap.getWidth(), true);
        if (bitmapCreateScaledBitmap != bitmap) {
            bitmap.recycle();
        }
        int height = imageView.getHeight();
        int height2 = bitmapCreateScaledBitmap.getHeight();
        if (height2 > height) {
            bitmapCreateBitmap = Bitmap.createBitmap(bitmapCreateScaledBitmap, 0, height2 - height, imageView.getWidth(), imageView.getHeight());
            if (bitmapCreateBitmap != bitmapCreateScaledBitmap) {
                bitmapCreateScaledBitmap.recycle();
            }
        } else {
            bitmapCreateBitmap = bitmapCreateScaledBitmap;
        }
        ((Activity) getContext()).runOnUiThread(new Runnable() { // from class: com.adobe.air.wand.view.WandViewFlipper.1
            @Override // java.lang.Runnable
            public void run() {
                imageView.setImageBitmap(bitmapCreateBitmap);
            }
        });
    }

    /* JADX INFO: Access modifiers changed from: private */
    public static String getTokenString(String str) {
        return PIN_TITLE + str;
    }

    /* JADX INFO: Access modifiers changed from: private */
    public static String getTokenDesc(boolean z) {
        return z ? ACTIVE_WIFI_ASSIST_MESSAGE : INACTIVE_WIFI_ASSIST_MESSAGE;
    }

    @Override // com.adobe.air.wand.view.WandView
    public void loadDefaultView() throws Exception {
        ((Activity) getContext()).runOnUiThread(new Runnable() { // from class: com.adobe.air.wand.view.WandViewFlipper.2
            @Override // java.lang.Runnable
            public void run() {
                ((ImageView) WandViewFlipper.this.mCompanionViewHolder.findViewById(R.id.skin)).setImageResource(R.color.transparent);
                WandViewFlipper.this.mCurrentViewIndex = 0;
                String connectionToken = WandViewFlipper.this.mListener != null ? WandViewFlipper.this.mListener.getConnectionToken() : "";
                ((TextView) WandViewFlipper.this.mDefaultView.findViewById(R.id.token_string)).setText(!connectionToken.equals("") ? WandViewFlipper.getTokenString(connectionToken) : connectionToken);
                ((TextView) WandViewFlipper.this.mDefaultView.findViewById(R.id.token_desc)).setText(WandViewFlipper.getTokenDesc(!WandViewFlipper.this.mListener.getConnectionToken().equals("")));
                WandViewFlipper.this.setDisplayedChild(WandViewFlipper.this.mCurrentViewIndex);
            }
        });
    }

    @Override // com.adobe.air.wand.view.WandView
    public void loadCompanionView() throws Exception {
        if (this.mCurrentViewIndex != 1) {
            this.mCurrentViewIndex = 1;
            ((Activity) getContext()).runOnUiThread(new Runnable() { // from class: com.adobe.air.wand.view.WandViewFlipper.3
                @Override // java.lang.Runnable
                public void run() {
                    WandViewFlipper.this.setDisplayedChild(WandViewFlipper.this.mCurrentViewIndex);
                    try {
                        if (WandViewFlipper.this.mListener != null) {
                            WandViewFlipper.this.mListener.onLoadCompanion(((Activity) WandViewFlipper.this.getContext()).getResources().getConfiguration());
                        }
                    } catch (Exception e) {
                    }
                }
            });
        }
    }

    @Override // com.adobe.air.wand.view.WandView
    public void registerListener(WandView.Listener listener) throws Exception {
        if (this.mListener != null) {
            throw new Exception("View listener is already registered");
        }
        if (listener == null) {
            throw new Exception("Invalid view listener");
        }
        this.mListener = listener;
    }

    @Override // com.adobe.air.wand.view.WandView
    public void unregisterListener() {
        this.mListener = null;
    }

    @Override // com.adobe.air.wand.view.WandView
    public void updateConnectionToken(final String str) {
        if (this.mCurrentViewIndex != 1) {
            ((Activity) getContext()).runOnUiThread(new Runnable() { // from class: com.adobe.air.wand.view.WandViewFlipper.4
                @Override // java.lang.Runnable
                public void run() {
                    ((TextView) WandViewFlipper.this.mDefaultView.findViewById(R.id.token_string)).setText(!str.equals("") ? WandViewFlipper.getTokenString(str) : "");
                    ((TextView) WandViewFlipper.this.mDefaultView.findViewById(R.id.token_desc)).setText(WandViewFlipper.getTokenDesc(!str.equals("")));
                }
            });
        }
    }

    @Override // com.adobe.air.wand.view.WandView
    public TouchSensor getTouchSensor() {
        return this.mTouchSensor;
    }
}
