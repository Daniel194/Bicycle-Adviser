package com.bicycle.adviser.utility;


import javax.swing.*;
import java.io.IOException;
import java.io.InputStream;
import java.io.PipedInputStream;
import java.io.PipedOutputStream;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ReadMessage extends Thread {
    private ServerSocket servs;
    private volatile Socket s = null;
    private volatile PipedInputStream pis = null;
    private Connection connection;

    public synchronized void setSocket(Socket s) {
        this.s = s;
        notify();
    }

    public final synchronized void setPipedInputStream(PipedInputStream pis) {
        this.pis = pis;
        notify();
    }

    public synchronized Socket getSocket() throws InterruptedException {
        if (s == null)
            wait();

        return s;
    }

    public synchronized PipedInputStream getPipedInputStream() throws InterruptedException {
        if (pis == null)
            wait();

        return pis;
    }


    public ReadMessage(Connection connection, ServerSocket servs) throws IOException {
        this.servs = servs;
        this.connection = connection;
    }

    public void run() {

        try {
            Socket s_aux = servs.accept();
            setSocket(s_aux);

            InputStream is = s_aux.getInputStream();

            PipedOutputStream pos = new PipedOutputStream();
            setPipedInputStream(new PipedInputStream(pos));

            int chr;
            String str = "";

            while ((chr = is.read()) != -1) {
                pos.write(chr);
                str += (char) chr;

                if (chr == '\n') {
                    final String sirDeScris = str;
                    str = "";
                    SwingUtilities.invokeLater(new Runnable() {
                        public void run() {
                            // TODO
                            //connection.getFereastra().getDebugTextArea().append(sirDeScris);
                        }
                    });
                }
            }
        } catch (IOException ex) {
            Logger.getLogger(ReadMessage.class.getName()).log(Level.SEVERE, null, ex);
        }

    }

}
