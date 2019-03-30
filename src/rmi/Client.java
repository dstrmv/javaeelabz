package rmi;

import java.rmi.NotBoundException;
import java.rmi.RemoteException;
import java.rmi.registry.LocateRegistry;
import java.rmi.registry.Registry;
import java.util.HashMap;
import java.util.Map;
import java.util.Scanner;

public class Client {

    private static Map<String, MathOperations> operationsMap = new HashMap<>();

    static {
        operationsMap.put("+", MathOperations.ADD);
        operationsMap.put("-", MathOperations.SUB);
        operationsMap.put("/", MathOperations.DIV);
        operationsMap.put("*", MathOperations.MPY);
        operationsMap.put("%", MathOperations.MOD);
    }

    public static void main(String[] args) throws RemoteException, NotBoundException {
        Registry registry = LocateRegistry.getRegistry("localhost", 2099);
        RemoteOperationExecutor executor = (RemoteOperationExecutor) registry.lookup("calc");

        Scanner in = new Scanner(System.in);
        Task task;
        double o1,o2;
        String op;
        while (true) {
            System.out.println("Введите число 1:");
            o1 = in.nextDouble();
            System.out.println("Введите число 2:");
            o2 = in.nextDouble();
            System.out.println("Введите оператор (\"exit\" для завершения работы): ");
            op = in.next();
            if (op.equals("exit")) return;
            task = new Task(operationsMap.get(op), o1, o2);
            System.out.println("Результат:");
            System.out.println(executor.execute(task));
        }
    }
}
