package com.facebook.model;

import com.facebook.FacebookGraphObjectException;
import com.facebook.internal.Utility;
import com.facebook.internal.Validate;
import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;
import java.lang.reflect.ParameterizedType;
import java.lang.reflect.Proxy;
import java.lang.reflect.Type;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.AbstractList;
import java.util.Collection;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

/* loaded from: classes.dex */
public interface GraphObject {

    public static final class Factory {
        private static final HashSet<Class<?>> verifiedGraphObjectClasses = new HashSet<>();
        private static final SimpleDateFormat[] dateFormats = {new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ssZ", Locale.US), new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss", Locale.US), new SimpleDateFormat("yyyy-MM-dd", Locale.US)};

        private static final class GraphObjectListImpl<T> extends AbstractList<T> implements GraphObjectList<T> {
            private final Class<?> itemType;
            private final JSONArray state;

            public GraphObjectListImpl(JSONArray jSONArray, Class<?> cls) {
                Validate.notNull(jSONArray, "state");
                Validate.notNull(cls, "itemType");
                this.state = jSONArray;
                this.itemType = cls;
            }

            private void checkIndex(int i) {
                if (i < 0 || i >= this.state.length()) {
                    throw new IndexOutOfBoundsException();
                }
            }

            private void put(int i, T t) throws JSONException {
                try {
                    this.state.put(i, Factory.getUnderlyingJSONObject(t));
                } catch (JSONException e) {
                    throw new IllegalArgumentException(e);
                }
            }

            @Override // java.util.AbstractList, java.util.List
            public void add(int i, T t) throws JSONException {
                if (i < 0) {
                    throw new IndexOutOfBoundsException();
                }
                if (i < size()) {
                    throw new UnsupportedOperationException("Only adding items at the end of the list is supported.");
                }
                put(i, t);
            }

            @Override // com.facebook.model.GraphObjectList
            public final <U extends GraphObject> GraphObjectList<U> castToListOf(Class<U> cls) {
                if (GraphObject.class.isAssignableFrom(this.itemType)) {
                    return cls.isAssignableFrom(this.itemType) ? this : Factory.createList(this.state, cls);
                }
                throw new FacebookGraphObjectException("Can't cast GraphObjectCollection of non-GraphObject type " + this.itemType);
            }

            @Override // java.util.AbstractList, java.util.AbstractCollection, java.util.Collection, java.util.List
            public void clear() {
                throw new UnsupportedOperationException();
            }

            @Override // java.util.AbstractList, java.util.Collection, java.util.List
            public boolean equals(Object obj) {
                if (obj == null) {
                    return false;
                }
                if (this == obj) {
                    return true;
                }
                if (getClass() != obj.getClass()) {
                    return false;
                }
                return this.state.equals(((GraphObjectListImpl) obj).state);
            }

            @Override // java.util.AbstractList, java.util.List
            public T get(int i) {
                checkIndex(i);
                return (T) Factory.coerceValueToExpectedType(this.state.opt(i), this.itemType, null);
            }

            @Override // com.facebook.model.GraphObjectList
            public final JSONArray getInnerJSONArray() {
                return this.state;
            }

            @Override // java.util.AbstractList, java.util.Collection, java.util.List
            public int hashCode() {
                return this.state.hashCode();
            }

            @Override // java.util.AbstractCollection, java.util.Collection, java.util.List
            public boolean remove(Object obj) {
                throw new UnsupportedOperationException();
            }

            @Override // java.util.AbstractCollection, java.util.Collection, java.util.List
            public boolean removeAll(Collection<?> collection) {
                throw new UnsupportedOperationException();
            }

            @Override // java.util.AbstractCollection, java.util.Collection, java.util.List
            public boolean retainAll(Collection<?> collection) {
                throw new UnsupportedOperationException();
            }

            @Override // java.util.AbstractList, java.util.List
            public T set(int i, T t) throws JSONException {
                checkIndex(i);
                T t2 = get(i);
                put(i, t);
                return t2;
            }

            @Override // java.util.AbstractCollection, java.util.Collection, java.util.List
            public int size() {
                return this.state.length();
            }

            @Override // java.util.AbstractCollection
            public String toString() {
                return String.format("GraphObjectList{itemType=%s, state=%s}", this.itemType.getSimpleName(), this.state);
            }
        }

        private static final class GraphObjectProxy extends ProxyBase<JSONObject> {
            private static final String CASTTOMAP_METHOD = "asMap";
            private static final String CAST_METHOD = "cast";
            private static final String CLEAR_METHOD = "clear";
            private static final String CONTAINSKEY_METHOD = "containsKey";
            private static final String CONTAINSVALUE_METHOD = "containsValue";
            private static final String ENTRYSET_METHOD = "entrySet";
            private static final String GETINNERJSONOBJECT_METHOD = "getInnerJSONObject";
            private static final String GETPROPERTYASLIST_METHOD = "getPropertyAsList";
            private static final String GETPROPERTYAS_METHOD = "getPropertyAs";
            private static final String GETPROPERTY_METHOD = "getProperty";
            private static final String GET_METHOD = "get";
            private static final String ISEMPTY_METHOD = "isEmpty";
            private static final String KEYSET_METHOD = "keySet";
            private static final String PUTALL_METHOD = "putAll";
            private static final String PUT_METHOD = "put";
            private static final String REMOVEPROPERTY_METHOD = "removeProperty";
            private static final String REMOVE_METHOD = "remove";
            private static final String SETPROPERTY_METHOD = "setProperty";
            private static final String SIZE_METHOD = "size";
            private static final String VALUES_METHOD = "values";
            private final Class<?> graphObjectClass;

            public GraphObjectProxy(JSONObject jSONObject, Class<?> cls) {
                super(jSONObject);
                this.graphObjectClass = cls;
            }

            private Object createGraphObjectsFromParameters(CreateGraphObject createGraphObject, Object obj) {
                if (createGraphObject == null || Utility.isNullOrEmpty(createGraphObject.value())) {
                    return obj;
                }
                String strValue = createGraphObject.value();
                if (!List.class.isAssignableFrom(obj.getClass())) {
                    GraphObject graphObjectCreate = Factory.create();
                    graphObjectCreate.setProperty(strValue, obj);
                    return graphObjectCreate;
                }
                GraphObjectList graphObjectListCreateList = Factory.createList(GraphObject.class);
                for (Object obj2 : (List) obj) {
                    GraphObject graphObjectCreate2 = Factory.create();
                    graphObjectCreate2.setProperty(strValue, obj2);
                    graphObjectListCreateList.add(graphObjectCreate2);
                }
                return graphObjectListCreateList;
            }

            /* JADX WARN: Multi-variable type inference failed */
            private final Object proxyGraphObjectGettersAndSetters(Method method, Object[] objArr) throws JSONException {
                String name = method.getName();
                int length = method.getParameterTypes().length;
                PropertyName propertyName = (PropertyName) method.getAnnotation(PropertyName.class);
                String strValue = propertyName != null ? propertyName.value() : Factory.convertCamelCaseToLowercaseWithUnderscores(name.substring(3));
                if (length == 0) {
                    Object objOpt = ((JSONObject) this.state).opt(strValue);
                    Class<?> returnType = method.getReturnType();
                    Type genericReturnType = method.getGenericReturnType();
                    return Factory.coerceValueToExpectedType(objOpt, returnType, genericReturnType instanceof ParameterizedType ? (ParameterizedType) genericReturnType : null);
                }
                if (length != 1) {
                    return throwUnexpectedMethodSignature(method);
                }
                ((JSONObject) this.state).putOpt(strValue, Factory.getUnderlyingJSONObject(createGraphObjectsFromParameters((CreateGraphObject) method.getAnnotation(CreateGraphObject.class), objArr[0])));
                return null;
            }

            /* JADX WARN: Multi-variable type inference failed */
            private final Object proxyGraphObjectMethods(Object obj, Method method, Object[] objArr) {
                String name = method.getName();
                if (name.equals(CAST_METHOD)) {
                    Class cls = (Class) objArr[0];
                    return (cls == null || !cls.isAssignableFrom(this.graphObjectClass)) ? Factory.createGraphObjectProxy(cls, (JSONObject) this.state) : obj;
                }
                if (name.equals(GETINNERJSONOBJECT_METHOD)) {
                    return ((GraphObjectProxy) Proxy.getInvocationHandler(obj)).state;
                }
                if (name.equals(CASTTOMAP_METHOD)) {
                    return Factory.createGraphObjectProxyForMap((JSONObject) this.state);
                }
                if (name.equals(GETPROPERTY_METHOD)) {
                    return ((JSONObject) this.state).opt((String) objArr[0]);
                }
                if (name.equals(GETPROPERTYAS_METHOD)) {
                    return Factory.coerceValueToExpectedType(((JSONObject) this.state).opt((String) objArr[0]), (Class) objArr[1], null);
                }
                if (name.equals(GETPROPERTYASLIST_METHOD)) {
                    Object objOpt = ((JSONObject) this.state).opt((String) objArr[0]);
                    final Class cls2 = (Class) objArr[1];
                    return Factory.coerceValueToExpectedType(objOpt, GraphObjectList.class, new ParameterizedType() { // from class: com.facebook.model.GraphObject.Factory.GraphObjectProxy.1
                        @Override // java.lang.reflect.ParameterizedType
                        public Type[] getActualTypeArguments() {
                            return new Type[]{cls2};
                        }

                        @Override // java.lang.reflect.ParameterizedType
                        public Type getOwnerType() {
                            return null;
                        }

                        @Override // java.lang.reflect.ParameterizedType
                        public Type getRawType() {
                            return GraphObjectList.class;
                        }
                    });
                }
                if (name.equals(SETPROPERTY_METHOD)) {
                    return setJSONProperty(objArr);
                }
                if (!name.equals(REMOVEPROPERTY_METHOD)) {
                    return throwUnexpectedMethodSignature(method);
                }
                ((JSONObject) this.state).remove((String) objArr[0]);
                return null;
            }

            /* JADX WARN: Multi-variable type inference failed */
            private final Object proxyMapMethods(Method method, Object[] objArr) throws JSONException {
                Map<String, Object> mapAsMap;
                String name = method.getName();
                if (name.equals(CLEAR_METHOD)) {
                    JsonUtil.jsonObjectClear((JSONObject) this.state);
                    return null;
                }
                if (name.equals(CONTAINSKEY_METHOD)) {
                    return Boolean.valueOf(((JSONObject) this.state).has((String) objArr[0]));
                }
                if (name.equals(CONTAINSVALUE_METHOD)) {
                    return Boolean.valueOf(JsonUtil.jsonObjectContainsValue((JSONObject) this.state, objArr[0]));
                }
                if (name.equals(ENTRYSET_METHOD)) {
                    return JsonUtil.jsonObjectEntrySet((JSONObject) this.state);
                }
                if (name.equals(GET_METHOD)) {
                    return ((JSONObject) this.state).opt((String) objArr[0]);
                }
                if (name.equals(ISEMPTY_METHOD)) {
                    return Boolean.valueOf(((JSONObject) this.state).length() == 0);
                }
                if (name.equals(KEYSET_METHOD)) {
                    return JsonUtil.jsonObjectKeySet((JSONObject) this.state);
                }
                if (name.equals(PUT_METHOD)) {
                    return setJSONProperty(objArr);
                }
                if (!name.equals(PUTALL_METHOD)) {
                    if (!name.equals(REMOVE_METHOD)) {
                        return name.equals(SIZE_METHOD) ? Integer.valueOf(((JSONObject) this.state).length()) : name.equals(VALUES_METHOD) ? JsonUtil.jsonObjectValues((JSONObject) this.state) : throwUnexpectedMethodSignature(method);
                    }
                    ((JSONObject) this.state).remove((String) objArr[0]);
                    return null;
                }
                if (objArr[0] instanceof Map) {
                    mapAsMap = (Map) objArr[0];
                } else {
                    if (!(objArr[0] instanceof GraphObject)) {
                        return null;
                    }
                    mapAsMap = ((GraphObject) objArr[0]).asMap();
                }
                JsonUtil.jsonObjectPutAll((JSONObject) this.state, mapAsMap);
                return null;
            }

            /* JADX WARN: Multi-variable type inference failed */
            private Object setJSONProperty(Object[] objArr) throws JSONException {
                try {
                    ((JSONObject) this.state).putOpt((String) objArr[0], Factory.getUnderlyingJSONObject(objArr[1]));
                    return null;
                } catch (JSONException e) {
                    throw new IllegalArgumentException(e);
                }
            }

            @Override // java.lang.reflect.InvocationHandler
            public final Object invoke(Object obj, Method method, Object[] objArr) throws Throwable {
                Class<?> declaringClass = method.getDeclaringClass();
                return declaringClass == Object.class ? proxyObjectMethods(obj, method, objArr) : declaringClass == Map.class ? proxyMapMethods(method, objArr) : declaringClass == GraphObject.class ? proxyGraphObjectMethods(obj, method, objArr) : GraphObject.class.isAssignableFrom(declaringClass) ? proxyGraphObjectGettersAndSetters(method, objArr) : throwUnexpectedMethodSignature(method);
            }

            public String toString() {
                return String.format("GraphObject{graphObjectClass=%s, state=%s}", this.graphObjectClass.getSimpleName(), this.state);
            }
        }

        private static abstract class ProxyBase<STATE> implements InvocationHandler {
            private static final String EQUALS_METHOD = "equals";
            private static final String TOSTRING_METHOD = "toString";
            protected final STATE state;

            protected ProxyBase(STATE state) {
                this.state = state;
            }

            protected final Object proxyObjectMethods(Object obj, Method method, Object[] objArr) throws Throwable {
                String name = method.getName();
                if (!name.equals(EQUALS_METHOD)) {
                    return name.equals(TOSTRING_METHOD) ? toString() : method.invoke(this.state, objArr);
                }
                Object obj2 = objArr[0];
                if (obj2 == null) {
                    return false;
                }
                InvocationHandler invocationHandler = Proxy.getInvocationHandler(obj2);
                if (invocationHandler instanceof GraphObjectProxy) {
                    return Boolean.valueOf(this.state.equals(((GraphObjectProxy) invocationHandler).state));
                }
                return false;
            }

            protected final Object throwUnexpectedMethodSignature(Method method) {
                throw new FacebookGraphObjectException(getClass().getName() + " got an unexpected method signature: " + method.toString());
            }
        }

        private Factory() {
        }

        static <U> U coerceValueToExpectedType(Object obj, Class<U> cls, ParameterizedType parameterizedType) {
            U u;
            if (obj == 0) {
                if (Boolean.TYPE.equals(cls)) {
                    return (U) false;
                }
                if (Character.TYPE.equals(cls)) {
                    return (U) (char) 0;
                }
                if (cls.isPrimitive()) {
                    return (U) 0;
                }
                return null;
            }
            Class<?> cls2 = obj.getClass();
            if (!cls.isAssignableFrom(cls2) && !cls.isPrimitive()) {
                if (GraphObject.class.isAssignableFrom(cls)) {
                    if (JSONObject.class.isAssignableFrom(cls2)) {
                        return (U) createGraphObjectProxy(cls, (JSONObject) obj);
                    }
                    if (GraphObject.class.isAssignableFrom(cls2)) {
                        return (U) ((GraphObject) obj).cast(cls);
                    }
                    throw new FacebookGraphObjectException("Can't create GraphObject from " + cls2.getName());
                }
                if (Iterable.class.equals(cls) || Collection.class.equals(cls) || List.class.equals(cls) || GraphObjectList.class.equals(cls)) {
                    if (parameterizedType == null) {
                        throw new FacebookGraphObjectException("can't infer generic type of: " + cls.toString());
                    }
                    Type[] actualTypeArguments = parameterizedType.getActualTypeArguments();
                    if (actualTypeArguments == null || actualTypeArguments.length != 1 || !(actualTypeArguments[0] instanceof Class)) {
                        throw new FacebookGraphObjectException("Expect collection properties to be of a type with exactly one generic parameter.");
                    }
                    Class cls3 = (Class) actualTypeArguments[0];
                    if (JSONArray.class.isAssignableFrom(cls2)) {
                        return (U) createList((JSONArray) obj, cls3);
                    }
                    throw new FacebookGraphObjectException("Can't create Collection from " + cls2.getName());
                }
                if (String.class.equals(cls)) {
                    if (Double.class.isAssignableFrom(cls2) || Float.class.isAssignableFrom(cls2)) {
                        return (U) String.format("%f", obj);
                    }
                    if (Number.class.isAssignableFrom(cls2)) {
                        return (U) String.format("%d", obj);
                    }
                } else if (Date.class.equals(cls) && String.class.isAssignableFrom(cls2)) {
                    for (SimpleDateFormat simpleDateFormat : dateFormats) {
                        try {
                            u = (U) simpleDateFormat.parse((String) obj);
                        } catch (ParseException e) {
                        }
                        if (u != null) {
                            return u;
                        }
                    }
                }
                throw new FacebookGraphObjectException("Can't convert type" + cls2.getName() + " to " + cls.getName());
            }
            return obj;
        }

        static String convertCamelCaseToLowercaseWithUnderscores(String str) {
            return str.replaceAll("([a-z])([A-Z])", "$1_$2").toLowerCase(Locale.US);
        }

        public static GraphObject create() {
            return create(GraphObject.class);
        }

        public static <T extends GraphObject> T create(Class<T> cls) {
            return (T) createGraphObjectProxy(cls, new JSONObject());
        }

        public static GraphObject create(JSONObject jSONObject) {
            return create(jSONObject, GraphObject.class);
        }

        public static <T extends GraphObject> T create(JSONObject jSONObject, Class<T> cls) {
            return (T) createGraphObjectProxy(cls, jSONObject);
        }

        /* JADX INFO: Access modifiers changed from: private */
        public static <T extends GraphObject> T createGraphObjectProxy(Class<T> cls, JSONObject jSONObject) throws SecurityException {
            verifyCanProxyClass(cls);
            return (T) Proxy.newProxyInstance(GraphObject.class.getClassLoader(), new Class[]{cls}, new GraphObjectProxy(jSONObject, cls));
        }

        /* JADX INFO: Access modifiers changed from: private */
        public static Map<String, Object> createGraphObjectProxyForMap(JSONObject jSONObject) {
            return (Map) Proxy.newProxyInstance(GraphObject.class.getClassLoader(), new Class[]{Map.class}, new GraphObjectProxy(jSONObject, Map.class));
        }

        public static <T> GraphObjectList<T> createList(Class<T> cls) {
            return createList(new JSONArray(), cls);
        }

        public static <T> GraphObjectList<T> createList(JSONArray jSONArray, Class<T> cls) {
            return new GraphObjectListImpl(jSONArray, cls);
        }

        /* JADX INFO: Access modifiers changed from: private */
        public static Object getUnderlyingJSONObject(Object obj) {
            if (obj == null) {
                return null;
            }
            Class<?> cls = obj.getClass();
            if (GraphObject.class.isAssignableFrom(cls)) {
                return ((GraphObject) obj).getInnerJSONObject();
            }
            if (GraphObjectList.class.isAssignableFrom(cls)) {
                return ((GraphObjectList) obj).getInnerJSONArray();
            }
            if (!Iterable.class.isAssignableFrom(cls)) {
                return obj;
            }
            JSONArray jSONArray = new JSONArray();
            for (Object obj2 : (Iterable) obj) {
                if (GraphObject.class.isAssignableFrom(obj2.getClass())) {
                    jSONArray.put(((GraphObject) obj2).getInnerJSONObject());
                } else {
                    jSONArray.put(obj2);
                }
            }
            return jSONArray;
        }

        private static synchronized <T extends GraphObject> boolean hasClassBeenVerified(Class<T> cls) {
            return verifiedGraphObjectClasses.contains(cls);
        }

        public static boolean hasSameId(GraphObject graphObject, GraphObject graphObject2) {
            if (graphObject == null || graphObject2 == null || !graphObject.asMap().containsKey("id") || !graphObject2.asMap().containsKey("id")) {
                return false;
            }
            if (graphObject.equals(graphObject2)) {
                return true;
            }
            Object property = graphObject.getProperty("id");
            Object property2 = graphObject2.getProperty("id");
            if (property == null || property2 == null || !(property instanceof String) || !(property2 instanceof String)) {
                return false;
            }
            return property.equals(property2);
        }

        private static synchronized <T extends GraphObject> void recordClassHasBeenVerified(Class<T> cls) {
            verifiedGraphObjectClasses.add(cls);
        }

        private static <T extends GraphObject> void verifyCanProxyClass(Class<T> cls) throws SecurityException {
            if (hasClassBeenVerified(cls)) {
                return;
            }
            if (!cls.isInterface()) {
                throw new FacebookGraphObjectException("Factory can only wrap interfaces, not class: " + cls.getName());
            }
            for (Method method : cls.getMethods()) {
                String name = method.getName();
                int length = method.getParameterTypes().length;
                Class<?> returnType = method.getReturnType();
                boolean zIsAnnotationPresent = method.isAnnotationPresent(PropertyName.class);
                if (!method.getDeclaringClass().isAssignableFrom(GraphObject.class)) {
                    if (length != 1 || returnType != Void.TYPE) {
                        if (length == 0 && returnType != Void.TYPE) {
                            if (zIsAnnotationPresent) {
                                if (!Utility.isNullOrEmpty(((PropertyName) method.getAnnotation(PropertyName.class)).value())) {
                                }
                            } else if (!name.startsWith("get") || name.length() <= 3) {
                            }
                        }
                        throw new FacebookGraphObjectException("Factory can't proxy method: " + method.toString());
                    }
                    if (zIsAnnotationPresent) {
                        if (Utility.isNullOrEmpty(((PropertyName) method.getAnnotation(PropertyName.class)).value())) {
                            throw new FacebookGraphObjectException("Factory can't proxy method: " + method.toString());
                        }
                    } else if (!name.startsWith("set") || name.length() <= 3) {
                        throw new FacebookGraphObjectException("Factory can't proxy method: " + method.toString());
                    }
                }
            }
            recordClassHasBeenVerified(cls);
        }
    }

    Map<String, Object> asMap();

    <T extends GraphObject> T cast(Class<T> cls);

    JSONObject getInnerJSONObject();

    Object getProperty(String str);

    <T extends GraphObject> T getPropertyAs(String str, Class<T> cls);

    <T extends GraphObject> GraphObjectList<T> getPropertyAsList(String str, Class<T> cls);

    void removeProperty(String str);

    void setProperty(String str, Object obj);
}
