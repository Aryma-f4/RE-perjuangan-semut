package com.adobe.air.microphone;

import android.media.AudioRecord;
import android.os.Process;

/* loaded from: classes.dex */
public class AIRMicrophoneRecorder implements Runnable {
    private byte[] mMicBuffer;
    private int m_audioFormat;
    private int m_audioSource;
    private int m_bufferSize;
    private int m_channelConfiguration;
    private volatile boolean m_isPaused;
    private volatile boolean m_isRecording;
    private AudioRecord m_recorder;
    private int m_sampleRate;
    private final Object mutex = new Object();

    public AIRMicrophoneRecorder(int i, int i2, int i3, int i4, int i5) {
        this.m_audioSource = 0;
        this.m_sampleRate = 0;
        this.m_channelConfiguration = 0;
        this.m_audioFormat = 0;
        this.m_bufferSize = 0;
        this.m_audioSource = i;
        this.m_sampleRate = i2;
        this.m_channelConfiguration = i3;
        this.m_audioFormat = i4;
        this.m_bufferSize = i5;
        this.mMicBuffer = new byte[this.m_bufferSize];
    }

    @Override // java.lang.Runnable
    public void run() throws IllegalStateException, SecurityException, IllegalArgumentException {
        synchronized (this.mutex) {
            while (!isRecording()) {
                try {
                    this.mutex.wait();
                } catch (InterruptedException e) {
                    throw new IllegalStateException("Wait interrupted", e);
                }
            }
        }
        Process.setThreadPriority(-19);
        if (this.m_recorder != null) {
            try {
                this.m_recorder.startRecording();
            } catch (IllegalStateException e2) {
            }
        }
    }

    public Boolean Open() {
        int i;
        int minBufferSize = AudioRecord.getMinBufferSize(this.m_sampleRate, this.m_channelConfiguration, this.m_audioFormat);
        if (this.m_bufferSize > minBufferSize) {
            i = this.m_bufferSize;
        } else {
            i = minBufferSize * 2;
        }
        try {
            this.m_recorder = new AudioRecord(this.m_audioSource, this.m_sampleRate, this.m_channelConfiguration, this.m_audioFormat, i);
            if (this.m_recorder != null && this.m_recorder.getState() == 1) {
                return true;
            }
            return false;
        } catch (IllegalArgumentException e) {
            e.printStackTrace();
            return false;
        }
    }

    public byte[] getBuffer() {
        int i = this.m_recorder.read(this.mMicBuffer, 0, this.m_bufferSize);
        if (i != -3 && i == -2) {
        }
        return this.mMicBuffer;
    }

    public void setRecording(boolean z) {
        synchronized (this.mutex) {
            this.m_isRecording = z;
            if (this.m_isRecording) {
                this.mutex.notify();
            } else {
                if (this.m_recorder.getState() == 1) {
                    this.m_recorder.stop();
                }
                this.m_recorder.release();
            }
        }
    }

    public boolean isRecording() {
        boolean z;
        synchronized (this.mutex) {
            z = this.m_isRecording;
        }
        return z;
    }
}
