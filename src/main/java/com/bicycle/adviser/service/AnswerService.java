package com.bicycle.adviser.service;

import com.bicycle.adviser.model.Question;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import java.util.HashMap;


@Path("/answer")
public class AnswerService {

    @GET
    @Path("/{param}")
    @Produces(MediaType.APPLICATION_JSON)
    public Question getMsg(@PathParam("param") String option) {

        String question = "Unde scartaie bicicleta ?";
        HashMap<String,String> options = new HashMap<>();

        options.put("fata","Fata");
        options.put("spate","Spate");
        options.put("centru","Centru");
        options.put("nu_scartaie","Nu Scartaie");

        return new Question(question, options);
    }

}
