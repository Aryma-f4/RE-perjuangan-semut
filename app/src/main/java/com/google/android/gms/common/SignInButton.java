package com.google.android.gms.common;

import android.content.Context;
import android.util.AttributeSet;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.FrameLayout;
import com.google.android.gms.dynamic.e;
import com.google.android.gms.internal.s;
import com.google.android.gms.internal.t;
import com.google.android.gms.internal.u;

/* loaded from: classes.dex */
public final class SignInButton extends FrameLayout implements View.OnClickListener {
    public static final int COLOR_DARK = 0;
    public static final int COLOR_LIGHT = 1;
    public static final int SIZE_ICON_ONLY = 2;
    public static final int SIZE_STANDARD = 0;
    public static final int SIZE_WIDE = 1;
    private int O;
    private int P;
    private View Q;
    private View.OnClickListener R;

    public SignInButton(Context context) {
        this(context, null);
    }

    public SignInButton(Context context, AttributeSet attrs) {
        this(context, attrs, 0);
    }

    public SignInButton(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
        this.R = null;
        setStyle(0, 0);
    }

    private static Button c(Context context, int i, int i2) {
        u uVar = new u(context);
        uVar.a(context.getResources(), i, i2);
        return uVar;
    }

    private void d(Context context) {
        if (this.Q != null) {
            removeView(this.Q);
        }
        try {
            this.Q = t.d(context, this.O, this.P);
        } catch (e.a e) {
            Log.w("SignInButton", "Sign in button not found, using placeholder instead");
            this.Q = c(context, this.O, this.P);
        }
        addView(this.Q);
        this.Q.setEnabled(isEnabled());
        this.Q.setOnClickListener(this);
    }

    @Override // android.view.View.OnClickListener
    public void onClick(View view) {
        if (this.R == null || view != this.Q) {
            return;
        }
        this.R.onClick(this);
    }

    public void setColorScheme(int colorScheme) {
        setStyle(this.O, colorScheme);
    }

    @Override // android.view.View
    public void setEnabled(boolean enabled) {
        super.setEnabled(enabled);
        this.Q.setEnabled(enabled);
    }

    @Override // android.view.View
    public void setOnClickListener(View.OnClickListener listener) {
        this.R = listener;
        if (this.Q != null) {
            this.Q.setOnClickListener(this);
        }
    }

    public void setSize(int buttonSize) {
        setStyle(buttonSize, this.P);
    }

    public void setStyle(int buttonSize, int colorScheme) {
        s.a(buttonSize >= 0 && buttonSize < 3, "Unknown button size " + buttonSize);
        s.a(colorScheme >= 0 && colorScheme < 2, "Unknown color scheme " + colorScheme);
        this.O = buttonSize;
        this.P = colorScheme;
        d(getContext());
    }
}
