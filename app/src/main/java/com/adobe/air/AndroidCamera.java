package com.adobe.air;

import android.content.res.Configuration;
import android.graphics.ImageFormat;
import android.hardware.Camera;
import android.view.SurfaceHolder;
import com.adobe.air.AndroidActivityWrapper;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.Iterator;
import java.util.List;

/* loaded from: classes.dex */
public class AndroidCamera {
    private static final int CAMERA_POSITION_UNKNOWN = -1;
    private static final String LOG_TAG = "AndroidCamera";
    private long mClientId;
    private static Class<?> sCameraInfoClass = null;
    private static Method sMIDOpen = null;
    private static Method sMIDOpenWithCameraID = null;
    private static Method sMIDGetNumberOfCameras = null;
    private static Method sMIDGetCameraInfo = null;
    private static boolean sAreMultipleCamerasSupportedOnDevice = false;
    private static boolean sAreMultipleCamerasSupportedInitialized = false;
    private Camera mCamera = null;
    private int mCameraId = 0;
    private boolean mInitialized = false;
    private boolean mCallbacksRegistered = false;
    private boolean mPreviewSurfaceValid = true;
    private boolean mCapturing = false;
    private AndroidActivityWrapper.StateChangeCallback mActivityStateCB = null;
    private byte[] mCallbackBuffer = null;
    private byte[] mBuffer1 = null;
    private byte[] mBuffer2 = null;

    /* JADX INFO: Access modifiers changed from: private */
    public native void nativeOnCanOpenCamera(long j);

    /* JADX INFO: Access modifiers changed from: private */
    public native void nativeOnFrameCaptured(long j, byte[] bArr);

    /* JADX INFO: Access modifiers changed from: private */
    public native void nativeOnShouldCloseCamera(long j);

    public AndroidCamera(long j) {
        this.mClientId = 0L;
        this.mClientId = j;
        areMultipleCamerasSupportedOnDevice();
    }

    public static boolean areMultipleCamerasSupportedOnDevice() {
        if (sAreMultipleCamerasSupportedInitialized) {
            return sAreMultipleCamerasSupportedOnDevice;
        }
        sAreMultipleCamerasSupportedInitialized = true;
        try {
            sMIDOpenWithCameraID = Camera.class.getMethod("open", Integer.TYPE);
            sMIDGetNumberOfCameras = Camera.class.getDeclaredMethod("getNumberOfCameras", (Class[]) null);
            try {
                sCameraInfoClass = Class.forName("android.hardware.Camera$CameraInfo");
                sMIDGetCameraInfo = Camera.class.getMethod("getCameraInfo", Integer.TYPE, sCameraInfoClass);
                if (sMIDOpenWithCameraID != null && sMIDGetNumberOfCameras != null && sMIDGetCameraInfo != null) {
                    sAreMultipleCamerasSupportedOnDevice = true;
                }
                return sAreMultipleCamerasSupportedOnDevice;
            } catch (Exception e) {
                return false;
            }
        } catch (NoSuchMethodException e2) {
            return false;
        }
    }

    /* JADX WARN: Removed duplicated region for block: B:17:0x0042  */
    /* JADX WARN: Removed duplicated region for block: B:27:0x0067  */
    /*
        Code decompiled incorrectly, please refer to instructions dump.
        To view partially-correct code enable 'Show inconsistent code' option in preferences
    */
    public boolean open(int r10) throws java.io.IOException {
        /*
            r9 = this;
            r8 = 0
            r7 = 1
            r6 = 0
            android.hardware.Camera r0 = r9.mCamera
            if (r0 == 0) goto L9
            r0 = r7
        L8:
            return r0
        L9:
            com.adobe.air.AndroidActivityWrapper r0 = com.adobe.air.AndroidActivityWrapper.GetAndroidActivityWrapper()     // Catch: java.lang.Exception -> L64
            com.adobe.air.AndroidCameraView r0 = r0.getCameraView()     // Catch: java.lang.Exception -> L64
            android.view.SurfaceHolder r1 = r0.getHolder()     // Catch: java.lang.Exception -> L64
            if (r1 == 0) goto L3d
            android.view.Surface r0 = r1.getSurface()     // Catch: java.lang.Exception -> L56
            if (r0 == 0) goto L3d
            boolean r0 = com.adobe.air.AndroidCamera.sAreMultipleCamerasSupportedOnDevice     // Catch: java.lang.Exception -> L56
            if (r0 == 0) goto L4c
            java.lang.reflect.Method r0 = com.adobe.air.AndroidCamera.sMIDOpenWithCameraID     // Catch: java.lang.Exception -> L56
            r2 = 0
            r3 = 1
            java.lang.Object[] r3 = new java.lang.Object[r3]     // Catch: java.lang.Exception -> L56
            r4 = 0
            java.lang.Integer r5 = java.lang.Integer.valueOf(r10)     // Catch: java.lang.Exception -> L56
            r3[r4] = r5     // Catch: java.lang.Exception -> L56
            java.lang.Object r0 = r0.invoke(r2, r3)     // Catch: java.lang.Exception -> L56
            android.hardware.Camera r0 = (android.hardware.Camera) r0     // Catch: java.lang.Exception -> L56
            r9.mCamera = r0     // Catch: java.lang.Exception -> L56
            r9.mCameraId = r10     // Catch: java.lang.Exception -> L56
        L38:
            android.hardware.Camera r0 = r9.mCamera     // Catch: java.lang.Exception -> L56
            r0.setPreviewDisplay(r1)     // Catch: java.lang.Exception -> L56
        L3d:
            r0 = r1
        L3e:
            android.hardware.Camera r1 = r9.mCamera
            if (r1 == 0) goto L67
            com.adobe.air.AndroidCamera$PreviewSurfaceCallback r1 = new com.adobe.air.AndroidCamera$PreviewSurfaceCallback
            r1.<init>()
            r0.addCallback(r1)
            r0 = r7
            goto L8
        L4c:
            android.hardware.Camera r0 = android.hardware.Camera.open()     // Catch: java.lang.Exception -> L56
            r9.mCamera = r0     // Catch: java.lang.Exception -> L56
            r0 = 0
            r9.mCameraId = r0     // Catch: java.lang.Exception -> L56
            goto L38
        L56:
            r0 = move-exception
            r0 = r1
        L58:
            android.hardware.Camera r1 = r9.mCamera
            if (r1 == 0) goto L3e
            android.hardware.Camera r1 = r9.mCamera
            r1.release()
            r9.mCamera = r8
            goto L3e
        L64:
            r0 = move-exception
            r0 = r8
            goto L58
        L67:
            r0 = r6
            goto L8
        */
        throw new UnsupportedOperationException("Method not decompiled: com.adobe.air.AndroidCamera.open(int):boolean");
    }

    public Camera getCamera() {
        return this.mCamera;
    }

    public int[] getSupportedFps() {
        int i = 0;
        int[] iArr = new int[0];
        try {
            List<Integer> supportedPreviewFrameRates = this.mCamera.getParameters().getSupportedPreviewFrameRates();
            iArr = new int[supportedPreviewFrameRates.size()];
            Iterator<Integer> it = supportedPreviewFrameRates.iterator();
            while (true) {
                int i2 = i;
                if (!it.hasNext()) {
                    break;
                }
                i = i2 + 1;
                iArr[i2] = it.next().intValue();
            }
        } catch (Exception e) {
        }
        return iArr;
    }

    public int getCameraPosition() throws IllegalAccessException, NoSuchFieldException, InstantiationException, IllegalArgumentException, InvocationTargetException {
        Object objNewInstance;
        Field field;
        if (!sAreMultipleCamerasSupportedOnDevice) {
            return -1;
        }
        if (sCameraInfoClass != null) {
            try {
                objNewInstance = sCameraInfoClass.newInstance();
            } catch (Exception e) {
                return -1;
            }
        } else {
            objNewInstance = null;
        }
        try {
            sMIDGetCameraInfo.invoke(this.mCamera, Integer.valueOf(this.mCameraId), objNewInstance);
            if (objNewInstance != null) {
                try {
                    field = objNewInstance.getClass().getField("facing");
                } catch (Exception e2) {
                    return -1;
                }
            } else {
                field = null;
            }
            try {
                return field.getInt(objNewInstance);
            } catch (Exception e3) {
                return -1;
            }
        } catch (Exception e4) {
            return -1;
        }
    }

    public static int getNumberOfCameras() {
        if (areMultipleCamerasSupportedOnDevice()) {
            try {
                return ((Integer) sMIDGetNumberOfCameras.invoke(null, (Object[]) null)).intValue();
            } catch (Exception e) {
            }
        }
        return 1;
    }

    public int[] getSupportedFormats() {
        int i = 0;
        int[] iArr = new int[0];
        try {
            List<Integer> supportedPreviewFormats = this.mCamera.getParameters().getSupportedPreviewFormats();
            iArr = new int[supportedPreviewFormats.size()];
            Iterator<Integer> it = supportedPreviewFormats.iterator();
            while (true) {
                int i2 = i;
                if (!it.hasNext()) {
                    break;
                }
                i = i2 + 1;
                iArr[i2] = it.next().intValue();
            }
        } catch (Exception e) {
        }
        return iArr;
    }

    public int[] getSupportedVideoSizes() {
        int[] iArr = new int[0];
        try {
            List<Camera.Size> supportedPreviewSizes = this.mCamera.getParameters().getSupportedPreviewSizes();
            iArr = new int[supportedPreviewSizes.size() * 2];
            int i = 0;
            for (Camera.Size size : supportedPreviewSizes) {
                int i2 = i + 1;
                iArr[i] = size.width;
                i = i2 + 1;
                iArr[i2] = size.height;
            }
        } catch (Exception e) {
        }
        return iArr;
    }

    public int getCaptureWidth() {
        try {
            return this.mCamera.getParameters().getPreviewSize().width;
        } catch (Exception e) {
            return 0;
        }
    }

    public int getCaptureHeight() {
        try {
            return this.mCamera.getParameters().getPreviewSize().height;
        } catch (Exception e) {
            return 0;
        }
    }

    public int getCaptureFormat() {
        try {
            return this.mCamera.getParameters().getPreviewFormat();
        } catch (Exception e) {
            return 0;
        }
    }

    public boolean setContinuousFocusMode() {
        if (this.mCamera == null) {
            return false;
        }
        try {
            Camera.Parameters parameters = this.mCamera.getParameters();
            if (!parameters.getSupportedFocusModes().contains("edof")) {
                return false;
            }
            parameters.setFocusMode("edof");
            this.mCamera.setParameters(parameters);
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    public boolean autoFocus() {
        if (this.mCamera == null || !this.mCapturing) {
            return false;
        }
        try {
            String focusMode = this.mCamera.getParameters().getFocusMode();
            if (focusMode == "fixed" || focusMode == "infinity") {
                return false;
            }
            this.mCamera.autoFocus(null);
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    public boolean startCapture(int i, int i2, int i3, int i4) {
        if (this.mCamera == null) {
            return false;
        }
        try {
            Camera.Parameters parameters = this.mCamera.getParameters();
            parameters.setPreviewSize(i, i2);
            parameters.setPreviewFrameRate(i3);
            parameters.setPreviewFormat(i4);
            this.mCamera.setParameters(parameters);
            this.mCamera.setPreviewCallbackWithBuffer(new Camera.PreviewCallback() { // from class: com.adobe.air.AndroidCamera.1
                @Override // android.hardware.Camera.PreviewCallback
                public void onPreviewFrame(byte[] bArr, Camera camera) {
                    try {
                        if (AndroidCamera.this.mClientId != 0 && AndroidCamera.this.mCallbacksRegistered) {
                            AndroidCamera.this.nativeOnFrameCaptured(AndroidCamera.this.mClientId, bArr);
                        }
                        if (AndroidCamera.this.mCallbackBuffer == AndroidCamera.this.mBuffer1) {
                            AndroidCamera.this.mCallbackBuffer = AndroidCamera.this.mBuffer2;
                        } else {
                            AndroidCamera.this.mCallbackBuffer = AndroidCamera.this.mBuffer1;
                        }
                        AndroidCamera.this.mCamera.addCallbackBuffer(AndroidCamera.this.mCallbackBuffer);
                    } catch (Exception e) {
                    }
                }
            });
            this.mCamera.startPreview();
            Camera.Parameters parameters2 = this.mCamera.getParameters();
            int bitsPerPixel = ImageFormat.getBitsPerPixel(parameters2.getPreviewFormat()) * parameters2.getPreviewSize().width * parameters2.getPreviewSize().height;
            this.mBuffer1 = new byte[bitsPerPixel];
            this.mBuffer2 = new byte[bitsPerPixel];
            this.mCallbackBuffer = this.mBuffer1;
            this.mCamera.addCallbackBuffer(this.mCallbackBuffer);
            try {
                this.mCapturing = true;
                return true;
            } catch (Exception e) {
                return true;
            }
        } catch (Exception e2) {
            return false;
        }
    }

    public void stopCapture() {
        if (this.mCamera != null) {
            this.mCamera.setPreviewCallback(null);
            this.mCamera.stopPreview();
            this.mCallbackBuffer = null;
            this.mBuffer1 = null;
            this.mBuffer2 = null;
        }
        this.mCapturing = false;
    }

    public void close() {
        if (this.mCamera != null) {
            stopCapture();
            this.mCamera.release();
            this.mCamera = null;
        }
    }

    public void registerCallbacks(boolean z) {
        this.mCallbacksRegistered = z;
        if (z) {
            if (this.mActivityStateCB == null) {
                this.mActivityStateCB = new AndroidActivityWrapper.StateChangeCallback() { // from class: com.adobe.air.AndroidCamera.2
                    @Override // com.adobe.air.AndroidActivityWrapper.StateChangeCallback
                    public void onActivityStateChanged(AndroidActivityWrapper.ActivityState activityState) {
                        if (AndroidCamera.this.mClientId != 0 && AndroidCamera.this.mCallbacksRegistered) {
                            if (activityState == AndroidActivityWrapper.ActivityState.RESUMED && AndroidCamera.this.mPreviewSurfaceValid) {
                                AndroidCamera.this.nativeOnCanOpenCamera(AndroidCamera.this.mClientId);
                            } else if (activityState == AndroidActivityWrapper.ActivityState.PAUSED) {
                                AndroidCamera.this.nativeOnShouldCloseCamera(AndroidCamera.this.mClientId);
                            }
                        }
                    }

                    @Override // com.adobe.air.AndroidActivityWrapper.StateChangeCallback
                    public void onConfigurationChanged(Configuration configuration) {
                    }
                };
            }
            AndroidActivityWrapper.GetAndroidActivityWrapper().addActivityStateChangeListner(this.mActivityStateCB);
        } else {
            if (this.mActivityStateCB != null) {
                AndroidActivityWrapper.GetAndroidActivityWrapper().removeActivityStateChangeListner(this.mActivityStateCB);
            }
            this.mActivityStateCB = null;
        }
    }

    class PreviewSurfaceCallback implements SurfaceHolder.Callback {
        PreviewSurfaceCallback() {
        }

        @Override // android.view.SurfaceHolder.Callback
        public void surfaceChanged(SurfaceHolder surfaceHolder, int i, int i2, int i3) {
        }

        @Override // android.view.SurfaceHolder.Callback
        public void surfaceCreated(SurfaceHolder surfaceHolder) {
            AndroidCamera.this.mPreviewSurfaceValid = true;
            if (AndroidCamera.this.mClientId != 0 && AndroidCamera.this.mCallbacksRegistered) {
                AndroidCamera.this.nativeOnCanOpenCamera(AndroidCamera.this.mClientId);
            }
        }

        @Override // android.view.SurfaceHolder.Callback
        public void surfaceDestroyed(SurfaceHolder surfaceHolder) {
            AndroidCamera.this.mPreviewSurfaceValid = false;
            if (AndroidCamera.this.mClientId != 0 && AndroidCamera.this.mCallbacksRegistered) {
                AndroidCamera.this.nativeOnShouldCloseCamera(AndroidCamera.this.mClientId);
            }
        }
    }
}
