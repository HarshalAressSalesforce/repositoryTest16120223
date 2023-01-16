public class surveyTabs {
     public Id currentSurveyId{ get;set;}
     public Survey__c  currentSurveyDetails {get;private set;}
     
     
     public surveyTabs () {
     
     } 
     
     public void getloadSurveydetails() {
         system.debug('currentSurveyId -->'+currentSurveyId );
        if(currentSurveyId != null) {
            List<Survey__c> surveyDetails = [SELECT Id, currentState__c FROM Survey__c WHERE Id =: currentSurveyId];
            if(surveyDetails.size() > 0) {
                currentSurveyDetails = surveyDetails[0];                
            }            
        }
     }
     
}