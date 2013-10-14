/*
 * EE4210 Project
 * Peer to Peer Application
 * Author: Ken Tran
 * Matric No. U099095A
 */

import java.util.*;
import java.io.*;
import java.net.*;

class FileSync implements Runnable {
    
    private static Socket clientSocket = null;
    private static ServerSocket serverSocket = null;

    private static final int maxPeersCount = 10000; 

    /* Maintain a list of server threads this peer is running
     * and a list of client threads from this peer to others
     */
    private static final SyncServerProcess[] serverThreads = 
                            new SyncServerProcess[maxPeersCount];
    private static final SyncClientProcess[] clientThreads = 
                            new SyncClientProcess[maxPeersCount];

    private static boolean closed = false;

    private static final int useServer = 1;

    public static void main (String args[]) {
        String ipaddr = "";
        if (args.length == 1 ) {
            ipaddr = args[0];
        }

        /* Create a thread to read user input */
        try {
            new Thread(new FileSync()).start();
        } catch (Exception e) {
            System.out.println(e);
        }

        /* Open sockets to other peer */
        try {
            /* Open a listening socket */
            serverSocket = new ServerSocket(5000);
            System.out.println("Waiting for peers at port 5000");

            /* If the user specifically enter the ip address of a peer */
            if (!ipaddr.equals("")) {
                /* Open a socket to a peer and start the client sync process */
                clientSocket = new Socket(ipaddr, 5000);
                SyncClientProcess c = new SyncClientProcess(clientSocket);
                clientThreads[0] = c;
                Thread clientThread = new Thread(c);
                clientThread.start();
            }

            getConnectedPeers();

            /* Start the server sync process when a new peer connects 
             * At the same time, start a client sync process to that peer
             */
            while(!closed) {

                Socket s = serverSocket.accept();

                System.out.println("Connection established with " + s.getInetAddress());
               
                for (int i = 0; i < maxPeersCount; i++) {
                    if (serverThreads[i] == null) {
                        /* Start the sync server process */
                        serverThreads[i] = new SyncServerProcess(s);
                        Thread serverThread = new Thread(serverThreads[i]);
                        serverThread.start();
                        break;
                    }
                    
                    if (i == maxPeersCount) {
                        PrintStream output = new PrintStream(s.getOutputStream());
                        output.println("Peer is busy. Please try to connect to another peer");
                        s.close();
                    }
                }

                /*
                * We need to create a client sync process back to the
                * newly connected peer, if that peer is not already
                * connected
                */
                for (int i = 0; i < maxPeersCount; i++) {
                    if (clientThreads[i] != null && 
                            clientThreads[i].getSocketAddr().equals(s.getInetAddress().toString())) {
                        break;
                    } else if (clientThreads[i] == null) {
                        clientSocket = new Socket(s.getInetAddress(), 5000);
                        SyncClientProcess c = new SyncClientProcess(clientSocket);
                        clientThreads[i] = c;
                        Thread clientThread = new Thread(c);
                        clientThread.start();
                        break;
                    }
                }
            }

            /* End Process */

        } catch (Exception e) {
            System.out.println(e + " on listening thread");
        }
    }

    /* Read user input */
    public void run() {
        try {
            BufferedReader br = new BufferedReader (new InputStreamReader(System.in));
            while (!closed) {
                String input = br.readLine().trim();
                String[] command = input.split(" ");

                /* User close the whole program */
                if (command[0].equals("quit")) {
                    for (int i = 0; i < maxPeersCount; i++) {
                        if (clientThreads[i] != null) {
                            clientThreads[i].closeConnection();
                            clientThreads[i] = null;
                        }
                        
                        if (serverThreads[i] != null) {
                            serverThreads[i].closeConnection();
                            serverThreads[i] = null;
                        }
                    }
                    removePeerFromServer();
                    closed = true;
                    br.close();
                    serverSocket.close();
                    clientSocket.close();
                } else if (command[0].equals("disconnect")) {
                    /* Disconnect a specific IP address */
                    for (int i = 0; i < maxPeersCount; i++) {
                        if (clientThreads[i] != null && 
                            clientThreads[i].getSocketAddr().equals("/"+command[1])) 
                        {
                            clientThreads[i].closeConnection();
                            clientThreads[i] = null;
                        }

                        if (serverThreads[i] != null &&
                            serverThreads[i].getSocketAddr().equals("/"+command[1]))
                        {
                            serverThreads[i].closeConnection();
                            serverThreads[i] = null;
                        }
                    }
                } else if (command[0].equals("connect")) {
                    /* Connect to a specific IP address */
                    for (int i = 0; i < maxPeersCount; i++) {
                        if (clientThreads[i] == null) {
                            clientSocket = new Socket(command[1], 5000);
                            SyncClientProcess c = new SyncClientProcess(clientSocket);
                            clientThreads[i] = c;
                            Thread clientThread = new Thread(c);
                            clientThread.start();
                            break;
                        }

                        if (i == maxPeersCount) {
                            System.out.println(
                                    "You have exceed the amount of connected peers allowed");
                        }
                    }
                } else if (command[0].equals("show")) {
                    /* Show connected Peers retrieved from the server */
                    getConnectedPeers();
                }
            }
        } catch (IOException e) {
            System.out.println(e);
        }  
    }

    private static void getConnectedPeers() {
        if (useServer == 1) {
            try {
                String my_ip = InetAddress.getLocalHost().getHostAddress();
                URL getPeers = new URL("http://ec2-54-234-7-38.compute-1.amazonaws.com/getIpAddr.php?my_ip=" + my_ip);
                URLConnection connection = getPeers.openConnection();

                BufferedReader in = new BufferedReader (
                    new InputStreamReader(connection.getInputStream()));

                String response;
            
                System.out.println("IP address of connected Peers:");
                while ((response = in.readLine()) != null) {                       
                    System.out.println(response);    
                }
            } catch (Exception e) {
                System.out.println(e);
            }
        }
    }

    private static void removePeerFromServer() {
        try {
            String my_ip = InetAddress.getLocalHost().getHostAddress();
            URL removePeer = new URL("http://ec2-54-234-7-38.compute-1.amazonaws.com/closeConnection.php?peer_ip=" + my_ip);
        
            URLConnection connection = removePeer.openConnection();
            BufferedReader in = new BufferedReader (
                    new InputStreamReader(connection.getInputStream()));

            String response = in.readLine();
        } catch (Exception e) {
            System.out.println(e);
        }
    }
}

class SyncClientProcess extends Thread {
    private Socket s;

    private BufferedReader br;
    private BufferedWriter bw;
    private PrintStream os;
    private Queue<String> newlist;
    private LinkedList<String> mylist;

    private String path = ".";

    private boolean closed = false;

    SyncClientProcess (Socket s) {
        try {
            this.s = s;
            br = new BufferedReader(new InputStreamReader(s.getInputStream()));
            os = new PrintStream(s.getOutputStream());
            newlist = new LinkedList<String>();
            mylist = new LinkedList<String>();
        } catch (IOException e) {
            System.out.println(e);
        }
    }

    public void run() {
        try {
            while (!closed) {
                /* Handshake with server before syncing */
                os.println("SYNC");
                String checkAlive = br.readLine();

                if (checkAlive == null)
                    break;

                if (!checkAlive.equals("ACK"))
                    break;

                /* The syncing process */
                System.out.println("ACK received from: " + s.getInetAddress());
                UpdateFileList();
                os.println("FILESYNC");
                GetSyncInfo(); 
                System.out.println("Start file syncing with: " + s.getInetAddress());

                while(!newlist.isEmpty()) {
                    os.println("GET");
                    String filename = newlist.poll();
                    ReceiveFile(filename);
                }
                Thread.currentThread().sleep(10000);
            }

            /* Close client connection when done */
            System.out.println("Peer exits. Client thread closed with " + s.getInetAddress());
            s.close();
            br.close();
            os.close();
        } catch (Exception e) {
            System.out.println(e);
        }
    }

    private void GetSyncInfo() throws Exception {
        String filename;
        newlist.clear();

        /* Put the file list in peer to newlist */
        while (true) {
            filename = br.readLine();
           
            if (filename.equals("EOF"))
                break;

            if (!filename.equals("")) 
                newlist.add(filename);
        }

        /* Remove the file we already have */
        while (!mylist.isEmpty()) {
            filename = mylist.pop();
            newlist.remove(filename);
        }
    }

    private void ReceiveFile(String filename) throws Exception {
        os.println(filename);
        String serverResp = br.readLine();

        if (serverResp.compareTo("File Not Found") == 0) {
            System.out.println("File not found on Peer...");
            return;
        } else if (serverResp.compareTo("READY") == 0) {
            System.out.println("Receiving File... " + filename);

            /* Check if directory exists and create it if not */
            if (filename.indexOf("/") != -1) {
                String[] dirs = filename.split("/");
                 
                String dirPath = "";
                for (int i = 0; i < dirs.length - 1; i++) {
                    File newDir = new File(dirPath + dirs[i]);

                    if (!newDir.exists()) {
                        System.out.println("Creating directory: " + newDir.getName());
                        if (newDir.mkdir())
                            System.out.println("DIR created");
                    }

                    dirPath += dirs[i] + "/";
                }
            }

            File f = new File(filename);
            if (f.exists()) {
                return;
            }
            
            FileOutputStream fout = new FileOutputStream(f);
            int ch;
            String temp;
            do {
                temp = br.readLine();
                ch = Integer.parseInt(temp);
                if (ch != -1) {
                    fout.write(ch);
                }
            } while (ch != -1);

            fout.close();
            System.out.println(br.readLine());
        }
    }

    private void UpdateFileList() {
        File folder = new File(path);
        ReadFolder(folder, path);
    }

    private void ReadFolder(File aFile, String path) {
        try {
            if (!path.equals(".")) {
                path = path + "/";
            } else {
                path = "";
            }

            if (aFile.isFile()) {
                mylist.add(path + aFile.getName());
            } else if (aFile.isDirectory()) {
                File[] listOfFiles = aFile.listFiles();

                if (listOfFiles != null) {
                    for (int i = 0; i < listOfFiles.length; i++) {
                        ReadFolder(listOfFiles[i], (path + aFile.getName()));
                    }
                }
            }
        } catch (Exception e) {
            System.out.println(e);
        }
    }

    public String getSocketAddr() {
        return s.getInetAddress().toString();
    }

    public void sendCommand(String command) {
        os.println(command);
    }

    public void closeConnection() {
        closed = true;
    }
}

class SyncServerProcess extends Thread {
    private Socket s;

    private BufferedReader br;
    private PrintStream os;

    private String path = ".";

    private boolean closed = false;

    SyncServerProcess (Socket s) {
        try {
            this.s = s;
            br = new BufferedReader(new InputStreamReader(s.getInputStream()));
            os = new PrintStream(s.getOutputStream());
        } catch (IOException e) {
            System.out.println(e);
        }
    }

    public void run() {
        try {
            while (!closed) {
                String action = br.readLine();

                if (closed)
                    break;

                if (action == null)
                    break;
                
                if (action.equals("SYNC")) {
                    System.out.println("SYNC received from: " + s.getInetAddress());
                    os.println("ACK");
                    continue;
                } else if (action.equals("FILESYNC")) {
                    System.out.println("FILESYNC received from " + s.getInetAddress());
                    SendSyncInfo();
                    continue;
                } else if (action.equals("GET")) {
                    System.out.println("GET received from: " +s.getInetAddress());
                    SendFile();
                    continue;
                } 
            }

            /* Close the socket to that peer */
            System.out.println("Peer exits. Server thread closed with " + s.getInetAddress());
            s.close();
            br.close();
            os.close();
        } catch (Exception e) {
            System.out.println(e);
        } 
    }

    private void SendSyncInfo() throws Exception {
        File folder = new File(path);
        ReadFolder(folder, path);
        os.println("EOF");
    }

    private void ReadFolder(File aFile, String path) {
        try {
            if (!path.equals(".")) {
                path += "/";
            } else {
                path = "";
            }

            if (aFile.isFile()) {
                os.println(path + aFile.getName());
            } else if (aFile.isDirectory()) {
                File [] listOfFiles = aFile.listFiles();

                if (listOfFiles != null) {
                    for (int i = 0; i < listOfFiles.length; i++) {
                        ReadFolder(listOfFiles[i], (path + aFile.getName()));
                    }
                }
            }
        } catch (Exception e) {
            System.out.println(e);
        }
    }

    private void SendFile() throws Exception {
        String filename = br.readLine();
        File f = new File(filename);
        
        if (!f.exists()) {
            os.println("File Not Found");
            return;
        } else {
            os.println("READY");
            FileInputStream fin = new FileInputStream(f);
            int ch;
            do {
                ch = fin.read();
                os.println(String.valueOf(ch));
            } while (ch != -1);

            fin.close();
            os.println(filename + " Receive Successfully");
        }
    }

    public void sendCommand (String command) {
        os.println(command);
    }

    public void closeConnection() {
        closed = true;
    }

    public String getSocketAddr() {
        return s.getInetAddress().toString();
    }
}


