package rmi;

import java.rmi.NotBoundException;
import java.rmi.RemoteException;
import java.rmi.registry.LocateRegistry;
import java.rmi.registry.Registry;

public class Client {
    public static void main(String[] args) throws RemoteException, NotBoundException {
        Registry registry = LocateRegistry.getRegistry("localhost", 2099);
        RemoteOperationExecutor executor = (RemoteOperationExecutor) registry.lookup("calc");
        Task task = new Task(MathOperations.SUB, 100, 200);
        System.out.println(executor.execute(task));
    }
}
