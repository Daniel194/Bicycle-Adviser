package com.bicycle.adviser.model;

import java.util.HashMap;

public class Rule {

    private String image;

    private String sugestion;

    private HashMap<String, String> rules;

    public Rule() {
    }

    public Rule(String image, String sugestion, HashMap<String, String> rules) {
        this.image = image;
        this.sugestion = sugestion;
        this.rules = rules;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public String getSugestion() {
        return sugestion;
    }

    public void setSugestion(String sugestion) {
        this.sugestion = sugestion;
    }

    public HashMap<String, String> getRules() {
        return rules;
    }

    public void setRules(HashMap<String, String> rules) {
        this.rules = rules;
    }
}
