package com.google.android.gms.internal;

import android.os.Parcel;
import com.google.android.gms.common.internal.safeparcel.SafeParcelable;
import com.google.android.gms.internal.ae;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;

/* loaded from: classes.dex */
public class ah implements SafeParcelable {
    public static final ai CREATOR = new ai();
    private final int ab;
    private final HashMap<String, HashMap<String, ae.a<?, ?>>> cD;
    private final ArrayList<a> cE;
    private final String cF;

    public static class a implements SafeParcelable {
        public static final aj CREATOR = new aj();
        final ArrayList<b> cG;
        final String className;
        final int versionCode;

        a(int i, String str, ArrayList<b> arrayList) {
            this.versionCode = i;
            this.className = str;
            this.cG = arrayList;
        }

        a(String str, HashMap<String, ae.a<?, ?>> map) {
            this.versionCode = 1;
            this.className = str;
            this.cG = a(map);
        }

        private static ArrayList<b> a(HashMap<String, ae.a<?, ?>> map) {
            if (map == null) {
                return null;
            }
            ArrayList<b> arrayList = new ArrayList<>();
            for (String str : map.keySet()) {
                arrayList.add(new b(str, map.get(str)));
            }
            return arrayList;
        }

        HashMap<String, ae.a<?, ?>> ak() {
            HashMap<String, ae.a<?, ?>> map = new HashMap<>();
            int size = this.cG.size();
            for (int i = 0; i < size; i++) {
                b bVar = this.cG.get(i);
                map.put(bVar.cH, bVar.cI);
            }
            return map;
        }

        @Override // android.os.Parcelable
        public int describeContents() {
            aj ajVar = CREATOR;
            return 0;
        }

        @Override // android.os.Parcelable
        public void writeToParcel(Parcel out, int flags) {
            aj ajVar = CREATOR;
            aj.a(this, out, flags);
        }
    }

    public static class b implements SafeParcelable {
        public static final ag CREATOR = new ag();
        final String cH;
        final ae.a<?, ?> cI;
        final int versionCode;

        b(int i, String str, ae.a<?, ?> aVar) {
            this.versionCode = i;
            this.cH = str;
            this.cI = aVar;
        }

        b(String str, ae.a<?, ?> aVar) {
            this.versionCode = 1;
            this.cH = str;
            this.cI = aVar;
        }

        @Override // android.os.Parcelable
        public int describeContents() {
            ag agVar = CREATOR;
            return 0;
        }

        @Override // android.os.Parcelable
        public void writeToParcel(Parcel out, int flags) {
            ag agVar = CREATOR;
            ag.a(this, out, flags);
        }
    }

    ah(int i, ArrayList<a> arrayList, String str) {
        this.ab = i;
        this.cE = null;
        this.cD = b(arrayList);
        this.cF = (String) s.d(str);
        ag();
    }

    public ah(Class<? extends ae> cls) {
        this.ab = 1;
        this.cE = null;
        this.cD = new HashMap<>();
        this.cF = cls.getCanonicalName();
    }

    private static HashMap<String, HashMap<String, ae.a<?, ?>>> b(ArrayList<a> arrayList) {
        HashMap<String, HashMap<String, ae.a<?, ?>>> map = new HashMap<>();
        int size = arrayList.size();
        for (int i = 0; i < size; i++) {
            a aVar = arrayList.get(i);
            map.put(aVar.className, aVar.ak());
        }
        return map;
    }

    public void a(Class<? extends ae> cls, HashMap<String, ae.a<?, ?>> map) {
        this.cD.put(cls.getCanonicalName(), map);
    }

    public void ag() {
        Iterator<String> it = this.cD.keySet().iterator();
        while (it.hasNext()) {
            HashMap<String, ae.a<?, ?>> map = this.cD.get(it.next());
            Iterator<String> it2 = map.keySet().iterator();
            while (it2.hasNext()) {
                map.get(it2.next()).a(this);
            }
        }
    }

    public void ah() {
        for (String str : this.cD.keySet()) {
            HashMap<String, ae.a<?, ?>> map = this.cD.get(str);
            HashMap<String, ae.a<?, ?>> map2 = new HashMap<>();
            for (String str2 : map.keySet()) {
                map2.put(str2, map.get(str2).W());
            }
            this.cD.put(str, map2);
        }
    }

    ArrayList<a> ai() {
        ArrayList<a> arrayList = new ArrayList<>();
        for (String str : this.cD.keySet()) {
            arrayList.add(new a(str, this.cD.get(str)));
        }
        return arrayList;
    }

    public String aj() {
        return this.cF;
    }

    public boolean b(Class<? extends ae> cls) {
        return this.cD.containsKey(cls.getCanonicalName());
    }

    @Override // android.os.Parcelable
    public int describeContents() {
        ai aiVar = CREATOR;
        return 0;
    }

    int i() {
        return this.ab;
    }

    public HashMap<String, ae.a<?, ?>> q(String str) {
        return this.cD.get(str);
    }

    public String toString() {
        StringBuilder sb = new StringBuilder();
        for (String str : this.cD.keySet()) {
            sb.append(str).append(":\n");
            HashMap<String, ae.a<?, ?>> map = this.cD.get(str);
            for (String str2 : map.keySet()) {
                sb.append("  ").append(str2).append(": ");
                sb.append(map.get(str2));
            }
        }
        return sb.toString();
    }

    @Override // android.os.Parcelable
    public void writeToParcel(Parcel out, int flags) {
        ai aiVar = CREATOR;
        ai.a(this, out, flags);
    }
}
