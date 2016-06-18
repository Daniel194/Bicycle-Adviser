# Bicycle Adviser

  **Bicycle Adviser** is an web page which indicate the problem of a bicycle. The problem is established by an Expert System which was written in Prolog. The comunication between Expert System and GUI is made via Socket. It was created two Web Services, one returns all questions for the user and other based on the user answers establishes the problem.
  
  The Web Services was written in Java using JAX-RS to create RESTful Web Services and Jersey to implement it. The Web Services return and receive JSON objects, it was used Jackson to convert JSON object in a Java object and convert Java object in JSON object.
  
  The GUI was written in AngularJS and Bootstrap.
  
  **Technologies used in this project:**
  * SICStus Prolog 4.3.3
  * Java 1.8
  * Maven
  * JAX-RS 2.0.1
  * Jersey 2.19
  * Jackson 2.6.3
  * AngularJS 1.5.7
  * Bootstrap 3.3.6
