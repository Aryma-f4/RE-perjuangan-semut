package com.facebook;

/* loaded from: classes.dex */
public enum SessionState {
    CREATED(Category.CREATED_CATEGORY),
    CREATED_TOKEN_LOADED(Category.CREATED_CATEGORY),
    OPENING(Category.CREATED_CATEGORY),
    OPENED(Category.OPENED_CATEGORY),
    OPENED_TOKEN_UPDATED(Category.OPENED_CATEGORY),
    CLOSED_LOGIN_FAILED(Category.CLOSED_CATEGORY),
    CLOSED(Category.CLOSED_CATEGORY);

    private final Category category;

    private enum Category {
        CREATED_CATEGORY,
        OPENED_CATEGORY,
        CLOSED_CATEGORY
    }

    SessionState(Category category) {
        this.category = category;
    }

    public boolean isClosed() {
        return this.category == Category.CLOSED_CATEGORY;
    }

    public boolean isOpened() {
        return this.category == Category.OPENED_CATEGORY;
    }
}
