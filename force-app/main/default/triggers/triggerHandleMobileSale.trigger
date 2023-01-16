/*
Trigger Name: triggerHandleMobileSale 
Description:Trigger for mobiole sale duration checking.
Author: Aress
Version: 38.0 
*/


trigger triggerHandleMobileSale on Mobile_Sales__c (before insert,before update) {
  
  
    if(trigger.isInsert && trigger.isBefore) {      
       MobileSalesClass.processInsertDiscount(Trigger.new);  // Before insert     
      
    }
    
    if(trigger.isUpdate && trigger.isBefore) {
       
         MobileSalesClass.processUpdateDiscount(Trigger.new); // Before update
      
    }
}