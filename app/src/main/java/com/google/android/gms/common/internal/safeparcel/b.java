package com.google.android.gms.common.internal.safeparcel;

import android.os.Bundle;
import android.os.IBinder;
import android.os.Parcel;
import android.os.Parcelable;
import java.util.List;

/* loaded from: classes.dex */
public class b {
    private static int A(Parcel parcel, int i) {
        parcel.writeInt((-65536) | i);
        parcel.writeInt(0);
        return parcel.dataPosition();
    }

    private static void B(Parcel parcel, int i) {
        int iDataPosition = parcel.dataPosition();
        parcel.setDataPosition(i - 4);
        parcel.writeInt(iDataPosition - i);
        parcel.setDataPosition(iDataPosition);
    }

    public static void C(Parcel parcel, int i) {
        B(parcel, i);
    }

    public static void a(Parcel parcel, int i, byte b) {
        b(parcel, i, 4);
        parcel.writeInt(b);
    }

    public static void a(Parcel parcel, int i, double d) {
        b(parcel, i, 8);
        parcel.writeDouble(d);
    }

    public static void a(Parcel parcel, int i, float f) {
        b(parcel, i, 4);
        parcel.writeFloat(f);
    }

    public static void a(Parcel parcel, int i, long j) {
        b(parcel, i, 8);
        parcel.writeLong(j);
    }

    public static void a(Parcel parcel, int i, Bundle bundle, boolean z) {
        if (bundle == null) {
            if (z) {
                b(parcel, i, 0);
            }
        } else {
            int iA = A(parcel, i);
            parcel.writeBundle(bundle);
            B(parcel, iA);
        }
    }

    public static void a(Parcel parcel, int i, IBinder iBinder, boolean z) {
        if (iBinder == null) {
            if (z) {
                b(parcel, i, 0);
            }
        } else {
            int iA = A(parcel, i);
            parcel.writeStrongBinder(iBinder);
            B(parcel, iA);
        }
    }

    public static void a(Parcel parcel, int i, Parcel parcel2, boolean z) {
        if (parcel2 == null) {
            if (z) {
                b(parcel, i, 0);
            }
        } else {
            int iA = A(parcel, i);
            parcel.appendFrom(parcel2, 0, parcel2.dataSize());
            B(parcel, iA);
        }
    }

    public static void a(Parcel parcel, int i, Parcelable parcelable, int i2, boolean z) {
        if (parcelable == null) {
            if (z) {
                b(parcel, i, 0);
            }
        } else {
            int iA = A(parcel, i);
            parcelable.writeToParcel(parcel, i2);
            B(parcel, iA);
        }
    }

    public static void a(Parcel parcel, int i, String str, boolean z) {
        if (str == null) {
            if (z) {
                b(parcel, i, 0);
            }
        } else {
            int iA = A(parcel, i);
            parcel.writeString(str);
            B(parcel, iA);
        }
    }

    public static void a(Parcel parcel, int i, List<String> list, boolean z) {
        if (list == null) {
            if (z) {
                b(parcel, i, 0);
            }
        } else {
            int iA = A(parcel, i);
            parcel.writeStringList(list);
            B(parcel, iA);
        }
    }

    public static void a(Parcel parcel, int i, short s) {
        b(parcel, i, 4);
        parcel.writeInt(s);
    }

    public static void a(Parcel parcel, int i, boolean z) {
        b(parcel, i, 4);
        parcel.writeInt(z ? 1 : 0);
    }

    public static void a(Parcel parcel, int i, byte[] bArr, boolean z) {
        if (bArr == null) {
            if (z) {
                b(parcel, i, 0);
            }
        } else {
            int iA = A(parcel, i);
            parcel.writeByteArray(bArr);
            B(parcel, iA);
        }
    }

    public static <T extends Parcelable> void a(Parcel parcel, int i, T[] tArr, int i2, boolean z) {
        if (tArr == null) {
            if (z) {
                b(parcel, i, 0);
                return;
            }
            return;
        }
        int iA = A(parcel, i);
        parcel.writeInt(tArr.length);
        for (T t : tArr) {
            if (t == null) {
                parcel.writeInt(0);
            } else {
                a(parcel, t, i2);
            }
        }
        B(parcel, iA);
    }

    public static void a(Parcel parcel, int i, String[] strArr, boolean z) {
        if (strArr == null) {
            if (z) {
                b(parcel, i, 0);
            }
        } else {
            int iA = A(parcel, i);
            parcel.writeStringArray(strArr);
            B(parcel, iA);
        }
    }

    private static <T extends Parcelable> void a(Parcel parcel, T t, int i) {
        int iDataPosition = parcel.dataPosition();
        parcel.writeInt(1);
        int iDataPosition2 = parcel.dataPosition();
        t.writeToParcel(parcel, i);
        int iDataPosition3 = parcel.dataPosition();
        parcel.setDataPosition(iDataPosition);
        parcel.writeInt(iDataPosition3 - iDataPosition2);
        parcel.setDataPosition(iDataPosition3);
    }

    private static void b(Parcel parcel, int i, int i2) {
        if (i2 < 65535) {
            parcel.writeInt((i2 << 16) | i);
        } else {
            parcel.writeInt((-65536) | i);
            parcel.writeInt(i2);
        }
    }

    public static <T extends Parcelable> void b(Parcel parcel, int i, List<T> list, boolean z) {
        if (list == null) {
            if (z) {
                b(parcel, i, 0);
                return;
            }
            return;
        }
        int iA = A(parcel, i);
        int size = list.size();
        parcel.writeInt(size);
        for (int i2 = 0; i2 < size; i2++) {
            T t = list.get(i2);
            if (t == null) {
                parcel.writeInt(0);
            } else {
                a(parcel, t, 0);
            }
        }
        B(parcel, iA);
    }

    public static void c(Parcel parcel, int i, int i2) {
        b(parcel, i, 4);
        parcel.writeInt(i2);
    }

    public static void c(Parcel parcel, int i, List list, boolean z) {
        if (list == null) {
            if (z) {
                b(parcel, i, 0);
            }
        } else {
            int iA = A(parcel, i);
            parcel.writeList(list);
            B(parcel, iA);
        }
    }

    public static int d(Parcel parcel) {
        return A(parcel, 20293);
    }
}
