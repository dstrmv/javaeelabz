package rmi;

import java.rmi.RemoteException;
import java.util.HashMap;
import java.util.Map;
import java.util.function.BiFunction;

public class RemoteOperationExecutorImpl implements RemoteOperationExecutor {

    private static Map<MathOperations, BiFunction<Double, Double, Double>> operations = new HashMap<>();

    static {
        operations.put(MathOperations.ADD, (o1, o2) -> o1 + o2);
        operations.put(MathOperations.SUB, (o1, o2) -> o1 - o2);
        operations.put(MathOperations.MPY, (o1, o2) -> o1 * o2);
        operations.put(MathOperations.DIV, (o1, o2) -> o1 / o2);
        operations.put(MathOperations.MOD, (o1, o2) -> o1 % o2);
    }

    @Override
    public double execute(Task task) throws RemoteException {
        MathOperations op = task.getOperation();
        Double o1 = task.getOp1();
        Double o2 = task.getOp2();
        return operations.get(op).apply(o1, o2);
    }
}
