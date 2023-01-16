/*
Class Name: seasonManager
Description: Act as heler class for for the CheckDuplicateSeason trigger.
Author: Aress
Version: 38.0 
*/



public class seasonManager {  
    /*  
     * Performs the insert functionlity for the trigger (before insert)
     *
     * @param  sObject Season__c 
     * @return  
    */ 
       
    public static void checkDuplicate(Season__c[] seasons) {
         for(Season__c season: seasons) {
               for(List<Season__c> seasonRecord: [select Id from Season__c where  From_Date__c =: season.From_Date__c and To_Date__c =: season.To_Date__c ]) {
                     for(Season__c  sason: seasonRecord) {                        
                        season.Name.addError('Season is already exists for the provided duration.');
                     }
                }                     
           } 
    }
      
      
    /*  
     * Performs the update functionlity for the trigger (before update)
     *
     * @param  sObject Season__c 
     * @return  
    */   
    public static void checkDuplicateUpdate(Season__c[] seasons) {
         for(Season__c season: seasons) {
               if(season.Id != NULL) {
                   for(List<Season__c> seasonRecord: [select Id from Season__c where Id !=:season.Id and  From_Date__c =: season.From_Date__c and To_Date__c =: season.To_Date__c ]) {
                     for(Season__c  sason: seasonRecord) {                        
                        season.Name.addError('Season is already exists for the provided duration.');
                     }
                   } 
               }                                   
           } 
      }
}