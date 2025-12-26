package com.google.android.gms.internal;

import android.R;
import android.app.Activity;
import android.content.Context;
import android.os.Binder;
import android.os.Bundle;
import android.os.IBinder;
import android.view.Display;
import android.view.View;
import android.view.ViewTreeObserver;
import java.lang.ref.WeakReference;

/* loaded from: classes.dex */
public class ba {
    protected au dt;
    protected a ej;

    public static final class a {
        public int bottom;
        public IBinder ek;
        public int el;
        public int gravity;
        public int left;
        public int right;
        public int top;

        private a(int i, IBinder iBinder) {
            this.el = -1;
            this.left = 0;
            this.top = 0;
            this.right = 0;
            this.bottom = 0;
            this.gravity = i;
            this.ek = iBinder;
        }

        public Bundle aE() {
            Bundle bundle = new Bundle();
            bundle.putInt("popupLocationInfo.gravity", this.gravity);
            bundle.putInt("popupLocationInfo.displayId", this.el);
            bundle.putInt("popupLocationInfo.left", this.left);
            bundle.putInt("popupLocationInfo.top", this.top);
            bundle.putInt("popupLocationInfo.right", this.right);
            bundle.putInt("popupLocationInfo.bottom", this.bottom);
            return bundle;
        }
    }

    private static final class b extends ba implements View.OnAttachStateChangeListener, ViewTreeObserver.OnGlobalLayoutListener {
        private boolean dE;
        private WeakReference<View> em;

        protected b(au auVar, int i) {
            super(auVar, i);
            this.dE = false;
        }

        private void b(View view) {
            Display display;
            int displayId = (!as.as() || (display = view.getDisplay()) == null) ? -1 : display.getDisplayId();
            IBinder windowToken = view.getWindowToken();
            int[] iArr = new int[2];
            view.getLocationInWindow(iArr);
            int width = view.getWidth();
            int height = view.getHeight();
            this.ej.el = displayId;
            this.ej.ek = windowToken;
            this.ej.left = iArr[0];
            this.ej.top = iArr[1];
            this.ej.right = iArr[0] + width;
            this.ej.bottom = iArr[1] + height;
            if (this.dE) {
                aB();
                this.dE = false;
            }
        }

        @Override // com.google.android.gms.internal.ba
        protected void F(int i) {
            this.ej = new a(i, null);
        }

        @Override // com.google.android.gms.internal.ba
        public void a(View view) {
            View viewFindViewById;
            this.dt.ax();
            if (this.em != null) {
                View decorView = this.em.get();
                Context context = this.dt.getContext();
                if (decorView == null && (context instanceof Activity)) {
                    decorView = ((Activity) context).getWindow().getDecorView();
                }
                if (decorView != null) {
                    decorView.removeOnAttachStateChangeListener(this);
                    ViewTreeObserver viewTreeObserver = decorView.getViewTreeObserver();
                    if (as.ar()) {
                        viewTreeObserver.removeOnGlobalLayoutListener(this);
                    } else {
                        viewTreeObserver.removeGlobalOnLayoutListener(this);
                    }
                }
            }
            this.em = null;
            Context context2 = this.dt.getContext();
            if (view == null && (context2 instanceof Activity)) {
                viewFindViewById = ((Activity) context2).findViewById(R.id.content);
                if (viewFindViewById == null) {
                    viewFindViewById = ((Activity) context2).getWindow().getDecorView();
                }
                ax.b("PopupManager", "You have not specified a View to use as content view for popups. Falling back to the Activity content view which may not work properly in future versions of the API. Use setViewForPopups() to set your content view.");
            } else {
                viewFindViewById = view;
            }
            if (viewFindViewById == null) {
                ax.c("PopupManager", "No content view usable to display popups. Popups will not be displayed in response to this client's calls. Use setViewForPopups() to set your content view.");
                return;
            }
            b(viewFindViewById);
            this.em = new WeakReference<>(viewFindViewById);
            viewFindViewById.addOnAttachStateChangeListener(this);
            viewFindViewById.getViewTreeObserver().addOnGlobalLayoutListener(this);
        }

        @Override // com.google.android.gms.internal.ba
        public void aB() {
            if (this.ej.ek != null) {
                super.aB();
            } else {
                this.dE = this.em != null;
            }
        }

        @Override // android.view.ViewTreeObserver.OnGlobalLayoutListener
        public void onGlobalLayout() {
            View view;
            if (this.em == null || (view = this.em.get()) == null) {
                return;
            }
            b(view);
        }

        @Override // android.view.View.OnAttachStateChangeListener
        public void onViewAttachedToWindow(View v) {
            b(v);
        }

        @Override // android.view.View.OnAttachStateChangeListener
        public void onViewDetachedFromWindow(View v) {
            this.dt.ax();
            v.removeOnAttachStateChangeListener(this);
        }
    }

    private ba(au auVar, int i) {
        this.dt = auVar;
        F(i);
    }

    public static ba a(au auVar, int i) {
        return as.ao() ? new b(auVar, i) : new ba(auVar, i);
    }

    protected void F(int i) {
        this.ej = new a(i, new Binder());
    }

    public void a(View view) {
    }

    public void aB() {
        this.dt.a(this.ej.ek, this.ej.aE());
    }

    public Bundle aC() {
        return this.ej.aE();
    }

    public IBinder aD() {
        return this.ej.ek;
    }

    public void setGravity(int gravity) {
        this.ej.gravity = gravity;
    }
}
