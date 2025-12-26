package org.jsoup.select;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.HashSet;
import java.util.Iterator;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.ListIterator;
import org.jsoup.helper.Validate;
import org.jsoup.nodes.Element;
import org.jsoup.nodes.FormElement;

/* loaded from: classes.dex */
public class Elements implements List<Element>, Cloneable {
    private List<Element> contents;

    public Elements() {
        this.contents = new ArrayList();
    }

    public Elements(int initialCapacity) {
        this.contents = new ArrayList(initialCapacity);
    }

    public Elements(Collection<Element> elements) {
        this.contents = new ArrayList(elements);
    }

    public Elements(List<Element> elements) {
        this.contents = elements;
    }

    public Elements(Element... elements) {
        this((List<Element>) Arrays.asList(elements));
    }

    public Elements clone() {
        try {
            Elements clone = (Elements) super.clone();
            List<Element> elements = new ArrayList<>();
            clone.contents = elements;
            for (Element e : this.contents) {
                elements.add(e.mo6clone());
            }
            return clone;
        } catch (CloneNotSupportedException e2) {
            throw new RuntimeException(e2);
        }
    }

    public String attr(String attributeKey) {
        for (Element element : this.contents) {
            if (element.hasAttr(attributeKey)) {
                return element.attr(attributeKey);
            }
        }
        return "";
    }

    public boolean hasAttr(String attributeKey) {
        for (Element element : this.contents) {
            if (element.hasAttr(attributeKey)) {
                return true;
            }
        }
        return false;
    }

    public Elements attr(String attributeKey, String attributeValue) {
        for (Element element : this.contents) {
            element.attr(attributeKey, attributeValue);
        }
        return this;
    }

    public Elements removeAttr(String attributeKey) {
        for (Element element : this.contents) {
            element.removeAttr(attributeKey);
        }
        return this;
    }

    public Elements addClass(String className) {
        for (Element element : this.contents) {
            element.addClass(className);
        }
        return this;
    }

    public Elements removeClass(String className) {
        for (Element element : this.contents) {
            element.removeClass(className);
        }
        return this;
    }

    public Elements toggleClass(String className) {
        for (Element element : this.contents) {
            element.toggleClass(className);
        }
        return this;
    }

    public boolean hasClass(String className) {
        for (Element element : this.contents) {
            if (element.hasClass(className)) {
                return true;
            }
        }
        return false;
    }

    public String val() {
        return size() > 0 ? first().val() : "";
    }

    public Elements val(String value) {
        for (Element element : this.contents) {
            element.val(value);
        }
        return this;
    }

    public String text() {
        StringBuilder sb = new StringBuilder();
        for (Element element : this.contents) {
            if (sb.length() != 0) {
                sb.append(" ");
            }
            sb.append(element.text());
        }
        return sb.toString();
    }

    public boolean hasText() {
        for (Element element : this.contents) {
            if (element.hasText()) {
                return true;
            }
        }
        return false;
    }

    public String html() {
        StringBuilder sb = new StringBuilder();
        for (Element element : this.contents) {
            if (sb.length() != 0) {
                sb.append("\n");
            }
            sb.append(element.html());
        }
        return sb.toString();
    }

    public String outerHtml() {
        StringBuilder sb = new StringBuilder();
        for (Element element : this.contents) {
            if (sb.length() != 0) {
                sb.append("\n");
            }
            sb.append(element.outerHtml());
        }
        return sb.toString();
    }

    public String toString() {
        return outerHtml();
    }

    public Elements tagName(String tagName) {
        for (Element element : this.contents) {
            element.tagName(tagName);
        }
        return this;
    }

    public Elements html(String html) {
        for (Element element : this.contents) {
            element.html(html);
        }
        return this;
    }

    public Elements prepend(String html) {
        for (Element element : this.contents) {
            element.prepend(html);
        }
        return this;
    }

    public Elements append(String html) {
        for (Element element : this.contents) {
            element.append(html);
        }
        return this;
    }

    public Elements before(String html) {
        for (Element element : this.contents) {
            element.before(html);
        }
        return this;
    }

    public Elements after(String html) {
        for (Element element : this.contents) {
            element.after(html);
        }
        return this;
    }

    public Elements wrap(String html) {
        Validate.notEmpty(html);
        for (Element element : this.contents) {
            element.wrap(html);
        }
        return this;
    }

    public Elements unwrap() {
        for (Element element : this.contents) {
            element.unwrap();
        }
        return this;
    }

    public Elements empty() {
        for (Element element : this.contents) {
            element.empty();
        }
        return this;
    }

    public Elements remove() {
        for (Element element : this.contents) {
            element.remove();
        }
        return this;
    }

    public Elements select(String query) {
        return Selector.select(query, this);
    }

    public Elements not(String query) {
        Elements out = Selector.select(query, this);
        return Selector.filterOut(this, out);
    }

    public Elements eq(int index) {
        return this.contents.size() > index ? new Elements(get(index)) : new Elements();
    }

    public boolean is(String query) {
        Elements children = select(query);
        return !children.isEmpty();
    }

    public Elements parents() {
        HashSet<Element> combo = new LinkedHashSet<>();
        for (Element e : this.contents) {
            combo.addAll(e.parents());
        }
        return new Elements(combo);
    }

    public Element first() {
        if (this.contents.isEmpty()) {
            return null;
        }
        return this.contents.get(0);
    }

    public Element last() {
        if (this.contents.isEmpty()) {
            return null;
        }
        return this.contents.get(this.contents.size() - 1);
    }

    public Elements traverse(NodeVisitor nodeVisitor) {
        Validate.notNull(nodeVisitor);
        NodeTraversor traversor = new NodeTraversor(nodeVisitor);
        for (Element el : this.contents) {
            traversor.traverse(el);
        }
        return this;
    }

    public List<FormElement> forms() {
        ArrayList<FormElement> forms = new ArrayList<>();
        for (Element el : this.contents) {
            if (el instanceof FormElement) {
                forms.add((FormElement) el);
            }
        }
        return forms;
    }

    @Override // java.util.List, java.util.Collection
    public int size() {
        return this.contents.size();
    }

    @Override // java.util.List, java.util.Collection
    public boolean isEmpty() {
        return this.contents.isEmpty();
    }

    @Override // java.util.List, java.util.Collection
    public boolean contains(Object o) {
        return this.contents.contains(o);
    }

    @Override // java.util.List, java.util.Collection, java.lang.Iterable
    public Iterator<Element> iterator() {
        return this.contents.iterator();
    }

    @Override // java.util.List, java.util.Collection
    public Object[] toArray() {
        return this.contents.toArray();
    }

    @Override // java.util.List, java.util.Collection
    public <T> T[] toArray(T[] tArr) {
        return (T[]) this.contents.toArray(tArr);
    }

    @Override // java.util.List, java.util.Collection
    public boolean add(Element element) {
        return this.contents.add(element);
    }

    @Override // java.util.List, java.util.Collection
    public boolean remove(Object o) {
        return this.contents.remove(o);
    }

    @Override // java.util.List, java.util.Collection
    public boolean containsAll(Collection<?> c) {
        return this.contents.containsAll(c);
    }

    @Override // java.util.List, java.util.Collection
    public boolean addAll(Collection<? extends Element> c) {
        return this.contents.addAll(c);
    }

    @Override // java.util.List
    public boolean addAll(int index, Collection<? extends Element> c) {
        return this.contents.addAll(index, c);
    }

    @Override // java.util.List, java.util.Collection
    public boolean removeAll(Collection<?> c) {
        return this.contents.removeAll(c);
    }

    @Override // java.util.List, java.util.Collection
    public boolean retainAll(Collection<?> c) {
        return this.contents.retainAll(c);
    }

    @Override // java.util.List, java.util.Collection
    public void clear() {
        this.contents.clear();
    }

    @Override // java.util.List, java.util.Collection
    public boolean equals(Object o) {
        return this.contents.equals(o);
    }

    @Override // java.util.List, java.util.Collection
    public int hashCode() {
        return this.contents.hashCode();
    }

    @Override // java.util.List
    public Element get(int index) {
        return this.contents.get(index);
    }

    @Override // java.util.List
    public Element set(int index, Element element) {
        return this.contents.set(index, element);
    }

    @Override // java.util.List
    public void add(int index, Element element) {
        this.contents.add(index, element);
    }

    @Override // java.util.List
    public Element remove(int index) {
        return this.contents.remove(index);
    }

    @Override // java.util.List
    public int indexOf(Object o) {
        return this.contents.indexOf(o);
    }

    @Override // java.util.List
    public int lastIndexOf(Object o) {
        return this.contents.lastIndexOf(o);
    }

    @Override // java.util.List
    public ListIterator<Element> listIterator() {
        return this.contents.listIterator();
    }

    @Override // java.util.List
    public ListIterator<Element> listIterator(int index) {
        return this.contents.listIterator(index);
    }

    @Override // java.util.List
    public List<Element> subList(int fromIndex, int toIndex) {
        return this.contents.subList(fromIndex, toIndex);
    }
}
