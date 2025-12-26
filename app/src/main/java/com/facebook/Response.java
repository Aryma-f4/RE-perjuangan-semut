package com.facebook;

import android.content.Context;
import android.support.v4.os.EnvironmentCompat;
import com.facebook.internal.FileLruCache;
import com.facebook.internal.Logger;
import com.facebook.internal.Utility;
import com.facebook.model.GraphObject;
import com.facebook.model.GraphObjectList;
import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.json.JSONTokener;

/* loaded from: classes.dex */
public class Response {
    static final /* synthetic */ boolean $assertionsDisabled;
    private static final String BODY_KEY = "body";
    private static final String CODE_KEY = "code";
    private static final int INVALID_SESSION_FACEBOOK_ERROR_CODE = 190;
    public static final String NON_JSON_RESPONSE_PROPERTY = "FACEBOOK_NON_JSON_RESULT";
    private static final String RESPONSE_CACHE_TAG = "ResponseCache";
    private static final String RESPONSE_LOG_TAG = "Response";
    private static FileLruCache responseCache;
    private final HttpURLConnection connection;
    private final FacebookRequestError error;
    private final GraphObject graphObject;
    private final GraphObjectList<GraphObject> graphObjectList;
    private final boolean isFromCache;
    private final Request request;

    interface PagedResults extends GraphObject {
        GraphObjectList<GraphObject> getData();

        PagingInfo getPaging();
    }

    public enum PagingDirection {
        NEXT,
        PREVIOUS
    }

    interface PagingInfo extends GraphObject {
        String getNext();

        String getPrevious();
    }

    static {
        $assertionsDisabled = !Response.class.desiredAssertionStatus();
    }

    Response(Request request, HttpURLConnection httpURLConnection, FacebookRequestError facebookRequestError) {
        this.request = request;
        this.connection = httpURLConnection;
        this.graphObject = null;
        this.graphObjectList = null;
        this.isFromCache = false;
        this.error = facebookRequestError;
    }

    Response(Request request, HttpURLConnection httpURLConnection, GraphObject graphObject, boolean z) {
        this.request = request;
        this.connection = httpURLConnection;
        this.graphObject = graphObject;
        this.graphObjectList = null;
        this.isFromCache = z;
        this.error = null;
    }

    Response(Request request, HttpURLConnection httpURLConnection, GraphObjectList<GraphObject> graphObjectList, boolean z) {
        this.request = request;
        this.connection = httpURLConnection;
        this.graphObject = null;
        this.graphObjectList = graphObjectList;
        this.isFromCache = z;
        this.error = null;
    }

    static List<Response> constructErrorResponses(List<Request> list, HttpURLConnection httpURLConnection, FacebookException facebookException) {
        int size = list.size();
        ArrayList arrayList = new ArrayList(size);
        for (int i = 0; i < size; i++) {
            arrayList.add(new Response(list.get(i), httpURLConnection, new FacebookRequestError(httpURLConnection, facebookException)));
        }
        return arrayList;
    }

    private static Response createResponseFromObject(Request request, HttpURLConnection httpURLConnection, Object obj, boolean z, Object obj2) throws JSONException {
        Object obj3;
        Session session;
        if (obj instanceof JSONObject) {
            JSONObject jSONObject = (JSONObject) obj;
            FacebookRequestError facebookRequestErrorCheckResponseAndCreateError = FacebookRequestError.checkResponseAndCreateError(jSONObject, obj2, httpURLConnection);
            if (facebookRequestErrorCheckResponseAndCreateError != null) {
                if (facebookRequestErrorCheckResponseAndCreateError.getErrorCode() == INVALID_SESSION_FACEBOOK_ERROR_CODE && (session = request.getSession()) != null) {
                    session.closeAndClearTokenInformation();
                }
                return new Response(request, httpURLConnection, facebookRequestErrorCheckResponseAndCreateError);
            }
            Object stringPropertyAsJSON = Utility.getStringPropertyAsJSON(jSONObject, BODY_KEY, NON_JSON_RESPONSE_PROPERTY);
            if (stringPropertyAsJSON instanceof JSONObject) {
                return new Response(request, httpURLConnection, GraphObject.Factory.create((JSONObject) stringPropertyAsJSON), z);
            }
            if (stringPropertyAsJSON instanceof JSONArray) {
                return new Response(request, httpURLConnection, (GraphObjectList<GraphObject>) GraphObject.Factory.createList((JSONArray) stringPropertyAsJSON, GraphObject.class), z);
            }
            obj3 = JSONObject.NULL;
        } else {
            obj3 = obj;
        }
        if (obj3 == JSONObject.NULL) {
            return new Response(request, httpURLConnection, (GraphObject) null, z);
        }
        throw new FacebookException("Got unexpected object type in response, class: " + obj3.getClass().getSimpleName());
    }

    private static List<Response> createResponsesFromObject(HttpURLConnection httpURLConnection, List<Request> list, Object obj, boolean z) throws JSONException, FacebookException {
        Object obj2;
        if (!$assertionsDisabled && httpURLConnection == null && !z) {
            throw new AssertionError();
        }
        int size = list.size();
        ArrayList arrayList = new ArrayList(size);
        if (size == 1) {
            Request request = list.get(0);
            try {
                JSONObject jSONObject = new JSONObject();
                jSONObject.put(BODY_KEY, obj);
                jSONObject.put(CODE_KEY, httpURLConnection != null ? httpURLConnection.getResponseCode() : 200);
                JSONArray jSONArray = new JSONArray();
                jSONArray.put(jSONObject);
                obj2 = jSONArray;
            } catch (IOException e) {
                arrayList.add(new Response(request, httpURLConnection, new FacebookRequestError(httpURLConnection, e)));
            } catch (JSONException e2) {
                arrayList.add(new Response(request, httpURLConnection, new FacebookRequestError(httpURLConnection, e2)));
                obj2 = obj;
            }
        } else {
            obj2 = obj;
        }
        if (!(obj2 instanceof JSONArray) || ((JSONArray) obj2).length() != size) {
            throw new FacebookException("Unexpected number of results");
        }
        JSONArray jSONArray2 = (JSONArray) obj2;
        for (int i = 0; i < jSONArray2.length(); i++) {
            Request request2 = list.get(i);
            try {
                arrayList.add(createResponseFromObject(request2, httpURLConnection, jSONArray2.get(i), z, obj));
            } catch (FacebookException e3) {
                arrayList.add(new Response(request2, httpURLConnection, new FacebookRequestError(httpURLConnection, e3)));
            } catch (JSONException e4) {
                arrayList.add(new Response(request2, httpURLConnection, new FacebookRequestError(httpURLConnection, e4)));
            }
        }
        return arrayList;
    }

    static List<Response> createResponsesFromStream(InputStream inputStream, HttpURLConnection httpURLConnection, RequestBatch requestBatch, boolean z) throws Throwable {
        String streamToString = Utility.readStreamToString(inputStream);
        Logger.log(LoggingBehavior.INCLUDE_RAW_RESPONSES, RESPONSE_LOG_TAG, "Response (raw)\n  Size: %d\n  Response:\n%s\n", Integer.valueOf(streamToString.length()), streamToString);
        return createResponsesFromString(streamToString, httpURLConnection, requestBatch, z);
    }

    static List<Response> createResponsesFromString(String str, HttpURLConnection httpURLConnection, RequestBatch requestBatch, boolean z) throws JSONException, FacebookException, IOException {
        List<Response> listCreateResponsesFromObject = createResponsesFromObject(httpURLConnection, requestBatch, new JSONTokener(str).nextValue(), z);
        Logger.log(LoggingBehavior.REQUESTS, RESPONSE_LOG_TAG, "Response\n  Id: %s\n  Size: %d\n  Responses:\n%s\n", requestBatch.getId(), Integer.valueOf(str.length()), listCreateResponsesFromObject);
        return listCreateResponsesFromObject;
    }

    /* JADX WARN: Multi-variable type inference failed */
    /* JADX WARN: Removed duplicated region for block: B:24:0x0062 A[Catch: FacebookException -> 0x00a3, JSONException -> 0x00bc, IOException -> 0x00db, SecurityException -> 0x00fa, all -> 0x0119, TRY_LEAVE, TryCatch #6 {FacebookException -> 0x00a3, IOException -> 0x00db, SecurityException -> 0x00fa, JSONException -> 0x00bc, all -> 0x0119, blocks: (B:22:0x005a, B:24:0x0062, B:41:0x0091, B:45:0x009b), top: B:91:0x005a }] */
    /* JADX WARN: Removed duplicated region for block: B:41:0x0091 A[Catch: FacebookException -> 0x00a3, JSONException -> 0x00bc, IOException -> 0x00db, SecurityException -> 0x00fa, all -> 0x0119, TRY_ENTER, TryCatch #6 {FacebookException -> 0x00a3, IOException -> 0x00db, SecurityException -> 0x00fa, JSONException -> 0x00bc, all -> 0x0119, blocks: (B:22:0x005a, B:24:0x0062, B:41:0x0091, B:45:0x009b), top: B:91:0x005a }] */
    /* JADX WARN: Type inference failed for: r2v0 */
    /* JADX WARN: Type inference failed for: r2v1, types: [com.facebook.internal.FileLruCache] */
    /* JADX WARN: Type inference failed for: r2v12 */
    /* JADX WARN: Type inference failed for: r2v16 */
    /* JADX WARN: Type inference failed for: r2v2 */
    /* JADX WARN: Type inference failed for: r2v38 */
    /* JADX WARN: Type inference failed for: r2v39 */
    /* JADX WARN: Type inference failed for: r2v40 */
    /* JADX WARN: Type inference failed for: r2v41 */
    /* JADX WARN: Type inference failed for: r2v42 */
    /* JADX WARN: Type inference failed for: r2v43 */
    /* JADX WARN: Type inference failed for: r2v44 */
    /* JADX WARN: Type inference failed for: r2v45 */
    /* JADX WARN: Type inference failed for: r2v46 */
    /* JADX WARN: Type inference failed for: r2v7 */
    /* JADX WARN: Type inference failed for: r2v8, types: [java.io.Closeable] */
    /*
        Code decompiled incorrectly, please refer to instructions dump.
        To view partially-correct code enable 'Show inconsistent code' option in preferences
    */
    static java.util.List<com.facebook.Response> fromHttpConnection(java.net.HttpURLConnection r9, com.facebook.RequestBatch r10) {
        /*
            Method dump skipped, instructions count: 339
            To view this dump change 'Code comments level' option to 'DEBUG'
        */
        throw new UnsupportedOperationException("Method not decompiled: com.facebook.Response.fromHttpConnection(java.net.HttpURLConnection, com.facebook.RequestBatch):java.util.List");
    }

    static FileLruCache getResponseCache() {
        Context staticContext;
        if (responseCache == null && (staticContext = Session.getStaticContext()) != null) {
            responseCache = new FileLruCache(staticContext, RESPONSE_CACHE_TAG, new FileLruCache.Limits());
        }
        return responseCache;
    }

    public final HttpURLConnection getConnection() {
        return this.connection;
    }

    public final FacebookRequestError getError() {
        return this.error;
    }

    public final GraphObject getGraphObject() {
        return this.graphObject;
    }

    public final <T extends GraphObject> T getGraphObjectAs(Class<T> cls) {
        if (this.graphObject == null) {
            return null;
        }
        if (cls == null) {
            throw new NullPointerException("Must pass in a valid interface that extends GraphObject");
        }
        return (T) this.graphObject.cast(cls);
    }

    public final GraphObjectList<GraphObject> getGraphObjectList() {
        return this.graphObjectList;
    }

    public final <T extends GraphObject> GraphObjectList<T> getGraphObjectListAs(Class<T> cls) {
        if (this.graphObjectList == null) {
            return null;
        }
        return (GraphObjectList<T>) this.graphObjectList.castToListOf(cls);
    }

    public final boolean getIsFromCache() {
        return this.isFromCache;
    }

    public Request getRequest() {
        return this.request;
    }

    public Request getRequestForPagedResults(PagingDirection pagingDirection) {
        PagingInfo paging;
        String next = (this.graphObject == null || (paging = ((PagedResults) this.graphObject.cast(PagedResults.class)).getPaging()) == null) ? null : pagingDirection == PagingDirection.NEXT ? paging.getNext() : paging.getPrevious();
        if (Utility.isNullOrEmpty(next)) {
            return null;
        }
        if (next != null && next.equals(this.request.getUrlForSingleRequest())) {
            return null;
        }
        try {
            return new Request(this.request.getSession(), new URL(next));
        } catch (MalformedURLException e) {
            return null;
        }
    }

    public String toString() {
        String str;
        try {
            Object[] objArr = new Object[1];
            objArr[0] = Integer.valueOf(this.connection != null ? this.connection.getResponseCode() : 200);
            str = String.format("%d", objArr);
        } catch (IOException e) {
            str = EnvironmentCompat.MEDIA_UNKNOWN;
        }
        return "{Response:  responseCode: " + str + ", graphObject: " + this.graphObject + ", error: " + this.error + ", isFromCache:" + this.isFromCache + "}";
    }
}
