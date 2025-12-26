package com.google.android.gms.dynamic;

import android.app.Activity;
import android.content.Context;
import android.content.pm.PackageManager;
import android.content.res.Resources;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.widget.TextView;
import com.google.android.gms.common.GooglePlayServicesUtil;
import com.google.android.gms.dynamic.LifecycleDelegate;
import java.security.cert.CertificateException;
import java.util.Iterator;
import java.util.LinkedList;

/* loaded from: classes.dex */
public abstract class a<T extends LifecycleDelegate> {
    private T cP;
    private Bundle cQ;
    private LinkedList<InterfaceC0004a> cR;
    private final d<T> cS = (d<T>) new d<T>() { // from class: com.google.android.gms.dynamic.a.1
        @Override // com.google.android.gms.dynamic.d
        public void a(T t) {
            a.this.cP = t;
            Iterator it = a.this.cR.iterator();
            while (it.hasNext()) {
                ((InterfaceC0004a) it.next()).b(a.this.cP);
            }
            a.this.cR.clear();
            a.this.cQ = null;
        }
    };

    /* renamed from: com.google.android.gms.dynamic.a$a, reason: collision with other inner class name */
    private interface InterfaceC0004a {
        void b(LifecycleDelegate lifecycleDelegate);

        int getState();
    }

    private void a(Bundle bundle, InterfaceC0004a interfaceC0004a) {
        if (this.cP != null) {
            interfaceC0004a.b(this.cP);
            return;
        }
        if (this.cR == null) {
            this.cR = new LinkedList<>();
        }
        this.cR.add(interfaceC0004a);
        if (bundle != null) {
            if (this.cQ == null) {
                this.cQ = (Bundle) bundle.clone();
            } else {
                this.cQ.putAll(bundle);
            }
        }
        a(this.cS);
    }

    private void y(int i) {
        while (!this.cR.isEmpty() && this.cR.getLast().getState() >= i) {
            this.cR.removeLast();
        }
    }

    public void a(FrameLayout frameLayout) throws Resources.NotFoundException, PackageManager.NameNotFoundException, CertificateException {
        final Context context = frameLayout.getContext();
        final int iIsGooglePlayServicesAvailable = GooglePlayServicesUtil.isGooglePlayServicesAvailable(context);
        String strB = GooglePlayServicesUtil.b(context, iIsGooglePlayServicesAvailable, -1);
        String strA = GooglePlayServicesUtil.a(context, iIsGooglePlayServicesAvailable);
        LinearLayout linearLayout = new LinearLayout(frameLayout.getContext());
        linearLayout.setOrientation(1);
        linearLayout.setLayoutParams(new FrameLayout.LayoutParams(-2, -2));
        frameLayout.addView(linearLayout);
        TextView textView = new TextView(frameLayout.getContext());
        textView.setLayoutParams(new FrameLayout.LayoutParams(-2, -2));
        textView.setText(strB);
        linearLayout.addView(textView);
        if (strA != null) {
            Button button = new Button(context);
            button.setLayoutParams(new FrameLayout.LayoutParams(-2, -2));
            button.setText(strA);
            linearLayout.addView(button);
            button.setOnClickListener(new View.OnClickListener() { // from class: com.google.android.gms.dynamic.a.5
                @Override // android.view.View.OnClickListener
                public void onClick(View v) {
                    context.startActivity(GooglePlayServicesUtil.a(context, iIsGooglePlayServicesAvailable, -1));
                }
            });
        }
    }

    protected abstract void a(d<T> dVar);

    public T at() {
        return this.cP;
    }

    public void onCreate(final Bundle savedInstanceState) {
        a(savedInstanceState, new InterfaceC0004a() { // from class: com.google.android.gms.dynamic.a.3
            @Override // com.google.android.gms.dynamic.a.InterfaceC0004a
            public void b(LifecycleDelegate lifecycleDelegate) {
                a.this.cP.onCreate(savedInstanceState);
            }

            @Override // com.google.android.gms.dynamic.a.InterfaceC0004a
            public int getState() {
                return 1;
            }
        });
    }

    public View onCreateView(final LayoutInflater inflater, final ViewGroup container, final Bundle savedInstanceState) throws Resources.NotFoundException, PackageManager.NameNotFoundException, CertificateException {
        final FrameLayout frameLayout = new FrameLayout(inflater.getContext());
        a(savedInstanceState, new InterfaceC0004a() { // from class: com.google.android.gms.dynamic.a.4
            @Override // com.google.android.gms.dynamic.a.InterfaceC0004a
            public void b(LifecycleDelegate lifecycleDelegate) {
                frameLayout.removeAllViews();
                frameLayout.addView(a.this.cP.onCreateView(inflater, container, savedInstanceState));
            }

            @Override // com.google.android.gms.dynamic.a.InterfaceC0004a
            public int getState() {
                return 2;
            }
        });
        if (this.cP == null) {
            a(frameLayout);
        }
        return frameLayout;
    }

    public void onDestroy() {
        if (this.cP != null) {
            this.cP.onDestroy();
        } else {
            y(1);
        }
    }

    public void onDestroyView() {
        if (this.cP != null) {
            this.cP.onDestroyView();
        } else {
            y(2);
        }
    }

    public void onInflate(final Activity activity, final Bundle attrs, final Bundle savedInstanceState) {
        a(savedInstanceState, new InterfaceC0004a() { // from class: com.google.android.gms.dynamic.a.2
            @Override // com.google.android.gms.dynamic.a.InterfaceC0004a
            public void b(LifecycleDelegate lifecycleDelegate) {
                a.this.cP.onInflate(activity, attrs, savedInstanceState);
            }

            @Override // com.google.android.gms.dynamic.a.InterfaceC0004a
            public int getState() {
                return 0;
            }
        });
    }

    public void onLowMemory() {
        if (this.cP != null) {
            this.cP.onLowMemory();
        }
    }

    public void onPause() {
        if (this.cP != null) {
            this.cP.onPause();
        } else {
            y(3);
        }
    }

    public void onResume() {
        a((Bundle) null, new InterfaceC0004a() { // from class: com.google.android.gms.dynamic.a.6
            @Override // com.google.android.gms.dynamic.a.InterfaceC0004a
            public void b(LifecycleDelegate lifecycleDelegate) {
                a.this.cP.onResume();
            }

            @Override // com.google.android.gms.dynamic.a.InterfaceC0004a
            public int getState() {
                return 3;
            }
        });
    }

    public void onSaveInstanceState(Bundle outState) {
        if (this.cP != null) {
            this.cP.onSaveInstanceState(outState);
        } else if (this.cQ != null) {
            outState.putAll(this.cQ);
        }
    }
}
