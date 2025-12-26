package com.google.android.gms.internal;

import android.os.Parcel;
import com.google.android.gms.common.internal.safeparcel.SafeParcelable;
import com.google.android.gms.internal.ae;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;

/* loaded from: classes.dex */
public final class ab implements SafeParcelable, ae.b<String, Integer> {
    public static final ac CREATOR = new ac();
    private final int ab;
    private final HashMap<String, Integer> co;
    private final HashMap<Integer, String> cp;
    private final ArrayList<a> cq;

    public static final class a implements SafeParcelable {
        public static final ad CREATOR = new ad();
        final String cr;
        final int cs;
        final int versionCode;

        a(int i, String str, int i2) {
            this.versionCode = i;
            this.cr = str;
            this.cs = i2;
        }

        a(String str, int i) {
            this.versionCode = 1;
            this.cr = str;
            this.cs = i;
        }

        @Override // android.os.Parcelable
        public int describeContents() {
            ad adVar = CREATOR;
            return 0;
        }

        @Override // android.os.Parcelable
        public void writeToParcel(Parcel out, int flags) {
            ad adVar = CREATOR;
            ad.a(this, out, flags);
        }
    }

    public ab() {
        this.ab = 1;
        this.co = new HashMap<>();
        this.cp = new HashMap<>();
        this.cq = null;
    }

    ab(int i, ArrayList<a> arrayList) {
        this.ab = i;
        this.co = new HashMap<>();
        this.cp = new HashMap<>();
        this.cq = null;
        a(arrayList);
    }

    private void a(ArrayList<a> arrayList) {
        Iterator<a> it = arrayList.iterator();
        while (it.hasNext()) {
            a next = it.next();
            b(next.cr, next.cs);
        }
    }

    ArrayList<a> Q() {
        ArrayList<a> arrayList = new ArrayList<>();
        for (String str : this.co.keySet()) {
            arrayList.add(new a(str, this.co.get(str).intValue()));
        }
        return arrayList;
    }

    @Override // com.google.android.gms.internal.ae.b
    public int R() {
        return 7;
    }

    @Override // com.google.android.gms.internal.ae.b
    public int S() {
        return 0;
    }

    @Override // com.google.android.gms.internal.ae.b
    /* renamed from: a, reason: merged with bridge method [inline-methods] */
    public String e(Integer num) {
        String str = this.cp.get(num);
        return (str == null && this.co.containsKey("gms_unknown")) ? "gms_unknown" : str;
    }

    public ab b(String str, int i) {
        this.co.put(str, Integer.valueOf(i));
        this.cp.put(Integer.valueOf(i), str);
        return this;
    }

    @Override // android.os.Parcelable
    public int describeContents() {
        ac acVar = CREATOR;
        return 0;
    }

    int i() {
        return this.ab;
    }

    @Override // android.os.Parcelable
    public void writeToParcel(Parcel out, int flags) {
        ac acVar = CREATOR;
        ac.a(this, out, flags);
    }
}
