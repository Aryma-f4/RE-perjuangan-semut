package com.mimopay;

import android.app.Activity;
import android.content.CursorLoader;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Build;
import android.telephony.SmsManager;
import android.util.Log;
import android.webkit.URLUtil;
import com.facebook.AppEventsConstants;
import com.facebook.internal.ServerProtocol;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.math.BigInteger;
import java.net.SocketTimeoutException;
import java.net.URL;
import java.net.URLConnection;
import java.nio.ByteBuffer;
import java.nio.CharBuffer;
import java.nio.charset.Charset;
import java.nio.charset.CharsetDecoder;
import java.nio.charset.CharsetEncoder;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.StatusLine;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.params.HttpConnectionParams;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.nodes.Node;
import org.jsoup.select.Elements;

/* loaded from: classes.dex */
public class MimopayCore {
    public ArrayList<String> alsLogos = null;
    public ArrayList<String> alsLabels = null;
    public ArrayList<String> alsBtnAction = null;
    public ArrayList<String> alsUrls = null;
    public ArrayList<String> alsDenomValue = null;
    public ArrayList<String> alsDenomContent = null;
    private ArrayList<String> alsTextEditName = null;
    public String mMimopayLogoUrl = "";
    public int mAlsActiveIdx = -1;
    public String mHttppostDenom = null;
    public String mHttppostCode = null;
    public String mHttppostPhoneNumber = null;
    private final int PAYMENTRESULT_OK = 1;
    private final int PAYMENTRESULT_VALIDATEERROR = 2;
    private final int PAYMENTRESULT_INTERNETPROBLEM = 3;
    private final int PAYMENTRESULT_UNDERMAINTENANCE = 4;
    private long mCurMillis = 0;
    private int mTimeout = 0;
    public Activity mActivity = null;
    private boolean mOnWaitSMS = false;

    /* JADX INFO: Access modifiers changed from: private */
    public void jprintf(String s) {
        if (MimopayStuff.mEnableLog) {
            Log.d("JimBas", "MimopayCore: " + s);
        }
    }

    protected void onProgress(boolean start, String cmd) {
    }

    protected void onError(String serr) {
    }

    protected void onMerchantPaymentMethodRetrieved() {
    }

    protected void onResultUI(String channel, ArrayList<String> params) {
    }

    protected void onSmsCompleted(boolean success, ArrayList<String> alsSms) {
    }

    public void executePayment() {
        if (MimopayStuff.sTransactionId.equals("")) {
            MimopayStuff.sTransactionId = getUnixTimeStamp();
            jprintf("Using unix timestamp: " + MimopayStuff.sTransactionId);
        }
        jprintf("PaymentMethod: " + MimopayStuff.sPaymentMethod + "\nChannel: " + MimopayStuff.sChannel + "\nEmailOrUserId: " + MimopayStuff.sEmailOrUserId + "\nMerchantCode: " + MimopayStuff.sMerchantCode + "\nProductName: " + MimopayStuff.sProductName + "\nTransactionId: " + MimopayStuff.sTransactionId + "\nSecretKeyStaging: " + MimopayStuff.sSecretKeyStaging + "\nSecretKeyGateway: " + MimopayStuff.sSecretKeyGateway + "\nSecretKey: " + MimopayStuff.sSecretKey + "\nCurrency: " + MimopayStuff.sCurrency + "\nsAmount: " + MimopayStuff.sAmount + "\n");
        new RetrieveMerchantPaymentMethod().execute(new Void[0]);
    }

    public void reset() {
        this.alsLogos = null;
        this.alsLabels = null;
        this.alsBtnAction = null;
        this.alsUrls = null;
        this.alsDenomValue = null;
        this.alsDenomContent = null;
        this.alsTextEditName = null;
        this.mMimopayLogoUrl = "";
        this.mAlsActiveIdx = -1;
        this.mHttppostDenom = null;
        this.mHttppostCode = null;
        this.mHttppostPhoneNumber = null;
    }

    public void retrieveMerchantPaymentMethod() {
        new RetrieveMerchantPaymentMethod().execute(new Void[0]);
    }

    private ByteBuffer str2bb(String msg) {
        Charset charset = Charset.forName("UTF-8");
        CharsetEncoder encoder = charset.newEncoder();
        try {
            return encoder.encode(CharBuffer.wrap(msg));
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    private String bb2str(ByteBuffer buffer) {
        Charset charset = Charset.forName("UTF-8");
        CharsetDecoder decoder = charset.newDecoder();
        try {
            int old_position = buffer.position();
            String data = decoder.decode(buffer).toString();
            buffer.position(old_position);
            return data;
        } catch (Exception e) {
            e.printStackTrace();
            return "";
        }
    }

    private String getUnixTimeStamp() {
        int tm = (int) (System.currentTimeMillis() % 2147483647L);
        return Integer.toString(tm);
    }

    private String getAPIKey(String transid, String merchantcode, String secretkey) throws NoSuchAlgorithmException {
        String smd5 = transid + merchantcode + secretkey;
        ByteBuffer bb = str2bb(smd5);
        try {
            MessageDigest md = MessageDigest.getInstance("MD5");
            md.update(bb);
            String sres = new BigInteger(1, md.digest()).toString(16);
            return sres;
        } catch (Exception e) {
            jprintf("exception: " + e.toString());
            return "";
        }
    }

    /* JADX INFO: Access modifiers changed from: private */
    public String assembleMerchantLoadUrl() throws NoSuchAlgorithmException {
        String surl = null;
        String apikey = getAPIKey(MimopayStuff.sTransactionId, MimopayStuff.sMerchantCode, MimopayStuff.sSecretKey);
        if (MimopayStuff.sPaymentMethod.equals("Topup")) {
            surl = "http://" + MimopayStuff.mMimopayUrlPoint + ".mimopay.com/topup_api/load/";
        } else if (MimopayStuff.sPaymentMethod.equals("Airtime")) {
            if (MimopayStuff.sChannel.equals("upoint")) {
                surl = "http://" + MimopayStuff.mMimopayUrlPoint + ".mimopay.com/upoint_airtime_api/load/";
            } else {
                jprintf("Unsupported PaymentMethod");
                return null;
            }
        } else if (MimopayStuff.sPaymentMethod.equals("XL")) {
            surl = "http://" + MimopayStuff.mMimopayUrlPoint + ".mimopay.com/xl_api/load/";
        } else if (MimopayStuff.sPaymentMethod.equals("ATM")) {
            surl = "http://" + MimopayStuff.mMimopayUrlPoint + ".mimopay.com/atm_api/load/";
        }
        if (surl != null) {
            surl = ((((((surl + MimopayStuff.sEmailOrUserId + "/") + MimopayStuff.sProductName + "/") + MimopayStuff.sMerchantCode + "/") + MimopayStuff.sTransactionId + "/") + MimopayStuff.sCurrency + "/") + MimopayStuff.sAmount + "/") + apikey;
        }
        return surl;
    }

    private class RetrieveMerchantPaymentMethod extends AsyncTask<Void, Void, Boolean> {
        private RetrieveMerchantPaymentMethod() {
        }

        @Override // android.os.AsyncTask
        protected void onPreExecute() {
            MimopayCore.this.onProgress(true, "connecting");
        }

        /* JADX INFO: Access modifiers changed from: protected */
        @Override // android.os.AsyncTask
        public void onPostExecute(Boolean b) {
            MimopayCore.this.onProgress(false, "");
        }

        @Override // android.os.AsyncTask
        protected void onCancelled() {
            MimopayCore.this.onProgress(false, "");
        }

        /* JADX INFO: Access modifiers changed from: protected */
        @Override // android.os.AsyncTask
        public Boolean doInBackground(Void... params) throws IllegalStateException, NoSuchAlgorithmException, IOException {
            String serror = "ErrorConnectingToMimopayServer";
            String merchantloadurl = MimopayCore.this.assembleMerchantLoadUrl();
            MimopayCore.this.jprintf(merchantloadurl);
            if (merchantloadurl == null) {
                MimopayCore.this.onError("MerchantLoadUrlNull");
                return false;
            }
            boolean bres = false;
            int statusCode = -1;
            try {
                HttpClient httpclient = new DefaultHttpClient();
                HttpConnectionParams.setConnectionTimeout(httpclient.getParams(), 60000);
                HttpConnectionParams.setSoTimeout(httpclient.getParams(), 60000);
                HttpPost httppost = new HttpPost("http://staging.mimopay.com/api/");
                HttpResponse response = httpclient.execute(httppost);
                StatusLine statusline = response.getStatusLine();
                statusCode = statusline.getStatusCode();
                if (statusCode != 200) {
                    if (statusCode == 404) {
                        serror = "ErrorHTTP404NotFound";
                    }
                } else {
                    StringBuilder builder = new StringBuilder();
                    HttpEntity entity = response.getEntity();
                    InputStream content = entity.getContent();
                    BufferedReader reader = new BufferedReader(new InputStreamReader(content));
                    while (true) {
                        String line = reader.readLine();
                        if (line == null) {
                            break;
                        }
                        builder.append(line + "\n");
                    }
                    content.close();
                    Document doc = Jsoup.parse(builder.toString());
                    Elements links = doc.select("img");
                    Iterator i$ = links.iterator();
                    while (true) {
                        if (!i$.hasNext()) {
                            break;
                        }
                        Element link = i$.next();
                        String s = link.attr("src");
                        if (s != null && s.indexOf("logo") != -1) {
                            MimopayCore.this.mMimopayLogoUrl = s;
                            break;
                        }
                    }
                    HttpClient httpclient2 = new DefaultHttpClient();
                    HttpConnectionParams.setConnectionTimeout(httpclient2.getParams(), 60000);
                    HttpConnectionParams.setSoTimeout(httpclient2.getParams(), 60000);
                    HttpPost httppost2 = new HttpPost(merchantloadurl);
                    HttpResponse response2 = httpclient2.execute(httppost2);
                    StatusLine statusline2 = response2.getStatusLine();
                    statusCode = statusline2.getStatusCode();
                    if (statusCode != 200) {
                        if (statusCode == 404) {
                            serror = "ErrorHTTP404NotFound";
                        }
                    } else {
                        StringBuilder builder2 = new StringBuilder();
                        HttpEntity entity2 = response2.getEntity();
                        InputStream content2 = entity2.getContent();
                        BufferedReader reader2 = new BufferedReader(new InputStreamReader(content2));
                        while (true) {
                            String line2 = reader2.readLine();
                            if (line2 == null) {
                                break;
                            }
                            builder2.append(line2 + "\n");
                        }
                        content2.close();
                        String sresult = builder2.toString();
                        MimopayCore.this.jprintf("result : " + sresult);
                        if (MimopayCore.this.parseMimopayResponse(sresult)) {
                            bres = true;
                            if (!MimopayCore.this.makesureImage(MimopayCore.this.mMimopayLogoUrl)) {
                                bres = false;
                            }
                            for (int i = 0; i < MimopayCore.this.alsLogos.size(); i++) {
                                if (!MimopayCore.this.makesureImage(MimopayCore.this.alsLogos.get(i))) {
                                    bres = false;
                                }
                            }
                        } else {
                            serror = "UnsupportedPaymentMethod";
                        }
                    }
                }
            } catch (Exception e) {
                MimopayCore.this.jprintf("RetrieveMerchantPaymentMethod,Exception: " + e.toString());
            }
            if (!bres) {
                MimopayCore.this.jprintf(String.format("RetrieveMerchantPaymentMethod: serror = %s, statusCode = %d", serror, Integer.valueOf(statusCode)));
                MimopayCore.this.onError(serror);
            } else {
                MimopayCore.this.onMerchantPaymentMethodRetrieved();
            }
            return Boolean.valueOf(bres);
        }
    }

    /* JADX INFO: Access modifiers changed from: private */
    public boolean parseMimopayResponse(String sresp) {
        boolean bres = false;
        if (this.alsLogos == null) {
            this.alsLogos = new ArrayList<>();
        }
        if (this.alsLabels == null) {
            this.alsLabels = new ArrayList<>();
        }
        if (this.alsBtnAction == null) {
            this.alsBtnAction = new ArrayList<>();
        }
        if (this.alsUrls == null) {
            this.alsUrls = new ArrayList<>();
        }
        if (this.alsDenomValue == null) {
            this.alsDenomValue = new ArrayList<>();
        }
        if (this.alsDenomContent == null) {
            this.alsDenomContent = new ArrayList<>();
        }
        if (this.alsTextEditName == null) {
            this.alsTextEditName = new ArrayList<>();
        }
        if (MimopayStuff.sPaymentMethod.equals("Topup")) {
            bres = parseMimopayTopupChannels(sresp);
            printAls();
        } else {
            if (MimopayStuff.sPaymentMethod.equals("Airtime")) {
                boolean bres2 = parseMimopayAirtimeUPoint(sresp);
                printAls();
                return bres2;
            }
            if (MimopayStuff.sPaymentMethod.equals("XL")) {
                boolean bres3 = parseMimopayXL(sresp);
                printAls();
                return bres3;
            }
            if (MimopayStuff.sPaymentMethod.equals("ATM")) {
                boolean bres4 = parseMimopayATMs(sresp);
                printAls();
                return bres4;
            }
        }
        return bres;
    }

    private boolean parseMimopayTopupChannels(String shtml) {
        Document doc = Jsoup.parse(shtml);
        String sres = "";
        Elements links = doc.select("div");
        String r = "";
        Iterator<Element> it = links.iterator();
        while (it.hasNext()) {
            Element link = it.next();
            for (Node node : link.childNodes()) {
                String s = node.getClass().getSimpleName();
                String t = node.toString();
                String v = node.nodeName();
                if (s.equals("Element") && v.equals("h4")) {
                    Element e = (Element) node;
                    Elements linksb = e.select("a");
                    Iterator i$ = linksb.iterator();
                    while (i$.hasNext()) {
                        Element linkb = i$.next();
                        if (linkb.attr("class").equals("accordion-toggle") && linkb.attr("data-toggle").equals("collapse") && linkb.attr("data-parent").equals("#accordion")) {
                            s = linkb.attr("name");
                            sres = linkb.toString() + "\n";
                            r = s;
                        }
                    }
                }
                if (s.equals("FormElement")) {
                    sres = sres + t + "\n";
                    Element e2 = (Element) node;
                    Elements linksb2 = e2.select("input");
                    Iterator i$2 = linksb2.iterator();
                    while (i$2.hasNext()) {
                        Element linkb2 = i$2.next();
                        if (linkb2.attr(ServerProtocol.DIALOG_PARAM_TYPE).equals("hidden") && linkb2.attr("name").equals("btnAction")) {
                            String s2 = linkb2.attr("value");
                            if (r.equals("smartfren") && s2.equals("smartfren")) {
                                jprintf("smartfren found!");
                                parseMimopayTopupSmartfren(sres);
                            } else if (r.equals("sevelin") && s2.equals("sevelin")) {
                                jprintf("sevelin found!");
                                parseMimopayTopupSevelin(sres);
                            }
                        }
                    }
                }
            }
        }
        return true;
    }

    private boolean parseMimopayTopupSmartfren(String stopup) {
        Document doc = Jsoup.parse(stopup);
        Elements links = doc.select("img");
        Iterator i$ = links.iterator();
        while (true) {
            if (!i$.hasNext()) {
                break;
            }
            String s = i$.next().attr("src");
            if (s != null) {
                this.alsLogos.add(s);
                break;
            }
        }
        Elements links2 = doc.select("form");
        Iterator i$2 = links2.iterator();
        while (i$2.hasNext()) {
            Element link = i$2.next();
            if (link.attr("method").equals("post") && link.attr("id").indexOf("smartfren") != -1) {
                String s2 = link.attr("action");
                this.alsUrls.add(s2);
            }
        }
        Elements links3 = doc.select("input");
        Iterator i$3 = links3.iterator();
        while (i$3.hasNext()) {
            Element link2 = i$3.next();
            if (link2.attr(ServerProtocol.DIALOG_PARAM_TYPE).equals("hidden") && link2.attr("name").equals("btnAction")) {
                String s3 = link2.attr("value");
                this.alsBtnAction.add(s3);
            }
            if (link2.attr(ServerProtocol.DIALOG_PARAM_TYPE).equals("text") && link2.attr("name").indexOf("smartfren") != -1) {
                String s4 = link2.attr("id");
                this.alsTextEditName.add(s4);
            }
        }
        this.alsDenomValue.add("");
        this.alsDenomContent.add("");
        return true;
    }

    private boolean parseMimopayTopupSevelin(String stopup) {
        Document doc = Jsoup.parse(stopup);
        Elements links = doc.select("img");
        Iterator i$ = links.iterator();
        while (true) {
            if (!i$.hasNext()) {
                break;
            }
            String s = i$.next().attr("src");
            if (s != null) {
                this.alsLogos.add(s);
                break;
            }
        }
        Elements links2 = doc.select("form");
        Iterator i$2 = links2.iterator();
        while (i$2.hasNext()) {
            Element link = i$2.next();
            if (link.attr("method").equals("post") && link.attr("id").indexOf("sevelin") != -1) {
                String s2 = link.attr("action");
                this.alsUrls.add(s2);
            }
        }
        Elements links3 = doc.select("input");
        Iterator i$3 = links3.iterator();
        while (i$3.hasNext()) {
            Element link2 = i$3.next();
            if (link2.attr(ServerProtocol.DIALOG_PARAM_TYPE).equals("hidden") && link2.attr("name").equals("btnAction")) {
                String s3 = link2.attr("value");
                this.alsBtnAction.add(s3);
            }
            if (link2.attr(ServerProtocol.DIALOG_PARAM_TYPE).equals("text") && link2.attr("name").indexOf("sevelin") != -1) {
                String s4 = link2.attr("id");
                this.alsTextEditName.add(s4);
            }
        }
        this.alsDenomValue.add("");
        this.alsDenomContent.add("");
        return true;
    }

    private boolean parseMimopayATMs(String satm) {
        if (!MimopayStuff.sAmount.equals(AppEventsConstants.EVENT_PARAM_VALUE_NO)) {
            boolean bres = parseMimopayAtmList(satm);
            return bres;
        }
        boolean bres2 = parseMimopayAtmDenom(satm);
        if (this.mHttppostDenom == null) {
            return false;
        }
        return bres2;
    }

    private boolean parseMimopayAtmList(String satm) {
        Document doc = Jsoup.parse(satm);
        Elements links = doc.select("div");
        Iterator<Element> it = links.iterator();
        while (it.hasNext()) {
            Element link = it.next();
            if (link.attr("class").equals("caption")) {
                String t = link.text().replace("Harga Barang", "\nHarga Barang");
                String v = t.replace(" Biaya ", "\nBiaya ");
                this.alsDenomContent.add(v.replace("Jumlah Tagihan", "\nJumlah Tagihan"));
            }
            for (Node node : link.childNodes()) {
                String s = node.getClass().getSimpleName();
                node.toString();
                String v2 = node.nodeName();
                if (s.equals("Element") && v2.equals("h4")) {
                    Elements links2 = ((Element) node).select("img");
                    Iterator i$ = links2.iterator();
                    while (i$.hasNext()) {
                        Element linka = i$.next();
                        s = linka.attr("src");
                        this.alsLogos.add(s);
                    }
                }
                if (s.equals("FormElement")) {
                    Element e = (Element) node;
                    if (e.attr("method").equals("post")) {
                        this.alsUrls.add(e.attr("action"));
                    }
                    Elements links3 = e.select("input");
                    Iterator i$2 = links3.iterator();
                    while (i$2.hasNext()) {
                        Element linkb = i$2.next();
                        if (linkb.attr(ServerProtocol.DIALOG_PARAM_TYPE).equals("hidden") && linkb.attr("name").equals("value")) {
                            this.alsDenomValue.add(linkb.attr("value"));
                        }
                        if (linkb.attr(ServerProtocol.DIALOG_PARAM_TYPE).equals("hidden") && linkb.attr("name").equals("btnAction")) {
                            this.alsBtnAction.add(linkb.attr("value"));
                        }
                    }
                }
            }
        }
        return true;
    }

    private boolean parseMimopayAtmDenom(String satmbca) {
        Document doc = Jsoup.parse(satmbca);
        Elements links = doc.select("img");
        Iterator i$ = links.iterator();
        while (i$.hasNext()) {
            String s = i$.next().attr("src");
            if (s != null) {
                this.alsLogos.add(s);
            }
        }
        Elements links2 = doc.select("form");
        Iterator i$2 = links2.iterator();
        while (i$2.hasNext()) {
            Element link = i$2.next();
            if (link.attr("method").equals("post")) {
                String s2 = link.attr("action");
                this.alsUrls.add(s2);
            }
        }
        Elements links3 = doc.select("input");
        String s3 = "[";
        String t = "[";
        boolean bcomma = false;
        Iterator i$3 = links3.iterator();
        while (i$3.hasNext()) {
            Element link2 = i$3.next();
            if (link2.attr(ServerProtocol.DIALOG_PARAM_TYPE).equals("radio") && link2.attr("name").indexOf("denom") != -1) {
                if (this.mHttppostDenom == null) {
                    this.mHttppostDenom = link2.attr("name");
                }
                if (bcomma) {
                    s3 = s3 + ",";
                    t = t + ",";
                }
                s3 = s3 + "\"" + link2.attr("value") + "\"";
                t = t + "\"" + link2.nextSibling().toString() + "\"";
                bcomma = true;
            }
            if (link2.attr(ServerProtocol.DIALOG_PARAM_TYPE).equals("hidden") && link2.attr("name").equals("btnAction")) {
                String z = link2.attr("value");
                this.alsBtnAction.add(z);
            }
        }
        this.alsTextEditName.add("");
        this.alsDenomValue.add(s3 + "]");
        this.alsDenomContent.add(t + "]");
        return true;
    }

    private boolean parseMimopayAirtimeUPoint(String sairtime) {
        Document doc = Jsoup.parse(sairtime);
        Elements links = doc.select("img");
        Iterator i$ = links.iterator();
        while (i$.hasNext()) {
            String s = i$.next().attr("src");
            if (s != null && s.indexOf("upoint") != -1) {
                this.alsLogos.add(s);
            }
        }
        Elements links2 = doc.select("form");
        Iterator i$2 = links2.iterator();
        while (i$2.hasNext()) {
            Element link = i$2.next();
            if (link.attr("method").equals("post") && link.attr("id").indexOf("upoint") != -1) {
                String s2 = link.attr("action");
                this.alsUrls.add(s2);
            }
        }
        Elements links3 = doc.select("input");
        String s3 = "[";
        String t = "[";
        boolean bcomma = false;
        Iterator i$3 = links3.iterator();
        while (i$3.hasNext()) {
            Element link2 = i$3.next();
            boolean bl = link2.attr(ServerProtocol.DIALOG_PARAM_TYPE).equals("radio");
            if (!MimopayStuff.sAmount.equals(AppEventsConstants.EVENT_PARAM_VALUE_NO)) {
                bl = true;
            }
            if (bl && link2.attr("name").indexOf("denom") != -1) {
                if (this.mHttppostDenom == null) {
                    this.mHttppostDenom = link2.attr("name");
                }
                if (bcomma) {
                    s3 = s3 + ",";
                    t = t + ",";
                }
                s3 = s3 + "\"" + link2.attr("value") + "\"";
                t = t + "\"" + link2.nextSibling().toString() + "\"";
                bcomma = true;
            }
            if (link2.attr(ServerProtocol.DIALOG_PARAM_TYPE).equals("hidden") && link2.attr("name").equals("btnAction")) {
                this.alsBtnAction.add(link2.attr("value"));
            }
            if (link2.attr(ServerProtocol.DIALOG_PARAM_TYPE).equals("text") && link2.attr("name").indexOf("upoint") != -1) {
                this.alsTextEditName.add(link2.attr("id"));
            }
        }
        this.alsDenomValue.add(s3 + "]");
        this.alsDenomContent.add(t + "]");
        return true;
    }

    private boolean parseMimopayXL(String sxl) {
        Document doc = Jsoup.parse(sxl);
        String sres = "";
        String slabel = "";
        Elements links = doc.select("div");
        String r = "";
        Iterator<Element> it = links.iterator();
        while (it.hasNext()) {
            Element link = it.next();
            for (Node node : link.childNodes()) {
                String s = node.getClass().getSimpleName();
                String t = node.toString();
                String v = node.nodeName();
                if (s.equals("Element") && v.equals("h4")) {
                    Element e = (Element) node;
                    Elements linksb = e.select("a");
                    Iterator i$ = linksb.iterator();
                    while (i$.hasNext()) {
                        Element linkb = i$.next();
                        if (linkb.attr("class").equals("accordion-toggle") && linkb.attr("data-toggle").equals("collapse") && linkb.attr("data-parent").equals("#accordion")) {
                            s = linkb.attr("name");
                            sres = linkb.toString() + "\n";
                            slabel = linkb.text();
                            r = s;
                        }
                    }
                }
                if (s.equals("FormElement")) {
                    sres = sres + t + "\n";
                    Element e2 = (Element) node;
                    Elements linksb2 = e2.select("input");
                    Iterator i$2 = linksb2.iterator();
                    while (i$2.hasNext()) {
                        Element linkb2 = i$2.next();
                        if (linkb2.attr(ServerProtocol.DIALOG_PARAM_TYPE).equals("hidden") && linkb2.attr("name").equals("btnAction")) {
                            String s2 = linkb2.attr("value");
                            if (r.equals("xl_airtime") && s2.equals("xl_airtime")) {
                                jprintf("xl_airtime found!. label: " + slabel);
                                this.alsLabels.add(slabel);
                                parseMimopayXLPulsa(sres);
                            } else if (r.equals("xl_hrn") && s2.equals("xl_hrn")) {
                                jprintf("xl_hrn found!. label: " + slabel);
                                this.alsLabels.add(slabel);
                                parseMimopayXLVoucher(sres);
                            }
                        }
                    }
                }
            }
        }
        return true;
    }

    private boolean parseMimopayXLPulsa(String sxlpulsa) {
        Document doc = Jsoup.parse(sxlpulsa);
        this.alsLogos.add("http://staging.mimopay.com/addons/default/modules/mimopay/css/img/logoxl_29.jpg");
        Elements links = doc.select("form");
        Iterator i$ = links.iterator();
        while (i$.hasNext()) {
            Element link = i$.next();
            if (link.attr("method").equals("post") && link.attr("id").indexOf("xl") != -1) {
                String s = link.attr("action");
                this.alsUrls.add(s);
            }
        }
        Elements links2 = doc.select("input");
        String s2 = "[";
        String t = "[";
        boolean bcomma = false;
        Iterator i$2 = links2.iterator();
        while (i$2.hasNext()) {
            Element link2 = i$2.next();
            if (link2.attr(ServerProtocol.DIALOG_PARAM_TYPE).equals("radio") && link2.attr("name").indexOf("denom") != -1) {
                if (this.mHttppostDenom == null) {
                    this.mHttppostDenom = link2.attr("name");
                }
                if (bcomma) {
                    s2 = s2 + ",";
                    t = t + ",";
                }
                s2 = s2 + "\"" + link2.attr("value") + "\"";
                t = t + "\"" + link2.nextSibling().toString() + "\"";
                bcomma = true;
            }
            if (link2.attr(ServerProtocol.DIALOG_PARAM_TYPE).equals("hidden") && link2.attr("name").equals("btnAction")) {
                this.alsBtnAction.add(link2.attr("value"));
            }
            if (link2.attr(ServerProtocol.DIALOG_PARAM_TYPE).equals("text") && link2.attr("name").indexOf("xl") != -1) {
                this.alsTextEditName.add(link2.attr("id"));
            }
        }
        this.alsDenomValue.add(s2 + "]");
        this.alsDenomContent.add(t + "]");
        return true;
    }

    private boolean parseMimopayXLVoucher(String sxlvoucher) {
        Document doc = Jsoup.parse(sxlvoucher);
        this.alsLogos.add("http://staging.mimopay.com/addons/default/modules/mimopay/css/img/logoxl_29.jpg");
        Elements links = doc.select("form");
        Iterator i$ = links.iterator();
        while (i$.hasNext()) {
            Element link = i$.next();
            if (link.attr("method").equals("post") && (link.attr("id").indexOf("xl") != -1 || link.attr("id").indexOf("sevelin") != -1)) {
                String s = link.attr("action");
                this.alsUrls.add(s);
            }
        }
        Elements links2 = doc.select("input");
        Iterator i$2 = links2.iterator();
        while (i$2.hasNext()) {
            Element link2 = i$2.next();
            if (link2.attr(ServerProtocol.DIALOG_PARAM_TYPE).equals("hidden") && link2.attr("name").equals("btnAction")) {
                String s2 = link2.attr("value");
                this.alsBtnAction.add(s2);
            }
            if (link2.attr(ServerProtocol.DIALOG_PARAM_TYPE).equals("text") && link2.attr("name").indexOf("xl") != -1) {
                String s3 = link2.attr("id");
                this.alsTextEditName.add(s3);
            }
        }
        this.alsDenomValue.add("");
        this.alsDenomContent.add("");
        return true;
    }

    private void printAls() {
        int j = this.alsBtnAction.size();
        for (int i = 0; i < j; i++) {
            jprintf(String.format("<alsBtnAction>size:%d, idx:%d, als:%s", Integer.valueOf(j), Integer.valueOf(i), this.alsBtnAction.get(i)));
        }
        int j2 = this.alsLogos.size();
        for (int i2 = 0; i2 < j2; i2++) {
            jprintf(String.format("<alsLogos>size:%d, idx:%d, als:%s", Integer.valueOf(j2), Integer.valueOf(i2), this.alsLogos.get(i2)));
        }
        int j3 = this.alsUrls.size();
        for (int i3 = 0; i3 < j3; i3++) {
            jprintf(String.format("<alsUrls>size:%d, idx:%d, als:%s", Integer.valueOf(j3), Integer.valueOf(i3), this.alsUrls.get(i3)));
        }
        int j4 = this.alsDenomValue.size();
        for (int i4 = 0; i4 < j4; i4++) {
            jprintf(String.format("<alsDenomValue>size:%d, idx:%d, als:%s", Integer.valueOf(j4), Integer.valueOf(i4), this.alsDenomValue.get(i4)));
        }
        int j5 = this.alsDenomContent.size();
        for (int i5 = 0; i5 < j5; i5++) {
            jprintf(String.format("<alsDenomContent>size:%d, idx:%d, als:%s", Integer.valueOf(j5), Integer.valueOf(i5), this.alsDenomContent.get(i5)));
        }
        int j6 = this.alsTextEditName.size();
        for (int i6 = 0; i6 < j6; i6++) {
            jprintf(String.format("<alsTextEditName>size:%d, idx:%d, als:%s", Integer.valueOf(j6), Integer.valueOf(i6), this.alsTextEditName.get(i6)));
        }
        jprintf("mHttppostDenom: " + this.mHttppostDenom);
    }

    public static boolean isNumeric(String str) {
        char[] arr$ = str.toCharArray();
        for (char c : arr$) {
            if (!Character.isDigit(c)) {
                return false;
            }
        }
        return true;
    }

    public static String getFnameFromUrl(String url) {
        if (url.equals("")) {
            return "";
        }
        int slashIndex = url.lastIndexOf(47);
        if (slashIndex < 0) {
            return null;
        }
        return url.substring(slashIndex + 1);
    }

    public static boolean isFileOkay(String filepath) {
        File file = new File(filepath);
        if (!file.exists()) {
            return false;
        }
        if (file.length() == 0) {
            file.delete();
            return false;
        }
        return true;
    }

    /* JADX INFO: Access modifiers changed from: private */
    public boolean makesureImage(String imageurl) throws IOException {
        String scoba = downloadFromUrl(imageurl);
        if (scoba != null) {
            jprintf(String.format("Failed to download %s. Reason: %s", imageurl, scoba));
        } else {
            jprintf("Success download " + imageurl);
        }
        return true;
    }

    public Bitmap getBitmapInternal(String urlpath) throws IOException {
        Bitmap rbmp = null;
        String pathname = getFnameFromUrl(urlpath);
        try {
            FileInputStream fis = this.mActivity.openFileInput(pathname);
            rbmp = BitmapFactory.decodeStream(fis);
            fis.close();
            return rbmp;
        } catch (FileNotFoundException e) {
            jprintf("getBitmapInternal: e=" + e.toString());
            return rbmp;
        } catch (IOException e2) {
            jprintf("getBitmapInternal: e=" + e2.toString());
            return rbmp;
        }
    }

    private String downloadFromUrl(String urlpath) throws IOException {
        InputStream stream;
        String serror = null;
        String pathname = getFnameFromUrl(urlpath);
        File file = this.mActivity.getFileStreamPath(pathname);
        if (file.exists()) {
            return "FileExistAlready";
        }
        if (!URLUtil.isNetworkUrl(urlpath)) {
            return "ErrorNetworkUrlInvalid";
        }
        try {
            URL url = new URL(urlpath);
            URLConnection cn = url.openConnection();
            cn.connect();
            stream = cn.getInputStream();
        } catch (IOException e) {
            serror = "ErrorImageDownloadStreamClose";
        } catch (Exception e2) {
            serror = "downloadFromUrl,e: " + e2.toString();
        }
        if (stream == null) {
            return "ErrorStreamIsNull";
        }
        Activity activity = this.mActivity;
        Activity activity2 = this.mActivity;
        FileOutputStream out = activity.openFileOutput(pathname, 0);
        byte[] buf = new byte[512];
        while (true) {
            int numread = stream.read(buf);
            if (numread <= 0) {
                break;
            }
            out.write(buf, 0, numread);
        }
        stream.close();
        out.close();
        return serror;
    }

    public boolean setChannelActiveIndex(String channel) {
        int j = this.alsBtnAction.size();
        for (int i = 0; i < j; i++) {
            String s = this.alsBtnAction.get(i);
            if (s.equals(channel)) {
                this.mAlsActiveIdx = i;
                return true;
            }
        }
        return false;
    }

    public void executeBtnAction() {
        new btnActionPost().execute(new Void[0]);
    }

    public class btnActionPost extends AsyncTask<Void, Void, Boolean> {
        public btnActionPost() {
        }

        @Override // android.os.AsyncTask
        protected void onPreExecute() {
            MimopayCore.this.onProgress(true, "validating");
        }

        /* JADX INFO: Access modifiers changed from: protected */
        @Override // android.os.AsyncTask
        public void onPostExecute(Boolean b) {
            MimopayCore.this.onProgress(false, "");
        }

        @Override // android.os.AsyncTask
        protected void onCancelled() {
            MimopayCore.this.onProgress(false, "");
        }

        /* JADX INFO: Access modifiers changed from: protected */
        @Override // android.os.AsyncTask
        public Boolean doInBackground(Void... params) throws IllegalStateException, IOException {
            HttpPost httppostc;
            MimopayCore.this.jprintf(" mHttppostCode: " + MimopayCore.this.mHttppostCode + " mAlsActiveIdx: " + Integer.toString(MimopayCore.this.mAlsActiveIdx));
            if (MimopayCore.this.mAlsActiveIdx == -1) {
                MimopayCore.this.jprintf("ArrayList index shouldn't be -1");
                MimopayCore.this.onError("UnspecifiedChannelRequest");
                return false;
            }
            int resstat = 3;
            String url = MimopayCore.this.alsUrls.get(MimopayCore.this.mAlsActiveIdx);
            String paymentname = MimopayCore.this.alsBtnAction.get(MimopayCore.this.mAlsActiveIdx);
            String texteditname = "";
            if (MimopayCore.this.alsTextEditName != null && MimopayCore.this.alsTextEditName.size() > MimopayCore.this.mAlsActiveIdx) {
                texteditname = (String) MimopayCore.this.alsTextEditName.get(MimopayCore.this.mAlsActiveIdx);
            }
            MimopayCore.this.alsDenomValue.get(MimopayCore.this.mAlsActiveIdx);
            MimopayCore.this.jprintf("url: " + url + " paymentname: " + paymentname + " texteditname: " + texteditname);
            try {
                HttpClient httpclientc = new DefaultHttpClient();
                HttpConnectionParams.setConnectionTimeout(httpclientc.getParams(), 60000);
                HttpConnectionParams.setSoTimeout(httpclientc.getParams(), 60000);
                if (paymentname.equals("smartfren") || paymentname.equals("sevelin") || paymentname.equals("xl_hrn")) {
                    List<NameValuePair> nameValuePairsc = new ArrayList<>(2);
                    nameValuePairsc.add(new BasicNameValuePair("btnAction", paymentname));
                    nameValuePairsc.add(new BasicNameValuePair(texteditname, MimopayCore.this.mHttppostCode));
                    httppostc = new HttpPost(url);
                    httppostc.setEntity(new UrlEncodedFormEntity(nameValuePairsc));
                } else if (paymentname.indexOf("atm_") != -1) {
                    httppostc = new HttpPost(url);
                    List<NameValuePair> nameValuePairsc2 = new ArrayList<>(2);
                    nameValuePairsc2.add(new BasicNameValuePair("btnAction", paymentname));
                    nameValuePairsc2.add(new BasicNameValuePair("denom", MimopayCore.this.mHttppostCode));
                    httppostc.setEntity(new UrlEncodedFormEntity(nameValuePairsc2));
                } else {
                    if (!paymentname.equals("upoint_airtime") && !paymentname.equals("xl_airtime")) {
                        MimopayCore.this.jprintf("Unsupported Payment Method: " + paymentname);
                        MimopayCore.this.onError("UnsupportedPaymentMethod");
                        return false;
                    }
                    httppostc = new HttpPost(url);
                    List<NameValuePair> nameValuePairsc3 = new ArrayList<>(3);
                    nameValuePairsc3.add(new BasicNameValuePair("btnAction", paymentname));
                    nameValuePairsc3.add(new BasicNameValuePair(texteditname, MimopayCore.this.mHttppostPhoneNumber));
                    nameValuePairsc3.add(new BasicNameValuePair(MimopayCore.this.mHttppostDenom, MimopayCore.this.mHttppostCode));
                    httppostc.setEntity(new UrlEncodedFormEntity(nameValuePairsc3));
                }
                HttpResponse responsec = httpclientc.execute(httppostc);
                StatusLine statusLinec = responsec.getStatusLine();
                int statusCode = statusLinec.getStatusCode();
                MimopayCore.this.jprintf("btnActionPost,statusCode: " + Integer.toString(statusCode));
                if (statusCode == 200) {
                    StringBuilder builderc = new StringBuilder();
                    HttpEntity entityc = responsec.getEntity();
                    InputStream contentc = entityc.getContent();
                    BufferedReader readerc = new BufferedReader(new InputStreamReader(contentc));
                    while (true) {
                        String linec = readerc.readLine();
                        if (linec == null) {
                            break;
                        }
                        builderc.append(linec + "\n");
                    }
                    contentc.close();
                    String sresultc = builderc.toString();
                    resstat = sresultc.indexOf("dontpanic.jpg") != -1 ? 4 : MimopayCore.this.decidePaymentMethodProcess(sresultc);
                }
            } catch (SocketTimeoutException e) {
                MimopayCore.this.jprintf("SocketTimeoutException: " + e.toString());
            } catch (Exception e2) {
                MimopayCore.this.jprintf("exception: " + e2.toString());
            }
            switch (resstat) {
                case 2:
                    MimopayCore.this.onError("ErrorValidatingVoucherCode");
                    break;
                case 3:
                    MimopayCore.this.onError("ErrorConnectingToMimopayServer");
                    break;
                case 4:
                    MimopayCore.this.onError("ErrorUnderMaintenance");
                    break;
            }
            return false;
        }
    }

    /* JADX INFO: Access modifiers changed from: private */
    public int decidePaymentMethodProcess(String jsonstr) throws JSONException, IOException {
        String type = this.alsBtnAction.get(this.mAlsActiveIdx);
        if (type.equals("smartfren") || type.equals("sevelin") || type.equals("xl_hrn")) {
            try {
                JSONObject json = new JSONObject(jsonstr);
                String sstat = json.getString("status");
                if (type.equals("xl_hrn") && sstat.equals("failed")) {
                    sstat = "ok";
                }
                if (sstat.equals("ok")) {
                    String html = json.getString("html");
                    Document doc = Jsoup.parse(html);
                    ArrayList<String> sval = new ArrayList<>();
                    Elements links = doc.select("br");
                    boolean bok = true;
                    Iterator i$ = links.iterator();
                    while (i$.hasNext()) {
                        Element link = i$.next();
                        Node e = link.nextSibling();
                        if (e != null) {
                            String s = e.toString();
                            if (bok) {
                                sval.add(s);
                                bok = false;
                            } else if (s.indexOf("Topup Status", 0) != -1) {
                                bok = true;
                            }
                            jprintf("link: " + s);
                        }
                    }
                    int nsize = sval.size();
                    jprintf("sval.size: " + nsize);
                    if (nsize == 2) {
                        ArrayList<String> svalb = new ArrayList<>();
                        svalb.add(sval.get(1));
                        svalb.add(sval.get(0));
                        MimopayStuff.saveLastResult(svalb);
                        onResultUI(type, svalb);
                        return 1;
                    }
                    return 3;
                }
            } catch (JSONException e2) {
                jprintf("JSONException,alsTextEditName: " + e2.toString());
                return 3;
            }
        } else {
            if (type.equals("atm_bca")) {
                try {
                    Document doc2 = Jsoup.parse(jsonstr);
                    Elements links2 = doc2.select("h4");
                    String v = null;
                    String u = null;
                    String t = null;
                    Iterator i$2 = links2.iterator();
                    while (i$2.hasNext()) {
                        Element link2 = i$2.next();
                        String s2 = link2.text();
                        jprintf("atmbca,link.text: " + s2);
                        if (s2.indexOf("Kode Perusahaan", 0) != -1) {
                            t = s2;
                        } else if (s2.indexOf("Jumlah Tagihan", 0) != -1) {
                            u = s2;
                        } else if (s2.indexOf("ID Transaksi", 0) != -1) {
                            v = s2;
                        }
                    }
                    ArrayList<String> als = new ArrayList<>();
                    als.add(t);
                    als.add(u);
                    als.add(v);
                    MimopayStuff.saveLastResult(als);
                    onResultUI(type, als);
                    return 1;
                } catch (Exception e3) {
                    jprintf("Exception: " + e3.toString());
                    return 3;
                }
            }
            if (type.equals("upoint_airtime")) {
                try {
                    JSONObject json2 = new JSONObject(jsonstr);
                    String sstat2 = json2.getString("status");
                    jprintf("status = " + sstat2);
                    if (sstat2.equals("ok")) {
                        String html2 = json2.getString("html");
                        Document doc3 = Jsoup.parse(html2);
                        Element div = doc3.select("div").first();
                        String smscontent = null;
                        String smsnumber = null;
                        int i = 0;
                        int stg = 0;
                        for (Node node : div.childNodes()) {
                            i++;
                            String s3 = node.getClass().getSimpleName();
                            String t2 = node.toString();
                            switch (stg) {
                                case 1:
                                    if (s3.equals("Element")) {
                                        Element e4 = (Element) node;
                                        smscontent = e4.text().replace("(spasi)", " ");
                                        jprintf("smscontent: " + smscontent);
                                        stg = 0;
                                        break;
                                    }
                                    break;
                                case 2:
                                    if (s3.equals("Element")) {
                                        Element e5 = (Element) node;
                                        smsnumber = e5.text();
                                        jprintf("smsnumber: " + smsnumber);
                                        stg = 0;
                                        break;
                                    }
                                    break;
                            }
                            if (s3.equals("TextNode") && t2.indexOf("SMS", 0) != -1) {
                                stg = 1;
                            }
                            if (s3.equals("TextNode") && t2.indexOf("ke", 0) != -1) {
                                stg = 2;
                            }
                        }
                        if (smscontent != null && smsnumber != null) {
                            ArrayList<String> als2 = new ArrayList<>();
                            als2.add(smscontent);
                            als2.add(smsnumber);
                            MimopayStuff.saveLastResult(als2);
                            onResultUI(type, als2);
                            return 1;
                        }
                        jprintf("either smscontent or smsnumber is null");
                    }
                } catch (JSONException e6) {
                    jprintf("JSONException,alsTextEditName: " + e6.toString());
                    return 3;
                }
            } else if (type.equals("xl_airtime")) {
                try {
                    JSONObject json3 = new JSONObject(jsonstr);
                    String sstat3 = json3.getString("status");
                    jprintf("status = " + sstat3);
                    if (sstat3.equals("ok")) {
                        String html3 = json3.getString("html");
                        Document doc4 = Jsoup.parse(html3);
                        Elements links3 = doc4.select("p");
                        Iterator<Element> it = links3.iterator();
                        while (it.hasNext()) {
                            Element link3 = it.next();
                            Iterator i$3 = link3.childNodes().iterator();
                            while (i$3.hasNext()) {
                                String s4 = i$3.next().toString();
                                if (s4.indexOf("Reference") != -1) {
                                    ArrayList<String> als3 = new ArrayList<>();
                                    als3.add(s4);
                                    MimopayStuff.saveLastResult(als3);
                                    onResultUI(type, als3);
                                    return 1;
                                }
                            }
                        }
                    }
                    jprintf("xl_airtime: no reference id found");
                } catch (JSONException e7) {
                    jprintf("JSONException,alsTextEditName: " + e7.toString());
                    return 3;
                }
            }
        }
        return 2;
    }

    public void sendSMS(String smsMessage, String phoneNumber) {
        String[] sendSMSTaskParams = {smsMessage, phoneNumber};
        new SendSMSTask().execute(sendSMSTaskParams);
    }

    private class SendSMSTask extends AsyncTask<String, Void, Boolean> {
        String dstphonenum;
        String smsmessage;

        private SendSMSTask() {
            this.smsmessage = null;
            this.dstphonenum = null;
        }

        @Override // android.os.AsyncTask
        protected void onPreExecute() {
            MimopayCore.this.onProgress(true, "sendsms");
        }

        /* JADX INFO: Access modifiers changed from: protected */
        @Override // android.os.AsyncTask
        public void onPostExecute(Boolean b) {
            MimopayCore.this.onProgress(false, "");
            ArrayList<String> als = new ArrayList<>();
            als.add("sent");
            als.add(this.smsmessage);
            als.add(this.dstphonenum);
            MimopayCore.this.onSmsCompleted(b.booleanValue(), als);
        }

        @Override // android.os.AsyncTask
        protected void onCancelled() {
            MimopayCore.this.onProgress(false, "");
        }

        /* JADX INFO: Access modifiers changed from: protected */
        @Override // android.os.AsyncTask
        public Boolean doInBackground(String... params) throws InterruptedException {
            this.smsmessage = params[0];
            this.dstphonenum = params[1];
            MimopayCore.this.jprintf("[SendSMSTask] smsmessage: " + this.smsmessage + " dstphonenum: " + this.dstphonenum);
            SmsManager smsmgr = SmsManager.getDefault();
            if (smsmgr == null) {
                MimopayCore.this.jprintf("Failed to send SMS");
                return false;
            }
            smsmgr.sendTextMessage(this.dstphonenum, null, this.smsmessage, null, null);
            try {
                Thread.sleep(3000L);
            } catch (InterruptedException e) {
            }
            return true;
        }
    }

    public void waitSMS(int ntimeout) {
        this.mCurMillis = System.currentTimeMillis();
        this.mTimeout = ntimeout;
        this.mOnWaitSMS = true;
        new WaitSMSTask().execute(new String[0]);
    }

    public void stopWaitSMS() {
        this.mOnWaitSMS = false;
    }

    private class WaitSMSTask extends AsyncTask<String, Void, Boolean> {
        ArrayList<String> als;
        private CursorLoader mCl;

        private WaitSMSTask() {
            this.als = null;
            this.mCl = null;
        }

        @Override // android.os.AsyncTask
        protected void onPreExecute() {
            MimopayCore.this.onProgress(true, "waitsms");
        }

        /* JADX INFO: Access modifiers changed from: protected */
        @Override // android.os.AsyncTask
        public void onPostExecute(Boolean b) {
            MimopayCore.this.onProgress(false, "");
            MimopayCore.this.onSmsCompleted(b.booleanValue(), this.als);
        }

        @Override // android.os.AsyncTask
        protected void onCancelled() {
            MimopayCore.this.onProgress(false, "");
        }

        /* JADX INFO: Access modifiers changed from: protected */
        @Override // android.os.AsyncTask
        public Boolean doInBackground(String... params) throws InterruptedException {
            for (int i = 0; i < MimopayCore.this.mTimeout; i++) {
                this.als = null;
                if (querySms()) {
                    MimopayCore.this.onSmsCompleted(true, this.als);
                }
                try {
                    Thread.sleep(500L);
                } catch (Exception e) {
                }
                if (!MimopayCore.this.mOnWaitSMS) {
                    this.als = new ArrayList<>();
                    this.als.add("read");
                    this.als.add("stopped");
                    return false;
                }
            }
            this.als = new ArrayList<>();
            this.als.add("read");
            this.als.add("timeout");
            return false;
        }

        private boolean querySms() throws NumberFormatException {
            Cursor cursor1;
            if (Build.VERSION.SDK_INT >= 11) {
                this.mCl = null;
                MimopayCore.this.mActivity.runOnUiThread(new Runnable() { // from class: com.mimopay.MimopayCore.WaitSMSTask.1
                    @Override // java.lang.Runnable
                    public void run() {
                        WaitSMSTask.this.mCl = new CursorLoader(MimopayCore.this.mActivity.getApplicationContext());
                    }
                });
                if (this.mCl == null) {
                    return false;
                }
                this.mCl.setUri(Uri.parse("content://sms/inbox"));
                cursor1 = this.mCl.loadInBackground();
            } else {
                Uri mSmsinboxQueryUri = Uri.parse("content://sms/inbox");
                cursor1 = MimopayCore.this.mActivity.getContentResolver().query(mSmsinboxQueryUri, new String[]{"_id", "thread_id", "address", "person", "date", "body", ServerProtocol.DIALOG_PARAM_TYPE}, null, null, null);
                MimopayCore.this.mActivity.startManagingCursor(cursor1);
            }
            String[] columns = {"address", "person", "date", "body", ServerProtocol.DIALOG_PARAM_TYPE};
            if (cursor1.getCount() > 0) {
                while (cursor1.moveToNext()) {
                    String date = cursor1.getString(cursor1.getColumnIndex(columns[2]));
                    long ndate = Long.parseLong(date);
                    if (ndate >= MimopayCore.this.mCurMillis) {
                        if (this.als == null) {
                            this.als = new ArrayList<>();
                            this.als.add("read");
                        }
                        String address = cursor1.getString(cursor1.getColumnIndex(columns[0]));
                        String name = cursor1.getString(cursor1.getColumnIndex(columns[1]));
                        String msg = cursor1.getString(cursor1.getColumnIndex(columns[3]));
                        JSONArray jarr = new JSONArray();
                        jarr.put(address);
                        jarr.put(name);
                        jarr.put(msg);
                        this.als.add(jarr.toString());
                        MimopayCore.this.mCurMillis = System.currentTimeMillis();
                    }
                }
            }
            return this.als != null;
        }
    }
}
