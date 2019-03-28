package rmi;

import java.io.Serializable;

public class Task implements Serializable {

    private MathOperations operation;
    private double op1;
    private double op2;

    public Task(MathOperations operation, double op1, double op2) {
        this.operation = operation;
        this.op1 = op1;
        this.op2 = op2;
    }

    public MathOperations getOperation() {
        return operation;
    }

    public void setOperation(MathOperations operation) {
        this.operation = operation;
    }

    public double getOp1() {
        return op1;
    }

    public void setOp1(double op1) {
        this.op1 = op1;
    }

    public double getOp2() {
        return op2;
    }

    public void setOp2(double op2) {
        this.op2 = op2;
    }
}
