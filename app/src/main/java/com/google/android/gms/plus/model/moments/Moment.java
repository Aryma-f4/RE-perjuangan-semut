package com.google.android.gms.plus.model.moments;

import com.google.android.gms.common.data.Freezable;
import com.google.android.gms.internal.bx;
import com.google.android.gms.internal.bz;
import java.util.HashSet;
import java.util.Set;

/* loaded from: classes.dex */
public interface Moment extends Freezable<Moment> {

    public static class Builder {
        private final Set<Integer> iD = new HashSet();
        private bx jB;
        private bx jC;
        private String jh;
        private String js;
        private String jy;

        public Moment build() {
            return new bz(this.iD, this.jh, this.jB, this.js, this.jC, this.jy);
        }

        public Builder setId(String id) {
            this.jh = id;
            this.iD.add(2);
            return this;
        }

        public Builder setResult(ItemScope result) {
            this.jB = (bx) result;
            this.iD.add(4);
            return this;
        }

        public Builder setStartDate(String startDate) {
            this.js = startDate;
            this.iD.add(5);
            return this;
        }

        public Builder setTarget(ItemScope target) {
            this.jC = (bx) target;
            this.iD.add(6);
            return this;
        }

        public Builder setType(String type) {
            this.jy = type;
            this.iD.add(7);
            return this;
        }
    }

    String getId();

    ItemScope getResult();

    String getStartDate();

    ItemScope getTarget();

    String getType();

    boolean hasId();

    boolean hasResult();

    boolean hasStartDate();

    boolean hasTarget();

    boolean hasType();
}
