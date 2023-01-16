public class surveyFeedbackWrapper {

    public Survey__c surveyDetails{ get; private set; }
    public surveyRecipient__c surveyRecipientDetails{ get; private set; }
    public User  userDetails{ get; private set; }
    public Feedback__c feedback{ get; set;}

    public surveyFeedbackWrapper (){
       
    }

    public surveyFeedbackWrapper (Feedback__c c){
        feedback = c; 
        
        list<Survey__c> surveyData = [SELECT Name, Description__c FROM Survey__c WHERE Id =: feedback.surveyId__c];
        if(surveyData.size()>0) {
            surveyDetails = surveyData[0];
        }
        
        if(feedback.SurveyRecipientId__c != null) {
           list<surveyRecipient__c> surveyRecipientData = [SELECT userId__c FROM surveyRecipient__c WHERE Id =: feedback.SurveyRecipientId__c];
           if(surveyRecipientData.size()>0) {
                surveyRecipientDetails = surveyRecipientData[0];
           } 
        }
        
        if(feedback.userId__c != null) {
           list<User> userData = [SELECT Email,FirstName,LastName FROM User WHERE Id =: feedback.userId__c];
           if(userData.size()>0) {
                userDetails = userData[0];
           } 
        } 
    }  
}