package xml;

import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Marshaller;
import javax.xml.bind.Unmarshaller;
import java.io.File;

public class Main {

    public static void main(String[] args) {
        String path = "src/xml/group.xml";
        File file = new File(path);
        System.setProperty("javax.xml.accessExternalDTD", "all");
        Group group = new Group();
        try {
            JAXBContext jaxbContext = JAXBContext.newInstance(Group.class);
            Unmarshaller unmarshaller = jaxbContext.createUnmarshaller();
            group = (Group) unmarshaller.unmarshal(file);
        } catch (JAXBException e) {
            e.printStackTrace();
        }
        for (Student student : group.getStudents()) {
            System.out.println(student.getFirstName());
        }

        group.checkAverage();

        try {
            JAXBContext context = JAXBContext.newInstance(Group.class, Student.class, Subject.class);
            Marshaller marshaller = context.createMarshaller();
            marshaller.setProperty(Marshaller.JAXB_FORMATTED_OUTPUT, Boolean.TRUE);
            marshaller.setProperty(Marshaller.JAXB_FRAGMENT, Boolean.TRUE);
            marshaller.setProperty("com.sun.xml.internal.bind.xmlHeaders",
                    "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>\n" +
                            "<!DOCTYPE group SYSTEM \"./group.dtd\">");
            marshaller.marshal(group, new File("src/xml/out.xml"));
        } catch (JAXBException e) {
            e.printStackTrace();
        }


    }

}
