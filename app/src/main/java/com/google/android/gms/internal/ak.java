package com.google.android.gms.internal;

import android.os.Bundle;
import android.os.Parcel;
import com.google.android.gms.common.internal.safeparcel.SafeParcelable;
import com.google.android.gms.common.internal.safeparcel.a;
import com.google.android.gms.internal.ae;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;

/* loaded from: classes.dex */
public class ak extends ae implements SafeParcelable {
    public static final al CREATOR = new al();
    private final int ab;
    private final ah cB;
    private final Parcel cJ;
    private final int cK;
    private int cL;
    private int cM;
    private final String mClassName;

    ak(int i, Parcel parcel, ah ahVar) {
        this.ab = i;
        this.cJ = (Parcel) s.d(parcel);
        this.cK = 2;
        this.cB = ahVar;
        if (this.cB == null) {
            this.mClassName = null;
        } else {
            this.mClassName = this.cB.aj();
        }
        this.cL = 2;
    }

    private ak(SafeParcelable safeParcelable, ah ahVar, String str) {
        this.ab = 1;
        this.cJ = Parcel.obtain();
        safeParcelable.writeToParcel(this.cJ, 0);
        this.cK = 1;
        this.cB = (ah) s.d(ahVar);
        this.mClassName = (String) s.d(str);
        this.cL = 2;
    }

    public static <T extends ae & SafeParcelable> ak a(T t) {
        String canonicalName = t.getClass().getCanonicalName();
        return new ak(t, b(t), canonicalName);
    }

    public static HashMap<String, String> a(Bundle bundle) {
        HashMap<String, String> map = new HashMap<>();
        for (String str : bundle.keySet()) {
            map.put(str, bundle.getString(str));
        }
        return map;
    }

    /* JADX WARN: Multi-variable type inference failed */
    private static void a(ah ahVar, ae aeVar) {
        Class<?> cls = aeVar.getClass();
        if (ahVar.b((Class<? extends ae>) cls)) {
            return;
        }
        HashMap<String, ae.a<?, ?>> mapT = aeVar.T();
        ahVar.a(cls, aeVar.T());
        Iterator<String> it = mapT.keySet().iterator();
        while (it.hasNext()) {
            ae.a<?, ?> aVar = mapT.get(it.next());
            Class<? extends ae> clsAb = aVar.ab();
            if (clsAb != null) {
                try {
                    a(ahVar, clsAb.newInstance());
                } catch (IllegalAccessException e) {
                    throw new IllegalStateException("Could not access object of type " + aVar.ab().getCanonicalName(), e);
                } catch (InstantiationException e2) {
                    throw new IllegalStateException("Could not instantiate an object of type " + aVar.ab().getCanonicalName(), e2);
                }
            }
        }
    }

    private void a(StringBuilder sb, int i, Object obj) {
        switch (i) {
            case 0:
            case 1:
            case 2:
            case 3:
            case 4:
            case 5:
            case 6:
                sb.append(obj);
                return;
            case 7:
                sb.append("\"").append(aq.r(obj.toString())).append("\"");
                return;
            case 8:
                sb.append("\"").append(an.a((byte[]) obj)).append("\"");
                return;
            case 9:
                sb.append("\"").append(an.b((byte[]) obj));
                sb.append("\"");
                return;
            case 10:
                ar.a(sb, (HashMap) obj);
                return;
            case 11:
                throw new IllegalArgumentException("Method does not accept concrete type.");
            default:
                throw new IllegalArgumentException("Unknown type = " + i);
        }
    }

    private void a(StringBuilder sb, ae.a<?, ?> aVar, Parcel parcel, int i) {
        switch (aVar.S()) {
            case 0:
                b(sb, aVar, a(aVar, Integer.valueOf(com.google.android.gms.common.internal.safeparcel.a.f(parcel, i))));
                return;
            case 1:
                b(sb, aVar, a(aVar, com.google.android.gms.common.internal.safeparcel.a.h(parcel, i)));
                return;
            case 2:
                b(sb, aVar, a(aVar, Long.valueOf(com.google.android.gms.common.internal.safeparcel.a.g(parcel, i))));
                return;
            case 3:
                b(sb, aVar, a(aVar, Float.valueOf(com.google.android.gms.common.internal.safeparcel.a.i(parcel, i))));
                return;
            case 4:
                b(sb, aVar, a(aVar, Double.valueOf(com.google.android.gms.common.internal.safeparcel.a.j(parcel, i))));
                return;
            case 5:
                b(sb, aVar, a(aVar, com.google.android.gms.common.internal.safeparcel.a.k(parcel, i)));
                return;
            case 6:
                b(sb, aVar, a(aVar, Boolean.valueOf(com.google.android.gms.common.internal.safeparcel.a.c(parcel, i))));
                return;
            case 7:
                b(sb, aVar, a(aVar, com.google.android.gms.common.internal.safeparcel.a.l(parcel, i)));
                return;
            case 8:
            case 9:
                b(sb, aVar, a(aVar, com.google.android.gms.common.internal.safeparcel.a.o(parcel, i)));
                return;
            case 10:
                b(sb, aVar, a(aVar, a(com.google.android.gms.common.internal.safeparcel.a.n(parcel, i))));
                return;
            case 11:
                throw new IllegalArgumentException("Method does not accept concrete type.");
            default:
                throw new IllegalArgumentException("Unknown field out type = " + aVar.S());
        }
    }

    private void a(StringBuilder sb, String str, ae.a<?, ?> aVar, Parcel parcel, int i) {
        sb.append("\"").append(str).append("\":");
        if (aVar.ad()) {
            a(sb, aVar, parcel, i);
        } else {
            b(sb, aVar, parcel, i);
        }
    }

    private void a(StringBuilder sb, HashMap<String, ae.a<?, ?>> map, Parcel parcel) {
        HashMap<Integer, Map.Entry<String, ae.a<?, ?>>> mapB = b(map);
        sb.append('{');
        int iC = com.google.android.gms.common.internal.safeparcel.a.c(parcel);
        boolean z = false;
        while (parcel.dataPosition() < iC) {
            int iB = com.google.android.gms.common.internal.safeparcel.a.b(parcel);
            Map.Entry<String, ae.a<?, ?>> entry = mapB.get(Integer.valueOf(com.google.android.gms.common.internal.safeparcel.a.m(iB)));
            if (entry != null) {
                if (z) {
                    sb.append(",");
                }
                a(sb, entry.getKey(), entry.getValue(), parcel, iB);
                z = true;
            }
        }
        if (parcel.dataPosition() != iC) {
            throw new a.C0003a("Overread allowed size end=" + iC, parcel);
        }
        sb.append('}');
    }

    private static ah b(ae aeVar) {
        ah ahVar = new ah(aeVar.getClass());
        a(ahVar, aeVar);
        ahVar.ah();
        ahVar.ag();
        return ahVar;
    }

    private static HashMap<Integer, Map.Entry<String, ae.a<?, ?>>> b(HashMap<String, ae.a<?, ?>> map) {
        HashMap<Integer, Map.Entry<String, ae.a<?, ?>>> map2 = new HashMap<>();
        for (Map.Entry<String, ae.a<?, ?>> entry : map.entrySet()) {
            map2.put(Integer.valueOf(entry.getValue().aa()), entry);
        }
        return map2;
    }

    private void b(StringBuilder sb, ae.a<?, ?> aVar, Parcel parcel, int i) {
        if (aVar.Y()) {
            sb.append("[");
            switch (aVar.S()) {
                case 0:
                    am.a(sb, com.google.android.gms.common.internal.safeparcel.a.q(parcel, i));
                    break;
                case 1:
                    am.a(sb, com.google.android.gms.common.internal.safeparcel.a.s(parcel, i));
                    break;
                case 2:
                    am.a(sb, com.google.android.gms.common.internal.safeparcel.a.r(parcel, i));
                    break;
                case 3:
                    am.a(sb, com.google.android.gms.common.internal.safeparcel.a.t(parcel, i));
                    break;
                case 4:
                    am.a(sb, com.google.android.gms.common.internal.safeparcel.a.u(parcel, i));
                    break;
                case 5:
                    am.a(sb, com.google.android.gms.common.internal.safeparcel.a.v(parcel, i));
                    break;
                case 6:
                    am.a(sb, com.google.android.gms.common.internal.safeparcel.a.p(parcel, i));
                    break;
                case 7:
                    am.a(sb, com.google.android.gms.common.internal.safeparcel.a.w(parcel, i));
                    break;
                case 8:
                case 9:
                case 10:
                    throw new UnsupportedOperationException("List of type BASE64, BASE64_URL_SAFE, or STRING_MAP is not supported");
                case 11:
                    Parcel[] parcelArrZ = com.google.android.gms.common.internal.safeparcel.a.z(parcel, i);
                    int length = parcelArrZ.length;
                    for (int i2 = 0; i2 < length; i2++) {
                        if (i2 > 0) {
                            sb.append(",");
                        }
                        parcelArrZ[i2].setDataPosition(0);
                        a(sb, aVar.af(), parcelArrZ[i2]);
                    }
                    break;
                default:
                    throw new IllegalStateException("Unknown field type out.");
            }
            sb.append("]");
            return;
        }
        switch (aVar.S()) {
            case 0:
                sb.append(com.google.android.gms.common.internal.safeparcel.a.f(parcel, i));
                return;
            case 1:
                sb.append(com.google.android.gms.common.internal.safeparcel.a.h(parcel, i));
                return;
            case 2:
                sb.append(com.google.android.gms.common.internal.safeparcel.a.g(parcel, i));
                return;
            case 3:
                sb.append(com.google.android.gms.common.internal.safeparcel.a.i(parcel, i));
                return;
            case 4:
                sb.append(com.google.android.gms.common.internal.safeparcel.a.j(parcel, i));
                return;
            case 5:
                sb.append(com.google.android.gms.common.internal.safeparcel.a.k(parcel, i));
                return;
            case 6:
                sb.append(com.google.android.gms.common.internal.safeparcel.a.c(parcel, i));
                return;
            case 7:
                sb.append("\"").append(aq.r(com.google.android.gms.common.internal.safeparcel.a.l(parcel, i))).append("\"");
                return;
            case 8:
                sb.append("\"").append(an.a(com.google.android.gms.common.internal.safeparcel.a.o(parcel, i))).append("\"");
                return;
            case 9:
                sb.append("\"").append(an.b(com.google.android.gms.common.internal.safeparcel.a.o(parcel, i)));
                sb.append("\"");
                return;
            case 10:
                Bundle bundleN = com.google.android.gms.common.internal.safeparcel.a.n(parcel, i);
                Set<String> setKeySet = bundleN.keySet();
                setKeySet.size();
                sb.append("{");
                boolean z = true;
                for (String str : setKeySet) {
                    if (!z) {
                        sb.append(",");
                    }
                    sb.append("\"").append(str).append("\"");
                    sb.append(":");
                    sb.append("\"").append(aq.r(bundleN.getString(str))).append("\"");
                    z = false;
                }
                sb.append("}");
                return;
            case 11:
                Parcel parcelY = com.google.android.gms.common.internal.safeparcel.a.y(parcel, i);
                parcelY.setDataPosition(0);
                a(sb, aVar.af(), parcelY);
                return;
            default:
                throw new IllegalStateException("Unknown field type out");
        }
    }

    private void b(StringBuilder sb, ae.a<?, ?> aVar, Object obj) {
        if (aVar.X()) {
            b(sb, aVar, (ArrayList<?>) obj);
        } else {
            a(sb, aVar.R(), obj);
        }
    }

    private void b(StringBuilder sb, ae.a<?, ?> aVar, ArrayList<?> arrayList) {
        sb.append("[");
        int size = arrayList.size();
        for (int i = 0; i < size; i++) {
            if (i != 0) {
                sb.append(",");
            }
            a(sb, aVar.R(), arrayList.get(i));
        }
        sb.append("]");
    }

    @Override // com.google.android.gms.internal.ae
    public HashMap<String, ae.a<?, ?>> T() {
        if (this.cB == null) {
            return null;
        }
        return this.cB.q(this.mClassName);
    }

    public Parcel al() {
        switch (this.cL) {
            case 0:
                this.cM = com.google.android.gms.common.internal.safeparcel.b.d(this.cJ);
                com.google.android.gms.common.internal.safeparcel.b.C(this.cJ, this.cM);
                this.cL = 2;
                break;
            case 1:
                com.google.android.gms.common.internal.safeparcel.b.C(this.cJ, this.cM);
                this.cL = 2;
                break;
        }
        return this.cJ;
    }

    ah am() {
        switch (this.cK) {
            case 0:
                return null;
            case 1:
                return this.cB;
            case 2:
                return this.cB;
            default:
                throw new IllegalStateException("Invalid creation type: " + this.cK);
        }
    }

    @Override // android.os.Parcelable
    public int describeContents() {
        al alVar = CREATOR;
        return 0;
    }

    public int i() {
        return this.ab;
    }

    @Override // com.google.android.gms.internal.ae
    protected Object m(String str) {
        throw new UnsupportedOperationException("Converting to JSON does not require this method.");
    }

    @Override // com.google.android.gms.internal.ae
    protected boolean n(String str) {
        throw new UnsupportedOperationException("Converting to JSON does not require this method.");
    }

    @Override // com.google.android.gms.internal.ae
    public String toString() {
        s.b(this.cB, "Cannot convert to JSON on client side.");
        Parcel parcelAl = al();
        parcelAl.setDataPosition(0);
        StringBuilder sb = new StringBuilder(100);
        a(sb, this.cB.q(this.mClassName), parcelAl);
        return sb.toString();
    }

    @Override // android.os.Parcelable
    public void writeToParcel(Parcel out, int flags) {
        al alVar = CREATOR;
        al.a(this, out, flags);
    }
}
