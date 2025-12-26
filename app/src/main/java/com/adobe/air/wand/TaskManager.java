package com.adobe.air.wand;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Build;
import android.os.SystemClock;
import android.os.Vibrator;
import android.util.Base64;
import android.view.Display;
import com.adobe.air.TouchEventData;
import com.adobe.air.wand.message.Message;
import com.adobe.air.wand.message.MessageDataArray;
import com.adobe.air.wand.message.MessageDataObject;
import com.adobe.air.wand.message.MessageManager;
import com.adobe.air.wand.message.Notification;
import com.adobe.air.wand.message.Request;
import com.adobe.air.wand.message.Response;
import com.adobe.air.wand.motionsensor.Accelerometer;
import com.adobe.air.wand.motionsensor.Gyroscope;
import com.adobe.air.wand.motionsensor.Magnetometer;
import com.adobe.air.wand.motionsensor.MotionSensor;
import com.adobe.air.wand.view.GestureEventData;
import com.adobe.air.wand.view.TouchSensor;
import com.adobe.air.wand.view.WandView;
import java.util.ArrayList;
import java.util.Date;

/* loaded from: classes.dex */
public class TaskManager {
    protected static final String GESTURE_PHASE_ALL = "ALL";
    protected static final String GESTURE_PHASE_BEGIN = "BEGIN";
    protected static final String GESTURE_PHASE_END = "END";
    protected static final String GESTURE_PHASE_UPDATE = "UPDATE";
    protected static final String GESTURE_TYPE_PAN = "GESTURE_PAN";
    protected static final String GESTURE_TYPE_ROTATE = "GESTURE_ROTATE";
    protected static final String GESTURE_TYPE_SWIPE = "GESTURE_SWIPE";
    protected static final String GESTURE_TYPE_TWO_FINGER_TAP = "GESTURE_TWO_FINGER_TAP";
    protected static final String GESTURE_TYPE_ZOOM = "GESTURE_ZOOM";
    private static final String LOG_TAG = "TaskManager";
    protected static final int MOTION_SENSOR_MINIMUM_INTERVAL = 16;
    protected static final String NAME_NOTIFICATION_ACCELEROMETER = "accelerometer";
    protected static final String NAME_NOTIFICATION_ACCELEROMETER_DATA = "acc";
    protected static final String NAME_NOTIFICATION_DURATION = "duration";
    protected static final String NAME_NOTIFICATION_GYROSCOPE = "gyroscope";
    protected static final String NAME_NOTIFICATION_GYROSCOPE_DATA = "gyro";
    protected static final String NAME_NOTIFICATION_INTERVAL = "interval";
    protected static final String NAME_NOTIFICATION_IS_PRIMARY_TOUCH_POINT = "isPrimaryTouchPoint";
    protected static final String NAME_NOTIFICATION_IS_TRANSFORM = "isTransform";
    protected static final String NAME_NOTIFICATION_LOCAL_X = "localX";
    protected static final String NAME_NOTIFICATION_LOCAL_Y = "localY";
    protected static final String NAME_NOTIFICATION_MAGNETOMETER = "magnetometer";
    protected static final String NAME_NOTIFICATION_MAGNETOMETER_DATA = "mag";
    protected static final String NAME_NOTIFICATION_MESSAGE = "message";
    protected static final String NAME_NOTIFICATION_OFFSET_X = "offsetX";
    protected static final String NAME_NOTIFICATION_OFFSET_Y = "offsetY";
    protected static final String NAME_NOTIFICATION_PHASE = "phase";
    protected static final String NAME_NOTIFICATION_PRESSURE = "pressure";
    protected static final String NAME_NOTIFICATION_ROTATION = "rotation";
    protected static final String NAME_NOTIFICATION_SCALE_X = "scaleX";
    protected static final String NAME_NOTIFICATION_SCALE_Y = "scaleY";
    protected static final String NAME_NOTIFICATION_SCREEN_DIMENSIONS = "screenDimensions";
    protected static final String NAME_NOTIFICATION_SIZE_X = "sizeX";
    protected static final String NAME_NOTIFICATION_SIZE_Y = "sizeY";
    protected static final String NAME_NOTIFICATION_START = "start";
    protected static final String NAME_NOTIFICATION_TIMESTAMP = "timestamp";
    protected static final String NAME_NOTIFICATION_TOUCH_POINT_ID = "touchPointID";
    protected static final String NAME_NOTIFICATION_TYPE = "type";
    protected static final String NAME_NOTIFICATION_VIBRATOR = "vibrator";
    protected static final String SCREEN_DIMENSIONS_HEIGHT = "height";
    protected static final String SCREEN_DIMENSIONS_WIDTH = "width";
    protected static final String TOUCH_TYPE_BEGIN = "TOUCH_BEGIN";
    protected static final String TOUCH_TYPE_END = "TOUCH_END";
    protected static final String TOUCH_TYPE_MOVE = "TOUCH_MOVE";
    private final Accelerometer mAccelerometer;
    private final Display mDisplay;
    private final Gyroscope mGyroscope;
    private Listener mListener = null;
    private final Magnetometer mMagnetometer;
    private final MessageManager mMessageManager;
    private final TouchSensor mTouchSensor;
    private final Vibrator mVibrator;

    public interface Listener {
        void drawImage(Bitmap bitmap) throws Exception;

        String getRequestedProtocolVerison() throws Exception;

        void sendConnectionMessage(String str) throws Exception;

        void setScreenOrientation(WandView.ScreenOrientation screenOrientation) throws Exception;
    }

    public enum MessageTitle {
        ACCELEROMETER_EVENT("ACCELEROMETER_EVENT"),
        MAGNETOMETER_EVENT("MAGNETOMETER_EVENT"),
        GYROSCOPE_EVENT("GYROSCOPE_EVENT"),
        TOUCH_EVENT("TOUCH_EVENT"),
        GESTURE_EVENT("GESTURE_EVENT"),
        VIBRATE("VIBRATE"),
        DRAW_IMAGE("DRAW_IMAGE"),
        HARDWARE_SPECIFICATIONS("HARDWARE_SPECIFICATIONS"),
        ERROR_LOG("ERROR_LOG");

        private final String mTitle;

        MessageTitle(String str) {
            this.mTitle = str;
        }

        @Override // java.lang.Enum
        public String toString() {
            return this.mTitle;
        }
    }

    public TaskManager(MessageManager messageManager, Display display, TouchSensor touchSensor, Accelerometer accelerometer, Magnetometer magnetometer, Gyroscope gyroscope, Vibrator vibrator) throws Exception {
        if (messageManager == null) {
            throw new Exception("Invalid MessageManager");
        }
        this.mMessageManager = messageManager;
        if (accelerometer == null) {
            throw new Exception("Invalid Accelerometer");
        }
        this.mAccelerometer = accelerometer;
        if (magnetometer == null) {
            throw new Exception("Invalid Magnetometer");
        }
        this.mMagnetometer = magnetometer;
        if (gyroscope == null) {
            throw new Exception("Invalid Gyroscope");
        }
        this.mGyroscope = gyroscope;
        this.mVibrator = vibrator;
        if (display == null) {
            throw new Exception("Invalid Display");
        }
        this.mDisplay = display;
        if (touchSensor == null) {
            throw new Exception("Invalid TouchSensor");
        }
        this.mTouchSensor = touchSensor;
        this.mTouchSensor.setListener(new TouchSensor.Listener() { // from class: com.adobe.air.wand.TaskManager.1
            @Override // com.adobe.air.wand.view.TouchSensor.Listener
            public void onTouchEvent(TouchEventData touchEventData) {
                TaskManager.this.sendTouchEventData(touchEventData);
            }

            @Override // com.adobe.air.wand.view.TouchSensor.Listener
            public void onGestureEvent(GestureEventData gestureEventData) {
                TaskManager.this.sendGestureEventData(gestureEventData);
            }
        });
        this.mAccelerometer.setListener(new MotionSensor.Listener() { // from class: com.adobe.air.wand.TaskManager.2
            @Override // com.adobe.air.wand.motionsensor.MotionSensor.Listener
            public void onSensorChanged(float[] fArr, long j) {
                TaskManager.this.sendMotionSensorData(fArr, j, TaskManager.NAME_NOTIFICATION_ACCELEROMETER_DATA, MessageTitle.ACCELEROMETER_EVENT);
            }
        });
        this.mMagnetometer.setListener(new MotionSensor.Listener() { // from class: com.adobe.air.wand.TaskManager.3
            @Override // com.adobe.air.wand.motionsensor.MotionSensor.Listener
            public void onSensorChanged(float[] fArr, long j) {
                TaskManager.this.sendMotionSensorData(fArr, j, TaskManager.NAME_NOTIFICATION_MAGNETOMETER_DATA, MessageTitle.MAGNETOMETER_EVENT);
            }
        });
        this.mGyroscope.setListener(new MotionSensor.Listener() { // from class: com.adobe.air.wand.TaskManager.4
            @Override // com.adobe.air.wand.motionsensor.MotionSensor.Listener
            public void onSensorChanged(float[] fArr, long j) {
                TaskManager.this.sendMotionSensorData(fArr, j, TaskManager.NAME_NOTIFICATION_GYROSCOPE_DATA, MessageTitle.GYROSCOPE_EVENT);
            }
        });
    }

    private String[] getGesturePhases(int i) {
        ArrayList arrayList = new ArrayList();
        if ((i & 2) != 0) {
            arrayList.add(GESTURE_PHASE_BEGIN);
        }
        if ((i & 1) != 0) {
            arrayList.add(GESTURE_PHASE_UPDATE);
        }
        if ((i & 4) != 0) {
            arrayList.add(GESTURE_PHASE_END);
        }
        if ((i & 8) != 0) {
            arrayList.add(GESTURE_PHASE_ALL);
        }
        return (String[]) arrayList.toArray(new String[0]);
    }

    /* JADX INFO: Access modifiers changed from: private */
    public void sendGestureEventData(GestureEventData gestureEventData) {
        for (String str : getGesturePhases(gestureEventData.mPhase)) {
            try {
                MessageDataObject messageDataObjectCreateDataObject = this.mMessageManager.createDataObject();
                messageDataObjectCreateDataObject.put(NAME_NOTIFICATION_PHASE, str);
                switch (gestureEventData.mType) {
                    case 0:
                        messageDataObjectCreateDataObject.put("type", GESTURE_TYPE_ZOOM);
                        break;
                    case 1:
                        messageDataObjectCreateDataObject.put("type", GESTURE_TYPE_PAN);
                        break;
                    case 2:
                        messageDataObjectCreateDataObject.put("type", GESTURE_TYPE_ROTATE);
                        break;
                    case 3:
                        messageDataObjectCreateDataObject.put("type", GESTURE_TYPE_TWO_FINGER_TAP);
                        break;
                    case 4:
                        messageDataObjectCreateDataObject.put("type", GESTURE_TYPE_SWIPE);
                        break;
                }
                messageDataObjectCreateDataObject.put(NAME_NOTIFICATION_IS_TRANSFORM, gestureEventData.mIsTransform);
                messageDataObjectCreateDataObject.put(NAME_NOTIFICATION_LOCAL_X, gestureEventData.mXCoord);
                messageDataObjectCreateDataObject.put(NAME_NOTIFICATION_LOCAL_Y, gestureEventData.mYCoord);
                messageDataObjectCreateDataObject.put(NAME_NOTIFICATION_SCALE_X, gestureEventData.mScaleX);
                messageDataObjectCreateDataObject.put(NAME_NOTIFICATION_SCALE_Y, gestureEventData.mScaleY);
                messageDataObjectCreateDataObject.put(NAME_NOTIFICATION_ROTATION, gestureEventData.mRotation);
                messageDataObjectCreateDataObject.put(NAME_NOTIFICATION_OFFSET_X, gestureEventData.mOffsetX);
                messageDataObjectCreateDataObject.put(NAME_NOTIFICATION_OFFSET_Y, gestureEventData.mOffsetY);
                messageDataObjectCreateDataObject.put(NAME_NOTIFICATION_TIMESTAMP, new Date().getTime());
                String strCreateSerializedNotification = this.mMessageManager.createSerializedNotification(MessageTitle.GESTURE_EVENT.toString(), messageDataObjectCreateDataObject);
                if (this.mListener != null) {
                    this.mListener.sendConnectionMessage(strCreateSerializedNotification);
                }
            } catch (Exception e) {
            }
        }
    }

    private String[] getTouchTypes(int i) {
        ArrayList arrayList = new ArrayList();
        if ((i & 2) != 0) {
            arrayList.add(TOUCH_TYPE_BEGIN);
        }
        if ((i & 1) != 0) {
            arrayList.add(TOUCH_TYPE_MOVE);
        }
        if ((i & 4) != 0) {
            arrayList.add(TOUCH_TYPE_END);
        }
        return (String[]) arrayList.toArray(new String[0]);
    }

    /* JADX INFO: Access modifiers changed from: private */
    public void sendTouchEventData(TouchEventData touchEventData) {
        for (String str : getTouchTypes(touchEventData.mTouchEventType)) {
            try {
                MessageDataObject messageDataObjectCreateDataObject = this.mMessageManager.createDataObject();
                messageDataObjectCreateDataObject.put("type", str);
                messageDataObjectCreateDataObject.put(NAME_NOTIFICATION_IS_PRIMARY_TOUCH_POINT, touchEventData.mIsPrimaryPoint);
                messageDataObjectCreateDataObject.put(NAME_NOTIFICATION_LOCAL_X, touchEventData.mXCoord);
                messageDataObjectCreateDataObject.put(NAME_NOTIFICATION_LOCAL_Y, touchEventData.mYCoord);
                messageDataObjectCreateDataObject.put(NAME_NOTIFICATION_PRESSURE, touchEventData.mPressure);
                messageDataObjectCreateDataObject.put(NAME_NOTIFICATION_SIZE_X, touchEventData.mContactX);
                messageDataObjectCreateDataObject.put(NAME_NOTIFICATION_SIZE_Y, touchEventData.mContactY);
                messageDataObjectCreateDataObject.put(NAME_NOTIFICATION_TOUCH_POINT_ID, touchEventData.mPointerID);
                messageDataObjectCreateDataObject.put(NAME_NOTIFICATION_TIMESTAMP, new Date().getTime());
                String strCreateSerializedNotification = this.mMessageManager.createSerializedNotification(MessageTitle.TOUCH_EVENT.toString(), messageDataObjectCreateDataObject);
                if (this.mListener != null) {
                    this.mListener.sendConnectionMessage(strCreateSerializedNotification);
                }
            } catch (Exception e) {
            }
        }
    }

    /* JADX INFO: Access modifiers changed from: private */
    public void sendMotionSensorData(float[] fArr, long j, String str, MessageTitle messageTitle) {
        try {
            MessageDataObject messageDataObjectCreateDataObject = this.mMessageManager.createDataObject();
            long jCurrentTimeMillis = System.currentTimeMillis() - SystemClock.uptimeMillis();
            MessageDataArray messageDataArrayCreateDataArray = this.mMessageManager.createDataArray();
            int i = 0;
            while (i < fArr.length) {
                messageDataArrayCreateDataArray.put(i, fArr[i]);
                i++;
            }
            messageDataArrayCreateDataArray.put(i, jCurrentTimeMillis + (j / 1000000));
            messageDataObjectCreateDataObject.put(str, messageDataArrayCreateDataArray);
            String strCreateSerializedNotification = this.mMessageManager.createSerializedNotification(messageTitle.toString(), messageDataObjectCreateDataObject);
            if (this.mListener != null) {
                this.mListener.sendConnectionMessage(strCreateSerializedNotification);
            }
        } catch (Exception e) {
        }
    }

    public void registerListener(Listener listener) throws Exception {
        if (listener == null) {
            throw new Exception("Invalid listener");
        }
        if (this.mListener != null) {
            throw new Exception("A listener is already registered");
        }
        this.mListener = listener;
    }

    public void unregisterListener() {
        this.mListener = null;
    }

    private void sendLogNotification(String str) {
        if (str != null && !str.equals("")) {
            MessageDataObject messageDataObjectCreateDataObject = this.mMessageManager.createDataObject();
            try {
                messageDataObjectCreateDataObject.put("message", str);
                String strCreateSerializedNotification = this.mMessageManager.createSerializedNotification(MessageTitle.ERROR_LOG.toString(), messageDataObjectCreateDataObject);
                if (this.mListener != null) {
                    this.mListener.sendConnectionMessage(strCreateSerializedNotification);
                }
            } catch (Exception e) {
            }
        }
    }

    public void handleRemoteMessage(String str) {
        try {
            Message messageDeserializeWandMessage = this.mMessageManager.deserializeWandMessage(str);
            switch (messageDeserializeWandMessage.getHeader().getType()) {
                case REQUEST:
                    handleRemoteRequest((Request) messageDeserializeWandMessage);
                    break;
                case RESPONSE:
                    handleRemoteResponse((Response) messageDeserializeWandMessage);
                    break;
                case NOTIFICATION:
                    handleRemoteNotification((Notification) messageDeserializeWandMessage);
                    break;
            }
        } catch (Exception e) {
            sendLogNotification("Invalid message : \"" + (str == null ? "null" : str) + "\"");
        }
    }

    private void handleRemoteRequest(Request request) throws Exception {
        String title = request.getHeader().getTitle();
        if (title.equals(MessageTitle.DRAW_IMAGE.toString())) {
            handleDrawImageRequest(request);
        } else if (title.equals(MessageTitle.HARDWARE_SPECIFICATIONS.toString())) {
            handleHardwareSpecsRequest(request);
        } else {
            sendLogNotification("Unsupported REQUEST title : " + title);
        }
    }

    private void handleRemoteResponse(Response response) {
        sendLogNotification("Unsupported RESPONSE title : " + response.getHeader().getTitle());
    }

    private boolean isOrAboveV1_1_0() throws Exception {
        return this.mListener != null && Version.isGreaterThanEqualTo(this.mListener.getRequestedProtocolVerison(), "1.1.0");
    }

    private void handleRemoteNotification(Notification notification) throws Exception {
        String title = notification.getHeader().getTitle();
        if (title.equals(MessageTitle.VIBRATE.toString())) {
            handleRemoteVibrateNotification(notification);
            return;
        }
        if (title.equals(MessageTitle.ACCELEROMETER_EVENT.toString())) {
            handleRemoteAccelerometerEventNotification(notification);
            return;
        }
        if (isOrAboveV1_1_0() && title.equals(MessageTitle.MAGNETOMETER_EVENT.toString())) {
            handleRemoteMagnetometerEventNotification(notification);
            return;
        }
        if (isOrAboveV1_1_0() && title.equals(MessageTitle.GYROSCOPE_EVENT.toString())) {
            handleRemoteGyroscopeEventNotification(notification);
            return;
        }
        if (title.equals(MessageTitle.TOUCH_EVENT.toString())) {
            handleRemoteTouchNotification(notification);
        } else if (title.equals(MessageTitle.GESTURE_EVENT.toString())) {
            handleRemoteGestureNotification(notification);
        } else {
            sendLogNotification("Unsupported NOTIFICATION title : " + title);
        }
    }

    void terminateRunningTasks() {
        if (this.mAccelerometer.active()) {
            this.mAccelerometer.stop();
        }
        if (this.mMagnetometer.active()) {
            this.mMagnetometer.stop();
        }
        if (this.mGyroscope.active()) {
            this.mGyroscope.stop();
        }
        if (this.mTouchSensor.activeTouchListening()) {
            this.mTouchSensor.stopTouchEventListening();
        }
        if (this.mTouchSensor.activeGestureListening()) {
            this.mTouchSensor.stopGestureEventListening();
        }
        if (this.mVibrator != null) {
            this.mVibrator.cancel();
        }
    }

    private void handleRemoteAccelerometerEventNotification(Notification notification) {
        try {
            if (!this.mAccelerometer.available()) {
                sendLogNotification("The device does not have an accelerometer");
            } else {
                MessageDataObject messageDataObject = (MessageDataObject) notification.getData().getNotification();
                if (messageDataObject.getBoolean(NAME_NOTIFICATION_START)) {
                    if (!this.mAccelerometer.active()) {
                        int i = messageDataObject.getInt(NAME_NOTIFICATION_INTERVAL);
                        if (i < 16) {
                            i = 16;
                        }
                        this.mAccelerometer.start(i);
                    } else {
                        sendLogNotification("Already started accelerometer event updates");
                    }
                } else if (this.mAccelerometer.active()) {
                    this.mAccelerometer.stop();
                } else {
                    sendLogNotification("Already stopped accelerometer event updates");
                }
            }
        } catch (Exception e) {
            sendLogNotification("Invalid ACCELEROMETER_EVENT notification");
        }
    }

    private void handleRemoteMagnetometerEventNotification(Notification notification) {
        try {
            if (!this.mMagnetometer.available()) {
                sendLogNotification("The device does not have an magnetometer");
            } else {
                MessageDataObject messageDataObject = (MessageDataObject) notification.getData().getNotification();
                if (messageDataObject.getBoolean(NAME_NOTIFICATION_START)) {
                    if (!this.mMagnetometer.active()) {
                        int i = messageDataObject.getInt(NAME_NOTIFICATION_INTERVAL);
                        if (i < 16) {
                            i = 16;
                        }
                        this.mMagnetometer.start(i);
                    } else {
                        sendLogNotification("Already started magnetometer event updates");
                    }
                } else if (this.mMagnetometer.active()) {
                    this.mMagnetometer.stop();
                } else {
                    sendLogNotification("Already stopped magnetometer event updates");
                }
            }
        } catch (Exception e) {
            sendLogNotification("Invalid MAGNETOMETER_EVENT notification");
        }
    }

    private void handleRemoteGyroscopeEventNotification(Notification notification) {
        try {
            if (!this.mGyroscope.available()) {
                sendLogNotification("The device does not have a gyroscope");
            } else {
                MessageDataObject messageDataObject = (MessageDataObject) notification.getData().getNotification();
                if (messageDataObject.getBoolean(NAME_NOTIFICATION_START)) {
                    if (!this.mGyroscope.active()) {
                        int i = messageDataObject.getInt(NAME_NOTIFICATION_INTERVAL);
                        if (i < 16) {
                            i = 16;
                        }
                        this.mGyroscope.start(i);
                    } else {
                        sendLogNotification("Already started gyroscope event updates");
                    }
                } else if (this.mGyroscope.active()) {
                    this.mGyroscope.stop();
                } else {
                    sendLogNotification("Already stopped gyroscope event updates");
                }
            }
        } catch (Exception e) {
            sendLogNotification("Invalid GYROSCOPE_EVENT notification");
        }
    }

    private void handleRemoteTouchNotification(Notification notification) {
        try {
            if (((MessageDataObject) notification.getData().getNotification()).getBoolean(NAME_NOTIFICATION_START)) {
                if (!this.mTouchSensor.activeTouchListening()) {
                    this.mTouchSensor.startTouchEventListening();
                } else {
                    sendLogNotification("Already started touch event updates");
                }
            } else if (this.mTouchSensor.activeTouchListening()) {
                this.mTouchSensor.stopTouchEventListening();
            } else {
                sendLogNotification("Already stopped touch event updates");
            }
        } catch (Exception e) {
            sendLogNotification("Invalid TOUCH_EVENT notification");
        }
    }

    private void handleRemoteGestureNotification(Notification notification) {
        try {
            if (((MessageDataObject) notification.getData().getNotification()).getBoolean(NAME_NOTIFICATION_START)) {
                if (!this.mTouchSensor.activeGestureListening()) {
                    this.mTouchSensor.startGestureEventListening();
                } else {
                    sendLogNotification("Already started gesture event updates");
                }
            } else if (this.mTouchSensor.activeGestureListening()) {
                this.mTouchSensor.stopGestureEventListening();
            } else {
                sendLogNotification("Already stopped gesture event updates");
            }
        } catch (Exception e) {
            sendLogNotification("Invalid GESTURE_EVENT notification");
        }
    }

    private boolean hasVibrator() {
        return (this.mVibrator == null || Build.VERSION.SDK_INT < 14) ? this.mVibrator != null : this.mVibrator.hasVibrator();
    }

    private void handleHardwareSpecsRequest(Request request) {
        try {
            MessageDataObject messageDataObjectCreateDataObject = this.mMessageManager.createDataObject();
            boolean zAvailable = this.mAccelerometer.available();
            boolean zAvailable2 = this.mMagnetometer.available();
            boolean zAvailable3 = this.mGyroscope.available();
            Display display = this.mDisplay;
            MessageDataObject messageDataObjectCreateDataObject2 = this.mMessageManager.createDataObject();
            int width = display.getWidth();
            int height = display.getHeight();
            messageDataObjectCreateDataObject2.put(SCREEN_DIMENSIONS_WIDTH, width);
            messageDataObjectCreateDataObject2.put(SCREEN_DIMENSIONS_HEIGHT, height);
            messageDataObjectCreateDataObject.put(NAME_NOTIFICATION_SCREEN_DIMENSIONS, messageDataObjectCreateDataObject2);
            messageDataObjectCreateDataObject.put(NAME_NOTIFICATION_ACCELEROMETER, zAvailable);
            messageDataObjectCreateDataObject.put(NAME_NOTIFICATION_VIBRATOR, hasVibrator());
            if (isOrAboveV1_1_0()) {
                messageDataObjectCreateDataObject.put(NAME_NOTIFICATION_MAGNETOMETER, zAvailable2);
                messageDataObjectCreateDataObject.put(NAME_NOTIFICATION_GYROSCOPE, zAvailable3);
            }
            String strCreateSerializedResponse = this.mMessageManager.createSerializedResponse(request, Response.Status.SUCCESS, messageDataObjectCreateDataObject);
            if (this.mListener != null) {
                this.mListener.sendConnectionMessage(strCreateSerializedResponse);
            }
        } catch (Exception e) {
            try {
                String strCreateSerializedErrorResponse = this.mMessageManager.createSerializedErrorResponse(request, e.getMessage());
                if (this.mListener != null) {
                    this.mListener.sendConnectionMessage(strCreateSerializedErrorResponse);
                }
            } catch (Exception e2) {
                sendLogNotification("Invalid HARDWARE_SPECIFICATIONS request");
            }
        }
    }

    private void handleRemoteVibrateNotification(Notification notification) {
        try {
            long j = ((MessageDataObject) notification.getData().getNotification()).getLong(NAME_NOTIFICATION_DURATION);
            if (j <= 0) {
                sendLogNotification("Invalid vibrate duration.");
            } else if (hasVibrator()) {
                this.mVibrator.vibrate(j);
            } else {
                sendLogNotification("Device does not support vibration");
            }
        } catch (Exception e) {
            sendLogNotification("Invalid VIBRATE notification");
        }
    }

    private void handleDrawImageRequest(Request request) throws Exception {
        try {
            byte[] bArrDecode = Base64.decode(request.getData().getArguments().getString(0), 0);
            if (bArrDecode.length < 4 || bArrDecode[0] != -1 || bArrDecode[1] != -40 || bArrDecode[2] != -1) {
                throw new Exception("Unsupported image format");
            }
            Bitmap bitmapDecodeByteArray = BitmapFactory.decodeByteArray(bArrDecode, 0, bArrDecode.length);
            if (bitmapDecodeByteArray == null) {
                throw new Exception("Unable to decode the image");
            }
            if (this.mListener != null) {
                this.mListener.drawImage(bitmapDecodeByteArray);
            }
            String strCreateSerializedSuccessResponse = this.mMessageManager.createSerializedSuccessResponse(request);
            if (this.mListener != null) {
                this.mListener.sendConnectionMessage(strCreateSerializedSuccessResponse);
            }
        } catch (Exception e) {
            try {
                String strCreateSerializedErrorResponse = this.mMessageManager.createSerializedErrorResponse(request, e.getMessage());
                if (this.mListener != null) {
                    this.mListener.sendConnectionMessage(strCreateSerializedErrorResponse);
                }
            } catch (Exception e2) {
                sendLogNotification("Invalid DRAW_IMAGE request");
            }
        }
    }
}
