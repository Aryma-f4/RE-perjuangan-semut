package com.google.android.gms.internal;

import android.os.Parcel;
import com.google.android.gms.plus.model.moments.ItemScope;
import com.google.android.gms.plus.model.moments.Moment;

/* loaded from: classes.dex */
public final class cb extends com.google.android.gms.common.data.b implements Moment {
    private bz jD;

    public cb(com.google.android.gms.common.data.d dVar, int i) {
        super(dVar, i);
    }

    private bz cb() {
        synchronized (this) {
            if (this.jD == null) {
                byte[] byteArray = getByteArray("momentImpl");
                Parcel parcelObtain = Parcel.obtain();
                parcelObtain.unmarshall(byteArray, 0, byteArray.length);
                parcelObtain.setDataPosition(0);
                this.jD = bz.CREATOR.createFromParcel(parcelObtain);
                parcelObtain.recycle();
            }
        }
        return this.jD;
    }

    @Override // com.google.android.gms.common.data.Freezable
    /* renamed from: ca, reason: merged with bridge method [inline-methods] */
    public bz freeze() {
        return cb();
    }

    @Override // com.google.android.gms.plus.model.moments.Moment
    public String getId() {
        return cb().getId();
    }

    @Override // com.google.android.gms.plus.model.moments.Moment
    public ItemScope getResult() {
        return cb().getResult();
    }

    @Override // com.google.android.gms.plus.model.moments.Moment
    public String getStartDate() {
        return cb().getStartDate();
    }

    @Override // com.google.android.gms.plus.model.moments.Moment
    public ItemScope getTarget() {
        return cb().getTarget();
    }

    @Override // com.google.android.gms.plus.model.moments.Moment
    public String getType() {
        return cb().getType();
    }

    @Override // com.google.android.gms.plus.model.moments.Moment
    public boolean hasId() {
        return cb().hasId();
    }

    @Override // com.google.android.gms.plus.model.moments.Moment
    public boolean hasResult() {
        return cb().hasId();
    }

    @Override // com.google.android.gms.plus.model.moments.Moment
    public boolean hasStartDate() {
        return cb().hasStartDate();
    }

    @Override // com.google.android.gms.plus.model.moments.Moment
    public boolean hasTarget() {
        return cb().hasTarget();
    }

    @Override // com.google.android.gms.plus.model.moments.Moment
    public boolean hasType() {
        return cb().hasType();
    }
}
