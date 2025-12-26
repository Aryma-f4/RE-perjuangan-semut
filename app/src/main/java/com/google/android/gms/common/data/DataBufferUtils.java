package com.google.android.gms.common.data;

import java.util.ArrayList;
import java.util.Iterator;
import org.jsoup.parser.ParseErrorList;

/* loaded from: classes.dex */
public final class DataBufferUtils {
    private DataBufferUtils() {
    }

    public static <T, E extends Freezable<T>> ArrayList<T> freezeAndClose(DataBuffer<E> dataBuffer) {
        ParseErrorList parseErrorList = (ArrayList<T>) new ArrayList(dataBuffer.getCount());
        try {
            Iterator<E> it = dataBuffer.iterator();
            while (it.hasNext()) {
                parseErrorList.add(it.next().freeze());
            }
            return parseErrorList;
        } finally {
            dataBuffer.close();
        }
    }
}
