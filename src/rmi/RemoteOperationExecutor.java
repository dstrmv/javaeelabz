package rmi;

import java.rmi.Remote;
import java.rmi.RemoteException;

public interface RemoteOperationExecutor extends Remote {

    double execute(Task task) throws RemoteException;

}
