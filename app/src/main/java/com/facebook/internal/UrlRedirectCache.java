package com.facebook.internal;

import android.content.Context;
import com.facebook.LoggingBehavior;
import com.facebook.internal.FileLruCache;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.URI;
import java.net.URISyntaxException;

/* loaded from: classes.dex */
class UrlRedirectCache {
    private static volatile FileLruCache urlRedirectCache;
    static final String TAG = UrlRedirectCache.class.getSimpleName();
    private static final String REDIRECT_CONTENT_TAG = TAG + "_Redirect";

    UrlRedirectCache() {
    }

    static void cacheUriRedirect(Context context, URI uri, URI uri2) throws Throwable {
        OutputStream outputStream;
        Throwable th;
        OutputStream outputStreamOpenPutStream;
        if (uri == null || uri2 == null) {
            return;
        }
        try {
            try {
                outputStreamOpenPutStream = getCache(context).openPutStream(uri.toString(), REDIRECT_CONTENT_TAG);
            } catch (Throwable th2) {
                outputStream = null;
                th = th2;
            }
            try {
                outputStreamOpenPutStream.write(uri2.toString().getBytes());
                Utility.closeQuietly(outputStreamOpenPutStream);
            } catch (Throwable th3) {
                outputStream = outputStreamOpenPutStream;
                th = th3;
                Utility.closeQuietly(outputStream);
                throw th;
            }
        } catch (IOException e) {
            Utility.closeQuietly(null);
        }
    }

    static void clearCache(Context context) {
        try {
            getCache(context).clearCache();
        } catch (IOException e) {
            Logger.log(LoggingBehavior.CACHE, 5, TAG, "clearCache failed " + e.getMessage());
        }
    }

    static synchronized FileLruCache getCache(Context context) throws IOException {
        if (urlRedirectCache == null) {
            urlRedirectCache = new FileLruCache(context.getApplicationContext(), TAG, new FileLruCache.Limits());
        }
        return urlRedirectCache;
    }

    static URI getRedirectedUri(Context context, URI uri) throws Throwable {
        InputStreamReader inputStreamReader;
        InputStreamReader inputStreamReader2;
        InputStreamReader inputStreamReader3;
        String string;
        boolean z;
        InputStreamReader inputStreamReader4;
        if (uri == null) {
            return null;
        }
        String string2 = uri.toString();
        try {
            FileLruCache cache = getCache(context);
            string = string2;
            z = false;
            inputStreamReader4 = null;
            while (true) {
                try {
                    InputStream inputStream = cache.get(string, REDIRECT_CONTENT_TAG);
                    if (inputStream == null) {
                        break;
                    }
                    z = true;
                    InputStreamReader inputStreamReader5 = new InputStreamReader(inputStream);
                    try {
                        char[] cArr = new char[128];
                        StringBuilder sb = new StringBuilder();
                        while (true) {
                            int i = inputStreamReader5.read(cArr, 0, cArr.length);
                            if (i <= 0) {
                                break;
                            }
                            sb.append(cArr, 0, i);
                        }
                        Utility.closeQuietly(inputStreamReader5);
                        string = sb.toString();
                        inputStreamReader4 = inputStreamReader5;
                    } catch (IOException e) {
                        inputStreamReader3 = inputStreamReader5;
                        Utility.closeQuietly(inputStreamReader3);
                        return null;
                    } catch (URISyntaxException e2) {
                        inputStreamReader2 = inputStreamReader5;
                        Utility.closeQuietly(inputStreamReader2);
                        return null;
                    } catch (Throwable th) {
                        th = th;
                        inputStreamReader = inputStreamReader5;
                        Utility.closeQuietly(inputStreamReader);
                        throw th;
                    }
                } catch (IOException e3) {
                    inputStreamReader3 = inputStreamReader4;
                } catch (URISyntaxException e4) {
                    inputStreamReader2 = inputStreamReader4;
                } catch (Throwable th2) {
                    th = th2;
                    inputStreamReader = inputStreamReader4;
                }
            }
        } catch (IOException e5) {
            inputStreamReader3 = null;
        } catch (URISyntaxException e6) {
            inputStreamReader2 = null;
        } catch (Throwable th3) {
            th = th3;
            inputStreamReader = null;
        }
        if (!z) {
            Utility.closeQuietly(inputStreamReader4);
            return null;
        }
        URI uri2 = new URI(string);
        Utility.closeQuietly(inputStreamReader4);
        return uri2;
    }
}
