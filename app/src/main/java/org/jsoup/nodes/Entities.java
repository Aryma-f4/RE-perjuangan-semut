package org.jsoup.nodes;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.nio.charset.CharsetEncoder;
import java.util.HashMap;
import java.util.Map;
import java.util.MissingResourceException;
import java.util.Properties;
import org.jsoup.helper.StringUtil;
import org.jsoup.nodes.Document;
import org.jsoup.parser.Parser;

/* loaded from: classes.dex */
public class Entities {
    private static final Map<String, Character> base;
    private static final Map<Character, String> baseByVal;
    private static final Map<String, Character> full;
    private static final Map<Character, String> fullByVal;
    private static final Object[][] xhtmlArray = {new Object[]{"quot", 34}, new Object[]{"amp", 38}, new Object[]{"lt", 60}, new Object[]{"gt", 62}};
    private static final Map<Character, String> xhtmlByVal = new HashMap();

    public enum EscapeMode {
        xhtml(Entities.xhtmlByVal),
        base(Entities.baseByVal),
        extended(Entities.fullByVal);

        private Map<Character, String> map;

        EscapeMode(Map map) {
            this.map = map;
        }

        public Map<Character, String> getMap() {
            return this.map;
        }
    }

    private Entities() {
    }

    public static boolean isNamedEntity(String name) {
        return full.containsKey(name);
    }

    public static boolean isBaseNamedEntity(String name) {
        return base.containsKey(name);
    }

    public static Character getCharacterByName(String name) {
        return full.get(name);
    }

    static String escape(String string, Document.OutputSettings out) {
        StringBuilder accum = new StringBuilder(string.length() * 2);
        escape(accum, string, out, false, false, false);
        return accum.toString();
    }

    static void escape(StringBuilder accum, String string, Document.OutputSettings out, boolean inAttribute, boolean normaliseWhite, boolean stripLeadingWhite) {
        boolean reachedNonWhite;
        char c;
        boolean reachedNonWhite2 = false;
        EscapeMode escapeMode = out.escapeMode();
        CharsetEncoder encoder = out.encoder();
        Map<Character, String> map = escapeMode.getMap();
        int length = string.length();
        int offset = 0;
        char c2 = 0;
        while (offset < length) {
            int codePoint = string.codePointAt(offset);
            if (!normaliseWhite) {
                reachedNonWhite = reachedNonWhite2;
                c = c2;
            } else if (StringUtil.isWhitespace(codePoint)) {
                if ((!stripLeadingWhite || reachedNonWhite2) && c2 == 0) {
                    accum.append(' ');
                    c2 = 1;
                }
                offset = Character.charCount(codePoint) + offset;
            } else {
                reachedNonWhite = true;
                c = 0;
            }
            if (codePoint < 65536) {
                char c3 = (char) codePoint;
                switch (c3) {
                    case '\"':
                        if (inAttribute) {
                            accum.append("&quot;");
                            break;
                        } else {
                            accum.append(c3);
                            break;
                        }
                    case '&':
                        accum.append("&amp;");
                        break;
                    case '<':
                        if (!inAttribute) {
                            accum.append("&lt;");
                            break;
                        } else {
                            accum.append(c3);
                            break;
                        }
                    case '>':
                        if (!inAttribute) {
                            accum.append("&gt;");
                            break;
                        } else {
                            accum.append(c3);
                            break;
                        }
                    case 160:
                        if (escapeMode != EscapeMode.xhtml) {
                            accum.append("&nbsp;");
                            break;
                        } else {
                            accum.append(c3);
                            break;
                        }
                    default:
                        if (encoder.canEncode(c3)) {
                            accum.append(c3);
                            break;
                        } else if (map.containsKey(Character.valueOf(c3))) {
                            accum.append('&').append(map.get(Character.valueOf(c3))).append(';');
                            break;
                        } else {
                            accum.append("&#x").append(Integer.toHexString(codePoint)).append(';');
                            break;
                        }
                }
                c2 = c;
                reachedNonWhite2 = reachedNonWhite;
            } else {
                String c4 = new String(Character.toChars(codePoint));
                if (encoder.canEncode(c4)) {
                    accum.append(c4);
                    c2 = c;
                    reachedNonWhite2 = reachedNonWhite;
                } else {
                    accum.append("&#x").append(Integer.toHexString(codePoint)).append(';');
                    c2 = c;
                    reachedNonWhite2 = reachedNonWhite;
                }
            }
            offset = Character.charCount(codePoint) + offset;
        }
    }

    static String unescape(String string) {
        return unescape(string, false);
    }

    static String unescape(String string, boolean strict) {
        return Parser.unescapeEntities(string, strict);
    }

    static {
        ByteArrayInputStream baisbase = null;
        ByteArrayInputStream baisfull = null;
        try {
            ByteArrayInputStream baisbase2 = new ByteArrayInputStream(EntitiesStuff.base.getBytes("UTF-8"));
            try {
                baisfull = new ByteArrayInputStream(EntitiesStuff.full.getBytes("UTF-8"));
                baisbase = baisbase2;
            } catch (UnsupportedEncodingException e) {
                baisbase = baisbase2;
            }
        } catch (UnsupportedEncodingException e2) {
        }
        base = loadEntities("base", baisbase);
        full = loadEntities("full", baisfull);
        baseByVal = toCharacterKey(base);
        fullByVal = toCharacterKey(full);
        Object[][] arr$ = xhtmlArray;
        for (Object[] entity : arr$) {
            Character c = Character.valueOf((char) ((Integer) entity[1]).intValue());
            xhtmlByVal.put(c, (String) entity[0]);
        }
    }

    private static Map<String, Character> loadEntities(String entid, InputStream in) throws IOException {
        Properties properties = new Properties();
        Map<String, Character> entities = new HashMap<>();
        try {
            properties.load(in);
            in.close();
            for (Map.Entry entry : properties.entrySet()) {
                Character val = Character.valueOf((char) Integer.parseInt((String) entry.getValue(), 16));
                String name = (String) entry.getKey();
                entities.put(name, val);
            }
            return entities;
        } catch (IOException e) {
            throw new MissingResourceException("Error loading entities resource: " + e.getMessage(), "Entities", entid);
        }
    }

    private static Map<String, Character> loadEntities(String filename) throws IOException {
        Properties properties = new Properties();
        Map<String, Character> entities = new HashMap<>();
        try {
            InputStream in = Entities.class.getResourceAsStream(filename);
            properties.load(in);
            in.close();
            for (Map.Entry entry : properties.entrySet()) {
                Character val = Character.valueOf((char) Integer.parseInt((String) entry.getValue(), 16));
                String name = (String) entry.getKey();
                entities.put(name, val);
            }
            return entities;
        } catch (IOException e) {
            throw new MissingResourceException("Error loading entities resource: " + e.getMessage(), "Entities", filename);
        }
    }

    private static Map<Character, String> toCharacterKey(Map<String, Character> inMap) {
        Map<Character, String> outMap = new HashMap<>();
        for (Map.Entry<String, Character> entry : inMap.entrySet()) {
            Character character = entry.getValue();
            String name = entry.getKey();
            if (outMap.containsKey(character)) {
                if (name.toLowerCase().equals(name)) {
                    outMap.put(character, name);
                }
            } else {
                outMap.put(character, name);
            }
        }
        return outMap;
    }
}
