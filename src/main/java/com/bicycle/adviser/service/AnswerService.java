package com.bicycle.adviser.service;

import com.bicycle.adviser.model.Answer;
import com.bicycle.adviser.model.Rule;
import com.bicycle.adviser.utility.Constant;
import com.fasterxml.jackson.core.JsonGenerationException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import javax.ws.rs.Consumes;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


@Path("/answer")
public class AnswerService {

    @POST
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public List<Answer> getAnswers(HashMap<String, String> responses) {
        ObjectMapper mapper = new ObjectMapper();
        List<Answer> answers = new ArrayList<>();
        List<Rule> rules = null;

        try {
            // Convert JSON string from file to Object
            rules = mapper.readValue(new File(Constant.rulePath), new TypeReference<List<Rule>>() {
            });

            for (Rule rule : rules) {
                if (responseHasRule(responses, rule.getRules())) {
                    Answer answer = new Answer(rule.getSugestion(), "img/" + rule.getImage());
                    answers.add(answer);
                }
            }

        } catch (JsonGenerationException e) {
            e.printStackTrace();
        } catch (JsonMappingException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }

        return answers;
    }


    private boolean responseHasRule(HashMap<String, String> responses, HashMap<String, String> rules) {

        for (Map.Entry<String, String> rule : rules.entrySet()) {
            if (responses.get(rule.getKey()) == null || !responses.get(rule.getKey()).equals(rule.getValue()))
                return false;
        }

        return true;
    }

}
