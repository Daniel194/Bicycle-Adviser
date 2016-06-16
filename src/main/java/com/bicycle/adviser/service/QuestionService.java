package com.bicycle.adviser.service;

import com.bicycle.adviser.model.Question;
import com.bicycle.adviser.utility.Constant;
import com.fasterxml.jackson.core.JsonGenerationException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import java.io.File;
import java.io.IOException;
import java.lang.reflect.Array;
import java.util.ArrayList;
import java.util.List;

@Path("/question")
public class QuestionService {


    @GET
    @Path("/all")
    @Produces(MediaType.APPLICATION_JSON)
    public List<Question> getAllQuestions() {
        ObjectMapper mapper = new ObjectMapper();
        List<Question> questions = null;

        try {
            // Convert JSON string from file to Object
            questions = mapper.readValue(new File(Constant.questionPath), new TypeReference<List<Question>>(){});

        } catch (JsonGenerationException e) {
            e.printStackTrace();
        } catch (JsonMappingException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }

        return questions;
    }
}
