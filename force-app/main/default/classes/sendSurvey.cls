public class sendSurvey
{
    public string surveyId {get;set;}
    public List<SurveyRecipient__c> lstSurveyRecipient {get;set;}
    public List<cSurveyRecipient> lstSurveyRecipientEmail {get;set;}
    public List<SurveyRecipient__c> lstSendEmailToRecipient {get;set;}
    public string searchFilter {get;set;}
    public boolean isHideButton {get;set;}

    
    /* Add Database query locator to standardController    
    */ 
       
    public ApexPages.StandardSetController con 
    {
        get
        {
            if(con==null)
            {
                con=new ApexPages.StandardSetController(Database.getQueryLocator([select id,surveyId__c,objectId__c,typeOfRecipient__c,email__c from surveyRecipient__c where surveyId__c =:surveyId order by email__c]));
                //set the no of record in each page set
                con.setPageSize(surveyConfigs.numberOfRecordPerPage);
            }   
            return con;
        }
        set;
    }
    
    /* Method to load all surveyRecipient
    * @param:
    * @return: List<SurveyRecipient__c>
    */
    public List<SurveyRecipient__c> getSurveyRecipients()
    {
        return (List<SurveyRecipient__c>)con.getRecords();        
    }
    
    /* Method To get the survey Id from the URL
    * @param:
    * @return: surveyId
    */
    public string getSurveyIdFromUrl()
    {
        try
        { 
            if(ApexPages.currentPage().getParameters().get('surveyId')!=null)
            {
                surveyId =  ApexPages.currentPage().getParameters().get('surveyId');
            }
        }
        catch(Exception ex)
        {
            system.debug(''+ ex.getMessage());
        }
        return surveyId;
    }
    
    /* Method to delete a survey.
    * @param:  
    * @return: null 
    */
    public PageReference deleteSurveyrecipient()
    {        
        boolean isDeleteFlag=true;
        if(surveyId==null)
            surveyId = getSurveyIdFromUrl();
        id idToDelete = ApexPages.currentPage().getParameters().get('srId');
        try
        {
            if(idToDelete!=null)
            {
                List<SurveyRecipient__c> deleteEmailDetails = [SELECT Id,Email__c FROM SurveyRecipient__c WHERE Id =: idToDelete limit 1];
                if(deleteEmailDetails.size() > 0) 
                {
                    SurveyRecipient__c deleteEmail = deleteEmailDetails[0];
                    List<feedback__c> chkfeedback;
                    if(chkfeedback==null)
                    {
                        chkfeedback=new List<feedback__c>();
                        chkfeedback = [select SurveyRecipientId__c from feedback__c where SurveyRecipientId__c=:idToDelete];
                        if(chkfeedback.size() > 0)
                        {
                            if( deleteEmail.Id == chkfeedback[0].SurveyRecipientId__c)
                            {
                                isDeleteFlag=true;                                
                            }
                        }
                        else
                        {                         
                            delete deleteEmail;
                            isDeleteFlag=false;                            
                        }                 
                    }   
                    if(isDeleteFlag==true)
                    {                        
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Sorry! Recipient has attempted the feedback'));
                    }
                    else if(isDeleteFlag==false)
                    {                        
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Custom Recipient deleted successfully.'));
                    }
                }
            }
            
        }
        catch(DmlException ex)
        {
            system.debug('exception while deleting - '+ex.getMessage());            
        }
        isHideButton = getSurveyDetailsToHideButton();
        system.debug('isHideButton '+isHideButton );
        getSurveyRecipient();
        return null;
    }
    /*  
     * This method gets the recipient who has attempted the survey by giving Feedback.
     *
     * @param  
     * @return List contianing the feedback data
     */ 
    
    public List<feedback__c> getFeedback(List<SurveyRecipient__c> lstSurveyRecipBySId)
    {
        List<feedback__c> lstFeed =new List<feedback__c>();                            
        for(SurveyRecipient__c sR : lstSurveyRecipBySId)
        {
            List<Feedback__c> feed = [select id,SurveyRecipientId__c from feedback__c where SurveyRecipientId__c =: sR.id];
            lstFeed.addAll(feed);
        }
        return lstFeed;
    }
    
    //Wrapper
    public class cSurveyRecipient
    {
        public SurveyRecipient__c sur {get; set;}
        //sendSurvey send; 
        public boolean selected {get; set;}
                
        /*  
         * When we create a new cLead object we pass a Lead that is set to the led property. We also set the selected value to false
         */
        public cSurveyRecipient(SurveyRecipient__c s,boolean b)
        {
            sur = s;
            selected = b;
        }
    }
    /*  
     * This Method retrieve the SurveyRecipient details
     * 
     * @param
     * @return  List contiaing all SurveyRecipient which is binded to table.
     */ 
    public List<cSurveyRecipient> getSurveyRecipient()
    {      
        boolean isChecked; 
        integer index=0;
        boolean isFlag=false;               
        
        List<SurveyRecipient__c> lstSurveyRecipient=new List<SurveyRecipient__c>();
        List<feedback__c> lstFeed;
        
        if(lstFeed==null)
        {
           lstFeed = new List<feedback__c>();
        }
        system.debug('surveyId'+surveyId);            
        lstSurveyRecipient = [select id,surveyId__c,objectId__c,typeOfRecipient__c,email__c from surveyRecipient__c where surveyId__c =:surveyId order by email__c];
        lstFeed = getFeedback(lstSurveyRecipient);
        system.debug('lstSurveyRecipient  '+lstSurveyRecipient );
        system.debug('lstFeed'+lstFeed);
        if(lstSurveyRecipientEmail == null)
        {
            lstSurveyRecipientEmail = new List<cSurveyRecipient>();
        }
        for(SurveyRecipient__c s: lstSurveyRecipient)
        {
                if(lstFeed.size() >0 )
                {
                    for(feedback__c f: lstFeed)
                    {
                        if(s.id == f.surveyRecipientId__c)
                        {                        
                            isChecked=false;
                            break;
                        }
                        else
                        {
                            isChecked=true;
                        }
                    }
                }
                else
                    isChecked=true;
                
                lstSurveyRecipientEmail.add(new cSurveyRecipient(s,isChecked));
        }
        
        return lstSurveyRecipientEmail;
    }
    
    
/* Load Email template which is Active.
* @param:
* @return: List<EmailTemplate__c>  
*/
    public List<EmailTemplate__c> getEmailTemplate()
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
    }
    
        /*This function get's the Recipient and EmailTemplate and fires the emails to them.This function is action for send email link button.
* @param:
* @return: void
*/
    public void sendEmailToRecipient()
    {        
        List<EmailTemplate__c> lstEmailTemplate = getEmailTemplate();
        if(lstSendEmailToRecipient==null)
            lstSendEmailToRecipient=new List<Surveyrecipient__c>();
        lstSendEmailToRecipient=getSurveyRecipients();
        system.debug(lstSendEmailToRecipient);
        if(lstSendEmailToRecipient.size()!=0 && lstSendEmailToRecipient!=null)
        {   
            if(lstEmailTemplate.size()!=0 && lstEmailTemplate!=null)
            {    
                sendEmailToRecipient(lstSendEmailToRecipient,lstEmailTemplate);
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
        }
        else
        {
            system.debug('Recipient Does not exists.Plz add the Recipient!');
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.WARNING,'Recipient Does not exists.Plz add the Recipient!'); 
            ApexPages.addMessage(myMsg);
        }
    }
    
    /*send email method: This method needs to be executed after adding questions and selecting recipients for the survey
* @param: list of recipients and email templates to be sent
* @return: void
*/
    public void sendEmailToRecipient(List<surveyRecipient__c> lstSurveyRecipBySId,List<EmailTemplate__c> lstEmailTemplate)
    {
        List<Messaging.SingleEmailMessage> lstMails = new List<Messaging.SingleEmailMessage>(); //Initate Email object
        for(surveyRecipient__c recipient : lstSurveyRecipBySId)
        {
            // Create a new Email
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); //Initate Email object
            
            // Set list of people who should get the email
            List<String> lstSendTo= new List<String>();
            lstSendTo.add(recipient.email__c);
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
    }
    
    /* Method to get Force.com public domain for recipient form
*  @param: 
*  @return: Generated url for the recipient survey form
*/
    public String generateURL(){
        //Public guest access domain for recipient form
        Site site = [SELECT Subdomain, UrlPathPrefix FROM Site];
        String url = 'https://' + site.Subdomain + '.ap2.force.com/' + site.UrlPathPrefix;
        return url;
    }
    public boolean getSurveyDetailsToHideButton()
    {        
        boolean isHide = true;
        List<survey__c> lstSurvey;
        if(lstSurvey == null)
            lstSurvey = new List<survey__c>();
        lstSurvey=[select id,name,isSent__c from survey__c where id =:surveyId limit 1];
        if(lstSurvey.size()>0)
        {
            if(lstSurvey[0].isSent__c==true)
                isHide=false;
            else
                isHide=true;        
        }
        system.debug('-->lstSurvey'+lstSurvey);
        return isHide;
    }
}