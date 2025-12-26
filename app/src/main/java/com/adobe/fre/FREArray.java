package com.adobe.fre;

import com.adobe.fre.FREObject;

/* loaded from: classes.dex */
public class FREArray extends FREObject {
    public native long getLength() throws FREInvalidObjectException, FREWrongThreadException;

    public native FREObject getObjectAt(long j) throws FREInvalidObjectException, IllegalArgumentException, FREWrongThreadException;

    public native void setLength(long j) throws FREInvalidObjectException, IllegalArgumentException, FREWrongThreadException, FREReadOnlyException;

    public native void setObjectAt(long j, FREObject fREObject) throws FREInvalidObjectException, FREWrongThreadException, FRETypeMismatchException;

    private FREArray(FREObject.CFREObjectWrapper obj) {
        super(obj);
    }

    protected FREArray(String base, FREObject[] constructorArgs) throws FREInvalidObjectException, FREASErrorException, FRENoSuchNameException, FREWrongThreadException, FRETypeMismatchException {
        super("Vector.<" + base + ">", constructorArgs);
    }

    protected FREArray(FREObject[] constructorArgs) throws FREInvalidObjectException, FREASErrorException, FRENoSuchNameException, FREWrongThreadException, FRETypeMismatchException {
        super("Array", constructorArgs);
    }

    public static FREArray newArray(String classname, int numElements, boolean fixed) throws IllegalStateException, FREASErrorException, FRENoSuchNameException, FREWrongThreadException {
        FREObject[] args = {new FREObject(numElements), new FREObject(fixed)};
        try {
            return new FREArray(classname, args);
        } catch (FREInvalidObjectException | FRETypeMismatchException e) {
            return null;
        }
    }

    public static FREArray newArray(int numElements) throws IllegalStateException, FREASErrorException, FREWrongThreadException {
        FREObject[] args = {new FREObject(numElements)};
        try {
            return new FREArray(args);
        } catch (FREInvalidObjectException | FRENoSuchNameException | FRETypeMismatchException e) {
            return null;
        }
    }
}
