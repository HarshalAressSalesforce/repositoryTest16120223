/*
Class Name: customListOfTemplate
Descriptiop: This class handles all the email template operations
Author: Aress
Version: 38.0 
*/
public class customListOfTemplate{
    public LIST<EmailTemplate__c> email { set; get; }
    public String message { set;get; }
    public boolean currentTemplateStatus {set;get;}
    public String messageColor { set;get; }
    public String idToDelete {set; get;}
    public string selected {set;get;}
    public String searchFilter {get;set;}
    
    
   /*
    * This function deactivates selected link
    * 
    * @return listOfEmailTemplate
    */
    public PageReference  selectedTemplateDeactivate() {
        EmailTemplate__c activeTemp = [SELECT id FROM EmailTemplate__c WHERE id=:selected];
        activeTemp.status__c = false;
        //update activeTemp;
        //List<EmailTemplate__C> falseValueList = [SELECT id,status__C FROM EmailTemplate__c WHERE status__C=null];
        //for(EmailTemplate__C i: falseValueList ){
        // i.status__C = false;
        update activeTemp ;
        PageReference listOfEmailTemplate = Page.listOfEmailTemplate;
        listOfEmailTemplate.setRedirect(true);
        return listOfEmailTemplate;  
    }
    
   /*
    * This function activates selected link
    *
    * @return listOfEmailTemplate
    */
    public pageReference selectTemplate(){
        list<EmailTemplate__c> EmailTemplates = [SELECT id FROM EmailTemplate__c];
        for(EmailTemplate__c EmailTemplate: EmailTemplates ){
            EmailTemplate.status__c = false;
            update EmailTemplate;
        }
        EmailTemplate__c toActiveTemp = [SELECT id FROM EmailTemplate__c WHERE id=:selected];
        toActiveTemp.status__c = true;
        update toActiveTemp ;
        PageReference listOfEmailTemplate = Page.listOfEmailTemplate;
        listOfEmailTemplate.setRedirect(true);
        return listOfEmailTemplate; 
    }
    
   /*
    * Checks for all the active email templates
    *
    * @return null
    */
    public PageReference templateList() {
        //surveySearch();
        searchActiveTemplate();
        return null;
    }
    
   /*
    * Controller to fetch the email templates
    *
    */
    public ApexPages.StandardSetController con {
        get {
            if(con == null) {
                con = new ApexPages.StandardSetController(Database.getQueryLocator([select Id,Title__c,status__c from EmailTemplate__c]));
                con.setPageSize(3); // sets the number of records in each page set
            }
            return con;
        }
        set;
    }  
    
   /*
    * To fetch all list of email templates and to display messages of respective functions
    *
    * @return List<EmailTemplate__c>
    */
    public List<EmailTemplate__c> getTemplates(){
        String msg = Apexpages.currentPage().getParameters().get('m');
        if(msg != null) {
            Integer messageNumber = Integer.valueOf(msg );
            if(messageNumber != null) {
                if (messageNumber == 1) {
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM,'Email template has been succesfully created. '); 
                    ApexPages.addMessage(myMsg);         
                }
                if (messageNumber == 2) {
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM,'Email template has been succesfully updated. '); 
                    ApexPages.addMessage(myMsg);         
                }
                if (messageNumber == 3) {
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM,'Template has been successfully deleted. '); 
                    ApexPages.addMessage(myMsg);         
                }  
            }
        }
        return (List<EmailTemplate__c>)con.getRecords();
    }
    
   /*
    * This function deletes email template list for the logged in user.
    *
    * @return null
    */
    public PageReference deleteTemplate(){
        String message;
        id idToDelete = ApexPages.currentPage().getParameters().get('id');
        if(idToDelete!=null){
            try{
                delete [SELECT Id FROM EmailTemplate__c WHERE Id =: idToDelete];
                PageReference listOfEmail = Page.listOfEmailTemplate;
                 listOfEmail .getParameters().put('m', '3');
                 listOfEmail .setRedirect(true);
                 return listOfEmail ;
            }catch(Exception e){
                System.debug('Error in deletion: '+e);
                message = 'There was a problem in deleting the Template.';
            }
        }
        return null;
    }
    
   /*
    * To search by input characters
    *
    * @return
    */
    public void search() {
        system.debug(searchFilter);
        if(searchFilter != null) {
            string tempInput = '%' + searchFilter + '%';
            con = new ApexPages.StandardSetController(Database.getQueryLocator([select Id,Title__c,status__c from EmailTemplate__c WHERE title__c LIKE :tempInput ]));
            con.setPageSize(surveyConfigs.numberOfRecordPerPage);
        }   
    }
    
   /*
    * This function searches for the active status of the currrent email template
    *
    * @return currentTemplateStatus.id
    */
    public id searchActiveTemplate(){
        emailTemplate__c currentTemplateStatus = [SELECT id FROM emailTemplate__c WHERE status__c = true]; 
        return currentTemplateStatus.id;
    }
    
   /*
    * This function reloads the list of email templates
    *
    * @return listOfEmailTemplate
    */
    public PageReference Reload() {
        PageReference listOfEmailTemplate = Page.listOfEmailTemplate;
        listOfEmailTemplate.setRedirect(true);
        return listOfEmailTemplate; 
    }
}