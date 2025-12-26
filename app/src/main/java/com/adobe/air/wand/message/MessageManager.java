package com.adobe.air.wand.message;

import com.adobe.air.wand.message.Response;

/* loaded from: classes.dex */
public abstract class MessageManager {
    protected static final String NAME_ARGUMENTS = "arguments";
    protected static final String NAME_DATA = "data";
    public static final String NAME_ERROR_MESSAGE = "message";
    protected static final String NAME_HEADER = "header";
    protected static final String NAME_NOTIFICATION = "notification";
    protected static final String NAME_RESULT = "result";
    protected static final String NAME_STATUS = "status";
    protected static final String NAME_TASK_ID = "taskID";
    protected static final String NAME_TIMESTAMP = "timestamp";
    protected static final String NAME_TITLE = "title";
    protected static final String NAME_TYPE = "type";

    public abstract MessageDataArray createDataArray();

    public abstract MessageDataObject createDataObject();

    public abstract Notification createWandNotification(String str, MessageDataObject messageDataObject) throws Exception;

    public abstract Request createWandRequest(String str, String str2, MessageDataArray messageDataArray) throws Exception;

    public abstract Response createWandResponse(String str, String str2, MessageDataObject messageDataObject, Response.Status status) throws Exception;

    public abstract Message deserializeWandMessage(String str) throws Exception;

    public abstract String serializeMessage(Message message) throws Exception;

    public Response createWandResponse(Request request, Response.Status status, MessageDataObject messageDataObject) throws Exception {
        return createWandResponse(request.getHeader().getTitle(), request.getHeader().getTaskID(), messageDataObject, status);
    }

    public String createSerializedResponse(String str, String str2, MessageDataObject messageDataObject, Response.Status status) throws Exception {
        return serializeMessage(createWandResponse(str, str2, messageDataObject, status));
    }

    public String createSerializedResponse(Request request, Response.Status status, MessageDataObject messageDataObject) throws Exception {
        return serializeMessage(createWandResponse(request, status, messageDataObject));
    }

    public String createSerializedNotification(String str, MessageDataObject messageDataObject) throws Exception {
        return serializeMessage(createWandNotification(str, messageDataObject));
    }

    public String createSerializedSuccessResponse(String str, String str2, MessageDataObject messageDataObject) throws Exception {
        return serializeMessage(createWandResponse(str, str2, messageDataObject, Response.Status.SUCCESS));
    }

    public String createSerializedErrorResponse(String str, String str2, String str3) throws Exception {
        MessageDataObject messageDataObjectCreateDataObject = createDataObject();
        messageDataObjectCreateDataObject.put(NAME_ERROR_MESSAGE, str3);
        return serializeMessage(createWandResponse(str, str2, messageDataObjectCreateDataObject, Response.Status.ERROR));
    }

    public String createSerializedSuccessResponse(Request request) throws Exception {
        return serializeMessage(createWandResponse(request, Response.Status.SUCCESS, null));
    }

    public String createSerializedErrorResponse(Request request, String str) throws Exception {
        MessageDataObject messageDataObjectCreateDataObject = createDataObject();
        messageDataObjectCreateDataObject.put(NAME_ERROR_MESSAGE, str);
        return serializeMessage(createWandResponse(request, Response.Status.ERROR, messageDataObjectCreateDataObject));
    }

    public String createSerializedRequest(String str, String str2, MessageDataArray messageDataArray) throws Exception {
        return serializeMessage(createWandRequest(str, str2, messageDataArray));
    }
}
