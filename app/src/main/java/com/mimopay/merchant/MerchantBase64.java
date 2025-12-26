package com.mimopay.merchant;

import android.support.v4.view.MotionEventCompat;

/* loaded from: classes.dex */
public class MerchantBase64 {
    private static final byte[] map2;
    private static final String systemLineSeparator = System.getProperty("line.separator");
    private static final char[] map1 = new char[64];

    static {
        int i;
        int i2 = 0;
        char c = 'A';
        while (true) {
            i = i2;
            if (c > 'Z') {
                break;
            }
            i2 = i + 1;
            map1[i] = c;
            c = (char) (c + 1);
        }
        char c2 = 'a';
        while (c2 <= 'z') {
            map1[i] = c2;
            c2 = (char) (c2 + 1);
            i++;
        }
        char c3 = '0';
        while (c3 <= '9') {
            map1[i] = c3;
            c3 = (char) (c3 + 1);
            i++;
        }
        int i3 = i + 1;
        map1[i] = '+';
        int i4 = i3 + 1;
        map1[i3] = '/';
        map2 = new byte[128];
        for (int i5 = 0; i5 < map2.length; i5++) {
            map2[i5] = -1;
        }
        for (int i6 = 0; i6 < 64; i6++) {
            map2[map1[i6]] = (byte) i6;
        }
    }

    public static String encodeString(String s) {
        return new String(encode(s.getBytes()));
    }

    public static String encodeLines(byte[] in) {
        return encodeLines(in, 0, in.length, 76, systemLineSeparator);
    }

    public static String encodeLines(byte[] in, int iOff, int iLen, int lineLen, String lineSeparator) {
        int blockLen = (lineLen * 3) / 4;
        if (blockLen <= 0) {
            throw new IllegalArgumentException();
        }
        int lines = ((iLen + blockLen) - 1) / blockLen;
        int bufLen = (((iLen + 2) / 3) * 4) + (lineSeparator.length() * lines);
        StringBuilder buf = new StringBuilder(bufLen);
        int ip = 0;
        while (ip < iLen) {
            int l = Math.min(iLen - ip, blockLen);
            buf.append(encode(in, iOff + ip, l));
            buf.append(lineSeparator);
            ip += l;
        }
        return buf.toString();
    }

    public static char[] encode(byte[] in) {
        return encode(in, 0, in.length);
    }

    public static char[] encode(byte[] in, int iLen) {
        return encode(in, 0, iLen);
    }

    public static char[] encode(byte[] in, int iOff, int iLen) {
        int ip;
        int i1;
        int ip2;
        int oDataLen = ((iLen * 4) + 2) / 3;
        int oLen = ((iLen + 2) / 3) * 4;
        char[] out = new char[oLen];
        int iEnd = iOff + iLen;
        int op = 0;
        int op2 = iOff;
        while (op2 < iEnd) {
            int ip3 = op2 + 1;
            int i0 = in[op2] & MotionEventCompat.ACTION_MASK;
            if (ip3 < iEnd) {
                int ip4 = ip3 + 1;
                i1 = in[ip3] & MotionEventCompat.ACTION_MASK;
                ip = ip4;
            } else {
                ip = ip3;
                i1 = 0;
            }
            if (ip < iEnd) {
                int ip5 = ip + 1;
                int ip6 = in[ip] & MotionEventCompat.ACTION_MASK;
                ip = ip5;
                ip2 = ip6;
            } else {
                ip2 = 0;
            }
            int o0 = i0 >>> 2;
            int o1 = ((i0 & 3) << 4) | (i1 >>> 4);
            int o2 = ((i1 & 15) << 2) | (ip2 >>> 6);
            int o3 = ip2 & 63;
            int op3 = op + 1;
            out[op] = map1[o0];
            int op4 = op3 + 1;
            out[op3] = map1[o1];
            out[op4] = op4 < oDataLen ? map1[o2] : '=';
            int op5 = op4 + 1;
            out[op5] = op5 < oDataLen ? map1[o3] : '=';
            op = op5 + 1;
            op2 = ip;
        }
        return out;
    }

    public static String decodeString(String s) {
        return new String(decode(s));
    }

    public static byte[] decodeLines(String s) {
        char[] buf = new char[s.length()];
        int p = 0;
        for (int ip = 0; ip < s.length(); ip++) {
            char c = s.charAt(ip);
            if (c != ' ' && c != '\r' && c != '\n' && c != '\t') {
                buf[p] = c;
                p++;
            }
        }
        return decode(buf, 0, p);
    }

    public static byte[] decode(String s) {
        return decode(s.toCharArray());
    }

    public static byte[] decode(char[] in) {
        return decode(in, 0, in.length);
    }

    public static byte[] decode(char[] in, int iOff, int iLen) {
        int ip;
        char c;
        int ip2;
        int o1;
        int op;
        if (iLen % 4 != 0) {
            throw new IllegalArgumentException("Length of Base64 encoded input string is not a multiple of 4.");
        }
        while (iLen > 0 && in[(iOff + iLen) - 1] == '=') {
            iLen--;
        }
        int oLen = (iLen * 3) / 4;
        byte[] out = new byte[oLen];
        int iEnd = iOff + iLen;
        int op2 = 0;
        for (int op3 = iOff; op3 < iEnd; op3 = ip) {
            int ip3 = op3 + 1;
            char c2 = in[op3];
            int ip4 = ip3 + 1;
            char c3 = in[ip3];
            if (ip4 < iEnd) {
                int ip5 = ip4 + 1;
                c = in[ip4];
                ip = ip5;
            } else {
                ip = ip4;
                c = 'A';
            }
            if (ip < iEnd) {
                int ip6 = ip + 1;
                char c4 = in[ip];
                ip = ip6;
                ip2 = c4;
            } else {
                ip2 = 65;
            }
            if (c2 > 127 || c3 > 127 || c > 127 || ip2 > 127) {
                throw new IllegalArgumentException("Illegal character in Base64 encoded data.");
            }
            int b0 = map2[c2];
            int b1 = map2[c3];
            int b2 = map2[c];
            int b3 = map2[ip2];
            if (b0 < 0 || b1 < 0 || b2 < 0 || b3 < 0) {
                throw new IllegalArgumentException("Illegal character in Base64 encoded data.");
            }
            int o0 = (b0 << 2) | (b1 >>> 4);
            int o12 = ((b1 & 15) << 4) | (b2 >>> 2);
            int o2 = ((b2 & 3) << 6) | b3;
            int b32 = op2 + 1;
            out[op2] = (byte) o0;
            if (b32 < oLen) {
                int op4 = b32 + 1;
                out[b32] = (byte) o12;
                o1 = op4;
            } else {
                o1 = b32;
            }
            if (o1 < oLen) {
                op = o1 + 1;
                out[o1] = (byte) o2;
            } else {
                op = o1;
            }
            op2 = op;
        }
        return out;
    }

    private MerchantBase64() {
    }
}
