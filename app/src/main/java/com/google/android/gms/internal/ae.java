package com.google.android.gms.internal;

import android.os.Parcel;
import com.google.android.gms.common.internal.safeparcel.SafeParcelable;
import java.util.ArrayList;
import java.util.HashMap;

/* loaded from: classes.dex */
public abstract class ae {

    public static class a<I, O> implements SafeParcelable {
        public static final af CREATOR = new af();
        private final int ab;
        protected final String cA;
        private ah cB;
        private b<I, O> cC;
        protected final int ct;
        protected final boolean cu;
        protected final int cv;
        protected final boolean cw;
        protected final String cx;
        protected final int cy;
        protected final Class<? extends ae> cz;

        a(int i, int i2, boolean z, int i3, boolean z2, String str, int i4, String str2, z zVar) {
            this.ab = i;
            this.ct = i2;
            this.cu = z;
            this.cv = i3;
            this.cw = z2;
            this.cx = str;
            this.cy = i4;
            if (str2 == null) {
                this.cz = null;
                this.cA = null;
            } else {
                this.cz = ak.class;
                this.cA = str2;
            }
            if (zVar == null) {
                this.cC = null;
            } else {
                this.cC = (b<I, O>) zVar.P();
            }
        }

        protected a(int i, boolean z, int i2, boolean z2, String str, int i3, Class<? extends ae> cls, b<I, O> bVar) {
            this.ab = 1;
            this.ct = i;
            this.cu = z;
            this.cv = i2;
            this.cw = z2;
            this.cx = str;
            this.cy = i3;
            this.cz = cls;
            if (cls == null) {
                this.cA = null;
            } else {
                this.cA = cls.getCanonicalName();
            }
            this.cC = bVar;
        }

        public static a a(String str, int i, b<?, ?> bVar, boolean z) {
            return new a(bVar.R(), z, bVar.S(), false, str, i, null, bVar);
        }

        public static <T extends ae> a<T, T> a(String str, int i, Class<T> cls) {
            return new a<>(11, false, 11, false, str, i, cls, null);
        }

        public static <T extends ae> a<ArrayList<T>, ArrayList<T>> b(String str, int i, Class<T> cls) {
            return new a<>(11, true, 11, true, str, i, cls, null);
        }

        public static a<Integer, Integer> c(String str, int i) {
            return new a<>(0, false, 0, false, str, i, null, null);
        }

        public static a<Double, Double> d(String str, int i) {
            return new a<>(4, false, 4, false, str, i, null, null);
        }

        public static a<Boolean, Boolean> e(String str, int i) {
            return new a<>(6, false, 6, false, str, i, null, null);
        }

        public static a<String, String> f(String str, int i) {
            return new a<>(7, false, 7, false, str, i, null, null);
        }

        public static a<ArrayList<String>, ArrayList<String>> g(String str, int i) {
            return new a<>(7, true, 7, true, str, i, null, null);
        }

        public int R() {
            return this.ct;
        }

        public int S() {
            return this.cv;
        }

        public a<I, O> W() {
            return new a<>(this.ab, this.ct, this.cu, this.cv, this.cw, this.cx, this.cy, this.cA, ae());
        }

        public boolean X() {
            return this.cu;
        }

        public boolean Y() {
            return this.cw;
        }

        public String Z() {
            return this.cx;
        }

        public void a(ah ahVar) {
            this.cB = ahVar;
        }

        public int aa() {
            return this.cy;
        }

        public Class<? extends ae> ab() {
            return this.cz;
        }

        String ac() {
            if (this.cA == null) {
                return null;
            }
            return this.cA;
        }

        public boolean ad() {
            return this.cC != null;
        }

        z ae() {
            if (this.cC == null) {
                return null;
            }
            return z.a(this.cC);
        }

        public HashMap<String, a<?, ?>> af() {
            s.d(this.cA);
            s.d(this.cB);
            return this.cB.q(this.cA);
        }

        @Override // android.os.Parcelable
        public int describeContents() {
            af afVar = CREATOR;
            return 0;
        }

        public I e(O o) {
            return this.cC.e(o);
        }

        public int i() {
            return this.ab;
        }

        public String toString() {
            StringBuilder sb = new StringBuilder();
            sb.append("Field\n");
            sb.append("            versionCode=").append(this.ab).append('\n');
            sb.append("                 typeIn=").append(this.ct).append('\n');
            sb.append("            typeInArray=").append(this.cu).append('\n');
            sb.append("                typeOut=").append(this.cv).append('\n');
            sb.append("           typeOutArray=").append(this.cw).append('\n');
            sb.append("        outputFieldName=").append(this.cx).append('\n');
            sb.append("      safeParcelFieldId=").append(this.cy).append('\n');
            sb.append("       concreteTypeName=").append(ac()).append('\n');
            if (ab() != null) {
                sb.append("     concreteType.class=").append(ab().getCanonicalName()).append('\n');
            }
            sb.append("          converterName=").append(this.cC == null ? "null" : this.cC.getClass().getCanonicalName()).append('\n');
            return sb.toString();
        }

        @Override // android.os.Parcelable
        public void writeToParcel(Parcel out, int flags) {
            af afVar = CREATOR;
            af.a(this, out, flags);
        }
    }

    public interface b<I, O> {
        int R();

        int S();

        I e(O o);
    }

    private void a(StringBuilder sb, a aVar, Object obj) {
        if (aVar.R() == 11) {
            sb.append(aVar.ab().cast(obj).toString());
        } else {
            if (aVar.R() != 7) {
                sb.append(obj);
                return;
            }
            sb.append("\"");
            sb.append(aq.r((String) obj));
            sb.append("\"");
        }
    }

    private void a(StringBuilder sb, a aVar, ArrayList<Object> arrayList) {
        sb.append("[");
        int size = arrayList.size();
        for (int i = 0; i < size; i++) {
            if (i > 0) {
                sb.append(",");
            }
            Object obj = arrayList.get(i);
            if (obj != null) {
                a(sb, aVar, obj);
            }
        }
        sb.append("]");
    }

    public abstract HashMap<String, a<?, ?>> T();

    public HashMap<String, Object> U() {
        return null;
    }

    public HashMap<String, Object> V() {
        return null;
    }

    /* JADX WARN: Multi-variable type inference failed */
    protected <O, I> I a(a<I, O> aVar, Object obj) {
        return ((a) aVar).cC != null ? aVar.e(obj) : obj;
    }

    protected boolean a(a aVar) {
        return aVar.S() == 11 ? aVar.Y() ? p(aVar.Z()) : o(aVar.Z()) : n(aVar.Z());
    }

    protected Object b(a aVar) {
        String strZ = aVar.Z();
        if (aVar.ab() == null) {
            return m(aVar.Z());
        }
        s.a(m(aVar.Z()) == null, "Concrete field shouldn't be value object: " + aVar.Z());
        HashMap<String, Object> mapV = aVar.Y() ? V() : U();
        if (mapV != null) {
            return mapV.get(strZ);
        }
        try {
            return getClass().getMethod("get" + Character.toUpperCase(strZ.charAt(0)) + strZ.substring(1), new Class[0]).invoke(this, new Object[0]);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    protected abstract Object m(String str);

    protected abstract boolean n(String str);

    protected boolean o(String str) {
        throw new UnsupportedOperationException("Concrete types not supported");
    }

    protected boolean p(String str) {
        throw new UnsupportedOperationException("Concrete type arrays not supported");
    }

    public String toString() {
        HashMap<String, a<?, ?>> mapT = T();
        StringBuilder sb = new StringBuilder(100);
        for (String str : mapT.keySet()) {
            a<?, ?> aVar = mapT.get(str);
            if (a(aVar)) {
                Object objA = a(aVar, b(aVar));
                if (sb.length() == 0) {
                    sb.append("{");
                } else {
                    sb.append(",");
                }
                sb.append("\"").append(str).append("\":");
                if (objA != null) {
                    switch (aVar.S()) {
                        case 8:
                            sb.append("\"").append(an.a((byte[]) objA)).append("\"");
                            break;
                        case 9:
                            sb.append("\"").append(an.b((byte[]) objA)).append("\"");
                            break;
                        case 10:
                            ar.a(sb, (HashMap) objA);
                            break;
                        default:
                            if (aVar.X()) {
                                a(sb, (a) aVar, (ArrayList<Object>) objA);
                                break;
                            } else {
                                a(sb, aVar, objA);
                                break;
                            }
                    }
                } else {
                    sb.append("null");
                }
            }
        }
        if (sb.length() > 0) {
            sb.append("}");
        } else {
            sb.append("{}");
        }
        return sb.toString();
    }
}
