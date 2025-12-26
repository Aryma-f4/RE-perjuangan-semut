package com.adobe.air;

import android.media.AudioTrack;

/* loaded from: classes.dex */
public class AJAudioTrack extends AudioTrack {
    private static int sStreamType = 3;
    private byte[] mBuf;

    public static AJAudioTrack CreateTrack(int i, int i2, int i3, int i4) {
        try {
            int minBufferSize = AudioTrack.getMinBufferSize(i, ToAndroidChannelCount(i3), ToAndroidFormat(i2));
            if (i4 >= minBufferSize) {
                minBufferSize = i4;
            }
            AJAudioTrack aJAudioTrack = new AJAudioTrack(i, ToAndroidFormat(i2), ToAndroidChannelCount(i3), minBufferSize);
            if (aJAudioTrack.getState() == 1) {
                return aJAudioTrack;
            }
            aJAudioTrack.release();
            return null;
        } catch (Exception e) {
            return null;
        }
    }

    public AJAudioTrack(int i, int i2, int i3, int i4) {
        super(sStreamType, i, i3, i2, i4, 1);
        this.mBuf = new byte[i4];
    }

    public static void SetStreamType(int i) {
        sStreamType = i;
    }

    public static int ToAndroidFormat(int i) {
        return i == 1 ? 3 : 2;
    }

    public static int ToAndroidChannelCount(int i) {
        return i == 1 ? 4 : 12;
    }

    public byte[] GetBuffer() {
        return this.mBuf;
    }

    public boolean playing() {
        return getPlayState() == 3;
    }

    public boolean stopped() {
        return getPlayState() == 1;
    }
}
