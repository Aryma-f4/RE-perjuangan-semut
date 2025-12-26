package com.adobe.air;

import android.content.res.Resources;
import java.lang.reflect.Field;
import java.util.Hashtable;

/* loaded from: classes.dex */
public class ResourceIdMap {
    private static Hashtable<String, Hashtable<String, Integer>> s_resourceMap;
    private Hashtable<String, Integer> m_resourceIds;

    public ResourceIdMap(String resourceClass) {
        try {
            init(Class.forName(resourceClass));
        } catch (ClassNotFoundException e) {
            System.out.format("Class not found:  %s%n%n", resourceClass);
        }
    }

    public ResourceIdMap(Class<?> resourceClass) {
        init(resourceClass);
    }

    private void init(Class<?> resourceClass) {
        if (s_resourceMap == null) {
            s_resourceMap = new Hashtable<>();
        }
        if (!s_resourceMap.contains(resourceClass)) {
            this.m_resourceIds = new Hashtable<>();
            gatherResourceInfo(resourceClass, this.m_resourceIds);
            s_resourceMap.put(resourceClass.getName(), this.m_resourceIds);
            return;
        }
        this.m_resourceIds = s_resourceMap.get(resourceClass);
    }

    private static void gatherResourceInfo(Class<?> resourceClass, Hashtable<String, Integer> resourceIds) {
        Class<?>[] clss = resourceClass.getClasses();
        for (Class<?> cls : clss) {
            String clsName = cls.getName();
            int indexOfDollarSign = clsName.lastIndexOf(36) + 1;
            String clsName2 = indexOfDollarSign > 0 ? clsName.substring(indexOfDollarSign) : clsName;
            Field[] fields = cls.getDeclaredFields();
            for (Field f : fields) {
                try {
                    String rscKey = String.format("%s.%s", clsName2, f.getName()).intern();
                    if (resourceIds.containsKey(rscKey)) {
                        System.out.format("Did not add duplicate resource key %s", rscKey);
                    } else {
                        resourceIds.put(rscKey, Integer.valueOf(f.getInt(cls)));
                    }
                } catch (IllegalAccessException e) {
                    System.out.format("IllegalAccessException", new Object[0]);
                } catch (IllegalArgumentException e2) {
                    System.out.format("IllegalArgumentException", new Object[0]);
                }
            }
        }
    }

    public int getId(String resourceString) throws Resources.NotFoundException, IllegalArgumentException {
        if (resourceString == null) {
            throw new IllegalArgumentException();
        }
        String internedResourceString = resourceString.intern();
        if (!this.m_resourceIds.containsKey(internedResourceString)) {
            throw new Resources.NotFoundException(internedResourceString);
        }
        return this.m_resourceIds.get(internedResourceString).intValue();
    }
}
