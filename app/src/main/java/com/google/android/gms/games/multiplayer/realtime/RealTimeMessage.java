package com.google.android.gms.games.multiplayer.realtime;

import android.os.Parcel;
import android.os.Parcelable;
import com.google.android.gms.internal.s;

/* loaded from: classes.dex */
public final class RealTimeMessage implements Parcelable {
    public static final Parcelable.Creator<RealTimeMessage> CREATOR = new Parcelable.Creator<RealTimeMessage>() { // from class: com.google.android.gms.games.multiplayer.realtime.RealTimeMessage.1
        @Override // android.os.Parcelable.Creator
        /* renamed from: J, reason: merged with bridge method [inline-methods] */
        public RealTimeMessage[] newArray(int i) {
            return new RealTimeMessage[i];
        }

        @Override // android.os.Parcelable.Creator
        /* renamed from: r, reason: merged with bridge method [inline-methods] */
        public RealTimeMessage createFromParcel(Parcel parcel) {
            return new RealTimeMessage(parcel);
        }
    };
    public static final int RELIABLE = 1;
    public static final int UNRELIABLE = 0;
    private final String eT;
    private final byte[] eU;
    private final int eV;

    private RealTimeMessage(Parcel parcel) {
        this(parcel.readString(), parcel.createByteArray(), parcel.readInt());
    }

    public RealTimeMessage(String senderParticipantId, byte[] messageData, int isReliable) {
        this.eT = (String) s.d(senderParticipantId);
        this.eU = (byte[]) ((byte[]) s.d(messageData)).clone();
        this.eV = isReliable;
    }

    @Override // android.os.Parcelable
    public int describeContents() {
        return 0;
    }

    public byte[] getMessageData() {
        return this.eU;
    }

    public String getSenderParticipantId() {
        return this.eT;
    }

    public boolean isReliable() {
        return this.eV == 1;
    }

    @Override // android.os.Parcelable
    public void writeToParcel(Parcel parcel, int flag) {
        parcel.writeString(this.eT);
        parcel.writeByteArray(this.eU);
        parcel.writeInt(this.eV);
    }
}
