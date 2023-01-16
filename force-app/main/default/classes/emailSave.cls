/*
Class Name: emailSave
Descriptiop: This class handles all the email template operations
Author: Aress
Version: 38.0 
*/

public class emailSave {
    public string nameInsert{set;get;}
    public string descriptionInsert{get;set;}
    public string nameUpdate{set;get;}
    public string descriptionUpdate{get;set;}
    public string idToUpdate{set;get;}
    public string message{set;get;}
    public string inputTextErrorMessage{set;get;}

   /*
    * This function inserts new email template for the current logged in user
    *
    * @return listOfEmail
    */
    public PageReference emailInsert(){
        EmailTemplate__c email = new EmailTemplate__c(Title__c=nameInsert,Description__c=descriptionInsert);
         insert email;

         PageReference listOfEmail = Page.listOfEmailTemplate;
         listOfEmail.getParameters().put('m', '1');
         listOfEmail.setRedirect(true);
         return listOfEmail ;
    }

   /*
    * This function updates the email template for the current logged in user
    *
    * @return listOfEmail
    */
    public PageReference emailUpdate(){
        String idToUpdate = ApexPages.currentPage().getParameters().get('id');
        EmailTemplate__c EmailUpdate = [SELECT Title__c,description__c FROM EmailTemplate__c WHERE id=: idToUpdate];
        EmailUpdate.Title__c = nameUpdate;
        EmailUpdate.description__c = descriptionUpdate;
        update EmailUpdate;

        PageReference listOfEmail = Page.listOfEmailTemplate;
        listOfEmail.getParameters().put('m', '2');
        listOfEmail.setRedirect(true);
        return listOfEmail ;
    }

   /*
    * This function loads all the email templates for the current logged in user
    *
    */
    public void loadEmail(){
        String idToUpdate = ApexPages.currentPage().getParameters().get('id');
        String message;
        EmailTemplate__c EmailLoad = [SELECT Title__c,description__c FROM EmailTemplate__c WHERE id= :idToUpdate];
        nameUpdate = EmailLoad .Title__c;
        descriptionUpdate = EmailLoad .Description__c;
    }
}