package com.bicycle.adviser.model;


import java.util.HashMap;

public class Question {

    private String question;

    private HashMap<String,String> options;

    public Question() {
    }

    public Question(String question, HashMap<String,String> options) {
        this.question = question;
        this.options = options;
    }

    public String getQuestion() {
        return question;
    }

    public void setQuestion(String question) {
        this.question = question;
    }

    public HashMap<String,String> getOptions() {
        return options;
    }

    public void setOptions(HashMap<String,String> options) {
        this.options = options;
    }
}
