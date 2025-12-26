package com.google.android.gms.maps;

import android.app.Activity;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.os.RemoteException;
import android.support.v4.app.Fragment;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import com.google.android.gms.common.GooglePlayServicesNotAvailableException;
import com.google.android.gms.dynamic.LifecycleDelegate;
import com.google.android.gms.dynamic.c;
import com.google.android.gms.dynamic.d;
import com.google.android.gms.internal.s;
import com.google.android.gms.maps.internal.IGoogleMapDelegate;
import com.google.android.gms.maps.internal.IMapFragmentDelegate;
import com.google.android.gms.maps.internal.o;
import com.google.android.gms.maps.internal.p;
import com.google.android.gms.maps.model.RuntimeRemoteException;
import java.security.cert.CertificateException;

/* loaded from: classes.dex */
public class SupportMapFragment extends Fragment {
    private final b gK = new b(this);
    private GoogleMap gz;

    static class a implements LifecycleDelegate {
        private final IMapFragmentDelegate gB;
        private final Fragment gL;

        public a(Fragment fragment, IMapFragmentDelegate iMapFragmentDelegate) {
            this.gB = (IMapFragmentDelegate) s.d(iMapFragmentDelegate);
            this.gL = (Fragment) s.d(fragment);
        }

        public IMapFragmentDelegate bh() {
            return this.gB;
        }

        @Override // com.google.android.gms.dynamic.LifecycleDelegate
        public void onCreate(Bundle savedInstanceState) {
            if (savedInstanceState == null) {
                try {
                    savedInstanceState = new Bundle();
                } catch (RemoteException e) {
                    throw new RuntimeRemoteException(e);
                }
            }
            Bundle arguments = this.gL.getArguments();
            if (arguments != null && arguments.containsKey("MapOptions")) {
                o.a(savedInstanceState, "MapOptions", arguments.getParcelable("MapOptions"));
            }
            this.gB.onCreate(savedInstanceState);
        }

        @Override // com.google.android.gms.dynamic.LifecycleDelegate
        public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
            try {
                return (View) c.a(this.gB.onCreateView(c.f(inflater), c.f(container), savedInstanceState));
            } catch (RemoteException e) {
                throw new RuntimeRemoteException(e);
            }
        }

        @Override // com.google.android.gms.dynamic.LifecycleDelegate
        public void onDestroy() {
            try {
                this.gB.onDestroy();
            } catch (RemoteException e) {
                throw new RuntimeRemoteException(e);
            }
        }

        @Override // com.google.android.gms.dynamic.LifecycleDelegate
        public void onDestroyView() {
            try {
                this.gB.onDestroyView();
            } catch (RemoteException e) {
                throw new RuntimeRemoteException(e);
            }
        }

        @Override // com.google.android.gms.dynamic.LifecycleDelegate
        public void onInflate(Activity activity, Bundle attrs, Bundle savedInstanceState) {
            try {
                this.gB.onInflate(c.f(activity), (GoogleMapOptions) attrs.getParcelable("MapOptions"), savedInstanceState);
            } catch (RemoteException e) {
                throw new RuntimeRemoteException(e);
            }
        }

        @Override // com.google.android.gms.dynamic.LifecycleDelegate
        public void onLowMemory() {
            try {
                this.gB.onLowMemory();
            } catch (RemoteException e) {
                throw new RuntimeRemoteException(e);
            }
        }

        @Override // com.google.android.gms.dynamic.LifecycleDelegate
        public void onPause() {
            try {
                this.gB.onPause();
            } catch (RemoteException e) {
                throw new RuntimeRemoteException(e);
            }
        }

        @Override // com.google.android.gms.dynamic.LifecycleDelegate
        public void onResume() {
            try {
                this.gB.onResume();
            } catch (RemoteException e) {
                throw new RuntimeRemoteException(e);
            }
        }

        @Override // com.google.android.gms.dynamic.LifecycleDelegate
        public void onSaveInstanceState(Bundle outState) {
            try {
                this.gB.onSaveInstanceState(outState);
            } catch (RemoteException e) {
                throw new RuntimeRemoteException(e);
            }
        }
    }

    static class b extends com.google.android.gms.dynamic.a<a> {
        private Activity bm;
        protected d<a> gC;
        private final Fragment gL;

        b(Fragment fragment) {
            this.gL = fragment;
        }

        /* JADX INFO: Access modifiers changed from: private */
        public void setActivity(Activity activity) throws PackageManager.NameNotFoundException, CertificateException {
            this.bm = activity;
            bi();
        }

        @Override // com.google.android.gms.dynamic.a
        protected void a(d<a> dVar) throws PackageManager.NameNotFoundException, CertificateException {
            this.gC = dVar;
            bi();
        }

        public void bi() throws PackageManager.NameNotFoundException, CertificateException {
            if (this.bm == null || this.gC == null || at() != null) {
                return;
            }
            try {
                MapsInitializer.initialize(this.bm);
                this.gC.a(new a(this.gL, p.i(this.bm).d(c.f(this.bm))));
            } catch (RemoteException e) {
                throw new RuntimeRemoteException(e);
            } catch (GooglePlayServicesNotAvailableException e2) {
            }
        }
    }

    public static SupportMapFragment newInstance() {
        return new SupportMapFragment();
    }

    public static SupportMapFragment newInstance(GoogleMapOptions options) {
        SupportMapFragment supportMapFragment = new SupportMapFragment();
        Bundle bundle = new Bundle();
        bundle.putParcelable("MapOptions", options);
        supportMapFragment.setArguments(bundle);
        return supportMapFragment;
    }

    protected IMapFragmentDelegate bh() throws PackageManager.NameNotFoundException, CertificateException {
        this.gK.bi();
        if (this.gK.at() == null) {
            return null;
        }
        return this.gK.at().bh();
    }

    public final GoogleMap getMap() throws PackageManager.NameNotFoundException, CertificateException {
        IMapFragmentDelegate iMapFragmentDelegateBh = bh();
        if (iMapFragmentDelegateBh == null) {
            return null;
        }
        try {
            IGoogleMapDelegate map = iMapFragmentDelegateBh.getMap();
            if (map == null) {
                return null;
            }
            if (this.gz == null || this.gz.aY().asBinder() != map.asBinder()) {
                this.gz = new GoogleMap(map);
            }
            return this.gz;
        } catch (RemoteException e) {
            throw new RuntimeRemoteException(e);
        }
    }

    @Override // android.support.v4.app.Fragment
    public void onActivityCreated(Bundle savedInstanceState) {
        if (savedInstanceState != null) {
            savedInstanceState.setClassLoader(SupportMapFragment.class.getClassLoader());
        }
        super.onActivityCreated(savedInstanceState);
    }

    @Override // android.support.v4.app.Fragment
    public void onAttach(Activity activity) throws PackageManager.NameNotFoundException, CertificateException {
        super.onAttach(activity);
        this.gK.setActivity(activity);
    }

    @Override // android.support.v4.app.Fragment
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        this.gK.onCreate(savedInstanceState);
    }

    @Override // android.support.v4.app.Fragment
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        return this.gK.onCreateView(inflater, container, savedInstanceState);
    }

    @Override // android.support.v4.app.Fragment
    public void onDestroy() {
        this.gK.onDestroy();
        super.onDestroy();
    }

    @Override // android.support.v4.app.Fragment
    public void onDestroyView() {
        this.gK.onDestroyView();
        super.onDestroyView();
    }

    @Override // android.support.v4.app.Fragment
    public void onInflate(Activity activity, AttributeSet attrs, Bundle savedInstanceState) throws PackageManager.NameNotFoundException, CertificateException {
        super.onInflate(activity, attrs, savedInstanceState);
        this.gK.setActivity(activity);
        GoogleMapOptions googleMapOptionsCreateFromAttributes = GoogleMapOptions.createFromAttributes(activity, attrs);
        Bundle bundle = new Bundle();
        bundle.putParcelable("MapOptions", googleMapOptionsCreateFromAttributes);
        this.gK.onInflate(activity, bundle, savedInstanceState);
    }

    @Override // android.support.v4.app.Fragment, android.content.ComponentCallbacks
    public void onLowMemory() {
        this.gK.onLowMemory();
        super.onLowMemory();
    }

    @Override // android.support.v4.app.Fragment
    public void onPause() {
        this.gK.onPause();
        super.onPause();
    }

    @Override // android.support.v4.app.Fragment
    public void onResume() {
        super.onResume();
        this.gK.onResume();
    }

    @Override // android.support.v4.app.Fragment
    public void onSaveInstanceState(Bundle outState) {
        if (outState != null) {
            outState.setClassLoader(SupportMapFragment.class.getClassLoader());
        }
        super.onSaveInstanceState(outState);
        this.gK.onSaveInstanceState(outState);
    }

    @Override // android.support.v4.app.Fragment
    public void setArguments(Bundle args) {
        super.setArguments(args);
    }
}
