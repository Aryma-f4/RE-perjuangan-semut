package com.freshplanet.ane.AirFacebook;

import android.content.Intent;
import android.os.Bundle;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.facebook.Session;
import com.facebook.SessionState;
import com.freshplanet.ane.AirFacebook.functions.ActivateAppFunction;
import com.freshplanet.ane.AirFacebook.functions.CanPresentMessageDialogFunction;
import com.freshplanet.ane.AirFacebook.functions.CanPresentOpenGraphDialogFunction;
import com.freshplanet.ane.AirFacebook.functions.CanPresentShareDialogFunction;
import com.freshplanet.ane.AirFacebook.functions.CloseSessionAndClearTokenInformationFunction;
import com.freshplanet.ane.AirFacebook.functions.GetAccessTokenFunction;
import com.freshplanet.ane.AirFacebook.functions.GetExpirationTimestampFunction;
import com.freshplanet.ane.AirFacebook.functions.InitFunction;
import com.freshplanet.ane.AirFacebook.functions.IsSessionOpenFunction;
import com.freshplanet.ane.AirFacebook.functions.OpenSessionWithPermissionsFunction;
import com.freshplanet.ane.AirFacebook.functions.PresentMessageDialogWithLinkAndParamsFunction;
import com.freshplanet.ane.AirFacebook.functions.ReauthorizeSessionWithPermissionsFunction;
import com.freshplanet.ane.AirFacebook.functions.RequestWithGraphPathFunction;
import com.freshplanet.ane.AirFacebook.functions.SetUsingStage3dFunction;
import com.freshplanet.ane.AirFacebook.functions.ShareLinkDialogFunction;
import com.freshplanet.ane.AirFacebook.functions.ShareOpenGraphDialogFunction;
import com.freshplanet.ane.AirFacebook.functions.ShareStatusDialogFunction;
import com.freshplanet.ane.AirFacebook.functions.WebDialogFunction;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.json.JSONException;

/* loaded from: classes.dex */
public class AirFacebookExtensionContext extends FREContext {
    private String _appID;
    private Session _session;
    public boolean usingStage3D = false;

    public void closeSessionAndClearTokenInformation() {
        if (this._session != null) {
            this._session.closeAndClearTokenInformation();
            this._session = null;
        }
    }

    @Override // com.adobe.fre.FREContext
    public void dispose() {
        AirFacebookExtension.context = null;
    }

    @Override // com.adobe.fre.FREContext
    public Map<String, FREFunction> getFunctions() {
        HashMap map = new HashMap();
        map.put("init", new InitFunction());
        map.put("getAccessToken", new GetAccessTokenFunction());
        map.put("getExpirationTimestamp", new GetExpirationTimestampFunction());
        map.put("isSessionOpen", new IsSessionOpenFunction());
        map.put("openSessionWithPermissions", new OpenSessionWithPermissionsFunction());
        map.put("reauthorizeSessionWithPermissions", new ReauthorizeSessionWithPermissionsFunction());
        map.put("closeSessionAndClearTokenInformation", new CloseSessionAndClearTokenInformationFunction());
        map.put("requestWithGraphPath", new RequestWithGraphPathFunction());
        map.put("canPresentShareDialog", new CanPresentShareDialogFunction());
        map.put("shareStatusDialog", new ShareStatusDialogFunction());
        map.put("shareLinkDialog", new ShareLinkDialogFunction());
        map.put("canPresentOpenGraphDialog", new CanPresentOpenGraphDialogFunction());
        map.put("shareOpenGraphDialog", new ShareOpenGraphDialogFunction());
        map.put("canPresentMessageDialog", new CanPresentMessageDialogFunction());
        map.put("presentMessageDialogWithLinkAndParams", new PresentMessageDialogWithLinkAndParamsFunction());
        map.put("webDialog", new WebDialogFunction());
        map.put("activateApp", new ActivateAppFunction());
        map.put("setUsingStage3D", new SetUsingStage3dFunction());
        return map;
    }

    public Session getSession() {
        if (this._session == null) {
            this._session = new Session.Builder(getActivity().getApplicationContext()).setApplicationId(this._appID).build();
        }
        return this._session;
    }

    public void init(String str) throws JSONException {
        this._appID = str;
        Session session = getSession();
        if (session.getState().equals(SessionState.CREATED_TOKEN_LOADED)) {
            Session.setActiveSession(session);
            try {
                session.openForRead(null);
            } catch (UnsupportedOperationException e) {
                AirFacebookExtension.log("ERROR - Couldn't open session from cached token: " + (e != null ? e.toString() : "null exception"));
            }
        }
    }

    public void launchDialogActivity(String str, Bundle bundle, String str2) {
        Intent intent = new Intent(getActivity().getApplicationContext(), (Class<?>) WebDialogActivity.class);
        intent.putExtra(WebDialogActivity.extraPrefix + ".method", str);
        intent.putExtra(WebDialogActivity.extraPrefix + ".parameters", bundle);
        intent.putExtra(WebDialogActivity.extraPrefix + ".callback", str2);
        getActivity().startActivity(intent);
    }

    public void launchLoginActivity(List<String> list, String str, Boolean bool) {
        Intent intent = new Intent(getActivity().getApplicationContext(), (Class<?>) LoginActivity.class);
        intent.putExtra(LoginActivity.extraPrefix + ".permissions", (String[]) list.toArray(new String[list.size()]));
        intent.putExtra(LoginActivity.extraPrefix + ".type", str);
        intent.putExtra(LoginActivity.extraPrefix + ".reauthorize", bool);
        getActivity().startActivity(intent);
    }

    public void launchRequestThread(String str, Bundle bundle, String str2, String str3) {
        new RequestThread(this, str, bundle, str2, str3).start();
    }
}
