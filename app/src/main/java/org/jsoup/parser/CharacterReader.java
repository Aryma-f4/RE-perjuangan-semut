package org.jsoup.parser;

import java.util.Locale;
import org.jsoup.helper.Validate;

/* loaded from: classes.dex */
class CharacterReader {
    static final char EOF = 65535;
    private final char[] input;
    private final int length;
    private int pos = 0;
    private int mark = 0;

    CharacterReader(String input) {
        Validate.notNull(input);
        this.input = input.toCharArray();
        this.length = this.input.length;
    }

    int pos() {
        return this.pos;
    }

    boolean isEmpty() {
        return this.pos >= this.length;
    }

    char current() {
        return this.pos >= this.length ? EOF : this.input[this.pos];
    }

    char consume() {
        char val = this.pos >= this.length ? (char) 65535 : this.input[this.pos];
        this.pos++;
        return val;
    }

    void unconsume() {
        this.pos--;
    }

    void advance() {
        this.pos++;
    }

    void mark() {
        this.mark = this.pos;
    }

    void rewindToMark() {
        this.pos = this.mark;
    }

    String consumeAsString() {
        char[] cArr = this.input;
        int i = this.pos;
        this.pos = i + 1;
        return new String(cArr, i, 1);
    }

    int nextIndexOf(char c) {
        for (int i = this.pos; i < this.length; i++) {
            if (c == this.input[i]) {
                return i - this.pos;
            }
        }
        return -1;
    }

    int nextIndexOf(CharSequence seq) {
        char startChar = seq.charAt(0);
        int offset = this.pos;
        while (offset < this.length) {
            if (startChar != this.input[offset]) {
                do {
                    offset++;
                    if (offset >= this.length) {
                        break;
                    }
                } while (startChar != this.input[offset]);
            }
            int i = offset + 1;
            int last = (seq.length() + i) - 1;
            if (offset < this.length && last <= this.length) {
                for (int j = 1; i < last && seq.charAt(j) == this.input[i]; j++) {
                    i++;
                }
                if (i == last) {
                    return offset - this.pos;
                }
            }
            offset++;
        }
        return -1;
    }

    String consumeTo(char c) {
        int offset = nextIndexOf(c);
        if (offset == -1) {
            return consumeToEnd();
        }
        String consumed = new String(this.input, this.pos, offset);
        this.pos += offset;
        return consumed;
    }

    String consumeTo(String seq) {
        int offset = nextIndexOf(seq);
        if (offset == -1) {
            return consumeToEnd();
        }
        String consumed = new String(this.input, this.pos, offset);
        this.pos += offset;
        return consumed;
    }

    String consumeToAny(char... chars) {
        int start = this.pos;
        loop0: while (this.pos < this.length) {
            for (char c : chars) {
                if (this.input[this.pos] == c) {
                    break loop0;
                }
            }
            this.pos++;
        }
        return this.pos > start ? new String(this.input, start, this.pos - start) : "";
    }

    String consumeToEnd() {
        String data = new String(this.input, this.pos, this.length - this.pos);
        this.pos = this.length;
        return data;
    }

    String consumeLetterSequence() {
        char c;
        int start = this.pos;
        while (this.pos < this.length && (((c = this.input[this.pos]) >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z'))) {
            this.pos++;
        }
        return new String(this.input, start, this.pos - start);
    }

    String consumeLetterThenDigitSequence() {
        char c;
        char c2;
        int start = this.pos;
        while (this.pos < this.length && (((c2 = this.input[this.pos]) >= 'A' && c2 <= 'Z') || (c2 >= 'a' && c2 <= 'z'))) {
            this.pos++;
        }
        while (!isEmpty() && (c = this.input[this.pos]) >= '0' && c <= '9') {
            this.pos++;
        }
        return new String(this.input, start, this.pos - start);
    }

    String consumeHexSequence() {
        char c;
        int start = this.pos;
        while (this.pos < this.length && (((c = this.input[this.pos]) >= '0' && c <= '9') || ((c >= 'A' && c <= 'F') || (c >= 'a' && c <= 'f')))) {
            this.pos++;
        }
        return new String(this.input, start, this.pos - start);
    }

    String consumeDigitSequence() {
        char c;
        int start = this.pos;
        while (this.pos < this.length && (c = this.input[this.pos]) >= '0' && c <= '9') {
            this.pos++;
        }
        return new String(this.input, start, this.pos - start);
    }

    boolean matches(char c) {
        return !isEmpty() && this.input[this.pos] == c;
    }

    boolean matches(String seq) {
        int scanLength = seq.length();
        if (scanLength > this.length - this.pos) {
            return false;
        }
        for (int offset = 0; offset < scanLength; offset++) {
            if (seq.charAt(offset) != this.input[this.pos + offset]) {
                return false;
            }
        }
        return true;
    }

    boolean matchesIgnoreCase(String seq) {
        int scanLength = seq.length();
        if (scanLength > this.length - this.pos) {
            return false;
        }
        for (int offset = 0; offset < scanLength; offset++) {
            char upScan = Character.toUpperCase(seq.charAt(offset));
            char upTarget = Character.toUpperCase(this.input[this.pos + offset]);
            if (upScan != upTarget) {
                return false;
            }
        }
        return true;
    }

    boolean matchesAny(char... seq) {
        if (isEmpty()) {
            return false;
        }
        char c = this.input[this.pos];
        for (char seek : seq) {
            if (seek == c) {
                return true;
            }
        }
        return false;
    }

    boolean matchesLetter() {
        if (isEmpty()) {
            return false;
        }
        char c = this.input[this.pos];
        return (c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z');
    }

    boolean matchesDigit() {
        if (isEmpty()) {
            return false;
        }
        char c = this.input[this.pos];
        return c >= '0' && c <= '9';
    }

    boolean matchConsume(String seq) {
        if (!matches(seq)) {
            return false;
        }
        this.pos += seq.length();
        return true;
    }

    boolean matchConsumeIgnoreCase(String seq) {
        if (!matchesIgnoreCase(seq)) {
            return false;
        }
        this.pos += seq.length();
        return true;
    }

    boolean containsIgnoreCase(String seq) {
        String loScan = seq.toLowerCase(Locale.ENGLISH);
        String hiScan = seq.toUpperCase(Locale.ENGLISH);
        return nextIndexOf(loScan) > -1 || nextIndexOf(hiScan) > -1;
    }

    public String toString() {
        return new String(this.input, this.pos, this.length - this.pos);
    }
}
