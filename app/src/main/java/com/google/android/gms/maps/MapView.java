package com.google.android.gms.maps;

import android.app.Activity;
import android.content.Context;
import android.os.Bundle;
import android.os.RemoteException;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;
import com.google.android.gms.common.GooglePlayServicesNotAvailableException;
import com.google.android.gms.dynamic.LifecycleDelegate;
import com.google.android.gms.dynamic.c;
import com.google.android.gms.dynamic.d;
import com.google.android.gms.internal.s;
import com.google.android.gms.maps.internal.IMapViewDelegate;
import com.google.android.gms.maps.internal.p;
import com.google.android.gms.maps.model.RuntimeRemoteException;

/* loaded from: classes.dex */
public class MapView extends FrameLayout {
    private final b gD;
    private GoogleMap gz;

    static class a implements LifecycleDelegate {
        private final ViewGroup gE;
        private final IMapViewDelegate gF;
        private View gG;

        public a(ViewGroup viewGroup, IMapViewDelegate iMapViewDelegate) {
            this.gF = (IMapViewDelegate) s.d(iMapViewDelegate);
            this.gE = (ViewGroup) s.d(viewGroup);
        }

        public IMapViewDelegate bj() {
            return this.gF;
        }

        @Override // com.google.android.gms.dynamic.LifecycleDelegate
        public void onCreate(Bundle savedInstanceState) {
            try {
                this.gF.onCreate(savedInstanceState);
                this.gG = (View) c.a(this.gF.getView());
                this.gE.removeAllViews();
                this.gE.addView(this.gG);
            } catch (RemoteException e) {
                throw new RuntimeRemoteException(e);
            }
        }

        @Override // com.google.android.gms.dynamic.LifecycleDelegate
        public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
            throw new UnsupportedOperationException("onCreateView not allowed on MapViewDelegate");
        }

        @Override // com.google.android.gms.dynamic.LifecycleDelegate
        public void onDestroy() {
            try {
                this.gF.onDestroy();
            } catch (RemoteException e) {
                throw new RuntimeRemoteException(e);
            }
        }

        @Override // com.google.android.gms.dynamic.LifecycleDelegate
        public void onDestroyView() {
            throw new UnsupportedOperationException("onDestroyView not allowed on MapViewDelegate");
        }

        @Override // com.google.android.gms.dynamic.LifecycleDelegate
        public void onInflate(Activity activity, Bundle attrs, Bundle savedInstanceState) {
            throw new UnsupportedOperationException("onInflate not allowed on MapViewDelegate");
        }

        @Override // com.google.android.gms.dynamic.LifecycleDelegate
        public void onLowMemory() {
            try {
                this.gF.onLowMemory();
            } catch (RemoteException e) {
                throw new RuntimeRemoteException(e);
            }
        }

        @Override // com.google.android.gms.dynamic.LifecycleDelegate
        public void onPause() {
            try {
                this.gF.onPause();
            } catch (RemoteException e) {
                throw new RuntimeRemoteException(e);
            }
        }

        @Override // com.google.android.gms.dynamic.LifecycleDelegate
        public void onResume() {
            try {
                this.gF.onResume();
            } catch (RemoteException e) {
                throw new RuntimeRemoteException(e);
            }
        }

        @Override // com.google.android.gms.dynamic.LifecycleDelegate
        public void onSaveInstanceState(Bundle outState) {
            try {
                this.gF.onSaveInstanceState(outState);
            } catch (RemoteException e) {
                throw new RuntimeRemoteException(e);
            }
        }
    }

    static class b extends com.google.android.gms.dynamic.a<a> {
        protected d<a> gC;
        private final ViewGroup gH;
        private final GoogleMapOptions gI;
        private final Context mContext;

        b(ViewGroup viewGroup, Context context, GoogleMapOptions googleMapOptions) {
            this.gH = viewGroup;
            this.mContext = context;
            this.gI = googleMapOptions;
        }

        @Override // com.google.android.gms.dynamic.a
        protected void a(d<a> dVar) {
            this.gC = dVar;
            bi();
        }

        public void bi() {
            if (this.gC == null || at() != null) {
                return;
            }
            try {
                this.gC.a(new a(this.gH, p.i(this.mContext).a(c.f(this.mContext), this.gI)));
            } catch (RemoteException e) {
                throw new RuntimeRemoteException(e);
            } catch (GooglePlayServicesNotAvailableException e2) {
            }
        }
    }

    public MapView(Context context) {
        super(context);
        this.gD = new b(this, context, null);
    }

    public MapView(Context context, AttributeSet attrs) {
        super(context, attrs);
        this.gD = new b(this, context, GoogleMapOptions.createFromAttributes(context, attrs));
    }

    public MapView(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
        this.gD = new b(this, context, GoogleMapOptions.createFromAttributes(context, attrs));
    }

    public MapView(Context context, GoogleMapOptions options) {
        super(context);
        this.gD = new b(this, context, options);
    }

    public final GoogleMap getMap() {
        if (this.gz != null) {
            return this.gz;
        }
        this.gD.bi();
        if (this.gD.at() == null) {
            return null;
        }
        try {
            this.gz = new GoogleMap(this.gD.at().bj().getMap());
            return this.gz;
        } catch (RemoteException e) {
            throw new RuntimeRemoteException(e);
        }
    }

    public final void onCreate(Bundle savedInstanceState) {
        this.gD.onCreate(savedInstanceState);
        if (this.gD.at() == null) {
            this.gD.a(this);
        }
    }

    public final void onDestroy() {
        this.gD.onDestroy();
    }

    public final void onLowMemory() {
        this.gD.onLowMemory();
    }

    public final void onPause() {
        this.gD.onPause();
    }

    public final void onResume() {
        this.gD.onResume();
    }

    public final void onSaveInstanceState(Bundle outState) {
        this.gD.onSaveInstanceState(outState);
    }
}
