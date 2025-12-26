package com.adobe.air;

import android.net.http.SslCertificate;
import java.io.ByteArrayInputStream;
import java.security.cert.CertificateFactory;
import java.security.cert.X509Certificate;

/* loaded from: classes.dex */
public class Certificate {
    private final String TAG = "AIRCertificateWarningDialog";
    private SslCertificate m_certificate;
    private CertificateFactory m_factory;
    private SslCertificate.DName m_issuedBy;
    private SslCertificate.DName m_issuedTo;

    public Certificate() {
        try {
            this.m_factory = CertificateFactory.getInstance("X.509");
        } catch (Exception e) {
        }
    }

    public Certificate(SslCertificate sslCertificate) {
        try {
            this.m_certificate = sslCertificate;
            this.m_issuedBy = this.m_certificate.getIssuedBy();
            this.m_issuedTo = this.m_certificate.getIssuedTo();
        } catch (Exception e) {
        }
    }

    public Boolean setCertificate(byte[] bArr) {
        if (this.m_factory == null) {
            return false;
        }
        try {
            this.m_certificate = new SslCertificate((X509Certificate) this.m_factory.generateCertificate(new ByteArrayInputStream(bArr)));
            this.m_issuedBy = this.m_certificate.getIssuedBy();
            this.m_issuedTo = this.m_certificate.getIssuedTo();
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    public String getIssuedToCommonName() {
        return this.m_issuedTo.getCName();
    }

    public String getIssuedToOrganization() {
        return this.m_issuedTo.getOName();
    }

    public String getIssuedToOrganizationalUnit() {
        return this.m_issuedTo.getUName();
    }

    public String getIssuedByCommonName() {
        return this.m_issuedBy.getCName();
    }

    public String getIssuedByOrganization() {
        return this.m_issuedBy.getOName();
    }

    public String getIssuedByOrganizationalUnit() {
        return this.m_issuedBy.getUName();
    }

    public String getIssuedOn() {
        return this.m_certificate.getValidNotBefore();
    }

    public String getExpiresOn() {
        return this.m_certificate.getValidNotAfter();
    }
}
