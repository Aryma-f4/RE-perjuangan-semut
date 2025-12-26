package com.google.android.gms.common.data;

import android.database.CharArrayBuffer;
import android.database.CursorIndexOutOfBoundsException;
import android.database.CursorWindow;
import android.net.Uri;
import android.os.Bundle;
import android.os.Parcel;
import com.google.android.gms.common.internal.safeparcel.SafeParcelable;
import com.google.android.gms.internal.s;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

/* loaded from: classes.dex */
public final class d implements SafeParcelable {
    public static final e CREATOR = new e();
    private static final HashMap<CursorWindow, Throwable> Z = (HashMap) null;
    private static final Object aa = new Object();
    private static final a ai = new a(new String[0], null) { // from class: com.google.android.gms.common.data.d.1
    };
    private final int ab;
    private final String[] ac;
    Bundle ad;
    private final CursorWindow[] ae;
    private final Bundle af;
    int[] ag;
    int ah;
    boolean mClosed;
    private final int p;

    public static class a {
        private final String[] ac;
        private final ArrayList<HashMap<String, Object>> aj;
        private final String ak;
        private final HashMap<Object, Integer> al;
        private boolean am;
        private String an;

        private a(String[] strArr, String str) {
            this.ac = (String[]) s.d(strArr);
            this.aj = new ArrayList<>();
            this.ak = str;
            this.al = new HashMap<>();
            this.am = false;
            this.an = null;
        }
    }

    d(int i, String[] strArr, CursorWindow[] cursorWindowArr, int i2, Bundle bundle) {
        this.mClosed = false;
        this.ab = i;
        this.ac = strArr;
        this.ae = cursorWindowArr;
        this.p = i2;
        this.af = bundle;
    }

    private d(a aVar, int i, Bundle bundle) {
        this(aVar.ac, a(aVar), i, bundle);
    }

    public d(String[] strArr, CursorWindow[] cursorWindowArr, int i, Bundle bundle) {
        this.mClosed = false;
        this.ab = 1;
        this.ac = (String[]) s.d(strArr);
        this.ae = (CursorWindow[]) s.d(cursorWindowArr);
        this.p = i;
        this.af = bundle;
        h();
    }

    public static d a(int i, Bundle bundle) {
        return new d(ai, i, bundle);
    }

    private static void a(CursorWindow cursorWindow) {
    }

    private void a(String str, int i) {
        if (this.ad == null || !this.ad.containsKey(str)) {
            throw new IllegalArgumentException("No such column: " + str);
        }
        if (isClosed()) {
            throw new IllegalArgumentException("Buffer is closed.");
        }
        if (i < 0 || i >= this.ah) {
            throw new CursorIndexOutOfBoundsException(i, this.ah);
        }
    }

    private static CursorWindow[] a(a aVar) {
        if (aVar.ac.length == 0) {
            return new CursorWindow[0];
        }
        ArrayList arrayList = aVar.aj;
        int size = arrayList.size();
        CursorWindow cursorWindow = new CursorWindow(false);
        CursorWindow[] cursorWindowArr = {cursorWindow};
        cursorWindow.setNumColumns(aVar.ac.length);
        for (int i = 0; i < size; i++) {
            try {
                if (!cursorWindow.allocRow()) {
                    throw new RuntimeException("Cursor window out of memory");
                }
                Map map = (Map) arrayList.get(i);
                for (int i2 = 0; i2 < aVar.ac.length; i2++) {
                    String str = aVar.ac[i2];
                    Object obj = map.get(str);
                    if (obj == null) {
                        cursorWindow.putNull(i, i2);
                    } else if (obj instanceof String) {
                        cursorWindow.putString((String) obj, i, i2);
                    } else if (obj instanceof Long) {
                        cursorWindow.putLong(((Long) obj).longValue(), i, i2);
                    } else if (obj instanceof Integer) {
                        cursorWindow.putLong(((Integer) obj).intValue(), i, i2);
                    } else if (obj instanceof Boolean) {
                        cursorWindow.putLong(((Boolean) obj).booleanValue() ? 1L : 0L, i, i2);
                    } else {
                        if (!(obj instanceof byte[])) {
                            throw new IllegalArgumentException("Unsupported object for column " + str + ": " + obj);
                        }
                        cursorWindow.putBlob((byte[]) obj, i, i2);
                    }
                }
            } catch (RuntimeException e) {
                cursorWindow.close();
                throw e;
            }
        }
        return cursorWindowArr;
    }

    public static d f(int i) {
        return a(i, (Bundle) null);
    }

    public long a(String str, int i, int i2) {
        a(str, i);
        return this.ae[i2].getLong(i - this.ag[i2], this.ad.getInt(str));
    }

    public void a(String str, int i, int i2, CharArrayBuffer charArrayBuffer) {
        a(str, i);
        this.ae[i2].copyStringToBuffer(i - this.ag[i2], this.ad.getInt(str), charArrayBuffer);
    }

    public int b(String str, int i, int i2) {
        a(str, i);
        return this.ae[i2].getInt(i - this.ag[i2], this.ad.getInt(str));
    }

    public String c(String str, int i, int i2) {
        a(str, i);
        return this.ae[i2].getString(i - this.ag[i2], this.ad.getInt(str));
    }

    public void close() {
        synchronized (this) {
            if (!this.mClosed) {
                this.mClosed = true;
                for (int i = 0; i < this.ae.length; i++) {
                    this.ae[i].close();
                    a(this.ae[i]);
                }
            }
        }
    }

    public boolean d(String str, int i, int i2) {
        a(str, i);
        return Long.valueOf(this.ae[i2].getLong(i - this.ag[i2], this.ad.getInt(str))).longValue() == 1;
    }

    @Override // android.os.Parcelable
    public int describeContents() {
        return 0;
    }

    public int e(int i) {
        s.a(i >= 0 && i < this.ah);
        int i2 = 0;
        while (true) {
            if (i2 >= this.ag.length) {
                break;
            }
            if (i < this.ag[i2]) {
                i2--;
                break;
            }
            i2++;
        }
        return i2 == this.ag.length ? i2 - 1 : i2;
    }

    public byte[] e(String str, int i, int i2) {
        a(str, i);
        return this.ae[i2].getBlob(i - this.ag[i2], this.ad.getInt(str));
    }

    public Uri f(String str, int i, int i2) {
        String strC = c(str, i, i2);
        if (strC == null) {
            return null;
        }
        return Uri.parse(strC);
    }

    public boolean g(String str, int i, int i2) {
        a(str, i);
        return this.ae[i2].isNull(i - this.ag[i2], this.ad.getInt(str));
    }

    public int getCount() {
        return this.ah;
    }

    public int getStatusCode() {
        return this.p;
    }

    public void h() {
        this.ad = new Bundle();
        for (int i = 0; i < this.ac.length; i++) {
            this.ad.putInt(this.ac[i], i);
        }
        this.ag = new int[this.ae.length];
        int numRows = 0;
        for (int i2 = 0; i2 < this.ae.length; i2++) {
            this.ag[i2] = numRows;
            numRows += this.ae[i2].getNumRows();
        }
        this.ah = numRows;
    }

    int i() {
        return this.ab;
    }

    public boolean isClosed() {
        boolean z;
        synchronized (this) {
            z = this.mClosed;
        }
        return z;
    }

    String[] j() {
        return this.ac;
    }

    CursorWindow[] k() {
        return this.ae;
    }

    public Bundle l() {
        return this.af;
    }

    @Override // android.os.Parcelable
    public void writeToParcel(Parcel dest, int flags) {
        e.a(this, dest, flags);
    }
}
