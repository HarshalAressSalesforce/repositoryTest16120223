public class surveyQuestionWrapper {

    public String value{ get; set; }
    public Id optionId{ get ; set; }
    public Question__c question{ get; set;}

    public surveyQuestionWrapper (){
        question = new Question__c ();
        value = '';
    }

    public surveyQuestionWrapper (Question__c c){
        question = c;
        value = '';
    } 
    
    public surveyQuestionWrapper (Question__c c, String val){
        question = c;
        value = val;
    } 
    
    
     public surveyQuestionWrapper (Question__c c, Id val){
        question = c;
        value = val;
    } 
    
    
}