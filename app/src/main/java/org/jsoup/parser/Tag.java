package org.jsoup.parser;

import com.google.android.gms.plus.PlusShare;
import java.util.HashMap;
import java.util.Map;
import org.jsoup.helper.Validate;

/* loaded from: classes.dex */
public class Tag {
    private String tagName;
    private static final Map<String, Tag> tags = new HashMap();
    private static final String[] blockTags = {"html", "head", "body", "frameset", "script", "noscript", "style", "meta", "link", PlusShare.KEY_CONTENT_DEEP_LINK_METADATA_TITLE, "frame", "noframes", "section", "nav", "aside", "hgroup", "header", "footer", "p", "h1", "h2", "h3", "h4", "h5", "h6", "ul", "ol", "pre", "div", "blockquote", "hr", "address", "figure", "figcaption", "form", "fieldset", "ins", "del", "s", "dl", "dt", "dd", "li", "table", "caption", "thead", "tfoot", "tbody", "colgroup", "col", "tr", "th", "td", "video", "audio", "canvas", "details", "menu", "plaintext"};
    private static final String[] inlineTags = {"object", "base", "font", "tt", "i", "b", "u", "big", "small", "em", "strong", "dfn", "code", "samp", "kbd", "var", "cite", "abbr", "time", "acronym", "mark", "ruby", "rt", "rp", "a", "img", "br", "wbr", "map", "q", "sub", "sup", "bdo", "iframe", "embed", "span", "input", "select", "textarea", PlusShare.KEY_CALL_TO_ACTION_LABEL, "button", "optgroup", "option", "legend", "datalist", "keygen", "output", "progress", "meter", "area", "param", "source", "track", "summary", "command", "device", "area", "basefont", "bgsound", "menuitem", "param", "source", "track"};
    private static final String[] emptyTags = {"meta", "link", "base", "frame", "img", "br", "wbr", "embed", "hr", "input", "keygen", "col", "command", "device", "area", "basefont", "bgsound", "menuitem", "param", "source", "track"};
    private static final String[] formatAsInlineTags = {PlusShare.KEY_CONTENT_DEEP_LINK_METADATA_TITLE, "a", "p", "h1", "h2", "h3", "h4", "h5", "h6", "pre", "address", "li", "th", "td", "script", "style", "ins", "del", "s"};
    private static final String[] preserveWhitespaceTags = {"pre", "plaintext", PlusShare.KEY_CONTENT_DEEP_LINK_METADATA_TITLE, "textarea"};
    private static final String[] formListedTags = {"button", "fieldset", "input", "keygen", "object", "output", "select", "textarea"};
    private static final String[] formSubmitTags = {"input", "keygen", "object", "select", "textarea"};
    private boolean isBlock = true;
    private boolean formatAsBlock = true;
    private boolean canContainBlock = true;
    private boolean canContainInline = true;
    private boolean empty = false;
    private boolean selfClosing = false;
    private boolean preserveWhitespace = false;
    private boolean formList = false;
    private boolean formSubmit = false;

    static {
        String[] arr$ = blockTags;
        for (String tagName : arr$) {
            register(new Tag(tagName));
        }
        String[] arr$2 = inlineTags;
        for (String tagName2 : arr$2) {
            Tag tag = new Tag(tagName2);
            tag.isBlock = false;
            tag.canContainBlock = false;
            tag.formatAsBlock = false;
            register(tag);
        }
        String[] arr$3 = emptyTags;
        for (String tagName3 : arr$3) {
            Tag tag2 = tags.get(tagName3);
            Validate.notNull(tag2);
            tag2.canContainBlock = false;
            tag2.canContainInline = false;
            tag2.empty = true;
        }
        String[] arr$4 = formatAsInlineTags;
        for (String tagName4 : arr$4) {
            Tag tag3 = tags.get(tagName4);
            Validate.notNull(tag3);
            tag3.formatAsBlock = false;
        }
        String[] arr$5 = preserveWhitespaceTags;
        for (String tagName5 : arr$5) {
            Tag tag4 = tags.get(tagName5);
            Validate.notNull(tag4);
            tag4.preserveWhitespace = true;
        }
        String[] arr$6 = formListedTags;
        for (String tagName6 : arr$6) {
            Tag tag5 = tags.get(tagName6);
            Validate.notNull(tag5);
            tag5.formList = true;
        }
        String[] arr$7 = formSubmitTags;
        for (String tagName7 : arr$7) {
            Tag tag6 = tags.get(tagName7);
            Validate.notNull(tag6);
            tag6.formSubmit = true;
        }
    }

    private Tag(String tagName) {
        this.tagName = tagName.toLowerCase();
    }

    public String getName() {
        return this.tagName;
    }

    public static Tag valueOf(String tagName) {
        Validate.notNull(tagName);
        Tag tag = tags.get(tagName);
        if (tag == null) {
            String tagName2 = tagName.trim().toLowerCase();
            Validate.notEmpty(tagName2);
            Tag tag2 = tags.get(tagName2);
            if (tag2 == null) {
                Tag tag3 = new Tag(tagName2);
                tag3.isBlock = false;
                tag3.canContainBlock = true;
                return tag3;
            }
            return tag2;
        }
        return tag;
    }

    public boolean isBlock() {
        return this.isBlock;
    }

    public boolean formatAsBlock() {
        return this.formatAsBlock;
    }

    public boolean canContainBlock() {
        return this.canContainBlock;
    }

    public boolean isInline() {
        return !this.isBlock;
    }

    public boolean isData() {
        return (this.canContainInline || isEmpty()) ? false : true;
    }

    public boolean isEmpty() {
        return this.empty;
    }

    public boolean isSelfClosing() {
        return this.empty || this.selfClosing;
    }

    public boolean isKnownTag() {
        return tags.containsKey(this.tagName);
    }

    public static boolean isKnownTag(String tagName) {
        return tags.containsKey(tagName);
    }

    public boolean preserveWhitespace() {
        return this.preserveWhitespace;
    }

    public boolean isFormListed() {
        return this.formList;
    }

    public boolean isFormSubmittable() {
        return this.formSubmit;
    }

    Tag setSelfClosing() {
        this.selfClosing = true;
        return this;
    }

    public boolean equals(Object o) {
        if (this == o) {
            return true;
        }
        if (!(o instanceof Tag)) {
            return false;
        }
        Tag tag = (Tag) o;
        if (this.canContainBlock == tag.canContainBlock && this.canContainInline == tag.canContainInline && this.empty == tag.empty && this.formatAsBlock == tag.formatAsBlock && this.isBlock == tag.isBlock && this.preserveWhitespace == tag.preserveWhitespace && this.selfClosing == tag.selfClosing && this.formList == tag.formList && this.formSubmit == tag.formSubmit && this.tagName.equals(tag.tagName)) {
            return true;
        }
        return false;
    }

    public int hashCode() {
        int result = this.tagName.hashCode();
        return (((((((((((((((((result * 31) + (this.isBlock ? 1 : 0)) * 31) + (this.formatAsBlock ? 1 : 0)) * 31) + (this.canContainBlock ? 1 : 0)) * 31) + (this.canContainInline ? 1 : 0)) * 31) + (this.empty ? 1 : 0)) * 31) + (this.selfClosing ? 1 : 0)) * 31) + (this.preserveWhitespace ? 1 : 0)) * 31) + (this.formList ? 1 : 0)) * 31) + (this.formSubmit ? 1 : 0);
    }

    public String toString() {
        return this.tagName;
    }

    private static void register(Tag tag) {
        tags.put(tag.tagName, tag);
    }
}
