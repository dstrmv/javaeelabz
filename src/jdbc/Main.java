package jdbc;

import java.sql.SQLException;
import java.time.LocalDate;

public class Main {
    public static void main(String[] args) throws SQLException {
        DatabaseManager manager = new DatabaseManager();
        //manager.getAllEmployees().forEach(System.out::println);
//        System.out.println(manager.getEmployeeById(9999));
//        Employee employee = new Employee();
//        employee.setId(9999);
//        employee.setName("TESTNAME");
//        employee.setJob("JOBJOBJOB");
//        employee.setManagerId(7499);
//        employee.setSalary(1234);
//        employee.setHireDate(LocalDate.now());
//        employee.setDeptId(10);
//        System.out.println(manager.saveEmployee(employee));
        manager.deleteEmployeeById(9999);
    }
}
