package com.bicycle.adviser.utility;


import java.io.*;
import java.net.Socket;
import java.util.logging.Level;
import java.util.logging.Logger;

public class SendMessage extends Thread {
    private Socket s;
    private ReadMessage read;
    private volatile PipedOutputStream pos = null;
    private PipedInputStream pis;
    private OutputStream ostream;
    private volatile boolean done = false;

    public final synchronized void setPipedOutputStream(PipedOutputStream pos) {
        this.pos = pos;
        notify();
    }

    public synchronized PipedOutputStream getPipedOutputStream() throws InterruptedException {
        if (pos == null)
            wait();

        return pos;
    }

    public SendMessage(ReadMessage read) throws IOException {
        this.read = read;
        this.pis = new PipedInputStream();
        setPipedOutputStream(new PipedOutputStream(pis));
    }

    public void sendMessage(String message) throws InterruptedException {
        PipedOutputStream pos = getPipedOutputStream();
        PrintStream ps = new PrintStream(pos);
        ps.println(message + " .");
        ps.flush();
    }

    public void run() {
        try {
            s = read.getSocket();
            ostream = s.getOutputStream();
            int chr;
            while ((chr = pis.read()) != -1) {
                ostream.write(chr);
            }
        } catch (IOException ex) {
            Logger.getLogger(SendMessage.class.getName()).log(Level.SEVERE, null, ex);
        } catch (InterruptedException ex) {
            Logger.getLogger(SendMessage.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

}
