package com.google.android.gms.internal;

import android.net.LocalSocket;
import android.os.Parcel;
import android.os.ParcelFileDescriptor;
import com.google.android.gms.games.RealTimeSocket;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

/* loaded from: classes.dex */
final class bb implements RealTimeSocket {
    private ParcelFileDescriptor aB;
    private final String dX;
    private final LocalSocket en;

    bb(LocalSocket localSocket, String str) {
        this.en = localSocket;
        this.dX = str;
    }

    @Override // com.google.android.gms.games.RealTimeSocket
    public void close() throws IOException {
        this.en.close();
    }

    @Override // com.google.android.gms.games.RealTimeSocket
    public InputStream getInputStream() throws IOException {
        return this.en.getInputStream();
    }

    @Override // com.google.android.gms.games.RealTimeSocket
    public OutputStream getOutputStream() throws IOException {
        return this.en.getOutputStream();
    }

    @Override // com.google.android.gms.games.RealTimeSocket
    public ParcelFileDescriptor getParcelFileDescriptor() throws IOException {
        if (this.aB == null && !isClosed()) {
            Parcel parcelObtain = Parcel.obtain();
            parcelObtain.writeFileDescriptor(this.en.getFileDescriptor());
            parcelObtain.setDataPosition(0);
            this.aB = parcelObtain.readFileDescriptor();
        }
        return this.aB;
    }

    @Override // com.google.android.gms.games.RealTimeSocket
    public boolean isClosed() {
        return (this.en.isConnected() || this.en.isBound()) ? false : true;
    }
}
