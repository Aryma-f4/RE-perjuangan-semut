package com.adobe.fre;

import com.adobe.fre.FREObject;
import java.nio.ByteBuffer;

/* loaded from: classes.dex */
public class FREBitmapData extends FREObject {
    private long m_dataPointer;

    public native void acquire() throws IllegalStateException, FREInvalidObjectException, FREWrongThreadException;

    public native ByteBuffer getBits() throws IllegalStateException, FREInvalidObjectException, FREWrongThreadException;

    public native int getHeight() throws IllegalStateException, FREInvalidObjectException, FREWrongThreadException;

    public native int getLineStride32() throws IllegalStateException, FREInvalidObjectException, FREWrongThreadException;

    public native int getWidth() throws IllegalStateException, FREInvalidObjectException, FREWrongThreadException;

    public native boolean hasAlpha() throws IllegalStateException, FREInvalidObjectException, FREWrongThreadException;

    public native void invalidateRect(int i, int i2, int i3, int i4) throws IllegalStateException, FREInvalidObjectException, FREWrongThreadException, IllegalArgumentException;

    public native boolean isInvertedY() throws IllegalStateException, FREInvalidObjectException, FREWrongThreadException;

    public native boolean isPremultiplied() throws IllegalStateException, FREInvalidObjectException, FREWrongThreadException;

    public native void release() throws IllegalStateException, FREInvalidObjectException, FREWrongThreadException;

    private FREBitmapData(FREObject.CFREObjectWrapper obj) {
        super(obj);
    }

    protected FREBitmapData(FREObject[] constructorArgs) throws IllegalStateException, FREInvalidObjectException, FREASErrorException, FRENoSuchNameException, FREWrongThreadException, FRETypeMismatchException {
        super("flash.display.BitmapData", constructorArgs);
    }

    public static FREBitmapData newBitmapData(int width, int height, boolean transparent, Byte[] fillColor) throws FREASErrorException, FREWrongThreadException, IllegalArgumentException {
        if (fillColor.length != 4) {
            throw new IllegalArgumentException("fillColor has wrong length");
        }
        FREObject[] array = new FREObject[4];
        array[0] = new FREObject(width);
        array[1] = new FREObject(height);
        array[2] = new FREObject(transparent);
        int color = 0;
        int signMask = -1;
        for (int i = 0; i < 4; i++) {
            int cShiftCount = (3 - i) * 8;
            color |= (fillColor[i].byteValue() << cShiftCount) & signMask;
            signMask >>>= 8;
        }
        array[3] = new FREObject(color);
        try {
            return new FREBitmapData(array);
        } catch (FREInvalidObjectException | FRENoSuchNameException | FRETypeMismatchException e) {
            return null;
        }
    }
}
