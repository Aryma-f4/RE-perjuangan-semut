package com.google.android.gms.plus.model.people;

import com.google.android.gms.common.data.Freezable;
import java.util.List;

/* loaded from: classes.dex */
public interface Person extends Freezable<Person> {

    public interface AgeRange extends Freezable<AgeRange> {
        int getMax();

        int getMin();

        boolean hasMax();

        boolean hasMin();
    }

    @Deprecated
    public interface Collection {

        @Deprecated
        public static final int VISIBLE = 0;
    }

    public interface Cover extends Freezable<Cover> {

        public interface CoverInfo extends Freezable<CoverInfo> {
            int getLeftImageOffset();

            int getTopImageOffset();

            boolean hasLeftImageOffset();

            boolean hasTopImageOffset();
        }

        public interface CoverPhoto extends Freezable<CoverPhoto> {
            int getHeight();

            String getUrl();

            int getWidth();

            boolean hasHeight();

            boolean hasUrl();

            boolean hasWidth();
        }

        public static final class Layout {
            public static final int BANNER = 0;

            private Layout() {
            }
        }

        CoverInfo getCoverInfo();

        CoverPhoto getCoverPhoto();

        int getLayout();

        boolean hasCoverInfo();

        boolean hasCoverPhoto();

        boolean hasLayout();
    }

    @Deprecated
    public interface Emails extends Freezable<Emails> {

        @Deprecated
        public static final class Type {

            @Deprecated
            public static final int HOME = 0;

            @Deprecated
            public static final int OTHER = 2;

            @Deprecated
            public static final int WORK = 1;

            private Type() {
            }
        }

        @Deprecated
        int getType();

        @Deprecated
        String getValue();

        @Deprecated
        boolean hasPrimary();

        @Deprecated
        boolean hasType();

        @Deprecated
        boolean hasValue();

        @Deprecated
        boolean isPrimary();
    }

    public static final class Gender {
        public static final int FEMALE = 1;
        public static final int MALE = 0;
        public static final int OTHER = 2;

        private Gender() {
        }
    }

    public interface Image extends Freezable<Image> {
        String getUrl();

        boolean hasUrl();
    }

    public interface Name extends Freezable<Name> {
        String getFamilyName();

        String getFormatted();

        String getGivenName();

        String getHonorificPrefix();

        String getHonorificSuffix();

        String getMiddleName();

        boolean hasFamilyName();

        boolean hasFormatted();

        boolean hasGivenName();

        boolean hasHonorificPrefix();

        boolean hasHonorificSuffix();

        boolean hasMiddleName();
    }

    public static final class ObjectType {
        public static final int PAGE = 1;
        public static final int PERSON = 0;

        private ObjectType() {
        }
    }

    @Deprecated
    public interface OrderBy {

        @Deprecated
        public static final int ALPHABETICAL = 0;

        @Deprecated
        public static final int BEST = 1;
    }

    public interface Organizations extends Freezable<Organizations> {

        public static final class Type {
            public static final int SCHOOL = 1;
            public static final int WORK = 0;

            private Type() {
            }
        }

        String getDepartment();

        String getDescription();

        String getEndDate();

        String getLocation();

        String getName();

        String getStartDate();

        String getTitle();

        int getType();

        boolean hasDepartment();

        boolean hasDescription();

        boolean hasEndDate();

        boolean hasLocation();

        boolean hasName();

        boolean hasPrimary();

        boolean hasStartDate();

        boolean hasTitle();

        boolean hasType();

        boolean isPrimary();
    }

    public interface PlacesLived extends Freezable<PlacesLived> {
        String getValue();

        boolean hasPrimary();

        boolean hasValue();

        boolean isPrimary();
    }

    public static final class RelationshipStatus {
        public static final int ENGAGED = 2;
        public static final int IN_A_RELATIONSHIP = 1;
        public static final int IN_CIVIL_UNION = 8;
        public static final int IN_DOMESTIC_PARTNERSHIP = 7;
        public static final int ITS_COMPLICATED = 4;
        public static final int MARRIED = 3;
        public static final int OPEN_RELATIONSHIP = 5;
        public static final int SINGLE = 0;
        public static final int WIDOWED = 6;

        private RelationshipStatus() {
        }
    }

    public interface Urls extends Freezable<Urls> {

        public static final class Type {
            public static final int CONTRIBUTOR = 6;
            public static final int OTHER = 4;
            public static final int OTHER_PROFILE = 5;
            public static final int WEBSITE = 7;

            private Type() {
            }
        }

        String getLabel();

        int getType();

        String getValue();

        boolean hasLabel();

        boolean hasType();

        boolean hasValue();
    }

    String getAboutMe();

    AgeRange getAgeRange();

    String getBirthday();

    String getBraggingRights();

    int getCircledByCount();

    Cover getCover();

    String getCurrentLocation();

    String getDisplayName();

    @Deprecated
    List<Emails> getEmails();

    int getGender();

    String getId();

    Image getImage();

    String getLanguage();

    Name getName();

    String getNickname();

    int getObjectType();

    List<Organizations> getOrganizations();

    List<PlacesLived> getPlacesLived();

    int getPlusOneCount();

    int getRelationshipStatus();

    String getTagline();

    String getUrl();

    List<Urls> getUrls();

    boolean hasAboutMe();

    boolean hasAgeRange();

    boolean hasBirthday();

    boolean hasBraggingRights();

    boolean hasCircledByCount();

    boolean hasCover();

    boolean hasCurrentLocation();

    boolean hasDisplayName();

    @Deprecated
    boolean hasEmails();

    boolean hasGender();

    boolean hasId();

    boolean hasImage();

    boolean hasIsPlusUser();

    boolean hasLanguage();

    boolean hasName();

    boolean hasNickname();

    boolean hasObjectType();

    boolean hasOrganizations();

    boolean hasPlacesLived();

    boolean hasPlusOneCount();

    boolean hasRelationshipStatus();

    boolean hasTagline();

    boolean hasUrl();

    boolean hasUrls();

    boolean hasVerified();

    boolean isPlusUser();

    boolean isVerified();
}
