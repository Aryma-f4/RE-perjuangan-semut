package com.mimopay;

import android.R;
import android.app.Activity;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Point;
import android.graphics.PorterDuff;
import android.graphics.PorterDuffXfermode;
import android.graphics.Rect;
import android.graphics.RectF;
import android.graphics.Typeface;
import android.graphics.drawable.ColorDrawable;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.GradientDrawable;
import android.graphics.drawable.StateListDrawable;
import android.os.Build;
import android.os.Bundle;
import android.os.Looper;
import android.support.v4.view.MotionEventCompat;
import android.telephony.TelephonyManager;
import android.text.Editable;
import android.text.InputFilter;
import android.text.Spanned;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.util.Log;
import android.view.Display;
import android.view.View;
import android.view.WindowManager;
import android.view.inputmethod.InputMethodManager;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.RelativeLayout;
import android.widget.ScrollView;
import android.widget.TextView;
import android.widget.Toast;
import com.facebook.AppEventsConstants;
import com.facebook.internal.NativeProtocol;
import java.lang.Thread;
import java.util.ArrayList;
import org.json.JSONArray;
import org.json.JSONException;

/* loaded from: classes.dex */
public class MimopayActivity extends Activity {
    private EditText edtUserToken = null;
    private int measuredWidth = 0;
    private int measuredHeight = 0;
    private boolean bMaxTopUpNumbers = false;
    private final int TEXT_COLOR = -9599820;
    private final int holobluelight = -13388315;
    private final int holobluedark = -16737844;
    private final int holobluebright = -16720385;
    private MimopayActivityCore mCore = null;
    private String mInfoResult = NativeProtocol.ERROR_USER_CANCELED;
    private ArrayList<String> mAlsResult = null;
    private String mPhoneNumber = null;
    private String mAirtimeValue = null;
    private boolean mbCannotSMS = false;
    InputFilter voucherfilter = new InputFilter() { // from class: com.mimopay.MimopayActivity.8
        @Override // android.text.InputFilter
        public CharSequence filter(CharSequence source, int start, int end, Spanned dest, int dstart, int dend) {
            if (MimopayActivity.this.bMaxTopUpNumbers) {
                return "";
            }
            for (int i = start; i < end; i++) {
                if (!Character.isDigit(source.charAt(i))) {
                    return "";
                }
            }
            return null;
        }
    };
    String mXLReferenceId = "";

    /* JADX INFO: Access modifiers changed from: private */
    public void jprintf(String s) {
        if (MimopayStuff.mEnableLog) {
            Log.d("JimBas", "MimopayActivity: " + s);
        }
    }

    @Override // android.app.Activity
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        jprintf("onCreate");
        Thread.setDefaultUncaughtExceptionHandler(new TopExceptionHandler());
        getWindow().setBackgroundDrawable(new ColorDrawable(-1895825408));
        int reqorient = getResources().getConfiguration().orientation == 2 ? 0 : 1;
        setRequestedOrientation(reqorient);
        this.mCore = new MimopayActivityCore();
        this.mPhoneNumber = getIntent().getStringExtra("PhoneNumber");
        this.mAirtimeValue = getIntent().getStringExtra("AirtimeValue");
        this.mCore.mActivity = this;
        getScreenDimension();
        this.mCore.executePayment();
    }

    private class TopExceptionHandler implements Thread.UncaughtExceptionHandler {
        private Thread.UncaughtExceptionHandler defaultUEH = Thread.getDefaultUncaughtExceptionHandler();

        TopExceptionHandler() {
        }

        /* JADX WARN: Type inference failed for: r1v6, types: [com.mimopay.MimopayActivity$TopExceptionHandler$1] */
        @Override // java.lang.Thread.UncaughtExceptionHandler
        public void uncaughtException(Thread t, Throwable e) throws InterruptedException {
            String reason = e.toString();
            MimopayActivity.this.jprintf("forceCloseReason: " + reason);
            MimopayActivity.this.mInfoResult = "FATALERROR";
            MimopayActivity.this.mAlsResult = new ArrayList();
            MimopayActivity.this.mAlsResult.add(reason);
            if (Mimopay.mMi != null) {
                Mimopay.mMi.onReturn(MimopayActivity.this.mInfoResult, MimopayActivity.this.mAlsResult);
            }
            new Thread() { // from class: com.mimopay.MimopayActivity.TopExceptionHandler.1
                @Override // java.lang.Thread, java.lang.Runnable
                public void run() {
                    Looper.prepare();
                    if (!MimopayActivity.this.isActivityFinishing()) {
                        Toast.makeText(MimopayActivity.this.getApplicationContext(), "Mimopay has Crashed. Recovering now...", 1).show();
                    }
                    Looper.loop();
                }
            }.start();
            try {
                Thread.sleep(3000L);
            } catch (InterruptedException e2) {
            }
            System.exit(666);
        }
    }

    private void _recreate() {
        this.mInfoResult = "_recreate";
        if (Build.VERSION.SDK_INT < 11) {
            Intent intent = getIntent();
            intent.addFlags(65536);
            startActivity(intent);
            if (Build.VERSION.SDK_INT >= 5) {
                overridePendingTransition(0, 0);
            }
            finish();
            if (Build.VERSION.SDK_INT >= 5) {
                overridePendingTransition(0, 0);
                return;
            }
            return;
        }
        recreate();
    }

    private void getScreenDimension() {
        Point size = new Point();
        WindowManager w = getWindowManager();
        if (Build.VERSION.SDK_INT >= 11) {
            w.getDefaultDisplay().getSize(size);
            this.measuredWidth = size.x;
            this.measuredHeight = size.y;
        } else {
            Display d = w.getDefaultDisplay();
            this.measuredWidth = d.getWidth();
            this.measuredHeight = d.getHeight();
        }
        jprintf("measuredWidth: " + this.measuredWidth + " measuredHeight: " + this.measuredHeight);
    }

    private void setBkgndCompat(View v, Drawable background) {
        if (Build.VERSION.SDK_INT >= 16) {
            v.setBackground(background);
        } else {
            v.setBackgroundDrawable(background);
        }
    }

    /* JADX INFO: Access modifiers changed from: private */
    public void setupTopUpMainUI() {
        int id;
        RelativeLayout relativeLayout = new RelativeLayout(this);
        RelativeLayout relativeLayout2 = new RelativeLayout(this);
        relativeLayout2.setPadding(20, 20, 20, 20);
        RelativeLayout.LayoutParams rllp = new RelativeLayout.LayoutParams(-1, -2);
        rllp.addRule(13);
        relativeLayout2.setLayoutParams(rllp);
        GradientDrawable rlshape = new GradientDrawable();
        rlshape.setCornerRadius(8.0f);
        rlshape.setColor(-2105377);
        setBkgndCompat(relativeLayout2, rlshape);
        ArrayList<Integer> alsi = new ArrayList<>();
        Bitmap mlbmp = getRoundedCornerBitmap(this.mCore.getBitmapInternal(this.mCore.mMimopayLogoUrl), -1);
        if (1 != 0 && mlbmp != null) {
            ImageView ivmimopaylogo = new ImageView(this);
            id = 0 + 1;
            ivmimopaylogo.setId(id);
            RelativeLayout.LayoutParams ivmimopaylogolp = new RelativeLayout.LayoutParams(-2, -2);
            ivmimopaylogolp.addRule(6);
            ivmimopaylogolp.addRule(14);
            ivmimopaylogo.setLayoutParams(ivmimopaylogolp);
            ivmimopaylogo.setImageBitmap(mlbmp);
            relativeLayout2.addView(ivmimopaylogo);
            alsi.add(Integer.valueOf(mlbmp.getWidth()));
        } else {
            TextView tvlogo = new TextView(this);
            id = 0 + 1;
            tvlogo.setId(id);
            RelativeLayout.LayoutParams tvlogolp = new RelativeLayout.LayoutParams(-2, -2);
            tvlogolp.addRule(6);
            tvlogolp.addRule(14);
            tvlogo.setLayoutParams(tvlogolp);
            tvlogo.setText("MIMOPAY");
            float fh = tvlogo.getTextSize();
            tvlogo.setTextSize(1.2f * fh);
            tvlogo.setTypeface(Typeface.DEFAULT_BOLD);
            tvlogo.setTextColor(-9599820);
            relativeLayout2.addView(tvlogo);
            alsi.add(Integer.valueOf((int) tvlogo.getPaint().measureText("MIMOPAY")));
        }
        int spaceid = 1000 + 1;
        relativeLayout2.addView(inBetweenHorizontalSpace(spaceid, 20, id));
        int id2 = id + 1;
        relativeLayout2.addView(lineSeparator(id2, spaceid));
        int spaceid2 = spaceid + 1;
        relativeLayout2.addView(inBetweenHorizontalSpace(spaceid2, 20, id2));
        if (this.mCore.alsLogos != null) {
            int chid = 19;
            int j = this.mCore.alsLogos.size();
            for (int i = 0; i < j; i++) {
                if (1 != 0) {
                    ImageButton iv = new ImageButton(this);
                    setButtonShape(iv);
                    RelativeLayout.LayoutParams ivlp = new RelativeLayout.LayoutParams(-1, -2);
                    ivlp.addRule(3, spaceid2);
                    ivlp.addRule(14);
                    chid++;
                    iv.setId(chid);
                    Bitmap mlbmp2 = getRoundedCornerBitmap(this.mCore.getBitmapInternal(this.mCore.alsLogos.get(i)), -1);
                    if (mlbmp2 != null) {
                        iv.setImageBitmap(mlbmp2);
                        iv.setOnClickListener(new View.OnClickListener() { // from class: com.mimopay.MimopayActivity.1
                            @Override // android.view.View.OnClickListener
                            public void onClick(View view) throws JSONException {
                                int id3 = view.getId();
                                MimopayActivity.this.jprintf("id: " + Integer.toString(id3));
                                switch (id3) {
                                    case 20:
                                        MimopayActivity.this.mCore.mAlsActiveIdx = 0;
                                        MimopayStuff.sChannel = "smartfren";
                                        MimopayActivity.this.setupTopUpVoucherUI();
                                        break;
                                    case 21:
                                        MimopayActivity.this.mCore.mAlsActiveIdx = 1;
                                        MimopayStuff.sChannel = "sevelin";
                                        MimopayActivity.this.setupTopUpVoucherUI();
                                        break;
                                    case 22:
                                        MimopayActivity.this.mCore.mAlsActiveIdx = 2;
                                        MimopayActivity.this.setupDenomUI();
                                        break;
                                }
                            }
                        });
                        alsi.add(Integer.valueOf(mlbmp2.getWidth()));
                    }
                    iv.setLayoutParams(ivlp);
                    relativeLayout2.addView(iv);
                } else {
                    Button btch = new Button(this);
                    setButtonShape(btch);
                    chid++;
                    btch.setId(chid);
                    RelativeLayout.LayoutParams btchlp = new RelativeLayout.LayoutParams(-1, -2);
                    btchlp.addRule(3, spaceid2);
                    btchlp.addRule(14);
                    btch.setLayoutParams(btchlp);
                    String scap = this.mCore.alsBtnAction.get(i).toUpperCase().replace('_', ' ');
                    btch.setText(scap);
                    btch.setTypeface(Typeface.DEFAULT_BOLD);
                    btch.setTextColor(-9599820);
                    btch.setOnClickListener(new View.OnClickListener() { // from class: com.mimopay.MimopayActivity.2
                        @Override // android.view.View.OnClickListener
                        public void onClick(View view) throws JSONException {
                            int id3 = view.getId();
                            MimopayActivity.this.jprintf("id: " + Integer.toString(id3));
                            switch (id3) {
                                case 20:
                                    MimopayActivity.this.mCore.mAlsActiveIdx = 0;
                                    MimopayStuff.sChannel = "smartfren";
                                    MimopayActivity.this.setupTopUpVoucherUI();
                                    break;
                                case 21:
                                    MimopayActivity.this.mCore.mAlsActiveIdx = 1;
                                    MimopayStuff.sChannel = "sevelin";
                                    MimopayActivity.this.setupTopUpVoucherUI();
                                    break;
                                case 22:
                                    MimopayActivity.this.mCore.mAlsActiveIdx = 2;
                                    MimopayActivity.this.setupDenomUI();
                                    break;
                            }
                        }
                    });
                    alsi.add(Integer.valueOf((int) btch.getPaint().measureText(scap)));
                    relativeLayout2.addView(btch);
                }
                spaceid2++;
                relativeLayout2.addView(inBetweenHorizontalSpace(spaceid2, 5, chid));
            }
        }
        int b = alsi.size();
        int d = 0;
        for (int a = 0; a < b; a++) {
            int c = alsi.get(a).intValue();
            if (d < c) {
                d = c;
            }
        }
        int i2 = 20 * 2;
        int wdth = (d / 4) + d + 40;
        if (wdth > this.measuredWidth - (20 * 2)) {
            wdth = this.measuredWidth - (20 * 2);
        }
        relativeLayout2.getLayoutParams().width = wdth;
        ScrollView scrollView = new ScrollView(this);
        RelativeLayout.LayoutParams svlp = new RelativeLayout.LayoutParams(-2, -2);
        svlp.addRule(14);
        svlp.addRule(15);
        scrollView.setLayoutParams(svlp);
        scrollView.setVerticalScrollBarEnabled(false);
        scrollView.setHorizontalScrollBarEnabled(false);
        scrollView.addView(relativeLayout2);
        relativeLayout.addView(scrollView);
        setContentView(relativeLayout, new RelativeLayout.LayoutParams(-1, -1));
    }

    /* JADX INFO: Access modifiers changed from: private */
    public void setupXLMainUI() {
        int id;
        RelativeLayout relativeLayout = new RelativeLayout(this);
        RelativeLayout relativeLayout2 = new RelativeLayout(this);
        relativeLayout2.setPadding(20, 20, 20, 20);
        RelativeLayout.LayoutParams rllp = new RelativeLayout.LayoutParams(-1, -2);
        rllp.addRule(13);
        relativeLayout2.setLayoutParams(rllp);
        GradientDrawable rlshape = new GradientDrawable();
        rlshape.setCornerRadius(8.0f);
        rlshape.setColor(-2105377);
        setBkgndCompat(relativeLayout2, rlshape);
        ArrayList<Integer> alsi = new ArrayList<>();
        Bitmap mlbmp = getRoundedCornerBitmap(this.mCore.getBitmapInternal(this.mCore.alsLogos.get(0)), -1);
        if (1 != 0 && mlbmp != null) {
            ImageView ivmimopaylogo = new ImageView(this);
            id = 0 + 1;
            ivmimopaylogo.setId(id);
            RelativeLayout.LayoutParams ivmimopaylogolp = new RelativeLayout.LayoutParams(-2, -2);
            ivmimopaylogolp.addRule(6);
            ivmimopaylogolp.addRule(14);
            ivmimopaylogo.setLayoutParams(ivmimopaylogolp);
            ivmimopaylogo.setImageBitmap(mlbmp);
            relativeLayout2.addView(ivmimopaylogo);
            alsi.add(Integer.valueOf(mlbmp.getWidth()));
        } else {
            TextView tvlogo = new TextView(this);
            id = 0 + 1;
            tvlogo.setId(id);
            RelativeLayout.LayoutParams tvlogolp = new RelativeLayout.LayoutParams(-2, -2);
            tvlogolp.addRule(6);
            tvlogolp.addRule(14);
            tvlogo.setLayoutParams(tvlogolp);
            tvlogo.setText(" XL ");
            float fh = tvlogo.getTextSize();
            tvlogo.setTextSize(1.2f * fh);
            tvlogo.setTypeface(Typeface.DEFAULT_BOLD);
            tvlogo.setTextColor(-9599820);
            relativeLayout2.addView(tvlogo);
            alsi.add(Integer.valueOf((int) tvlogo.getPaint().measureText(" XL ")));
        }
        int spaceid = 1000 + 1;
        relativeLayout2.addView(inBetweenHorizontalSpace(spaceid, 20, id));
        int id2 = id + 1;
        relativeLayout2.addView(lineSeparator(id2, spaceid));
        int spaceid2 = spaceid + 1;
        relativeLayout2.addView(inBetweenHorizontalSpace(spaceid2, 20, id2));
        if (this.mCore.alsLogos != null) {
            int chid = 19;
            final int fchid = 19 + 1;
            int j = this.mCore.alsLogos.size();
            for (int i = 0; i < j; i++) {
                Button btch = new Button(this);
                setButtonShape(btch);
                chid++;
                btch.setId(chid);
                RelativeLayout.LayoutParams btchlp = new RelativeLayout.LayoutParams(-1, -2);
                btchlp.addRule(3, spaceid2);
                btchlp.addRule(14);
                btch.setLayoutParams(btchlp);
                String scap = this.mCore.alsLabels.get(i);
                btch.setText(scap);
                btch.setGravity(17);
                btch.setTypeface(Typeface.DEFAULT_BOLD);
                btch.setTextColor(-9599820);
                btch.setOnClickListener(new View.OnClickListener() { // from class: com.mimopay.MimopayActivity.3
                    @Override // android.view.View.OnClickListener
                    public void onClick(View view) throws JSONException {
                        int id3 = view.getId() - fchid;
                        if (id3 < 0) {
                            id3 = 0;
                        }
                        MimopayActivity.this.mCore.mAlsActiveIdx = id3;
                        String st = MimopayActivity.this.mCore.alsBtnAction.get(id3);
                        MimopayStuff.sChannel = st;
                        if (st.equals("xl_airtime")) {
                            MimopayStuff.sChannel = "xl_airtime";
                            MimopayActivity.this.setupAirtimeDenomUI();
                        } else if (st.equals("xl_hrn")) {
                            MimopayStuff.sChannel = "xl_hrn";
                            MimopayActivity.this.setupTopUpVoucherUI();
                        }
                    }
                });
                alsi.add(Integer.valueOf((int) btch.getPaint().measureText("  " + scap + "  ")));
                relativeLayout2.addView(btch);
                spaceid2++;
                relativeLayout2.addView(inBetweenHorizontalSpace(spaceid2, 5, chid));
            }
        }
        int b = alsi.size();
        int d = 0;
        for (int a = 0; a < b; a++) {
            int c = alsi.get(a).intValue();
            if (d < c) {
                d = c;
            }
        }
        int i2 = 20 * 2;
        int wdth = (d / 4) + d + 40;
        if (wdth > this.measuredWidth - (20 * 2)) {
            wdth = this.measuredWidth - (20 * 2);
        }
        relativeLayout2.getLayoutParams().width = wdth;
        ScrollView scrollView = new ScrollView(this);
        RelativeLayout.LayoutParams svlp = new RelativeLayout.LayoutParams(-2, -2);
        svlp.addRule(14);
        svlp.addRule(15);
        scrollView.setLayoutParams(svlp);
        scrollView.setVerticalScrollBarEnabled(false);
        scrollView.setHorizontalScrollBarEnabled(false);
        scrollView.addView(relativeLayout2);
        relativeLayout.addView(scrollView);
        setContentView(relativeLayout, new RelativeLayout.LayoutParams(-1, -1));
    }

    /* JADX INFO: Access modifiers changed from: private */
    public void setupAtmMainUI() {
        int id;
        RelativeLayout relativeLayout = new RelativeLayout(this);
        RelativeLayout relativeLayout2 = new RelativeLayout(this);
        relativeLayout2.setPadding(20, 20, 20, 20);
        RelativeLayout.LayoutParams rllp = new RelativeLayout.LayoutParams(-1, -2);
        rllp.addRule(13);
        relativeLayout2.setLayoutParams(rllp);
        GradientDrawable rlshape = new GradientDrawable();
        rlshape.setCornerRadius(8.0f);
        rlshape.setColor(-2105377);
        setBkgndCompat(relativeLayout2, rlshape);
        ArrayList<Integer> alsi = new ArrayList<>();
        Bitmap mlbmp = getRoundedCornerBitmap(this.mCore.getBitmapInternal(this.mCore.mMimopayLogoUrl), -1);
        if (1 != 0 && mlbmp != null) {
            ImageView ivmimopaylogo = new ImageView(this);
            id = 0 + 1;
            ivmimopaylogo.setId(id);
            RelativeLayout.LayoutParams ivmimopaylogolp = new RelativeLayout.LayoutParams(-2, -2);
            ivmimopaylogolp.addRule(6);
            ivmimopaylogolp.addRule(14);
            ivmimopaylogo.setLayoutParams(ivmimopaylogolp);
            ivmimopaylogo.setImageBitmap(mlbmp);
            relativeLayout2.addView(ivmimopaylogo);
            alsi.add(Integer.valueOf(mlbmp.getWidth()));
        } else {
            TextView tvlogo = new TextView(this);
            id = 0 + 1;
            tvlogo.setId(id);
            RelativeLayout.LayoutParams tvlogolp = new RelativeLayout.LayoutParams(-2, -2);
            tvlogolp.addRule(6);
            tvlogolp.addRule(14);
            tvlogo.setLayoutParams(tvlogolp);
            tvlogo.setText("MIMOPAY");
            float fh = tvlogo.getTextSize();
            tvlogo.setTextSize(1.2f * fh);
            tvlogo.setTypeface(Typeface.DEFAULT_BOLD);
            tvlogo.setTextColor(-9599820);
            relativeLayout2.addView(tvlogo);
            alsi.add(Integer.valueOf((int) tvlogo.getPaint().measureText("MIMOPAY")));
        }
        int spaceid = 1000 + 1;
        relativeLayout2.addView(inBetweenHorizontalSpace(spaceid, 20, id));
        int id2 = id + 1;
        relativeLayout2.addView(lineSeparator(id2, spaceid));
        int spaceid2 = spaceid + 1;
        relativeLayout2.addView(inBetweenHorizontalSpace(spaceid2, 20, id2));
        if (this.mCore.alsLogos != null) {
            int chid = 19;
            int j = this.mCore.alsLogos.size();
            for (int i = 0; i < j; i++) {
                if (1 != 0) {
                    ImageButton iv = new ImageButton(this);
                    setButtonShape(iv);
                    RelativeLayout.LayoutParams ivlp = new RelativeLayout.LayoutParams(-1, -2);
                    ivlp.addRule(3, spaceid2);
                    ivlp.addRule(14);
                    chid++;
                    iv.setId(chid);
                    Bitmap mlbmp2 = getRoundedCornerBitmap(this.mCore.getBitmapInternal(this.mCore.alsLogos.get(i)), -1);
                    if (mlbmp2 != null) {
                        iv.setImageBitmap(mlbmp2);
                        iv.setOnClickListener(new View.OnClickListener() { // from class: com.mimopay.MimopayActivity.4
                            @Override // android.view.View.OnClickListener
                            public void onClick(View view) {
                                int id3 = view.getId();
                                MimopayActivity.this.jprintf("id: " + Integer.toString(id3));
                                MimopayActivity.this.mCore.mAlsActiveIdx = id3 - 20;
                                MimopayActivity.this.setupAtmChoosenUI();
                            }
                        });
                        alsi.add(Integer.valueOf(mlbmp2.getWidth()));
                    }
                    iv.setLayoutParams(ivlp);
                    relativeLayout2.addView(iv);
                } else {
                    Button btch = new Button(this);
                    setButtonShape(btch);
                    chid++;
                    btch.setId(chid);
                    RelativeLayout.LayoutParams btchlp = new RelativeLayout.LayoutParams(-1, -2);
                    btchlp.addRule(3, spaceid2);
                    btchlp.addRule(14);
                    btch.setLayoutParams(btchlp);
                    String scap = this.mCore.alsBtnAction.get(i).toUpperCase().replace('_', ' ');
                    btch.setText(scap);
                    btch.setTypeface(Typeface.DEFAULT_BOLD);
                    btch.setTextColor(-9599820);
                    btch.setOnClickListener(new View.OnClickListener() { // from class: com.mimopay.MimopayActivity.5
                        @Override // android.view.View.OnClickListener
                        public void onClick(View view) {
                            int id3 = view.getId();
                            MimopayActivity.this.jprintf("id: " + Integer.toString(id3));
                            MimopayActivity.this.mCore.mAlsActiveIdx = id3 - 20;
                            MimopayActivity.this.setupAtmChoosenUI();
                        }
                    });
                    alsi.add(Integer.valueOf((int) btch.getPaint().measureText(scap)));
                    relativeLayout2.addView(btch);
                }
                spaceid2++;
                relativeLayout2.addView(inBetweenHorizontalSpace(spaceid2, 5, chid));
            }
        }
        int b = alsi.size();
        int d = 0;
        for (int a = 0; a < b; a++) {
            int c = alsi.get(a).intValue();
            if (d < c) {
                d = c;
            }
        }
        int i2 = 20 * 2;
        int wdth = (d / 4) + d + 40;
        if (wdth > this.measuredWidth - (20 * 2)) {
            wdth = this.measuredWidth - (20 * 2);
        }
        relativeLayout2.getLayoutParams().width = wdth;
        ScrollView scrollView = new ScrollView(this);
        RelativeLayout.LayoutParams svlp = new RelativeLayout.LayoutParams(-2, -2);
        svlp.addRule(14);
        svlp.addRule(15);
        scrollView.setLayoutParams(svlp);
        scrollView.setVerticalScrollBarEnabled(false);
        scrollView.setHorizontalScrollBarEnabled(false);
        scrollView.addView(relativeLayout2);
        relativeLayout.addView(scrollView);
        setContentView(relativeLayout, new RelativeLayout.LayoutParams(-1, -1));
    }

    /* JADX INFO: Access modifiers changed from: private */
    public void setupDenomUI() throws JSONException {
        int id;
        RelativeLayout relativeLayout = new RelativeLayout(this);
        RelativeLayout relativeLayout2 = new RelativeLayout(this);
        relativeLayout2.setPadding(20, 20, 20, 20);
        RelativeLayout.LayoutParams rllp = new RelativeLayout.LayoutParams(-1, -2);
        rllp.addRule(13);
        relativeLayout2.setLayoutParams(rllp);
        GradientDrawable rlshape = new GradientDrawable();
        rlshape.setCornerRadius(8.0f);
        rlshape.setColor(-2105377);
        setBkgndCompat(relativeLayout2, rlshape);
        ArrayList<Integer> alsi = new ArrayList<>();
        if (1 != 0) {
            ImageView ivlogo = new ImageView(this);
            id = 0 + 1;
            ivlogo.setId(id);
            RelativeLayout.LayoutParams ivlogolp = new RelativeLayout.LayoutParams(-2, -2);
            ivlogolp.addRule(6);
            ivlogolp.addRule(14);
            ivlogo.setLayoutParams(ivlogolp);
            Bitmap mlbmp = getRoundedCornerBitmap(this.mCore.getBitmapInternal(this.mCore.alsLogos.get(this.mCore.mAlsActiveIdx)), -1);
            if (mlbmp != null) {
                ivlogo.setImageBitmap(mlbmp);
                alsi.add(Integer.valueOf(mlbmp.getWidth()));
            }
            relativeLayout2.addView(ivlogo);
        } else {
            TextView tvlogo = new TextView(this);
            id = 0 + 1;
            tvlogo.setId(id);
            RelativeLayout.LayoutParams tvlogolp = new RelativeLayout.LayoutParams(-2, -2);
            tvlogolp.addRule(6);
            tvlogolp.addRule(14);
            tvlogo.setLayoutParams(tvlogolp);
            String scap = this.mCore.alsBtnAction.get(this.mCore.mAlsActiveIdx).toUpperCase().replace('_', ' ');
            tvlogo.setText(scap);
            tvlogo.setTypeface(Typeface.DEFAULT_BOLD);
            tvlogo.setTextColor(-9599820);
            relativeLayout2.addView(tvlogo);
            alsi.add(Integer.valueOf((int) tvlogo.getPaint().measureText(scap)));
        }
        int spaceid = 1000 + 1;
        relativeLayout2.addView(inBetweenHorizontalSpace(spaceid, 20, id));
        int id2 = id + 1;
        relativeLayout2.addView(lineSeparator(id2, spaceid));
        int spaceid2 = spaceid + 1;
        relativeLayout2.addView(inBetweenHorizontalSpace(spaceid2, 20, id2));
        final Button btn = new Button(this);
        this.mCore.mHttppostCode = null;
        RadioGroup rg = new RadioGroup(this);
        int id3 = id2 + 1;
        rg.setId(id3);
        rg.setOnCheckedChangeListener(new RadioGroup.OnCheckedChangeListener() { // from class: com.mimopay.MimopayActivity.6
            @Override // android.widget.RadioGroup.OnCheckedChangeListener
            public void onCheckedChanged(RadioGroup rg2, int cid) {
                String s = MimopayActivity.this.mCore.alsDenomValue.get(MimopayActivity.this.mCore.mAlsActiveIdx);
                int did = cid - 100;
                try {
                    JSONArray jarr = new JSONArray(s);
                    MimopayActivity.this.mCore.mHttppostCode = jarr.getString(did);
                } catch (JSONException e) {
                }
                MimopayActivity.this.jprintf("cid: " + Integer.toString(cid) + " mCore.mHttppostCode: " + MimopayActivity.this.mCore.mHttppostCode);
                btn.setEnabled(true);
                if (Build.VERSION.SDK_INT >= 11) {
                    btn.setAlpha(1.0f);
                }
            }
        });
        RelativeLayout.LayoutParams rglp = new RelativeLayout.LayoutParams(-2, -2);
        rglp.addRule(3, spaceid2);
        rg.setOrientation(1);
        rg.setLayoutParams(rglp);
        ArrayList<Integer> alirb = new ArrayList<>();
        try {
            String s = this.mCore.alsDenomContent.get(this.mCore.mAlsActiveIdx);
            JSONArray jarr = new JSONArray(s);
            int j = jarr.length();
            RadioButton[] rb = new RadioButton[j];
            int k = 0;
            for (int i = 0; i < j; i++) {
                rb[k] = new RadioButton(this);
                String ss = jarr.getString(i);
                jprintf("jarr: " + ss + " i: " + Integer.toString(i));
                setButtonShape(rb[k]);
                rb[k].setText(ss);
                rb[k].setTextColor(-9599820);
                rb[k].setTypeface(Typeface.DEFAULT);
                float ftxtsz = rb[k].getTextSize();
                rb[k].setId(i + 100);
                int h = (int) (2.0f * ftxtsz);
                RelativeLayout.LayoutParams rblp = new RelativeLayout.LayoutParams(-2, h);
                rb[k].setLayoutParams(rblp);
                rb[k].setGravity(3);
                rb[k].setEllipsize(TextUtils.TruncateAt.MARQUEE);
                rb[k].setMarqueeRepeatLimit(1);
                rb[k].setHorizontallyScrolling(true);
                rb[k].setSingleLine();
                int isz = (int) rb[k].getPaint().measureText(ss);
                alsi.add(Integer.valueOf(isz));
                alirb.add(Integer.valueOf(isz));
                rg.addView(rb[k]);
                k++;
            }
            relativeLayout2.addView(rg);
            int spaceid3 = spaceid2 + 1;
            relativeLayout2.addView(inBetweenHorizontalSpace(spaceid3, 10, id3));
            setButtonShape(btn);
            int id4 = id3 + 1;
            btn.setId(id4);
            RelativeLayout.LayoutParams blp = new RelativeLayout.LayoutParams(-2, -2);
            blp.addRule(3, spaceid3);
            blp.addRule(7, spaceid3);
            btn.setLayoutParams(blp);
            btn.setText("LANJUT");
            btn.setEnabled(false);
            if (Build.VERSION.SDK_INT >= 11) {
                btn.setAlpha(0.5f);
            }
            btn.setOnClickListener(new View.OnClickListener() { // from class: com.mimopay.MimopayActivity.7
                @Override // android.view.View.OnClickListener
                public void onClick(View v) {
                    if (MimopayActivity.this.mCore.mHttppostCode != null && !MimopayActivity.this.mCore.mHttppostCode.equals("")) {
                        if (MimopayStuff.sPaymentMethod.equals("ATM")) {
                            MimopayStuff.sAmount = MimopayActivity.this.mCore.mHttppostCode;
                            MimopayActivity.this.mCore.reset();
                            MimopayActivity.this.mCore.retrieveMerchantPaymentMethod();
                            return;
                        }
                        MimopayActivity.this.mCore.executeBtnAction();
                    }
                }
            });
            relativeLayout2.addView(btn);
            relativeLayout2.addView(inBetweenHorizontalSpace(spaceid3 + 1, 10, id4));
            ScrollView scrollView = new ScrollView(this);
            RelativeLayout.LayoutParams svlp = new RelativeLayout.LayoutParams(-2, -2);
            svlp.addRule(14);
            svlp.addRule(15);
            scrollView.setLayoutParams(svlp);
            scrollView.setVerticalScrollBarEnabled(false);
            scrollView.setHorizontalScrollBarEnabled(false);
            scrollView.addView(relativeLayout2);
            relativeLayout.addView(scrollView);
            setContentView(relativeLayout, new RelativeLayout.LayoutParams(-1, -1));
            int b = alsi.size();
            int d = 0;
            for (int a = 0; a < b; a++) {
                int c = alsi.get(a).intValue();
                if (d < c) {
                    d = c;
                }
            }
            int i2 = 20 * 2;
            int wdth = (d / 4) + d + 40;
            if (wdth > this.measuredWidth - (20 * 2)) {
                wdth = this.measuredWidth - (20 * 2);
            }
            relativeLayout2.getLayoutParams().width = wdth;
            int b2 = alirb.size();
            int c2 = wdth - (20 * 2);
            for (int a2 = 0; a2 < b2; a2++) {
                if (rb != null && alirb.get(a2).intValue() > c2) {
                    rb[a2].setFocusableInTouchMode(true);
                }
            }
        } catch (JSONException e) {
            jprintf("setupDenomUI,JSONException: " + e.toString());
        }
    }

    /* JADX INFO: Access modifiers changed from: private */
    public void setupTopUpVoucherUI() {
        int id;
        RelativeLayout relativeLayout = new RelativeLayout(this);
        RelativeLayout relativeLayout2 = new RelativeLayout(this);
        relativeLayout2.setPadding(20, 20, 20, 20);
        RelativeLayout.LayoutParams rllp = new RelativeLayout.LayoutParams(-1, -2);
        rllp.addRule(13);
        relativeLayout2.setLayoutParams(rllp);
        GradientDrawable rlshape = new GradientDrawable();
        rlshape.setCornerRadius(8.0f);
        rlshape.setColor(-2105377);
        setBkgndCompat(relativeLayout2, rlshape);
        ArrayList<Integer> alsi = new ArrayList<>();
        if (1 != 0) {
            ImageView ivlogo = new ImageView(this);
            id = 0 + 1;
            ivlogo.setId(id);
            RelativeLayout.LayoutParams ivlogolp = new RelativeLayout.LayoutParams(-2, -2);
            ivlogolp.addRule(6);
            ivlogolp.addRule(14);
            ivlogo.setLayoutParams(ivlogolp);
            Bitmap mlbmp = getRoundedCornerBitmap(this.mCore.getBitmapInternal(this.mCore.alsLogos.get(this.mCore.mAlsActiveIdx)), -1);
            if (mlbmp != null) {
                ivlogo.setImageBitmap(mlbmp);
                alsi.add(Integer.valueOf(mlbmp.getWidth()));
            }
            relativeLayout2.addView(ivlogo);
        } else {
            TextView tvlogo = new TextView(this);
            id = 0 + 1;
            tvlogo.setId(id);
            RelativeLayout.LayoutParams tvlogolp = new RelativeLayout.LayoutParams(-2, -2);
            tvlogolp.addRule(6);
            tvlogolp.addRule(14);
            tvlogo.setLayoutParams(tvlogolp);
            String scap = this.mCore.alsBtnAction.get(this.mCore.mAlsActiveIdx).toUpperCase().replace('_', ' ');
            tvlogo.setText(scap);
            tvlogo.setTypeface(Typeface.DEFAULT_BOLD);
            tvlogo.setTextColor(-9599820);
            relativeLayout2.addView(tvlogo);
            alsi.add(Integer.valueOf((int) tvlogo.getPaint().measureText(scap)));
        }
        int spaceid = 1000 + 1;
        relativeLayout2.addView(inBetweenHorizontalSpace(spaceid, 20, id));
        int id2 = id + 1;
        relativeLayout2.addView(lineSeparator(id2, spaceid));
        int spaceid2 = spaceid + 1;
        relativeLayout2.addView(inBetweenHorizontalSpace(spaceid2, 30, id2));
        TextView tv = new TextView(this);
        int id3 = id2 + 1;
        tv.setId(id3);
        RelativeLayout.LayoutParams tvlp = new RelativeLayout.LayoutParams(-2, -2);
        tvlp.addRule(3, spaceid2);
        tv.setLayoutParams(tvlp);
        tv.setText("Voucher:");
        tv.setTextColor(-9599820);
        relativeLayout2.addView(tv);
        int spaceid3 = spaceid2 + 1;
        relativeLayout2.addView(inBetweenHorizontalSpace(spaceid3, 5, id3));
        alsi.add(Integer.valueOf((int) tv.getPaint().measureText("Voucher:")));
        LinearLayout linearLayout = new LinearLayout(this);
        int id4 = id3 + 1;
        linearLayout.setId(id4);
        RelativeLayout.LayoutParams elllp = new RelativeLayout.LayoutParams(-1, -2);
        elllp.addRule(3, spaceid3);
        elllp.addRule(14);
        linearLayout.setLayoutParams(elllp);
        final EditText et = new EditText(this);
        LinearLayout.LayoutParams etlp = new LinearLayout.LayoutParams(0, -2);
        etlp.setMargins(0, 0, 10, 0);
        etlp.weight = 1.0f;
        et.setLayoutParams(etlp);
        GradientDrawable etshape = new GradientDrawable();
        etshape.setCornerRadius(8.0f);
        etshape.setColor(-2105377);
        etshape.setStroke(2, -9599820);
        setBkgndCompat(et, etshape);
        et.setMinLines(1);
        et.setMaxLines(3);
        et.setFilters(new InputFilter[]{this.voucherfilter});
        et.setInputType(3);
        et.setTextColor(-9599820);
        alsi.add(Integer.valueOf((int) et.getPaint().measureText("12345678901234567890")));
        linearLayout.addView(et);
        final ImageView ivvalid = new ImageView(this);
        LinearLayout.LayoutParams ivvalidlp = new LinearLayout.LayoutParams(0, -2);
        ivvalidlp.weight = 0.1f;
        ivvalidlp.gravity = 17;
        ivvalid.setLayoutParams(ivvalidlp);
        ivvalid.setImageResource(R.drawable.presence_offline);
        linearLayout.addView(ivvalid);
        relativeLayout2.addView(linearLayout);
        int spaceid4 = spaceid3 + 1;
        relativeLayout2.addView(inBetweenHorizontalSpace(spaceid4, 20, id4));
        String sch = null;
        if (MimopayStuff.sChannel.equals("smartfren")) {
            sch = "Beli voucher Smartfren di toko terdekat, gosok pelindung kode dibelakangnya dan ketikkan kode tersebut diatas.";
        } else if (MimopayStuff.sChannel.equals("sevelin")) {
            sch = "Beli voucher Sevelin di 7-eleven terdekat, ketikkan kode voucher tersebut diatas.";
        } else if (MimopayStuff.sChannel.equals("xl_hrn")) {
            sch = "Hanya berlaku untuk Voucher dengan nominal Rp 10.000 & Rp 50.000 (sudah termasuk PPN).";
        }
        if (sch != null) {
            TextView tva = new TextView(this);
            id4++;
            tva.setId(id4);
            RelativeLayout.LayoutParams tvalp = new RelativeLayout.LayoutParams(-2, -2);
            tvalp.addRule(3, spaceid4);
            tva.setLayoutParams(tvalp);
            tva.setText(sch);
            tva.setTextColor(-9599820);
            relativeLayout2.addView(tva);
            spaceid4++;
            relativeLayout2.addView(inBetweenHorizontalSpace(spaceid4, 30, id4));
        }
        final Button btn = new Button(this);
        setButtonShape(btn);
        int id5 = id4 + 1;
        btn.setId(id5);
        RelativeLayout.LayoutParams blp = new RelativeLayout.LayoutParams(-2, -2);
        blp.addRule(3, spaceid4);
        blp.addRule(7, id4);
        btn.setLayoutParams(blp);
        btn.setText("LANJUT");
        btn.setEnabled(false);
        if (Build.VERSION.SDK_INT >= 11) {
            btn.setAlpha(0.5f);
        }
        this.bMaxTopUpNumbers = false;
        btn.setOnClickListener(new View.OnClickListener() { // from class: com.mimopay.MimopayActivity.9
            @Override // android.view.View.OnClickListener
            public void onClick(View v) {
                InputMethodManager imm = (InputMethodManager) MimopayActivity.this.getSystemService("input_method");
                imm.hideSoftInputFromWindow(v.getApplicationWindowToken(), 2);
                MimopayActivity.this.mCore.mHttppostCode = et.getText().toString();
                MimopayActivity.this.mCore.executeBtnAction();
            }
        });
        relativeLayout2.addView(btn);
        relativeLayout2.addView(inBetweenHorizontalSpace(spaceid4 + 1, 10, id5));
        ScrollView scrollView = new ScrollView(this);
        RelativeLayout.LayoutParams svlp = new RelativeLayout.LayoutParams(-2, -2);
        svlp.addRule(14);
        svlp.addRule(15);
        scrollView.setLayoutParams(svlp);
        scrollView.setVerticalScrollBarEnabled(false);
        scrollView.setHorizontalScrollBarEnabled(false);
        scrollView.addView(relativeLayout2);
        relativeLayout.addView(scrollView);
        setContentView(relativeLayout, new RelativeLayout.LayoutParams(-1, -1));
        int b = alsi.size();
        int d = 0;
        for (int a = 0; a < b; a++) {
            int c = alsi.get(a).intValue();
            if (d < c) {
                d = c;
            }
        }
        int i = 20 * 2;
        int wdth = (d / 4) + d + 40;
        if (wdth > this.measuredWidth - (20 * 2)) {
            wdth = this.measuredWidth - (20 * 2);
        }
        relativeLayout2.getLayoutParams().width = wdth;
        TextWatcher fieldValidatorTextWatcher = new TextWatcher() { // from class: com.mimopay.MimopayActivity.10
            @Override // android.text.TextWatcher
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {
            }

            @Override // android.text.TextWatcher
            public void onTextChanged(CharSequence s, int start, int before, int count) {
            }

            @Override // android.text.TextWatcher
            public void afterTextChanged(Editable s) {
                if (s.length() == 16) {
                    MimopayActivity.this.bMaxTopUpNumbers = true;
                    btn.setEnabled(true);
                    if (Build.VERSION.SDK_INT >= 11) {
                        btn.setAlpha(1.0f);
                    }
                    ivvalid.setImageResource(R.drawable.presence_online);
                    return;
                }
                MimopayActivity.this.bMaxTopUpNumbers = false;
                btn.setEnabled(false);
                if (Build.VERSION.SDK_INT >= 11) {
                    btn.setAlpha(0.5f);
                }
                ivvalid.setImageResource(R.drawable.presence_offline);
            }
        };
        et.addTextChangedListener(fieldValidatorTextWatcher);
    }

    /* JADX INFO: Access modifiers changed from: private */
    public void setupAirtimeDenomUI() throws JSONException {
        int id;
        RelativeLayout relativeLayout = new RelativeLayout(this);
        RelativeLayout relativeLayout2 = new RelativeLayout(this);
        relativeLayout2.setPadding(20, 20, 20, 20);
        RelativeLayout.LayoutParams rllp = new RelativeLayout.LayoutParams(-1, -2);
        rllp.addRule(13);
        relativeLayout2.setLayoutParams(rllp);
        GradientDrawable rlshape = new GradientDrawable();
        rlshape.setCornerRadius(8.0f);
        rlshape.setColor(-2105377);
        setBkgndCompat(relativeLayout2, rlshape);
        ArrayList<Integer> alsi = new ArrayList<>();
        if (1 != 0) {
            ImageView ivlogo = new ImageView(this);
            id = 0 + 1;
            ivlogo.setId(id);
            RelativeLayout.LayoutParams ivlogolp = new RelativeLayout.LayoutParams(-2, -2);
            ivlogolp.addRule(6);
            ivlogolp.addRule(14);
            ivlogo.setLayoutParams(ivlogolp);
            Bitmap mlbmp = getRoundedCornerBitmap(this.mCore.getBitmapInternal(this.mCore.alsLogos.get(this.mCore.mAlsActiveIdx)), -1);
            if (mlbmp != null) {
                ivlogo.setImageBitmap(mlbmp);
                alsi.add(Integer.valueOf(mlbmp.getWidth()));
            }
            relativeLayout2.addView(ivlogo);
        } else {
            TextView tvlogo = new TextView(this);
            id = 0 + 1;
            tvlogo.setId(id);
            RelativeLayout.LayoutParams tvlogolp = new RelativeLayout.LayoutParams(-2, -2);
            tvlogolp.addRule(6);
            tvlogolp.addRule(14);
            tvlogo.setLayoutParams(tvlogolp);
            String captvlogo = this.mCore.alsBtnAction.get(this.mCore.mAlsActiveIdx).toUpperCase().replace('_', ' ');
            tvlogo.setText(captvlogo);
            tvlogo.setTypeface(Typeface.DEFAULT_BOLD);
            tvlogo.setTextColor(-9599820);
            relativeLayout2.addView(tvlogo);
            alsi.add(Integer.valueOf((int) tvlogo.getPaint().measureText(captvlogo)));
        }
        int spaceid = 1000 + 1;
        relativeLayout2.addView(inBetweenHorizontalSpace(spaceid, 20, id));
        int id2 = id + 1;
        relativeLayout2.addView(lineSeparator(id2, spaceid));
        int spaceid2 = spaceid + 1;
        relativeLayout2.addView(inBetweenHorizontalSpace(spaceid2, 20, id2));
        final Button btn = new Button(this);
        this.mCore.mHttppostCode = null;
        RadioGroup rg = new RadioGroup(this);
        int id3 = id2 + 1;
        rg.setId(id3);
        rg.setOnCheckedChangeListener(new RadioGroup.OnCheckedChangeListener() { // from class: com.mimopay.MimopayActivity.11
            @Override // android.widget.RadioGroup.OnCheckedChangeListener
            public void onCheckedChanged(RadioGroup rg2, int cid) {
                String s = MimopayActivity.this.mCore.alsDenomValue.get(MimopayActivity.this.mCore.mAlsActiveIdx);
                int did = cid - 100;
                try {
                    JSONArray jarr = new JSONArray(s);
                    MimopayActivity.this.mCore.mHttppostCode = jarr.getString(did);
                } catch (JSONException e) {
                }
                MimopayActivity.this.jprintf("cid: " + Integer.toString(cid) + " mCore.mHttppostCode: " + MimopayActivity.this.mCore.mHttppostCode + " mCore.mAlsActiveIdx: " + Integer.toString(MimopayActivity.this.mCore.mAlsActiveIdx));
                btn.setEnabled(true);
                if (Build.VERSION.SDK_INT >= 11) {
                    btn.setAlpha(1.0f);
                }
            }
        });
        RelativeLayout.LayoutParams rglp = new RelativeLayout.LayoutParams(-2, -2);
        rglp.addRule(3, spaceid2);
        rg.setOrientation(1);
        rg.setLayoutParams(rglp);
        ArrayList<Integer> alirb = new ArrayList<>();
        try {
            String s = this.mCore.alsDenomContent.get(this.mCore.mAlsActiveIdx);
            JSONArray jarr = new JSONArray(s);
            int j = jarr.length();
            RadioButton[] rb = new RadioButton[j];
            int k = 0;
            for (int i = 0; i < j; i++) {
                rb[k] = new RadioButton(this);
                String ss = jarr.getString(i);
                jprintf("jarr: " + ss + " i: " + Integer.toString(i));
                setButtonShape(rb[k]);
                rb[k].setText(ss);
                rb[k].setTextColor(-9599820);
                rb[k].setTypeface(Typeface.DEFAULT);
                float ftxtsz = rb[k].getTextSize();
                rb[k].setGravity(3);
                rb[k].setId(i + 100);
                int h = (int) (2.0f * ftxtsz);
                RelativeLayout.LayoutParams rblp = new RelativeLayout.LayoutParams(-2, h);
                rb[k].setLayoutParams(rblp);
                rb[k].setEllipsize(TextUtils.TruncateAt.MARQUEE);
                rb[k].setMarqueeRepeatLimit(1);
                rb[k].setHorizontallyScrolling(true);
                rb[k].setSingleLine();
                int isz = (int) rb[k].getPaint().measureText(ss);
                alsi.add(Integer.valueOf(isz));
                alirb.add(Integer.valueOf(isz));
                rg.addView(rb[k]);
                k++;
            }
            relativeLayout2.addView(rg);
            int spaceid3 = spaceid2 + 1;
            relativeLayout2.addView(inBetweenHorizontalSpace(spaceid3, 10, id3));
            setButtonShape(btn);
            int id4 = id3 + 1;
            btn.setId(id4);
            RelativeLayout.LayoutParams blp = new RelativeLayout.LayoutParams(-2, -2);
            blp.addRule(3, spaceid3);
            blp.addRule(7, spaceid3);
            btn.setLayoutParams(blp);
            btn.setText("Next");
            btn.setEnabled(false);
            if (Build.VERSION.SDK_INT >= 11) {
                btn.setAlpha(0.5f);
            }
            btn.setOnClickListener(new View.OnClickListener() { // from class: com.mimopay.MimopayActivity.12
                @Override // android.view.View.OnClickListener
                public void onClick(View v) {
                    if (MimopayActivity.this.mCore.mHttppostCode != null && !MimopayActivity.this.mCore.mHttppostCode.equals("")) {
                        String s2 = MimopayActivity.this.getMyPhoneNumber();
                        if (s2 == null) {
                            MimopayActivity.this.mbCannotSMS = true;
                        }
                        MimopayActivity.this.setupUserPhoneNumberUI();
                    }
                }
            });
            relativeLayout2.addView(btn);
            relativeLayout2.addView(inBetweenHorizontalSpace(spaceid3 + 1, 10, id4));
            ScrollView scrollView = new ScrollView(this);
            RelativeLayout.LayoutParams svlp = new RelativeLayout.LayoutParams(-2, -2);
            svlp.addRule(14);
            svlp.addRule(15);
            scrollView.setLayoutParams(svlp);
            scrollView.setVerticalScrollBarEnabled(false);
            scrollView.setHorizontalScrollBarEnabled(false);
            scrollView.addView(relativeLayout2);
            relativeLayout.addView(scrollView);
            setContentView(relativeLayout, new RelativeLayout.LayoutParams(-1, -1));
            int b = alsi.size();
            int d = 0;
            for (int a = 0; a < b; a++) {
                int c = alsi.get(a).intValue();
                if (d < c) {
                    d = c;
                }
            }
            int i2 = 20 * 2;
            int wdth = (d / 4) + d + 40;
            if (wdth > this.measuredWidth - (20 * 2)) {
                wdth = this.measuredWidth - (20 * 2);
            }
            relativeLayout2.getLayoutParams().width = wdth;
            int b2 = alirb.size();
            int c2 = wdth - (20 * 2);
            for (int a2 = 0; a2 < b2; a2++) {
                if (rb != null && alirb.get(a2).intValue() > c2) {
                    rb[a2].setFocusableInTouchMode(true);
                }
            }
        } catch (JSONException e) {
            jprintf("setupDenomUI,JSONException: " + e.toString());
        }
    }

    private TextView lineSeparator(int id, int below) {
        TextView lineseptv = new TextView(this, null, R.attr.listSeparatorTextViewStyle);
        lineseptv.setId(id);
        RelativeLayout.LayoutParams lineseptvlp = new RelativeLayout.LayoutParams(-1, 2);
        lineseptvlp.addRule(3, below);
        lineseptv.setLayoutParams(lineseptvlp);
        lineseptv.setBackgroundColor(-16737844);
        return lineseptv;
    }

    private RelativeLayout inBetweenHorizontalSpace(int id, int height, int below) {
        RelativeLayout sep = new RelativeLayout(this);
        sep.setId(id);
        RelativeLayout.LayoutParams seplp = new RelativeLayout.LayoutParams(-1, height);
        seplp.addRule(3, below);
        sep.setLayoutParams(seplp);
        return sep;
    }

    /* JADX INFO: Access modifiers changed from: private */
    public void setupUserPhoneNumberUI() {
        int id;
        Bitmap mlbmp;
        RelativeLayout relativeLayout = new RelativeLayout(this);
        RelativeLayout relativeLayout2 = new RelativeLayout(this);
        relativeLayout2.setPadding(20, 20, 20, 20);
        RelativeLayout.LayoutParams rllp = new RelativeLayout.LayoutParams(-1, -2);
        rllp.addRule(13);
        relativeLayout2.setLayoutParams(rllp);
        GradientDrawable rlshape = new GradientDrawable();
        rlshape.setCornerRadius(8.0f);
        rlshape.setColor(-2105377);
        setBkgndCompat(relativeLayout2, rlshape);
        if (1 != 0) {
            ImageView ivlogo = new ImageView(this);
            id = 0 + 1;
            ivlogo.setId(id);
            RelativeLayout.LayoutParams ivlogolp = new RelativeLayout.LayoutParams(-2, -2);
            ivlogolp.addRule(6);
            ivlogolp.addRule(14);
            ivlogo.setLayoutParams(ivlogolp);
            if (this.mCore.mAlsActiveIdx >= 0 && (mlbmp = getRoundedCornerBitmap(this.mCore.getBitmapInternal(this.mCore.alsLogos.get(this.mCore.mAlsActiveIdx)), -1)) != null) {
                ivlogo.setImageBitmap(mlbmp);
            }
            relativeLayout2.addView(ivlogo);
        } else {
            TextView tvlogo = new TextView(this);
            id = 0 + 1;
            tvlogo.setId(id);
            RelativeLayout.LayoutParams tvlogolp = new RelativeLayout.LayoutParams(-2, -2);
            tvlogolp.addRule(6);
            tvlogolp.addRule(14);
            tvlogo.setLayoutParams(tvlogolp);
            tvlogo.setText(this.mCore.alsBtnAction.get(this.mCore.mAlsActiveIdx).toUpperCase().replace('_', ' '));
            tvlogo.setTypeface(Typeface.DEFAULT_BOLD);
            tvlogo.setTextColor(-9599820);
            relativeLayout2.addView(tvlogo);
        }
        int spaceid = 1000 + 1;
        relativeLayout2.addView(inBetweenHorizontalSpace(spaceid, 30, id));
        int id2 = id + 1;
        relativeLayout2.addView(lineSeparator(id2, spaceid));
        int spaceid2 = spaceid + 1;
        relativeLayout2.addView(inBetweenHorizontalSpace(spaceid2, 20, id2));
        TextView tv = new TextView(this);
        int id3 = id2 + 1;
        tv.setId(id3);
        RelativeLayout.LayoutParams tvlp = new RelativeLayout.LayoutParams(-2, -2);
        tvlp.addRule(3, spaceid2);
        tv.setLayoutParams(tvlp);
        tv.setText("Nomor telpon anda tidak berhasil dibaca. Anda harus mengetikkan secara manual.\n\nNomor Telpon:");
        tv.setTextColor(-9599820);
        relativeLayout2.addView(tv);
        int spaceid3 = spaceid2 + 1;
        relativeLayout2.addView(inBetweenHorizontalSpace(spaceid3, 10, id3));
        LinearLayout linearLayout = new LinearLayout(this);
        int id4 = id3 + 1;
        linearLayout.setId(id4);
        RelativeLayout.LayoutParams elllp = new RelativeLayout.LayoutParams(-1, -2);
        elllp.addRule(3, spaceid3);
        elllp.addRule(14);
        linearLayout.setLayoutParams(elllp);
        final EditText et = new EditText(this);
        LinearLayout.LayoutParams etlp = new LinearLayout.LayoutParams(0, -2);
        etlp.setMargins(0, 0, 10, 0);
        etlp.weight = 1.0f;
        et.setLayoutParams(etlp);
        GradientDrawable etshape = new GradientDrawable();
        etshape.setCornerRadius(8.0f);
        etshape.setColor(-2105377);
        etshape.setStroke(2, -9599820);
        setBkgndCompat(et, etshape);
        et.setMinLines(1);
        et.setMaxLines(3);
        et.setInputType(3);
        et.setTextColor(-9599820);
        et.setLongClickable(true);
        linearLayout.addView(et);
        int widthref = (int) et.getPaint().measureText("123456789012345678901234567890");
        final ImageView ivvalid = new ImageView(this);
        LinearLayout.LayoutParams ivvalidlp = new LinearLayout.LayoutParams(0, -2);
        ivvalidlp.weight = 0.1f;
        ivvalidlp.gravity = 17;
        ivvalid.setLayoutParams(ivvalidlp);
        ivvalid.setImageResource(R.drawable.presence_offline);
        linearLayout.addView(ivvalid);
        relativeLayout2.addView(linearLayout);
        int spaceid4 = spaceid3 + 1;
        relativeLayout2.addView(inBetweenHorizontalSpace(spaceid4, 15, id4));
        String sdisclaim = "";
        if (this.mbCannotSMS) {
            sdisclaim = "Perangkat anda hanya mendukung Wifi-only. Oleh karena itu, setelah kode UPoint didapat, anda harus mengirimkan dengan SMS menggunakan perangkat lain";
        } else if (MimopayStuff.sChannel.equals("upoint")) {
            sdisclaim = "Centang ini jika anda ingin transaksi ini lanjut secara otomatis mengirimkan SMS. Pastikan nomor yg anda ketik adalah nomor yg aktif diperangkat ini dan nomor tersebut adalah  nomor Telkomsel/Flexi number.";
        } else if (MimopayStuff.sChannel.equals("xl_airtime")) {
            sdisclaim = "Centang ini jika anda ingin SMS yg akan diterima dari XL akan secara otomatis dibaca dan lanjut untuk verifikasi kode. Pastikan nomor yg anda ketik adalah nomor yg aktif diperangkat ini dan nomor tersebut adalah  nomor Telkomsel/Flexi number.";
        }
        final CheckBox cbdisclaim = new CheckBox(this);
        int id5 = id4 + 1;
        cbdisclaim.setId(id5);
        setButtonShape(cbdisclaim);
        RelativeLayout.LayoutParams cbdisclaimlp = new RelativeLayout.LayoutParams(-2, -2);
        cbdisclaimlp.addRule(3, spaceid4);
        cbdisclaim.setLayoutParams(cbdisclaimlp);
        cbdisclaim.setText(sdisclaim);
        cbdisclaim.setTextAppearance(this, R.style.TextAppearance.Small);
        cbdisclaim.setTextColor(-9599820);
        cbdisclaim.setGravity(48);
        if (this.mbCannotSMS) {
            cbdisclaim.setVisibility(8);
        } else {
            cbdisclaim.setChecked(true);
        }
        relativeLayout2.addView(cbdisclaim);
        int spaceid5 = spaceid4 + 1;
        relativeLayout2.addView(inBetweenHorizontalSpace(spaceid5, 30, id5));
        final Button btn = new Button(this);
        setButtonShape(btn);
        int id6 = id5 + 1;
        btn.setId(id6);
        RelativeLayout.LayoutParams btnlp = new RelativeLayout.LayoutParams(-2, -2);
        btnlp.addRule(3, spaceid5);
        btnlp.addRule(7, spaceid5 - 1);
        btn.setLayoutParams(btnlp);
        btn.setText("LANJUT");
        btn.setEnabled(false);
        if (Build.VERSION.SDK_INT >= 11) {
            btn.setAlpha(0.5f);
        }
        btn.setOnClickListener(new View.OnClickListener() { // from class: com.mimopay.MimopayActivity.13
            @Override // android.view.View.OnClickListener
            public void onClick(View v) {
                InputMethodManager imm = (InputMethodManager) MimopayActivity.this.getSystemService("input_method");
                imm.hideSoftInputFromWindow(v.getApplicationWindowToken(), 2);
                MimopayActivity.this.mbCannotSMS = !cbdisclaim.isChecked();
                MimopayActivity.this.mCore.mHttppostPhoneNumber = et.getText().toString();
                MimopayActivity.this.jprintf("mHttppostPhoneNumber: " + MimopayActivity.this.mCore.mHttppostPhoneNumber);
                if (!MimopayActivity.this.mbCannotSMS && MimopayStuff.sChannel.equals("xl_airtime")) {
                    MimopayActivity.this.mCore.waitSMS(60);
                }
                MimopayActivity.this.mCore.executeBtnAction();
            }
        });
        relativeLayout2.addView(btn);
        relativeLayout2.addView(inBetweenHorizontalSpace(spaceid5 + 1, 10, id6));
        ScrollView scrollView = new ScrollView(this);
        RelativeLayout.LayoutParams svlp = new RelativeLayout.LayoutParams(-2, -2);
        svlp.addRule(14);
        svlp.addRule(15);
        scrollView.setLayoutParams(svlp);
        scrollView.setVerticalScrollBarEnabled(false);
        scrollView.setHorizontalScrollBarEnabled(false);
        scrollView.addView(relativeLayout2);
        relativeLayout.addView(scrollView);
        setContentView(relativeLayout, new RelativeLayout.LayoutParams(-1, -1));
        if (widthref > this.measuredWidth) {
            widthref = this.measuredWidth;
        }
        relativeLayout2.getLayoutParams().width = widthref;
        TextWatcher fieldValidatorTextWatcher = new TextWatcher() { // from class: com.mimopay.MimopayActivity.14
            @Override // android.text.TextWatcher
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {
            }

            @Override // android.text.TextWatcher
            public void onTextChanged(CharSequence s, int start, int before, int count) {
            }

            @Override // android.text.TextWatcher
            public void afterTextChanged(Editable s) {
                if (s.length() >= 9) {
                    btn.setEnabled(true);
                    if (Build.VERSION.SDK_INT >= 11) {
                        btn.setAlpha(1.0f);
                    }
                    ivvalid.setImageResource(R.drawable.presence_online);
                    return;
                }
                btn.setEnabled(false);
                if (Build.VERSION.SDK_INT >= 11) {
                    btn.setAlpha(0.5f);
                }
                ivvalid.setImageResource(R.drawable.presence_offline);
            }
        };
        et.addTextChangedListener(fieldValidatorTextWatcher);
    }

    /* JADX INFO: Access modifiers changed from: private */
    public void setupAtmChoosenUI() {
        int id;
        RelativeLayout relativeLayout = new RelativeLayout(this);
        RelativeLayout relativeLayout2 = new RelativeLayout(this);
        relativeLayout2.setPadding(20, 20, 20, 20);
        RelativeLayout.LayoutParams rllp = new RelativeLayout.LayoutParams(-1, -2);
        rllp.addRule(13);
        relativeLayout2.setLayoutParams(rllp);
        GradientDrawable rlshape = new GradientDrawable();
        rlshape.setCornerRadius(8.0f);
        rlshape.setColor(-2105377);
        setBkgndCompat(relativeLayout2, rlshape);
        ArrayList<Integer> alsi = new ArrayList<>();
        if (1 != 0) {
            ImageView ivlogo = new ImageView(this);
            id = 0 + 1;
            ivlogo.setId(id);
            RelativeLayout.LayoutParams ivlogolp = new RelativeLayout.LayoutParams(-2, -2);
            ivlogolp.addRule(6);
            ivlogolp.addRule(14);
            ivlogo.setLayoutParams(ivlogolp);
            Bitmap mlbmp = getRoundedCornerBitmap(this.mCore.getBitmapInternal(this.mCore.alsLogos.get(this.mCore.mAlsActiveIdx)), -1);
            if (mlbmp != null) {
                ivlogo.setImageBitmap(mlbmp);
                alsi.add(Integer.valueOf(mlbmp.getWidth()));
            }
            relativeLayout2.addView(ivlogo);
        } else {
            TextView tvlogo = new TextView(this);
            id = 0 + 1;
            tvlogo.setId(id);
            RelativeLayout.LayoutParams tvlogolp = new RelativeLayout.LayoutParams(-2, -2);
            tvlogolp.addRule(6);
            tvlogolp.addRule(14);
            tvlogo.setLayoutParams(tvlogolp);
            String scap = this.mCore.alsBtnAction.get(this.mCore.mAlsActiveIdx).toUpperCase().replace('_', ' ');
            tvlogo.setText(scap);
            tvlogo.setTypeface(Typeface.DEFAULT_BOLD);
            tvlogo.setTextColor(-9599820);
            relativeLayout2.addView(tvlogo);
            alsi.add(Integer.valueOf((int) tvlogo.getPaint().measureText(scap)));
        }
        int spaceid = 1000 + 1;
        relativeLayout2.addView(inBetweenHorizontalSpace(spaceid, 20, id));
        int id2 = id + 1;
        relativeLayout2.addView(lineSeparator(id2, spaceid));
        int spaceid2 = spaceid + 1;
        relativeLayout2.addView(inBetweenHorizontalSpace(spaceid2, 20, id2));
        TextView tv = new TextView(this);
        int id3 = id2 + 1;
        tv.setId(id3);
        RelativeLayout.LayoutParams tvlp = new RelativeLayout.LayoutParams(-2, -2);
        tvlp.addRule(3, spaceid2);
        tv.setLayoutParams(tvlp);
        String z = this.mCore.alsDenomContent.get(this.mCore.mAlsActiveIdx);
        tv.setText(z);
        String[] lines = z.split("\\r?\\n");
        tv.setTextColor(-9599820);
        relativeLayout2.addView(tv);
        int spaceid3 = spaceid2 + 1;
        relativeLayout2.addView(inBetweenHorizontalSpace(spaceid3, 20, id3));
        for (String str : lines) {
            alsi.add(Integer.valueOf((int) tv.getPaint().measureText(str)));
        }
        Button btn = new Button(this);
        setButtonShape(btn);
        RelativeLayout.LayoutParams btnlp = new RelativeLayout.LayoutParams(-2, -2);
        btnlp.addRule(3, spaceid3);
        btnlp.addRule(14);
        btn.setLayoutParams(btnlp);
        btn.setText("   LANJUT   ");
        btn.setOnClickListener(new View.OnClickListener() { // from class: com.mimopay.MimopayActivity.15
            @Override // android.view.View.OnClickListener
            public void onClick(View v) {
                MimopayActivity.this.mCore.mHttppostCode = MimopayActivity.this.mCore.alsDenomValue.get(MimopayActivity.this.mCore.mAlsActiveIdx);
                MimopayActivity.this.mCore.executeBtnAction();
            }
        });
        relativeLayout2.addView(btn);
        ScrollView scrollView = new ScrollView(this);
        RelativeLayout.LayoutParams svlp = new RelativeLayout.LayoutParams(-2, -2);
        svlp.addRule(14);
        svlp.addRule(15);
        scrollView.setLayoutParams(svlp);
        scrollView.setVerticalScrollBarEnabled(false);
        scrollView.setHorizontalScrollBarEnabled(false);
        scrollView.addView(relativeLayout2);
        relativeLayout.addView(scrollView);
        setContentView(relativeLayout, new RelativeLayout.LayoutParams(-1, -1));
        int b = alsi.size();
        int d = 0;
        for (int a = 0; a < b; a++) {
            int c = alsi.get(a).intValue();
            if (d < c) {
                d = c;
            }
        }
        int i = 20 * 2;
        int wdth = (d / 8) + d + 40;
        if (wdth > this.measuredWidth - (20 * 2)) {
            wdth = this.measuredWidth - (20 * 2);
        }
        relativeLayout2.getLayoutParams().width = wdth;
    }

    /* JADX INFO: Access modifiers changed from: private */
    public void setupDenomAtmResultUI(final String companyCode, final String totalBill, final String transId) {
        int id;
        RelativeLayout relativeLayout = new RelativeLayout(this);
        RelativeLayout relativeLayout2 = new RelativeLayout(this);
        relativeLayout2.setPadding(20, 20, 20, 20);
        RelativeLayout.LayoutParams rllp = new RelativeLayout.LayoutParams(-1, -2);
        rllp.addRule(13);
        relativeLayout2.setLayoutParams(rllp);
        GradientDrawable rlshape = new GradientDrawable();
        rlshape.setCornerRadius(8.0f);
        rlshape.setColor(-2105377);
        setBkgndCompat(relativeLayout2, rlshape);
        ArrayList<Integer> alsi = new ArrayList<>();
        if (1 != 0) {
            ImageView ivlogo = new ImageView(this);
            id = 0 + 1;
            ivlogo.setId(id);
            RelativeLayout.LayoutParams ivlogolp = new RelativeLayout.LayoutParams(-2, -2);
            ivlogolp.addRule(6);
            ivlogolp.addRule(14);
            ivlogo.setLayoutParams(ivlogolp);
            Bitmap mlbmp = getRoundedCornerBitmap(this.mCore.getBitmapInternal(this.mCore.alsLogos.get(this.mCore.mAlsActiveIdx)), -1);
            if (mlbmp != null) {
                ivlogo.setImageBitmap(mlbmp);
                alsi.add(Integer.valueOf(mlbmp.getWidth()));
            }
            relativeLayout2.addView(ivlogo);
        } else {
            TextView tvlogo = new TextView(this);
            id = 0 + 1;
            tvlogo.setId(id);
            RelativeLayout.LayoutParams tvlogolp = new RelativeLayout.LayoutParams(-2, -2);
            tvlogolp.addRule(6);
            tvlogolp.addRule(14);
            tvlogo.setLayoutParams(tvlogolp);
            String scap = this.mCore.alsBtnAction.get(this.mCore.mAlsActiveIdx).toUpperCase().replace('_', ' ');
            tvlogo.setText(scap);
            tvlogo.setTypeface(Typeface.DEFAULT_BOLD);
            tvlogo.setTextColor(-9599820);
            relativeLayout2.addView(tvlogo);
            alsi.add(Integer.valueOf((int) tvlogo.getPaint().measureText(scap)));
        }
        int spaceid = 1000 + 1;
        relativeLayout2.addView(inBetweenHorizontalSpace(spaceid, 20, id));
        int id2 = id + 1;
        relativeLayout2.addView(lineSeparator(id2, spaceid));
        int spaceid2 = spaceid + 1;
        relativeLayout2.addView(inBetweenHorizontalSpace(spaceid2, 20, id2));
        TextView tv = new TextView(this);
        int id3 = id2 + 1;
        tv.setId(id3);
        RelativeLayout.LayoutParams tvlp = new RelativeLayout.LayoutParams(-2, -2);
        tvlp.addRule(3, spaceid2);
        tv.setLayoutParams(tvlp);
        tv.setText(companyCode + "\n" + totalBill + "\n" + transId);
        tv.setTextColor(-9599820);
        relativeLayout2.addView(tv);
        int spaceid3 = spaceid2 + 1;
        relativeLayout2.addView(inBetweenHorizontalSpace(spaceid3, 20, id3));
        alsi.add(Integer.valueOf((int) tv.getPaint().measureText(companyCode)));
        alsi.add(Integer.valueOf((int) tv.getPaint().measureText(totalBill)));
        alsi.add(Integer.valueOf((int) tv.getPaint().measureText(transId)));
        Button btn = new Button(this);
        setButtonShape(btn);
        RelativeLayout.LayoutParams btnlp = new RelativeLayout.LayoutParams(-2, -2);
        btnlp.addRule(3, spaceid3);
        btnlp.addRule(14);
        btn.setLayoutParams(btnlp);
        btn.setText("   SELESAI   ");
        btn.setOnClickListener(new View.OnClickListener() { // from class: com.mimopay.MimopayActivity.16
            @Override // android.view.View.OnClickListener
            public void onClick(View v) {
                MimopayActivity.this.mInfoResult = "Success";
                MimopayActivity.this.mAlsResult = new ArrayList();
                MimopayActivity.this.mAlsResult.add(MimopayActivity.this.mCore.alsBtnAction.get(MimopayActivity.this.mCore.mAlsActiveIdx));
                MimopayActivity.this.mAlsResult.add(companyCode);
                MimopayActivity.this.mAlsResult.add(totalBill);
                MimopayActivity.this.mAlsResult.add(transId);
                MimopayActivity.this.finish();
            }
        });
        relativeLayout2.addView(btn);
        ScrollView scrollView = new ScrollView(this);
        RelativeLayout.LayoutParams svlp = new RelativeLayout.LayoutParams(-2, -2);
        svlp.addRule(14);
        svlp.addRule(15);
        scrollView.setLayoutParams(svlp);
        scrollView.setVerticalScrollBarEnabled(false);
        scrollView.setHorizontalScrollBarEnabled(false);
        scrollView.addView(relativeLayout2);
        relativeLayout.addView(scrollView);
        setContentView(relativeLayout, new RelativeLayout.LayoutParams(-1, -1));
        int b = alsi.size();
        int d = 0;
        for (int a = 0; a < b; a++) {
            int c = alsi.get(a).intValue();
            if (d < c) {
                d = c;
            }
        }
        int i = 20 * 2;
        int wdth = (d / 4) + d + 40;
        if (wdth > this.measuredWidth - (20 * 2)) {
            wdth = this.measuredWidth - (20 * 2);
        }
        relativeLayout2.getLayoutParams().width = wdth;
    }

    private void setButtonShape(Object obj) {
        StateListDrawable btnsld = new StateListDrawable();
        if (obj instanceof RadioButton) {
            btnsld.addState(new int[]{R.attr.state_checked}, getResources().getDrawable(R.drawable.presence_online));
            btnsld.addState(new int[]{-16842912}, getResources().getDrawable(R.drawable.presence_invisible));
            RadioButton rb = (RadioButton) obj;
            rb.setButtonDrawable(btnsld);
            rb.setPadding(30, -3, 0, 0);
            return;
        }
        if (obj instanceof CheckBox) {
            btnsld.addState(new int[]{R.attr.state_checked}, getResources().getDrawable(R.drawable.checkbox_on_background));
            btnsld.addState(new int[]{-16842912}, getResources().getDrawable(R.drawable.checkbox_off_background));
            CheckBox cb = (CheckBox) obj;
            cb.setButtonDrawable(btnsld);
            cb.setPadding(30, -5, 0, 0);
            return;
        }
        GradientDrawable btnupshape = new GradientDrawable();
        btnupshape.setColor(0);
        btnupshape.setCornerRadius(8.0f);
        btnupshape.setStroke(2, -16737844);
        GradientDrawable btndownshape = new GradientDrawable();
        btndownshape.setColor(-16720385);
        btndownshape.setCornerRadius(8.0f);
        GradientDrawable btnoffshape = new GradientDrawable();
        btnoffshape.setColor(0);
        btnoffshape.setStroke(2, 1069596864);
        btnoffshape.setCornerRadius(8.0f);
        if ((obj instanceof Button) || (obj instanceof ImageButton)) {
            btnsld.addState(new int[]{R.attr.stateNotNeeded}, btndownshape);
            btnsld.addState(new int[]{R.attr.state_pressed, R.attr.state_enabled}, btndownshape);
            btnsld.addState(new int[]{R.attr.state_focused, R.attr.state_enabled}, btnupshape);
            btnsld.addState(new int[]{R.attr.state_enabled}, btnupshape);
            btnsld.addState(new int[]{-16842910}, btnoffshape);
            if (obj instanceof Button) {
                Button b = (Button) obj;
                b.setTextColor(-9599820);
                setBkgndCompat(b, btnsld);
            } else if (obj instanceof ImageButton) {
                View ib = (ImageButton) obj;
                setBkgndCompat(ib, btnsld);
            }
        }
    }

    /* JADX INFO: Access modifiers changed from: private */
    public void setupTopUpResultUI(final String stopupres, final String stransid) {
        int id;
        RelativeLayout relativeLayout = new RelativeLayout(this);
        RelativeLayout relativeLayout2 = new RelativeLayout(this);
        relativeLayout2.setPadding(20, 20, 20, 20);
        RelativeLayout.LayoutParams rllp = new RelativeLayout.LayoutParams(-1, -2);
        rllp.addRule(13);
        relativeLayout2.setLayoutParams(rllp);
        GradientDrawable rlshape = new GradientDrawable();
        rlshape.setCornerRadius(8.0f);
        rlshape.setColor(-2105377);
        setBkgndCompat(relativeLayout2, rlshape);
        ArrayList<Integer> alsi = new ArrayList<>();
        if (1 != 0) {
            ImageView ivlogo = new ImageView(this);
            id = 0 + 1;
            ivlogo.setId(id);
            RelativeLayout.LayoutParams ivlogolp = new RelativeLayout.LayoutParams(-2, -2);
            ivlogolp.addRule(6);
            ivlogolp.addRule(14);
            ivlogo.setLayoutParams(ivlogolp);
            Bitmap mlbmp = getRoundedCornerBitmap(this.mCore.getBitmapInternal(this.mCore.alsLogos.get(this.mCore.mAlsActiveIdx)), -1);
            if (mlbmp != null) {
                ivlogo.setImageBitmap(mlbmp);
                alsi.add(Integer.valueOf(mlbmp.getWidth()));
            }
            relativeLayout2.addView(ivlogo);
        } else {
            TextView tvlogo = new TextView(this);
            id = 0 + 1;
            tvlogo.setId(id);
            RelativeLayout.LayoutParams tvlogolp = new RelativeLayout.LayoutParams(-2, -2);
            tvlogolp.addRule(6);
            tvlogolp.addRule(14);
            tvlogo.setLayoutParams(tvlogolp);
            String scap = this.mCore.alsBtnAction.get(this.mCore.mAlsActiveIdx).toUpperCase().replace('_', ' ');
            tvlogo.setText(scap);
            tvlogo.setTypeface(Typeface.DEFAULT_BOLD);
            tvlogo.setTextColor(-9599820);
            relativeLayout2.addView(tvlogo);
            alsi.add(Integer.valueOf((int) tvlogo.getPaint().measureText(scap)));
        }
        int spaceid = 1000 + 1;
        relativeLayout2.addView(inBetweenHorizontalSpace(spaceid, 20, id));
        int id2 = id + 1;
        relativeLayout2.addView(lineSeparator(id2, spaceid));
        int spaceid2 = spaceid + 1;
        relativeLayout2.addView(inBetweenHorizontalSpace(spaceid2, 30, id2));
        TextView tv = new TextView(this);
        int id3 = id2 + 1;
        tv.setId(id3);
        RelativeLayout.LayoutParams tvlp = new RelativeLayout.LayoutParams(-2, -2);
        tvlp.addRule(3, spaceid2);
        tvlp.addRule(14);
        tv.setLayoutParams(tvlp);
        tv.setText(stopupres);
        tv.setTextColor(-9599820);
        tv.setTypeface(Typeface.DEFAULT_BOLD);
        relativeLayout2.addView(tv);
        int spaceid3 = spaceid2 + 1;
        relativeLayout2.addView(inBetweenHorizontalSpace(spaceid3, 5, id3));
        alsi.add(Integer.valueOf((int) tv.getPaint().measureText(stopupres)));
        TextView tvb = new TextView(this);
        int id4 = id3 + 1;
        tvb.setId(id4);
        RelativeLayout.LayoutParams tvblp = new RelativeLayout.LayoutParams(-2, -2);
        tvblp.addRule(3, spaceid3);
        tvblp.addRule(14);
        tvb.setLayoutParams(tvblp);
        String strans = "ID Transaksi: " + stransid;
        tvb.setText(strans);
        tvb.setTextColor(-9599820);
        relativeLayout2.addView(tvb);
        int spaceid4 = spaceid3 + 1;
        relativeLayout2.addView(inBetweenHorizontalSpace(spaceid4, 30, id4));
        alsi.add(Integer.valueOf((int) tvb.getPaint().measureText(strans)));
        Button btn = new Button(this);
        btn.setId(id4 + 1);
        setButtonShape(btn);
        RelativeLayout.LayoutParams btnlp = new RelativeLayout.LayoutParams(-2, -2);
        btnlp.addRule(3, spaceid4);
        btnlp.addRule(14);
        btn.setLayoutParams(btnlp);
        btn.setText("   SELESAI   ");
        btn.setOnClickListener(new View.OnClickListener() { // from class: com.mimopay.MimopayActivity.17
            @Override // android.view.View.OnClickListener
            public void onClick(View v) {
                MimopayActivity.this.mInfoResult = "Success";
                MimopayActivity.this.mAlsResult = new ArrayList();
                MimopayActivity.this.mAlsResult.add(MimopayActivity.this.mCore.alsBtnAction.get(MimopayActivity.this.mCore.mAlsActiveIdx));
                MimopayActivity.this.mAlsResult.add(stopupres);
                MimopayActivity.this.mAlsResult.add(stransid);
                MimopayActivity.this.finish();
            }
        });
        relativeLayout2.addView(btn);
        ScrollView scrollView = new ScrollView(this);
        RelativeLayout.LayoutParams svlp = new RelativeLayout.LayoutParams(-2, -2);
        svlp.addRule(14);
        svlp.addRule(15);
        scrollView.setLayoutParams(svlp);
        scrollView.setVerticalScrollBarEnabled(false);
        scrollView.setHorizontalScrollBarEnabled(false);
        scrollView.addView(relativeLayout2);
        relativeLayout.addView(scrollView);
        setContentView(relativeLayout, new RelativeLayout.LayoutParams(-1, -1));
        int b = alsi.size();
        int d = 0;
        for (int a = 0; a < b; a++) {
            int c = alsi.get(a).intValue();
            if (d < c) {
                d = c;
            }
        }
        int i = 20 * 2;
        int wdth = (d / 4) + d + 40;
        if (wdth > this.measuredWidth - (20 * 2)) {
            wdth = this.measuredWidth - (20 * 2);
        }
        relativeLayout2.getLayoutParams().width = wdth;
    }

    /* JADX INFO: Access modifiers changed from: private */
    public void setupAirtimeUPointResultUI(final String smscontent, final String smsnumber) {
        int id;
        int widthref;
        Button btnok;
        RelativeLayout relativeLayout = new RelativeLayout(this);
        RelativeLayout relativeLayout2 = new RelativeLayout(this);
        relativeLayout2.setPadding(20, 20, 20, 20);
        RelativeLayout.LayoutParams rllp = new RelativeLayout.LayoutParams(-1, -2);
        rllp.addRule(13);
        relativeLayout2.setLayoutParams(rllp);
        GradientDrawable rlshape = new GradientDrawable();
        rlshape.setCornerRadius(8.0f);
        rlshape.setColor(-2105377);
        setBkgndCompat(relativeLayout2, rlshape);
        if (1 != 0) {
            ImageView ivlogo = new ImageView(this);
            id = 0 + 1;
            ivlogo.setId(id);
            RelativeLayout.LayoutParams ivlogolp = new RelativeLayout.LayoutParams(-2, -2);
            ivlogolp.addRule(6);
            ivlogolp.addRule(14);
            ivlogo.setLayoutParams(ivlogolp);
            Bitmap mlbmp = getRoundedCornerBitmap(this.mCore.getBitmapInternal(this.mCore.alsLogos.get(this.mCore.mAlsActiveIdx)), -1);
            if (mlbmp != null) {
                ivlogo.setImageBitmap(mlbmp);
            }
            relativeLayout2.addView(ivlogo);
        } else {
            TextView tvlogo = new TextView(this);
            id = 0 + 1;
            tvlogo.setId(id);
            RelativeLayout.LayoutParams tvlogolp = new RelativeLayout.LayoutParams(-2, -2);
            tvlogolp.addRule(6);
            tvlogolp.addRule(14);
            tvlogo.setLayoutParams(tvlogolp);
            tvlogo.setText(this.mCore.alsBtnAction.get(this.mCore.mAlsActiveIdx).toUpperCase().replace('_', ' '));
            tvlogo.setTypeface(Typeface.DEFAULT_BOLD);
            tvlogo.setTextColor(-9599820);
            relativeLayout2.addView(tvlogo);
        }
        int spaceid = 1000 + 1;
        relativeLayout2.addView(inBetweenHorizontalSpace(spaceid, 20, id));
        int id2 = id + 1;
        relativeLayout2.addView(lineSeparator(id2, spaceid));
        int spaceid2 = spaceid + 1;
        relativeLayout2.addView(inBetweenHorizontalSpace(spaceid2, 20, id2));
        TextView tv = new TextView(this);
        int id3 = id2 + 1;
        tv.setId(id3);
        RelativeLayout.LayoutParams tvlp = new RelativeLayout.LayoutParams(-2, -2);
        tvlp.addRule(3, spaceid2);
        tv.setLayoutParams(tvlp);
        int a = smscontent.indexOf(" ", 0);
        final String skode = smscontent.substring(a + 1);
        String st = "Kirim SMS berisi up(spasi)" + skode + " ke " + smsnumber + ". Pembelian menggunakan nomor telpon : " + this.mCore.mHttppostPhoneNumber + ".";
        tv.setText(st);
        tv.setTextColor(-9599820);
        tv.setPadding(0, 10, 0, 10);
        relativeLayout2.addView(tv);
        ImageView ivvalid = null;
        EditText et = null;
        if (!this.mbCannotSMS) {
            int spaceid3 = spaceid2 + 1;
            relativeLayout2.addView(inBetweenHorizontalSpace(spaceid3, 10, id3));
            tv.setText(st + "\n\nAgar supaya SMS terkirim secara otomatis, anda harus mengetikkan kode 'up' tersebut diatas.");
            LinearLayout ell = new LinearLayout(this);
            int id4 = id3 + 1;
            ell.setId(id4);
            RelativeLayout.LayoutParams elllp = new RelativeLayout.LayoutParams(-1, -2);
            elllp.addRule(3, spaceid3);
            elllp.addRule(14);
            ell.setLayoutParams(elllp);
            et = new EditText(this);
            LinearLayout.LayoutParams etlp = new LinearLayout.LayoutParams(0, -2);
            etlp.setMargins(0, 0, 10, 0);
            etlp.weight = 1.0f;
            et.setLayoutParams(etlp);
            GradientDrawable etshape = new GradientDrawable();
            etshape.setCornerRadius(8.0f);
            etshape.setColor(-2105377);
            etshape.setStroke(2, -9599820);
            setBkgndCompat(et, etshape);
            et.setMinLines(1);
            et.setMaxLines(3);
            et.setTextColor(-9599820);
            et.setFilters(new InputFilter[]{new InputFilter.LengthFilter(skode.length())});
            et.setInputType(3);
            ell.addView(et);
            widthref = (int) et.getPaint().measureText("123456789012345678901234567890");
            ivvalid = new ImageView(this);
            LinearLayout.LayoutParams ivvalidlp = new LinearLayout.LayoutParams(0, -2);
            ivvalidlp.weight = 0.1f;
            ivvalidlp.gravity = 17;
            ivvalid.setLayoutParams(ivvalidlp);
            ivvalid.setImageResource(R.drawable.presence_offline);
            ell.addView(ivvalid);
            relativeLayout2.addView(ell);
            int spaceid4 = spaceid3 + 1;
            relativeLayout2.addView(inBetweenHorizontalSpace(spaceid4, 10, id4));
            TextView tv2 = new TextView(this);
            int id5 = id4 + 1;
            tv2.setId(id5);
            RelativeLayout.LayoutParams tv2lp = new RelativeLayout.LayoutParams(-2, -2);
            tv2lp.addRule(3, spaceid4);
            tv2.setLayoutParams(tv2lp);
            tv2.setText("Tekan LANJUT utk pengiriman SMS secara otomatis. Pulsa anda secara otomatis akan berkurang.");
            tv2.setTextColor(-9599820);
            tv2.setPadding(0, 10, 0, 30);
            relativeLayout2.addView(tv2);
            int spaceid5 = spaceid4 + 1;
            relativeLayout2.addView(inBetweenHorizontalSpace(spaceid5, 10, id5));
            LinearLayout ll = new LinearLayout(this);
            int id6 = id5 + 1;
            ll.setId(id6);
            RelativeLayout.LayoutParams lllp = new RelativeLayout.LayoutParams(-2, -2);
            lllp.addRule(3, spaceid5);
            lllp.addRule(14);
            ll.setLayoutParams(lllp);
            btnok = new Button(this);
            setButtonShape(btnok);
            LinearLayout.LayoutParams boklp = new LinearLayout.LayoutParams(-2, -2);
            boklp.setMargins(0, 0, 10, 0);
            btnok.setLayoutParams(boklp);
            btnok.setText("   LANJUT   ");
            btnok.setOnClickListener(new View.OnClickListener() { // from class: com.mimopay.MimopayActivity.18
                @Override // android.view.View.OnClickListener
                public void onClick(View v) {
                    MimopayActivity.this.mCore.sendSMS(smscontent, smsnumber);
                }
            });
            btnok.setEnabled(false);
            if (Build.VERSION.SDK_INT >= 11) {
                btnok.setAlpha(0.5f);
            }
            ll.addView(btnok);
            Button btncancel = new Button(this);
            setButtonShape(btncancel);
            LinearLayout.LayoutParams bcanlp = new LinearLayout.LayoutParams(-2, -2);
            btncancel.setLayoutParams(bcanlp);
            btncancel.setText(" BATAL ");
            btncancel.setOnClickListener(new View.OnClickListener() { // from class: com.mimopay.MimopayActivity.19
                @Override // android.view.View.OnClickListener
                public void onClick(View v) {
                    MimopayActivity.this.mInfoResult = "Success";
                    MimopayActivity.this.mAlsResult = new ArrayList();
                    MimopayActivity.this.mAlsResult.add(MimopayActivity.this.mCore.alsBtnAction.get(MimopayActivity.this.mCore.mAlsActiveIdx));
                    MimopayActivity.this.mAlsResult.add(smscontent);
                    MimopayActivity.this.mAlsResult.add(smsnumber);
                    MimopayActivity.this.mAlsResult.add(MimopayActivity.this.mCore.mHttppostPhoneNumber);
                    MimopayActivity.this.finish();
                }
            });
            ll.addView(btncancel);
            relativeLayout2.addView(ll);
            relativeLayout2.addView(inBetweenHorizontalSpace(spaceid5 + 1, 10, id6));
        } else {
            widthref = (int) tv.getPaint().measureText("123456789012345678901234567890");
            int spaceid6 = spaceid2 + 1;
            relativeLayout2.addView(inBetweenHorizontalSpace(spaceid6, 30, id3));
            btnok = new Button(this);
            btnok.setId(id3 + 1);
            setButtonShape(btnok);
            RelativeLayout.LayoutParams btnoklp = new RelativeLayout.LayoutParams(-2, -2);
            btnoklp.addRule(3, spaceid6);
            btnoklp.addRule(14);
            btnok.setLayoutParams(btnoklp);
            btnok.setText("   SELESAI   ");
            btnok.setOnClickListener(new View.OnClickListener() { // from class: com.mimopay.MimopayActivity.20
                @Override // android.view.View.OnClickListener
                public void onClick(View v) {
                    MimopayActivity.this.mInfoResult = "Success";
                    MimopayActivity.this.mAlsResult = new ArrayList();
                    MimopayActivity.this.mAlsResult.add(MimopayActivity.this.mCore.alsBtnAction.get(MimopayActivity.this.mCore.mAlsActiveIdx));
                    MimopayActivity.this.mAlsResult.add(smscontent);
                    MimopayActivity.this.mAlsResult.add(smsnumber);
                    MimopayActivity.this.mAlsResult.add(MimopayActivity.this.mCore.mHttppostPhoneNumber);
                    MimopayActivity.this.finish();
                }
            });
            relativeLayout2.addView(btnok);
        }
        ScrollView scrollView = new ScrollView(this);
        RelativeLayout.LayoutParams svlp = new RelativeLayout.LayoutParams(-2, -2);
        svlp.addRule(14);
        svlp.addRule(15);
        scrollView.setLayoutParams(svlp);
        scrollView.setVerticalScrollBarEnabled(false);
        scrollView.setHorizontalScrollBarEnabled(false);
        scrollView.addView(relativeLayout2);
        relativeLayout.addView(scrollView);
        setContentView(relativeLayout, new RelativeLayout.LayoutParams(-1, -1));
        int i = 20 * 2;
        int wdth = (widthref / 4) + widthref + 40;
        if (wdth > this.measuredWidth - (20 * 2)) {
            wdth = this.measuredWidth - (20 * 2);
        }
        relativeLayout2.getLayoutParams().width = wdth;
        if (!this.mbCannotSMS) {
            final Button fbtnok = btnok;
            final ImageView fivvalid = ivvalid;
            final EditText fet = et;
            TextWatcher fieldValidatorTextWatcher = new TextWatcher() { // from class: com.mimopay.MimopayActivity.21
                @Override // android.text.TextWatcher
                public void beforeTextChanged(CharSequence s, int start, int count, int after) {
                }

                @Override // android.text.TextWatcher
                public void onTextChanged(CharSequence s, int start, int before, int count) {
                }

                @Override // android.text.TextWatcher
                public void afterTextChanged(Editable s) {
                    String iskode = skode;
                    int len = iskode.length();
                    if (s.length() == len) {
                        String t = fet.getText().toString();
                        if (t.equals(iskode)) {
                            fbtnok.setEnabled(true);
                            if (Build.VERSION.SDK_INT >= 11) {
                                fbtnok.setAlpha(1.0f);
                            }
                            fivvalid.setImageResource(R.drawable.presence_online);
                            return;
                        }
                        return;
                    }
                    fbtnok.setEnabled(false);
                    if (Build.VERSION.SDK_INT >= 11) {
                        fbtnok.setAlpha(0.5f);
                    }
                    fivvalid.setImageResource(R.drawable.presence_offline);
                }
            };
            et.addTextChangedListener(fieldValidatorTextWatcher);
        }
    }

    /* JADX INFO: Access modifiers changed from: private */
    public void setupAirtimeXLResult1UI(String srefid) {
        int id;
        int widthref;
        RelativeLayout relativeLayout = new RelativeLayout(this);
        RelativeLayout relativeLayout2 = new RelativeLayout(this);
        relativeLayout2.setPadding(20, 20, 20, 20);
        RelativeLayout.LayoutParams rllp = new RelativeLayout.LayoutParams(-1, -2);
        rllp.addRule(13);
        relativeLayout2.setLayoutParams(rllp);
        GradientDrawable rlshape = new GradientDrawable();
        rlshape.setCornerRadius(8.0f);
        rlshape.setColor(-2105377);
        setBkgndCompat(relativeLayout2, rlshape);
        if (1 != 0) {
            ImageView ivlogo = new ImageView(this);
            id = 0 + 1;
            ivlogo.setId(id);
            RelativeLayout.LayoutParams ivlogolp = new RelativeLayout.LayoutParams(-2, -2);
            ivlogolp.addRule(6);
            ivlogolp.addRule(14);
            ivlogo.setLayoutParams(ivlogolp);
            Bitmap mlbmp = getRoundedCornerBitmap(this.mCore.getBitmapInternal(this.mCore.alsLogos.get(this.mCore.mAlsActiveIdx)), -1);
            if (mlbmp != null) {
                ivlogo.setImageBitmap(mlbmp);
            }
            relativeLayout2.addView(ivlogo);
        } else {
            TextView tvlogo = new TextView(this);
            id = 0 + 1;
            tvlogo.setId(id);
            RelativeLayout.LayoutParams tvlogolp = new RelativeLayout.LayoutParams(-2, -2);
            tvlogolp.addRule(6);
            tvlogolp.addRule(14);
            tvlogo.setLayoutParams(tvlogolp);
            tvlogo.setText(this.mCore.alsBtnAction.get(this.mCore.mAlsActiveIdx).toUpperCase().replace('_', ' '));
            tvlogo.setTypeface(Typeface.DEFAULT_BOLD);
            tvlogo.setTextColor(-9599820);
            relativeLayout2.addView(tvlogo);
        }
        int spaceid = 1000 + 1;
        relativeLayout2.addView(inBetweenHorizontalSpace(spaceid, 20, id));
        int id2 = id + 1;
        relativeLayout2.addView(lineSeparator(id2, spaceid));
        int spaceid2 = spaceid + 1;
        relativeLayout2.addView(inBetweenHorizontalSpace(spaceid2, 20, id2));
        TextView tv = new TextView(this);
        int id3 = id2 + 1;
        tv.setId(id3);
        RelativeLayout.LayoutParams tvlp = new RelativeLayout.LayoutParams(-2, -2);
        tvlp.addRule(3, spaceid2);
        tvlp.addRule(14);
        tv.setLayoutParams(tvlp);
        String ssrefid = srefid.replaceAll("\\s", "#");
        int a = ssrefid.lastIndexOf("#");
        final String srefnum = ssrefid.substring(a + 1);
        String st = "ID Referensi: " + srefnum + ". \nPembelian menggunakan nomor telpon : " + this.mCore.mHttppostPhoneNumber;
        tv.setText(st);
        tv.setTextColor(-9599820);
        tv.setPadding(0, 10, 0, 10);
        relativeLayout2.addView(tv);
        if (!this.mbCannotSMS) {
            int spaceid3 = spaceid2 + 1;
            relativeLayout2.addView(inBetweenHorizontalSpace(spaceid3, 20, id3));
            this.mXLReferenceId = srefnum;
            ProgressBar pb = new ProgressBar(this, null, R.attr.progressBarStyle);
            int id4 = id3 + 1;
            pb.setId(id4);
            RelativeLayout.LayoutParams pblp = new RelativeLayout.LayoutParams(50, 50);
            pblp.addRule(3, spaceid3);
            pblp.addRule(14);
            pb.setLayoutParams(pblp);
            pb.setIndeterminate(true);
            pb.getIndeterminateDrawable().setColorFilter(-13388315, PorterDuff.Mode.MULTIPLY);
            relativeLayout2.addView(pb);
            int spaceid4 = spaceid3 + 1;
            relativeLayout2.addView(inBetweenHorizontalSpace(spaceid4, 20, id4));
            TextView tvwait = new TextView(this);
            int id5 = id4 + 1;
            tvwait.setId(id5);
            RelativeLayout.LayoutParams tvwaitlp = new RelativeLayout.LayoutParams(-2, -2);
            tvwaitlp.addRule(3, spaceid4);
            tvwaitlp.addRule(14);
            tvwait.setLayoutParams(tvwaitlp);
            tvwait.setText("Menunggu Konfirmasi SMS dari XL...");
            tvwait.setTextColor(-9599820);
            relativeLayout2.addView(tvwait);
            relativeLayout2.addView(inBetweenHorizontalSpace(spaceid4 + 1, 20, id5));
            widthref = (int) tvwait.getPaint().measureText("Menunggu Konfirmasi SMS dari XL...");
        } else {
            int spaceid5 = spaceid2 + 1;
            relativeLayout2.addView(inBetweenHorizontalSpace(spaceid5, 30, id3));
            widthref = (int) tv.getPaint().measureText("\nAnda akan segera menerima SMS balasan");
            tv.setText(st + "\n\nAnda akan segera menerima SMS balasan");
            Button btnok = new Button(this);
            int id6 = id3 + 1;
            btnok.setId(id6);
            setButtonShape(btnok);
            RelativeLayout.LayoutParams btnoklp = new RelativeLayout.LayoutParams(-2, -2);
            btnoklp.addRule(3, spaceid5);
            btnoklp.addRule(14);
            btnok.setLayoutParams(btnoklp);
            btnok.setText("   SELESAI   ");
            btnok.setOnClickListener(new View.OnClickListener() { // from class: com.mimopay.MimopayActivity.22
                @Override // android.view.View.OnClickListener
                public void onClick(View v) {
                    MimopayActivity.this.mInfoResult = "Success";
                    MimopayActivity.this.mAlsResult = new ArrayList();
                    MimopayActivity.this.mAlsResult.add(MimopayActivity.this.mCore.alsBtnAction.get(MimopayActivity.this.mCore.mAlsActiveIdx));
                    MimopayActivity.this.mAlsResult.add(srefnum);
                    MimopayActivity.this.mAlsResult.add(MimopayActivity.this.mCore.mHttppostPhoneNumber);
                    MimopayActivity.this.finish();
                }
            });
            relativeLayout2.addView(btnok);
            relativeLayout2.addView(inBetweenHorizontalSpace(spaceid5 + 1, 20, id6));
        }
        ScrollView scrollView = new ScrollView(this);
        RelativeLayout.LayoutParams svlp = new RelativeLayout.LayoutParams(-2, -2);
        svlp.addRule(14);
        svlp.addRule(15);
        scrollView.setLayoutParams(svlp);
        scrollView.setVerticalScrollBarEnabled(false);
        scrollView.setHorizontalScrollBarEnabled(false);
        scrollView.addView(relativeLayout2);
        relativeLayout.addView(scrollView);
        setContentView(relativeLayout, new RelativeLayout.LayoutParams(-1, -1));
        int i = 20 * 2;
        int wdth = (widthref / 4) + widthref + 40;
        if (wdth > this.measuredWidth - (20 * 2)) {
            wdth = this.measuredWidth - (20 * 2);
        }
        relativeLayout2.getLayoutParams().width = wdth;
    }

    /* JADX INFO: Access modifiers changed from: private */
    public void processXLRepliedSMS(boolean bsuccess, String jarrsms) {
        if (bsuccess) {
            String senderphno = null;
            String smsmsg = null;
            try {
                JSONArray jarr = new JSONArray(jarrsms);
                try {
                    String senderphno2 = new String(jarr.getString(0));
                    try {
                        smsmsg = new String(jarr.getString(2));
                        senderphno = senderphno2;
                    } catch (JSONException e) {
                        senderphno = senderphno2;
                    }
                } catch (JSONException e2) {
                }
            } catch (JSONException e3) {
            }
            if (senderphno != null && smsmsg != null) {
                if (smsmsg.indexOf(this.mCore.mHttppostCode) != -1) {
                    String ssmsmsg = smsmsg.replaceAll("\\s", "#");
                    jprintf("senderphno: " + senderphno + " smsmsg: " + smsmsg + " ssmsmsg: " + ssmsmsg);
                    int a = ssmsmsg.indexOf("kode", 0);
                    if (a != -1) {
                        int b = ssmsmsg.indexOf(".", a);
                        if (b != -1) {
                            String sssmsmsg = ssmsmsg.substring(a, b);
                            jprintf("parsedkode: " + sssmsmsg);
                            int c = sssmsmsg.lastIndexOf("#");
                            if (c != -1) {
                                final String thecode = sssmsmsg.substring(c + 1);
                                if (thecode.length() == 4) {
                                    this.mCore.stopWaitSMS();
                                    jprintf("thecode: " + thecode);
                                    final String fsenderphno = senderphno;
                                    runOnUiThread(new Runnable() { // from class: com.mimopay.MimopayActivity.23
                                        @Override // java.lang.Runnable
                                        public void run() {
                                            MimopayActivity.this.setupAirtimeXLResult2UI(thecode, fsenderphno);
                                        }
                                    });
                                    return;
                                }
                                return;
                            }
                            return;
                        }
                        return;
                    }
                    return;
                }
                return;
            }
            return;
        }
        jprintf("read_status: " + jarrsms);
        if (jarrsms.equals("timeout")) {
            this.mbCannotSMS = true;
            runOnUiThread(new Runnable() { // from class: com.mimopay.MimopayActivity.24
                @Override // java.lang.Runnable
                public void run() {
                    MimopayActivity.this.setupAirtimeXLResult1UI(MimopayActivity.this.mXLReferenceId);
                }
            });
        }
    }

    /* JADX INFO: Access modifiers changed from: private */
    public void setupAirtimeXLResult2UI(final String skode, final String senderphno) {
        int id;
        RelativeLayout relativeLayout = new RelativeLayout(this);
        RelativeLayout relativeLayout2 = new RelativeLayout(this);
        relativeLayout2.setPadding(20, 20, 20, 20);
        RelativeLayout.LayoutParams rllp = new RelativeLayout.LayoutParams(-1, -2);
        rllp.addRule(13);
        relativeLayout2.setLayoutParams(rllp);
        GradientDrawable rlshape = new GradientDrawable();
        rlshape.setCornerRadius(8.0f);
        rlshape.setColor(-2105377);
        setBkgndCompat(relativeLayout2, rlshape);
        if (1 != 0) {
            ImageView ivlogo = new ImageView(this);
            id = 0 + 1;
            ivlogo.setId(id);
            RelativeLayout.LayoutParams ivlogolp = new RelativeLayout.LayoutParams(-2, -2);
            ivlogolp.addRule(6);
            ivlogolp.addRule(14);
            ivlogo.setLayoutParams(ivlogolp);
            Bitmap mlbmp = getRoundedCornerBitmap(this.mCore.getBitmapInternal(this.mCore.alsLogos.get(this.mCore.mAlsActiveIdx)), -1);
            if (mlbmp != null) {
                ivlogo.setImageBitmap(mlbmp);
            }
            relativeLayout2.addView(ivlogo);
        } else {
            TextView tvlogo = new TextView(this);
            id = 0 + 1;
            tvlogo.setId(id);
            RelativeLayout.LayoutParams tvlogolp = new RelativeLayout.LayoutParams(-2, -2);
            tvlogolp.addRule(6);
            tvlogolp.addRule(14);
            tvlogo.setLayoutParams(tvlogolp);
            tvlogo.setText(this.mCore.alsBtnAction.get(this.mCore.mAlsActiveIdx).toUpperCase().replace('_', ' '));
            tvlogo.setTypeface(Typeface.DEFAULT_BOLD);
            tvlogo.setTextColor(-9599820);
            relativeLayout2.addView(tvlogo);
        }
        int spaceid = 1000 + 1;
        relativeLayout2.addView(inBetweenHorizontalSpace(spaceid, 20, id));
        int id2 = id + 1;
        relativeLayout2.addView(lineSeparator(id2, spaceid));
        int spaceid2 = spaceid + 1;
        relativeLayout2.addView(inBetweenHorizontalSpace(spaceid2, 20, id2));
        TextView tv = new TextView(this);
        int id3 = id2 + 1;
        tv.setId(id3);
        RelativeLayout.LayoutParams tvlp = new RelativeLayout.LayoutParams(-2, -2);
        tvlp.addRule(3, spaceid2);
        tv.setLayoutParams(tvlp);
        String st = "ID Referensi: " + this.mXLReferenceId + ".\nNomor telpon : " + this.mCore.mHttppostPhoneNumber + ".\nKode balasan: " + skode + ".\n\nUntuk konfirmasi transaksi, anda harus mengetikkan kode balasan tersebut.";
        tv.setText(st);
        tv.setTextColor(-9599820);
        tv.setPadding(0, 10, 0, 10);
        relativeLayout2.addView(tv);
        int spaceid3 = spaceid2 + 1;
        relativeLayout2.addView(inBetweenHorizontalSpace(spaceid3, 10, id3));
        LinearLayout linearLayout = new LinearLayout(this);
        int id4 = id3 + 1;
        linearLayout.setId(id4);
        RelativeLayout.LayoutParams elllp = new RelativeLayout.LayoutParams(-1, -2);
        elllp.addRule(3, spaceid3);
        elllp.addRule(14);
        linearLayout.setLayoutParams(elllp);
        final EditText et = new EditText(this);
        LinearLayout.LayoutParams etlp = new LinearLayout.LayoutParams(0, -2);
        etlp.setMargins(0, 0, 10, 0);
        etlp.weight = 1.0f;
        et.setLayoutParams(etlp);
        GradientDrawable etshape = new GradientDrawable();
        etshape.setCornerRadius(8.0f);
        etshape.setColor(-2105377);
        etshape.setStroke(2, -9599820);
        setBkgndCompat(et, etshape);
        et.setMinLines(1);
        et.setMaxLines(3);
        et.setTextColor(-9599820);
        et.setFilters(new InputFilter[]{new InputFilter.LengthFilter(skode.length())});
        et.setInputType(3);
        linearLayout.addView(et);
        int widthref = (int) et.getPaint().measureText("123456789012345678901234567890");
        final ImageView ivvalid = new ImageView(this);
        LinearLayout.LayoutParams ivvalidlp = new LinearLayout.LayoutParams(0, -2);
        ivvalidlp.weight = 0.1f;
        ivvalidlp.gravity = 17;
        ivvalid.setLayoutParams(ivvalidlp);
        ivvalid.setImageResource(R.drawable.presence_offline);
        linearLayout.addView(ivvalid);
        relativeLayout2.addView(linearLayout);
        int spaceid4 = spaceid3 + 1;
        relativeLayout2.addView(inBetweenHorizontalSpace(spaceid4, 10, id4));
        TextView tv2 = new TextView(this);
        int id5 = id4 + 1;
        tv2.setId(id5);
        RelativeLayout.LayoutParams tv2lp = new RelativeLayout.LayoutParams(-2, -2);
        tv2lp.addRule(3, spaceid4);
        tv2.setLayoutParams(tv2lp);
        tv2.setText("Tekan LANJUT untuk mengirimkan SMS secara otomatis. Pulsa anda akan berkurang.");
        tv2.setTextColor(-9599820);
        tv2.setPadding(0, 10, 0, 30);
        relativeLayout2.addView(tv2);
        int spaceid5 = spaceid4 + 1;
        relativeLayout2.addView(inBetweenHorizontalSpace(spaceid5, 10, id5));
        LinearLayout linearLayout2 = new LinearLayout(this);
        int id6 = id5 + 1;
        linearLayout2.setId(id6);
        RelativeLayout.LayoutParams lllp = new RelativeLayout.LayoutParams(-2, -2);
        lllp.addRule(3, spaceid5);
        lllp.addRule(14);
        linearLayout2.setLayoutParams(lllp);
        final Button btnok = new Button(this);
        setButtonShape(btnok);
        LinearLayout.LayoutParams boklp = new LinearLayout.LayoutParams(-2, -2);
        boklp.setMargins(0, 0, 10, 0);
        btnok.setLayoutParams(boklp);
        btnok.setText("  LANJUT  ");
        btnok.setOnClickListener(new View.OnClickListener() { // from class: com.mimopay.MimopayActivity.25
            @Override // android.view.View.OnClickListener
            public void onClick(View v) {
                MimopayActivity.this.mCore.sendSMS(skode, senderphno);
            }
        });
        btnok.setEnabled(false);
        if (Build.VERSION.SDK_INT >= 11) {
            btnok.setAlpha(0.5f);
        }
        linearLayout2.addView(btnok);
        Button btncancel = new Button(this);
        setButtonShape(btncancel);
        LinearLayout.LayoutParams bcanlp = new LinearLayout.LayoutParams(-2, -2);
        btncancel.setLayoutParams(bcanlp);
        btncancel.setText(" BATAL ");
        btncancel.setOnClickListener(new View.OnClickListener() { // from class: com.mimopay.MimopayActivity.26
            @Override // android.view.View.OnClickListener
            public void onClick(View v) {
                MimopayActivity.this.mInfoResult = "Success";
                MimopayActivity.this.mAlsResult = new ArrayList();
                MimopayActivity.this.mAlsResult.add(MimopayActivity.this.mCore.alsBtnAction.get(MimopayActivity.this.mCore.mAlsActiveIdx));
                MimopayActivity.this.mAlsResult.add(MimopayActivity.this.mXLReferenceId);
                MimopayActivity.this.mAlsResult.add(skode);
                MimopayActivity.this.mAlsResult.add(senderphno);
                MimopayActivity.this.mAlsResult.add(MimopayActivity.this.mCore.mHttppostPhoneNumber);
                MimopayActivity.this.finish();
            }
        });
        linearLayout2.addView(btncancel);
        relativeLayout2.addView(linearLayout2);
        relativeLayout2.addView(inBetweenHorizontalSpace(spaceid5 + 1, 10, id6));
        ScrollView scrollView = new ScrollView(this);
        RelativeLayout.LayoutParams svlp = new RelativeLayout.LayoutParams(-2, -2);
        svlp.addRule(14);
        svlp.addRule(15);
        scrollView.setLayoutParams(svlp);
        scrollView.setVerticalScrollBarEnabled(false);
        scrollView.setHorizontalScrollBarEnabled(false);
        scrollView.addView(relativeLayout2);
        relativeLayout.addView(scrollView);
        setContentView(relativeLayout, new RelativeLayout.LayoutParams(-1, -1));
        int i = 20 * 2;
        int wdth = (widthref / 4) + widthref + 40;
        if (wdth > this.measuredWidth - (20 * 2)) {
            wdth = this.measuredWidth - (20 * 2);
        }
        relativeLayout2.getLayoutParams().width = wdth;
        if (!this.mbCannotSMS) {
            TextWatcher fieldValidatorTextWatcher = new TextWatcher() { // from class: com.mimopay.MimopayActivity.27
                @Override // android.text.TextWatcher
                public void beforeTextChanged(CharSequence s, int start, int count, int after) {
                }

                @Override // android.text.TextWatcher
                public void onTextChanged(CharSequence s, int start, int before, int count) {
                }

                @Override // android.text.TextWatcher
                public void afterTextChanged(Editable s) {
                    String iskode = skode;
                    int len = iskode.length();
                    if (s.length() == len) {
                        String t = et.getText().toString();
                        if (t.equals(iskode)) {
                            btnok.setEnabled(true);
                            if (Build.VERSION.SDK_INT >= 11) {
                                btnok.setAlpha(1.0f);
                            }
                            ivvalid.setImageResource(R.drawable.presence_online);
                            return;
                        }
                        return;
                    }
                    btnok.setEnabled(false);
                    if (Build.VERSION.SDK_INT >= 11) {
                        btnok.setAlpha(0.5f);
                    }
                    ivvalid.setImageResource(R.drawable.presence_offline);
                }
            };
            et.addTextChangedListener(fieldValidatorTextWatcher);
        }
    }

    /* JADX INFO: Access modifiers changed from: private */
    public String getMyPhoneNumber() {
        TelephonyManager telpmgr = (TelephonyManager) getApplicationContext().getSystemService("phone");
        String s = telpmgr.getLine1Number();
        jprintf("getMyPhoneNumber: " + s);
        return s;
    }

    /* JADX INFO: Access modifiers changed from: private */
    public boolean isActivityFinishing() {
        return isFinishing();
    }

    /* JADX INFO: Access modifiers changed from: private */
    public void setupAlertDialog(String smsg, final String sfirstbtn, final String ssecondbtn, final MimopayInterface mi) {
        int id;
        RelativeLayout relativeLayout = new RelativeLayout(this);
        RelativeLayout relativeLayout2 = new RelativeLayout(this);
        relativeLayout2.setPadding(20, 20, 20, 20);
        RelativeLayout.LayoutParams rllp = new RelativeLayout.LayoutParams(-1, -2);
        rllp.addRule(13);
        relativeLayout2.setLayoutParams(rllp);
        GradientDrawable rlshape = new GradientDrawable();
        rlshape.setCornerRadius(8.0f);
        rlshape.setColor(-2105377);
        setBkgndCompat(relativeLayout2, rlshape);
        if (1 != 0 && !this.mCore.mMimopayLogoUrl.equals("")) {
            ImageView ivlogo = new ImageView(this);
            id = 0 + 1;
            ivlogo.setId(id);
            RelativeLayout.LayoutParams ivlogolp = new RelativeLayout.LayoutParams(-2, -2);
            ivlogolp.addRule(6);
            ivlogolp.addRule(14);
            ivlogo.setLayoutParams(ivlogolp);
            Bitmap mlbmp = getRoundedCornerBitmap(this.mCore.getBitmapInternal(this.mCore.mMimopayLogoUrl), -1);
            if (mlbmp != null) {
                ivlogo.setImageBitmap(mlbmp);
            }
            relativeLayout2.addView(ivlogo);
        } else {
            TextView tvlogo = new TextView(this);
            id = 0 + 1;
            tvlogo.setId(id);
            RelativeLayout.LayoutParams tvlogolp = new RelativeLayout.LayoutParams(-2, -2);
            tvlogolp.addRule(6);
            tvlogolp.addRule(14);
            tvlogo.setLayoutParams(tvlogolp);
            tvlogo.setText("MIMOPAY");
            tvlogo.setTypeface(Typeface.DEFAULT_BOLD);
            tvlogo.setTextColor(-9599820);
            relativeLayout2.addView(tvlogo);
        }
        int spaceid = 1000 + 1;
        relativeLayout2.addView(inBetweenHorizontalSpace(spaceid, 20, id));
        int id2 = id + 1;
        relativeLayout2.addView(lineSeparator(id2, spaceid));
        int spaceid2 = spaceid + 1;
        relativeLayout2.addView(inBetweenHorizontalSpace(spaceid2, 20, id2));
        TextView tv = new TextView(this);
        int id3 = id2 + 1;
        tv.setId(id3);
        RelativeLayout.LayoutParams tvlp = new RelativeLayout.LayoutParams(-2, -2);
        tvlp.addRule(3, spaceid2);
        tvlp.addRule(14);
        tv.setLayoutParams(tvlp);
        tv.setText(smsg);
        tv.setTextColor(-9599820);
        tv.setPadding(0, 10, 0, 10);
        relativeLayout2.addView(tv);
        int widthref = (int) tv.getPaint().measureText(smsg);
        int spaceid3 = spaceid2 + 1;
        relativeLayout2.addView(inBetweenHorizontalSpace(spaceid3, 20, id3));
        LinearLayout linearLayout = new LinearLayout(this);
        int id4 = id3 + 1;
        linearLayout.setId(id4);
        RelativeLayout.LayoutParams lllp = new RelativeLayout.LayoutParams(-2, -2);
        lllp.addRule(3, spaceid3);
        lllp.addRule(14);
        linearLayout.setLayoutParams(lllp);
        Button btnok = new Button(this);
        setButtonShape(btnok);
        LinearLayout.LayoutParams boklp = new LinearLayout.LayoutParams(-2, -2);
        boklp.setMargins(0, 0, 10, 0);
        btnok.setLayoutParams(boklp);
        btnok.setText("  " + sfirstbtn + "  ");
        btnok.setOnClickListener(new View.OnClickListener() { // from class: com.mimopay.MimopayActivity.28
            @Override // android.view.View.OnClickListener
            public void onClick(View v) {
                if (mi != null) {
                    mi.onReturn(sfirstbtn, null);
                }
            }
        });
        linearLayout.addView(btnok);
        if (ssecondbtn != null) {
            Button btncancel = new Button(this);
            setButtonShape(btncancel);
            LinearLayout.LayoutParams bcanlp = new LinearLayout.LayoutParams(-2, -2);
            btncancel.setLayoutParams(bcanlp);
            btncancel.setText("  " + ssecondbtn + "  ");
            btncancel.setOnClickListener(new View.OnClickListener() { // from class: com.mimopay.MimopayActivity.29
                @Override // android.view.View.OnClickListener
                public void onClick(View v) {
                    if (mi != null) {
                        mi.onReturn(ssecondbtn, null);
                    }
                }
            });
            linearLayout.addView(btncancel);
        }
        relativeLayout2.addView(linearLayout);
        relativeLayout2.addView(inBetweenHorizontalSpace(spaceid3 + 1, 10, id4));
        ScrollView scrollView = new ScrollView(this);
        RelativeLayout.LayoutParams svlp = new RelativeLayout.LayoutParams(-2, -2);
        svlp.addRule(14);
        svlp.addRule(15);
        scrollView.setLayoutParams(svlp);
        scrollView.setVerticalScrollBarEnabled(false);
        scrollView.setHorizontalScrollBarEnabled(false);
        scrollView.addView(relativeLayout2);
        relativeLayout.addView(scrollView);
        setContentView(relativeLayout, new RelativeLayout.LayoutParams(-1, -1));
        int i = 20 * 2;
        int wdth = (widthref / 4) + widthref + 40;
        if (wdth > this.measuredWidth - (20 * 2)) {
            wdth = this.measuredWidth - (20 * 2);
        }
        relativeLayout2.getLayoutParams().width = wdth;
    }

    /* JADX INFO: Access modifiers changed from: private */
    public void setupProgressDialog(String smsg) {
        RelativeLayout relativeLayout = new RelativeLayout(this);
        RelativeLayout relativeLayout2 = new RelativeLayout(this);
        relativeLayout2.setPadding(20, 20, 20, 20);
        RelativeLayout.LayoutParams rllp = new RelativeLayout.LayoutParams(-1, -2);
        rllp.addRule(13);
        relativeLayout2.setLayoutParams(rllp);
        GradientDrawable rlshape = new GradientDrawable();
        rlshape.setCornerRadius(8.0f);
        rlshape.setColor(-2105377);
        setBkgndCompat(relativeLayout2, rlshape);
        LinearLayout linearLayout = new LinearLayout(this);
        int id = 0 + 1;
        linearLayout.setId(id);
        RelativeLayout.LayoutParams elllp = new RelativeLayout.LayoutParams(-1, -2);
        elllp.addRule(14);
        elllp.addRule(15);
        linearLayout.setLayoutParams(elllp);
        ProgressBar pb = new ProgressBar(this, null, R.attr.progressBarStyle);
        LinearLayout.LayoutParams pblp = new LinearLayout.LayoutParams(-2, -2);
        pblp.setMargins(0, 0, 20, 0);
        pblp.gravity = 17;
        pb.setLayoutParams(pblp);
        pb.setIndeterminate(true);
        pb.getIndeterminateDrawable().setColorFilter(-13388315, PorterDuff.Mode.MULTIPLY);
        linearLayout.addView(pb);
        TextView tvwait = new TextView(this);
        LinearLayout.LayoutParams tvwaitlp = new LinearLayout.LayoutParams(-2, -2);
        tvwaitlp.gravity = 17;
        tvwait.setLayoutParams(tvwaitlp);
        tvwait.setText(smsg);
        tvwait.setTextColor(-9599820);
        linearLayout.addView(tvwait);
        relativeLayout2.addView(linearLayout);
        int widthref = (int) tvwait.getPaint().measureText(smsg);
        ScrollView scrollView = new ScrollView(this);
        RelativeLayout.LayoutParams svlp = new RelativeLayout.LayoutParams(-2, -2);
        svlp.addRule(14);
        svlp.addRule(15);
        scrollView.setLayoutParams(svlp);
        scrollView.setVerticalScrollBarEnabled(false);
        scrollView.setHorizontalScrollBarEnabled(false);
        scrollView.addView(relativeLayout2);
        relativeLayout.addView(scrollView);
        setContentView(relativeLayout, new RelativeLayout.LayoutParams(-1, -1));
        int i = 20 * 2;
        int wdth = (widthref / 4) + widthref + 40;
        if (wdth > this.measuredWidth - (20 * 2)) {
            wdth = this.measuredWidth - (20 * 2);
        }
        relativeLayout2.getLayoutParams().width = wdth;
    }

    public class MimopayActivityCore extends MimopayCore {
        public MimopayActivityCore() {
        }

        @Override // com.mimopay.MimopayCore
        public void onError(String serr) {
            if (MimopayActivity.this.isActivityFinishing()) {
                MimopayActivity.this.jprintf("Error Notification Cancelled");
                return;
            }
            String smsg = "-";
            String sfirst = "SELESAI";
            String ssecond = null;
            MimopayInterface lmi = new MimopayInterface() { // from class: com.mimopay.MimopayActivity.MimopayActivityCore.1
                @Override // com.mimopay.MimopayInterface
                public void onReturn(String info, ArrayList<String> params) {
                    MimopayActivity.this.finish();
                }
            };
            if (serr.equals("MerchantLoadUrlNull")) {
                smsg = "URL Merchant Tidak Boleh Sama Dengan Nol";
            } else if (serr.equals("UnsupportedPaymentMethod")) {
                smsg = "Cara Pembayaran Tidak di Dukung";
            } else if (serr.equals("UnspecifiedChannelRequest")) {
                smsg = "Kanal Pembayaran Tidak di Dukung atau Tersedia";
            } else if (serr.equals("ErrorHTTP404NotFound")) {
                smsg = "Terjadi Error 404. Mohon Ulangi Kembali";
            } else if (serr.equals("ErrorUnderMaintenance")) {
                smsg = "Maaf, Server Sedang Dalam Perbaikan";
            } else if (serr.equals("ErrorConnectingToMimopayServer") || serr.equals("ErrorValidatingVoucherCode") || serr.equals("ErrorInternetConnectionProblem")) {
                if (serr.equals("ErrorConnectingToMimopayServer")) {
                    smsg = "Error koneksi ke server atau server sibuk";
                } else if (serr.equals("ErrorValidatingVoucherCode")) {
                    smsg = "Error Validasi Kode Voucher";
                } else if (serr.equals("ErrorInternetConnectionProblem")) {
                    smsg = "Koneksi Internet Bermasalah. 16 digit kode yg ada ketik sudah di-copy, anda bisa mengulangi nya dan paste kode tersebut.";
                }
                sfirst = "Selesai";
                ssecond = null;
                lmi = new MimopayInterface() { // from class: com.mimopay.MimopayActivity.MimopayActivityCore.2
                    @Override // com.mimopay.MimopayInterface
                    public void onReturn(String info, ArrayList<String> params) {
                        if (info.equals("Selesai")) {
                            MimopayActivity.this.finish();
                        }
                    }
                };
            }
            final String fsmsg = smsg;
            final String fsfirst = sfirst;
            final String fssecond = ssecond;
            final MimopayInterface flmi = lmi;
            MimopayActivity.this.runOnUiThread(new Runnable() { // from class: com.mimopay.MimopayActivity.MimopayActivityCore.3
                @Override // java.lang.Runnable
                public void run() {
                    MimopayActivity.this.setupAlertDialog(fsmsg, fsfirst, fssecond, flmi);
                }
            });
        }

        @Override // com.mimopay.MimopayCore
        public void onProgress(boolean start, String cmd) {
            String msg = "";
            if (start) {
                if (cmd.equals("validating")) {
                    msg = "Mohon menunggu, sedang memvalidasi kode dgn Server";
                } else if (cmd.equals("connecting")) {
                    msg = "Mohon menunggu, melakukan koneksi ke Server";
                } else if (cmd.equals("sendsms")) {
                    msg = "Mohon menunggu, mengirimkan SMS...";
                } else if (cmd.equals("waitsms")) {
                    msg = "Mohon menunggu, sedang membaca SMS balasan...";
                }
                MimopayActivity.this.setupProgressDialog(msg);
            }
        }

        @Override // com.mimopay.MimopayCore
        public void onMerchantPaymentMethodRetrieved() {
            MimopayActivity.this.runOnUiThread(new Runnable() { // from class: com.mimopay.MimopayActivity.MimopayActivityCore.4
                @Override // java.lang.Runnable
                public void run() throws JSONException {
                    if (MimopayStuff.sPaymentMethod.equals("Topup")) {
                        if (MimopayStuff.sChannel.equals("smartfren")) {
                            boolean b = MimopayActivity.this.mCore.setChannelActiveIndex("smartfren");
                            if (b) {
                                MimopayActivity.this.setupTopUpVoucherUI();
                                return;
                            } else {
                                MimopayActivityCore.this.onError("UnspecifiedChannelRequest");
                                return;
                            }
                        }
                        if (MimopayStuff.sChannel.equals("sevelin")) {
                            boolean b2 = MimopayActivity.this.mCore.setChannelActiveIndex("sevelin");
                            if (b2) {
                                MimopayActivity.this.setupTopUpVoucherUI();
                                return;
                            } else {
                                MimopayActivityCore.this.onError("UnspecifiedChannelRequest");
                                return;
                            }
                        }
                        MimopayActivity.this.setupTopUpMainUI();
                        return;
                    }
                    if (MimopayStuff.sPaymentMethod.equals("Airtime")) {
                        if (MimopayStuff.sChannel.equals("upoint")) {
                            if (MimopayActivity.this.mPhoneNumber != null) {
                                MimopayActivity.this.mCore.mAlsActiveIdx = 0;
                                MimopayActivity.this.mCore.mHttppostCode = MimopayActivity.this.mAirtimeValue;
                                MimopayActivity.this.mCore.mHttppostPhoneNumber = MimopayActivity.this.mPhoneNumber;
                                MimopayActivity.this.mCore.executeBtnAction();
                                return;
                            }
                            if (!MimopayStuff.sAmount.equals(AppEventsConstants.EVENT_PARAM_VALUE_NO)) {
                                MimopayActivity.this.mCore.mHttppostCode = MimopayStuff.sAmount;
                                MimopayActivity.this.mCore.mAlsActiveIdx = 0;
                                String s = MimopayActivity.this.getMyPhoneNumber();
                                if (s == null) {
                                    MimopayActivity.this.mbCannotSMS = true;
                                }
                                MimopayActivity.this.setupUserPhoneNumberUI();
                                return;
                            }
                            MimopayActivity.this.mCore.mAlsActiveIdx = 0;
                            MimopayActivity.this.setupAirtimeDenomUI();
                            return;
                        }
                        MimopayActivity.this.jprintf("Unsupported Channel of Payment Method: " + MimopayStuff.sPaymentMethod);
                        return;
                    }
                    if (MimopayStuff.sPaymentMethod.equals("XL")) {
                        if (MimopayStuff.sChannel.equals("xl_airtime")) {
                            boolean b3 = MimopayActivity.this.mCore.setChannelActiveIndex("xl_airtime");
                            if (MimopayActivity.this.mPhoneNumber != null) {
                                MimopayActivity.this.mCore.mHttppostCode = MimopayActivity.this.mAirtimeValue;
                                MimopayActivity.this.mCore.mHttppostPhoneNumber = MimopayActivity.this.mPhoneNumber;
                                if (b3) {
                                    MimopayActivity.this.mbCannotSMS = false;
                                    MimopayActivity.this.mCore.waitSMS(60);
                                    MimopayActivity.this.mCore.executeBtnAction();
                                    return;
                                }
                                MimopayActivityCore.this.onError("UnspecifiedChannelRequest");
                                return;
                            }
                            if (b3) {
                                MimopayActivity.this.setupAirtimeDenomUI();
                                return;
                            } else {
                                MimopayActivityCore.this.onError("UnspecifiedChannelRequest");
                                return;
                            }
                        }
                        if (MimopayStuff.sChannel.equals("xl_hrn")) {
                            boolean b4 = MimopayActivity.this.mCore.setChannelActiveIndex("xl_hrn");
                            if (b4) {
                                MimopayActivity.this.setupTopUpVoucherUI();
                                return;
                            } else {
                                MimopayActivityCore.this.onError("UnspecifiedChannelRequest");
                                return;
                            }
                        }
                        MimopayActivity.this.setupXLMainUI();
                        return;
                    }
                    if (!MimopayStuff.sPaymentMethod.equals("ATM")) {
                        MimopayActivity.this.jprintf("Unsupported Payment Method");
                        return;
                    }
                    if (MimopayStuff.sAmount.equals(AppEventsConstants.EVENT_PARAM_VALUE_NO)) {
                        MimopayActivity.this.mCore.mAlsActiveIdx = 0;
                        MimopayActivity.this.setupDenomUI();
                        return;
                    }
                    if (MimopayStuff.sChannel.equals("atm_bca")) {
                        boolean b5 = MimopayActivity.this.mCore.setChannelActiveIndex("atm_bca");
                        if (b5) {
                            MimopayActivity.this.setupAtmChoosenUI();
                            return;
                        } else {
                            MimopayActivityCore.this.onError("UnspecifiedChannelRequest");
                            return;
                        }
                    }
                    if (MimopayStuff.sChannel.equals("atm_bersama")) {
                        boolean b6 = MimopayActivity.this.mCore.setChannelActiveIndex("atm_bersama");
                        if (b6) {
                            MimopayActivity.this.setupAtmChoosenUI();
                            return;
                        } else {
                            MimopayActivityCore.this.onError("UnspecifiedChannelRequest");
                            return;
                        }
                    }
                    MimopayActivity.this.setupAtmMainUI();
                }
            });
        }

        @Override // com.mimopay.MimopayCore
        public void onResultUI(String channel, ArrayList<String> params) {
            if (channel.equals("smartfren") || channel.equals("sevelin") || channel.equals("xl_hrn")) {
                final String ftopupResult = params.get(0);
                final String ftransId = params.get(1);
                MimopayActivity.this.runOnUiThread(new Runnable() { // from class: com.mimopay.MimopayActivity.MimopayActivityCore.5
                    @Override // java.lang.Runnable
                    public void run() {
                        MimopayActivity.this.setupTopUpResultUI(ftopupResult, ftransId);
                    }
                });
                return;
            }
            if (channel.equals("atm_bca")) {
                final String fcompanyCode = params.get(0);
                final String ftotalBill = params.get(1);
                final String ftransId2 = params.get(2);
                MimopayActivity.this.runOnUiThread(new Runnable() { // from class: com.mimopay.MimopayActivity.MimopayActivityCore.6
                    @Override // java.lang.Runnable
                    public void run() {
                        MimopayActivity.this.setupDenomAtmResultUI(fcompanyCode, ftotalBill, ftransId2);
                    }
                });
                return;
            }
            if (channel.equals("upoint_airtime")) {
                final String fsmsContent = params.get(0);
                final String fsmsNumber = params.get(1);
                MimopayActivity.this.runOnUiThread(new Runnable() { // from class: com.mimopay.MimopayActivity.MimopayActivityCore.7
                    @Override // java.lang.Runnable
                    public void run() {
                        MimopayActivity.this.setupAirtimeUPointResultUI(fsmsContent, fsmsNumber);
                    }
                });
            } else if (channel.equals("xl_airtime")) {
                final String refid = params.get(0);
                MimopayActivity.this.runOnUiThread(new Runnable() { // from class: com.mimopay.MimopayActivity.MimopayActivityCore.8
                    @Override // java.lang.Runnable
                    public void run() {
                        MimopayActivity.this.setupAirtimeXLResult1UI(refid);
                    }
                });
            }
        }

        @Override // com.mimopay.MimopayCore
        public void onSmsCompleted(boolean success, ArrayList<String> alsSms) {
            String sop = alsSms.get(0);
            if (sop.equals("sent")) {
                if (!success) {
                    if (!MimopayActivity.this.isActivityFinishing()) {
                        Toast.makeText(MimopayActivity.this.getApplicationContext(), "Gagal mengirim SMS", 1).show();
                        return;
                    }
                    return;
                }
                String stitle = "";
                final String smsmessage = alsSms.get(1);
                final String dstphonenum = alsSms.get(2);
                if (MimopayStuff.sChannel.equals("upoint")) {
                    stitle = "UPoint";
                } else if (MimopayStuff.sChannel.equals("xl_airtime")) {
                    stitle = "XL";
                }
                if (!MimopayActivity.this.isActivityFinishing()) {
                    MimopayActivity.this.runOnUiThread(new Runnable() { // from class: com.mimopay.MimopayActivity.MimopayActivityCore.9
                        @Override // java.lang.Runnable
                        public void run() {
                            MimopayActivity.this.setupAlertDialog("SMS telah terkirim. Anda segera akan mendapatkan SMS balasan", "Selesai", null, new MimopayInterface() { // from class: com.mimopay.MimopayActivity.MimopayActivityCore.9.1
                                @Override // com.mimopay.MimopayInterface
                                public void onReturn(String info, ArrayList<String> params) {
                                    MimopayActivity.this.mInfoResult = "Success";
                                    MimopayActivity.this.mAlsResult = new ArrayList();
                                    MimopayActivity.this.mAlsResult.add(MimopayActivity.this.mCore.alsBtnAction.get(MimopayActivity.this.mCore.mAlsActiveIdx));
                                    MimopayActivity.this.mAlsResult.add(smsmessage);
                                    MimopayActivity.this.mAlsResult.add(dstphonenum);
                                    if (MimopayStuff.sChannel.equals("xl_airtime")) {
                                        MimopayActivity.this.mAlsResult.add(MimopayActivity.this.mXLReferenceId);
                                    }
                                    MimopayActivity.this.mAlsResult.add(MimopayActivity.this.mCore.mHttppostPhoneNumber);
                                    MimopayActivity.this.finish();
                                }
                            });
                        }
                    });
                    return;
                }
                return;
            }
            if (sop.equals("read")) {
                MimopayActivity.this.processXLRepliedSMS(success, alsSms.get(1));
            }
        }
    }

    @Override // android.app.Activity
    protected void onStart() {
        super.onStart();
        jprintf("MimopayActivity:onStart");
    }

    @Override // android.app.Activity
    protected void onStop() {
        super.onStop();
        jprintf("MimopayActivity:onStop");
    }

    @Override // android.app.Activity
    protected void onResume() {
        super.onResume();
        jprintf("MimopayActivity:onResume");
    }

    @Override // android.app.Activity
    protected void onPause() {
        super.onPause();
        jprintf("MimopayActivity:onPause");
    }

    @Override // android.app.Activity
    protected void onDestroy() {
        super.onDestroy();
        jprintf("MimopayActivity:onDestroy");
        if (Mimopay.mMi != null) {
            if (this.mInfoResult.equals("_recreate")) {
                this.mInfoResult = NativeProtocol.ERROR_USER_CANCELED;
            } else {
                Mimopay.mMi.onReturn(this.mInfoResult, this.mAlsResult);
            }
        }
    }

    private Bitmap getRoundedCornerBitmap(Bitmap bitmap, int bkgndcolor) {
        Bitmap output;
        if (bitmap != null && (output = Bitmap.createBitmap(bitmap.getWidth(), bitmap.getHeight(), Bitmap.Config.ARGB_8888)) != null) {
            Canvas canvas = new Canvas(output);
            Paint paint = new Paint();
            Rect rect = new Rect(0, 0, bitmap.getWidth(), bitmap.getHeight());
            RectF rectF = new RectF(rect);
            paint.setAntiAlias(true);
            canvas.drawARGB(0, 0, 0, 0);
            paint.setColor(bkgndcolor);
            canvas.drawRoundRect(rectF, 8.0f, 8.0f, paint);
            paint.setXfermode(new PorterDuffXfermode(PorterDuff.Mode.SRC_IN));
            canvas.drawBitmap(bitmap, rect, rect, paint);
            return output;
        }
        return null;
    }

    private Bitmap getInverted(Bitmap src) {
        Bitmap output;
        if (src == null || (output = Bitmap.createBitmap(src.getWidth(), src.getHeight(), src.getConfig())) == null) {
            return null;
        }
        int height = src.getHeight();
        int width = src.getWidth();
        for (int y = 0; y < height; y++) {
            for (int x = 0; x < width; x++) {
                int pixelColor = src.getPixel(x, y);
                int A = Color.alpha(pixelColor);
                int R = MotionEventCompat.ACTION_MASK - Color.red(pixelColor);
                int G = MotionEventCompat.ACTION_MASK - Color.green(pixelColor);
                int B = MotionEventCompat.ACTION_MASK - Color.blue(pixelColor);
                output.setPixel(x, y, Color.argb(A, R, G, B));
            }
        }
        return output;
    }
}
