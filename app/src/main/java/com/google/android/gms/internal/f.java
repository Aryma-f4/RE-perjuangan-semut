package com.google.android.gms.internal;

import android.graphics.Canvas;
import android.graphics.ColorFilter;
import android.graphics.Rect;
import android.graphics.drawable.Drawable;
import android.os.SystemClock;
import android.support.v4.view.MotionEventCompat;

/* loaded from: classes.dex */
public final class f extends Drawable implements Drawable.Callback {
    private boolean aP;
    private int aR;
    private long aS;
    private int aT;
    private int aU;
    private int aV;
    private int aW;
    private int aX;
    private boolean aY;
    private b aZ;
    private Drawable ba;
    private Drawable bb;
    private boolean bc;
    private boolean bd;
    private boolean be;
    private int bf;

    private static final class a extends Drawable {
        private static final a bg = new a();
        private static final C0022a bh = new C0022a();

        /* renamed from: com.google.android.gms.internal.f$a$a, reason: collision with other inner class name */
        private static final class C0022a extends Drawable.ConstantState {
            private C0022a() {
            }

            @Override // android.graphics.drawable.Drawable.ConstantState
            public int getChangingConfigurations() {
                return 0;
            }

            @Override // android.graphics.drawable.Drawable.ConstantState
            public Drawable newDrawable() {
                return a.bg;
            }
        }

        private a() {
        }

        @Override // android.graphics.drawable.Drawable
        public void draw(Canvas canvas) {
        }

        @Override // android.graphics.drawable.Drawable
        public Drawable.ConstantState getConstantState() {
            return bh;
        }

        @Override // android.graphics.drawable.Drawable
        public int getOpacity() {
            return -2;
        }

        @Override // android.graphics.drawable.Drawable
        public void setAlpha(int alpha) {
        }

        @Override // android.graphics.drawable.Drawable
        public void setColorFilter(ColorFilter cf) {
        }
    }

    static final class b extends Drawable.ConstantState {
        int bi;
        int bj;

        b(b bVar) {
            if (bVar != null) {
                this.bi = bVar.bi;
                this.bj = bVar.bj;
            }
        }

        @Override // android.graphics.drawable.Drawable.ConstantState
        public int getChangingConfigurations() {
            return this.bi;
        }

        @Override // android.graphics.drawable.Drawable.ConstantState
        public Drawable newDrawable() {
            return new f(this);
        }
    }

    public f(Drawable drawable, Drawable drawable2) {
        this(null);
        Drawable drawable3 = drawable == null ? a.bg : drawable;
        this.ba = drawable3;
        drawable3.setCallback(this);
        b bVar = this.aZ;
        bVar.bj = drawable3.getChangingConfigurations() | bVar.bj;
        Drawable drawable4 = drawable2 == null ? a.bg : drawable2;
        this.bb = drawable4;
        drawable4.setCallback(this);
        b bVar2 = this.aZ;
        bVar2.bj = drawable4.getChangingConfigurations() | bVar2.bj;
    }

    f(b bVar) {
        this.aR = 0;
        this.aV = MotionEventCompat.ACTION_MASK;
        this.aX = 0;
        this.aP = true;
        this.aZ = new b(bVar);
    }

    public boolean canConstantState() {
        if (!this.bc) {
            this.bd = (this.ba.getConstantState() == null || this.bb.getConstantState() == null) ? false : true;
            this.bc = true;
        }
        return this.bd;
    }

    @Override // android.graphics.drawable.Drawable
    public void draw(Canvas canvas) {
        boolean z;
        switch (this.aR) {
            case 1:
                this.aS = SystemClock.uptimeMillis();
                this.aR = 2;
                z = false;
                break;
            case 2:
                if (this.aS >= 0) {
                    float fUptimeMillis = (SystemClock.uptimeMillis() - this.aS) / this.aW;
                    boolean z2 = fUptimeMillis >= 1.0f;
                    if (z2) {
                        this.aR = 0;
                    }
                    this.aX = (int) ((Math.min(fUptimeMillis, 1.0f) * (this.aU - this.aT)) + this.aT);
                    z = z2;
                    break;
                }
            default:
                z = true;
                break;
        }
        int i = this.aX;
        boolean z3 = this.aP;
        Drawable drawable = this.ba;
        Drawable drawable2 = this.bb;
        if (z) {
            if (!z3 || i == 0) {
                drawable.draw(canvas);
            }
            if (i == this.aV) {
                drawable2.setAlpha(this.aV);
                drawable2.draw(canvas);
                return;
            }
            return;
        }
        if (z3) {
            drawable.setAlpha(this.aV - i);
        }
        drawable.draw(canvas);
        if (z3) {
            drawable.setAlpha(this.aV);
        }
        if (i > 0) {
            drawable2.setAlpha(i);
            drawable2.draw(canvas);
            drawable2.setAlpha(this.aV);
        }
        invalidateSelf();
    }

    @Override // android.graphics.drawable.Drawable
    public int getChangingConfigurations() {
        return super.getChangingConfigurations() | this.aZ.bi | this.aZ.bj;
    }

    @Override // android.graphics.drawable.Drawable
    public Drawable.ConstantState getConstantState() {
        if (!canConstantState()) {
            return null;
        }
        this.aZ.bi = getChangingConfigurations();
        return this.aZ;
    }

    @Override // android.graphics.drawable.Drawable
    public int getIntrinsicHeight() {
        return Math.max(this.ba.getIntrinsicHeight(), this.bb.getIntrinsicHeight());
    }

    @Override // android.graphics.drawable.Drawable
    public int getIntrinsicWidth() {
        return Math.max(this.ba.getIntrinsicWidth(), this.bb.getIntrinsicWidth());
    }

    @Override // android.graphics.drawable.Drawable
    public int getOpacity() {
        if (!this.be) {
            this.bf = Drawable.resolveOpacity(this.ba.getOpacity(), this.bb.getOpacity());
            this.be = true;
        }
        return this.bf;
    }

    @Override // android.graphics.drawable.Drawable.Callback
    public void invalidateDrawable(Drawable who) {
        Drawable.Callback callback;
        if (!as.an() || (callback = getCallback()) == null) {
            return;
        }
        callback.invalidateDrawable(this);
    }

    @Override // android.graphics.drawable.Drawable
    public Drawable mutate() {
        if (!this.aY && super.mutate() == this) {
            if (!canConstantState()) {
                throw new IllegalStateException("One or more children of this LayerDrawable does not have constant state; this drawable cannot be mutated.");
            }
            this.ba.mutate();
            this.bb.mutate();
            this.aY = true;
        }
        return this;
    }

    @Override // android.graphics.drawable.Drawable
    protected void onBoundsChange(Rect bounds) {
        this.ba.setBounds(bounds);
        this.bb.setBounds(bounds);
    }

    public Drawable r() {
        return this.bb;
    }

    @Override // android.graphics.drawable.Drawable.Callback
    public void scheduleDrawable(Drawable who, Runnable what, long when) {
        Drawable.Callback callback;
        if (!as.an() || (callback = getCallback()) == null) {
            return;
        }
        callback.scheduleDrawable(this, what, when);
    }

    @Override // android.graphics.drawable.Drawable
    public void setAlpha(int alpha) {
        if (this.aX == this.aV) {
            this.aX = alpha;
        }
        this.aV = alpha;
        invalidateSelf();
    }

    @Override // android.graphics.drawable.Drawable
    public void setColorFilter(ColorFilter cf) {
        this.ba.setColorFilter(cf);
        this.bb.setColorFilter(cf);
    }

    public void startTransition(int durationMillis) {
        this.aT = 0;
        this.aU = this.aV;
        this.aX = 0;
        this.aW = durationMillis;
        this.aR = 1;
        invalidateSelf();
    }

    @Override // android.graphics.drawable.Drawable.Callback
    public void unscheduleDrawable(Drawable who, Runnable what) {
        Drawable.Callback callback;
        if (!as.an() || (callback = getCallback()) == null) {
            return;
        }
        callback.unscheduleDrawable(this, what);
    }
}
