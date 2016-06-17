package com.bicycle.adviser.model;


public class Answer {

    private String sugestion;

    private String image;

    public Answer() {
    }

    public Answer(String sugestion, String image) {
        this.sugestion = sugestion;
        this.image = image;
    }

    public String getSugestion() {
        return sugestion;
    }

    public void setSugestion(String sugestion) {
        this.sugestion = sugestion;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }
}
