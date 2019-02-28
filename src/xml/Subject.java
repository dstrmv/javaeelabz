package xml;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlAttribute;

@XmlAccessorType(XmlAccessType.FIELD)
public class Subject {

    @XmlAttribute(name = "title")
    private String title;
    @XmlAttribute(name = "mark")
    private int mark;

    public String getName() {
        return title;
    }

    public void setName(String name) {
        this.title = name;
    }

    public int getMark() {
        return mark;
    }

    public void setMark(int mark) {
        this.mark = mark;
    }
}
