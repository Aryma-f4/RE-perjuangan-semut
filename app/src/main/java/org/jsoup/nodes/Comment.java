package org.jsoup.nodes;

import org.jsoup.nodes.Document;

/* loaded from: classes.dex */
public class Comment extends Node {
    private static final String COMMENT_KEY = "comment";

    public Comment(String data, String baseUri) {
        super(baseUri);
        this.attributes.put(COMMENT_KEY, data);
    }

    @Override // org.jsoup.nodes.Node
    public String nodeName() {
        return "#comment";
    }

    public String getData() {
        return this.attributes.get(COMMENT_KEY);
    }

    @Override // org.jsoup.nodes.Node
    void outerHtmlHead(StringBuilder accum, int depth, Document.OutputSettings out) {
        if (out.prettyPrint()) {
            indent(accum, depth, out);
        }
        accum.append("<!--").append(getData()).append("-->");
    }

    @Override // org.jsoup.nodes.Node
    void outerHtmlTail(StringBuilder accum, int depth, Document.OutputSettings out) {
    }

    @Override // org.jsoup.nodes.Node
    public String toString() {
        return outerHtml();
    }
}
