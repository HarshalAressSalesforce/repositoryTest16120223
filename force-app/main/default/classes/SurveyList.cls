/* Class: SurveyList 
 * Description: Includes all the methods for handling survey related opertions on surveyList.vfp page
 * Author: Aress
 * Version: 38.0
 */
public class SurveyList{
    public LIST<Survey__c> surveyList { set; get; }                 //Surveylist to be dispayed
    public String idToDelete {set; get;}                            //Id of the survey to be deleted
    public String searchFilter {get;set;}                           //String searchFilter for filtering the surveyList
    public String surveyId{get;set;}                                //Id of the survey to fetch recipients
    public List<surveyRecipient__c> lstSurveyRecipBySId {get;set;}  //SurveyRecipient List        
    
    /* Add Database query locator to standardController
     */
    public ApexPages.StandardSetController con {
        get {
            if(con == null) {
                con = new ApexPages.StandardSetController(Database.getQueryLocator([select Id,name,Description__c,isSent__c,createdOn__c from Survey__c order by createdOn__c DESC NULLS LAST]));
                // sets the number of records in each page set
                con.setPageSize(surveyConfigs.numberOfRecordPerPage);
            }
            return con;
        }
        set;
    }
    
    /* Method to search survey using searchFilter string as survey name
    * @param:
    * @return: void
    */
    public void search() {
        if(searchFilter != null) {
            string tempInput = '%' + searchFilter + '%';
            con = new ApexPages.StandardSetController(Database.getQueryLocator([SELECT Id,name,Description__c,isSent__c FROM Survey__c WHERE Name LIKE :tempInput  order by createdOn__c DESC NULLS LAST]));
            con.setPageSize(surveyConfigs.numberOfRecordPerPage);
        }   
    }
    
  
    
    /* Method to load all surveys in DESC order of createdOn__c datetime
    * @param:
    * @return: List<Survey__c>
    */
    public List<Survey__c> getSurveys(){
        String msg = Apexpages.currentPage().getParameters().get('m');
        if(msg != null) 
        {
            Integer messageNumber = Integer.valueOf(msg );
            if(messageNumber != null) 
            {
                if (messageNumber == 1) 
                {
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Recipient has been successfully inserted.');
                    ApexPages.addMessage(myMsg);         
                } 
                
                if (messageNumber == 3) 
                {
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Survey has been successfully created.');
                    ApexPages.addMessage(myMsg);         
                }

                if (messageNumber == 4) 
                {
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Survey has been successfully updated.');
                    ApexPages.addMessage(myMsg);         
                }               
                
                if (messageNumber == 5) 
                {
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Clone of survey has been created successfully.');
                    ApexPages.addMessage(myMsg);         
                }  
                             
            }
        }
        
        return (List<Survey__c>)con.getRecords();
    }
    
    /* Method to delete a survey.
    * @param:  
    * @return: PageReference //for if redirect needed in future
    */
    public PageReference deleteSurvey(){
        id idToDelete = ApexPages.currentPage().getParameters().get('id');
        if(idToDelete!=null){
            try{
                delete [SELECT Id FROM SurveyQuestion__c WHERE surveyId__c = :idToDelete];
                delete [SELECT Id FROM SurveyRecipient__c WHERE surveyId__c = :idToDelete];
                delete [SELECT Id FROM FeedbackDetail__c WHERE feedbackId__r.surveyId__c = :idToDelete];
                delete [SELECT Id FROM Feedback__c WHERE surveyId__c = :idToDelete];
                delete [SELECT Id FROM Survey__c WHERE Id =: idToDelete];
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Survey has been deleted successfully.'); 
                ApexPages.addMessage(myMsg);
            }catch(Exception e){
                System.debug('Error in deletion: '+e);
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Survey was not deleted successfully.'); 
                ApexPages.addMessage(myMsg);
            }
        }
        return null;
    }
    
    /* Load Email template which is Active.
    * @param:
    * @return: List<EmailTemplate__c>  
    */
    /*public List<EmailTemplate__c> getEmailTemplate()
    {       
        List<EmailTemplate__c> lstEmailTemplate;
        try
        {
            if(lstEmailTemplate==null)
            {
                lstEmailTemplate = new List<EmailTemplate__c>();
                lstEmailTemplate = [select Id,title__c,description__c from EmailTemplate__c where status__c = true];               
            }           
        }
        catch(Exception ex)
        {
            system.debug(''+ ex.getMessage());
        }
        return lstEmailTemplate;
    }*/
    
    /* Loads the all the Recipient for that survey.
    * @param: 
    * @return: void
    */
    /*public void getSurveyRecipient()
    {
        try
        {
            if(surveyId != '' && surveyId != null)
            {
                if(lstSurveyRecipBySId == null)
                {
                    lstSurveyRecipBySId = new List<surveyRecipient__c>();
                    lstSurveyRecipBySId =[select Id,name,userId__c from surveyRecipient__c where surveyId__c=:surveyId];
                    system.debug('surveyId for '+surveyId +'selected Recipients are- '+lstSurveyRecipBySId);
                }
            }
        }catch(Exception ex)
        {
            system.debug(''+ ex.getMessage());
        }
    }*/
    
    /*This function get's the Recipient and EmailTemplate and fires the emails to them.This function is action for send email link button.
    * @param:
    * @return: void
    */
    /*public void sendEmailToRecipient()
    {        
        List<EmailTemplate__c> lstEmailTemplate = getEmailTemplate();
        getSurveyRecipient();
        
        if(lstSurveyRecipBySId.size()!=0 && lstSurveyRecipBySId!=null)
        {   
            if(lstEmailTemplate.size()!=0 && lstEmailTemplate!=null)
            {    
                sendEmailToRecipient(lstSurveyRecipBySId,lstEmailTemplate);
                Survey__c survey = [SELECT Id FROM Survey__c WHERE Id=:surveyId];
                survey.isSent__c=true;
                survey.sentDate__c = DateTime.now();
                update survey;
            }
            else
            {
                system.debug('EmailTemplate status is not active!');
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.WARNING,'EmailTemplate status is not active!'); 
                ApexPages.addMessage(myMsg);
            }
        }else
        {
            system.debug('Recipient Does not exists.Plz add the Recipient!');
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.WARNING,'Recipient Does not exists.Plz add the Recipient!'); 
            ApexPages.addMessage(myMsg);
        }
    }*/
    
    /*send email method: This method needs to be executed after adding questions and selecting recipients for the survey
    * @param: list of recipients and email templates to be sent
    * @return: void
    */
    /*public void sendEmailToRecipient(List<surveyRecipient__c> lstSurveyRecipBySId,List<EmailTemplate__c> lstEmailTemplate)
    {
        List<Messaging.SingleEmailMessage> lstMails = new List<Messaging.SingleEmailMessage>(); //Initate Email object
        for(surveyRecipient__c recipient : lstSurveyRecipBySId)
        {
            // Create a new Email
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); //Initate Email object
            
            // Set list of people who should get the email
            List<String> lstSendTo= new List<String>();
            lstSendTo.add(recipient.userId__c);
            mail.setToAddresses(lstSendTo);
            system.debug('List of Email send to :- '+lstSendTo);
            
            // Set who the email is sent from
            mail.setSenderDisplayName('Aress Softwares and Education Services');
            
            // Email subject
            mail.subject = lstEmailTemplate[0].title__c;             
            
            String body = lstEmailTemplate[0].description__c;
            body = body.replace('{URL}', generateURL()+'?recptId='+recipient.Id); 
            mail.setHtmlBody(body);
            
            // Add your email to the master list
            lstMails.add(mail);           
        }
        Messaging.SendEmailResult[] results = Messaging.sendEmail(lstMails);
        
        if (results[0].success)
        {
            try
            {
                Survey__c updateSurvey=[select emailTemplate__c from survey__c where id=:surveyId];
                updateSurvey.emailTemplate__c = lstEmailTemplate[0].Id;
                update updateSurvey;
                // Verify that the emailTemplate__c filed was updated.
                Survey__c afterUpdate = [select emailTemplate__c from survey__c where id=:surveyId];
                System.assertEquals(lstEmailTemplate[0].Id, afterUpdate.emailTemplate__c);
                System.debug('EmailTemplate field of survey Object is Updated successfully.');
            }
            catch(DmlException ex)
            {
                System.debug('Updation Failed - '+ex.getMessage());
            }
            System.debug('The email was sent successfully.');
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Email Send Successfully'); 
            ApexPages.addMessage(myMsg);
        }
        else
        {
            System.debug('The email failed to send: ' + results[0].errors[0].message);
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Failed to Send Email.'); 
            ApexPages.addMessage(myMsg); 
        }
    }*/
    
    /* Method to get Force.com public domain for recipient form
    *  @param: 
    *  @return: Generated url for the recipient survey form
    */
    /*public String generateURL(){
        //Public guest access domain for recipient form
        Site site = [SELECT Subdomain, UrlPathPrefix FROM Site];
        String url = 'https://' + site.Subdomain + '.ap2.force.com/' + site.UrlPathPrefix;
        return url;
    }*/
    
    /* Reset filters from lisitng page
    * @param  
    * @return 
    */ 
    public PageReference Reload() {
        PageReference surveylist = Page.surveyList;
        surveylist.setRedirect(true);
        return surveylist; 
    }
}