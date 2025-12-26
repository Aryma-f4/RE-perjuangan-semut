package com.adobe.fre;

import com.adobe.fre.FREObject;
import java.nio.ByteBuffer;

/* loaded from: classes.dex */
public class FREByteArray extends FREObject {
    private long m_dataPointer;

    public native void acquire() throws IllegalStateException, FREInvalidObjectException, FREWrongThreadException;

    public native ByteBuffer getBytes() throws IllegalStateException, FREInvalidObjectException, FREWrongThreadException;

    public native long getLength() throws IllegalStateException, FREInvalidObjectException, FREWrongThreadException;

    public native void release() throws IllegalStateException, FREInvalidObjectException, FREWrongThreadException;

    private FREByteArray(FREObject.CFREObjectWrapper obj) {
        super(obj);
    }

    protected FREByteArray() throws IllegalStateException, FREInvalidObjectException, FREASErrorException, FRENoSuchNameException, FREWrongThreadException, FRETypeMismatchException {
        super("flash.utils.ByteArray", null);
    }

    public static FREByteArray newByteArray() throws IllegalStateException, FREASErrorException, FREWrongThreadException {
        try {
            return new FREByteArray();
        } catch (FREInvalidObjectException | FRENoSuchNameException | FRETypeMismatchException e) {
            return null;
        }
    }
}
