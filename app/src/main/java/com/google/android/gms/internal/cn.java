package com.google.android.gms.internal;

import com.google.android.gms.internal.cc;
import com.google.android.gms.plus.model.people.Person;
import java.util.ArrayList;

/* loaded from: classes.dex */
public final class cn extends com.google.android.gms.common.data.b implements Person {
    public cn(com.google.android.gms.common.data.d dVar, int i) {
        super(dVar, i);
    }

    @Override // com.google.android.gms.common.data.Freezable
    /* renamed from: cA, reason: merged with bridge method [inline-methods] */
    public Person freeze() {
        return new cc(getDisplayName(), getId(), (cc.c) getImage(), getObjectType(), getUrl());
    }

    @Override // com.google.android.gms.plus.model.people.Person
    /* renamed from: cw, reason: merged with bridge method [inline-methods] */
    public ArrayList<Person.Emails> getEmails() {
        return null;
    }

    @Override // com.google.android.gms.plus.model.people.Person
    /* renamed from: cx, reason: merged with bridge method [inline-methods] */
    public ArrayList<Person.Organizations> getOrganizations() {
        return null;
    }

    @Override // com.google.android.gms.plus.model.people.Person
    /* renamed from: cy, reason: merged with bridge method [inline-methods] */
    public ArrayList<Person.PlacesLived> getPlacesLived() {
        return null;
    }

    @Override // com.google.android.gms.plus.model.people.Person
    /* renamed from: cz, reason: merged with bridge method [inline-methods] */
    public ArrayList<Person.Urls> getUrls() {
        return null;
    }

    @Override // com.google.android.gms.plus.model.people.Person
    public String getAboutMe() {
        return null;
    }

    @Override // com.google.android.gms.plus.model.people.Person
    public Person.AgeRange getAgeRange() {
        return null;
    }

    @Override // com.google.android.gms.plus.model.people.Person
    public String getBirthday() {
        return null;
    }

    @Override // com.google.android.gms.plus.model.people.Person
    public String getBraggingRights() {
        return null;
    }

    @Override // com.google.android.gms.plus.model.people.Person
    public int getCircledByCount() {
        return 0;
    }

    @Override // com.google.android.gms.plus.model.people.Person
    public Person.Cover getCover() {
        return null;
    }

    @Override // com.google.android.gms.plus.model.people.Person
    public String getCurrentLocation() {
        return null;
    }

    @Override // com.google.android.gms.plus.model.people.Person
    public String getDisplayName() {
        return getString("displayName");
    }

    @Override // com.google.android.gms.plus.model.people.Person
    public int getGender() {
        return 0;
    }

    @Override // com.google.android.gms.plus.model.people.Person
    public String getId() {
        return getString("personId");
    }

    @Override // com.google.android.gms.plus.model.people.Person
    public Person.Image getImage() {
        return new cc.c(getString("image"));
    }

    @Override // com.google.android.gms.plus.model.people.Person
    public String getLanguage() {
        return null;
    }

    @Override // com.google.android.gms.plus.model.people.Person
    public Person.Name getName() {
        return null;
    }

    @Override // com.google.android.gms.plus.model.people.Person
    public String getNickname() {
        return null;
    }

    @Override // com.google.android.gms.plus.model.people.Person
    public int getObjectType() {
        return cc.e.G(getString("objectType"));
    }

    @Override // com.google.android.gms.plus.model.people.Person
    public int getPlusOneCount() {
        return 0;
    }

    @Override // com.google.android.gms.plus.model.people.Person
    public int getRelationshipStatus() {
        return 0;
    }

    @Override // com.google.android.gms.plus.model.people.Person
    public String getTagline() {
        return null;
    }

    @Override // com.google.android.gms.plus.model.people.Person
    public String getUrl() {
        return getString("url");
    }

    @Override // com.google.android.gms.plus.model.people.Person
    public boolean hasAboutMe() {
        return false;
    }

    @Override // com.google.android.gms.plus.model.people.Person
    public boolean hasAgeRange() {
        return false;
    }

    @Override // com.google.android.gms.plus.model.people.Person
    public boolean hasBirthday() {
        return false;
    }

    @Override // com.google.android.gms.plus.model.people.Person
    public boolean hasBraggingRights() {
        return false;
    }

    @Override // com.google.android.gms.plus.model.people.Person
    public boolean hasCircledByCount() {
        return false;
    }

    @Override // com.google.android.gms.plus.model.people.Person
    public boolean hasCover() {
        return false;
    }

    @Override // com.google.android.gms.plus.model.people.Person
    public boolean hasCurrentLocation() {
        return false;
    }

    @Override // com.google.android.gms.plus.model.people.Person
    public boolean hasDisplayName() {
        return true;
    }

    @Override // com.google.android.gms.plus.model.people.Person
    public boolean hasEmails() {
        return false;
    }

    @Override // com.google.android.gms.plus.model.people.Person
    public boolean hasGender() {
        return false;
    }

    @Override // com.google.android.gms.plus.model.people.Person
    public boolean hasId() {
        return true;
    }

    @Override // com.google.android.gms.plus.model.people.Person
    public boolean hasImage() {
        return true;
    }

    @Override // com.google.android.gms.plus.model.people.Person
    public boolean hasIsPlusUser() {
        return false;
    }

    @Override // com.google.android.gms.plus.model.people.Person
    public boolean hasLanguage() {
        return false;
    }

    @Override // com.google.android.gms.plus.model.people.Person
    public boolean hasName() {
        return false;
    }

    @Override // com.google.android.gms.plus.model.people.Person
    public boolean hasNickname() {
        return false;
    }

    @Override // com.google.android.gms.plus.model.people.Person
    public boolean hasObjectType() {
        return true;
    }

    @Override // com.google.android.gms.plus.model.people.Person
    public boolean hasOrganizations() {
        return false;
    }

    @Override // com.google.android.gms.plus.model.people.Person
    public boolean hasPlacesLived() {
        return false;
    }

    @Override // com.google.android.gms.plus.model.people.Person
    public boolean hasPlusOneCount() {
        return false;
    }

    @Override // com.google.android.gms.plus.model.people.Person
    public boolean hasRelationshipStatus() {
        return false;
    }

    @Override // com.google.android.gms.plus.model.people.Person
    public boolean hasTagline() {
        return false;
    }

    @Override // com.google.android.gms.plus.model.people.Person
    public boolean hasUrl() {
        return true;
    }

    @Override // com.google.android.gms.plus.model.people.Person
    public boolean hasUrls() {
        return false;
    }

    @Override // com.google.android.gms.plus.model.people.Person
    public boolean hasVerified() {
        return false;
    }

    @Override // com.google.android.gms.plus.model.people.Person
    public boolean isPlusUser() {
        return false;
    }

    @Override // com.google.android.gms.plus.model.people.Person
    public boolean isVerified() {
        return false;
    }
}
