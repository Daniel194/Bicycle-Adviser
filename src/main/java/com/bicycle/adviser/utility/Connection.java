package com.bicycle.adviser.utility;


import java.io.IOException;
import java.io.InputStream;
import java.net.ServerSocket;

public class Connection {

    private final String path = "/usr/local/sicstus/bin/sicstus";
    private final String prologFile = "/Users/daniellungu/Documents/Workspace/Java/Bicycle-Adviser/src/main/prolog/SistemExpert.pl";
    private final String start = "inceput.";

    private Process procesSicstus;
    private ReadMessage read;
    private SendMessage send;

    public SendMessage getSend(){
        return  send;
    }

    public ReadMessage getRead(){
        return read;
    }

    public Connection(int port) throws IOException, InterruptedException {
        InputStream processIs, processStreamErr;
        String command = path + " -f -l " + prologFile + " --goal " + start + " -a " + port;

        ServerSocket servs = new ServerSocket(port);

        //Read and send message to Expert Sistem.
        read=new ReadMessage(this,servs);
        read.start();

        send = new SendMessage(read);
        send.start();

        Runtime rtime = Runtime.getRuntime();

        procesSicstus = rtime.exec(command);

        processIs = procesSicstus.getInputStream();

        processStreamErr = procesSicstus.getErrorStream();
    }
}
