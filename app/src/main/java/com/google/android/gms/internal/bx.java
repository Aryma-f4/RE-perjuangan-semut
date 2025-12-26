package com.google.android.gms.internal;

import android.os.Parcel;
import android.support.v4.util.TimeUtils;
import android.support.v7.appcompat.R;
import com.facebook.Request;
import com.facebook.internal.ServerProtocol;
import com.google.android.gms.common.internal.safeparcel.SafeParcelable;
import com.google.android.gms.internal.ae;
import com.google.android.gms.plus.PlusShare;
import com.google.android.gms.plus.model.moments.ItemScope;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

/* loaded from: classes.dex */
public final class bx extends ae implements SafeParcelable, ItemScope {
    public static final by CREATOR = new by();
    private static final HashMap<String, ae.a<?, ?>> iC = new HashMap<>();
    private final int ab;
    private String di;
    private double fy;
    private double fz;
    private final Set<Integer> iD;
    private bx iE;
    private List<String> iF;
    private bx iG;
    private String iH;
    private String iI;
    private String iJ;
    private List<bx> iK;
    private int iL;
    private List<bx> iM;
    private bx iN;
    private List<bx> iO;
    private String iP;
    private String iQ;
    private bx iR;
    private String iS;
    private String iT;
    private String iU;
    private List<bx> iV;
    private String iW;
    private String iX;
    private String iY;
    private String iZ;
    private String ie;
    private String jA;
    private String ja;
    private String jb;
    private String jc;
    private String jd;
    private bx je;
    private String jf;
    private String jg;
    private String jh;
    private String ji;
    private bx jj;
    private bx jk;
    private bx jl;
    private List<bx> jm;
    private String jn;
    private String jo;
    private String jp;
    private String jq;
    private bx jr;
    private String js;
    private String jt;
    private String ju;
    private bx jv;
    private String jw;
    private String jx;
    private String jy;
    private String jz;
    private String mName;

    static {
        iC.put("about", ae.a.a("about", 2, bx.class));
        iC.put("additionalName", ae.a.g("additionalName", 3));
        iC.put("address", ae.a.a("address", 4, bx.class));
        iC.put("addressCountry", ae.a.f("addressCountry", 5));
        iC.put("addressLocality", ae.a.f("addressLocality", 6));
        iC.put("addressRegion", ae.a.f("addressRegion", 7));
        iC.put("associated_media", ae.a.b("associated_media", 8, bx.class));
        iC.put("attendeeCount", ae.a.c("attendeeCount", 9));
        iC.put("attendees", ae.a.b("attendees", 10, bx.class));
        iC.put("audio", ae.a.a("audio", 11, bx.class));
        iC.put("author", ae.a.b("author", 12, bx.class));
        iC.put("bestRating", ae.a.f("bestRating", 13));
        iC.put("birthDate", ae.a.f("birthDate", 14));
        iC.put("byArtist", ae.a.a("byArtist", 15, bx.class));
        iC.put("caption", ae.a.f("caption", 16));
        iC.put("contentSize", ae.a.f("contentSize", 17));
        iC.put("contentUrl", ae.a.f("contentUrl", 18));
        iC.put("contributor", ae.a.b("contributor", 19, bx.class));
        iC.put("dateCreated", ae.a.f("dateCreated", 20));
        iC.put("dateModified", ae.a.f("dateModified", 21));
        iC.put("datePublished", ae.a.f("datePublished", 22));
        iC.put(PlusShare.KEY_CONTENT_DEEP_LINK_METADATA_DESCRIPTION, ae.a.f(PlusShare.KEY_CONTENT_DEEP_LINK_METADATA_DESCRIPTION, 23));
        iC.put("duration", ae.a.f("duration", 24));
        iC.put("embedUrl", ae.a.f("embedUrl", 25));
        iC.put("endDate", ae.a.f("endDate", 26));
        iC.put("familyName", ae.a.f("familyName", 27));
        iC.put("gender", ae.a.f("gender", 28));
        iC.put("geo", ae.a.a("geo", 29, bx.class));
        iC.put("givenName", ae.a.f("givenName", 30));
        iC.put("height", ae.a.f("height", 31));
        iC.put("id", ae.a.f("id", 32));
        iC.put("image", ae.a.f("image", 33));
        iC.put("inAlbum", ae.a.a("inAlbum", 34, bx.class));
        iC.put("latitude", ae.a.d("latitude", 36));
        iC.put("location", ae.a.a("location", 37, bx.class));
        iC.put("longitude", ae.a.d("longitude", 38));
        iC.put("name", ae.a.f("name", 39));
        iC.put("partOfTVSeries", ae.a.a("partOfTVSeries", 40, bx.class));
        iC.put("performers", ae.a.b("performers", 41, bx.class));
        iC.put("playerType", ae.a.f("playerType", 42));
        iC.put("postOfficeBoxNumber", ae.a.f("postOfficeBoxNumber", 43));
        iC.put("postalCode", ae.a.f("postalCode", 44));
        iC.put("ratingValue", ae.a.f("ratingValue", 45));
        iC.put("reviewRating", ae.a.a("reviewRating", 46, bx.class));
        iC.put("startDate", ae.a.f("startDate", 47));
        iC.put("streetAddress", ae.a.f("streetAddress", 48));
        iC.put("text", ae.a.f("text", 49));
        iC.put("thumbnail", ae.a.a("thumbnail", 50, bx.class));
        iC.put(PlusShare.KEY_CONTENT_DEEP_LINK_METADATA_THUMBNAIL_URL, ae.a.f(PlusShare.KEY_CONTENT_DEEP_LINK_METADATA_THUMBNAIL_URL, 51));
        iC.put("tickerSymbol", ae.a.f("tickerSymbol", 52));
        iC.put(ServerProtocol.DIALOG_PARAM_TYPE, ae.a.f(ServerProtocol.DIALOG_PARAM_TYPE, 53));
        iC.put("url", ae.a.f("url", 54));
        iC.put("width", ae.a.f("width", 55));
        iC.put("worstRating", ae.a.f("worstRating", 56));
    }

    public bx() {
        this.ab = 1;
        this.iD = new HashSet();
    }

    bx(Set<Integer> set, int i, bx bxVar, List<String> list, bx bxVar2, String str, String str2, String str3, List<bx> list2, int i2, List<bx> list3, bx bxVar3, List<bx> list4, String str4, String str5, bx bxVar4, String str6, String str7, String str8, List<bx> list5, String str9, String str10, String str11, String str12, String str13, String str14, String str15, String str16, String str17, bx bxVar5, String str18, String str19, String str20, String str21, bx bxVar6, double d, bx bxVar7, double d2, String str22, bx bxVar8, List<bx> list6, String str23, String str24, String str25, String str26, bx bxVar9, String str27, String str28, String str29, bx bxVar10, String str30, String str31, String str32, String str33, String str34, String str35) {
        this.iD = set;
        this.ab = i;
        this.iE = bxVar;
        this.iF = list;
        this.iG = bxVar2;
        this.iH = str;
        this.iI = str2;
        this.iJ = str3;
        this.iK = list2;
        this.iL = i2;
        this.iM = list3;
        this.iN = bxVar3;
        this.iO = list4;
        this.iP = str4;
        this.iQ = str5;
        this.iR = bxVar4;
        this.iS = str6;
        this.iT = str7;
        this.iU = str8;
        this.iV = list5;
        this.iW = str9;
        this.iX = str10;
        this.iY = str11;
        this.di = str12;
        this.iZ = str13;
        this.ja = str14;
        this.jb = str15;
        this.jc = str16;
        this.jd = str17;
        this.je = bxVar5;
        this.jf = str18;
        this.jg = str19;
        this.jh = str20;
        this.ji = str21;
        this.jj = bxVar6;
        this.fy = d;
        this.jk = bxVar7;
        this.fz = d2;
        this.mName = str22;
        this.jl = bxVar8;
        this.jm = list6;
        this.jn = str23;
        this.jo = str24;
        this.jp = str25;
        this.jq = str26;
        this.jr = bxVar9;
        this.js = str27;
        this.jt = str28;
        this.ju = str29;
        this.jv = bxVar10;
        this.jw = str30;
        this.jx = str31;
        this.jy = str32;
        this.ie = str33;
        this.jz = str34;
        this.jA = str35;
    }

    public bx(Set<Integer> set, bx bxVar, List<String> list, bx bxVar2, String str, String str2, String str3, List<bx> list2, int i, List<bx> list3, bx bxVar3, List<bx> list4, String str4, String str5, bx bxVar4, String str6, String str7, String str8, List<bx> list5, String str9, String str10, String str11, String str12, String str13, String str14, String str15, String str16, String str17, bx bxVar5, String str18, String str19, String str20, String str21, bx bxVar6, double d, bx bxVar7, double d2, String str22, bx bxVar8, List<bx> list6, String str23, String str24, String str25, String str26, bx bxVar9, String str27, String str28, String str29, bx bxVar10, String str30, String str31, String str32, String str33, String str34, String str35) {
        this.iD = set;
        this.ab = 1;
        this.iE = bxVar;
        this.iF = list;
        this.iG = bxVar2;
        this.iH = str;
        this.iI = str2;
        this.iJ = str3;
        this.iK = list2;
        this.iL = i;
        this.iM = list3;
        this.iN = bxVar3;
        this.iO = list4;
        this.iP = str4;
        this.iQ = str5;
        this.iR = bxVar4;
        this.iS = str6;
        this.iT = str7;
        this.iU = str8;
        this.iV = list5;
        this.iW = str9;
        this.iX = str10;
        this.iY = str11;
        this.di = str12;
        this.iZ = str13;
        this.ja = str14;
        this.jb = str15;
        this.jc = str16;
        this.jd = str17;
        this.je = bxVar5;
        this.jf = str18;
        this.jg = str19;
        this.jh = str20;
        this.ji = str21;
        this.jj = bxVar6;
        this.fy = d;
        this.jk = bxVar7;
        this.fz = d2;
        this.mName = str22;
        this.jl = bxVar8;
        this.jm = list6;
        this.jn = str23;
        this.jo = str24;
        this.jp = str25;
        this.jq = str26;
        this.jr = bxVar9;
        this.js = str27;
        this.jt = str28;
        this.ju = str29;
        this.jv = bxVar10;
        this.jw = str30;
        this.jx = str31;
        this.jy = str32;
        this.ie = str33;
        this.jz = str34;
        this.jA = str35;
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
                return this.iE;
            case 3:
                return this.iF;
            case 4:
                return this.iG;
            case 5:
                return this.iH;
            case 6:
                return this.iI;
            case 7:
                return this.iJ;
            case 8:
                return this.iK;
            case 9:
                return Integer.valueOf(this.iL);
            case 10:
                return this.iM;
            case 11:
                return this.iN;
            case 12:
                return this.iO;
            case 13:
                return this.iP;
            case 14:
                return this.iQ;
            case 15:
                return this.iR;
            case 16:
                return this.iS;
            case R.styleable.ActionBar_progressBarPadding /* 17 */:
                return this.iT;
            case R.styleable.ActionBar_itemPadding /* 18 */:
                return this.iU;
            case TimeUtils.HUNDRED_DAY_FIELD_LEN /* 19 */:
                return this.iV;
            case 20:
                return this.iW;
            case 21:
                return this.iX;
            case 22:
                return this.iY;
            case 23:
                return this.di;
            case 24:
                return this.iZ;
            case 25:
                return this.ja;
            case 26:
                return this.jb;
            case 27:
                return this.jc;
            case 28:
                return this.jd;
            case 29:
                return this.je;
            case 30:
                return this.jf;
            case 31:
                return this.jg;
            case 32:
                return this.jh;
            case 33:
                return this.ji;
            case 34:
                return this.jj;
            case 35:
            default:
                throw new IllegalStateException("Unknown safe parcelable id=" + aVar.aa());
            case 36:
                return Double.valueOf(this.fy);
            case 37:
                return this.jk;
            case 38:
                return Double.valueOf(this.fz);
            case 39:
                return this.mName;
            case 40:
                return this.jl;
            case 41:
                return this.jm;
            case 42:
                return this.jn;
            case 43:
                return this.jo;
            case 44:
                return this.jp;
            case 45:
                return this.jq;
            case 46:
                return this.jr;
            case 47:
                return this.js;
            case 48:
                return this.jt;
            case 49:
                return this.ju;
            case Request.MAXIMUM_BATCH_SIZE /* 50 */:
                return this.jv;
            case 51:
                return this.jw;
            case 52:
                return this.jx;
            case 53:
                return this.jy;
            case 54:
                return this.ie;
            case 55:
                return this.jz;
            case 56:
                return this.jA;
        }
    }

    Set<Integer> bH() {
        return this.iD;
    }

    bx bI() {
        return this.iE;
    }

    bx bJ() {
        return this.iG;
    }

    List<bx> bK() {
        return this.iK;
    }

    List<bx> bL() {
        return this.iM;
    }

    bx bM() {
        return this.iN;
    }

    List<bx> bN() {
        return this.iO;
    }

    bx bO() {
        return this.iR;
    }

    List<bx> bP() {
        return this.iV;
    }

    bx bQ() {
        return this.je;
    }

    bx bR() {
        return this.jj;
    }

    bx bS() {
        return this.jk;
    }

    bx bT() {
        return this.jl;
    }

    List<bx> bU() {
        return this.jm;
    }

    bx bV() {
        return this.jr;
    }

    bx bW() {
        return this.jv;
    }

    @Override // com.google.android.gms.common.data.Freezable
    /* renamed from: bX, reason: merged with bridge method [inline-methods] */
    public bx freeze() {
        return this;
    }

    @Override // android.os.Parcelable
    public int describeContents() {
        by byVar = CREATOR;
        return 0;
    }

    public boolean equals(Object obj) {
        if (!(obj instanceof bx)) {
            return false;
        }
        if (this == obj) {
            return true;
        }
        bx bxVar = (bx) obj;
        for (ae.a<?, ?> aVar : iC.values()) {
            if (a(aVar)) {
                if (bxVar.a(aVar) && b(aVar).equals(bxVar.b(aVar))) {
                }
                return false;
            }
            if (bxVar.a(aVar)) {
                return false;
            }
        }
        return true;
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public ItemScope getAbout() {
        return this.iE;
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public List<String> getAdditionalName() {
        return this.iF;
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public ItemScope getAddress() {
        return this.iG;
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public String getAddressCountry() {
        return this.iH;
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public String getAddressLocality() {
        return this.iI;
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public String getAddressRegion() {
        return this.iJ;
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public List<ItemScope> getAssociated_media() {
        return (ArrayList) this.iK;
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public int getAttendeeCount() {
        return this.iL;
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public List<ItemScope> getAttendees() {
        return (ArrayList) this.iM;
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public ItemScope getAudio() {
        return this.iN;
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public List<ItemScope> getAuthor() {
        return (ArrayList) this.iO;
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public String getBestRating() {
        return this.iP;
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public String getBirthDate() {
        return this.iQ;
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public ItemScope getByArtist() {
        return this.iR;
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public String getCaption() {
        return this.iS;
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public String getContentSize() {
        return this.iT;
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public String getContentUrl() {
        return this.iU;
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public List<ItemScope> getContributor() {
        return (ArrayList) this.iV;
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public String getDateCreated() {
        return this.iW;
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public String getDateModified() {
        return this.iX;
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public String getDatePublished() {
        return this.iY;
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public String getDescription() {
        return this.di;
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public String getDuration() {
        return this.iZ;
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public String getEmbedUrl() {
        return this.ja;
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public String getEndDate() {
        return this.jb;
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public String getFamilyName() {
        return this.jc;
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public String getGender() {
        return this.jd;
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public ItemScope getGeo() {
        return this.je;
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public String getGivenName() {
        return this.jf;
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public String getHeight() {
        return this.jg;
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public String getId() {
        return this.jh;
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public String getImage() {
        return this.ji;
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public ItemScope getInAlbum() {
        return this.jj;
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public double getLatitude() {
        return this.fy;
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public ItemScope getLocation() {
        return this.jk;
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public double getLongitude() {
        return this.fz;
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public String getName() {
        return this.mName;
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public ItemScope getPartOfTVSeries() {
        return this.jl;
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public List<ItemScope> getPerformers() {
        return (ArrayList) this.jm;
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public String getPlayerType() {
        return this.jn;
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public String getPostOfficeBoxNumber() {
        return this.jo;
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public String getPostalCode() {
        return this.jp;
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public String getRatingValue() {
        return this.jq;
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public ItemScope getReviewRating() {
        return this.jr;
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public String getStartDate() {
        return this.js;
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public String getStreetAddress() {
        return this.jt;
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public String getText() {
        return this.ju;
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public ItemScope getThumbnail() {
        return this.jv;
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public String getThumbnailUrl() {
        return this.jw;
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public String getTickerSymbol() {
        return this.jx;
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public String getType() {
        return this.jy;
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public String getUrl() {
        return this.ie;
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public String getWidth() {
        return this.jz;
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public String getWorstRating() {
        return this.jA;
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public boolean hasAbout() {
        return this.iD.contains(2);
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public boolean hasAdditionalName() {
        return this.iD.contains(3);
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public boolean hasAddress() {
        return this.iD.contains(4);
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public boolean hasAddressCountry() {
        return this.iD.contains(5);
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public boolean hasAddressLocality() {
        return this.iD.contains(6);
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public boolean hasAddressRegion() {
        return this.iD.contains(7);
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public boolean hasAssociated_media() {
        return this.iD.contains(8);
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public boolean hasAttendeeCount() {
        return this.iD.contains(9);
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public boolean hasAttendees() {
        return this.iD.contains(10);
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public boolean hasAudio() {
        return this.iD.contains(11);
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public boolean hasAuthor() {
        return this.iD.contains(12);
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public boolean hasBestRating() {
        return this.iD.contains(13);
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public boolean hasBirthDate() {
        return this.iD.contains(14);
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public boolean hasByArtist() {
        return this.iD.contains(15);
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public boolean hasCaption() {
        return this.iD.contains(16);
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public boolean hasContentSize() {
        return this.iD.contains(17);
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public boolean hasContentUrl() {
        return this.iD.contains(18);
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public boolean hasContributor() {
        return this.iD.contains(19);
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public boolean hasDateCreated() {
        return this.iD.contains(20);
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public boolean hasDateModified() {
        return this.iD.contains(21);
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public boolean hasDatePublished() {
        return this.iD.contains(22);
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public boolean hasDescription() {
        return this.iD.contains(23);
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public boolean hasDuration() {
        return this.iD.contains(24);
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public boolean hasEmbedUrl() {
        return this.iD.contains(25);
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public boolean hasEndDate() {
        return this.iD.contains(26);
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public boolean hasFamilyName() {
        return this.iD.contains(27);
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public boolean hasGender() {
        return this.iD.contains(28);
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public boolean hasGeo() {
        return this.iD.contains(29);
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public boolean hasGivenName() {
        return this.iD.contains(30);
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public boolean hasHeight() {
        return this.iD.contains(31);
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public boolean hasId() {
        return this.iD.contains(32);
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public boolean hasImage() {
        return this.iD.contains(33);
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public boolean hasInAlbum() {
        return this.iD.contains(34);
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public boolean hasLatitude() {
        return this.iD.contains(36);
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public boolean hasLocation() {
        return this.iD.contains(37);
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public boolean hasLongitude() {
        return this.iD.contains(38);
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public boolean hasName() {
        return this.iD.contains(39);
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public boolean hasPartOfTVSeries() {
        return this.iD.contains(40);
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public boolean hasPerformers() {
        return this.iD.contains(41);
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public boolean hasPlayerType() {
        return this.iD.contains(42);
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public boolean hasPostOfficeBoxNumber() {
        return this.iD.contains(43);
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public boolean hasPostalCode() {
        return this.iD.contains(44);
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public boolean hasRatingValue() {
        return this.iD.contains(45);
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public boolean hasReviewRating() {
        return this.iD.contains(46);
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public boolean hasStartDate() {
        return this.iD.contains(47);
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public boolean hasStreetAddress() {
        return this.iD.contains(48);
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public boolean hasText() {
        return this.iD.contains(49);
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public boolean hasThumbnail() {
        return this.iD.contains(50);
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public boolean hasThumbnailUrl() {
        return this.iD.contains(51);
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public boolean hasTickerSymbol() {
        return this.iD.contains(52);
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public boolean hasType() {
        return this.iD.contains(53);
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public boolean hasUrl() {
        return this.iD.contains(54);
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public boolean hasWidth() {
        return this.iD.contains(55);
    }

    @Override // com.google.android.gms.plus.model.moments.ItemScope
    public boolean hasWorstRating() {
        return this.iD.contains(56);
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
        by byVar = CREATOR;
        by.a(this, out, flags);
    }
}
