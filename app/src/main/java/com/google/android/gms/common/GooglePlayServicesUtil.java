package com.google.android.gms.common;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.Dialog;
import android.app.PendingIntent;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.res.Configuration;
import android.content.res.Resources;
import android.net.Uri;
import android.os.Build;
import android.util.Base64;
import android.util.Log;
import com.google.android.gms.R;
import com.google.android.gms.internal.as;
import com.google.android.gms.internal.i;
import com.google.android.gms.internal.m;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.security.cert.CertificateException;
import java.security.cert.CertificateExpiredException;
import java.security.cert.CertificateFactory;
import java.security.cert.CertificateNotYetValidException;
import java.security.cert.X509Certificate;
import java.util.Arrays;
import java.util.NoSuchElementException;
import java.util.Scanner;

/* loaded from: classes.dex */
public final class GooglePlayServicesUtil {
    public static final String GOOGLE_PLAY_SERVICES_PACKAGE = "com.google.android.gms";
    public static final int GOOGLE_PLAY_SERVICES_VERSION_CODE = 3265100;
    public static final String GOOGLE_PLAY_STORE_PACKAGE = "com.android.vending";
    static final byte[][] C = {c("0\u0082\u0004C0\u0082\u0003+ \u0003\u0002\u0001\u0002\u0002\t\u0000Âà\u0087FdJ0\u008d0\r\u0006\t*\u0086H\u0086÷\r\u0001\u0001\u0004\u0005\u00000t1\u000b0\t\u0006\u0003U\u0004\u0006\u0013\u0002US1\u00130\u0011\u0006\u0003U\u0004\b\u0013\nCalifornia1\u00160\u0014\u0006\u0003U\u0004\u0007\u0013\rMountain View1\u00140\u0012\u0006\u0003U\u0004\n\u0013\u000bGoogle Inc.1\u00100\u000e\u0006\u0003U\u0004\u000b\u0013\u0007Android1\u00100\u000e\u0006\u0003U\u0004\u0003\u0013\u0007Android0\u001e\u0017\r080821231334Z\u0017\r360107231334Z0t1\u000b0\t\u0006\u0003U\u0004\u0006\u0013\u0002US1\u00130\u0011\u0006\u0003U\u0004\b\u0013\nCalifornia1\u00160\u0014\u0006\u0003U\u0004\u0007\u0013\rMountain View1\u00140\u0012\u0006\u0003U\u0004\n\u0013\u000bGoogle Inc.1\u00100\u000e\u0006\u0003U\u0004\u000b\u0013\u0007Android1\u00100\u000e\u0006\u0003U\u0004\u0003\u0013\u0007Android0\u0082\u0001 0\r\u0006\t*\u0086H\u0086÷\r\u0001\u0001\u0001\u0005\u0000\u0003\u0082\u0001\r\u00000\u0082\u0001\b\u0002\u0082\u0001\u0001\u0000«V.\u0000Ø;¢\b®\n\u0096o\u0012N)Ú\u0011ò«VÐ\u008fXâÌ©\u0013\u0003é·TÓrö@§\u001b\u001dË\u0013\tgbNFV§wj\u0092\u0019=²å¿·$©\u001ew\u0018\u008b\u000ejG¤;3Ù`\u009bw\u00181EÌß{.XftÉáV[\u001fLjYU¿òQ¦=«ùÅ\\'\"\"Rèuäø\u0015Jd_\u0089qhÀ±¿Æ\u0012ê¿xWi»4ªy\u0084Ü~.¢vL®\u0083\u0007ØÁqT×î_d¥\u001aD¦\u0002ÂI\u0005AWÜ\u0002Í_\\\u000eUûï\u0085\u0019ûã'ð±Q\u0016\u0092Å o\u0019Ñ\u0083\u0085õÄÛÂÖ¹?hÌ)yÇ\u000e\u0018«\u0093\u0086k;ÕÛ\u0089\u0099U*\u000e;L\u0099ßXû\u0091\u008bíÁ\u0082º5à\u0003Á´±\rÒD¨î$ÿý38r«R!\u0098^Ú°ü\r\u000b\u0014[j¡\u0092\u0085\u008ey\u0002\u0001\u0003£\u0081Ù0\u0081Ö0\u001d\u0006\u0003U\u001d\u000e\u0004\u0016\u0004\u0014Ç}\u008cÂ!\u0017V%\u009a\u007fÓ\u0082ßkã\u0098ä×\u0086¥0\u0081¦\u0006\u0003U\u001d#\u0004\u0081\u009e0\u0081\u009b\u0080\u0014Ç}\u008cÂ!\u0017V%\u009a\u007fÓ\u0082ßkã\u0098ä×\u0086¥¡x¤v0t1\u000b0\t\u0006\u0003U\u0004\u0006\u0013\u0002US1\u00130\u0011\u0006\u0003U\u0004\b\u0013\nCalifornia1\u00160\u0014\u0006\u0003U\u0004\u0007\u0013\rMountain View1\u00140\u0012\u0006\u0003U\u0004\n\u0013\u000bGoogle Inc.1\u00100\u000e\u0006\u0003U\u0004\u000b\u0013\u0007Android1\u00100\u000e\u0006\u0003U\u0004\u0003\u0013\u0007Android\u0082\t\u0000Âà\u0087FdJ0\u008d0\f\u0006\u0003U\u001d\u0013\u0004\u00050\u0003\u0001\u0001ÿ0\r\u0006\t*\u0086H\u0086÷\r\u0001\u0001\u0004\u0005\u0000\u0003\u0082\u0001\u0001\u0000mÒRÎï\u00850,6\nªÎ\u0093\u009bÏòÌ©\u0004»]z\u0016aø®F²\u0099B\u0004ÐÿJhÇí\u001aS\u001eÄYZb<æ\u0007c±g)zzãW\u0012Ä\u0007ò\bðË\u0010\u0094)\u0012M{\u0010b\u0019À\u0084Ê>³ù\u00ad_¸qï\u0092&\u009a\u008bâ\u008bñmDÈÙ \u008el²ð\u0005»?âË\u0096D~\u0086\u008es\u0010v\u00adE³?`\tê\u0019Áaæ&Aª\u0099'\u001dýR(ÅÅ\u0087\u0087]Û\u007fE'XÖaöÌ\fÌ·5.BLÄ6\\R52÷2Q7Y<JãAôÛAíÚ\r\u000b\u0010q§Ä@ðþ\u009e \u001c¶'ÊgCiÐ\u0084½/Ù\u0011ÿ\u0006Í¿,ú\u0010Ü\u000f\u0089:ãWb\u0091\u0090HÇïÆLqD\u0017\u0083B÷\u0005\u0081ÉÞW:õ[9\r×ý¹A\u00861\u0089]_u\u009f0\u0011&\u0087ÿb\u0014\u0010Ài0\u008a"), c("0\u0082\u0004¨0\u0082\u0003\u0090 \u0003\u0002\u0001\u0002\u0002\t\u0000Õ\u0085¸l}ÓNõ0\r\u0006\t*\u0086H\u0086÷\r\u0001\u0001\u0004\u0005\u00000\u0081\u00941\u000b0\t\u0006\u0003U\u0004\u0006\u0013\u0002US1\u00130\u0011\u0006\u0003U\u0004\b\u0013\nCalifornia1\u00160\u0014\u0006\u0003U\u0004\u0007\u0013\rMountain View1\u00100\u000e\u0006\u0003U\u0004\n\u0013\u0007Android1\u00100\u000e\u0006\u0003U\u0004\u000b\u0013\u0007Android1\u00100\u000e\u0006\u0003U\u0004\u0003\u0013\u0007Android1\"0 \u0006\t*\u0086H\u0086÷\r\u0001\t\u0001\u0016\u0013android@android.com0\u001e\u0017\r080415233656Z\u0017\r350901233656Z0\u0081\u00941\u000b0\t\u0006\u0003U\u0004\u0006\u0013\u0002US1\u00130\u0011\u0006\u0003U\u0004\b\u0013\nCalifornia1\u00160\u0014\u0006\u0003U\u0004\u0007\u0013\rMountain View1\u00100\u000e\u0006\u0003U\u0004\n\u0013\u0007Android1\u00100\u000e\u0006\u0003U\u0004\u000b\u0013\u0007Android1\u00100\u000e\u0006\u0003U\u0004\u0003\u0013\u0007Android1\"0 \u0006\t*\u0086H\u0086÷\r\u0001\t\u0001\u0016\u0013android@android.com0\u0082\u0001 0\r\u0006\t*\u0086H\u0086÷\r\u0001\u0001\u0001\u0005\u0000\u0003\u0082\u0001\r\u00000\u0082\u0001\b\u0002\u0082\u0001\u0001\u0000ÖÎ.\b\n¿â1MÑ\u008d³ÏÓ\u0018\\´=3ú\ftá½¶ÑÛ\u0089\u0013ö,\\9ßVøF\u0081=e¾ÀóÊBk\u0007Å¨íZ9\u0090ÁgçkÉ\u0099¹'\u0089K\u008f\u000b\"\u0000\u0019\u0094©)\u0015årÅm*0\u001b£oÅü\u0011:ÖË\u009et5¡m#«}úîáeäß\u001f\n\u008d½§\n\u0086\u009dQlN\u009d\u0005\u0011\u0096Ê|\fU\u007f\u0017[ÃuùHÅj®\u0086\b\u009b¤O\u008a¦¤Ý\u009a}¿,\n5\"\u0082\u00ad\u0006¸Ì\u0018^±Uyîøm\b\u000b\u001da\u0089Àù¯\u0098±ÂëÑ\u0007êE«Ûh£Ç\u0083\u008a^T\u0088ÇlSÔ\u000b\u0012\u001dç»Ó\u000eb\f\u0018\u008aáªaÛ¼\u0087Ý<d_/UóÔÃuì@p©?qQØ6pÁj\u0097\u001a¾^òÑ\u0018\u0090á¸®ó)\u008cðf¿\u009eláD¬\u009aèm\u001c\u001b\u000f\u0002\u0001\u0003£\u0081ü0\u0081ù0\u001d\u0006\u0003U\u001d\u000e\u0004\u0016\u0004\u0014\u008d\u001cÅ¾\u0095LC<a\u0086:\u0015°L¼\u0003òOà²0\u0081É\u0006\u0003U\u001d#\u0004\u0081Á0\u0081¾\u0080\u0014\u008d\u001cÅ¾\u0095LC<a\u0086:\u0015°L¼\u0003òOà²¡\u0081\u009a¤\u0081\u00970\u0081\u00941\u000b0\t\u0006\u0003U\u0004\u0006\u0013\u0002US1\u00130\u0011\u0006\u0003U\u0004\b\u0013\nCalifornia1\u00160\u0014\u0006\u0003U\u0004\u0007\u0013\rMountain View1\u00100\u000e\u0006\u0003U\u0004\n\u0013\u0007Android1\u00100\u000e\u0006\u0003U\u0004\u000b\u0013\u0007Android1\u00100\u000e\u0006\u0003U\u0004\u0003\u0013\u0007Android1\"0 \u0006\t*\u0086H\u0086÷\r\u0001\t\u0001\u0016\u0013android@android.com\u0082\t\u0000Õ\u0085¸l}ÓNõ0\f\u0006\u0003U\u001d\u0013\u0004\u00050\u0003\u0001\u0001ÿ0\r\u0006\t*\u0086H\u0086÷\r\u0001\u0001\u0004\u0005\u0000\u0003\u0082\u0001\u0001\u0000\u0019Ó\fñ\u0005ûx\u0092?L\r}Ò##=@\u0096zÏÎ\u0000\b\u001d[×ÆéÖí k\u000e\u0011 \u0095\u0006Al¢D\u0093\u0099\u0013ÒkJ àõ$ÊÒ»\\nL¡\u0001j\u0015\u0091n¡ì]ÉZ^:\u0001\u00006ô\u0092HÕ\u0010\u009b¿.\u001ea\u0081\u0086g:;åm¯\u000bw±Â)ãÂUãèL\u0090]#\u0087ïº\tËñ; +NZ\"É2cHJ#Òü)ú\u009f\u00199u\u00973¯Øª\u0016\u000fB\u0096ÂÐ\u0016>\u0081\u0082\u0085\u009cfCéÁ\u0096/ Á\u008333[À\u0090ÿ\u009ak\"ÞÑ\u00adDB)¥9©Nï\u00ad«ÐeÎÒK>QåÝ{fx{ï\u0012þ\u0097û¤\u0084Ä#ûOøÌIL\u0002ðõ\u0005\u0016\u0012ÿe)9>\u008eFêÅ»!òwÁQª_*¦'Ñè\u009d§\n¶\u00035iÞ;\u0098\u0097¿ÿ|©Ú>\u0012Cö\u000b")};
    static final byte[][] D = {c("0\u0082\u0002R0\u0082\u0001»\u0002\u0004I4\u0098~0\r\u0006\t*\u0086H\u0086÷\r\u0001\u0001\u0004\u0005\u00000p1\u000b0\t\u0006\u0003U\u0004\u0006\u0013\u0002US1\u000b0\t\u0006\u0003U\u0004\b\u0013\u0002CA1\u00160\u0014\u0006\u0003U\u0004\u0007\u0013\rMountain View1\u00140\u0012\u0006\u0003U\u0004\n\u0013\u000bGoogle, Inc1\u00140\u0012\u0006\u0003U\u0004\u000b\u0013\u000bGoogle, Inc1\u00100\u000e\u0006\u0003U\u0004\u0003\u0013\u0007Unknown0\u001e\u0017\r081202020758Z\u0017\r360419020758Z0p1\u000b0\t\u0006\u0003U\u0004\u0006\u0013\u0002US1\u000b0\t\u0006\u0003U\u0004\b\u0013\u0002CA1\u00160\u0014\u0006\u0003U\u0004\u0007\u0013\rMountain View1\u00140\u0012\u0006\u0003U\u0004\n\u0013\u000bGoogle, Inc1\u00140\u0012\u0006\u0003U\u0004\u000b\u0013\u000bGoogle, Inc1\u00100\u000e\u0006\u0003U\u0004\u0003\u0013\u0007Unknown0\u0081\u009f0\r\u0006\t*\u0086H\u0086÷\r\u0001\u0001\u0001\u0005\u0000\u0003\u0081\u008d\u00000\u0081\u0089\u0002\u0081\u0081\u0000\u009fH\u0003\u0019\u0090ù±G&8N\u0004SÑ\u008f\u008c\u000b¿\u008dÇ{%\u0004¤± |LlDº¼\u0000\u00adÆa\u000f¦¶«-¨\u000e3òîñk&£ö¸[\u009aúÊ\u0090\u009fû¾³ôÉO~\u0081\"§\u0098àë§\\í=Ò)úseô\u0015\u0016AZ©Áa}Õ\u0083Î\u0019ºè »Ø\u0085ü\u0017©´½&@\u0080Q!ªÛ\u0093wÞ´\u0000\u00138\u0014\u0018\u0088.Å\"\u0082üX\r\u0002\u0003\u0001\u0000\u00010\r\u0006\t*\u0086H\u0086÷\r\u0001\u0001\u0004\u0005\u0000\u0003\u0081\u0081\u0000@\u0086f\u009eÖ1ÚC\u0084ÝÐaÒ&às¹\u008cÄ¹\u009døµä¾\u009e<¾\u0097P\u001e\u0083ß\u001co©YÀÎ`\\OÒ¬m\u001c\u0084ÎÞ Glº±\u009bèò :ÿw\u0017\u00ade-\u008fÌ\u0089\u0007\bÑ!m¨DWY&IàéÓÄ»Lõ\u008d¡\u009d±ÔüA¼¹XOdæ_A\r\u0005)ý[h\u0083\u008c\u0014\u001d\n\u009bÑÛ\u0011\u0091Ë*\r÷\u0090ê\f±-³¤"), c("0\u0082\u0004¨0\u0082\u0003\u0090 \u0003\u0002\u0001\u0002\u0002\t\u0000\u0084~OòÖµÞ\u008e0\r\u0006\t*\u0086H\u0086÷\r\u0001\u0001\u0005\u0005\u00000\u0081\u00941\u000b0\t\u0006\u0003U\u0004\u0006\u0013\u0002US1\u00130\u0011\u0006\u0003U\u0004\b\u0013\nCalifornia1\u00160\u0014\u0006\u0003U\u0004\u0007\u0013\rMountain View1\u00100\u000e\u0006\u0003U\u0004\n\u0013\u0007Android1\u00100\u000e\u0006\u0003U\u0004\u000b\u0013\u0007Android1\u00100\u000e\u0006\u0003U\u0004\u0003\u0013\u0007Android1\"0 \u0006\t*\u0086H\u0086÷\r\u0001\t\u0001\u0016\u0013android@android.com0\u001e\u0017\r100120010135Z\u0017\r370607010135Z0\u0081\u00941\u000b0\t\u0006\u0003U\u0004\u0006\u0013\u0002US1\u00130\u0011\u0006\u0003U\u0004\b\u0013\nCalifornia1\u00160\u0014\u0006\u0003U\u0004\u0007\u0013\rMountain View1\u00100\u000e\u0006\u0003U\u0004\n\u0013\u0007Android1\u00100\u000e\u0006\u0003U\u0004\u000b\u0013\u0007Android1\u00100\u000e\u0006\u0003U\u0004\u0003\u0013\u0007Android1\"0 \u0006\t*\u0086H\u0086÷\r\u0001\t\u0001\u0016\u0013android@android.com0\u0082\u0001 0\r\u0006\t*\u0086H\u0086÷\r\u0001\u0001\u0001\u0005\u0000\u0003\u0082\u0001\r\u00000\u0082\u0001\b\u0002\u0082\u0001\u0001\u0000Ø(q|6Ñ\u0017\u000fÔM\n{\u000f\u0007\u0011&è[¿ß3°4`\u0000Z\u0094Ìûe¥Û ²Cß`±\u0091¿\u009d\u0006ß\u001d\u008a\\\n3âÑcõ\u0013ß\u001d\"SAê<3y\"è\\\u0002ì4ÎÙL¸\u0007#¦#ÿK¯û´åïæw;>¢¾¸¼²\u0002gÏç\u0085Q\u001f\u0083.ù\u0087«u\u0094þ\u001e)Ï¼M\b:\u001f\u0012R\u0000ws\u0096ò\u0016[i{\u0000£ Á:Ì0\u008a\u0093ò!cÁn\u009c=J²\u0014\u009f6LEÀC\u00142p9ñÚ\t`\u0093ñ³ü\u0018¶V\u0010\u0095Æ\"_Ç\u0010+\u0098|o\u0013¤]$ãàÅN\u0085\u009dgã[g\b'\u0013ÒÖðWÝ4WÑ\u009fÄþ\u008dÝì\u008c:O?\u0097#\u0005\u0019§\n(64¬5\u0081£J½¡}\u0084Z\n\t\u0085ûø\u0006\u000b\u0003j'x`\u0081cú\f7¹çò¡\u000ev¼w\u0002\u0001\u0003£\u0081ü0\u0081ù0\u001d\u0006\u0003U\u001d\u000e\u0004\u0016\u0004\u0014µÇù\u0012ox\r:ûÊess?õ\"k\u009b\u001770\u0081É\u0006\u0003U\u001d#\u0004\u0081Á0\u0081¾\u0080\u0014µÇù\u0012ox\r:ûÊess?õ\"k\u009b\u00177¡\u0081\u009a¤\u0081\u00970\u0081\u00941\u000b0\t\u0006\u0003U\u0004\u0006\u0013\u0002US1\u00130\u0011\u0006\u0003U\u0004\b\u0013\nCalifornia1\u00160\u0014\u0006\u0003U\u0004\u0007\u0013\rMountain View1\u00100\u000e\u0006\u0003U\u0004\n\u0013\u0007Android1\u00100\u000e\u0006\u0003U\u0004\u000b\u0013\u0007Android1\u00100\u000e\u0006\u0003U\u0004\u0003\u0013\u0007Android1\"0 \u0006\t*\u0086H\u0086÷\r\u0001\t\u0001\u0016\u0013android@android.com\u0082\t\u0000\u0084~OòÖµÞ\u008e0\f\u0006\u0003U\u001d\u0013\u0004\u00050\u0003\u0001\u0001ÿ0\r\u0006\t*\u0086H\u0086÷\r\u0001\u0001\u0005\u0005\u0000\u0003\u0082\u0001\u0001\u0000L>§e}&æ»×\u0011\f\u008f\u0019ß\u001f\u008d¡\t}3\u0086\u000fiÞ¿ÊÛF£~\u0087å³\u000f»4{\u001cuU¼»<\u0099T\u0014\u0080F\u0096_\u009cy*\u0002ÐÛå¦Ga³yG«kÿ°ºÆ¢Á Íøbøw©g\rýo\u0006.@nÎ\u0018\u0006\f`I\u008dü6\u009f'\u0011q\u0098åoË¡Ræ\u0005\u008dÎ\u0094ÎY\u001fÄô©\u0098+3ºØ\u0019mwoU·Ð\u001aÏ1Ý×\fì·\u0089xv\u0006e\u0010ùI¥RJ11³ËeAÏ\u008b5B\u000e¼ÄR%Y\u0096?Bfi\u0005rfbO³\u0098ÏÛR\u0017\u0088\u001d\u0011\u001cn\u0003F\u0016øQ!\u0018Ð¢¦\u009d\u0013×\u0092ðÍ\u0011ÛÕ\u008e#\u0083ZT¥JÂQçÒ,Dj?î\u0014\u0012\u0010éDGK@c\u0007»&\u0084+OkÓU\u0082\u001cs\u0096Qÿ¢`[\u0005â$\u0095×\u0015Øz\u0091ö")};
    static final byte[][] E = {c("0\u0082\u0002§0\u0082\u0002e \u0003\u0002\u0001\u0002\u0002\u0004P\u0005|B0\u000b\u0006\u0007*\u0086HÎ8\u0004\u0003\u0005\u0000071\u000b0\t\u0006\u0003U\u0004\u0006\u0013\u0002US1\u00100\u000e\u0006\u0003U\u0004\n\u0013\u0007Android1\u00160\u0014\u0006\u0003U\u0004\u0003\u0013\rAndroid Debug0\u001e\u0017\r120717145250Z\u0017\r220715145250Z071\u000b0\t\u0006\u0003U\u0004\u0006\u0013\u0002US1\u00100\u000e\u0006\u0003U\u0004\n\u0013\u0007Android1\u00160\u0014\u0006\u0003U\u0004\u0003\u0013\rAndroid Debug0\u0082\u0001·0\u0082\u0001,\u0006\u0007*\u0086HÎ8\u0004\u00010\u0082\u0001\u001f\u0002\u0081\u0081\u0000ý\u007fS\u0081\u001du\u0012)RßJ\u009c.ìäçö\u0011·R<ïD\u0000Ã\u001e?\u0080¶Q&iE]@\"QûY=\u008dXú¿Åõº0öË\u009bUl×\u0081;\u0080\u001d4oòf`·k\u0099P¥¤\u009f\u009fè\u0004{\u0010\"ÂO»©×þ·Æ\u001bø;WçÆ¨¦\u0015\u000f\u0004û\u0083öÓÅ\u001eÃ\u00025T\u0013Z\u0016\u00912öuó®+a×*ïò\"\u0003\u0019\u009dÑH\u0001Ç\u0002\u0015\u0000\u0097`P\u008f\u0015#\u000bÌ²\u0092¹\u0082¢ë\u0084\u000bðX\u001cõ\u0002\u0081\u0081\u0000÷á \u0085Ö\u009b=ÞË¼«\\6¸W¹y\u0094¯»ú:ê\u0082ùWL\u000b=\u0007\u0082gQYW\u008eºÔYOæq\u0007\u0010\u0081\u0080´I\u0016q#èL(\u0016\u0013·Ï\t2\u008cÈ¦á<\u0016z\u008bT|\u008d(à£®\u001e+³¦u\u0091n£\u007f\u000bú!5bñûbz\u0001$;Ì¤ñ¾¨Q\u0090\u0089¨\u0083ßáZå\u009f\u0006\u0092\u008bf^\u0080{U%d\u0001L;þÏI*\u0003\u0081\u0084\u0000\u0002\u0081\u0080jÑ\u001b×ÕfÒzô9À.Ah¬ýE´¾\u0085¼\u0099\u008c{\u009b\u008e\u001cwTi?\u008c\rB\u008a¤üá\u0010\u0084\u00818BO¦\u008cÑ0RNïöñ78c\u0082/¦7)\u008bþMF ¸feîðA\u00179\u0001\u0003[\u001c\u0080j£\u0018\u0018\r0:¨Ì\u009eY#àjo«úuh<E;²\u0007w|òýçÏ±\u009b\u001408\u0014ª\u001d÷´=[\"+W\u0006´\u008b\u00940\u000b\u0006\u0007*\u0086HÎ8\u0004\u0003\u0005\u0000\u0003/\u00000,\u0002\u0014\tÒÑ°G\u0002)µ¾Ò\u0090&aÑ\u0012òpÅæ\u001d\u0002\u0014gP\u0002\u0006§\u0080Pºx®Ç\u0017O\u0016\u0004\u007f\u0084ê¢÷")};
    static final byte[][] F = {c("0\u0082\u0004L0\u0082\u00034 \u0003\u0002\u0001\u0002\u0002\t\u0000¨Í\u0017É=¥Ù\u00900\r\u0006\t*\u0086H\u0086÷\r\u0001\u0001\u0005\u0005\u00000w1\u000b0\t\u0006\u0003U\u0004\u0006\u0013\u0002US1\u00130\u0011\u0006\u0003U\u0004\b\u0013\nCalifornia1\u00160\u0014\u0006\u0003U\u0004\u0007\u0013\rMountain View1\u00140\u0012\u0006\u0003U\u0004\n\u0013\u000bGoogle Inc.1\u00100\u000e\u0006\u0003U\u0004\u000b\u0013\u0007Android1\u00130\u0011\u0006\u0003U\u0004\u0003\u0013\nGoogle NFC0\u001e\u0017\r110324010653Z\u0017\r380809010653Z0w1\u000b0\t\u0006\u0003U\u0004\u0006\u0013\u0002US1\u00130\u0011\u0006\u0003U\u0004\b\u0013\nCalifornia1\u00160\u0014\u0006\u0003U\u0004\u0007\u0013\rMountain View1\u00140\u0012\u0006\u0003U\u0004\n\u0013\u000bGoogle Inc.1\u00100\u000e\u0006\u0003U\u0004\u000b\u0013\u0007Android1\u00130\u0011\u0006\u0003U\u0004\u0003\u0013\nGoogle NFC0\u0082\u0001 0\r\u0006\t*\u0086H\u0086÷\r\u0001\u0001\u0001\u0005\u0000\u0003\u0082\u0001\r\u00000\u0082\u0001\b\u0002\u0082\u0001\u0001\u0000Ã\u000f\u0088\u00adÙ´\u0092\tj,XjZ\u009a\u00805kú\u0002iXøÿ\f]úõ\u009fI&\u008aØpÞè!¥>\u001f[\u0017\u000fÉbE£É\u0082§ËE'\u0005;ã^4ó\u0096ÒK\"\u0091ì\fR\u008dn&\u0092teàhuêb\u001f\u007fù\u008c@ã4[ I\u0007Ì\u0093Tt:ÍªÎeV_HºtÍA!ÍÈvß5\"ºÛ\t\\ Ù4Åj>\\9>åðà/\u008fàb\u001f\u0091\u008d\u001f5¨$\u0089%,o¦¶3\u0092§hk>Ha-\u0006©ÏoI¿ñ\u001d]\u0096(\u009c\u009dþ\u0014¬WbC\u0096\u0097Ý)êý¹\u0081\rã&5\u0013©\u0005¬\u008e\u008e¯ \u0090~Fu\nZ·¿\u009aw&/G°?Z<nm{Q4?iÇ÷%÷\u000bÌ\u001bJÕ\u0092%\u000bpZ\u0086æè>â®7þW\u0001¼½²oîýÿö\u000fj[ßµ¶G\u0093\u0002\u0001\u0003£\u0081Ü0\u0081Ù0\u001d\u0006\u0003U\u001d\u000e\u0004\u0016\u0004\u0014\u001cÎÎ\u000eêMÁ\u0012\u001fÇQ_\r\n\frà\u008cÉm0\u0081©\u0006\u0003U\u001d#\u0004\u0081¡0\u0081\u009e\u0080\u0014\u001cÎÎ\u000eêMÁ\u0012\u001fÇQ_\r\n\frà\u008cÉm¡{¤y0w1\u000b0\t\u0006\u0003U\u0004\u0006\u0013\u0002US1\u00130\u0011\u0006\u0003U\u0004\b\u0013\nCalifornia1\u00160\u0014\u0006\u0003U\u0004\u0007\u0013\rMountain View1\u00140\u0012\u0006\u0003U\u0004\n\u0013\u000bGoogle Inc.1\u00100\u000e\u0006\u0003U\u0004\u000b\u0013\u0007Android1\u00130\u0011\u0006\u0003U\u0004\u0003\u0013\nGoogle NFC\u0082\t\u0000¨Í\u0017É=¥Ù\u00900\f\u0006\u0003U\u001d\u0013\u0004\u00050\u0003\u0001\u0001ÿ0\r\u0006\t*\u0086H\u0086÷\r\u0001\u0001\u0005\u0005\u0000\u0003\u0082\u0001\u0001\u0000¤pÇ(áÓ\u001b\u0006Ù¯jçhµe\u0004lW\u0080k\u0098CrI1×]L¡\f2\u0015 Ó<Ïí*¦Tb#L\u009eù¶ù\u0010Ìgk\u0099Ë\u007f\u0098\u0095ÖÀgcWO»x3\u0012uÜ\\ó\u008fº©\u0018×\u0093\u008c\u0005\u001fû¢\u00adèó\u0003ÍèÙæ\u008a\u0004\u008d\u001fÛ\u009e|\u009f*I²\"Æ\u008fÿB+ñUi¸^îí°J£\bsÛæK\u009c\u009etøòÂöÄ\u0001$ª¨Ñx\r\u0018Q+T\nÝ(³éX\u0019q¤\u0017\rØhÏ_1äG\u0012²Â;µ\u00107×ï\u009f\u0087¦å½³^,ëk°\"cl\u0017¥j\u0096¼zP%\u008c\u000bÒí{1UZ\u0018E.\u00172\u001a\rR\u0083\u008c\u0082ö?t-tÿyXj\\»\u007f¯q\u0098¨KÏtC\u0010éé'Y\u007f\u0000¢=Ð\u0006`\u0080\f\"8Ù\u000b/³rßÛºu½\u0085."), c("0\u0082\u0004L0\u0082\u00034 \u0003\u0002\u0001\u0002\u0002\t\u0000Þv\u0095\u0004\u001dvPÀ0\r\u0006\t*\u0086H\u0086÷\r\u0001\u0001\u0005\u0005\u00000w1\u000b0\t\u0006\u0003U\u0004\u0006\u0013\u0002US1\u00130\u0011\u0006\u0003U\u0004\b\u0013\nCalifornia1\u00160\u0014\u0006\u0003U\u0004\u0007\u0013\rMountain View1\u00140\u0012\u0006\u0003U\u0004\n\u0013\u000bGoogle Inc.1\u00100\u000e\u0006\u0003U\u0004\u000b\u0013\u0007Android1\u00130\u0011\u0006\u0003U\u0004\u0003\u0013\nGoogle NFC0\u001e\u0017\r110324010324Z\u0017\r380809010324Z0w1\u000b0\t\u0006\u0003U\u0004\u0006\u0013\u0002US1\u00130\u0011\u0006\u0003U\u0004\b\u0013\nCalifornia1\u00160\u0014\u0006\u0003U\u0004\u0007\u0013\rMountain View1\u00140\u0012\u0006\u0003U\u0004\n\u0013\u000bGoogle Inc.1\u00100\u000e\u0006\u0003U\u0004\u000b\u0013\u0007Android1\u00130\u0011\u0006\u0003U\u0004\u0003\u0013\nGoogle NFC0\u0082\u0001 0\r\u0006\t*\u0086H\u0086÷\r\u0001\u0001\u0001\u0005\u0000\u0003\u0082\u0001\r\u00000\u0082\u0001\b\u0002\u0082\u0001\u0001\u0000æÿ=ïé*¡\rqë\u000f¦@\u008bÀ6·âCîíh¦¤v=Ç¥*1u|ÚÆ\u001få\u0010»sÇ\u0016ä\u0000\u0001\u0004&[4\u007fÎÎôÄ+ñá7\u009dÐ¨vð(\"\u007f»Áù½Õ×\u0013²ö©5£yÒË©Éo\u0092ÒÐx|\u0011ñë\u0019T\u0080\b¦ r³K\u0091\u0083lú\ná'g\u0080é\u0000u0\u0016i\u0086¡\u001c\u009cïFÎ÷Ç\u0004\u0080mÞ\u00941û`(M\u0012\n°çÞ\u001dc?\u0007h}F\u008cQ\u0013\u009aÿýÆ¼\u009a |©\u0004¸¾\u001d ª{N\u0097uoC`d\u0088¾\\®<hè»yBÍõ\u0016\u0007É0¢üÚe[uÐu\u009cº\u0089\u00ad\u0006ç9½\u000b¢\u009b\u001f@B\u0096ÂÀ¨Z\u0084\u007fZ°ÐgÆÃì\u009cI! B¬c§å;Tle´`\u0080´ãæ\u0080â>\u001fwÏçöÞtK\u001ae\u0002\u0001\u0003£\u0081Ü0\u0081Ù0\u001d\u0006\u0003U\u001d\u000e\u0004\u0016\u0004\u0014¢è\u0090d°]\b\u0086\\4Û\u0093\n\u009d\u0084\u0000P\u0011zì0\u0081©\u0006\u0003U\u001d#\u0004\u0081¡0\u0081\u009e\u0080\u0014¢è\u0090d°]\b\u0086\\4Û\u0093\n\u009d\u0084\u0000P\u0011zì¡{¤y0w1\u000b0\t\u0006\u0003U\u0004\u0006\u0013\u0002US1\u00130\u0011\u0006\u0003U\u0004\b\u0013\nCalifornia1\u00160\u0014\u0006\u0003U\u0004\u0007\u0013\rMountain View1\u00140\u0012\u0006\u0003U\u0004\n\u0013\u000bGoogle Inc.1\u00100\u000e\u0006\u0003U\u0004\u000b\u0013\u0007Android1\u00130\u0011\u0006\u0003U\u0004\u0003\u0013\nGoogle NFC\u0082\t\u0000Þv\u0095\u0004\u001dvPÀ0\f\u0006\u0003U\u001d\u0013\u0004\u00050\u0003\u0001\u0001ÿ0\r\u0006\t*\u0086H\u0086÷\r\u0001\u0001\u0005\u0005\u0000\u0003\u0082\u0001\u0001\u00007q\u0087\fè|<Rê\u0084\u0089\u00920ÆébÙKM_\u0012\u0093Â]\u0088&\u0015Aý\u0090µU]\u0012\u0085Îó¸1,?]ö\u0091¨ªàL¹\u0081³\u0005ä'ý\u001d-\u009e\u0019\u0087áÒ\u0090xñ<\u0084R\u0099\u000f\u0018!\u0098\u0002cØÔ½6Q\u0093HØØº&Ø¹\u009f¿\tõý>»\u000e£ÂðÉ7o\u001e\u001fÊvó¦¤\u0005B\u009d\b\u001bu*z\u0090·Vé«DÚA«Èáèø\u008aÂu\u008d§CûsæPq\u009aW\u0084\fËkzÝ!¹\u009fÆ\u0081äVá\u0087,\"=\\\u0007JßUö«Ú&\u008c-\u008bdê\n\u0088EîÍ\u0096\u008f\u0092´\u0093\u0012~uÇSÃÿ0ËÆxµ\u001c\u009fR\u0096\u0014rñ}¢\n\rÆ'J¢F44Á©¶\u0014ßi}\u008fõÊ\u0081\u0001ç¢\\}³û\u0005]eV\u009c\u0004°\u001d8\u009c«ºW³¡p>ÂçJ\u0088Ó4")};
    private static final byte[][] G = a(C, D, E, F);
    private static final byte[][] H = {C[0], D[0], F[0]};
    static final byte[][] I = {c("0\u0082\u0002_0\u0082\u0001È \u0003\u0002\u0001\u0002\u0002\u0004K\u0019±\u009d0\r\u0006\t*\u0086H\u0086÷\r\u0001\u0001\u0005\u0005\u00000t1\u000b0\t\u0006\u0003U\u0004\u0006\u0013\u0002US1\u00130\u0011\u0006\u0003U\u0004\b\u0013\nCalifornia1\u00160\u0014\u0006\u0003U\u0004\u0007\u0013\rMountain View1\u00150\u0013\u0006\u0003U\u0004\n\u0013\fGoogle, Inc.1\u00100\u000e\u0006\u0003U\u0004\u000b\u0013\u0007Unknown1\u000f0\r\u0006\u0003U\u0004\u0003\u0013\u0006Bazaar0\u001e\u0017\r091205010429Z\u0017\r370422010429Z0t1\u000b0\t\u0006\u0003U\u0004\u0006\u0013\u0002US1\u00130\u0011\u0006\u0003U\u0004\b\u0013\nCalifornia1\u00160\u0014\u0006\u0003U\u0004\u0007\u0013\rMountain View1\u00150\u0013\u0006\u0003U\u0004\n\u0013\fGoogle, Inc.1\u00100\u000e\u0006\u0003U\u0004\u000b\u0013\u0007Unknown1\u000f0\r\u0006\u0003U\u0004\u0003\u0013\u0006Bazaar0\u0081\u009f0\r\u0006\t*\u0086H\u0086÷\r\u0001\u0001\u0001\u0005\u0000\u0003\u0081\u008d\u00000\u0081\u0089\u0002\u0081\u0081\u0000©\b\u0088Þ\u0096ã54w\tÝK%\u001ez)¨G7k.\\º[[Õ\u0004>\u0083\u0088\u0001\u0002\u0098\u0019\u0014\u0094\u0013ú3ªåD;\u0003SJÎJ\u00adoP\u0097\u0012IÙ\u008ev£\u009a~LÌá×\u001b§¾>ugMµñ\u0007Z\u0098sp\u0001FH§Îp<-Ç\u00884\u0089\u0005\u0092\u0012¯\u009cl[(«ÕO\u0083d\u0011È1¢\u009fP\u000f(\u0002ÑlæÑ\u0085o\u0086pªü¢eA\u0083{9\u0002\u0003\u0001\u0000\u00010\r\u0006\t*\u0086H\u0086÷\r\u0001\u0001\u0005\u0005\u0000\u0003\u0081\u0081\u0000I\u0084ÆóAG\u0001#b:'Oéá7=u1Ì\rüé§jæ\u007fûp[@L½\u001bÁ\u0016\u008c«\u0018»\u0011Ãx\u0095¿´ólÁLì\u001d,ÅQj\u000eÎÔ\u0007Nµh\u0082\u0089Pd\u0000¯øÜÈïT\u0004\u0012\u0002ýïñý\u0082àó#\u0010rýÌÞJ6\u008bàÆÃù¸³ª\rh<:¿Ú\u009a·»\u00882é¾^6\u0019º\u0092Ý:Ì\u0003j\u00adµ¦\u0019¯P")};
    public static boolean J = false;
    public static boolean K = false;
    static boolean L = false;
    private static int M = -1;
    private static final Object N = new Object();

    private GooglePlayServicesUtil() {
    }

    public static Dialog a(int i, Activity activity, int i2, DialogInterface.OnCancelListener onCancelListener, int i3) {
        AlertDialog.Builder message = new AlertDialog.Builder(activity).setMessage(b(activity, i, i3));
        if (onCancelListener != null) {
            message.setOnCancelListener(onCancelListener);
        }
        i iVar = new i(activity, a(activity, i, i3), i2);
        String strA = a(activity, i);
        if (strA != null) {
            message.setPositiveButton(strA, iVar);
        }
        switch (i) {
            case 0:
                break;
            case 1:
                break;
            case 2:
                break;
            case 3:
                break;
            case 4:
            case 6:
                break;
            case 5:
                Log.e("GooglePlayServicesUtil", "An invalid account was specified when connecting. Please provide a valid account.");
                break;
            case 7:
                Log.e("GooglePlayServicesUtil", "Network error occurred. Please retry request later.");
                break;
            case 8:
                Log.e("GooglePlayServicesUtil", "Internal error occurred. Please see logs for detailed information");
                break;
            case 9:
                Log.e("GooglePlayServicesUtil", "Google Play services is invalid. Cannot recover.");
                break;
            case 10:
                Log.e("GooglePlayServicesUtil", "Developer error occurred. Please see logs for detailed information");
                break;
            case 11:
                Log.e("GooglePlayServicesUtil", "The application is not licensed to the user.");
                break;
            default:
                Log.e("GooglePlayServicesUtil", "Unexpected error code " + i);
                break;
        }
        return message.setTitle(R.string.common_google_play_services_unknown_issue).create();
    }

    public static Intent a(Context context, int i, int i2) {
        switch (i) {
            case 1:
            case 2:
                return b(i2) ? c(context) ? m.l(GOOGLE_PLAY_SERVICES_PACKAGE) : m.k("com.google.android.apps.bazaar") : m.k(GOOGLE_PLAY_SERVICES_PACKAGE);
            case 3:
                return m.i(GOOGLE_PLAY_SERVICES_PACKAGE);
            default:
                return null;
        }
    }

    public static String a(Context context, int i) {
        Resources resources = context.getResources();
        switch (i) {
            case 1:
                return resources.getString(R.string.common_google_play_services_install_button);
            case 2:
                return resources.getString(R.string.common_google_play_services_update_button);
            case 3:
                return resources.getString(R.string.common_google_play_services_enable_button);
            default:
                return resources.getString(android.R.string.ok);
        }
    }

    public static boolean a(Resources resources) {
        return (as.an() && ((resources.getConfiguration().screenLayout & 15) > 3)) || b(resources);
    }

    private static byte[] a(PackageInfo packageInfo, byte[]... bArr) throws CertificateException {
        try {
            CertificateFactory certificateFactory = CertificateFactory.getInstance("X509");
            if (packageInfo.signatures.length != 1) {
                Log.w("GooglePlayServicesUtil", "Package has more than one signature.");
                return null;
            }
            try {
                try {
                    ((X509Certificate) certificateFactory.generateCertificate(new ByteArrayInputStream(packageInfo.signatures[0].toByteArray()))).checkValidity();
                    byte[] byteArray = packageInfo.signatures[0].toByteArray();
                    for (byte[] bArr2 : bArr) {
                        if (Arrays.equals(bArr2, byteArray)) {
                            return bArr2;
                        }
                    }
                    if (Log.isLoggable("GooglePlayServicesUtil", 2)) {
                        Log.v("GooglePlayServicesUtil", "Signature not valid.  Found: \n" + Base64.encodeToString(byteArray, 0));
                    }
                    return null;
                } catch (CertificateExpiredException e) {
                    Log.w("GooglePlayServicesUtil", "Certificate has expired.");
                    return null;
                } catch (CertificateNotYetValidException e2) {
                    Log.w("GooglePlayServicesUtil", "Certificate is not yet valid.");
                    return null;
                }
            } catch (CertificateException e3) {
                Log.w("GooglePlayServicesUtil", "Could not generate certificate.");
                return null;
            }
        } catch (CertificateException e4) {
            Log.w("GooglePlayServicesUtil", "Could not get certificate instance.");
            return null;
        }
    }

    private static byte[][] a(byte[][]... bArr) {
        int length = 0;
        for (byte[][] bArr2 : bArr) {
            length += bArr2.length;
        }
        byte[][] bArr3 = new byte[length][];
        int length2 = bArr.length;
        int i = 0;
        int i2 = 0;
        while (i < length2) {
            byte[][] bArr4 = bArr[i];
            int i3 = i2;
            int i4 = 0;
            while (i4 < bArr4.length) {
                bArr3[i3] = bArr4[i4];
                i4++;
                i3++;
            }
            i++;
            i2 = i3;
        }
        return bArr3;
    }

    public static String b(Context context, int i, int i2) throws Resources.NotFoundException {
        Resources resources = context.getResources();
        switch (i) {
            case 1:
                String string = a(context.getResources()) ? resources.getString(R.string.common_google_play_services_install_text_tablet) : resources.getString(R.string.common_google_play_services_install_text_phone);
                return b(i2) ? string + " (via Bazaar)" : string;
            case 2:
                String string2 = resources.getString(R.string.common_google_play_services_update_text);
                return b(i2) ? string2 + " (via Bazaar)" : string2;
            case 3:
                return resources.getString(R.string.common_google_play_services_enable_text);
            case 4:
            case 6:
            case 8:
            default:
                return resources.getString(R.string.common_google_play_services_unknown_issue);
            case 5:
                return resources.getString(R.string.common_google_play_services_invalid_account_text);
            case 7:
                return resources.getString(R.string.common_google_play_services_network_error_text);
            case 9:
                return resources.getString(R.string.common_google_play_services_unsupported_text);
        }
    }

    static boolean b(int i) {
        switch (c(i)) {
            case 0:
                return !g();
            case 1:
                return true;
            case 2:
                return false;
            default:
                return false;
        }
    }

    private static boolean b(Resources resources) {
        Configuration configuration = resources.getConfiguration();
        if (as.ap()) {
            return (configuration.screenLayout & 15) <= 3 && configuration.smallestScreenWidthDp >= 600;
        }
        return false;
    }

    private static int c(int i) {
        if (i == -1) {
            return 2;
        }
        return i;
    }

    private static boolean c(Context context) {
        if (J) {
            return L;
        }
        try {
            return a(context.getPackageManager().getPackageInfo("com.google.android.apps.bazaar", 64), I) != null;
        } catch (PackageManager.NameNotFoundException e) {
            return false;
        }
    }

    private static byte[] c(String str) {
        try {
            return str.getBytes("ISO-8859-1");
        } catch (UnsupportedEncodingException e) {
            throw new AssertionError(e);
        }
    }

    public static boolean g() {
        return J ? K : "user".equals(Build.TYPE);
    }

    public static Dialog getErrorDialog(int errorCode, Activity activity, int requestCode) {
        return a(errorCode, activity, requestCode, null, -1);
    }

    public static Dialog getErrorDialog(int errorCode, Activity activity, int requestCode, DialogInterface.OnCancelListener cancelListener) {
        return a(errorCode, activity, requestCode, cancelListener, -1);
    }

    public static PendingIntent getErrorPendingIntent(int errorCode, Context context, int requestCode) {
        Intent intentA = a(context, errorCode, -1);
        if (intentA == null) {
            return null;
        }
        return PendingIntent.getActivity(context, requestCode, intentA, 268435456);
    }

    public static String getErrorString(int errorCode) {
        switch (errorCode) {
            case 0:
                return "SUCCESS";
            case 1:
                return "SERVICE_MISSING";
            case 2:
                return "SERVICE_VERSION_UPDATE_REQUIRED";
            case 3:
                return "SERVICE_DISABLED";
            case 4:
                return "SIGN_IN_REQUIRED";
            case 5:
                return "INVALID_ACCOUNT";
            case 6:
                return "RESOLUTION_REQUIRED";
            case 7:
                return "NETWORK_ERROR";
            case 8:
                return "INTERNAL_ERROR";
            case 9:
                return "SERVICE_INVALID";
            case 10:
                return "DEVELOPER_ERROR";
            case 11:
                return "LICENSE_CHECK_FAILED";
            default:
                return "UNKNOWN_ERROR_CODE";
        }
    }

    public static String getOpenSourceSoftwareLicenseInfo(Context context) throws IOException {
        try {
            InputStream inputStreamOpenInputStream = context.getContentResolver().openInputStream(new Uri.Builder().scheme("android.resource").authority(GOOGLE_PLAY_SERVICES_PACKAGE).appendPath("raw").appendPath("oss_notice").build());
            try {
                try {
                    return new Scanner(inputStreamOpenInputStream).useDelimiter("\\A").next();
                } finally {
                    if (inputStreamOpenInputStream != null) {
                        inputStreamOpenInputStream.close();
                    }
                }
            } catch (NoSuchElementException e) {
                if (inputStreamOpenInputStream != null) {
                    inputStreamOpenInputStream.close();
                }
                return null;
            }
        } catch (Exception e2) {
            return null;
        }
    }

    public static Context getRemoteContext(Context context) {
        try {
            return context.createPackageContext(GOOGLE_PLAY_SERVICES_PACKAGE, 3);
        } catch (PackageManager.NameNotFoundException e) {
            return null;
        }
    }

    public static Resources getRemoteResource(Context context) {
        try {
            return context.getPackageManager().getResourcesForApplication(GOOGLE_PLAY_SERVICES_PACKAGE);
        } catch (PackageManager.NameNotFoundException e) {
            return null;
        }
    }

    public static int isGooglePlayServicesAvailable(Context context) throws PackageManager.NameNotFoundException, CertificateException {
        PackageManager packageManager = context.getPackageManager();
        try {
            context.getResources().getString(R.string.common_google_play_services_unknown_issue);
        } catch (Throwable th) {
            Log.e("GooglePlayServicesUtil", "The Google Play services resources were not found. Check your project configuration to ensure that the resources are included.");
        }
        try {
            byte[] bArrA = a(packageManager.getPackageInfo(GOOGLE_PLAY_STORE_PACKAGE, 64), C);
            if (bArrA == null) {
                Log.w("GooglePlayServicesUtil", "Google Play Store signature invalid.");
                return 9;
            }
            try {
                PackageInfo packageInfo = packageManager.getPackageInfo(GOOGLE_PLAY_SERVICES_PACKAGE, 64);
                if (a(packageInfo, bArrA) == null) {
                    Log.w("GooglePlayServicesUtil", "Google Play services signature invalid.");
                    return 9;
                }
                if (packageInfo.versionCode < 3265100) {
                    Log.w("GooglePlayServicesUtil", "Google Play services out of date.  Requires 3265100 but found " + packageInfo.versionCode);
                    return 2;
                }
                try {
                    return !packageManager.getApplicationInfo(GOOGLE_PLAY_SERVICES_PACKAGE, 0).enabled ? 3 : 0;
                } catch (PackageManager.NameNotFoundException e) {
                    Log.wtf("GooglePlayServicesUtil", "Google Play services missing when getting application info.");
                    e.printStackTrace();
                    return 1;
                }
            } catch (PackageManager.NameNotFoundException e2) {
                Log.w("GooglePlayServicesUtil", "Google Play services is missing.");
                return 1;
            }
        } catch (PackageManager.NameNotFoundException e3) {
            Log.w("GooglePlayServicesUtil", "Google Play Store is missing.");
            return 9;
        }
    }

    public static boolean isUserRecoverableError(int errorCode) {
        switch (errorCode) {
            case 1:
            case 2:
            case 3:
            case 9:
                return true;
            case 4:
            case 5:
            case 6:
            case 7:
            case 8:
            default:
                return false;
        }
    }
}
