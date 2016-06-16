package com.bicycle.adviser.service;

import com.bicycle.adviser.model.Answer;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;


@Path("/answer")
public class AnswerService {

    @GET
    @Path("/{param}")
    @Produces(MediaType.APPLICATION_JSON)
    public Answer getAnswer(@PathParam("param") String option) {
        //TODO

        return null;
    }

}
