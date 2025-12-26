package com.google.android.gms.games;

import android.os.ParcelFileDescriptor;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

/* loaded from: classes.dex */
public interface RealTimeSocket {
    void close() throws IOException;

    InputStream getInputStream() throws IOException;

    OutputStream getOutputStream() throws IOException;

    ParcelFileDescriptor getParcelFileDescriptor() throws IOException;

    boolean isClosed();
}
