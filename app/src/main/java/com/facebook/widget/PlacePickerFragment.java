package com.facebook.widget;

import android.app.Activity;
import android.content.res.TypedArray;
import android.location.Location;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.util.AttributeSet;
import android.view.ViewGroup;
import android.view.inputmethod.InputMethodManager;
import android.widget.EditText;
import android.widget.ListView;
import com.facebook.AppEventsLogger;
import com.facebook.FacebookException;
import com.facebook.LoggingBehavior;
import com.facebook.Request;
import com.facebook.Session;
import com.facebook.internal.AnalyticsEvents;
import com.facebook.internal.Logger;
import com.facebook.internal.Utility;
import com.facebook.model.GraphPlace;
import com.facebook.widget.GraphObjectAdapter;
import com.facebook.widget.PickerFragment;
import com.freshplanet.ane.AirFacebook.AirFacebookExtension;
import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.Timer;
import java.util.TimerTask;

/* loaded from: classes.dex */
public class PlacePickerFragment extends PickerFragment<GraphPlace> {
    private static final String CATEGORY = "category";
    public static final int DEFAULT_RADIUS_IN_METERS = 1000;
    public static final int DEFAULT_RESULTS_LIMIT = 100;
    private static final String ID = "id";
    private static final String LOCATION = "location";
    public static final String LOCATION_BUNDLE_KEY = "com.facebook.widget.PlacePickerFragment.Location";
    private static final String NAME = "name";
    public static final String RADIUS_IN_METERS_BUNDLE_KEY = "com.facebook.widget.PlacePickerFragment.RadiusInMeters";
    public static final String RESULTS_LIMIT_BUNDLE_KEY = "com.facebook.widget.PlacePickerFragment.ResultsLimit";
    public static final String SEARCH_TEXT_BUNDLE_KEY = "com.facebook.widget.PlacePickerFragment.SearchText";
    public static final String SHOW_SEARCH_BOX_BUNDLE_KEY = "com.facebook.widget.PlacePickerFragment.ShowSearchBox";
    private static final String TAG = "PlacePickerFragment";
    private static final String WERE_HERE_COUNT = "were_here_count";
    private static final int searchTextTimerDelayInMilliseconds = 2000;
    private boolean hasSearchTextChangedSinceLastQuery;
    private Location location;
    private int radiusInMeters;
    private int resultsLimit;
    private EditText searchBox;
    private String searchText;
    private Timer searchTextTimer;
    private boolean showSearchBox;

    private class AsNeededLoadingStrategy extends PickerFragment.LoadingStrategy {
        private AsNeededLoadingStrategy() {
            super();
        }

        @Override // com.facebook.widget.PickerFragment.LoadingStrategy
        public void attach(GraphObjectAdapter<GraphPlace> graphObjectAdapter) {
            super.attach(graphObjectAdapter);
            this.adapter.setDataNeededListener(new GraphObjectAdapter.DataNeededListener() { // from class: com.facebook.widget.PlacePickerFragment.AsNeededLoadingStrategy.1
                @Override // com.facebook.widget.GraphObjectAdapter.DataNeededListener
                public void onDataNeeded() {
                    if (AsNeededLoadingStrategy.this.loader.isLoading()) {
                        return;
                    }
                    AsNeededLoadingStrategy.this.loader.followNextLink();
                }
            });
        }

        @Override // com.facebook.widget.PickerFragment.LoadingStrategy
        protected void onLoadFinished(GraphObjectPagingLoader<GraphPlace> graphObjectPagingLoader, SimpleGraphObjectCursor<GraphPlace> simpleGraphObjectCursor) {
            super.onLoadFinished(graphObjectPagingLoader, simpleGraphObjectCursor);
            if (simpleGraphObjectCursor == null || graphObjectPagingLoader.isLoading()) {
                return;
            }
            PlacePickerFragment.this.hideActivityCircle();
            if (simpleGraphObjectCursor.isFromCache()) {
                graphObjectPagingLoader.refreshOriginalRequest(simpleGraphObjectCursor.areMoreObjectsAvailable() ? 2000L : 0L);
            }
        }
    }

    private class SearchTextWatcher implements TextWatcher {
        private SearchTextWatcher() {
        }

        @Override // android.text.TextWatcher
        public void afterTextChanged(Editable editable) {
        }

        @Override // android.text.TextWatcher
        public void beforeTextChanged(CharSequence charSequence, int i, int i2, int i3) {
        }

        @Override // android.text.TextWatcher
        public void onTextChanged(CharSequence charSequence, int i, int i2, int i3) {
            PlacePickerFragment.this.onSearchBoxTextChanged(charSequence.toString(), false);
        }
    }

    public PlacePickerFragment() {
        this(null);
    }

    public PlacePickerFragment(Bundle bundle) {
        super(GraphPlace.class, AirFacebookExtension.getResourceId("layout.com_facebook_placepickerfragment"), bundle);
        this.radiusInMeters = 1000;
        this.resultsLimit = 100;
        this.showSearchBox = true;
        setPlacePickerSettingsFromBundle(bundle);
    }

    private Request createRequest(Location location, int i, int i2, String str, Set<String> set, Session session) {
        Request requestNewPlacesSearchRequest = Request.newPlacesSearchRequest(session, location, i, i2, str, null);
        HashSet hashSet = new HashSet(set);
        hashSet.addAll(Arrays.asList(ID, NAME, LOCATION, CATEGORY, WERE_HERE_COUNT));
        String pictureFieldSpecifier = this.adapter.getPictureFieldSpecifier();
        if (pictureFieldSpecifier != null) {
            hashSet.add(pictureFieldSpecifier);
        }
        Bundle parameters = requestNewPlacesSearchRequest.getParameters();
        parameters.putString("fields", TextUtils.join(",", hashSet));
        requestNewPlacesSearchRequest.setParameters(parameters);
        return requestNewPlacesSearchRequest;
    }

    private Timer createSearchTextTimer() {
        Timer timer = new Timer();
        timer.schedule(new TimerTask() { // from class: com.facebook.widget.PlacePickerFragment.2
            @Override // java.util.TimerTask, java.lang.Runnable
            public void run() {
                PlacePickerFragment.this.onSearchTextTimerTriggered();
            }
        }, 0L, 2000L);
        return timer;
    }

    /* JADX INFO: Access modifiers changed from: private */
    public void onSearchTextTimerTriggered() {
        if (this.hasSearchTextChangedSinceLastQuery) {
            new Handler(Looper.getMainLooper()).post(new Runnable() { // from class: com.facebook.widget.PlacePickerFragment.3
                /* JADX WARN: Multi-variable type inference failed */
                @Override // java.lang.Runnable
                public void run() {
                    FacebookException facebookException = null;
                    facebookException = null;
                    facebookException = null;
                    facebookException = null;
                    facebookException = null;
                    facebookException = null;
                    try {
                        try {
                            PlacePickerFragment.this.loadData(true);
                            if (0 != 0) {
                                PickerFragment.OnErrorListener onErrorListener = PlacePickerFragment.this.getOnErrorListener();
                                if (onErrorListener != null) {
                                    onErrorListener.onError(PlacePickerFragment.this, null);
                                } else {
                                    Logger.log(LoggingBehavior.REQUESTS, PlacePickerFragment.TAG, "Error loading data : %s", null);
                                }
                            }
                        } catch (FacebookException e) {
                            if (e != null) {
                                PickerFragment.OnErrorListener onErrorListener2 = PlacePickerFragment.this.getOnErrorListener();
                                if (onErrorListener2 != null) {
                                    onErrorListener2.onError(PlacePickerFragment.this, e);
                                } else {
                                    Logger.log(LoggingBehavior.REQUESTS, PlacePickerFragment.TAG, "Error loading data : %s", e);
                                }
                            }
                        } catch (Exception e2) {
                            FacebookException facebookException2 = new FacebookException(e2);
                            if (facebookException2 != null) {
                                PickerFragment.OnErrorListener onErrorListener3 = PlacePickerFragment.this.getOnErrorListener();
                                if (onErrorListener3 != 0) {
                                    onErrorListener3.onError(PlacePickerFragment.this, facebookException2);
                                    facebookException = onErrorListener3;
                                } else {
                                    LoggingBehavior loggingBehavior = LoggingBehavior.REQUESTS;
                                    Logger.log(loggingBehavior, PlacePickerFragment.TAG, "Error loading data : %s", facebookException2);
                                    facebookException = loggingBehavior;
                                }
                            }
                        }
                    } catch (Throwable th) {
                        if (facebookException != null) {
                            PickerFragment.OnErrorListener onErrorListener4 = PlacePickerFragment.this.getOnErrorListener();
                            if (onErrorListener4 != null) {
                                onErrorListener4.onError(PlacePickerFragment.this, facebookException);
                            } else {
                                Logger.log(LoggingBehavior.REQUESTS, PlacePickerFragment.TAG, "Error loading data : %s", facebookException);
                            }
                        }
                        throw th;
                    }
                }
            });
        } else {
            this.searchTextTimer.cancel();
            this.searchTextTimer = null;
        }
    }

    private void setPlacePickerSettingsFromBundle(Bundle bundle) {
        if (bundle != null) {
            setRadiusInMeters(bundle.getInt(RADIUS_IN_METERS_BUNDLE_KEY, this.radiusInMeters));
            setResultsLimit(bundle.getInt(RESULTS_LIMIT_BUNDLE_KEY, this.resultsLimit));
            if (bundle.containsKey(SEARCH_TEXT_BUNDLE_KEY)) {
                setSearchText(bundle.getString(SEARCH_TEXT_BUNDLE_KEY));
            }
            if (bundle.containsKey(LOCATION_BUNDLE_KEY)) {
                setLocation((Location) bundle.getParcelable(LOCATION_BUNDLE_KEY));
            }
            this.showSearchBox = bundle.getBoolean(SHOW_SEARCH_BOX_BUNDLE_KEY, this.showSearchBox);
        }
    }

    @Override // com.facebook.widget.PickerFragment
    PickerFragment<GraphPlace>.PickerFragmentAdapter<GraphPlace> createAdapter() {
        PickerFragment<GraphPlace>.PickerFragmentAdapter<GraphPlace> pickerFragmentAdapter = new PickerFragment<GraphPlace>.PickerFragmentAdapter<GraphPlace>(getActivity()) { // from class: com.facebook.widget.PlacePickerFragment.1
            @Override // com.facebook.widget.GraphObjectAdapter
            protected int getDefaultPicture() {
                return AirFacebookExtension.getResourceId("drawable.com_facebook_place_default_icon");
            }

            /* JADX INFO: Access modifiers changed from: protected */
            @Override // com.facebook.widget.GraphObjectAdapter
            public int getGraphObjectRowLayoutId(GraphPlace graphPlace) {
                return AirFacebookExtension.getResourceId("layout.com_facebook_placepickerfragment_list_row");
            }

            /* JADX INFO: Access modifiers changed from: protected */
            @Override // com.facebook.widget.GraphObjectAdapter
            public CharSequence getSubTitleOfGraphObject(GraphPlace graphPlace) {
                String category = graphPlace.getCategory();
                Integer num = (Integer) graphPlace.getProperty(PlacePickerFragment.WERE_HERE_COUNT);
                if (category != null && num != null) {
                    return PlacePickerFragment.this.getString(AirFacebookExtension.getResourceId("string.com_facebook_placepicker_subtitle_format"), category, num);
                }
                if (category == null && num != null) {
                    return PlacePickerFragment.this.getString(AirFacebookExtension.getResourceId("string.com_facebook_placepicker_subtitle_were_here_only_format"), num);
                }
                if (category == null || num != null) {
                    return null;
                }
                return PlacePickerFragment.this.getString(AirFacebookExtension.getResourceId("string.com_facebook_placepicker_subtitle_catetory_only_format"), category);
            }
        };
        pickerFragmentAdapter.setShowCheckbox(false);
        pickerFragmentAdapter.setShowPicture(getShowPictures());
        return pickerFragmentAdapter;
    }

    @Override // com.facebook.widget.PickerFragment
    PickerFragment<GraphPlace>.LoadingStrategy createLoadingStrategy() {
        return new AsNeededLoadingStrategy();
    }

    @Override // com.facebook.widget.PickerFragment
    PickerFragment<GraphPlace>.SelectionStrategy createSelectionStrategy() {
        return new PickerFragment.SingleSelectionStrategy();
    }

    @Override // com.facebook.widget.PickerFragment
    String getDefaultTitleText() {
        return getString(AirFacebookExtension.getResourceId("string.com_facebook_nearby"));
    }

    public Location getLocation() {
        return this.location;
    }

    public int getRadiusInMeters() {
        return this.radiusInMeters;
    }

    @Override // com.facebook.widget.PickerFragment
    Request getRequestForLoadData(Session session) {
        return createRequest(this.location, this.radiusInMeters, this.resultsLimit, this.searchText, this.extraFields, session);
    }

    public int getResultsLimit() {
        return this.resultsLimit;
    }

    public String getSearchText() {
        return this.searchText;
    }

    public GraphPlace getSelection() {
        List<GraphPlace> selectedGraphObjects = getSelectedGraphObjects();
        if (selectedGraphObjects == null || selectedGraphObjects.isEmpty()) {
            return null;
        }
        return selectedGraphObjects.iterator().next();
    }

    @Override // com.facebook.widget.PickerFragment
    void logAppEvents(boolean z) {
        AppEventsLogger appEventsLoggerNewLogger = AppEventsLogger.newLogger(getActivity(), getSession());
        Bundle bundle = new Bundle();
        bundle.putString(AnalyticsEvents.PARAMETER_DIALOG_OUTCOME, z ? AnalyticsEvents.PARAMETER_DIALOG_OUTCOME_VALUE_COMPLETED : AnalyticsEvents.PARAMETER_DIALOG_OUTCOME_VALUE_UNKNOWN);
        bundle.putInt("num_places_picked", getSelection() != null ? 1 : 0);
        appEventsLoggerNewLogger.logSdkEvent(AnalyticsEvents.EVENT_PLACE_PICKER_USAGE, null, bundle);
    }

    @Override // android.support.v4.app.Fragment
    public void onAttach(Activity activity) {
        super.onAttach(activity);
        if (this.searchBox != null) {
            ((InputMethodManager) getActivity().getSystemService("input_method")).showSoftInput(this.searchBox, 1);
        }
    }

    @Override // com.facebook.widget.PickerFragment, android.support.v4.app.Fragment
    public void onDetach() {
        super.onDetach();
        if (this.searchBox != null) {
            ((InputMethodManager) getActivity().getSystemService("input_method")).hideSoftInputFromWindow(this.searchBox.getWindowToken(), 0);
        }
    }

    @Override // com.facebook.widget.PickerFragment, android.support.v4.app.Fragment
    public void onInflate(Activity activity, AttributeSet attributeSet, Bundle bundle) {
        super.onInflate(activity, attributeSet, bundle);
        TypedArray typedArrayObtainStyledAttributes = activity.obtainStyledAttributes(attributeSet, AirFacebookExtension.getResourceIds("styleable.com_facebook_place_picker_fragment"));
        setRadiusInMeters(typedArrayObtainStyledAttributes.getInt(AirFacebookExtension.getResourceId("styleable.com_facebook_place_picker_fragment_radius_in_meters"), this.radiusInMeters));
        setResultsLimit(typedArrayObtainStyledAttributes.getInt(AirFacebookExtension.getResourceId("styleable.com_facebook_place_picker_fragment_results_limit"), this.resultsLimit));
        if (typedArrayObtainStyledAttributes.hasValue(AirFacebookExtension.getResourceId("styleable.com_facebook_place_picker_fragment_results_limit"))) {
            setSearchText(typedArrayObtainStyledAttributes.getString(AirFacebookExtension.getResourceId("styleable.com_facebook_place_picker_fragment_search_text")));
        }
        this.showSearchBox = typedArrayObtainStyledAttributes.getBoolean(AirFacebookExtension.getResourceId("styleable.com_facebook_place_picker_fragment_show_search_box"), this.showSearchBox);
        typedArrayObtainStyledAttributes.recycle();
    }

    @Override // com.facebook.widget.PickerFragment
    void onLoadingData() {
        this.hasSearchTextChangedSinceLastQuery = false;
    }

    public void onSearchBoxTextChanged(String str, boolean z) {
        if (z || !Utility.stringsEqualOrEmpty(this.searchText, str)) {
            this.searchText = TextUtils.isEmpty(str) ? null : str;
            this.hasSearchTextChangedSinceLastQuery = true;
            if (this.searchTextTimer == null) {
                this.searchTextTimer = createSearchTextTimer();
            }
        }
    }

    @Override // com.facebook.widget.PickerFragment
    void saveSettingsToBundle(Bundle bundle) {
        super.saveSettingsToBundle(bundle);
        bundle.putInt(RADIUS_IN_METERS_BUNDLE_KEY, this.radiusInMeters);
        bundle.putInt(RESULTS_LIMIT_BUNDLE_KEY, this.resultsLimit);
        bundle.putString(SEARCH_TEXT_BUNDLE_KEY, this.searchText);
        bundle.putParcelable(LOCATION_BUNDLE_KEY, this.location);
        bundle.putBoolean(SHOW_SEARCH_BOX_BUNDLE_KEY, this.showSearchBox);
    }

    public void setLocation(Location location) {
        this.location = location;
    }

    public void setRadiusInMeters(int i) {
        this.radiusInMeters = i;
    }

    public void setResultsLimit(int i) {
        this.resultsLimit = i;
    }

    public void setSearchText(String str) {
        String str2 = TextUtils.isEmpty(str) ? null : str;
        this.searchText = str2;
        if (this.searchBox != null) {
            this.searchBox.setText(str2);
        }
    }

    @Override // com.facebook.widget.PickerFragment
    public void setSettingsFromBundle(Bundle bundle) {
        super.setSettingsFromBundle(bundle);
        setPlacePickerSettingsFromBundle(bundle);
    }

    @Override // com.facebook.widget.PickerFragment
    void setupViews(ViewGroup viewGroup) {
        if (this.showSearchBox) {
            ListView listView = (ListView) viewGroup.findViewById(AirFacebookExtension.getResourceId("id.com_facebook_picker_list_view"));
            listView.addHeaderView(getActivity().getLayoutInflater().inflate(AirFacebookExtension.getResourceId("layout.com_facebook_picker_search_box"), (ViewGroup) listView, false), null, false);
            this.searchBox = (EditText) viewGroup.findViewById(AirFacebookExtension.getResourceId("id.com_facebook_picker_search_text"));
            this.searchBox.addTextChangedListener(new SearchTextWatcher());
            if (TextUtils.isEmpty(this.searchText)) {
                return;
            }
            this.searchBox.setText(this.searchText);
        }
    }
}
