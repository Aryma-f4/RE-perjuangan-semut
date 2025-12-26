package com.google.android.gms.internal;

import android.os.Parcel;
import android.support.v4.util.TimeUtils;
import android.support.v7.appcompat.R;
import com.facebook.internal.ServerProtocol;
import com.google.android.gms.common.internal.safeparcel.SafeParcelable;
import com.google.android.gms.internal.ae;
import com.google.android.gms.plus.PlusShare;
import com.google.android.gms.plus.model.people.Person;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

/* loaded from: classes.dex */
public final class cc extends ae implements SafeParcelable, Person {
    public static final cd CREATOR = new cd();
    private static final HashMap<String, ae.a<?, ?>> iC = new HashMap<>();
    private final int ab;
    private String cl;
    private final Set<Integer> iD;
    private String ie;
    private String jE;
    private a jF;
    private String jG;
    private String jH;
    private int jI;
    private b jJ;
    private String jK;
    private int jL;
    private c jM;
    private boolean jN;
    private String jO;
    private d jP;
    private String jQ;
    private int jR;
    private List<f> jS;
    private List<g> jT;
    private int jU;
    private int jV;
    private String jW;
    private List<h> jX;
    private boolean jY;
    private String jh;

    public static final class a extends ae implements SafeParcelable, Person.AgeRange {
        public static final ce CREATOR = new ce();
        private static final HashMap<String, ae.a<?, ?>> iC = new HashMap<>();
        private final int ab;
        private final Set<Integer> iD;
        private int jZ;
        private int ka;

        static {
            iC.put("max", ae.a.c("max", 2));
            iC.put("min", ae.a.c("min", 3));
        }

        public a() {
            this.ab = 1;
            this.iD = new HashSet();
        }

        a(Set<Integer> set, int i, int i2, int i3) {
            this.iD = set;
            this.ab = i;
            this.jZ = i2;
            this.ka = i3;
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
                    return Integer.valueOf(this.jZ);
                case 3:
                    return Integer.valueOf(this.ka);
                default:
                    throw new IllegalStateException("Unknown safe parcelable id=" + aVar.aa());
            }
        }

        Set<Integer> bH() {
            return this.iD;
        }

        @Override // com.google.android.gms.common.data.Freezable
        /* renamed from: ck, reason: merged with bridge method [inline-methods] */
        public a freeze() {
            return this;
        }

        @Override // android.os.Parcelable
        public int describeContents() {
            ce ceVar = CREATOR;
            return 0;
        }

        public boolean equals(Object obj) {
            if (!(obj instanceof a)) {
                return false;
            }
            if (this == obj) {
                return true;
            }
            a aVar = (a) obj;
            for (ae.a<?, ?> aVar2 : iC.values()) {
                if (a(aVar2)) {
                    if (aVar.a(aVar2) && b(aVar2).equals(aVar.b(aVar2))) {
                    }
                    return false;
                }
                if (aVar.a(aVar2)) {
                    return false;
                }
            }
            return true;
        }

        @Override // com.google.android.gms.plus.model.people.Person.AgeRange
        public int getMax() {
            return this.jZ;
        }

        @Override // com.google.android.gms.plus.model.people.Person.AgeRange
        public int getMin() {
            return this.ka;
        }

        @Override // com.google.android.gms.plus.model.people.Person.AgeRange
        public boolean hasMax() {
            return this.iD.contains(2);
        }

        @Override // com.google.android.gms.plus.model.people.Person.AgeRange
        public boolean hasMin() {
            return this.iD.contains(3);
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
            ce ceVar = CREATOR;
            ce.a(this, out, flags);
        }
    }

    public static final class b extends ae implements SafeParcelable, Person.Cover {
        public static final cf CREATOR = new cf();
        private static final HashMap<String, ae.a<?, ?>> iC = new HashMap<>();
        private final int ab;
        private final Set<Integer> iD;
        private a kb;
        private C0019b kc;
        private int kd;

        public static final class a extends ae implements SafeParcelable, Person.Cover.CoverInfo {
            public static final cg CREATOR = new cg();
            private static final HashMap<String, ae.a<?, ?>> iC = new HashMap<>();
            private final int ab;
            private final Set<Integer> iD;
            private int ke;
            private int kf;

            static {
                iC.put("leftImageOffset", ae.a.c("leftImageOffset", 2));
                iC.put("topImageOffset", ae.a.c("topImageOffset", 3));
            }

            public a() {
                this.ab = 1;
                this.iD = new HashSet();
            }

            a(Set<Integer> set, int i, int i2, int i3) {
                this.iD = set;
                this.ab = i;
                this.ke = i2;
                this.kf = i3;
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
                        return Integer.valueOf(this.ke);
                    case 3:
                        return Integer.valueOf(this.kf);
                    default:
                        throw new IllegalStateException("Unknown safe parcelable id=" + aVar.aa());
                }
            }

            Set<Integer> bH() {
                return this.iD;
            }

            @Override // com.google.android.gms.common.data.Freezable
            /* renamed from: co, reason: merged with bridge method [inline-methods] */
            public a freeze() {
                return this;
            }

            @Override // android.os.Parcelable
            public int describeContents() {
                cg cgVar = CREATOR;
                return 0;
            }

            public boolean equals(Object obj) {
                if (!(obj instanceof a)) {
                    return false;
                }
                if (this == obj) {
                    return true;
                }
                a aVar = (a) obj;
                for (ae.a<?, ?> aVar2 : iC.values()) {
                    if (a(aVar2)) {
                        if (aVar.a(aVar2) && b(aVar2).equals(aVar.b(aVar2))) {
                        }
                        return false;
                    }
                    if (aVar.a(aVar2)) {
                        return false;
                    }
                }
                return true;
            }

            @Override // com.google.android.gms.plus.model.people.Person.Cover.CoverInfo
            public int getLeftImageOffset() {
                return this.ke;
            }

            @Override // com.google.android.gms.plus.model.people.Person.Cover.CoverInfo
            public int getTopImageOffset() {
                return this.kf;
            }

            @Override // com.google.android.gms.plus.model.people.Person.Cover.CoverInfo
            public boolean hasLeftImageOffset() {
                return this.iD.contains(2);
            }

            @Override // com.google.android.gms.plus.model.people.Person.Cover.CoverInfo
            public boolean hasTopImageOffset() {
                return this.iD.contains(3);
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
                cg cgVar = CREATOR;
                cg.a(this, out, flags);
            }
        }

        /* renamed from: com.google.android.gms.internal.cc$b$b, reason: collision with other inner class name */
        public static final class C0019b extends ae implements SafeParcelable, Person.Cover.CoverPhoto {
            public static final ch CREATOR = new ch();
            private static final HashMap<String, ae.a<?, ?>> iC = new HashMap<>();
            private final int ab;
            private int hL;
            private int hM;
            private final Set<Integer> iD;
            private String ie;

            static {
                iC.put("height", ae.a.c("height", 2));
                iC.put("url", ae.a.f("url", 3));
                iC.put("width", ae.a.c("width", 4));
            }

            public C0019b() {
                this.ab = 1;
                this.iD = new HashSet();
            }

            C0019b(Set<Integer> set, int i, int i2, String str, int i3) {
                this.iD = set;
                this.ab = i;
                this.hM = i2;
                this.ie = str;
                this.hL = i3;
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
                        return Integer.valueOf(this.hM);
                    case 3:
                        return this.ie;
                    case 4:
                        return Integer.valueOf(this.hL);
                    default:
                        throw new IllegalStateException("Unknown safe parcelable id=" + aVar.aa());
                }
            }

            Set<Integer> bH() {
                return this.iD;
            }

            @Override // com.google.android.gms.common.data.Freezable
            /* renamed from: cp, reason: merged with bridge method [inline-methods] */
            public C0019b freeze() {
                return this;
            }

            @Override // android.os.Parcelable
            public int describeContents() {
                ch chVar = CREATOR;
                return 0;
            }

            public boolean equals(Object obj) {
                if (!(obj instanceof C0019b)) {
                    return false;
                }
                if (this == obj) {
                    return true;
                }
                C0019b c0019b = (C0019b) obj;
                for (ae.a<?, ?> aVar : iC.values()) {
                    if (a(aVar)) {
                        if (c0019b.a(aVar) && b(aVar).equals(c0019b.b(aVar))) {
                        }
                        return false;
                    }
                    if (c0019b.a(aVar)) {
                        return false;
                    }
                }
                return true;
            }

            @Override // com.google.android.gms.plus.model.people.Person.Cover.CoverPhoto
            public int getHeight() {
                return this.hM;
            }

            @Override // com.google.android.gms.plus.model.people.Person.Cover.CoverPhoto
            public String getUrl() {
                return this.ie;
            }

            @Override // com.google.android.gms.plus.model.people.Person.Cover.CoverPhoto
            public int getWidth() {
                return this.hL;
            }

            @Override // com.google.android.gms.plus.model.people.Person.Cover.CoverPhoto
            public boolean hasHeight() {
                return this.iD.contains(2);
            }

            @Override // com.google.android.gms.plus.model.people.Person.Cover.CoverPhoto
            public boolean hasUrl() {
                return this.iD.contains(3);
            }

            @Override // com.google.android.gms.plus.model.people.Person.Cover.CoverPhoto
            public boolean hasWidth() {
                return this.iD.contains(4);
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
                ch chVar = CREATOR;
                ch.a(this, out, flags);
            }
        }

        static {
            iC.put("coverInfo", ae.a.a("coverInfo", 2, a.class));
            iC.put("coverPhoto", ae.a.a("coverPhoto", 3, C0019b.class));
            iC.put("layout", ae.a.a("layout", 4, new ab().b("banner", 0), false));
        }

        public b() {
            this.ab = 1;
            this.iD = new HashSet();
        }

        b(Set<Integer> set, int i, a aVar, C0019b c0019b, int i2) {
            this.iD = set;
            this.ab = i;
            this.kb = aVar;
            this.kc = c0019b;
            this.kd = i2;
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
                    return this.kb;
                case 3:
                    return this.kc;
                case 4:
                    return Integer.valueOf(this.kd);
                default:
                    throw new IllegalStateException("Unknown safe parcelable id=" + aVar.aa());
            }
        }

        Set<Integer> bH() {
            return this.iD;
        }

        a cl() {
            return this.kb;
        }

        C0019b cm() {
            return this.kc;
        }

        @Override // com.google.android.gms.common.data.Freezable
        /* renamed from: cn, reason: merged with bridge method [inline-methods] */
        public b freeze() {
            return this;
        }

        @Override // android.os.Parcelable
        public int describeContents() {
            cf cfVar = CREATOR;
            return 0;
        }

        public boolean equals(Object obj) {
            if (!(obj instanceof b)) {
                return false;
            }
            if (this == obj) {
                return true;
            }
            b bVar = (b) obj;
            for (ae.a<?, ?> aVar : iC.values()) {
                if (a(aVar)) {
                    if (bVar.a(aVar) && b(aVar).equals(bVar.b(aVar))) {
                    }
                    return false;
                }
                if (bVar.a(aVar)) {
                    return false;
                }
            }
            return true;
        }

        @Override // com.google.android.gms.plus.model.people.Person.Cover
        public Person.Cover.CoverInfo getCoverInfo() {
            return this.kb;
        }

        @Override // com.google.android.gms.plus.model.people.Person.Cover
        public Person.Cover.CoverPhoto getCoverPhoto() {
            return this.kc;
        }

        @Override // com.google.android.gms.plus.model.people.Person.Cover
        public int getLayout() {
            return this.kd;
        }

        @Override // com.google.android.gms.plus.model.people.Person.Cover
        public boolean hasCoverInfo() {
            return this.iD.contains(2);
        }

        @Override // com.google.android.gms.plus.model.people.Person.Cover
        public boolean hasCoverPhoto() {
            return this.iD.contains(3);
        }

        @Override // com.google.android.gms.plus.model.people.Person.Cover
        public boolean hasLayout() {
            return this.iD.contains(4);
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
            cf cfVar = CREATOR;
            cf.a(this, out, flags);
        }
    }

    public static final class c extends ae implements SafeParcelable, Person.Image {
        public static final ci CREATOR = new ci();
        private static final HashMap<String, ae.a<?, ?>> iC = new HashMap<>();
        private final int ab;
        private final Set<Integer> iD;
        private String ie;

        static {
            iC.put("url", ae.a.f("url", 2));
        }

        public c() {
            this.ab = 1;
            this.iD = new HashSet();
        }

        public c(String str) {
            this.iD = new HashSet();
            this.ab = 1;
            this.ie = str;
            this.iD.add(2);
        }

        c(Set<Integer> set, int i, String str) {
            this.iD = set;
            this.ab = i;
            this.ie = str;
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
                    return this.ie;
                default:
                    throw new IllegalStateException("Unknown safe parcelable id=" + aVar.aa());
            }
        }

        Set<Integer> bH() {
            return this.iD;
        }

        @Override // com.google.android.gms.common.data.Freezable
        /* renamed from: cq, reason: merged with bridge method [inline-methods] */
        public c freeze() {
            return this;
        }

        @Override // android.os.Parcelable
        public int describeContents() {
            ci ciVar = CREATOR;
            return 0;
        }

        public boolean equals(Object obj) {
            if (!(obj instanceof c)) {
                return false;
            }
            if (this == obj) {
                return true;
            }
            c cVar = (c) obj;
            for (ae.a<?, ?> aVar : iC.values()) {
                if (a(aVar)) {
                    if (cVar.a(aVar) && b(aVar).equals(cVar.b(aVar))) {
                    }
                    return false;
                }
                if (cVar.a(aVar)) {
                    return false;
                }
            }
            return true;
        }

        @Override // com.google.android.gms.plus.model.people.Person.Image
        public String getUrl() {
            return this.ie;
        }

        @Override // com.google.android.gms.plus.model.people.Person.Image
        public boolean hasUrl() {
            return this.iD.contains(2);
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
            ci ciVar = CREATOR;
            ci.a(this, out, flags);
        }
    }

    public static final class d extends ae implements SafeParcelable, Person.Name {
        public static final cj CREATOR = new cj();
        private static final HashMap<String, ae.a<?, ?>> iC = new HashMap<>();
        private final int ab;
        private final Set<Integer> iD;
        private String jc;
        private String jf;
        private String kg;
        private String kh;
        private String ki;
        private String kj;

        static {
            iC.put("familyName", ae.a.f("familyName", 2));
            iC.put("formatted", ae.a.f("formatted", 3));
            iC.put("givenName", ae.a.f("givenName", 4));
            iC.put("honorificPrefix", ae.a.f("honorificPrefix", 5));
            iC.put("honorificSuffix", ae.a.f("honorificSuffix", 6));
            iC.put("middleName", ae.a.f("middleName", 7));
        }

        public d() {
            this.ab = 1;
            this.iD = new HashSet();
        }

        d(Set<Integer> set, int i, String str, String str2, String str3, String str4, String str5, String str6) {
            this.iD = set;
            this.ab = i;
            this.jc = str;
            this.kg = str2;
            this.jf = str3;
            this.kh = str4;
            this.ki = str5;
            this.kj = str6;
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
                    return this.jc;
                case 3:
                    return this.kg;
                case 4:
                    return this.jf;
                case 5:
                    return this.kh;
                case 6:
                    return this.ki;
                case 7:
                    return this.kj;
                default:
                    throw new IllegalStateException("Unknown safe parcelable id=" + aVar.aa());
            }
        }

        Set<Integer> bH() {
            return this.iD;
        }

        @Override // com.google.android.gms.common.data.Freezable
        /* renamed from: cr, reason: merged with bridge method [inline-methods] */
        public d freeze() {
            return this;
        }

        @Override // android.os.Parcelable
        public int describeContents() {
            cj cjVar = CREATOR;
            return 0;
        }

        public boolean equals(Object obj) {
            if (!(obj instanceof d)) {
                return false;
            }
            if (this == obj) {
                return true;
            }
            d dVar = (d) obj;
            for (ae.a<?, ?> aVar : iC.values()) {
                if (a(aVar)) {
                    if (dVar.a(aVar) && b(aVar).equals(dVar.b(aVar))) {
                    }
                    return false;
                }
                if (dVar.a(aVar)) {
                    return false;
                }
            }
            return true;
        }

        @Override // com.google.android.gms.plus.model.people.Person.Name
        public String getFamilyName() {
            return this.jc;
        }

        @Override // com.google.android.gms.plus.model.people.Person.Name
        public String getFormatted() {
            return this.kg;
        }

        @Override // com.google.android.gms.plus.model.people.Person.Name
        public String getGivenName() {
            return this.jf;
        }

        @Override // com.google.android.gms.plus.model.people.Person.Name
        public String getHonorificPrefix() {
            return this.kh;
        }

        @Override // com.google.android.gms.plus.model.people.Person.Name
        public String getHonorificSuffix() {
            return this.ki;
        }

        @Override // com.google.android.gms.plus.model.people.Person.Name
        public String getMiddleName() {
            return this.kj;
        }

        @Override // com.google.android.gms.plus.model.people.Person.Name
        public boolean hasFamilyName() {
            return this.iD.contains(2);
        }

        @Override // com.google.android.gms.plus.model.people.Person.Name
        public boolean hasFormatted() {
            return this.iD.contains(3);
        }

        @Override // com.google.android.gms.plus.model.people.Person.Name
        public boolean hasGivenName() {
            return this.iD.contains(4);
        }

        @Override // com.google.android.gms.plus.model.people.Person.Name
        public boolean hasHonorificPrefix() {
            return this.iD.contains(5);
        }

        @Override // com.google.android.gms.plus.model.people.Person.Name
        public boolean hasHonorificSuffix() {
            return this.iD.contains(6);
        }

        @Override // com.google.android.gms.plus.model.people.Person.Name
        public boolean hasMiddleName() {
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
            cj cjVar = CREATOR;
            cj.a(this, out, flags);
        }
    }

    public static class e {
        public static int G(String str) {
            if (str.equals("person")) {
                return 0;
            }
            if (str.equals("page")) {
                return 1;
            }
            throw new IllegalArgumentException("Unknown objectType string: " + str);
        }
    }

    public static final class f extends ae implements SafeParcelable, Person.Organizations {
        public static final ck CREATOR = new ck();
        private static final HashMap<String, ae.a<?, ?>> iC = new HashMap<>();
        private int aJ;
        private final int ab;
        private String di;
        private String hs;
        private final Set<Integer> iD;
        private String jb;
        private String js;
        private String kk;
        private String kl;
        private boolean km;
        private String mName;

        static {
            iC.put("department", ae.a.f("department", 2));
            iC.put(PlusShare.KEY_CONTENT_DEEP_LINK_METADATA_DESCRIPTION, ae.a.f(PlusShare.KEY_CONTENT_DEEP_LINK_METADATA_DESCRIPTION, 3));
            iC.put("endDate", ae.a.f("endDate", 4));
            iC.put("location", ae.a.f("location", 5));
            iC.put("name", ae.a.f("name", 6));
            iC.put("primary", ae.a.e("primary", 7));
            iC.put("startDate", ae.a.f("startDate", 8));
            iC.put(PlusShare.KEY_CONTENT_DEEP_LINK_METADATA_TITLE, ae.a.f(PlusShare.KEY_CONTENT_DEEP_LINK_METADATA_TITLE, 9));
            iC.put(ServerProtocol.DIALOG_PARAM_TYPE, ae.a.a(ServerProtocol.DIALOG_PARAM_TYPE, 10, new ab().b("work", 0).b("school", 1), false));
        }

        public f() {
            this.ab = 1;
            this.iD = new HashSet();
        }

        f(Set<Integer> set, int i, String str, String str2, String str3, String str4, String str5, boolean z, String str6, String str7, int i2) {
            this.iD = set;
            this.ab = i;
            this.kk = str;
            this.di = str2;
            this.jb = str3;
            this.kl = str4;
            this.mName = str5;
            this.km = z;
            this.js = str6;
            this.hs = str7;
            this.aJ = i2;
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
                    return this.kk;
                case 3:
                    return this.di;
                case 4:
                    return this.jb;
                case 5:
                    return this.kl;
                case 6:
                    return this.mName;
                case 7:
                    return Boolean.valueOf(this.km);
                case 8:
                    return this.js;
                case 9:
                    return this.hs;
                case 10:
                    return Integer.valueOf(this.aJ);
                default:
                    throw new IllegalStateException("Unknown safe parcelable id=" + aVar.aa());
            }
        }

        Set<Integer> bH() {
            return this.iD;
        }

        @Override // com.google.android.gms.common.data.Freezable
        /* renamed from: cs, reason: merged with bridge method [inline-methods] */
        public f freeze() {
            return this;
        }

        @Override // android.os.Parcelable
        public int describeContents() {
            ck ckVar = CREATOR;
            return 0;
        }

        public boolean equals(Object obj) {
            if (!(obj instanceof f)) {
                return false;
            }
            if (this == obj) {
                return true;
            }
            f fVar = (f) obj;
            for (ae.a<?, ?> aVar : iC.values()) {
                if (a(aVar)) {
                    if (fVar.a(aVar) && b(aVar).equals(fVar.b(aVar))) {
                    }
                    return false;
                }
                if (fVar.a(aVar)) {
                    return false;
                }
            }
            return true;
        }

        @Override // com.google.android.gms.plus.model.people.Person.Organizations
        public String getDepartment() {
            return this.kk;
        }

        @Override // com.google.android.gms.plus.model.people.Person.Organizations
        public String getDescription() {
            return this.di;
        }

        @Override // com.google.android.gms.plus.model.people.Person.Organizations
        public String getEndDate() {
            return this.jb;
        }

        @Override // com.google.android.gms.plus.model.people.Person.Organizations
        public String getLocation() {
            return this.kl;
        }

        @Override // com.google.android.gms.plus.model.people.Person.Organizations
        public String getName() {
            return this.mName;
        }

        @Override // com.google.android.gms.plus.model.people.Person.Organizations
        public String getStartDate() {
            return this.js;
        }

        @Override // com.google.android.gms.plus.model.people.Person.Organizations
        public String getTitle() {
            return this.hs;
        }

        @Override // com.google.android.gms.plus.model.people.Person.Organizations
        public int getType() {
            return this.aJ;
        }

        @Override // com.google.android.gms.plus.model.people.Person.Organizations
        public boolean hasDepartment() {
            return this.iD.contains(2);
        }

        @Override // com.google.android.gms.plus.model.people.Person.Organizations
        public boolean hasDescription() {
            return this.iD.contains(3);
        }

        @Override // com.google.android.gms.plus.model.people.Person.Organizations
        public boolean hasEndDate() {
            return this.iD.contains(4);
        }

        @Override // com.google.android.gms.plus.model.people.Person.Organizations
        public boolean hasLocation() {
            return this.iD.contains(5);
        }

        @Override // com.google.android.gms.plus.model.people.Person.Organizations
        public boolean hasName() {
            return this.iD.contains(6);
        }

        @Override // com.google.android.gms.plus.model.people.Person.Organizations
        public boolean hasPrimary() {
            return this.iD.contains(7);
        }

        @Override // com.google.android.gms.plus.model.people.Person.Organizations
        public boolean hasStartDate() {
            return this.iD.contains(8);
        }

        @Override // com.google.android.gms.plus.model.people.Person.Organizations
        public boolean hasTitle() {
            return this.iD.contains(9);
        }

        @Override // com.google.android.gms.plus.model.people.Person.Organizations
        public boolean hasType() {
            return this.iD.contains(10);
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

        @Override // com.google.android.gms.plus.model.people.Person.Organizations
        public boolean isPrimary() {
            return this.km;
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
            ck ckVar = CREATOR;
            ck.a(this, out, flags);
        }
    }

    public static final class g extends ae implements SafeParcelable, Person.PlacesLived {
        public static final cl CREATOR = new cl();
        private static final HashMap<String, ae.a<?, ?>> iC = new HashMap<>();
        private final int ab;
        private final Set<Integer> iD;
        private boolean km;
        private String mValue;

        static {
            iC.put("primary", ae.a.e("primary", 2));
            iC.put("value", ae.a.f("value", 3));
        }

        public g() {
            this.ab = 1;
            this.iD = new HashSet();
        }

        g(Set<Integer> set, int i, boolean z, String str) {
            this.iD = set;
            this.ab = i;
            this.km = z;
            this.mValue = str;
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
                    return Boolean.valueOf(this.km);
                case 3:
                    return this.mValue;
                default:
                    throw new IllegalStateException("Unknown safe parcelable id=" + aVar.aa());
            }
        }

        Set<Integer> bH() {
            return this.iD;
        }

        @Override // com.google.android.gms.common.data.Freezable
        /* renamed from: ct, reason: merged with bridge method [inline-methods] */
        public g freeze() {
            return this;
        }

        @Override // android.os.Parcelable
        public int describeContents() {
            cl clVar = CREATOR;
            return 0;
        }

        public boolean equals(Object obj) {
            if (!(obj instanceof g)) {
                return false;
            }
            if (this == obj) {
                return true;
            }
            g gVar = (g) obj;
            for (ae.a<?, ?> aVar : iC.values()) {
                if (a(aVar)) {
                    if (gVar.a(aVar) && b(aVar).equals(gVar.b(aVar))) {
                    }
                    return false;
                }
                if (gVar.a(aVar)) {
                    return false;
                }
            }
            return true;
        }

        @Override // com.google.android.gms.plus.model.people.Person.PlacesLived
        public String getValue() {
            return this.mValue;
        }

        @Override // com.google.android.gms.plus.model.people.Person.PlacesLived
        public boolean hasPrimary() {
            return this.iD.contains(2);
        }

        @Override // com.google.android.gms.plus.model.people.Person.PlacesLived
        public boolean hasValue() {
            return this.iD.contains(3);
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

        @Override // com.google.android.gms.plus.model.people.Person.PlacesLived
        public boolean isPrimary() {
            return this.km;
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
            cl clVar = CREATOR;
            cl.a(this, out, flags);
        }
    }

    public static final class h extends ae implements SafeParcelable, Person.Urls {
        public static final cm CREATOR = new cm();
        private static final HashMap<String, ae.a<?, ?>> iC = new HashMap<>();
        private int aJ;
        private final int ab;
        private final Set<Integer> iD;
        private String kn;
        private final int ko;
        private String mValue;

        static {
            iC.put(PlusShare.KEY_CALL_TO_ACTION_LABEL, ae.a.f(PlusShare.KEY_CALL_TO_ACTION_LABEL, 5));
            iC.put(ServerProtocol.DIALOG_PARAM_TYPE, ae.a.a(ServerProtocol.DIALOG_PARAM_TYPE, 6, new ab().b("home", 0).b("work", 1).b("blog", 2).b("profile", 3).b("other", 4).b("otherProfile", 5).b("contributor", 6).b("website", 7), false));
            iC.put("value", ae.a.f("value", 4));
        }

        public h() {
            this.ko = 4;
            this.ab = 2;
            this.iD = new HashSet();
        }

        h(Set<Integer> set, int i, String str, int i2, String str2, int i3) {
            this.ko = 4;
            this.iD = set;
            this.ab = i;
            this.kn = str;
            this.aJ = i2;
            this.mValue = str2;
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
                case 4:
                    return this.mValue;
                case 5:
                    return this.kn;
                case 6:
                    return Integer.valueOf(this.aJ);
                default:
                    throw new IllegalStateException("Unknown safe parcelable id=" + aVar.aa());
            }
        }

        Set<Integer> bH() {
            return this.iD;
        }

        @Deprecated
        public int cu() {
            return 4;
        }

        @Override // com.google.android.gms.common.data.Freezable
        /* renamed from: cv, reason: merged with bridge method [inline-methods] */
        public h freeze() {
            return this;
        }

        @Override // android.os.Parcelable
        public int describeContents() {
            cm cmVar = CREATOR;
            return 0;
        }

        public boolean equals(Object obj) {
            if (!(obj instanceof h)) {
                return false;
            }
            if (this == obj) {
                return true;
            }
            h hVar = (h) obj;
            for (ae.a<?, ?> aVar : iC.values()) {
                if (a(aVar)) {
                    if (hVar.a(aVar) && b(aVar).equals(hVar.b(aVar))) {
                    }
                    return false;
                }
                if (hVar.a(aVar)) {
                    return false;
                }
            }
            return true;
        }

        @Override // com.google.android.gms.plus.model.people.Person.Urls
        public String getLabel() {
            return this.kn;
        }

        @Override // com.google.android.gms.plus.model.people.Person.Urls
        public int getType() {
            return this.aJ;
        }

        @Override // com.google.android.gms.plus.model.people.Person.Urls
        public String getValue() {
            return this.mValue;
        }

        @Override // com.google.android.gms.plus.model.people.Person.Urls
        public boolean hasLabel() {
            return this.iD.contains(5);
        }

        @Override // com.google.android.gms.plus.model.people.Person.Urls
        public boolean hasType() {
            return this.iD.contains(6);
        }

        @Override // com.google.android.gms.plus.model.people.Person.Urls
        public boolean hasValue() {
            return this.iD.contains(4);
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
            cm cmVar = CREATOR;
            cm.a(this, out, flags);
        }
    }

    static {
        iC.put("aboutMe", ae.a.f("aboutMe", 2));
        iC.put("ageRange", ae.a.a("ageRange", 3, a.class));
        iC.put("birthday", ae.a.f("birthday", 4));
        iC.put("braggingRights", ae.a.f("braggingRights", 5));
        iC.put("circledByCount", ae.a.c("circledByCount", 6));
        iC.put("cover", ae.a.a("cover", 7, b.class));
        iC.put("currentLocation", ae.a.f("currentLocation", 8));
        iC.put("displayName", ae.a.f("displayName", 9));
        iC.put("gender", ae.a.a("gender", 12, new ab().b("male", 0).b("female", 1).b("other", 2), false));
        iC.put("id", ae.a.f("id", 14));
        iC.put("image", ae.a.a("image", 15, c.class));
        iC.put("isPlusUser", ae.a.e("isPlusUser", 16));
        iC.put("language", ae.a.f("language", 18));
        iC.put("name", ae.a.a("name", 19, d.class));
        iC.put("nickname", ae.a.f("nickname", 20));
        iC.put("objectType", ae.a.a("objectType", 21, new ab().b("person", 0).b("page", 1), false));
        iC.put("organizations", ae.a.b("organizations", 22, f.class));
        iC.put("placesLived", ae.a.b("placesLived", 23, g.class));
        iC.put("plusOneCount", ae.a.c("plusOneCount", 24));
        iC.put("relationshipStatus", ae.a.a("relationshipStatus", 25, new ab().b("single", 0).b("in_a_relationship", 1).b("engaged", 2).b("married", 3).b("its_complicated", 4).b("open_relationship", 5).b("widowed", 6).b("in_domestic_partnership", 7).b("in_civil_union", 8), false));
        iC.put("tagline", ae.a.f("tagline", 26));
        iC.put("url", ae.a.f("url", 27));
        iC.put("urls", ae.a.b("urls", 28, h.class));
        iC.put("verified", ae.a.e("verified", 29));
    }

    public cc() {
        this.ab = 2;
        this.iD = new HashSet();
    }

    public cc(String str, String str2, c cVar, int i, String str3) {
        this.ab = 2;
        this.iD = new HashSet();
        this.cl = str;
        this.iD.add(9);
        this.jh = str2;
        this.iD.add(14);
        this.jM = cVar;
        this.iD.add(15);
        this.jR = i;
        this.iD.add(21);
        this.ie = str3;
        this.iD.add(27);
    }

    cc(Set<Integer> set, int i, String str, a aVar, String str2, String str3, int i2, b bVar, String str4, String str5, int i3, String str6, c cVar, boolean z, String str7, d dVar, String str8, int i4, List<f> list, List<g> list2, int i5, int i6, String str9, String str10, List<h> list3, boolean z2) {
        this.iD = set;
        this.ab = i;
        this.jE = str;
        this.jF = aVar;
        this.jG = str2;
        this.jH = str3;
        this.jI = i2;
        this.jJ = bVar;
        this.jK = str4;
        this.cl = str5;
        this.jL = i3;
        this.jh = str6;
        this.jM = cVar;
        this.jN = z;
        this.jO = str7;
        this.jP = dVar;
        this.jQ = str8;
        this.jR = i4;
        this.jS = list;
        this.jT = list2;
        this.jU = i5;
        this.jV = i6;
        this.jW = str9;
        this.ie = str10;
        this.jX = list3;
        this.jY = z2;
    }

    public static cc d(byte[] bArr) {
        Parcel parcelObtain = Parcel.obtain();
        parcelObtain.unmarshall(bArr, 0, bArr.length);
        parcelObtain.setDataPosition(0);
        cc ccVarCreateFromParcel = CREATOR.createFromParcel(parcelObtain);
        parcelObtain.recycle();
        return ccVarCreateFromParcel;
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
                return this.jE;
            case 3:
                return this.jF;
            case 4:
                return this.jG;
            case 5:
                return this.jH;
            case 6:
                return Integer.valueOf(this.jI);
            case 7:
                return this.jJ;
            case 8:
                return this.jK;
            case 9:
                return this.cl;
            case 10:
            case 11:
            case 13:
            case R.styleable.ActionBar_progressBarPadding /* 17 */:
            default:
                throw new IllegalStateException("Unknown safe parcelable id=" + aVar.aa());
            case 12:
                return Integer.valueOf(this.jL);
            case 14:
                return this.jh;
            case 15:
                return this.jM;
            case 16:
                return Boolean.valueOf(this.jN);
            case R.styleable.ActionBar_itemPadding /* 18 */:
                return this.jO;
            case TimeUtils.HUNDRED_DAY_FIELD_LEN /* 19 */:
                return this.jP;
            case 20:
                return this.jQ;
            case 21:
                return Integer.valueOf(this.jR);
            case 22:
                return this.jS;
            case 23:
                return this.jT;
            case 24:
                return Integer.valueOf(this.jU);
            case 25:
                return Integer.valueOf(this.jV);
            case 26:
                return this.jW;
            case 27:
                return this.ie;
            case 28:
                return this.jX;
            case 29:
                return Boolean.valueOf(this.jY);
        }
    }

    Set<Integer> bH() {
        return this.iD;
    }

    a cc() {
        return this.jF;
    }

    b cd() {
        return this.jJ;
    }

    c ce() {
        return this.jM;
    }

    d cf() {
        return this.jP;
    }

    List<f> cg() {
        return this.jS;
    }

    List<g> ch() {
        return this.jT;
    }

    List<h> ci() {
        return this.jX;
    }

    @Override // com.google.android.gms.common.data.Freezable
    /* renamed from: cj, reason: merged with bridge method [inline-methods] */
    public cc freeze() {
        return this;
    }

    @Override // android.os.Parcelable
    public int describeContents() {
        cd cdVar = CREATOR;
        return 0;
    }

    public boolean equals(Object obj) {
        if (!(obj instanceof cc)) {
            return false;
        }
        if (this == obj) {
            return true;
        }
        cc ccVar = (cc) obj;
        for (ae.a<?, ?> aVar : iC.values()) {
            if (a(aVar)) {
                if (ccVar.a(aVar) && b(aVar).equals(ccVar.b(aVar))) {
                }
                return false;
            }
            if (ccVar.a(aVar)) {
                return false;
            }
        }
        return true;
    }

    @Override // com.google.android.gms.plus.model.people.Person
    public String getAboutMe() {
        return this.jE;
    }

    @Override // com.google.android.gms.plus.model.people.Person
    public Person.AgeRange getAgeRange() {
        return this.jF;
    }

    @Override // com.google.android.gms.plus.model.people.Person
    public String getBirthday() {
        return this.jG;
    }

    @Override // com.google.android.gms.plus.model.people.Person
    public String getBraggingRights() {
        return this.jH;
    }

    @Override // com.google.android.gms.plus.model.people.Person
    public int getCircledByCount() {
        return this.jI;
    }

    @Override // com.google.android.gms.plus.model.people.Person
    public Person.Cover getCover() {
        return this.jJ;
    }

    @Override // com.google.android.gms.plus.model.people.Person
    public String getCurrentLocation() {
        return this.jK;
    }

    @Override // com.google.android.gms.plus.model.people.Person
    public String getDisplayName() {
        return this.cl;
    }

    @Override // com.google.android.gms.plus.model.people.Person
    @Deprecated
    public List<Person.Emails> getEmails() {
        return null;
    }

    @Override // com.google.android.gms.plus.model.people.Person
    public int getGender() {
        return this.jL;
    }

    @Override // com.google.android.gms.plus.model.people.Person
    public String getId() {
        return this.jh;
    }

    @Override // com.google.android.gms.plus.model.people.Person
    public Person.Image getImage() {
        return this.jM;
    }

    @Override // com.google.android.gms.plus.model.people.Person
    public String getLanguage() {
        return this.jO;
    }

    @Override // com.google.android.gms.plus.model.people.Person
    public Person.Name getName() {
        return this.jP;
    }

    @Override // com.google.android.gms.plus.model.people.Person
    public String getNickname() {
        return this.jQ;
    }

    @Override // com.google.android.gms.plus.model.people.Person
    public int getObjectType() {
        return this.jR;
    }

    @Override // com.google.android.gms.plus.model.people.Person
    public List<Person.Organizations> getOrganizations() {
        return (ArrayList) this.jS;
    }

    @Override // com.google.android.gms.plus.model.people.Person
    public List<Person.PlacesLived> getPlacesLived() {
        return (ArrayList) this.jT;
    }

    @Override // com.google.android.gms.plus.model.people.Person
    public int getPlusOneCount() {
        return this.jU;
    }

    @Override // com.google.android.gms.plus.model.people.Person
    public int getRelationshipStatus() {
        return this.jV;
    }

    @Override // com.google.android.gms.plus.model.people.Person
    public String getTagline() {
        return this.jW;
    }

    @Override // com.google.android.gms.plus.model.people.Person
    public String getUrl() {
        return this.ie;
    }

    @Override // com.google.android.gms.plus.model.people.Person
    public List<Person.Urls> getUrls() {
        return (ArrayList) this.jX;
    }

    @Override // com.google.android.gms.plus.model.people.Person
    public boolean hasAboutMe() {
        return this.iD.contains(2);
    }

    @Override // com.google.android.gms.plus.model.people.Person
    public boolean hasAgeRange() {
        return this.iD.contains(3);
    }

    @Override // com.google.android.gms.plus.model.people.Person
    public boolean hasBirthday() {
        return this.iD.contains(4);
    }

    @Override // com.google.android.gms.plus.model.people.Person
    public boolean hasBraggingRights() {
        return this.iD.contains(5);
    }

    @Override // com.google.android.gms.plus.model.people.Person
    public boolean hasCircledByCount() {
        return this.iD.contains(6);
    }

    @Override // com.google.android.gms.plus.model.people.Person
    public boolean hasCover() {
        return this.iD.contains(7);
    }

    @Override // com.google.android.gms.plus.model.people.Person
    public boolean hasCurrentLocation() {
        return this.iD.contains(8);
    }

    @Override // com.google.android.gms.plus.model.people.Person
    public boolean hasDisplayName() {
        return this.iD.contains(9);
    }

    @Override // com.google.android.gms.plus.model.people.Person
    @Deprecated
    public boolean hasEmails() {
        return false;
    }

    @Override // com.google.android.gms.plus.model.people.Person
    public boolean hasGender() {
        return this.iD.contains(12);
    }

    @Override // com.google.android.gms.plus.model.people.Person
    public boolean hasId() {
        return this.iD.contains(14);
    }

    @Override // com.google.android.gms.plus.model.people.Person
    public boolean hasImage() {
        return this.iD.contains(15);
    }

    @Override // com.google.android.gms.plus.model.people.Person
    public boolean hasIsPlusUser() {
        return this.iD.contains(16);
    }

    @Override // com.google.android.gms.plus.model.people.Person
    public boolean hasLanguage() {
        return this.iD.contains(18);
    }

    @Override // com.google.android.gms.plus.model.people.Person
    public boolean hasName() {
        return this.iD.contains(19);
    }

    @Override // com.google.android.gms.plus.model.people.Person
    public boolean hasNickname() {
        return this.iD.contains(20);
    }

    @Override // com.google.android.gms.plus.model.people.Person
    public boolean hasObjectType() {
        return this.iD.contains(21);
    }

    @Override // com.google.android.gms.plus.model.people.Person
    public boolean hasOrganizations() {
        return this.iD.contains(22);
    }

    @Override // com.google.android.gms.plus.model.people.Person
    public boolean hasPlacesLived() {
        return this.iD.contains(23);
    }

    @Override // com.google.android.gms.plus.model.people.Person
    public boolean hasPlusOneCount() {
        return this.iD.contains(24);
    }

    @Override // com.google.android.gms.plus.model.people.Person
    public boolean hasRelationshipStatus() {
        return this.iD.contains(25);
    }

    @Override // com.google.android.gms.plus.model.people.Person
    public boolean hasTagline() {
        return this.iD.contains(26);
    }

    @Override // com.google.android.gms.plus.model.people.Person
    public boolean hasUrl() {
        return this.iD.contains(27);
    }

    @Override // com.google.android.gms.plus.model.people.Person
    public boolean hasUrls() {
        return this.iD.contains(28);
    }

    @Override // com.google.android.gms.plus.model.people.Person
    public boolean hasVerified() {
        return this.iD.contains(29);
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

    @Override // com.google.android.gms.plus.model.people.Person
    public boolean isPlusUser() {
        return this.jN;
    }

    @Override // com.google.android.gms.plus.model.people.Person
    public boolean isVerified() {
        return this.jY;
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
        cd cdVar = CREATOR;
        cd.a(this, out, flags);
    }
}
