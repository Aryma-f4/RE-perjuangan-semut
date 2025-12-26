package com.google.android.gms.common.images;

import android.app.ActivityManager;
import android.content.ComponentCallbacks2;
import android.content.Context;
import android.content.Intent;
import android.content.res.Configuration;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.os.ParcelFileDescriptor;
import android.os.ResultReceiver;
import android.support.v4.view.accessibility.AccessibilityEventCompat;
import android.util.Log;
import android.widget.ImageView;
import com.google.android.gms.common.images.a;
import com.google.android.gms.internal.as;
import com.google.android.gms.internal.h;
import com.google.android.gms.internal.w;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

/* loaded from: classes.dex */
public final class ImageManager {
    private static final Object aq = new Object();
    private static HashSet<Uri> ar = new HashSet<>();
    private static ImageManager as;
    private static ImageManager at;
    private final b av;
    private final Map<com.google.android.gms.common.images.a, ImageReceiver> aw;
    private final Map<Uri, ImageReceiver> ax;
    private final Context mContext;
    private final Handler mHandler = new Handler(Looper.getMainLooper());
    private final ExecutorService au = Executors.newFixedThreadPool(4);

    private final class ImageReceiver extends ResultReceiver {
        private final ArrayList<com.google.android.gms.common.images.a> ay;
        boolean az;
        private final Uri mUri;

        ImageReceiver(Uri uri) {
            super(new Handler(Looper.getMainLooper()));
            this.az = false;
            this.mUri = uri;
            this.ay = new ArrayList<>();
        }

        public void c(com.google.android.gms.common.images.a aVar) {
            h.a(!this.az, "Cannot add an ImageRequest when mHandlingRequests is true");
            h.f("ImageReceiver.addImageRequest() must be called in the main thread");
            this.ay.add(aVar);
        }

        public void d(com.google.android.gms.common.images.a aVar) {
            h.a(!this.az, "Cannot remove an ImageRequest when mHandlingRequests is true");
            h.f("ImageReceiver.removeImageRequest() must be called in the main thread");
            this.ay.remove(aVar);
        }

        @Override // android.os.ResultReceiver
        public void onReceiveResult(int resultCode, Bundle resultData) {
            ImageManager.this.au.execute(ImageManager.this.new c(this.mUri, (ParcelFileDescriptor) resultData.getParcelable("com.google.android.gms.extra.fileDescriptor")));
        }

        public void q() {
            Intent intent = new Intent("com.google.android.gms.common.images.LOAD_IMAGE");
            intent.putExtra("com.google.android.gms.extras.uri", this.mUri);
            intent.putExtra("com.google.android.gms.extras.resultReceiver", this);
            intent.putExtra("com.google.android.gms.extras.priority", 3);
            ImageManager.this.mContext.sendBroadcast(intent);
        }
    }

    public interface OnImageLoadedListener {
        void onImageLoaded(Uri uri, Drawable drawable);
    }

    private static final class a {
        static int a(ActivityManager activityManager) {
            return activityManager.getLargeMemoryClass();
        }
    }

    private static final class b extends w<a.C0002a, Bitmap> {
        public b(Context context) {
            super(e(context));
        }

        private static int e(Context context) {
            ActivityManager activityManager = (ActivityManager) context.getSystemService("activity");
            return (int) (((((context.getApplicationInfo().flags & AccessibilityEventCompat.TYPE_TOUCH_INTERACTION_START) != 0) && as.an()) ? a.a(activityManager) : activityManager.getMemoryClass()) * AccessibilityEventCompat.TYPE_TOUCH_INTERACTION_START * 0.33f);
        }

        /* JADX INFO: Access modifiers changed from: protected */
        @Override // com.google.android.gms.internal.w
        /* renamed from: a, reason: merged with bridge method [inline-methods] */
        public int sizeOf(a.C0002a c0002a, Bitmap bitmap) {
            return bitmap.getHeight() * bitmap.getRowBytes();
        }

        /* JADX INFO: Access modifiers changed from: protected */
        @Override // com.google.android.gms.internal.w
        /* renamed from: a, reason: merged with bridge method [inline-methods] */
        public void entryRemoved(boolean z, a.C0002a c0002a, Bitmap bitmap, Bitmap bitmap2) {
            super.entryRemoved(z, c0002a, bitmap, bitmap2);
        }
    }

    private final class c implements Runnable {
        private final ParcelFileDescriptor aB;
        private final Uri mUri;

        public c(Uri uri, ParcelFileDescriptor parcelFileDescriptor) {
            this.mUri = uri;
            this.aB = parcelFileDescriptor;
        }

        @Override // java.lang.Runnable
        public void run() throws InterruptedException, IOException {
            Bitmap bitmapDecodeFileDescriptor;
            boolean z;
            Bitmap bitmap;
            boolean z2;
            h.g("LoadBitmapFromDiskRunnable can't be executed in the main thread");
            if (this.aB != null) {
                try {
                    z = false;
                    bitmapDecodeFileDescriptor = BitmapFactory.decodeFileDescriptor(this.aB.getFileDescriptor());
                } catch (OutOfMemoryError e) {
                    Log.e("ImageManager", "OOM while loading bitmap for uri: " + this.mUri, e);
                    bitmapDecodeFileDescriptor = null;
                    z = true;
                }
                try {
                    this.aB.close();
                    bitmap = bitmapDecodeFileDescriptor;
                    z2 = z;
                } catch (IOException e2) {
                    Log.e("ImageManager", "closed failed", e2);
                    bitmap = bitmapDecodeFileDescriptor;
                    z2 = z;
                }
            } else {
                bitmap = null;
                z2 = false;
            }
            CountDownLatch countDownLatch = new CountDownLatch(1);
            ImageManager.this.mHandler.post(ImageManager.this.new f(this.mUri, bitmap, z2, countDownLatch));
            try {
                countDownLatch.await();
            } catch (InterruptedException e3) {
                Log.w("ImageManager", "Latch interrupted while posting " + this.mUri);
            }
        }
    }

    private final class d implements Runnable {
        private final com.google.android.gms.common.images.a aC;

        public d(com.google.android.gms.common.images.a aVar) {
            this.aC = aVar;
        }

        @Override // java.lang.Runnable
        public void run() {
            h.f("LoadImageRunnable must be executed on the main thread");
            ImageManager.this.b(this.aC);
            a.C0002a c0002a = this.aC.aG;
            if (c0002a.uri == null) {
                this.aC.b(ImageManager.this.mContext, true);
                return;
            }
            Bitmap bitmapA = ImageManager.this.a(c0002a);
            if (bitmapA != null) {
                this.aC.a(ImageManager.this.mContext, bitmapA, true);
                return;
            }
            this.aC.f(ImageManager.this.mContext);
            ImageReceiver imageReceiver = (ImageReceiver) ImageManager.this.ax.get(c0002a.uri);
            if (imageReceiver == null) {
                imageReceiver = ImageManager.this.new ImageReceiver(c0002a.uri);
                ImageManager.this.ax.put(c0002a.uri, imageReceiver);
            }
            imageReceiver.c(this.aC);
            if (this.aC.aJ != 1) {
                ImageManager.this.aw.put(this.aC, imageReceiver);
            }
            synchronized (ImageManager.aq) {
                if (!ImageManager.ar.contains(c0002a.uri)) {
                    ImageManager.ar.add(c0002a.uri);
                    imageReceiver.q();
                }
            }
        }
    }

    private static final class e implements ComponentCallbacks2 {
        private final b av;

        public e(b bVar) {
            this.av = bVar;
        }

        @Override // android.content.ComponentCallbacks
        public void onConfigurationChanged(Configuration newConfig) {
        }

        @Override // android.content.ComponentCallbacks
        public void onLowMemory() {
            this.av.evictAll();
        }

        @Override // android.content.ComponentCallbacks2
        public void onTrimMemory(int level) {
            if (level >= 60) {
                this.av.evictAll();
            } else if (level >= 20) {
                this.av.trimToSize(this.av.size() / 2);
            }
        }
    }

    private final class f implements Runnable {
        private final Bitmap aD;
        private final CountDownLatch aE;
        private boolean aF;
        private final Uri mUri;

        public f(Uri uri, Bitmap bitmap, boolean z, CountDownLatch countDownLatch) {
            this.mUri = uri;
            this.aD = bitmap;
            this.aF = z;
            this.aE = countDownLatch;
        }

        private void a(ImageReceiver imageReceiver, boolean z) {
            imageReceiver.az = true;
            ArrayList arrayList = imageReceiver.ay;
            int size = arrayList.size();
            for (int i = 0; i < size; i++) {
                com.google.android.gms.common.images.a aVar = (com.google.android.gms.common.images.a) arrayList.get(i);
                if (z) {
                    aVar.a(ImageManager.this.mContext, this.aD, false);
                } else {
                    aVar.b(ImageManager.this.mContext, false);
                }
                if (aVar.aJ != 1) {
                    ImageManager.this.aw.remove(aVar);
                }
            }
            imageReceiver.az = false;
        }

        @Override // java.lang.Runnable
        public void run() {
            h.f("OnBitmapLoadedRunnable must be executed in the main thread");
            boolean z = this.aD != null;
            if (ImageManager.this.av != null) {
                if (this.aF) {
                    ImageManager.this.av.evictAll();
                    System.gc();
                    this.aF = false;
                    ImageManager.this.mHandler.post(this);
                    return;
                }
                if (z) {
                    ImageManager.this.av.put(new a.C0002a(this.mUri), this.aD);
                }
            }
            ImageReceiver imageReceiver = (ImageReceiver) ImageManager.this.ax.remove(this.mUri);
            if (imageReceiver != null) {
                a(imageReceiver, z);
            }
            this.aE.countDown();
            synchronized (ImageManager.aq) {
                ImageManager.ar.remove(this.mUri);
            }
        }
    }

    private ImageManager(Context context, boolean withMemoryCache) {
        this.mContext = context.getApplicationContext();
        if (withMemoryCache) {
            this.av = new b(this.mContext);
            if (as.aq()) {
                n();
            }
        } else {
            this.av = null;
        }
        this.aw = new HashMap();
        this.ax = new HashMap();
    }

    /* JADX INFO: Access modifiers changed from: private */
    public Bitmap a(a.C0002a c0002a) {
        if (this.av == null) {
            return null;
        }
        return this.av.get(c0002a);
    }

    public static ImageManager a(Context context, boolean z) {
        if (z) {
            if (at == null) {
                at = new ImageManager(context, true);
            }
            return at;
        }
        if (as == null) {
            as = new ImageManager(context, false);
        }
        return as;
    }

    /* JADX INFO: Access modifiers changed from: private */
    public boolean b(com.google.android.gms.common.images.a aVar) {
        ImageReceiver imageReceiver;
        h.f("ImageManager.cleanupHashMaps() must be called in the main thread");
        if (aVar.aJ != 1 && (imageReceiver = this.aw.get(aVar)) != null) {
            if (imageReceiver.az) {
                return false;
            }
            this.aw.remove(aVar);
            imageReceiver.d(aVar);
            return true;
        }
        return true;
    }

    public static ImageManager create(Context context) {
        return a(context, false);
    }

    private void n() {
        this.mContext.registerComponentCallbacks(new e(this.av));
    }

    public void a(com.google.android.gms.common.images.a aVar) {
        h.f("ImageManager.loadImage() must be called in the main thread");
        boolean zB = b(aVar);
        d dVar = new d(aVar);
        if (zB) {
            dVar.run();
        } else {
            this.mHandler.post(dVar);
        }
    }

    public void loadImage(ImageView imageView, int resId) {
        com.google.android.gms.common.images.a aVar = new com.google.android.gms.common.images.a(resId);
        aVar.a(imageView);
        a(aVar);
    }

    public void loadImage(ImageView imageView, Uri uri) {
        com.google.android.gms.common.images.a aVar = new com.google.android.gms.common.images.a(uri);
        aVar.a(imageView);
        a(aVar);
    }

    public void loadImage(ImageView imageView, Uri uri, int defaultResId) {
        com.google.android.gms.common.images.a aVar = new com.google.android.gms.common.images.a(uri);
        aVar.j(defaultResId);
        aVar.a(imageView);
        a(aVar);
    }

    public void loadImage(OnImageLoadedListener listener, Uri uri) {
        com.google.android.gms.common.images.a aVar = new com.google.android.gms.common.images.a(uri);
        aVar.a(listener);
        a(aVar);
    }

    public void loadImage(OnImageLoadedListener listener, Uri uri, int defaultResId) {
        com.google.android.gms.common.images.a aVar = new com.google.android.gms.common.images.a(uri);
        aVar.j(defaultResId);
        aVar.a(listener);
        a(aVar);
    }
}
