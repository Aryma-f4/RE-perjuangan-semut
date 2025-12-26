package com.adobe.fre;

/* loaded from: classes.dex */
public class FREObject {
    private long m_objectPointer;

    private native void FREObjectFromBoolean(boolean z) throws FREWrongThreadException;

    private native void FREObjectFromClass(String str, FREObject[] fREObjectArr) throws FREInvalidObjectException, FREASErrorException, FRENoSuchNameException, FREWrongThreadException, FRETypeMismatchException;

    private native void FREObjectFromDouble(double d) throws FREWrongThreadException;

    private native void FREObjectFromInt(int i) throws FREWrongThreadException;

    private native void FREObjectFromString(String str) throws FREWrongThreadException;

    public static native FREObject newObject(String str, FREObject[] fREObjectArr) throws IllegalStateException, FREInvalidObjectException, FREASErrorException, FRENoSuchNameException, FREWrongThreadException, FRETypeMismatchException;

    public native FREObject callMethod(String str, FREObject[] fREObjectArr) throws IllegalStateException, FREInvalidObjectException, FREASErrorException, FRENoSuchNameException, FREWrongThreadException, FRETypeMismatchException;

    public native boolean getAsBool() throws IllegalStateException, FREInvalidObjectException, FREWrongThreadException, FRETypeMismatchException;

    public native double getAsDouble() throws IllegalStateException, FREInvalidObjectException, FREWrongThreadException, FRETypeMismatchException;

    public native int getAsInt() throws IllegalStateException, FREInvalidObjectException, FREWrongThreadException, FRETypeMismatchException;

    public native String getAsString() throws IllegalStateException, FREInvalidObjectException, FREWrongThreadException, FRETypeMismatchException;

    public native FREObject getProperty(String str) throws IllegalStateException, FREInvalidObjectException, FREASErrorException, FRENoSuchNameException, FREWrongThreadException, FRETypeMismatchException;

    public native void setProperty(String str, FREObject fREObject) throws IllegalStateException, FREInvalidObjectException, FREASErrorException, FRENoSuchNameException, FREWrongThreadException, FREReadOnlyException, FRETypeMismatchException;

    protected static class CFREObjectWrapper {
        private long m_objectPointer;

        private CFREObjectWrapper(long obj) {
            this.m_objectPointer = obj;
        }
    }

    protected FREObject(CFREObjectWrapper obj) {
        this.m_objectPointer = obj.m_objectPointer;
    }

    protected FREObject(int value) throws FREWrongThreadException {
        FREObjectFromInt(value);
    }

    protected FREObject(double value) throws FREWrongThreadException {
        FREObjectFromDouble(value);
    }

    protected FREObject(boolean value) throws FREWrongThreadException {
        FREObjectFromBoolean(value);
    }

    protected FREObject(String value) throws FREWrongThreadException {
        FREObjectFromString(value);
    }

    public static FREObject newObject(int value) throws FREWrongThreadException {
        return new FREObject(value);
    }

    public static FREObject newObject(double value) throws FREWrongThreadException {
        return new FREObject(value);
    }

    public static FREObject newObject(boolean value) throws FREWrongThreadException {
        return new FREObject(value);
    }

    public static FREObject newObject(String value) throws FREWrongThreadException {
        return new FREObject(value);
    }

    public FREObject(String className, FREObject[] constructorArgs) throws IllegalStateException, FREInvalidObjectException, FREASErrorException, FRENoSuchNameException, FREWrongThreadException, FRETypeMismatchException {
        FREObjectFromClass(className, constructorArgs);
    }
}
