//File: Class for updating survey details
public class editSurvey {
    public String message{get; set;} // Success message to be displayed
    public String title{get; set;} //Title of survey
    public String description{get; set;} //description of survey
    public Survey__c currentSurvey{get;set;}  //Survey to be updated
    public PageReference updateSurvey(){
        if(title != ''){
            currentSurvey.Name = title;
            currentSurvey.Description__c = description;
            try{
                update currentSurvey; 
                //Write your logic here and redirect
                PageReference redirectPage = Page.surveyList;
               redirectPage .getParameters().put('m', '4');
               redirectPage.setRedirect(true);
               return redirectPage;
                message = 'Survey updated successfully.' ;
            }catch(Exception e){
                message = 'Survey was updated successfully.';
                //PageReference retURL = new PageReference('https://aresssurvey-dev-ed--c.ap2.visual.force.com/apex/SurveyList?op=update&opStatus=false');
                //retURL.setRedirect(true);
                //return retURL;
            }//end of try catch block
        }//end of if statment
        else{
            message = 'Please Enter a valid Title';
        }
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM, message); 
        ApexPages.addMessage(myMsg);
        return null;
    }//end of createAcccount Method.
    
    //Method: To load survey on page load for updating
    public void loadInfo(){
        try{
            Id i = ApexPages.currentPage().getParameters().get('id');
            Survey__c survey = [SELECT Name, Description__c,emailTemplate__c,expirationPeriod__c,status__c FROM Survey__c WHERE Id =: i];
            title = survey.Name;
            description = survey.Description__c;
            currentSurvey = survey;
        }catch(Exception e){
            System.debug(e);
        }
    }
    
    
     public PageReference makeClone() {
        
       if(currentSurvey  != null) {
          if(title.trim() != '') {
              Survey__c newSureyDetails = new Survey__c();
              newSureyDetails.Name = title;
              newSureyDetails.Description__c  = description  ;
              newSureyDetails.emailTemplate__c = currentSurvey.emailTemplate__c;
              newSureyDetails.expirationPeriod__c= currentSurvey.expirationPeriod__c;
              newSureyDetails.status__c = currentSurvey.status__c;
              newSureyDetails.createdOn__c= Date.today();
              insert newSureyDetails;
                   
              Id newsurveyId  = newSureyDetails.Id;
              
              title = '';
              description   = '';     
                   
              Set<Id> questionIDs = surveyQuestions.getQuestions(currentSurvey.Id);
              for(List<Question__c> question : [select Id,name,Question__c,typeOfQuestion__c from Question__c where status__c = true and Id IN : questionIDs]) {
                  for(Question__c ques : question ) {                        
                      SurveyQuestion__c SurveyQuestion = new SurveyQuestion__c();                       
                      SurveyQuestion.questionId__c= ques.Id;
                      SurveyQuestion.surveyId__c = newsurveyId ;  
                      insert SurveyQuestion;
                   }
              }
              
               PageReference redirectPage = Page.surveyList;
               redirectPage .getParameters().put('m', '5');
               redirectPage.setRedirect(true);
               return redirectPage;   
       
               ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Clone of survey has been created successfully'); 
               ApexPages.addMessage(myMsg);
          } else {
              ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Title should not be empty.'); 
               ApexPages.addMessage(myMsg);
          }        
          
       } 
       
       
      
        return null;
   }
   
   
   /*
    * Method to save and redirect user to create questions page
    * @param
    * @return: PageReference
    */
    public PageReference manageQuestions() {
        updateSurvey();
        if(currentSurvey != null) {                               
               List<Survey__c> surveyDetails = [SELECT Id, currentState__c FROM Survey__c WHERE Id =: currentSurvey.Id];
               if(surveyDetails.size() > 0) {
                   Survey__c surveyData = surveyDetails[0];
                   if(surveyData.currentState__c == 1) {
                     surveyData.currentState__c++;
                     update surveyData ;
                   } 
               }
               PageReference redirectPage = Page.createSurveyQuestions;
               redirectPage.getParameters().put('surveyId',currentSurvey.Id);
               redirectPage.setRedirect(true);
               return redirectPage;
        }
       return null;
    }
}