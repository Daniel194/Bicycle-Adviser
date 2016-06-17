package com.bicycle.adviser.service;

import com.bicycle.adviser.model.Answer;
import com.bicycle.adviser.model.Response;

import javax.ws.rs.Consumes;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import java.util.ArrayList;
import java.util.List;


@Path("/answer")
public class AnswerService {

    @POST
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public List<Answer> getAnswers(List<Response> responses) {

        List<Answer> answers = new ArrayList<>();
        Answer answer = new Answer("Verifica pinioane!", "img/6.jpg");

        answers.add(answer);

        return answers;
    }

}
