public class allocationsController {
    public Id qId{ get; set; } 
    
    /* Method for fetching all surveys that have the given question as allocated
     * @param:
     * @return: List<Survey__c>
     */
    public LIST<Survey__C> getAllocatedSurveys(){
        qId = ApexPages.currentPage().getParameters().get('qId');
        return (List<Survey__c>)allocatedCon.getRecords();
    }
    
    public ApexPages.StandardSetController allocatedCon {
        get {
            if(allocatedCon == null) {
                allocatedCon = new ApexPages.StandardSetController(Database.getQueryLocator([SELECT Id, Name, Description__c FROM Survey__c WHERE Id 
                                   IN (SELECT SurveyId__c FROM SurveyQuestion__c WHERE questionId__c = :qId)]));
                // sets the number of records in each page set
                allocatedCon.setPageSize(surveyConfigs.numberOfRecordPerPage);
            }
            return allocatedCon;
        }
        set;
    }
    
    /* Method to delete a survey for the purpose of deleting a question
    * @param:  
    * @return: PageReference //for if redirect needed in future
    */
    public PageReference deleteAllocatedSurvey(){
        //--------------------------
        LIST<Survey__C> surveys = getAllocatedSurveys();
        system.debug(surveys);
        if(surveys.size()<=0){
            PageReference returnToQuestions = Page.ManageQuestions;
            returnToQuestions.getParameters().put('m','3');
            returnToQuestions.setRedirect(true);
            return returnToQuestions;
        }
        //--------------------------
        //system.debug(ApexPages.currentPage().getParameters().get('qId'));
        id idToDelete = ApexPages.currentPage().getParameters().get('id');
        id qId = ApexPages.currentPage().getParameters().get('qId');      
        String message = ApexPages.currentPage().getParameters().get('m');
        if(idToDelete!=null){
            try{
                delete [SELECT Id FROM SurveyQuestion__c WHERE surveyId__c = :idToDelete];
                delete [SELECT Id FROM SurveyRecipient__c WHERE surveyId__c = :idToDelete];
                delete [SELECT Id FROM FeedbackDetail__c WHERE feedbackId__r.surveyId__c = :idToDelete];
                delete [SELECT Id FROM Feedback__c WHERE surveyId__c = :idToDelete];
                delete [SELECT Id FROM Survey__c WHERE Id =: idToDelete];
               
                PageReference allocationsPage = Page.questionAllocations;
                allocationsPage.getParameters().put('m','1');
                allocationsPage.getParameters().put('qId',qId);
                allocationsPage.setRedirect(true);
                return allocationsPage;
            }catch(Exception e){
                PageReference allocationsPage = Page.questionAllocations;
                allocationsPage.getParameters().put('m','2');
                allocationsPage.getParameters().put('qId',qId);
                allocationsPage.setRedirect(true);
                return allocationsPage;
            }
        }
        
        if(message != null){
            if(message == '1'){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Survey has been deleted successfully.'); 
                ApexPages.addMessage(myMsg);
            }
            
            if(message == '2'){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Survey was not deleted successfully.'); 
                ApexPages.addMessage(myMsg);
            }
        }
        
        return null;
    }
}