public class CreateSurvey {
    public String message{get; set;}
    public String surveyName{get; set;}
    public String description{get; set;}
    public Id surveyId{ get;private set;}
    
    
    public void getSessionTest() {
        system.debug(Cache.Session.getKeys());
        List<Question__c > questions =  [SELECT Id,name,Question__c FROM Question__c  order by createdOn__c desc];
        
        if(!Cache.Session.contains('questions')) {    
          Cache.Session.put('questions', questions );  
         
        }
        
        if (!Cache.Session.contains('sessionTest')) {            
            Cache.Session.put('sessionTest', 'This is the session Value');   
            system.debug('Empty Session');    
            system.debug(String.valueOf(Cache.Session.get('sessionTest')));     
        } else {
            system.debug('Not Empty Session');
            system.debug(String.valueOf(Cache.Session.get('sessionTest')));
        }
    }
     
    /*
    * Method to save survey
    * @param
    * @return PageReference //IF REQUIRED IN FUTURE
    */
    public PageReference createSurvey(){
       // getSessionTest();
        
        if(surveyName.trim() != ''){
            Survey__c survey = new Survey__c();
            survey.Name = surveyName;
            survey.Description__c = description;
            survey.createdOn__c = Datetime.now();
            survey.currentState__c = 1;
            
            try{
                insert survey;
                surveyId = survey.Id;
                
                PageReference redirectPage = Page.surveyList;
                redirectPage .getParameters().put('m', '3');
                redirectPage.setRedirect(true);
                return redirectPage;  
                
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Survey has been successfully created'); 
                ApexPages.addMessage(myMsg);
            }catch(Exception e){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Survey was not successfully created.'); 
                ApexPages.addMessage(myMsg);
            }//end of try catch block
        }//end of if statement
        else{
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter a valid title.'); 
            ApexPages.addMessage(myMsg);
        }
        return null;
    }//end of createAcccount Method.
    
    /*
    * Method to save and redirect user to create questions page
    * @param
    * @return: PageReference
    */
    public PageReference manageQuestions() {
        CreateSurvey();
         if(surveyId != null) {                               
               List<Survey__c> surveyDetails = [SELECT Id, currentState__c FROM Survey__c WHERE Id =: surveyId];
               if(surveyDetails.size() > 0) {
                   Survey__c surveyData = surveyDetails[0];
                   surveyData.currentState__c++;
                   update surveyData ;
               }
               PageReference redirectPage = Page.createSurveyQuestions;
               redirectPage.getParameters().put('surveyId',surveyId);
               redirectPage.setRedirect(true);
               return redirectPage;
        }
       return null;
    }
}