package rmi;

import java.rmi.AlreadyBoundException;
import java.rmi.Remote;
import java.rmi.RemoteException;
import java.rmi.registry.LocateRegistry;
import java.rmi.registry.Registry;
import java.rmi.server.UnicastRemoteObject;

public class Server {
    public static void main(String[] args) throws RemoteException, AlreadyBoundException, InterruptedException {
        Registry registry;

        registry = LocateRegistry.createRegistry(2099);
        RemoteOperationExecutor executor = new RemoteOperationExecutorImpl();
        Remote stub = UnicastRemoteObject.exportObject(executor, 0);
        registry.bind("calc", stub);
        while (true) {
            Thread.sleep(Integer.MAX_VALUE);
        }


    }

}
