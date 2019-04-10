package jdbc;

public class EmployeeNotFoundException extends RuntimeException {
    public EmployeeNotFoundException(int id) {
        super(String.format("Employee with id %d not found", id));
    }
}
