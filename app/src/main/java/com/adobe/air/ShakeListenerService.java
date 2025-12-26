package com.adobe.air;

import android.app.ActivityManager;
import android.app.IntentService;
import android.content.ComponentName;
import android.content.Intent;
import com.adobe.air.ShakeListener;
import com.adobe.air.wand.WandActivity;
import java.util.List;

/* loaded from: classes.dex */
public class ShakeListenerService extends IntentService {
    private final String AIR_WAND_CLASS_NAME;
    private ShakeListener mShakeListener;

    public ShakeListenerService() {
        super("ShakeListenerService");
        this.AIR_WAND_CLASS_NAME = "com.adobe.air.wand.WandActivity";
    }

    @Override // android.app.IntentService
    protected void onHandleIntent(Intent intent) {
        try {
            this.mShakeListener = new ShakeListener(this);
            this.mShakeListener.registerListener(new ShakeListener.Listener() { // from class: com.adobe.air.ShakeListenerService.1
                @Override // com.adobe.air.ShakeListener.Listener
                public void onShake() throws SecurityException {
                    List<ActivityManager.RunningTaskInfo> runningTasks = ((ActivityManager) ShakeListenerService.this.getApplicationContext().getSystemService("activity")).getRunningTasks(1);
                    if (!runningTasks.isEmpty()) {
                        ComponentName componentName = runningTasks.get(0).topActivity;
                        if (componentName.getPackageName().equals(ShakeListenerService.this.getApplicationContext().getPackageName()) && !componentName.getClassName().equalsIgnoreCase("com.adobe.air.wand.WandActivity")) {
                            Intent intent2 = new Intent(ShakeListenerService.this.getApplicationContext(), (Class<?>) WandActivity.class);
                            intent2.setFlags(272629760);
                            ShakeListenerService.this.startActivity(intent2);
                        }
                    }
                }
            });
        } catch (Exception e) {
        }
    }
}
