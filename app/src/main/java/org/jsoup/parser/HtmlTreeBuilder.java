package org.jsoup.parser;

import com.google.android.gms.plus.PlusShare;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;
import org.jsoup.helper.DescendableLinkedList;
import org.jsoup.helper.StringUtil;
import org.jsoup.helper.Validate;
import org.jsoup.nodes.Comment;
import org.jsoup.nodes.DataNode;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.nodes.FormElement;
import org.jsoup.nodes.Node;
import org.jsoup.nodes.TextNode;
import org.jsoup.parser.Token;
import org.jsoup.select.Elements;

/* loaded from: classes.dex */
class HtmlTreeBuilder extends TreeBuilder {
    static final /* synthetic */ boolean $assertionsDisabled;
    private static final String[] TagSearchButton;
    private static final String[] TagSearchEndTags;
    private static final String[] TagSearchList;
    private static final String[] TagSearchSelectScope;
    private static final String[] TagSearchSpecial;
    private static final String[] TagSearchTableScope;
    private static final String[] TagsScriptStyle;
    public static final String[] TagsSearchInScope;
    private Element contextElement;
    private FormElement formElement;
    private Element headElement;
    private HtmlTreeBuilderState originalState;
    private HtmlTreeBuilderState state;
    private boolean baseUriSetFromDoc = false;
    private DescendableLinkedList<Element> formattingElements = new DescendableLinkedList<>();
    private List<Token.Character> pendingTableCharacters = new ArrayList();
    private boolean framesetOk = true;
    private boolean fosterInserts = false;
    private boolean fragmentParsing = false;

    static {
        $assertionsDisabled = !HtmlTreeBuilder.class.desiredAssertionStatus();
        TagsScriptStyle = new String[]{"script", "style"};
        TagsSearchInScope = new String[]{"applet", "caption", "html", "table", "td", "th", "marquee", "object"};
        TagSearchList = new String[]{"ol", "ul"};
        TagSearchButton = new String[]{"button"};
        TagSearchTableScope = new String[]{"html", "table"};
        TagSearchSelectScope = new String[]{"optgroup", "option"};
        TagSearchEndTags = new String[]{"dd", "dt", "li", "option", "optgroup", "p", "rp", "rt"};
        TagSearchSpecial = new String[]{"address", "applet", "area", "article", "aside", "base", "basefont", "bgsound", "blockquote", "body", "br", "button", "caption", "center", "col", "colgroup", "command", "dd", "details", "dir", "div", "dl", "dt", "embed", "fieldset", "figcaption", "figure", "footer", "form", "frame", "frameset", "h1", "h2", "h3", "h4", "h5", "h6", "head", "header", "hgroup", "hr", "html", "iframe", "img", "input", "isindex", "li", "link", "listing", "marquee", "menu", "meta", "nav", "noembed", "noframes", "noscript", "object", "ol", "p", "param", "plaintext", "pre", "script", "section", "select", "style", "summary", "table", "tbody", "td", "textarea", "tfoot", "th", "thead", PlusShare.KEY_CONTENT_DEEP_LINK_METADATA_TITLE, "tr", "ul", "wbr", "xmp"};
    }

    HtmlTreeBuilder() {
    }

    @Override // org.jsoup.parser.TreeBuilder
    Document parse(String input, String baseUri, ParseErrorList errors) {
        this.state = HtmlTreeBuilderState.Initial;
        return super.parse(input, baseUri, errors);
    }

    List<Node> parseFragment(String inputFragment, Element context, String baseUri, ParseErrorList errors) {
        this.state = HtmlTreeBuilderState.Initial;
        initialiseParse(inputFragment, baseUri, errors);
        this.contextElement = context;
        this.fragmentParsing = true;
        Element root = null;
        if (context != null) {
            if (context.ownerDocument() != null) {
                this.doc.quirksMode(context.ownerDocument().quirksMode());
            }
            String contextTag = context.tagName();
            if (StringUtil.in(contextTag, PlusShare.KEY_CONTENT_DEEP_LINK_METADATA_TITLE, "textarea")) {
                this.tokeniser.transition(TokeniserState.Rcdata);
            } else if (StringUtil.in(contextTag, "iframe", "noembed", "noframes", "style", "xmp")) {
                this.tokeniser.transition(TokeniserState.Rawtext);
            } else if (contextTag.equals("script")) {
                this.tokeniser.transition(TokeniserState.ScriptData);
            } else if (!contextTag.equals("noscript") && contextTag.equals("plaintext")) {
                this.tokeniser.transition(TokeniserState.Data);
            } else {
                this.tokeniser.transition(TokeniserState.Data);
            }
            root = new Element(Tag.valueOf("html"), baseUri);
            this.doc.appendChild(root);
            this.stack.push(root);
            resetInsertionMode();
            Elements contextChain = context.parents();
            contextChain.add(0, context);
            Iterator i$ = contextChain.iterator();
            while (true) {
                if (!i$.hasNext()) {
                    break;
                }
                Element parent = i$.next();
                if (parent instanceof FormElement) {
                    this.formElement = (FormElement) parent;
                    break;
                }
            }
        }
        runParser();
        if (context != null) {
            return root.childNodes();
        }
        return this.doc.childNodes();
    }

    @Override // org.jsoup.parser.TreeBuilder
    protected boolean process(Token token) {
        this.currentToken = token;
        return this.state.process(token, this);
    }

    boolean process(Token token, HtmlTreeBuilderState state) {
        this.currentToken = token;
        return state.process(token, this);
    }

    void transition(HtmlTreeBuilderState state) {
        this.state = state;
    }

    HtmlTreeBuilderState state() {
        return this.state;
    }

    void markInsertionMode() {
        this.originalState = this.state;
    }

    HtmlTreeBuilderState originalState() {
        return this.originalState;
    }

    void framesetOk(boolean framesetOk) {
        this.framesetOk = framesetOk;
    }

    boolean framesetOk() {
        return this.framesetOk;
    }

    Document getDocument() {
        return this.doc;
    }

    String getBaseUri() {
        return this.baseUri;
    }

    void maybeSetBaseUri(Element base) {
        if (!this.baseUriSetFromDoc) {
            String href = base.absUrl("href");
            if (href.length() != 0) {
                this.baseUri = href;
                this.baseUriSetFromDoc = true;
                this.doc.setBaseUri(href);
            }
        }
    }

    boolean isFragmentParsing() {
        return this.fragmentParsing;
    }

    void error(HtmlTreeBuilderState state) {
        if (this.errors.canAddError()) {
            this.errors.add(new ParseError(this.reader.pos(), "Unexpected token [%s] when in state [%s]", this.currentToken.tokenType(), state));
        }
    }

    Element insert(Token.StartTag startTag) {
        if (startTag.isSelfClosing()) {
            Element el = insertEmpty(startTag);
            this.stack.add(el);
            this.tokeniser.transition(TokeniserState.Data);
            this.tokeniser.emit(new Token.EndTag(el.tagName()));
            return el;
        }
        Element el2 = new Element(Tag.valueOf(startTag.name()), this.baseUri, startTag.attributes);
        insert(el2);
        return el2;
    }

    Element insert(String startTagName) {
        Element el = new Element(Tag.valueOf(startTagName), this.baseUri);
        insert(el);
        return el;
    }

    void insert(Element el) {
        insertNode(el);
        this.stack.add(el);
    }

    Element insertEmpty(Token.StartTag startTag) {
        Tag tag = Tag.valueOf(startTag.name());
        Element el = new Element(tag, this.baseUri, startTag.attributes);
        insertNode(el);
        if (startTag.isSelfClosing()) {
            if (tag.isKnownTag()) {
                if (tag.isSelfClosing()) {
                    this.tokeniser.acknowledgeSelfClosingFlag();
                }
            } else {
                tag.setSelfClosing();
                this.tokeniser.acknowledgeSelfClosingFlag();
            }
        }
        return el;
    }

    FormElement insertForm(Token.StartTag startTag, boolean onStack) {
        Tag tag = Tag.valueOf(startTag.name());
        FormElement el = new FormElement(tag, this.baseUri, startTag.attributes);
        setFormElement(el);
        insertNode(el);
        if (onStack) {
            this.stack.add(el);
        }
        return el;
    }

    void insert(Token.Comment commentToken) {
        Comment comment = new Comment(commentToken.getData(), this.baseUri);
        insertNode(comment);
    }

    void insert(Token.Character characterToken) {
        Node node;
        String tagName = currentElement().tagName();
        if (tagName.equals("script") || tagName.equals("style")) {
            node = new DataNode(characterToken.getData(), this.baseUri);
        } else {
            node = new TextNode(characterToken.getData(), this.baseUri);
        }
        currentElement().appendChild(node);
    }

    private void insertNode(Node node) {
        if (this.stack.size() == 0) {
            this.doc.appendChild(node);
        } else if (isFosterInserts()) {
            insertInFosterParent(node);
        } else {
            currentElement().appendChild(node);
        }
        if ((node instanceof Element) && ((Element) node).tag().isFormListed() && this.formElement != null) {
            this.formElement.addElement((Element) node);
        }
    }

    Element pop() {
        if (this.stack.peekLast().nodeName().equals("td") && !this.state.name().equals("InCell")) {
            Validate.isFalse(true, "pop td not in cell");
        }
        if (this.stack.peekLast().nodeName().equals("html")) {
            Validate.isFalse(true, "popping html!");
        }
        return this.stack.pollLast();
    }

    void push(Element element) {
        this.stack.add(element);
    }

    DescendableLinkedList<Element> getStack() {
        return this.stack;
    }

    boolean onStack(Element el) {
        return isElementInQueue(this.stack, el);
    }

    private boolean isElementInQueue(DescendableLinkedList<Element> queue, Element element) {
        Iterator<Element> it = queue.descendingIterator();
        while (it.hasNext()) {
            Element next = it.next();
            if (next == element) {
                return true;
            }
        }
        return false;
    }

    Element getFromStack(String elName) {
        Iterator<Element> it = this.stack.descendingIterator();
        while (it.hasNext()) {
            Element next = it.next();
            if (next.nodeName().equals(elName)) {
                return next;
            }
        }
        return null;
    }

    boolean removeFromStack(Element el) {
        Iterator<Element> it = this.stack.descendingIterator();
        while (it.hasNext()) {
            Element next = it.next();
            if (next == el) {
                it.remove();
                return true;
            }
        }
        return false;
    }

    void popStackToClose(String elName) {
        Iterator<Element> it = this.stack.descendingIterator();
        while (it.hasNext()) {
            Element next = it.next();
            if (next.nodeName().equals(elName)) {
                it.remove();
                return;
            }
            it.remove();
        }
    }

    void popStackToClose(String... elNames) {
        Iterator<Element> it = this.stack.descendingIterator();
        while (it.hasNext()) {
            Element next = it.next();
            if (StringUtil.in(next.nodeName(), elNames)) {
                it.remove();
                return;
            }
            it.remove();
        }
    }

    void popStackToBefore(String elName) {
        Iterator<Element> it = this.stack.descendingIterator();
        while (it.hasNext()) {
            Element next = it.next();
            if (!next.nodeName().equals(elName)) {
                it.remove();
            } else {
                return;
            }
        }
    }

    void clearStackToTableContext() {
        clearStackToContext("table");
    }

    void clearStackToTableBodyContext() {
        clearStackToContext("tbody", "tfoot", "thead");
    }

    void clearStackToTableRowContext() {
        clearStackToContext("tr");
    }

    private void clearStackToContext(String... nodeNames) {
        Iterator<Element> it = this.stack.descendingIterator();
        while (it.hasNext()) {
            Element next = it.next();
            if (!StringUtil.in(next.nodeName(), nodeNames) && !next.nodeName().equals("html")) {
                it.remove();
            } else {
                return;
            }
        }
    }

    Element aboveOnStack(Element el) {
        if (!$assertionsDisabled && !onStack(el)) {
            throw new AssertionError();
        }
        Iterator<Element> it = this.stack.descendingIterator();
        while (it.hasNext()) {
            Element next = it.next();
            if (next == el) {
                return it.next();
            }
        }
        return null;
    }

    void insertOnStackAfter(Element after, Element in) {
        int i = this.stack.lastIndexOf(after);
        Validate.isTrue(i != -1);
        this.stack.add(i + 1, in);
    }

    void replaceOnStack(Element out, Element in) {
        replaceInQueue(this.stack, out, in);
    }

    private void replaceInQueue(LinkedList<Element> queue, Element out, Element in) {
        int i = queue.lastIndexOf(out);
        Validate.isTrue(i != -1);
        queue.remove(i);
        queue.add(i, in);
    }

    void resetInsertionMode() {
        boolean last = false;
        Iterator<Element> it = this.stack.descendingIterator();
        while (it.hasNext()) {
            Element node = it.next();
            if (!it.hasNext()) {
                last = true;
                node = this.contextElement;
            }
            String name = node.nodeName();
            if ("select".equals(name)) {
                transition(HtmlTreeBuilderState.InSelect);
                return;
            }
            if ("td".equals(name) || ("td".equals(name) && !last)) {
                transition(HtmlTreeBuilderState.InCell);
                return;
            }
            if ("tr".equals(name)) {
                transition(HtmlTreeBuilderState.InRow);
                return;
            }
            if ("tbody".equals(name) || "thead".equals(name) || "tfoot".equals(name)) {
                transition(HtmlTreeBuilderState.InTableBody);
                return;
            }
            if ("caption".equals(name)) {
                transition(HtmlTreeBuilderState.InCaption);
                return;
            }
            if ("colgroup".equals(name)) {
                transition(HtmlTreeBuilderState.InColumnGroup);
                return;
            }
            if ("table".equals(name)) {
                transition(HtmlTreeBuilderState.InTable);
                return;
            }
            if ("head".equals(name)) {
                transition(HtmlTreeBuilderState.InBody);
                return;
            }
            if ("body".equals(name)) {
                transition(HtmlTreeBuilderState.InBody);
                return;
            }
            if ("frameset".equals(name)) {
                transition(HtmlTreeBuilderState.InFrameset);
                return;
            } else if ("html".equals(name)) {
                transition(HtmlTreeBuilderState.BeforeHead);
                return;
            } else if (last) {
                transition(HtmlTreeBuilderState.InBody);
                return;
            }
        }
    }

    private boolean inSpecificScope(String targetName, String[] baseTypes, String[] extraTypes) {
        return inSpecificScope(new String[]{targetName}, baseTypes, extraTypes);
    }

    private boolean inSpecificScope(String[] targetNames, String[] baseTypes, String[] extraTypes) {
        Iterator<Element> it = this.stack.descendingIterator();
        while (it.hasNext()) {
            Element el = it.next();
            String elName = el.nodeName();
            if (StringUtil.in(elName, targetNames)) {
                return true;
            }
            if (StringUtil.in(elName, baseTypes)) {
                return false;
            }
            if (extraTypes != null && StringUtil.in(elName, extraTypes)) {
                return false;
            }
        }
        Validate.fail("Should not be reachable");
        return false;
    }

    boolean inScope(String[] targetNames) {
        return inSpecificScope(targetNames, TagsSearchInScope, (String[]) null);
    }

    boolean inScope(String targetName) {
        return inScope(targetName, null);
    }

    boolean inScope(String targetName, String[] extras) {
        return inSpecificScope(targetName, TagsSearchInScope, extras);
    }

    boolean inListItemScope(String targetName) {
        return inScope(targetName, TagSearchList);
    }

    boolean inButtonScope(String targetName) {
        return inScope(targetName, TagSearchButton);
    }

    boolean inTableScope(String targetName) {
        return inSpecificScope(targetName, TagSearchTableScope, (String[]) null);
    }

    boolean inSelectScope(String targetName) {
        Iterator<Element> it = this.stack.descendingIterator();
        while (it.hasNext()) {
            Element el = it.next();
            String elName = el.nodeName();
            if (elName.equals(targetName)) {
                return true;
            }
            if (!StringUtil.in(elName, TagSearchSelectScope)) {
                return false;
            }
        }
        Validate.fail("Should not be reachable");
        return false;
    }

    void setHeadElement(Element headElement) {
        this.headElement = headElement;
    }

    Element getHeadElement() {
        return this.headElement;
    }

    boolean isFosterInserts() {
        return this.fosterInserts;
    }

    void setFosterInserts(boolean fosterInserts) {
        this.fosterInserts = fosterInserts;
    }

    FormElement getFormElement() {
        return this.formElement;
    }

    void setFormElement(FormElement formElement) {
        this.formElement = formElement;
    }

    void newPendingTableCharacters() {
        this.pendingTableCharacters = new ArrayList();
    }

    List<Token.Character> getPendingTableCharacters() {
        return this.pendingTableCharacters;
    }

    void setPendingTableCharacters(List<Token.Character> pendingTableCharacters) {
        this.pendingTableCharacters = pendingTableCharacters;
    }

    void generateImpliedEndTags(String excludeTag) {
        while (excludeTag != null && !currentElement().nodeName().equals(excludeTag) && StringUtil.in(currentElement().nodeName(), TagSearchEndTags)) {
            pop();
        }
    }

    void generateImpliedEndTags() {
        generateImpliedEndTags(null);
    }

    boolean isSpecial(Element el) {
        String name = el.nodeName();
        return StringUtil.in(name, TagSearchSpecial);
    }

    void pushActiveFormattingElements(Element in) {
        Element el;
        int numSeen = 0;
        Iterator<Element> iter = this.formattingElements.descendingIterator();
        while (true) {
            if (!iter.hasNext() || (el = iter.next()) == null) {
                break;
            }
            if (isSameFormattingElement(in, el)) {
                numSeen++;
            }
            if (numSeen == 3) {
                iter.remove();
                break;
            }
        }
        this.formattingElements.add(in);
    }

    private boolean isSameFormattingElement(Element a, Element b) {
        return a.nodeName().equals(b.nodeName()) && a.attributes().equals(b.attributes());
    }

    void reconstructFormattingElements() {
        int size = this.formattingElements.size();
        if (size != 0 && this.formattingElements.getLast() != null && !onStack(this.formattingElements.getLast())) {
            Element entry = this.formattingElements.getLast();
            int pos = size - 1;
            boolean skip = false;
            while (true) {
                if (pos == 0) {
                    skip = true;
                    break;
                }
                pos--;
                Element entry2 = this.formattingElements.get(pos);
                entry = entry2;
                if (entry == null || onStack(entry)) {
                    break;
                }
            }
            do {
                if (!skip) {
                    pos++;
                    Element entry3 = this.formattingElements.get(pos);
                    entry = entry3;
                }
                Validate.notNull(entry);
                skip = false;
                Element newEl = insert(entry.nodeName());
                newEl.attributes().addAll(entry.attributes());
                this.formattingElements.add(pos, newEl);
                this.formattingElements.remove(pos + 1);
            } while (pos != size - 1);
        }
    }

    void clearFormattingElementsToLastMarker() {
        while (!this.formattingElements.isEmpty()) {
            Element el = this.formattingElements.peekLast();
            this.formattingElements.removeLast();
            if (el == null) {
                return;
            }
        }
    }

    void removeFromActiveFormattingElements(Element el) {
        Iterator<Element> it = this.formattingElements.descendingIterator();
        while (it.hasNext()) {
            Element next = it.next();
            if (next == el) {
                it.remove();
                return;
            }
        }
    }

    boolean isInActiveFormattingElements(Element el) {
        return isElementInQueue(this.formattingElements, el);
    }

    Element getActiveFormattingElement(String nodeName) {
        Element next;
        Iterator<Element> it = this.formattingElements.descendingIterator();
        while (it.hasNext() && (next = it.next()) != null) {
            if (next.nodeName().equals(nodeName)) {
                return next;
            }
        }
        return null;
    }

    void replaceActiveFormattingElement(Element out, Element in) {
        replaceInQueue(this.formattingElements, out, in);
    }

    void insertMarkerToFormattingElements() {
        this.formattingElements.add(null);
    }

    void insertInFosterParent(Node in) {
        Element fosterParent;
        Element lastTable = getFromStack("table");
        boolean isLastTableParent = false;
        if (lastTable != null) {
            if (lastTable.parent() != null) {
                fosterParent = lastTable.parent();
                isLastTableParent = true;
            } else {
                fosterParent = aboveOnStack(lastTable);
            }
        } else {
            Element fosterParent2 = this.stack.get(0);
            fosterParent = fosterParent2;
        }
        if (isLastTableParent) {
            Validate.notNull(lastTable);
            lastTable.before(in);
        } else {
            fosterParent.appendChild(in);
        }
    }

    public String toString() {
        return "TreeBuilder{currentToken=" + this.currentToken + ", state=" + this.state + ", currentElement=" + currentElement() + '}';
    }
}
