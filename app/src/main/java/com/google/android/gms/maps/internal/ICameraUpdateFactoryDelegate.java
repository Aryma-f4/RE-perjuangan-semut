package com.google.android.gms.maps.internal;

import android.os.Binder;
import android.os.IBinder;
import android.os.IInterface;
import android.os.Parcel;
import android.os.RemoteException;
import com.google.android.gms.dynamic.b;
import com.google.android.gms.maps.model.CameraPosition;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.LatLngBounds;

/* loaded from: classes.dex */
public interface ICameraUpdateFactoryDelegate extends IInterface {

    public static abstract class a extends Binder implements ICameraUpdateFactoryDelegate {

        /* renamed from: com.google.android.gms.maps.internal.ICameraUpdateFactoryDelegate$a$a, reason: collision with other inner class name */
        private static class C0030a implements ICameraUpdateFactoryDelegate {
            private IBinder a;

            C0030a(IBinder iBinder) {
                this.a = iBinder;
            }

            @Override // android.os.IInterface
            public IBinder asBinder() {
                return this.a;
            }

            @Override // com.google.android.gms.maps.internal.ICameraUpdateFactoryDelegate
            public com.google.android.gms.dynamic.b newCameraPosition(CameraPosition cameraPosition) throws RemoteException {
                Parcel parcelObtain = Parcel.obtain();
                Parcel parcelObtain2 = Parcel.obtain();
                try {
                    parcelObtain.writeInterfaceToken("com.google.android.gms.maps.internal.ICameraUpdateFactoryDelegate");
                    if (cameraPosition != null) {
                        parcelObtain.writeInt(1);
                        cameraPosition.writeToParcel(parcelObtain, 0);
                    } else {
                        parcelObtain.writeInt(0);
                    }
                    this.a.transact(7, parcelObtain, parcelObtain2, 0);
                    parcelObtain2.readException();
                    return b.a.l(parcelObtain2.readStrongBinder());
                } finally {
                    parcelObtain2.recycle();
                    parcelObtain.recycle();
                }
            }

            @Override // com.google.android.gms.maps.internal.ICameraUpdateFactoryDelegate
            public com.google.android.gms.dynamic.b newLatLng(LatLng latLng) throws RemoteException {
                Parcel parcelObtain = Parcel.obtain();
                Parcel parcelObtain2 = Parcel.obtain();
                try {
                    parcelObtain.writeInterfaceToken("com.google.android.gms.maps.internal.ICameraUpdateFactoryDelegate");
                    if (latLng != null) {
                        parcelObtain.writeInt(1);
                        latLng.writeToParcel(parcelObtain, 0);
                    } else {
                        parcelObtain.writeInt(0);
                    }
                    this.a.transact(8, parcelObtain, parcelObtain2, 0);
                    parcelObtain2.readException();
                    return b.a.l(parcelObtain2.readStrongBinder());
                } finally {
                    parcelObtain2.recycle();
                    parcelObtain.recycle();
                }
            }

            @Override // com.google.android.gms.maps.internal.ICameraUpdateFactoryDelegate
            public com.google.android.gms.dynamic.b newLatLngBounds(LatLngBounds bounds, int padding) throws RemoteException {
                Parcel parcelObtain = Parcel.obtain();
                Parcel parcelObtain2 = Parcel.obtain();
                try {
                    parcelObtain.writeInterfaceToken("com.google.android.gms.maps.internal.ICameraUpdateFactoryDelegate");
                    if (bounds != null) {
                        parcelObtain.writeInt(1);
                        bounds.writeToParcel(parcelObtain, 0);
                    } else {
                        parcelObtain.writeInt(0);
                    }
                    parcelObtain.writeInt(padding);
                    this.a.transact(10, parcelObtain, parcelObtain2, 0);
                    parcelObtain2.readException();
                    return b.a.l(parcelObtain2.readStrongBinder());
                } finally {
                    parcelObtain2.recycle();
                    parcelObtain.recycle();
                }
            }

            @Override // com.google.android.gms.maps.internal.ICameraUpdateFactoryDelegate
            public com.google.android.gms.dynamic.b newLatLngBoundsWithSize(LatLngBounds bounds, int width, int height, int padding) throws RemoteException {
                Parcel parcelObtain = Parcel.obtain();
                Parcel parcelObtain2 = Parcel.obtain();
                try {
                    parcelObtain.writeInterfaceToken("com.google.android.gms.maps.internal.ICameraUpdateFactoryDelegate");
                    if (bounds != null) {
                        parcelObtain.writeInt(1);
                        bounds.writeToParcel(parcelObtain, 0);
                    } else {
                        parcelObtain.writeInt(0);
                    }
                    parcelObtain.writeInt(width);
                    parcelObtain.writeInt(height);
                    parcelObtain.writeInt(padding);
                    this.a.transact(11, parcelObtain, parcelObtain2, 0);
                    parcelObtain2.readException();
                    return b.a.l(parcelObtain2.readStrongBinder());
                } finally {
                    parcelObtain2.recycle();
                    parcelObtain.recycle();
                }
            }

            @Override // com.google.android.gms.maps.internal.ICameraUpdateFactoryDelegate
            public com.google.android.gms.dynamic.b newLatLngZoom(LatLng latLng, float zoom) throws RemoteException {
                Parcel parcelObtain = Parcel.obtain();
                Parcel parcelObtain2 = Parcel.obtain();
                try {
                    parcelObtain.writeInterfaceToken("com.google.android.gms.maps.internal.ICameraUpdateFactoryDelegate");
                    if (latLng != null) {
                        parcelObtain.writeInt(1);
                        latLng.writeToParcel(parcelObtain, 0);
                    } else {
                        parcelObtain.writeInt(0);
                    }
                    parcelObtain.writeFloat(zoom);
                    this.a.transact(9, parcelObtain, parcelObtain2, 0);
                    parcelObtain2.readException();
                    return b.a.l(parcelObtain2.readStrongBinder());
                } finally {
                    parcelObtain2.recycle();
                    parcelObtain.recycle();
                }
            }

            @Override // com.google.android.gms.maps.internal.ICameraUpdateFactoryDelegate
            public com.google.android.gms.dynamic.b scrollBy(float xPixel, float yPixel) throws RemoteException {
                Parcel parcelObtain = Parcel.obtain();
                Parcel parcelObtain2 = Parcel.obtain();
                try {
                    parcelObtain.writeInterfaceToken("com.google.android.gms.maps.internal.ICameraUpdateFactoryDelegate");
                    parcelObtain.writeFloat(xPixel);
                    parcelObtain.writeFloat(yPixel);
                    this.a.transact(3, parcelObtain, parcelObtain2, 0);
                    parcelObtain2.readException();
                    return b.a.l(parcelObtain2.readStrongBinder());
                } finally {
                    parcelObtain2.recycle();
                    parcelObtain.recycle();
                }
            }

            @Override // com.google.android.gms.maps.internal.ICameraUpdateFactoryDelegate
            public com.google.android.gms.dynamic.b zoomBy(float amount) throws RemoteException {
                Parcel parcelObtain = Parcel.obtain();
                Parcel parcelObtain2 = Parcel.obtain();
                try {
                    parcelObtain.writeInterfaceToken("com.google.android.gms.maps.internal.ICameraUpdateFactoryDelegate");
                    parcelObtain.writeFloat(amount);
                    this.a.transact(5, parcelObtain, parcelObtain2, 0);
                    parcelObtain2.readException();
                    return b.a.l(parcelObtain2.readStrongBinder());
                } finally {
                    parcelObtain2.recycle();
                    parcelObtain.recycle();
                }
            }

            @Override // com.google.android.gms.maps.internal.ICameraUpdateFactoryDelegate
            public com.google.android.gms.dynamic.b zoomByWithFocus(float amount, int screenFocusX, int screenFocusY) throws RemoteException {
                Parcel parcelObtain = Parcel.obtain();
                Parcel parcelObtain2 = Parcel.obtain();
                try {
                    parcelObtain.writeInterfaceToken("com.google.android.gms.maps.internal.ICameraUpdateFactoryDelegate");
                    parcelObtain.writeFloat(amount);
                    parcelObtain.writeInt(screenFocusX);
                    parcelObtain.writeInt(screenFocusY);
                    this.a.transact(6, parcelObtain, parcelObtain2, 0);
                    parcelObtain2.readException();
                    return b.a.l(parcelObtain2.readStrongBinder());
                } finally {
                    parcelObtain2.recycle();
                    parcelObtain.recycle();
                }
            }

            @Override // com.google.android.gms.maps.internal.ICameraUpdateFactoryDelegate
            public com.google.android.gms.dynamic.b zoomIn() throws RemoteException {
                Parcel parcelObtain = Parcel.obtain();
                Parcel parcelObtain2 = Parcel.obtain();
                try {
                    parcelObtain.writeInterfaceToken("com.google.android.gms.maps.internal.ICameraUpdateFactoryDelegate");
                    this.a.transact(1, parcelObtain, parcelObtain2, 0);
                    parcelObtain2.readException();
                    return b.a.l(parcelObtain2.readStrongBinder());
                } finally {
                    parcelObtain2.recycle();
                    parcelObtain.recycle();
                }
            }

            @Override // com.google.android.gms.maps.internal.ICameraUpdateFactoryDelegate
            public com.google.android.gms.dynamic.b zoomOut() throws RemoteException {
                Parcel parcelObtain = Parcel.obtain();
                Parcel parcelObtain2 = Parcel.obtain();
                try {
                    parcelObtain.writeInterfaceToken("com.google.android.gms.maps.internal.ICameraUpdateFactoryDelegate");
                    this.a.transact(2, parcelObtain, parcelObtain2, 0);
                    parcelObtain2.readException();
                    return b.a.l(parcelObtain2.readStrongBinder());
                } finally {
                    parcelObtain2.recycle();
                    parcelObtain.recycle();
                }
            }

            @Override // com.google.android.gms.maps.internal.ICameraUpdateFactoryDelegate
            public com.google.android.gms.dynamic.b zoomTo(float zoom) throws RemoteException {
                Parcel parcelObtain = Parcel.obtain();
                Parcel parcelObtain2 = Parcel.obtain();
                try {
                    parcelObtain.writeInterfaceToken("com.google.android.gms.maps.internal.ICameraUpdateFactoryDelegate");
                    parcelObtain.writeFloat(zoom);
                    this.a.transact(4, parcelObtain, parcelObtain2, 0);
                    parcelObtain2.readException();
                    return b.a.l(parcelObtain2.readStrongBinder());
                } finally {
                    parcelObtain2.recycle();
                    parcelObtain.recycle();
                }
            }
        }

        public static ICameraUpdateFactoryDelegate t(IBinder iBinder) {
            if (iBinder == null) {
                return null;
            }
            IInterface iInterfaceQueryLocalInterface = iBinder.queryLocalInterface("com.google.android.gms.maps.internal.ICameraUpdateFactoryDelegate");
            return (iInterfaceQueryLocalInterface == null || !(iInterfaceQueryLocalInterface instanceof ICameraUpdateFactoryDelegate)) ? new C0030a(iBinder) : (ICameraUpdateFactoryDelegate) iInterfaceQueryLocalInterface;
        }

        @Override // android.os.Binder
        public boolean onTransact(int code, Parcel data, Parcel reply, int flags) throws RemoteException {
            switch (code) {
                case 1:
                    data.enforceInterface("com.google.android.gms.maps.internal.ICameraUpdateFactoryDelegate");
                    com.google.android.gms.dynamic.b bVarZoomIn = zoomIn();
                    reply.writeNoException();
                    reply.writeStrongBinder(bVarZoomIn != null ? bVarZoomIn.asBinder() : null);
                    return true;
                case 2:
                    data.enforceInterface("com.google.android.gms.maps.internal.ICameraUpdateFactoryDelegate");
                    com.google.android.gms.dynamic.b bVarZoomOut = zoomOut();
                    reply.writeNoException();
                    reply.writeStrongBinder(bVarZoomOut != null ? bVarZoomOut.asBinder() : null);
                    return true;
                case 3:
                    data.enforceInterface("com.google.android.gms.maps.internal.ICameraUpdateFactoryDelegate");
                    com.google.android.gms.dynamic.b bVarScrollBy = scrollBy(data.readFloat(), data.readFloat());
                    reply.writeNoException();
                    reply.writeStrongBinder(bVarScrollBy != null ? bVarScrollBy.asBinder() : null);
                    return true;
                case 4:
                    data.enforceInterface("com.google.android.gms.maps.internal.ICameraUpdateFactoryDelegate");
                    com.google.android.gms.dynamic.b bVarZoomTo = zoomTo(data.readFloat());
                    reply.writeNoException();
                    reply.writeStrongBinder(bVarZoomTo != null ? bVarZoomTo.asBinder() : null);
                    return true;
                case 5:
                    data.enforceInterface("com.google.android.gms.maps.internal.ICameraUpdateFactoryDelegate");
                    com.google.android.gms.dynamic.b bVarZoomBy = zoomBy(data.readFloat());
                    reply.writeNoException();
                    reply.writeStrongBinder(bVarZoomBy != null ? bVarZoomBy.asBinder() : null);
                    return true;
                case 6:
                    data.enforceInterface("com.google.android.gms.maps.internal.ICameraUpdateFactoryDelegate");
                    com.google.android.gms.dynamic.b bVarZoomByWithFocus = zoomByWithFocus(data.readFloat(), data.readInt(), data.readInt());
                    reply.writeNoException();
                    reply.writeStrongBinder(bVarZoomByWithFocus != null ? bVarZoomByWithFocus.asBinder() : null);
                    return true;
                case 7:
                    data.enforceInterface("com.google.android.gms.maps.internal.ICameraUpdateFactoryDelegate");
                    com.google.android.gms.dynamic.b bVarNewCameraPosition = newCameraPosition(data.readInt() != 0 ? CameraPosition.CREATOR.createFromParcel(data) : null);
                    reply.writeNoException();
                    reply.writeStrongBinder(bVarNewCameraPosition != null ? bVarNewCameraPosition.asBinder() : null);
                    return true;
                case 8:
                    data.enforceInterface("com.google.android.gms.maps.internal.ICameraUpdateFactoryDelegate");
                    com.google.android.gms.dynamic.b bVarNewLatLng = newLatLng(data.readInt() != 0 ? LatLng.CREATOR.createFromParcel(data) : null);
                    reply.writeNoException();
                    reply.writeStrongBinder(bVarNewLatLng != null ? bVarNewLatLng.asBinder() : null);
                    return true;
                case 9:
                    data.enforceInterface("com.google.android.gms.maps.internal.ICameraUpdateFactoryDelegate");
                    com.google.android.gms.dynamic.b bVarNewLatLngZoom = newLatLngZoom(data.readInt() != 0 ? LatLng.CREATOR.createFromParcel(data) : null, data.readFloat());
                    reply.writeNoException();
                    reply.writeStrongBinder(bVarNewLatLngZoom != null ? bVarNewLatLngZoom.asBinder() : null);
                    return true;
                case 10:
                    data.enforceInterface("com.google.android.gms.maps.internal.ICameraUpdateFactoryDelegate");
                    com.google.android.gms.dynamic.b bVarNewLatLngBounds = newLatLngBounds(data.readInt() != 0 ? LatLngBounds.CREATOR.createFromParcel(data) : null, data.readInt());
                    reply.writeNoException();
                    reply.writeStrongBinder(bVarNewLatLngBounds != null ? bVarNewLatLngBounds.asBinder() : null);
                    return true;
                case 11:
                    data.enforceInterface("com.google.android.gms.maps.internal.ICameraUpdateFactoryDelegate");
                    com.google.android.gms.dynamic.b bVarNewLatLngBoundsWithSize = newLatLngBoundsWithSize(data.readInt() != 0 ? LatLngBounds.CREATOR.createFromParcel(data) : null, data.readInt(), data.readInt(), data.readInt());
                    reply.writeNoException();
                    reply.writeStrongBinder(bVarNewLatLngBoundsWithSize != null ? bVarNewLatLngBoundsWithSize.asBinder() : null);
                    return true;
                case 1598968902:
                    reply.writeString("com.google.android.gms.maps.internal.ICameraUpdateFactoryDelegate");
                    return true;
                default:
                    return super.onTransact(code, data, reply, flags);
            }
        }
    }

    com.google.android.gms.dynamic.b newCameraPosition(CameraPosition cameraPosition) throws RemoteException;

    com.google.android.gms.dynamic.b newLatLng(LatLng latLng) throws RemoteException;

    com.google.android.gms.dynamic.b newLatLngBounds(LatLngBounds latLngBounds, int i) throws RemoteException;

    com.google.android.gms.dynamic.b newLatLngBoundsWithSize(LatLngBounds latLngBounds, int i, int i2, int i3) throws RemoteException;

    com.google.android.gms.dynamic.b newLatLngZoom(LatLng latLng, float f) throws RemoteException;

    com.google.android.gms.dynamic.b scrollBy(float f, float f2) throws RemoteException;

    com.google.android.gms.dynamic.b zoomBy(float f) throws RemoteException;

    com.google.android.gms.dynamic.b zoomByWithFocus(float f, int i, int i2) throws RemoteException;

    com.google.android.gms.dynamic.b zoomIn() throws RemoteException;

    com.google.android.gms.dynamic.b zoomOut() throws RemoteException;

    com.google.android.gms.dynamic.b zoomTo(float f) throws RemoteException;
}
