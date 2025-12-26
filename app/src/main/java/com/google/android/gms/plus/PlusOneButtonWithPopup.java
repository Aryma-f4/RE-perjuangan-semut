package com.google.android.gms.plus;

import android.app.PendingIntent;
import android.content.Context;
import android.os.IBinder;
import android.os.RemoteException;
import android.support.v4.widget.ExploreByTouchHelper;
import android.util.AttributeSet;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import com.google.android.gms.internal.br;
import com.google.android.gms.internal.bu;
import com.google.android.gms.internal.s;

/* loaded from: classes.dex */
public final class PlusOneButtonWithPopup extends ViewGroup {
    private int O;
    private String g;
    private View ic;
    private int id;
    private String ie;
    private View.OnClickListener ij;

    public PlusOneButtonWithPopup(Context context) {
        this(context, null);
    }

    public PlusOneButtonWithPopup(Context context, AttributeSet attrs) {
        super(context, attrs);
        this.O = PlusOneButton.getSize(context, attrs);
        this.id = PlusOneButton.getAnnotation(context, attrs);
        this.ic = new PlusOneDummyView(context, this.O);
        addView(this.ic);
    }

    private void bv() {
        if (this.ic != null) {
            removeView(this.ic);
        }
        this.ic = bu.a(getContext(), this.O, this.id, this.ie, this.g);
        if (this.ij != null) {
            setOnClickListener(this.ij);
        }
        addView(this.ic);
    }

    private br bw() throws RemoteException {
        br brVarAa = br.a.aa((IBinder) this.ic.getTag());
        if (brVarAa != null) {
            return brVarAa;
        }
        if (Log.isLoggable("PlusOneButtonWithPopup", 5)) {
            Log.w("PlusOneButtonWithPopup", "Failed to get PlusOneDelegate");
        }
        throw new RemoteException();
    }

    private int c(int i, int i2) {
        int mode = View.MeasureSpec.getMode(i);
        switch (mode) {
            case ExploreByTouchHelper.INVALID_ID /* -2147483648 */:
            case 1073741824:
                return View.MeasureSpec.makeMeasureSpec(View.MeasureSpec.getSize(i) - i2, mode);
            default:
                return i;
        }
    }

    public void cancelClick() {
        if (this.ic != null) {
            try {
                bw().cancelClick();
            } catch (RemoteException e) {
            }
        }
    }

    public PendingIntent getResolution() {
        if (this.ic != null) {
            try {
                return bw().getResolution();
            } catch (RemoteException e) {
            }
        }
        return null;
    }

    public void initialize(String url, String accountName) {
        s.b(url, "Url must not be null");
        this.ie = url;
        this.g = accountName;
        bv();
    }

    @Override // android.view.ViewGroup, android.view.View
    protected void onLayout(boolean changed, int left, int top, int right, int bottom) {
        this.ic.layout(getPaddingLeft(), getPaddingTop(), (right - left) - getPaddingRight(), (bottom - top) - getPaddingBottom());
    }

    @Override // android.view.View
    protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
        int paddingLeft = getPaddingLeft() + getPaddingRight();
        int paddingTop = getPaddingTop() + getPaddingBottom();
        this.ic.measure(c(widthMeasureSpec, paddingLeft), c(heightMeasureSpec, paddingTop));
        setMeasuredDimension(paddingLeft + this.ic.getMeasuredWidth(), paddingTop + this.ic.getMeasuredHeight());
    }

    public void reinitialize() {
        if (this.ic != null) {
            try {
                bw().reinitialize();
            } catch (RemoteException e) {
            }
        }
    }

    public void setAnnotation(int annotation) {
        this.id = annotation;
        bv();
    }

    @Override // android.view.View
    public void setOnClickListener(View.OnClickListener onClickListener) {
        this.ij = onClickListener;
        this.ic.setOnClickListener(onClickListener);
    }

    public void setSize(int size) {
        this.O = size;
        bv();
    }
}
