package com.adobe.air;

import android.content.Context;
import android.content.res.Configuration;
import android.hardware.input.InputManager;
import android.util.SparseArray;
import android.view.InputDevice;
import android.view.KeyEvent;
import android.view.MotionEvent;
import com.adobe.air.AndroidActivityWrapper;

/* loaded from: classes.dex */
public class AndroidInputManager implements InputManager.InputDeviceListener, AndroidActivityWrapper.StateChangeCallback, AndroidActivityWrapper.InputEventCallback {
    private static AndroidInputManager sAndroidInputManager = null;
    private Context mContext;
    private SparseArray<AndroidInputDevice> mInputDevices;
    private InputManager mInputManager;
    private long mInternalReference = 0;
    private boolean mListening = false;

    private native void OnDeviceAdded(long j, AndroidInputDevice androidInputDevice, String str);

    private native void OnDeviceRemoved(long j, String str);

    public static boolean isSupported() {
        try {
            return Class.forName("android.hardware.input.InputManager") != null;
        } catch (Exception e) {
            return false;
        }
    }

    public static AndroidInputManager GetAndroidInputManager(Context context) {
        if (isSupported() && sAndroidInputManager == null) {
            sAndroidInputManager = new AndroidInputManager(context);
        }
        return sAndroidInputManager;
    }

    private AndroidInputManager(Context context) {
        this.mContext = null;
        this.mInputManager = null;
        this.mInputDevices = null;
        this.mContext = context;
        if (this.mContext != null) {
            this.mInputManager = (InputManager) this.mContext.getSystemService("input");
        }
        AndroidActivityWrapper androidActivityWrapperGetAndroidActivityWrapper = AndroidActivityWrapper.GetAndroidActivityWrapper();
        if (androidActivityWrapperGetAndroidActivityWrapper != null) {
            androidActivityWrapperGetAndroidActivityWrapper.addActivityStateChangeListner(this);
            androidActivityWrapperGetAndroidActivityWrapper.addInputEventListner(this);
        }
        this.mInputDevices = new SparseArray<>();
    }

    public AndroidInputDevice getInputDevice(int i) {
        return this.mInputDevices.get(i);
    }

    public void setInternalReference(long j) {
        this.mInternalReference = j;
    }

    /* JADX WARN: Removed duplicated region for block: B:11:0x001a  */
    /*
        Code decompiled incorrectly, please refer to instructions dump.
        To view partially-correct code enable 'Show inconsistent code' option in preferences
    */
    public void listenForInputDevice(boolean r3) {
        /*
            r2 = this;
            android.hardware.input.InputManager r0 = r2.mInputManager
            if (r0 != 0) goto L5
        L4:
            return
        L5:
            if (r3 == 0) goto L1a
            boolean r0 = r2.mListening     // Catch: java.lang.Exception -> L18
            if (r0 != 0) goto L1a
            android.hardware.input.InputManager r0 = r2.mInputManager     // Catch: java.lang.Exception -> L18
            r1 = 0
            r0.registerInputDeviceListener(r2, r1)     // Catch: java.lang.Exception -> L18
            r2.addRemoveExistingInputDevices()     // Catch: java.lang.Exception -> L18
            r0 = 1
            r2.mListening = r0     // Catch: java.lang.Exception -> L18
            goto L4
        L18:
            r0 = move-exception
            goto L4
        L1a:
            if (r3 != 0) goto L4
            boolean r0 = r2.mListening     // Catch: java.lang.Exception -> L18
            if (r0 == 0) goto L4
            android.hardware.input.InputManager r0 = r2.mInputManager     // Catch: java.lang.Exception -> L18
            r0.unregisterInputDeviceListener(r2)     // Catch: java.lang.Exception -> L18
            r0 = 0
            r2.mListening = r0     // Catch: java.lang.Exception -> L18
            goto L4
        */
        throw new UnsupportedOperationException("Method not decompiled: com.adobe.air.AndroidInputManager.listenForInputDevice(boolean):void");
    }

    private void addRemoveExistingInputDevices() {
        int size = this.mInputDevices.size();
        for (int i = 0; i < size; i++) {
            int[] inputDeviceIds = this.mInputManager.getInputDeviceIds();
            int i2 = 0;
            while (i2 < inputDeviceIds.length && this.mInputDevices.keyAt(i) != inputDeviceIds[i2]) {
                i2++;
            }
            if (i2 == inputDeviceIds.length) {
                OnDeviceRemoved(this.mInternalReference, this.mInputDevices.valueAt(i).getUniqueId());
                this.mInputDevices.delete(this.mInputDevices.keyAt(i));
            }
        }
        for (int i3 : this.mInputManager.getInputDeviceIds()) {
            onInputDeviceAdded(i3);
        }
    }

    @Override // android.hardware.input.InputManager.InputDeviceListener
    public void onInputDeviceAdded(int i) {
        if (this.mInputDevices.get(i) == null) {
            InputDevice inputDevice = this.mInputManager.getInputDevice(i);
            if (!inputDevice.isVirtual() && (inputDevice.getSources() & 16) != 0 && (inputDevice.getSources() & 1) != 0) {
                AndroidInputDevice androidInputDevice = new AndroidInputDevice(inputDevice);
                this.mInputDevices.put(i, androidInputDevice);
                OnDeviceAdded(this.mInternalReference, androidInputDevice, androidInputDevice.getUniqueId());
            }
        }
    }

    @Override // android.hardware.input.InputManager.InputDeviceListener
    public void onInputDeviceRemoved(int i) {
        AndroidInputDevice androidInputDevice = this.mInputDevices.get(i);
        if (androidInputDevice != null) {
            OnDeviceRemoved(this.mInternalReference, androidInputDevice.getUniqueId());
            this.mInputDevices.delete(i);
        }
    }

    @Override // android.hardware.input.InputManager.InputDeviceListener
    public void onInputDeviceChanged(int i) {
        onInputDeviceRemoved(i);
        onInputDeviceAdded(i);
    }

    @Override // com.adobe.air.AndroidActivityWrapper.InputEventCallback
    public boolean onKeyEvent(KeyEvent keyEvent) {
        AndroidInputDevice androidInputDevice = this.mInputDevices.get(keyEvent.getDeviceId());
        if (androidInputDevice != null) {
            return androidInputDevice.onKeyEvent(keyEvent);
        }
        return false;
    }

    @Override // com.adobe.air.AndroidActivityWrapper.InputEventCallback
    public boolean onGenericMotionEvent(MotionEvent motionEvent) {
        AndroidInputDevice androidInputDevice;
        if ((motionEvent.getSource() & 16) == 0 || motionEvent.getAction() != 2 || (androidInputDevice = this.mInputDevices.get(motionEvent.getDeviceId())) == null) {
            return false;
        }
        return androidInputDevice.onGenericMotionEvent(motionEvent);
    }

    @Override // com.adobe.air.AndroidActivityWrapper.StateChangeCallback
    public void onActivityStateChanged(AndroidActivityWrapper.ActivityState activityState) {
        if (activityState == AndroidActivityWrapper.ActivityState.RESUMED) {
            listenForInputDevice(true);
        } else if (activityState == AndroidActivityWrapper.ActivityState.PAUSED) {
            listenForInputDevice(false);
        }
    }

    @Override // com.adobe.air.AndroidActivityWrapper.StateChangeCallback
    public void onConfigurationChanged(Configuration configuration) {
    }
}
