package jdbc;

import java.time.LocalDate;

public class Employee {

    private int id;
    private String name;
    private String job;
    private int managerId;
    private LocalDate hireDate;
    private double salary;
    private double comm;
    private int deptId;
    private String deptName;
    private String location;
    private int salGrade;

    public Employee() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getJob() {
        return job;
    }

    public void setJob(String job) {
        this.job = job;
    }

    public int getManagerId() {
        return managerId;
    }

    public void setManagerId(int managerId) {
        this.managerId = managerId;
    }

    public LocalDate getHireDate() {
        return hireDate;
    }

    public void setHireDate(LocalDate hireDate) {
        this.hireDate = hireDate;
    }

    public double getSalary() {
        return salary;
    }

    public void setSalary(double salary) {
        this.salary = salary;
    }

    public double getComm() {
        return comm;
    }

    public void setComm(double comm) {
        this.comm = comm;
    }

    public int getDeptId() {
        return deptId;
    }

    public void setDeptId(int deptId) {
        this.deptId = deptId;
    }

    public String getDeptName() {
        return deptName;
    }

    public void setDeptName(String deptName) {
        this.deptName = deptName;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public int getSalGrade() {
        return salGrade;
    }

    public void setSalGrade(int salGrade) {
        this.salGrade = salGrade;
    }

    @Override
    public String toString() {
        return "Employee{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", job='" + job + '\'' +
                ", managerId=" + managerId +
                ", hireDate=" + hireDate +
                ", salary=" + salary +
                ", comm=" + comm +
                ", deptId=" + deptId +
                ", deptName='" + deptName + '\'' +
                ", location='" + location + '\'' +
                ", salGrade=" + salGrade +
                '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        Employee employee = (Employee) o;

        if (id != employee.id) return false;
        if (managerId != employee.managerId) return false;
        if (Double.compare(employee.salary, salary) != 0) return false;
        if (Double.compare(employee.comm, comm) != 0) return false;
        if (deptId != employee.deptId) return false;
        if (salGrade != employee.salGrade) return false;
        if (!name.equals(employee.name)) return false;
        if (!job.equals(employee.job)) return false;
        if (!hireDate.equals(employee.hireDate)) return false;
        if (!deptName.equals(employee.deptName)) return false;
        return location.equals(employee.location);
    }

    @Override
    public int hashCode() {
        int result;
        long temp;
        result = id;
        result = 31 * result + name.hashCode();
        result = 31 * result + job.hashCode();
        result = 31 * result + managerId;
        result = 31 * result + hireDate.hashCode();
        temp = Double.doubleToLongBits(salary);
        result = 31 * result + (int) (temp ^ (temp >>> 32));
        temp = Double.doubleToLongBits(comm);
        result = 31 * result + (int) (temp ^ (temp >>> 32));
        result = 31 * result + deptId;
        result = 31 * result + deptName.hashCode();
        result = 31 * result + location.hashCode();
        result = 31 * result + salGrade;
        return result;
    }
}
