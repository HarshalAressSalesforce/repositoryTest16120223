/*
 * Class Name: EmailListing
 * Description: To select and Add the Recipient for particular survey.
 * Author: Aress
 * Version: 38.0 
 */
 
public class EmailListing
{    
    public List<cLead> lstLeadEmail {get;set;}
    public List<cContact> lstContactEmail {get;set;}
    public List<surveyRecipient__c> lstSurveyRecipBySId {get;set;}
    public List<surveyRecipient__c> lstAllCustomEmail {get;set;}
    public string txtCustomEmail {get;set;}
    public string surveyId {get;set;}
    public List<string> inValidEmail {get;set;}
    public String idToDelete {get;set;}
    public string outputMsg {get;set;}
    
    
    public static final string theLead='lead';
    public static final string theContact='contact';
    public static final string theCustom='custom';
    /*  
     * Load all the information when page loads.
     */
    public EmailListing()
    {        
        loadInfo();
        getLeadEmail();
        getContactEmail();        
        getCustomEmails();        
    }
    
    /*  
     * When the page Load this method executes.
     * This method get the Id to delete the recipient.
     * @param  
     * @return 
     */ 
    public void deleteCustomEmailInit() {
        Id idToDelete = (Id) Apexpages.currentPage().getParameters().get('idToDelete');
        if(idToDelete != null) 
        {
            deleteCustomEmail(idToDelete);
        } 
        
        //display page messages if any
        showMessages();
    }
    
    /* Method to display page messages as per the url flags
     * 
     * @param
     * @return
     */
    public void showMessages(){
        String message = Apexpages.currentPage().getParameters().get('m');
        if( message!= null){
            if(message=='1'){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Recipients has been added succesfully!'));
            }
        }
        
    }
    
    /*  
     * When the page Load this method executes.
     * This method loads all the Recipient who is already selected for that suvey.
     * @param  
     * @return 
     */ 
    public void loadInfo()     {
       try
        { 
            if(ApexPages.currentPage().getParameters().get('surveyId')!=null)
            {
                surveyId =  ApexPages.currentPage().getParameters().get('surveyId');          
                if(surveyId != '' && surveyId != null)
                {
                    if(lstSurveyRecipBySId == null)
                    {
                        lstSurveyRecipBySId = new List<surveyRecipient__c>();
                        lstSurveyRecipBySId = [select Id,name,surveyId__c,objectId__c,typeOfRecipient__c,email__c from surveyRecipient__c where surveyId__c=:surveyId];
                        system.debug(lstSurveyRecipBySId);
                    }
                }
            }
        }
        catch(Exception ex)
        {
            system.debug(''+ ex.getMessage());
        }
    }
            
    /*  
     * This Method retrieve the Leads details
     * And removes the Leads who has selected for the survey.
     * 
     * @param  
     * @return  List contiaing all Leads which is binded to table.
     */ 
    public List<cLead> getLeadEmail()
    {        
        boolean isChecked;
        integer index=0;
        boolean isFlag=false;
        
        List<Lead> lstLead = new List<Lead>();   
        lstLead = [select Id, Name, Email from Lead where Email != null order by Name asc];
        if(lstLeadEmail == null)
        {
            lstLeadEmail = new List<cLead>();
            for(Lead l: lstLead)
            {                
                isChecked=false;
                lstLeadEmail.add(new cLead(l,isChecked));
            }
        }                
        while(index < lstLeadEmail.size())
        {
            for(Integer j=0 ; j<lstSurveyRecipBySId.size() ; j++)
            {
                if(lstLeadEmail[index].led.Id == lstSurveyRecipBySId[j].objectId__c)
                {
                    lstLeadEmail.remove(index);
                    isFlag = true;
                }
            }
            if(isFlag == true)
                index=0;
            else
                index++;
            isFlag=false;
        }
        return lstLeadEmail;
    }
    
    /*  
     * This Method retrieve the Contacts details
     * And removes the Contacts who are selected for the survey.
     * 
     * @param  
     * @return  List contiaing all Contacts which is binded to table.
     */
    public List<cContact> getContactEmail()
    {
        boolean isChecked;
        integer index=0;
        boolean isFlag=false;
        List<Contact> lstContact = new List<Contact>();
        lstContact = [select Id,Name,Email from Contact where Email != null order by Name asc];
        if(lstContactEmail == null)
        {
            lstContactEmail =new List<cContact>();
            for(Contact c : lstContact)
            {
                isChecked=false;
                lstContactEmail.add(new cContact(c,isChecked));
            }
        }
        while(index < lstContactEmail.size())
        {
            for(Integer j=0 ; j<lstSurveyRecipBySId.size() ; j++)
            {
                if(lstContactEmail[index].con.id == lstSurveyRecipBySId[j].objectId__c)
                {
                    lstContactEmail.remove(index);        
                    isFlag = true;
                }
            }
            if(isFlag == true)
                index=0;
            else
                index++;
            isFlag=false;     
        }
        return lstContactEmail;
    }
    
    /*  
     * This method get all the custom Emails with typeOdRecipient='custom'
     * 
     * @param  
     * @return  List contiaing all Custom which is binded to table.
     */
    public List<surveyRecipient__c> getCustomEmails()
    {        
        lstAllCustomEmail =new List<surveyRecipient__c>();
        lstAllCustomEmail =[select Id,surveyId__c,Email__c from surveyRecipient__c where typeOfRecipient__c=:theCustom and Email__c!=null and surveyId__c =:surveyId order by Email__c asc];
        return lstAllCustomEmail;
    }
    
    /*  This is Leads wrapper class
     *  In this example a wrapper class contains both the standard salesforce object Lead and a Boolean value.
     *     
     */ 
    public class cLead
    {
        public Lead led {get; set;}
        public boolean selected {get; set;}
                
        /*  
         * When we create a new cLead object we pass a Lead that is set to the led property. We also set the selected value to false
         */
        public cLead(Lead l,boolean b)
        {
            led = l;
            selected = b;
        }
    }
    /*  This is Contacts wrapper class
     *  In this example a wrapper class contains both the standard salesforce object Contact and a Boolean value.
     *     
     */
    public class cContact
    {
        public Contact con {get;set;}
        public Boolean selected {get; set;} 
        /*  
         * When we create a new cContact object we pass a Contact that is set to the con property. We also set the selected value to false
         */
        public cContact(Contact c,Boolean b)
        {
            con=c;
            selected = b;
        }
    }
    
    /*  
     * This method Adds all selected the Recipient from the list.
     * This method is linked to AddRecipient button.
     * We create a list of Leads/Contacts that will be populated only with Leads/contacts if they are selected.
     * We will cycle through our list of cLeads/cContacts and will check to see if the selected property is set to true,
     * If it is set to true then we add the Lead.Contact to the lstSelectedLeads/lstSelectedContacts list.
     * Adds the custome email by checking the valid email.     
     * @param  
     * @return  null
     */
    public PageReference processSelected()
    {
        List<SurveyRecipient__c> lstAddAllSurveyRecipient = new List<SurveyRecipient__c>();
        try
        {
            List<Lead> lstSelectedLeads;
            List<Contact> lstSelectedContacts;
            if(lstSelectedLeads == null)
                lstSelectedLeads = new List<Lead>();
            if(lstSelectedContacts == null)
               lstSelectedContacts = new List<Contact>();
            
            for(cLead cLed : getLeadEmail())
            {
                if(cLed.selected == true)
                {
                    lstSelectedLeads.add(cLed.led);
                }
            }
            for(cContact cCon : getContactEmail())
            {
                if(cCon.selected == true)
                {
                    lstSelectedContacts.add(cCon.con);
                }
            }
            if(lstSelectedLeads.size() > 0 || lstSelectedContacts.size() > 0 || txtCustomEmail != '')
            {
                if(lstSelectedLeads.size()>0)
                {
                    System.debug('These are the selected Leads...');
                    for(Lead led: lstSelectedLeads)
                    {
                        system.debug(led);
                    }
                    for(Lead led : lstSelectedLeads)
                    {
                        SurveyRecipient__c recipient = new SurveyRecipient__c();
                        recipient.surveyId__c = surveyId;
                        recipient.objectId__c = led.Id;
                        recipient.typeOfRecipient__c = theLead;
                        recipient.email__c = led.Email;
                        lstAddAllSurveyRecipient.add(recipient);
                    }
                }
                if(lstSelectedContacts.size() > 0)
                {
                    System.debug('These are the selected Contacts...');
                    for(Contact con: lstSelectedContacts) 
                    {
                        system.debug(con);
                    }
                }
                for(Contact con : lstSelectedContacts)
                {
                    SurveyRecipient__c recipient= new SurveyRecipient__c();
                    recipient.surveyId__c = surveyId;
                    recipient.objectId__c = con.Id;
                    recipient.typeOfRecipient__c = theContact;
                    recipient.email__c = con.Email;
                    lstAddAllSurveyRecipient.add(recipient);
                }
                if(txtCustomEmail != '')
                {
                    List<string> lstSplitEmail=txtCustomEmail.split('\\,');
                    if(lstSplitEmail.size() > 0 && lstSplitEmail != null)
                    {
                        for(string listCustomEmail :lstSplitEmail)
                        {
                            if(validateEmail(listCustomEmail.trim()))
                            {
                                 SurveyRecipient__c recipient= new SurveyRecipient__c();
                                 recipient.surveyId__c = surveyId;                                 
                                 recipient.objectId__c = null;
                                 recipient.typeOfRecipient__c = theCustom;
                                 recipient.email__c = listCustomEmail.trim();
                                 lstAddAllSurveyRecipient.add(recipient);
                            }
                            else
                            {
                                inValidEmail=new List<string>();
                                inValidEmail.add(listCustomEmail);
                                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Invalid EmailId : '+inValidEmail));
                            }
                        }
                    }
                }
                List<Database.SaveResult> srList = Database.insert(lstAddAllSurveyRecipient, false);
                for (Database.SaveResult sr : srList)
                {
                    if (sr.isSuccess())
                    {                        
                        lstAddAllSurveyRecipient.clear();
                        lstSelectedLeads.clear();                                          
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Recipients Inserted Successfully..!'));
                        //outputMsg ='Recipients Inserted Successfully..!'; 
                        //PageReference redirectPage = Page.surveyList;
                        //redirectPage .getParameters().put('m', '1');
                        //redirectPage.setRedirect(true);
                        //return redirectPage; 
                        Pagereference ref = new Pagereference('/apex/SBRecipient');
                        ref.getParameters().put('surveyId',surveyId);
                        ref.getParameters().put('m','1');
                        ref.setRedirect(true);
                        return ref;
                    }
                    else
                    {
                        for(Database.Error err : sr.getErrors()) 
                        {
                            System.debug('The following error has occurred.');                    
                            System.debug(err.getStatusCode() + ': ' + err.getMessage());
                            System.debug('Contact fields that affected this error: ' + err.getFields());
                        }
                    }
                }
            }
            else
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please select the Recipient !'));
            }
        }
        catch(exception ex)
        {
            system.debug('Exception - '+ex);
        }
        return null;
    }    
    
    /*  
     * Cancel Action
     *
     * @param  
     * @return PageReference to redirect. 
     */ 
    public pageReference CancelAction()
    {
        PageReference pR=new PageReference('/apex/surveyList');
        pR.setRedirect(true);
        return pR;
    }
        
    /*  
     * This method deletes the Custom Emails from the Custome emails Listing.
     *
     * @param  
     * @return null
    */ 
    public Pagereference deleteCustomEmail(Id idToDelete)
    {
        boolean isDeleteFlag=true;
        system.debug('iddddd- '+idToDelete);
        try
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
                     outputMsg = 'Sorry! Recipient has attempted the feedback';
                     ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Sorry! Recipient has attempted the feedback'));
                 }
                 else if(isDeleteFlag==false)
                 {
                     outputMsg = 'Custom Recipient deleted successfully.';
                     ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Custom Recipient deleted successfully.'));
                 }
             }
        }
        catch(DmlException ex)
        {
            system.debug(ex.getMessage());
            outputMsg = 'There was a problem in deleting the Email.';
        }        
        getCustomEmails(); 
        return null;
    } 
     
    /*  
     * Email validation method for custom email.
     *
     * @param  
     * @return boolean true/fasle.
     */     
    public static Boolean validateEmail(String email) 
    {
        boolean res = true;
        string emailRegex = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$'; // source: <a href="http://www.regular-expressions.info/email.html" target="_blank" rel="nofollow">http://www.regular-expressions.info/email.html</a>
        Pattern MyPattern = Pattern.compile(emailRegex);
        Matcher MyMatcher = MyPattern.matcher(email); 
        if (!MyMatcher.matches())
        {
            res = false;
        }
        return res;
    } 
    /*  
     * This method executes for specific time interval.
     *
     * @param  
     * @return null
    */ 
    public PageReference timeInterval()
    {    
        //seconds++;
        return null;
    }   
    
    public PageReference gotoSendSurvey() {
      if(lstSurveyRecipBySId.size()>0) {
            List<Survey__c> surveyDetails = [SELECT Id, currentState__c FROM Survey__c WHERE Id =: surveyId ];
            if(surveyDetails.size() > 0) {
                 Survey__c surveyData = surveyDetails[0];
                 surveyData.currentState__c++;
                 update surveyData ;
            }
            PageReference redirectPage = Page.sendSurvey;
            redirectPage.getParameters().put('surveyId',surveyId);
            redirectPage.setRedirect(true);
            return redirectPage; 
       } else {
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please add recipient for the survey'));
       }  
       return null; 
    
    }  
}