package com.google.android.gms.internal;

import android.os.Parcel;
import com.facebook.internal.ServerProtocol;
import com.google.android.gms.common.internal.safeparcel.SafeParcelable;
import com.google.android.gms.internal.ae;
import com.google.android.gms.plus.model.moments.ItemScope;
import com.google.android.gms.plus.model.moments.Moment;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Set;

/* loaded from: classes.dex */
public final class bz extends ae implements SafeParcelable, Moment {
    public static final ca CREATOR = new ca();
    private static final HashMap<String, ae.a<?, ?>> iC = new HashMap<>();
    private final int ab;
    private final Set<Integer> iD;
    private bx jB;
    private bx jC;
    private String jh;
    private String js;
    private String jy;

    static {
        iC.put("id", ae.a.f("id", 2));
        iC.put("result", ae.a.a("result", 4, bx.class));
        iC.put("startDate", ae.a.f("startDate", 5));
        iC.put("target", ae.a.a("target", 6, bx.class));
        iC.put(ServerProtocol.DIALOG_PARAM_TYPE, ae.a.f(ServerProtocol.DIALOG_PARAM_TYPE, 7));
    }

    public bz() {
        this.ab = 1;
        this.iD = new HashSet();
    }

    bz(Set<Integer> set, int i, String str, bx bxVar, String str2, bx bxVar2, String str3) {
        this.iD = set;
        this.ab = i;
        this.jh = str;
        this.jB = bxVar;
        this.js = str2;
        this.jC = bxVar2;
        this.jy = str3;
    }

    public bz(Set<Integer> set, String str, bx bxVar, String str2, bx bxVar2, String str3) {
        this.iD = set;
        this.ab = 1;
        this.jh = str;
        this.jB = bxVar;
        this.js = str2;
        this.jC = bxVar2;
        this.jy = str3;
    }

    @Override // com.google.android.gms.internal.ae
    public HashMap<String, ae.a<?, ?>> T() {
        return iC;
    }

    @Override // com.google.android.gms.internal.ae
    protected boolean a(ae.a aVar) {
        return this.iD.contains(Integer.valueOf(aVar.aa()));
    }

    @Override // com.google.android.gms.internal.ae
    protected Object b(ae.a aVar) {
        switch (aVar.aa()) {
            case 2:
                return this.jh;
            case 3:
            default:
                throw new IllegalStateException("Unknown safe parcelable id=" + aVar.aa());
            case 4:
                return this.jB;
            case 5:
                return this.js;
            case 6:
                return this.jC;
            case 7:
                return this.jy;
        }
    }

    Set<Integer> bH() {
        return this.iD;
    }

    bx bY() {
        return this.jB;
    }

    bx bZ() {
        return this.jC;
    }

    @Override // com.google.android.gms.common.data.Freezable
    /* renamed from: ca, reason: merged with bridge method [inline-methods] */
    public bz freeze() {
        return this;
    }

    @Override // android.os.Parcelable
    public int describeContents() {
        ca caVar = CREATOR;
        return 0;
    }

    public boolean equals(Object obj) {
        if (!(obj instanceof bz)) {
            return false;
        }
        if (this == obj) {
            return true;
        }
        bz bzVar = (bz) obj;
        for (ae.a<?, ?> aVar : iC.values()) {
            if (a(aVar)) {
                if (bzVar.a(aVar) && b(aVar).equals(bzVar.b(aVar))) {
                }
                return false;
            }
            if (bzVar.a(aVar)) {
                return false;
            }
        }
        return true;
    }

    @Override // com.google.android.gms.plus.model.moments.Moment
    public String getId() {
        return this.jh;
    }

    @Override // com.google.android.gms.plus.model.moments.Moment
    public ItemScope getResult() {
        return this.jB;
    }

    @Override // com.google.android.gms.plus.model.moments.Moment
    public String getStartDate() {
        return this.js;
    }

    @Override // com.google.android.gms.plus.model.moments.Moment
    public ItemScope getTarget() {
        return this.jC;
    }

    @Override // com.google.android.gms.plus.model.moments.Moment
    public String getType() {
        return this.jy;
    }

    @Override // com.google.android.gms.plus.model.moments.Moment
    public boolean hasId() {
        return this.iD.contains(2);
    }

    @Override // com.google.android.gms.plus.model.moments.Moment
    public boolean hasResult() {
        return this.iD.contains(4);
    }

    @Override // com.google.android.gms.plus.model.moments.Moment
    public boolean hasStartDate() {
        return this.iD.contains(5);
    }

    @Override // com.google.android.gms.plus.model.moments.Moment
    public boolean hasTarget() {
        return this.iD.contains(6);
    }

    @Override // com.google.android.gms.plus.model.moments.Moment
    public boolean hasType() {
        return this.iD.contains(7);
    }

    public int hashCode() {
        int iHashCode = 0;
        Iterator<ae.a<?, ?>> it = iC.values().iterator();
        while (true) {
            int i = iHashCode;
            if (!it.hasNext()) {
                return i;
            }
            ae.a<?, ?> next = it.next();
            if (a(next)) {
                iHashCode = b(next).hashCode() + i + next.aa();
            } else {
                iHashCode = i;
            }
        }
    }

    int i() {
        return this.ab;
    }

    @Override // com.google.android.gms.common.data.Freezable
    public boolean isDataValid() {
        return true;
    }

    @Override // com.google.android.gms.internal.ae
    protected Object m(String str) {
        return null;
    }

    @Override // com.google.android.gms.internal.ae
    protected boolean n(String str) {
        return false;
    }

    @Override // android.os.Parcelable
    public void writeToParcel(Parcel out, int flags) {
        ca caVar = CREATOR;
        ca.a(this, out, flags);
    }
}
