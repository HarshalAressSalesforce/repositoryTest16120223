/*
Class Name: Class to question checkbox wrapper on the survey question assignment page
Author: Aress
Version: 38.0 
*/

public class questionWrapper {

    public Boolean checked{ get; set; }
    public Question__c question{ get; set;}

    public questionWrapper (){
        question = new Question__c ();
        checked = false;
    }

    public questionWrapper(Question__c c){
        question = c;
        checked = false;
    }  
}