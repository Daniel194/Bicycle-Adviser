package com.bicycle.adviser.service;

import com.bicycle.adviser.model.Question;
import com.bicycle.adviser.utility.Connection;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import java.util.HashMap;
import java.util.logging.Level;
import java.util.logging.Logger;


@Path("/answer")
public class AnswerService {
    private static final int PORT = 5002;
    private static Connection conn;

    public AnswerService() {
        if (conn == null) {
            try {
                conn = new Connection(PORT);
            } catch (Exception ex) {
                Logger.getLogger(AnswerService.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
    }

    @GET
    @Path("/{param}")
    @Produces(MediaType.APPLICATION_JSON)
    public Question getMsg(@PathParam("param") String option) {
        String question = null;
        HashMap<String, String> options = new HashMap<>();

        try {

            // Send message to Expert Sistem.
            conn.getSend().sendMessage(option);

            // Read the message from Expert System.
            question = conn.getRead().getMessage();

        } catch (InterruptedException ex) {
            Logger.getLogger(AnswerService.class.getName()).log(Level.SEVERE, null, ex);
        }

        return new Question(question, options);
    }

}
