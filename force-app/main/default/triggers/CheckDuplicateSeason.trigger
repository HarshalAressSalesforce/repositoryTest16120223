/*
Trigger Name: CheckDuplicateSeason 
Description:Trigger for season duration checking.
Author: Aress
Version: 38.0 
*/



trigger CheckDuplicateSeason on Season__c (before insert, after insert,before update) {
    
    if(trigger.isInsert && trigger.isBefore) { 
       seasonManager.checkDuplicate(Trigger.new); // Before insert       
    }
    
    if(trigger.isUpdate && trigger.isBefore) {
       seasonManager.checkDuplicateUpdate(Trigger.new); // Before update
      
    }
}