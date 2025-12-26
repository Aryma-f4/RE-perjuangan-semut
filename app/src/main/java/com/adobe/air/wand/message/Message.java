package com.adobe.air.wand.message;

/* loaded from: classes.dex */
public abstract class Message {
    protected final Data mData;
    protected final Header mHeader;

    public static abstract class Data {
    }

    public enum Type {
        REQUEST("REQUEST"),
        RESPONSE("RESPONSE"),
        NOTIFICATION("NOTIFICATION");

        private final String mType;

        Type(String str) {
            this.mType = str;
        }

        @Override // java.lang.Enum
        public String toString() {
            return this.mType;
        }
    }

    public static abstract class Header {
        protected long mTimestamp;
        protected String mTitle;
        protected Type mType;

        public Header(String str, Type type, long j) {
            this.mTitle = null;
            this.mType = null;
            this.mTimestamp = 0L;
            this.mTitle = str;
            this.mType = type;
            this.mTimestamp = j;
        }

        public String getTitle() {
            return this.mTitle;
        }

        public Type getType() {
            return this.mType;
        }

        public long getTimestamp() {
            return this.mTimestamp;
        }

        public void setTitle(String str) {
            this.mTitle = str;
        }

        public void setType(Type type) {
            this.mType = type;
        }

        public void setTimestamp(long j) {
            this.mTimestamp = j;
        }
    }

    public Header getHeader() {
        return this.mHeader;
    }

    public Data getData() {
        return this.mData;
    }

    public Message(Header header, Data data) {
        this.mHeader = header;
        this.mData = data;
    }
}
