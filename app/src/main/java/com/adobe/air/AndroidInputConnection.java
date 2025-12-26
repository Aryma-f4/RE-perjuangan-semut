package com.adobe.air;

import android.R;
import android.text.Editable;
import android.view.inputmethod.BaseInputConnection;
import android.view.inputmethod.ExtractedText;
import android.view.inputmethod.ExtractedTextRequest;
import android.view.inputmethod.InputMethodManager;
import com.adobe.air.utils.AIRLogger;

/* loaded from: classes.dex */
public class AndroidInputConnection extends BaseInputConnection {
    private static final String LOG_TAG = "AndroidInputConnection";
    private CharSequence mComposedText;
    private ExtractedTextRequest mExtractRequest;
    private ExtractedText mExtractedText;
    private final AIRWindowSurfaceView mWindowSurfaceView;

    private native String nativeGetTextAfterCursor(int i);

    private native String nativeGetTextBeforeCursor(int i);

    private native int nativeGetTextBoxMaxChars();

    private native void nativeSetSelection(int i, int i2);

    public AndroidInputConnection(AIRWindowSurfaceView aIRWindowSurfaceView) {
        super(aIRWindowSurfaceView, true);
        this.mExtractRequest = null;
        this.mComposedText = null;
        this.mExtractedText = null;
        this.mWindowSurfaceView = aIRWindowSurfaceView;
    }

    @Override // android.view.inputmethod.BaseInputConnection, android.view.inputmethod.InputConnection
    public boolean deleteSurroundingText(int i, int i2) {
        for (int i3 = 0; i3 < i2; i3++) {
            AIRLogger.d(LOG_TAG, "[JP] deleteSurroundingText ");
            this.mWindowSurfaceView.nativeOnKeyListener(0, 22, 0, false, false, false);
            this.mWindowSurfaceView.nativeOnKeyListener(1, 22, 0, false, false, false);
        }
        int i4 = i2 + i;
        for (int i5 = 0; i5 < i4; i5++) {
            AIRLogger.d(LOG_TAG, "[JP] deleteSurroundingText 2 ");
            this.mWindowSurfaceView.nativeOnKeyListener(0, 67, 0, false, false, false);
            this.mWindowSurfaceView.nativeOnKeyListener(1, 67, 0, false, false, false);
        }
        return true;
    }

    @Override // android.view.inputmethod.BaseInputConnection, android.view.inputmethod.InputConnection
    public CharSequence getTextAfterCursor(int i, int i2) {
        return nativeGetTextAfterCursor(i);
    }

    @Override // android.view.inputmethod.BaseInputConnection, android.view.inputmethod.InputConnection
    public CharSequence getTextBeforeCursor(int i, int i2) {
        return nativeGetTextBeforeCursor(i);
    }

    @Override // android.view.inputmethod.BaseInputConnection, android.view.inputmethod.InputConnection
    public ExtractedText getExtractedText(ExtractedTextRequest extractedTextRequest, int i) {
        this.mWindowSurfaceView.setInputConnection(this);
        ExtractedText extractedTextNativeGetTextContent = this.mWindowSurfaceView.nativeGetTextContent();
        if (extractedTextNativeGetTextContent == null || extractedTextNativeGetTextContent.text == null) {
            return null;
        }
        extractedTextNativeGetTextContent.partialEndOffset = -1;
        extractedTextNativeGetTextContent.partialStartOffset = -1;
        if ((i & 1) != 0) {
            extractedTextNativeGetTextContent.startOffset = 0;
            this.mExtractedText = extractedTextNativeGetTextContent;
            this.mExtractRequest = extractedTextRequest;
            this.mWindowSurfaceView.nativeShowOriginalRect();
            return extractedTextNativeGetTextContent;
        }
        return extractedTextNativeGetTextContent;
    }

    @Override // android.view.inputmethod.BaseInputConnection
    public Editable getEditable() {
        return null;
    }

    @Override // android.view.inputmethod.BaseInputConnection, android.view.inputmethod.InputConnection
    public boolean performEditorAction(int i) {
        if (i != 6) {
            return false;
        }
        this.mWindowSurfaceView.showSoftKeyboard(false);
        this.mWindowSurfaceView.nativeDispatchUserTriggeredSkDeactivateEvent();
        return true;
    }

    @Override // android.view.inputmethod.BaseInputConnection, android.view.inputmethod.InputConnection
    public boolean performContextMenuAction(int i) {
        int i2 = 0;
        switch (i) {
            case R.id.selectAll:
                break;
            case R.id.cut:
                if (this.mWindowSurfaceView.nativeIsTextSelected()) {
                    i2 = 1;
                    break;
                } else {
                    i2 = 2;
                    break;
                }
            case R.id.copy:
                if (this.mWindowSurfaceView.nativeIsTextSelected()) {
                    i2 = 3;
                    break;
                } else {
                    i2 = 4;
                    break;
                }
            case R.id.paste:
                i2 = 5;
                break;
            case R.id.copyUrl:
            case R.id.inputExtractEditText:
            case R.id.keyboardView:
            case R.id.closeButton:
            default:
                return false;
            case R.id.switchInputMethod:
                i2 = 6;
                break;
            case R.id.startSelectingText:
                i2 = 7;
                break;
            case R.id.stopSelectingText:
                i2 = 8;
                break;
        }
        return this.mWindowSurfaceView.onTextBoxContextMenuItem(i2);
    }

    @Override // android.view.inputmethod.BaseInputConnection, android.view.inputmethod.InputConnection
    public boolean setComposingRegion(int i, int i2) {
        this.mComposedText = this.mWindowSurfaceView.nativeGetTextContent().text.subSequence(i, i2);
        return true;
    }

    @Override // android.view.inputmethod.BaseInputConnection, android.view.inputmethod.InputConnection
    public boolean setComposingText(CharSequence charSequence, int i) {
        CharSequence charSequenceSubSequence;
        int iNativeGetTextBoxMaxChars = nativeGetTextBoxMaxChars();
        if (iNativeGetTextBoxMaxChars == 0 || charSequence.length() <= 0) {
            charSequenceSubSequence = charSequence;
        } else {
            ExtractedText extractedTextNativeGetTextContent = this.mWindowSurfaceView.nativeGetTextContent();
            int length = ((iNativeGetTextBoxMaxChars - extractedTextNativeGetTextContent.text.length()) + extractedTextNativeGetTextContent.selectionEnd) - extractedTextNativeGetTextContent.selectionStart;
            int length2 = 0;
            if (this.mComposedText != null) {
                length2 = this.mComposedText.length();
            }
            int iMin = Math.min(length + length2, charSequence.length());
            if (iMin > 0) {
                charSequenceSubSequence = charSequence.subSequence(0, iMin);
            } else {
                charSequenceSubSequence = null;
            }
        }
        if (charSequenceSubSequence != null) {
            AIRLogger.d(LOG_TAG, "[JP] setComposingText " + ((Object) charSequenceSubSequence));
            writeText(charSequenceSubSequence);
            this.mComposedText = charSequenceSubSequence;
            if (i <= 0) {
                int length3 = charSequenceSubSequence.length() + Math.abs(i);
                for (int i2 = 0; i2 < length3; i2++) {
                    AIRLogger.d(LOG_TAG, "[JP] setComposingText " + ((Object) charSequenceSubSequence));
                    this.mWindowSurfaceView.nativeOnKeyListener(0, 21, 0, false, false, false);
                    this.mWindowSurfaceView.nativeOnKeyListener(1, 21, 0, false, false, false);
                }
                return true;
            }
            if (i > 1) {
                int i3 = i - 1;
                for (int i4 = 0; i4 < i3; i4++) {
                    AIRLogger.d(LOG_TAG, "[JP] setComposingText 2 " + ((Object) charSequenceSubSequence));
                    this.mWindowSurfaceView.nativeOnKeyListener(0, 22, 0, false, false, false);
                    this.mWindowSurfaceView.nativeOnKeyListener(1, 22, 0, false, false, false);
                }
                return true;
            }
            return true;
        }
        return true;
    }

    @Override // android.view.inputmethod.BaseInputConnection, android.view.inputmethod.InputConnection
    public boolean finishComposingText() {
        this.mComposedText = null;
        if (this.mWindowSurfaceView.getIsFullScreen() && !this.mWindowSurfaceView.IsSurfaceChangedForSoftKeyboard()) {
            this.mWindowSurfaceView.nativeShowOriginalRect();
            return true;
        }
        return true;
    }

    @Override // android.view.inputmethod.BaseInputConnection, android.view.inputmethod.InputConnection
    public boolean setSelection(int i, int i2) {
        nativeSetSelection(i, i2);
        return true;
    }

    @Override // android.view.inputmethod.BaseInputConnection, android.view.inputmethod.InputConnection
    public boolean commitText(CharSequence charSequence, int i) {
        AIRLogger.d(LOG_TAG, "[JP] setComposingText " + ((Object) charSequence));
        writeText(charSequence);
        this.mComposedText = null;
        return true;
    }

    private void writeText(CharSequence charSequence) {
        int i;
        int length = charSequence.length();
        if (this.mComposedText == null) {
            i = 0;
        } else {
            int length2 = this.mComposedText.length();
            int iMin = Math.min(length, length2);
            int i2 = 0;
            while (i2 < iMin && charSequence.charAt(i2) == this.mComposedText.charAt(i2)) {
                i2++;
            }
            for (int i3 = i2; i3 < length2; i3++) {
                AIRLogger.d(LOG_TAG, "[JP] writeText " + ((Object) charSequence));
                this.mWindowSurfaceView.nativeOnKeyListener(0, 67, 0, false, false, false);
                this.mWindowSurfaceView.nativeOnKeyListener(1, 67, 0, false, false, false);
            }
            i = i2;
        }
        while (i < length) {
            AIRLogger.d(LOG_TAG, "[JP] writeText 2 " + ((Object) charSequence));
            this.mWindowSurfaceView.nativeOnKeyListener(0, 0, charSequence.charAt(i), false, false, false);
            this.mWindowSurfaceView.nativeOnKeyListener(1, 0, charSequence.charAt(i), false, false, false);
            i++;
        }
        updateIMEText();
    }

    public void updateIMEText() {
        InputMethodManager inputMethodManager;
        if (this.mExtractRequest != null && (inputMethodManager = this.mWindowSurfaceView.getInputMethodManager()) != null && inputMethodManager.isActive(this.mWindowSurfaceView)) {
            ExtractedText extractedTextNativeGetTextContent = this.mWindowSurfaceView.nativeGetTextContent();
            boolean zEquals = extractedTextNativeGetTextContent.text.toString().equals(this.mExtractedText.text.toString());
            if (!zEquals || extractedTextNativeGetTextContent.selectionStart != this.mExtractedText.selectionStart || extractedTextNativeGetTextContent.selectionEnd != this.mExtractedText.selectionEnd || extractedTextNativeGetTextContent.flags != this.mExtractedText.flags) {
                extractedTextNativeGetTextContent.startOffset = 0;
                if (zEquals) {
                    extractedTextNativeGetTextContent.partialStartOffset = 0;
                    extractedTextNativeGetTextContent.partialEndOffset = 0;
                    extractedTextNativeGetTextContent.text = "";
                    this.mExtractedText.flags = extractedTextNativeGetTextContent.flags;
                    this.mExtractedText.selectionStart = extractedTextNativeGetTextContent.selectionStart;
                    this.mExtractedText.selectionEnd = extractedTextNativeGetTextContent.selectionEnd;
                } else {
                    extractedTextNativeGetTextContent.partialStartOffset = -1;
                    extractedTextNativeGetTextContent.partialEndOffset = -1;
                    this.mExtractedText = extractedTextNativeGetTextContent;
                }
                inputMethodManager.updateExtractedText(this.mWindowSurfaceView, this.mExtractRequest.token, extractedTextNativeGetTextContent);
            }
        }
    }

    public void Reset() {
        this.mComposedText = null;
        this.mExtractRequest = null;
        this.mExtractedText = null;
    }
}
