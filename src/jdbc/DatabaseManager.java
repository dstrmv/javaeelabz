package jdbc;

import org.postgresql.ds.PGSimpleDataSource;

import javax.sql.DataSource;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DatabaseManager {

    private DataSource dataSource;

    public DatabaseManager() throws SQLException {

        PGSimpleDataSource pgSource = new PGSimpleDataSource();
        pgSource.setURL("jdbc:postgresql://localhost:5432/nclabs?currentSchema=dblabs");
        pgSource.setUser("postgres");
        pgSource.setPassword("postgres");
        this.dataSource = pgSource;
    }

    private static Employee mapEmployee(ResultSet resultSet) throws SQLException {
        Employee employee = new Employee();
        employee.setId(resultSet.getInt("empno"));
        employee.setName(resultSet.getString("ename"));
        employee.setJob(resultSet.getString("job"));
        employee.setManagerId(resultSet.getInt("mgr"));
        employee.setHireDate(resultSet.getDate("hiredate").toLocalDate());
        employee.setSalary(resultSet.getDouble("sal"));
        employee.setComm(resultSet.getDouble("comm"));
        employee.setDeptId(resultSet.getInt("deptno"));
        employee.setDeptName(resultSet.getString("dname"));
        employee.setLocation(resultSet.getString("loc"));
        employee.setSalGrade(resultSet.getInt("grade"));
        return employee;
    }

    public List<Employee> getAllEmployees() throws SQLException {

        List<Employee> employees = new ArrayList<>();
        String query = "SELECT * FROM emp e JOIN salgrade s ON e.sal BETWEEN s.losal AND s.hisal INNER JOIN dept d ON e.deptno = d.deptno; ";

        Connection connection = dataSource.getConnection();
        Statement statement = connection.createStatement();
        ResultSet resultSet = statement.executeQuery(query);

        while (resultSet.next()) {
            employees.add(mapEmployee(resultSet));
        }

        connection.close();

        return employees;

    }

    public Employee getEmployeeById(int id) {

        String query = "SELECT * FROM emp e JOIN salgrade s ON e.sal BETWEEN s.losal AND s.hisal INNER JOIN dept d ON e.deptno = d.deptno WHERE e.empno = ?; ";
        Employee employee = null;

        try (Connection connection = dataSource.getConnection();
             PreparedStatement statement = connection.prepareStatement(query)) {
            statement.setInt(1, id);
            ResultSet resultSet = statement.executeQuery();
            if (!resultSet.next()) throw new EmployeeNotFoundException(id);

            employee = mapEmployee(resultSet);
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return employee;
    }

    public Employee saveEmployee(Employee employee) {

        Employee newEmployee = null;

        String query = "INSERT INTO emp(empno, ename, job, mgr, hiredate, sal, comm, deptno) VALUES (?, ?, ?, ?, ?, ?, ?, ?);";
        try (Connection connection = dataSource.getConnection();
             PreparedStatement statement = connection.prepareStatement(query)) {
            statement.setInt(1, employee.getId());
            statement.setString(2, employee.getName());
            statement.setString(3, employee.getJob());
            statement.setInt(4, employee.getManagerId());
            statement.setDate(5, Date.valueOf(employee.getHireDate()));
            statement.setDouble(6, employee.getSalary());
            statement.setDouble(7, employee.getComm());
            statement.setInt(8, employee.getDeptId());

            statement.executeUpdate();

            newEmployee = getEmployeeById(employee.getId());
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return newEmployee;
    }

    public void deleteEmployeeById(int id) {

        String query = "DELETE FROM emp WHERE empno = ?";

        try (Connection connection = dataSource.getConnection();
             PreparedStatement statement = connection.prepareStatement(query)) {
            statement.setInt(1, id);
            statement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

}
