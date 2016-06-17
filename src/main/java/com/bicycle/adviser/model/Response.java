package com.bicycle.adviser.model;

public class Response {

    private String value;

    private String answer;


    public Response() {
    }

    public Response(String value, String answer) {
        this.value = value;
        this.answer = answer;
    }

    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }

    public String getAnswer() {
        return answer;
    }

    public void setAnswer(String answer) {
        this.answer = answer;
    }
}
