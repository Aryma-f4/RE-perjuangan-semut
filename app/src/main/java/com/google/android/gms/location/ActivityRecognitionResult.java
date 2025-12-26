package com.google.android.gms.location;

import android.content.Intent;
import android.os.Parcel;
import com.google.android.gms.common.internal.safeparcel.SafeParcelable;
import com.google.android.gms.internal.s;
import java.util.Collections;
import java.util.List;

/* loaded from: classes.dex */
public class ActivityRecognitionResult implements SafeParcelable {
    public static final ActivityRecognitionResultCreator CREATOR = new ActivityRecognitionResultCreator();
    public static final String EXTRA_ACTIVITY_RESULT = "com.google.android.location.internal.EXTRA_ACTIVITY_RESULT";
    private final int ab;
    List<DetectedActivity> fp;
    long fq;
    long fr;

    public ActivityRecognitionResult(int versionCode, List<DetectedActivity> probableActivities, long timeMillis, long elapsedRealtimeMillis) {
        this.ab = 1;
        this.fp = probableActivities;
        this.fq = timeMillis;
        this.fr = elapsedRealtimeMillis;
    }

    public ActivityRecognitionResult(DetectedActivity mostProbableActivity, long time, long elapsedRealtimeMillis) {
        this((List<DetectedActivity>) Collections.singletonList(mostProbableActivity), time, elapsedRealtimeMillis);
    }

    public ActivityRecognitionResult(List<DetectedActivity> probableActivities, long time, long elapsedRealtimeMillis) {
        s.b(probableActivities != null && probableActivities.size() > 0, "Must have at least 1 detected activity");
        this.ab = 1;
        this.fp = probableActivities;
        this.fq = time;
        this.fr = elapsedRealtimeMillis;
    }

    public static ActivityRecognitionResult extractResult(Intent intent) {
        if (hasResult(intent)) {
            return (ActivityRecognitionResult) intent.getExtras().get(EXTRA_ACTIVITY_RESULT);
        }
        return null;
    }

    public static boolean hasResult(Intent intent) {
        if (intent == null) {
            return false;
        }
        return intent.hasExtra(EXTRA_ACTIVITY_RESULT);
    }

    @Override // android.os.Parcelable
    public int describeContents() {
        return 0;
    }

    public int getActivityConfidence(int activityType) {
        for (DetectedActivity detectedActivity : this.fp) {
            if (detectedActivity.getType() == activityType) {
                return detectedActivity.getConfidence();
            }
        }
        return 0;
    }

    public long getElapsedRealtimeMillis() {
        return this.fr;
    }

    public DetectedActivity getMostProbableActivity() {
        return this.fp.get(0);
    }

    public List<DetectedActivity> getProbableActivities() {
        return this.fp;
    }

    public long getTime() {
        return this.fq;
    }

    public int i() {
        return this.ab;
    }

    public String toString() {
        return "ActivityRecognitionResult [probableActivities=" + this.fp + ", timeMillis=" + this.fq + ", elapsedRealtimeMillis=" + this.fr + "]";
    }

    @Override // android.os.Parcelable
    public void writeToParcel(Parcel out, int flags) {
        ActivityRecognitionResultCreator.a(this, out, flags);
    }
}
