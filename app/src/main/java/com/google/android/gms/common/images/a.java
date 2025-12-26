package com.google.android.gms.common.images;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.widget.ImageView;
import android.widget.TextView;
import com.google.android.gms.common.images.ImageManager;
import com.google.android.gms.internal.as;
import com.google.android.gms.internal.f;
import com.google.android.gms.internal.g;
import com.google.android.gms.internal.h;
import com.google.android.gms.internal.r;
import java.lang.ref.WeakReference;

/* loaded from: classes.dex */
public final class a {
    final C0002a aG;
    private int aH;
    private int aI;
    int aJ;
    private int aK;
    private WeakReference<ImageManager.OnImageLoadedListener> aL;
    private WeakReference<ImageView> aM;
    private WeakReference<TextView> aN;
    private int aO;
    private boolean aP;
    private boolean aQ;

    /* renamed from: com.google.android.gms.common.images.a$a, reason: collision with other inner class name */
    public static final class C0002a {
        public final Uri uri;

        public C0002a(Uri uri) {
            this.uri = uri;
        }

        public boolean equals(Object obj) {
            if (!(obj instanceof C0002a)) {
                return false;
            }
            if (this != obj && ((C0002a) obj).hashCode() != hashCode()) {
                return false;
            }
            return true;
        }

        public int hashCode() {
            return r.hashCode(this.uri);
        }
    }

    public a(int i) {
        this.aH = 0;
        this.aI = 0;
        this.aO = -1;
        this.aP = true;
        this.aQ = false;
        this.aG = new C0002a(null);
        this.aI = i;
    }

    public a(Uri uri) {
        this.aH = 0;
        this.aI = 0;
        this.aO = -1;
        this.aP = true;
        this.aQ = false;
        this.aG = new C0002a(uri);
        this.aI = 0;
    }

    private f a(Drawable drawable, Drawable drawable2) {
        return new f(drawable != null ? drawable instanceof f ? ((f) drawable).r() : drawable : null, drawable2);
    }

    private void a(Drawable drawable, boolean z, boolean z2, boolean z3) {
        ImageManager.OnImageLoadedListener onImageLoadedListener;
        switch (this.aJ) {
            case 1:
                if (!z2 && (onImageLoadedListener = this.aL.get()) != null) {
                    onImageLoadedListener.onImageLoaded(this.aG.uri, drawable);
                    break;
                }
                break;
            case 2:
                ImageView imageView = this.aM.get();
                if (imageView != null) {
                    a(imageView, drawable, z, z2, z3);
                    break;
                }
                break;
            case 3:
                TextView textView = this.aN.get();
                if (textView != null) {
                    a(textView, this.aO, drawable, z, z2);
                    break;
                }
                break;
        }
    }

    private void a(ImageView imageView, Drawable drawable, boolean z, boolean z2, boolean z3) {
        boolean z4 = (z2 || z3) ? false : true;
        if (z4 && (imageView instanceof g)) {
            int iT = ((g) imageView).t();
            if (this.aI != 0 && iT == this.aI) {
                return;
            }
        }
        boolean zA = a(z, z2);
        Drawable drawableA = zA ? a(imageView.getDrawable(), drawable) : drawable;
        imageView.setImageDrawable(drawableA);
        if (imageView instanceof g) {
            g gVar = (g) imageView;
            gVar.a(z3 ? this.aG.uri : null);
            gVar.k(z4 ? this.aI : 0);
        }
        if (zA) {
            ((f) drawableA).startTransition(250);
        }
    }

    private void a(TextView textView, int i, Drawable drawable, boolean z, boolean z2) {
        boolean zA = a(z, z2);
        Drawable[] compoundDrawablesRelative = as.as() ? textView.getCompoundDrawablesRelative() : textView.getCompoundDrawables();
        Drawable drawableA = zA ? a(compoundDrawablesRelative[i], drawable) : drawable;
        Drawable drawable2 = i == 0 ? drawableA : compoundDrawablesRelative[0];
        Drawable drawable3 = i == 1 ? drawableA : compoundDrawablesRelative[1];
        Drawable drawable4 = i == 2 ? drawableA : compoundDrawablesRelative[2];
        Drawable drawable5 = i == 3 ? drawableA : compoundDrawablesRelative[3];
        if (as.as()) {
            textView.setCompoundDrawablesRelativeWithIntrinsicBounds(drawable2, drawable3, drawable4, drawable5);
        } else {
            textView.setCompoundDrawablesWithIntrinsicBounds(drawable2, drawable3, drawable4, drawable5);
        }
        if (zA) {
            ((f) drawableA).startTransition(250);
        }
    }

    private boolean a(boolean z, boolean z2) {
        return this.aP && !z2 && (!z || this.aQ);
    }

    void a(Context context, Bitmap bitmap, boolean z) {
        h.b(bitmap);
        a(new BitmapDrawable(context.getResources(), bitmap), z, false, true);
    }

    public void a(ImageView imageView) {
        h.b(imageView);
        this.aL = null;
        this.aM = new WeakReference<>(imageView);
        this.aN = null;
        this.aO = -1;
        this.aJ = 2;
        this.aK = imageView.hashCode();
    }

    public void a(ImageManager.OnImageLoadedListener onImageLoadedListener) {
        h.b(onImageLoadedListener);
        this.aL = new WeakReference<>(onImageLoadedListener);
        this.aM = null;
        this.aN = null;
        this.aO = -1;
        this.aJ = 1;
        this.aK = r.hashCode(onImageLoadedListener, this.aG);
    }

    void b(Context context, boolean z) {
        a(this.aI != 0 ? context.getResources().getDrawable(this.aI) : null, z, false, false);
    }

    public boolean equals(Object obj) {
        if (!(obj instanceof a)) {
            return false;
        }
        if (this != obj && ((a) obj).hashCode() != hashCode()) {
            return false;
        }
        return true;
    }

    void f(Context context) {
        a(this.aH != 0 ? context.getResources().getDrawable(this.aH) : null, false, true, false);
    }

    public int hashCode() {
        return this.aK;
    }

    public void j(int i) {
        this.aI = i;
    }
}
