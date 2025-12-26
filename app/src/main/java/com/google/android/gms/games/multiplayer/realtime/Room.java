package com.google.android.gms.games.multiplayer.realtime;

import android.database.CharArrayBuffer;
import android.os.Bundle;
import android.os.Parcelable;
import com.google.android.gms.common.data.Freezable;
import com.google.android.gms.games.multiplayer.Participatable;
import java.util.ArrayList;

/* loaded from: classes.dex */
public interface Room extends Parcelable, Freezable<Room>, Participatable {
    public static final int ROOM_STATUS_ACTIVE = 3;
    public static final int ROOM_STATUS_AUTO_MATCHING = 1;
    public static final int ROOM_STATUS_CONNECTING = 2;
    public static final int ROOM_STATUS_INVITING = 0;
    public static final int ROOM_VARIANT_ANY = -1;

    Bundle getAutoMatchCriteria();

    int getAutoMatchWaitEstimateSeconds();

    long getCreationTimestamp();

    String getCreatorId();

    String getDescription();

    void getDescription(CharArrayBuffer charArrayBuffer);

    String getParticipantId(String str);

    ArrayList<String> getParticipantIds();

    int getParticipantStatus(String str);

    String getRoomId();

    int getStatus();

    int getVariant();
}
