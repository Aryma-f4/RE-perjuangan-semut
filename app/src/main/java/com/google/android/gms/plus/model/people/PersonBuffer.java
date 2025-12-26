package com.google.android.gms.plus.model.people;

import com.google.android.gms.common.data.DataBuffer;
import com.google.android.gms.common.data.c;
import com.google.android.gms.common.data.d;
import com.google.android.gms.internal.cc;
import com.google.android.gms.internal.cn;

/* loaded from: classes.dex */
public final class PersonBuffer extends DataBuffer<Person> {
    private final c<cc> kp;

    public PersonBuffer(d dataHolder) {
        super(dataHolder);
        if (dataHolder.l() == null || !dataHolder.l().getBoolean("com.google.android.gms.plus.IsSafeParcelable", false)) {
            this.kp = null;
        } else {
            this.kp = new c<>(dataHolder, cc.CREATOR);
        }
    }

    /* JADX WARN: Can't rename method to resolve collision */
    @Override // com.google.android.gms.common.data.DataBuffer
    public Person get(int position) {
        return this.kp != null ? (Person) this.kp.get(position) : new cn(this.S, position);
    }
}
