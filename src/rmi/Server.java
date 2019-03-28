package rmi;

import java.rmi.AlreadyBoundException;
import java.rmi.Remote;
import java.rmi.RemoteException;
import java.rmi.registry.LocateRegistry;
import java.rmi.registry.Registry;
import java.rmi.server.UnicastRemoteObject;

public class Server {
    public static void main(String[] args) {
        Registry registry;
        try {
            registry = LocateRegistry.createRegistry(1099);
            Remote stub = UnicastRemoteObject.exportObject(new RemoteOperationExecutorImpl(), 0);
            registry.bind("calc", stub);

        } catch (RemoteException | AlreadyBoundException e) {
            e.printStackTrace();
        }

    }

}
