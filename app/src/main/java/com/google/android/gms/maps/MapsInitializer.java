package com.google.android.gms.maps;

import android.content.Context;
import android.content.pm.PackageManager;
import android.os.RemoteException;
import com.google.android.gms.common.GooglePlayServicesNotAvailableException;
import com.google.android.gms.internal.s;
import com.google.android.gms.maps.internal.c;
import com.google.android.gms.maps.internal.p;
import com.google.android.gms.maps.model.BitmapDescriptorFactory;
import com.google.android.gms.maps.model.RuntimeRemoteException;
import java.security.cert.CertificateException;

/* loaded from: classes.dex */
public final class MapsInitializer {
    private MapsInitializer() {
    }

    public static void initialize(Context context) throws GooglePlayServicesNotAvailableException, PackageManager.NameNotFoundException, CertificateException {
        s.d(context);
        c cVarI = p.i(context);
        try {
            CameraUpdateFactory.a(cVarI.bk());
            BitmapDescriptorFactory.a(cVarI.bl());
        } catch (RemoteException e) {
            throw new RuntimeRemoteException(e);
        }
    }
}
