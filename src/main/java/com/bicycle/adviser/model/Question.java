package com.bicycle.adviser.model;


import java.util.HashMap;

public class Question {

    private int number;

    private String value;

    private String message;

    private HashMap<String, String> options;

    public Question() {
    }

    public Question(int number, String value, String question, HashMap<String, String> options) {
        if (number > 0)
            this.number = number;
        else
            this.number = 0;

        this.value = value;
        this.message = question;
        this.options = options;
    }

    public int getNumber() {
        return number;
    }

    public void setNumber(int number) {

        if (number > 0)
            this.number = number;
        else
            number = 0;
    }

    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public HashMap<String, String> getOptions() {
        return options;
    }

    public void setOptions(HashMap<String, String> options) {
        this.options = options;
    }
}
