package com.adobe.air;

import android.app.Activity;
import android.content.ActivityNotFoundException;
import android.content.ContentValues;
import android.content.Intent;
import android.database.Cursor;
import android.media.MediaScannerConnection;
import android.net.Uri;
import android.os.Environment;
import android.provider.MediaStore;
import com.adobe.air.AndroidActivityWrapper;
import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Date;

/* loaded from: classes.dex */
public final class CameraUI implements AndroidActivityWrapper.ActivityResultCallback {
    public static final int ERROR_ACTIVITY_DESTROYED = 4;
    public static final int ERROR_CAMERA_BUSY = 1;
    public static final int ERROR_CAMERA_ERROR = 2;
    public static final int ERROR_CAMERA_UNAVAILABLE = 3;
    private static final String LOG_TAG = "CameraUI";
    private static final String PHONE_STORAGE = "phoneStorage";
    public static final int REQUESTED_MEDIA_TYPE_IMAGE = 1;
    public static final int REQUESTED_MEDIA_TYPE_INVALID = 0;
    public static final int REQUESTED_MEDIA_TYPE_VIDEO = 2;
    private static String sCameraRollPath = null;
    private static CameraUI sCameraUI = null;
    private long mLastClientId = 0;
    private boolean mCameraBusy = false;
    private String mImagePath = null;

    private native void nativeOnCameraCancel(long j);

    private native void nativeOnCameraError(long j, int i);

    private native void nativeOnCameraResult(long j, String str, String str2, String str3);

    private void onCameraError(int i) {
        if (this.mLastClientId != 0) {
            nativeOnCameraError(this.mLastClientId, i);
            this.mLastClientId = 0L;
        }
    }

    private void onCameraCancel() {
        if (this.mLastClientId != 0) {
            nativeOnCameraCancel(this.mLastClientId);
            this.mLastClientId = 0L;
        }
    }

    private void onCameraResult(String str, String str2, String str3) {
        if (this.mLastClientId != 0) {
            nativeOnCameraResult(this.mLastClientId, str, str2, str3);
            this.mLastClientId = 0L;
        }
    }

    private CameraUI() {
    }

    public static synchronized CameraUI getCameraUI() {
        if (sCameraUI == null) {
            sCameraUI = new CameraUI();
            AndroidActivityWrapper.GetAndroidActivityWrapper().addActivityResultListener(sCameraUI);
        }
        return sCameraUI;
    }

    public Object clone() throws CloneNotSupportedException {
        throw new CloneNotSupportedException();
    }

    public void unregisterCallbacks(long j) {
        if (this.mLastClientId == j) {
            this.mLastClientId = 0L;
        }
    }

    private String toMediaType(String str) {
        if (str == null) {
            return null;
        }
        if (str.startsWith("image/")) {
            return new String("image");
        }
        if (!str.startsWith("video/")) {
            return null;
        }
        return new String("video");
    }

    private File getFileFromUri(Uri uri, Activity activity) throws Throwable {
        Cursor cursorFromUri = getCursorFromUri(uri, activity, new String[]{"_data"});
        if (cursorFromUri == null) {
            return null;
        }
        try {
            return new File(cursorFromUri.getString(cursorFromUri.getColumnIndexOrThrow("_data")));
        } catch (IllegalArgumentException e) {
            return null;
        } finally {
            cursorFromUri.close();
        }
    }

    private Cursor getCursorFromUri(Uri uri, Activity activity, String[] strArr) throws Throwable {
        Cursor cursor;
        try {
            Cursor cursorQuery = activity.getContentResolver().query(uri, strArr, null, null, null);
            try {
                if (cursorQuery.moveToFirst()) {
                    if (!(cursorQuery != null) || !(!cursorQuery.moveToFirst())) {
                        return cursorQuery;
                    }
                    cursorQuery.close();
                    return cursorQuery;
                }
                cursorQuery.close();
                if ((cursorQuery != null) & (!cursorQuery.moveToFirst())) {
                    cursorQuery.close();
                }
                return null;
            } catch (Throwable th) {
                cursor = cursorQuery;
                th = th;
                if ((cursor != null) & (!cursor.moveToFirst())) {
                    cursor.close();
                }
                throw th;
            }
        } catch (Throwable th2) {
            th = th2;
            cursor = null;
        }
    }

    private void processImageSuccessResult() {
        String str = new String("image");
        String name = new File(this.mImagePath).getName();
        MediaScannerConnection.scanFile(AndroidActivityWrapper.GetAndroidActivityWrapper().getDefaultContext(), new String[]{this.mImagePath}, null, null);
        onCameraResult(this.mImagePath, str, name);
    }

    /* JADX WARN: Removed duplicated region for block: B:16:0x006b  */
    /* JADX WARN: Removed duplicated region for block: B:18:0x0073  */
    /* JADX WARN: Removed duplicated region for block: B:39:0x005b A[EXC_TOP_SPLITTER, SYNTHETIC] */
    /*
        Code decompiled incorrectly, please refer to instructions dump.
        To view partially-correct code enable 'Show inconsistent code' option in preferences
    */
    private void processVideoSuccessResult(android.content.Intent r10) throws java.lang.Throwable {
        /*
            r9 = this;
            r7 = 2
            r6 = 0
            java.lang.String r5 = "mime_type"
            java.lang.String r4 = "_display_name"
            java.lang.String r3 = "_data"
            r0 = 3
            java.lang.String[] r0 = new java.lang.String[r0]
            r1 = 0
            java.lang.String r2 = "_data"
            r0[r1] = r3
            r1 = 1
            java.lang.String r2 = "mime_type"
            r0[r1] = r5
            java.lang.String r1 = "_display_name"
            r0[r7] = r4
            android.net.Uri r1 = r10.getData()
            com.adobe.air.AndroidActivityWrapper r2 = com.adobe.air.AndroidActivityWrapper.GetAndroidActivityWrapper()
            android.app.Activity r2 = r2.getActivity()
            android.database.Cursor r0 = r9.getCursorFromUri(r1, r2, r0)
            if (r0 == 0) goto Lab
            java.lang.String r1 = "_data"
            int r1 = r0.getColumnIndexOrThrow(r1)     // Catch: java.lang.IllegalArgumentException -> L7f java.lang.Throwable -> L8a
            java.lang.String r2 = "mime_type"
            int r2 = r0.getColumnIndexOrThrow(r2)     // Catch: java.lang.IllegalArgumentException -> L7f java.lang.Throwable -> L8a
            java.lang.String r3 = "_display_name"
            int r3 = r0.getColumnIndexOrThrow(r3)     // Catch: java.lang.IllegalArgumentException -> L7f java.lang.Throwable -> L8a
            java.lang.String r1 = r0.getString(r1)     // Catch: java.lang.IllegalArgumentException -> L7f java.lang.Throwable -> L8a
            if (r1 == 0) goto La8
            java.lang.String r2 = r0.getString(r2)     // Catch: java.lang.Throwable -> L8a java.lang.IllegalArgumentException -> L93
            java.lang.String r2 = r9.toMediaType(r2)     // Catch: java.lang.Throwable -> L8a java.lang.IllegalArgumentException -> L93
            if (r2 != 0) goto L55
            java.lang.String r4 = new java.lang.String     // Catch: java.lang.Throwable -> L8a java.lang.IllegalArgumentException -> L98
            java.lang.String r5 = "video"
            r4.<init>(r5)     // Catch: java.lang.Throwable -> L8a java.lang.IllegalArgumentException -> L98
            r2 = r4
        L55:
            java.lang.String r3 = r0.getString(r3)     // Catch: java.lang.Throwable -> L8a java.lang.IllegalArgumentException -> L9d
            if (r3 != 0) goto L63
            java.lang.String r4 = new java.lang.String     // Catch: java.lang.Throwable -> L8a java.lang.IllegalArgumentException -> La2
            java.lang.String r5 = ""
            r4.<init>(r5)     // Catch: java.lang.Throwable -> L8a java.lang.IllegalArgumentException -> La2
            r3 = r4
        L63:
            r0.close()
            r0 = r2
            r2 = r1
            r1 = r3
        L69:
            if (r0 == 0) goto L73
            java.lang.String r3 = "image"
            boolean r3 = r0.equals(r3)
            if (r3 != 0) goto L7b
        L73:
            java.lang.String r3 = "video"
            boolean r3 = r0.equals(r3)
            if (r3 == 0) goto L8f
        L7b:
            r9.onCameraResult(r2, r0, r1)
        L7e:
            return
        L7f:
            r1 = move-exception
            r1 = r6
            r2 = r6
            r3 = r6
        L83:
            r0.close()
            r0 = r1
            r1 = r2
            r2 = r3
            goto L69
        L8a:
            r1 = move-exception
            r0.close()
            throw r1
        L8f:
            r9.onCameraError(r7)
            goto L7e
        L93:
            r2 = move-exception
            r2 = r6
            r3 = r1
            r1 = r6
            goto L83
        L98:
            r3 = move-exception
            r3 = r1
            r1 = r2
            r2 = r6
            goto L83
        L9d:
            r3 = move-exception
            r3 = r1
            r1 = r2
            r2 = r6
            goto L83
        La2:
            r4 = move-exception
            r8 = r2
            r2 = r3
            r3 = r1
            r1 = r8
            goto L83
        La8:
            r2 = r6
            r3 = r6
            goto L63
        Lab:
            r0 = r6
            r1 = r6
            r2 = r6
            goto L69
        */
        throw new UnsupportedOperationException("Method not decompiled: com.adobe.air.CameraUI.processVideoSuccessResult(android.content.Intent):void");
    }

    @Override // com.adobe.air.AndroidActivityWrapper.ActivityResultCallback
    public void onActivityResult(int i, int i2, Intent intent) throws Throwable {
        if (i == 3 || i == 4) {
            this.mCameraBusy = false;
            if (this.mLastClientId != 0) {
                switch (i2) {
                    case -1:
                        if (i == 3) {
                            if (this.mImagePath != null) {
                                processImageSuccessResult();
                                this.mImagePath = null;
                                break;
                            } else {
                                onCameraCancel();
                                break;
                            }
                        } else if (i == 4) {
                            processVideoSuccessResult(intent);
                            break;
                        }
                        break;
                    case 0:
                        if (this.mImagePath != null) {
                            this.mImagePath = null;
                        }
                        onCameraCancel();
                        break;
                    default:
                        if (this.mImagePath != null) {
                            this.mImagePath = null;
                        }
                        onCameraError(2);
                        break;
                }
            }
        }
    }

    public void launch(long j, int i) {
        int iVideoCaptureWork;
        if (j != 0) {
            if (this.mCameraBusy) {
                nativeOnCameraError(j, 1);
                return;
            }
            if (this.mLastClientId != 0) {
                onCameraError(1);
            }
            this.mLastClientId = j;
            this.mCameraBusy = true;
            switch (i) {
                case 1:
                    iVideoCaptureWork = stillPictureWork();
                    break;
                case 2:
                    iVideoCaptureWork = videoCaptureWork();
                    break;
                default:
                    iVideoCaptureWork = 3;
                    break;
            }
            if (iVideoCaptureWork != 0) {
                this.mCameraBusy = false;
                onCameraError(iVideoCaptureWork);
            }
        }
    }

    private int videoCaptureWork() {
        try {
            Activity activity = AndroidActivityWrapper.GetAndroidActivityWrapper().getActivity();
            if (activity == null) {
                return 4;
            }
            Intent intent = new Intent("android.media.action.VIDEO_CAPTURE");
            intent.putExtra("android.intent.extra.videoQuality", 0);
            activity.startActivityForResult(intent, 4);
            return 0;
        } catch (ActivityNotFoundException e) {
            return 3;
        }
    }

    private String getCameraRollDirectory(Activity activity) {
        Uri uriInsert;
        if (sCameraRollPath != null) {
            return sCameraRollPath;
        }
        try {
            uriInsert = activity.getContentResolver().insert(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, new ContentValues());
        } catch (Exception e) {
            uriInsert = null;
        }
        if (uriInsert == null) {
            try {
                uriInsert = activity.getContentResolver().insert(MediaStore.Images.Media.getContentUri(PHONE_STORAGE), new ContentValues());
            } catch (Exception e2) {
            }
        }
        if (uriInsert != null) {
            try {
                sCameraRollPath = getFileFromUri(uriInsert, activity).getParent();
            } catch (ActivityNotFoundException e3) {
            } catch (NullPointerException e4) {
            } finally {
                activity.getContentResolver().delete(uriInsert, null, null);
            }
        } else {
            File externalStoragePublicDirectory = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES);
            if (externalStoragePublicDirectory.exists()) {
                sCameraRollPath = externalStoragePublicDirectory.toString();
            }
        }
        return sCameraRollPath;
    }

    private int stillPictureWork() {
        String str;
        int i;
        Activity activity = AndroidActivityWrapper.GetAndroidActivityWrapper().getActivity();
        if (activity == null) {
            return 4;
        }
        if (getCameraRollDirectory(activity) == null) {
            return 2;
        }
        String str2 = getCameraRollDirectory(activity) + "/" + new SimpleDateFormat("'IMG'_yyyyMMdd_HHmmss").format(new Date(System.currentTimeMillis())) + ".jpg";
        File file = new File(str2);
        if (file.exists()) {
            return 2;
        }
        try {
            Intent intent = new Intent("android.media.action.IMAGE_CAPTURE");
            intent.putExtra("output", Uri.fromFile(file));
            activity.startActivityForResult(intent, 3);
            i = 0;
            str = str2;
        } catch (ActivityNotFoundException e) {
            str = null;
            i = 3;
        } catch (NullPointerException e2) {
            str = null;
            i = 2;
        }
        this.mImagePath = str;
        return i;
    }
}
