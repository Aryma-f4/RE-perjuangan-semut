package com.facebook;

import android.content.Context;
import android.content.SharedPreferences;
import android.os.Bundle;
import com.facebook.internal.Logger;
import com.facebook.internal.Utility;
import com.facebook.internal.Validate;
import java.util.ArrayList;
import java.util.List;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

/* loaded from: classes.dex */
public class SharedPreferencesTokenCachingStrategy extends TokenCachingStrategy {
    private static final String DEFAULT_CACHE_KEY = "com.facebook.SharedPreferencesTokenCachingStrategy.DEFAULT_KEY";
    private static final String JSON_VALUE = "value";
    private static final String JSON_VALUE_ENUM_TYPE = "enumType";
    private static final String JSON_VALUE_TYPE = "valueType";
    private static final String TAG = SharedPreferencesTokenCachingStrategy.class.getSimpleName();
    private static final String TYPE_BOOLEAN = "bool";
    private static final String TYPE_BOOLEAN_ARRAY = "bool[]";
    private static final String TYPE_BYTE = "byte";
    private static final String TYPE_BYTE_ARRAY = "byte[]";
    private static final String TYPE_CHAR = "char";
    private static final String TYPE_CHAR_ARRAY = "char[]";
    private static final String TYPE_DOUBLE = "double";
    private static final String TYPE_DOUBLE_ARRAY = "double[]";
    private static final String TYPE_ENUM = "enum";
    private static final String TYPE_FLOAT = "float";
    private static final String TYPE_FLOAT_ARRAY = "float[]";
    private static final String TYPE_INTEGER = "int";
    private static final String TYPE_INTEGER_ARRAY = "int[]";
    private static final String TYPE_LONG = "long";
    private static final String TYPE_LONG_ARRAY = "long[]";
    private static final String TYPE_SHORT = "short";
    private static final String TYPE_SHORT_ARRAY = "short[]";
    private static final String TYPE_STRING = "string";
    private static final String TYPE_STRING_LIST = "stringList";
    private SharedPreferences cache;
    private String cacheKey;

    public SharedPreferencesTokenCachingStrategy(Context context) {
        this(context, null);
    }

    public SharedPreferencesTokenCachingStrategy(Context context, String str) {
        Validate.notNull(context, "context");
        this.cacheKey = Utility.isNullOrEmpty(str) ? DEFAULT_CACHE_KEY : str;
        Context applicationContext = context.getApplicationContext();
        this.cache = (applicationContext == null ? context : applicationContext).getSharedPreferences(this.cacheKey, 0);
    }

    private void deserializeKey(String str, Bundle bundle) throws JSONException {
        JSONObject jSONObject = new JSONObject(this.cache.getString(str, "{}"));
        String string = jSONObject.getString(JSON_VALUE_TYPE);
        if (string.equals(TYPE_BOOLEAN)) {
            bundle.putBoolean(str, jSONObject.getBoolean(JSON_VALUE));
            return;
        }
        if (string.equals(TYPE_BOOLEAN_ARRAY)) {
            JSONArray jSONArray = jSONObject.getJSONArray(JSON_VALUE);
            boolean[] zArr = new boolean[jSONArray.length()];
            for (int i = 0; i < zArr.length; i++) {
                zArr[i] = jSONArray.getBoolean(i);
            }
            bundle.putBooleanArray(str, zArr);
            return;
        }
        if (string.equals(TYPE_BYTE)) {
            bundle.putByte(str, (byte) jSONObject.getInt(JSON_VALUE));
            return;
        }
        if (string.equals(TYPE_BYTE_ARRAY)) {
            JSONArray jSONArray2 = jSONObject.getJSONArray(JSON_VALUE);
            byte[] bArr = new byte[jSONArray2.length()];
            for (int i2 = 0; i2 < bArr.length; i2++) {
                bArr[i2] = (byte) jSONArray2.getInt(i2);
            }
            bundle.putByteArray(str, bArr);
            return;
        }
        if (string.equals(TYPE_SHORT)) {
            bundle.putShort(str, (short) jSONObject.getInt(JSON_VALUE));
            return;
        }
        if (string.equals(TYPE_SHORT_ARRAY)) {
            JSONArray jSONArray3 = jSONObject.getJSONArray(JSON_VALUE);
            short[] sArr = new short[jSONArray3.length()];
            for (int i3 = 0; i3 < sArr.length; i3++) {
                sArr[i3] = (short) jSONArray3.getInt(i3);
            }
            bundle.putShortArray(str, sArr);
            return;
        }
        if (string.equals(TYPE_INTEGER)) {
            bundle.putInt(str, jSONObject.getInt(JSON_VALUE));
            return;
        }
        if (string.equals(TYPE_INTEGER_ARRAY)) {
            JSONArray jSONArray4 = jSONObject.getJSONArray(JSON_VALUE);
            int[] iArr = new int[jSONArray4.length()];
            for (int i4 = 0; i4 < iArr.length; i4++) {
                iArr[i4] = jSONArray4.getInt(i4);
            }
            bundle.putIntArray(str, iArr);
            return;
        }
        if (string.equals(TYPE_LONG)) {
            bundle.putLong(str, jSONObject.getLong(JSON_VALUE));
            return;
        }
        if (string.equals(TYPE_LONG_ARRAY)) {
            JSONArray jSONArray5 = jSONObject.getJSONArray(JSON_VALUE);
            long[] jArr = new long[jSONArray5.length()];
            for (int i5 = 0; i5 < jArr.length; i5++) {
                jArr[i5] = jSONArray5.getLong(i5);
            }
            bundle.putLongArray(str, jArr);
            return;
        }
        if (string.equals(TYPE_FLOAT)) {
            bundle.putFloat(str, (float) jSONObject.getDouble(JSON_VALUE));
            return;
        }
        if (string.equals(TYPE_FLOAT_ARRAY)) {
            JSONArray jSONArray6 = jSONObject.getJSONArray(JSON_VALUE);
            float[] fArr = new float[jSONArray6.length()];
            for (int i6 = 0; i6 < fArr.length; i6++) {
                fArr[i6] = (float) jSONArray6.getDouble(i6);
            }
            bundle.putFloatArray(str, fArr);
            return;
        }
        if (string.equals(TYPE_DOUBLE)) {
            bundle.putDouble(str, jSONObject.getDouble(JSON_VALUE));
            return;
        }
        if (string.equals(TYPE_DOUBLE_ARRAY)) {
            JSONArray jSONArray7 = jSONObject.getJSONArray(JSON_VALUE);
            double[] dArr = new double[jSONArray7.length()];
            for (int i7 = 0; i7 < dArr.length; i7++) {
                dArr[i7] = jSONArray7.getDouble(i7);
            }
            bundle.putDoubleArray(str, dArr);
            return;
        }
        if (string.equals(TYPE_CHAR)) {
            String string2 = jSONObject.getString(JSON_VALUE);
            if (string2 == null || string2.length() != 1) {
                return;
            }
            bundle.putChar(str, string2.charAt(0));
            return;
        }
        if (string.equals(TYPE_CHAR_ARRAY)) {
            JSONArray jSONArray8 = jSONObject.getJSONArray(JSON_VALUE);
            char[] cArr = new char[jSONArray8.length()];
            for (int i8 = 0; i8 < cArr.length; i8++) {
                String string3 = jSONArray8.getString(i8);
                if (string3 != null && string3.length() == 1) {
                    cArr[i8] = string3.charAt(0);
                }
            }
            bundle.putCharArray(str, cArr);
            return;
        }
        if (string.equals(TYPE_STRING)) {
            bundle.putString(str, jSONObject.getString(JSON_VALUE));
            return;
        }
        if (!string.equals(TYPE_STRING_LIST)) {
            if (string.equals(TYPE_ENUM)) {
                try {
                    bundle.putSerializable(str, Enum.valueOf(Class.forName(jSONObject.getString(JSON_VALUE_ENUM_TYPE)), jSONObject.getString(JSON_VALUE)));
                    return;
                } catch (ClassNotFoundException e) {
                    return;
                } catch (IllegalArgumentException e2) {
                    return;
                }
            }
            return;
        }
        JSONArray jSONArray9 = jSONObject.getJSONArray(JSON_VALUE);
        int length = jSONArray9.length();
        ArrayList<String> arrayList = new ArrayList<>(length);
        for (int i9 = 0; i9 < length; i9++) {
            Object obj = jSONArray9.get(i9);
            arrayList.add(i9, obj == JSONObject.NULL ? null : (String) obj);
        }
        bundle.putStringArrayList(str, arrayList);
    }

    private void serializeKey(String str, Bundle bundle, SharedPreferences.Editor editor) throws JSONException {
        JSONArray jSONArray;
        String str2;
        int i = 0;
        Object obj = bundle.get(str);
        if (obj == null) {
            return;
        }
        JSONObject jSONObject = new JSONObject();
        if (obj instanceof Byte) {
            jSONObject.put(JSON_VALUE, ((Byte) obj).intValue());
            str2 = TYPE_BYTE;
            jSONArray = null;
        } else if (obj instanceof Short) {
            jSONObject.put(JSON_VALUE, ((Short) obj).intValue());
            str2 = TYPE_SHORT;
            jSONArray = null;
        } else if (obj instanceof Integer) {
            jSONObject.put(JSON_VALUE, ((Integer) obj).intValue());
            str2 = TYPE_INTEGER;
            jSONArray = null;
        } else if (obj instanceof Long) {
            jSONObject.put(JSON_VALUE, ((Long) obj).longValue());
            str2 = TYPE_LONG;
            jSONArray = null;
        } else if (obj instanceof Float) {
            jSONObject.put(JSON_VALUE, ((Float) obj).doubleValue());
            str2 = TYPE_FLOAT;
            jSONArray = null;
        } else if (obj instanceof Double) {
            jSONObject.put(JSON_VALUE, ((Double) obj).doubleValue());
            str2 = TYPE_DOUBLE;
            jSONArray = null;
        } else if (obj instanceof Boolean) {
            jSONObject.put(JSON_VALUE, ((Boolean) obj).booleanValue());
            str2 = TYPE_BOOLEAN;
            jSONArray = null;
        } else if (obj instanceof Character) {
            jSONObject.put(JSON_VALUE, obj.toString());
            str2 = TYPE_CHAR;
            jSONArray = null;
        } else if (obj instanceof String) {
            jSONObject.put(JSON_VALUE, (String) obj);
            str2 = TYPE_STRING;
            jSONArray = null;
        } else if (obj instanceof Enum) {
            jSONObject.put(JSON_VALUE, obj.toString());
            jSONObject.put(JSON_VALUE_ENUM_TYPE, obj.getClass().getName());
            str2 = TYPE_ENUM;
            jSONArray = null;
        } else {
            jSONArray = new JSONArray();
            if (obj instanceof byte[]) {
                str2 = TYPE_BYTE_ARRAY;
                byte[] bArr = (byte[]) obj;
                int length = bArr.length;
                while (i < length) {
                    jSONArray.put((int) bArr[i]);
                    i++;
                }
            } else if (obj instanceof short[]) {
                str2 = TYPE_SHORT_ARRAY;
                short[] sArr = (short[]) obj;
                int length2 = sArr.length;
                while (i < length2) {
                    jSONArray.put((int) sArr[i]);
                    i++;
                }
            } else if (obj instanceof int[]) {
                str2 = TYPE_INTEGER_ARRAY;
                int[] iArr = (int[]) obj;
                int length3 = iArr.length;
                while (i < length3) {
                    jSONArray.put(iArr[i]);
                    i++;
                }
            } else if (obj instanceof long[]) {
                str2 = TYPE_LONG_ARRAY;
                long[] jArr = (long[]) obj;
                int length4 = jArr.length;
                while (i < length4) {
                    jSONArray.put(jArr[i]);
                    i++;
                }
            } else if (obj instanceof float[]) {
                str2 = TYPE_FLOAT_ARRAY;
                int length5 = ((float[]) obj).length;
                while (i < length5) {
                    jSONArray.put(r8[i]);
                    i++;
                }
            } else if (obj instanceof double[]) {
                str2 = TYPE_DOUBLE_ARRAY;
                double[] dArr = (double[]) obj;
                int length6 = dArr.length;
                while (i < length6) {
                    jSONArray.put(dArr[i]);
                    i++;
                }
            } else if (obj instanceof boolean[]) {
                str2 = TYPE_BOOLEAN_ARRAY;
                boolean[] zArr = (boolean[]) obj;
                int length7 = zArr.length;
                while (i < length7) {
                    jSONArray.put(zArr[i]);
                    i++;
                }
            } else if (obj instanceof char[]) {
                str2 = TYPE_CHAR_ARRAY;
                char[] cArr = (char[]) obj;
                int length8 = cArr.length;
                while (i < length8) {
                    jSONArray.put(String.valueOf(cArr[i]));
                    i++;
                }
            } else if (obj instanceof List) {
                str2 = TYPE_STRING_LIST;
                for (String str3 : (List) obj) {
                    jSONArray.put(str3 == null ? JSONObject.NULL : str3);
                }
            } else {
                jSONArray = null;
                str2 = null;
            }
        }
        if (str2 != null) {
            jSONObject.put(JSON_VALUE_TYPE, str2);
            if (jSONArray != null) {
                jSONObject.putOpt(JSON_VALUE, jSONArray);
            }
            editor.putString(str, jSONObject.toString());
        }
    }

    @Override // com.facebook.TokenCachingStrategy
    public void clear() {
        this.cache.edit().clear().commit();
    }

    @Override // com.facebook.TokenCachingStrategy
    public Bundle load() {
        Bundle bundle = new Bundle();
        for (String str : this.cache.getAll().keySet()) {
            try {
                deserializeKey(str, bundle);
            } catch (JSONException e) {
                Logger.log(LoggingBehavior.CACHE, 5, TAG, "Error reading cached value for key: '" + str + "' -- " + e);
                return null;
            }
        }
        return bundle;
    }

    @Override // com.facebook.TokenCachingStrategy
    public void save(Bundle bundle) {
        Validate.notNull(bundle, "bundle");
        SharedPreferences.Editor editorEdit = this.cache.edit();
        for (String str : bundle.keySet()) {
            try {
                serializeKey(str, bundle, editorEdit);
            } catch (JSONException e) {
                Logger.log(LoggingBehavior.CACHE, 5, TAG, "Error processing value for key: '" + str + "' -- " + e);
                return;
            }
        }
        if (editorEdit.commit()) {
            return;
        }
        Logger.log(LoggingBehavior.CACHE, 5, TAG, "SharedPreferences.Editor.commit() was not successful");
    }
}
