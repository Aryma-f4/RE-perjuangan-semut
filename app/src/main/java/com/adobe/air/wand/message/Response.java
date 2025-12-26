package com.adobe.air.wand.message;

import com.adobe.air.wand.message.Message;

/* loaded from: classes.dex */
public class Response extends Message {

    public enum Status {
        SUCCESS("SUCCESS"),
        ERROR("ERROR");

        private final String mStatus;

        Status(String str) {
            this.mStatus = str;
        }

        @Override // java.lang.Enum
        public String toString() {
            return this.mStatus;
        }
    }

    public static class Header extends Message.Header {
        protected Status mStatus;
        protected String mTaskID;

        public Header(String str, String str2, long j, Status status) {
            super(str, Message.Type.RESPONSE, j);
            this.mStatus = null;
            this.mTaskID = "";
            this.mStatus = status;
            this.mTaskID = str2;
        }

        public Status getStatus() {
            return this.mStatus;
        }

        public void setStatus(Status status) {
            this.mStatus = status;
        }

        public String getTaskID() {
            return this.mTaskID;
        }

        public void setTaskID(String str) {
            this.mTaskID = str;
        }
    }

    public static class Data extends Message.Data {
        protected MessageDataObject mResult = null;

        public Data(MessageDataObject messageDataObject) {
            setResult(messageDataObject);
        }

        public Object getResult() {
            return this.mResult;
        }

        public void setResult(MessageDataObject messageDataObject) {
            this.mResult = messageDataObject;
        }
    }

    public Response(Header header, Data data) {
        super(header, data);
    }

    @Override // com.adobe.air.wand.message.Message
    public Header getHeader() {
        return (Header) this.mHeader;
    }

    @Override // com.adobe.air.wand.message.Message
    public Data getData() {
        return (Data) this.mData;
    }
}
