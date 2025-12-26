package com.google.android.gms.plus;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.res.Resources;
import android.util.AttributeSet;
import android.view.View;
import android.widget.FrameLayout;
import com.google.android.gms.internal.bu;
import com.google.android.gms.internal.s;
import com.google.android.gms.internal.v;

/* loaded from: classes.dex */
public final class PlusOneButton extends FrameLayout {
    public static final int ANNOTATION_BUBBLE = 1;
    public static final int ANNOTATION_INLINE = 2;
    public static final int ANNOTATION_NONE = 0;
    public static final int DEFAULT_ACTIVITY_REQUEST_CODE = -1;
    public static final int SIZE_MEDIUM = 1;
    public static final int SIZE_SMALL = 0;
    public static final int SIZE_STANDARD = 3;
    public static final int SIZE_TALL = 2;
    private int O;
    private View ic;
    private int id;
    private String ie;

    /* renamed from: if, reason: not valid java name */
    private int f1if;
    private OnPlusOneClickListener ig;

    protected class DefaultOnPlusOneClickListener implements View.OnClickListener, OnPlusOneClickListener {
        private final OnPlusOneClickListener ih;

        public DefaultOnPlusOneClickListener(OnPlusOneClickListener proxy) {
            this.ih = proxy;
        }

        @Override // android.view.View.OnClickListener
        public void onClick(View view) {
            Intent intent = (Intent) PlusOneButton.this.ic.getTag();
            if (this.ih != null) {
                this.ih.onPlusOneClick(intent);
            } else {
                onPlusOneClick(intent);
            }
        }

        @Override // com.google.android.gms.plus.PlusOneButton.OnPlusOneClickListener
        public void onPlusOneClick(Intent intent) {
            Context context = PlusOneButton.this.getContext();
            if (!(context instanceof Activity) || intent == null) {
                return;
            }
            ((Activity) context).startActivityForResult(intent, PlusOneButton.this.f1if);
        }
    }

    public interface OnPlusOneClickListener {
        void onPlusOneClick(Intent intent);
    }

    public PlusOneButton(Context context) {
        this(context, null);
    }

    public PlusOneButton(Context context, AttributeSet attrs) {
        super(context, attrs);
        this.O = getSize(context, attrs);
        this.id = getAnnotation(context, attrs);
        this.f1if = -1;
        d(getContext());
        if (isInEditMode()) {
        }
    }

    private void d(Context context) {
        if (this.ic != null) {
            removeView(this.ic);
        }
        this.ic = bu.a(context, this.O, this.id, this.ie, this.f1if);
        setOnPlusOneClickListener(this.ig);
        addView(this.ic);
    }

    protected static int getAnnotation(Context context, AttributeSet attrs) throws Resources.NotFoundException {
        String strA = v.a("http://schemas.android.com/apk/lib/com.google.android.gms.plus", "annotation", context, attrs, true, false, "PlusOneButton");
        if ("INLINE".equalsIgnoreCase(strA)) {
            return 2;
        }
        return "NONE".equalsIgnoreCase(strA) ? 0 : 1;
    }

    protected static int getSize(Context context, AttributeSet attrs) throws Resources.NotFoundException {
        String strA = v.a("http://schemas.android.com/apk/lib/com.google.android.gms.plus", "size", context, attrs, true, false, "PlusOneButton");
        if ("SMALL".equalsIgnoreCase(strA)) {
            return 0;
        }
        if ("MEDIUM".equalsIgnoreCase(strA)) {
            return 1;
        }
        return "TALL".equalsIgnoreCase(strA) ? 2 : 3;
    }

    public void initialize(String url, int activityRequestCode) {
        s.a(getContext() instanceof Activity, "To use this method, the PlusOneButton must be placed in an Activity. Use initialize(PlusClient, String, OnPlusOneClickListener).");
        this.ie = url;
        this.f1if = activityRequestCode;
        d(getContext());
    }

    public void initialize(String url, OnPlusOneClickListener plusOneClickListener) {
        this.ie = url;
        this.f1if = 0;
        d(getContext());
        setOnPlusOneClickListener(plusOneClickListener);
    }

    @Override // android.widget.FrameLayout, android.view.ViewGroup, android.view.View
    protected void onLayout(boolean changed, int left, int top, int right, int bottom) {
        this.ic.layout(0, 0, right - left, bottom - top);
    }

    @Override // android.widget.FrameLayout, android.view.View
    protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
        View view = this.ic;
        measureChild(view, widthMeasureSpec, heightMeasureSpec);
        setMeasuredDimension(view.getMeasuredWidth(), view.getMeasuredHeight());
    }

    public void setAnnotation(int annotation) {
        this.id = annotation;
        d(getContext());
    }

    public void setOnPlusOneClickListener(OnPlusOneClickListener listener) {
        this.ig = listener;
        this.ic.setOnClickListener(new DefaultOnPlusOneClickListener(listener));
    }

    public void setSize(int size) {
        this.O = size;
        d(getContext());
    }
}
