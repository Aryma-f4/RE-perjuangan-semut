package com.google.android.gms.plus;

import android.R;
import android.content.Context;
import android.content.pm.PackageManager;
import android.content.res.Resources;
import android.graphics.Point;
import android.graphics.drawable.Drawable;
import android.util.DisplayMetrics;
import android.util.TypedValue;
import android.widget.Button;
import android.widget.FrameLayout;
import com.google.android.gms.common.GooglePlayServicesUtil;

/* loaded from: classes.dex */
public class PlusOneDummyView extends FrameLayout {
    public static final String TAG = "PlusOneDummyView";

    private static class a implements d {
        private Context mContext;

        private a(Context context) {
            this.mContext = context;
        }

        @Override // com.google.android.gms.plus.PlusOneDummyView.d
        public Drawable getDrawable(int size) {
            return this.mContext.getResources().getDrawable(R.drawable.btn_default);
        }

        @Override // com.google.android.gms.plus.PlusOneDummyView.d
        public boolean isValid() {
            return true;
        }
    }

    private static class b implements d {
        private Context mContext;

        private b(Context context) {
            this.mContext = context;
        }

        @Override // com.google.android.gms.plus.PlusOneDummyView.d
        public Drawable getDrawable(int size) {
            String str;
            try {
                Resources resources = this.mContext.createPackageContext(GooglePlayServicesUtil.GOOGLE_PLAY_SERVICES_PACKAGE, 4).getResources();
                switch (size) {
                    case 0:
                        str = "ic_plusone_small";
                        break;
                    case 1:
                        str = "ic_plusone_medium";
                        break;
                    case 2:
                        str = "ic_plusone_tall";
                        break;
                    default:
                        str = "ic_plusone_standard";
                        break;
                }
                return resources.getDrawable(resources.getIdentifier(str, "drawable", GooglePlayServicesUtil.GOOGLE_PLAY_SERVICES_PACKAGE));
            } catch (PackageManager.NameNotFoundException e) {
                return null;
            }
        }

        @Override // com.google.android.gms.plus.PlusOneDummyView.d
        public boolean isValid() {
            try {
                this.mContext.createPackageContext(GooglePlayServicesUtil.GOOGLE_PLAY_SERVICES_PACKAGE, 4).getResources();
                return true;
            } catch (PackageManager.NameNotFoundException e) {
                return false;
            }
        }
    }

    private static class c implements d {
        private Context mContext;

        private c(Context context) {
            this.mContext = context;
        }

        @Override // com.google.android.gms.plus.PlusOneDummyView.d
        public Drawable getDrawable(int size) {
            String str;
            switch (size) {
                case 0:
                    str = "ic_plusone_small_off_client";
                    break;
                case 1:
                    str = "ic_plusone_medium_off_client";
                    break;
                case 2:
                    str = "ic_plusone_tall_off_client";
                    break;
                default:
                    str = "ic_plusone_standard_off_client";
                    break;
            }
            return this.mContext.getResources().getDrawable(this.mContext.getResources().getIdentifier(str, "drawable", this.mContext.getPackageName()));
        }

        @Override // com.google.android.gms.plus.PlusOneDummyView.d
        public boolean isValid() {
            return (this.mContext.getResources().getIdentifier("ic_plusone_small_off_client", "drawable", this.mContext.getPackageName()) == 0 || this.mContext.getResources().getIdentifier("ic_plusone_medium_off_client", "drawable", this.mContext.getPackageName()) == 0 || this.mContext.getResources().getIdentifier("ic_plusone_tall_off_client", "drawable", this.mContext.getPackageName()) == 0 || this.mContext.getResources().getIdentifier("ic_plusone_standard_off_client", "drawable", this.mContext.getPackageName()) == 0) ? false : true;
        }
    }

    private interface d {
        Drawable getDrawable(int i);

        boolean isValid();
    }

    public PlusOneDummyView(Context context, int size) {
        super(context);
        Button button = new Button(context);
        button.setEnabled(false);
        button.setBackgroundDrawable(bx().getDrawable(size));
        Point pointT = T(size);
        addView(button, new FrameLayout.LayoutParams(pointT.x, pointT.y, 17));
    }

    private Point T(int i) {
        int i2;
        int i3;
        Point point = new Point();
        switch (i) {
            case 0:
                i3 = 14;
                i2 = 24;
                break;
            case 1:
                i2 = 32;
                i3 = 20;
                break;
            case 2:
                i2 = 50;
                i3 = 20;
                break;
            default:
                i2 = 38;
                i3 = 24;
                break;
        }
        DisplayMetrics displayMetrics = getResources().getDisplayMetrics();
        float fApplyDimension = TypedValue.applyDimension(1, i2, displayMetrics);
        float fApplyDimension2 = TypedValue.applyDimension(1, i3, displayMetrics);
        point.x = (int) (fApplyDimension + 0.5d);
        point.y = (int) (fApplyDimension2 + 0.5d);
        return point;
    }

    private d bx() {
        d bVar = new b(getContext());
        if (!bVar.isValid()) {
            bVar = new c(getContext());
        }
        return !bVar.isValid() ? new a(getContext()) : bVar;
    }
}
