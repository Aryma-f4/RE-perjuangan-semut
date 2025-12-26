package com.google.android.gms.internal;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

/* loaded from: classes.dex */
public final class r {

    public static final class a {
        private final List<String> bY;
        private final Object bZ;

        private a(Object obj) {
            this.bZ = s.d(obj);
            this.bY = new ArrayList();
        }

        public a a(String str, Object obj) {
            this.bY.add(((String) s.d(str)) + "=" + String.valueOf(obj));
            return this;
        }

        public String toString() {
            StringBuilder sbAppend = new StringBuilder(100).append(this.bZ.getClass().getSimpleName()).append('{');
            int size = this.bY.size();
            for (int i = 0; i < size; i++) {
                sbAppend.append(this.bY.get(i));
                if (i < size - 1) {
                    sbAppend.append(", ");
                }
            }
            return sbAppend.append('}').toString();
        }
    }

    public static boolean a(Object obj, Object obj2) {
        return obj == obj2 || (obj != null && obj.equals(obj2));
    }

    public static a c(Object obj) {
        return new a(obj);
    }

    public static int hashCode(Object... objects) {
        return Arrays.hashCode(objects);
    }
}
