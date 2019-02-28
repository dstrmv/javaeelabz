package xml;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlElement;
import java.util.List;

@XmlAccessorType(XmlAccessType.FIELD)
public class Student {

    @XmlAttribute(name = "firstname")
    private String firstName;
    @XmlAttribute(name = "lastname")
    private String lastName;
    @XmlAttribute(name = "groupnumber")
    private int groupNumber;
    @XmlElement(name="subject")
    private List<Subject> subjects;
    @XmlElement(name = "average")
    private double average;

    public double getAverage() {
        return average;
    }

    public void setAverage(double average) {
        this.average = average;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public int getGroupNumber() {
        return groupNumber;
    }

    public void setGroupNumber(int groupNumber) {
        this.groupNumber = groupNumber;
    }

    public List<Subject> getSubjects() {
        return subjects;
    }

    public void setSubjects(List<Subject> subjects) {
        this.subjects = subjects;
    }

    public void calculateAverage() {
        this.setAverage(subjects.stream().mapToDouble(Subject::getMark).sum()/subjects.size());
    }
}
