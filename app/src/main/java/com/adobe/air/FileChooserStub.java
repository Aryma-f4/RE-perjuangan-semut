package com.adobe.air;

import android.app.Activity;
import com.facebook.widget.FacebookDialog;
import java.util.ArrayList;
import java.util.concurrent.locks.Condition;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

/* loaded from: classes.dex */
public class FileChooserStub {
    public static final String TAG = FileChooserStub.class.toString();
    private AIRExpandableFileChooser fileChooser;
    private ArrayList<String> m_filenames = null;
    private String m_userAction = null;
    private ArrayList<String> m_filterList = new ArrayList<>();
    private Lock m_lock = new ReentrantLock();
    private Condition m_condition = this.m_lock.newCondition();

    public void show(final String str, final boolean z, final boolean z2) {
        AndroidActivityWrapper androidActivityWrapperGetAndroidActivityWrapper = AndroidActivityWrapper.GetAndroidActivityWrapper();
        Activity activity = androidActivityWrapperGetAndroidActivityWrapper.getActivity();
        (activity == null ? androidActivityWrapperGetAndroidActivityWrapper.WaitForNewActivity() : activity).runOnUiThread(new Runnable() { // from class: com.adobe.air.FileChooserStub.1
            @Override // java.lang.Runnable
            public void run() {
                FileChooserStub.this.fileChooser = new AIRExpandableFileChooser(FileChooserStub.this.m_filterList, z, z2, str, this);
                FileChooserStub.this.fileChooser.GetDialog().show();
            }
        });
        this.m_lock.lock();
        try {
            if (this.m_userAction == null) {
                this.m_condition.await();
            }
        } catch (InterruptedException e) {
        } finally {
            this.m_lock.unlock();
        }
        this.m_filenames = this.fileChooser.GetFileNames();
        if (this.m_filenames != null) {
            for (int i = 0; i < this.m_filenames.size(); i++) {
            }
        }
    }

    public void addFilter(String str) {
        this.m_filterList.add(str);
    }

    public void SetUserAction(String str) {
        this.m_lock.lock();
        this.m_userAction = str;
        this.m_condition.signal();
        this.m_lock.unlock();
    }

    public int getNumFilenames() {
        return this.m_filenames.size();
    }

    public String getFilename(int i) {
        if (i >= this.m_filenames.size()) {
            return null;
        }
        return this.m_filenames.get(i);
    }

    public boolean userCancelled() {
        return this.m_userAction == null || this.m_userAction.equals(FacebookDialog.COMPLETION_GESTURE_CANCEL);
    }
}
