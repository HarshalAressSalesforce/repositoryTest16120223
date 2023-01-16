/*
Class Name: MobileSalesClass
Description: Act as heler class for for the triggerHandleMobileSale trigger.
Author: Aress
Version: 38.0 
*/

public class MobileSalesClass {  
    
    /*  
     * Performs the insert functionlity for the trigger (before insert)
     *
     * @param  sObject Mobile_Sales__c
     * @return  
   */ 
    
    public static void processInsertDiscount(Mobile_Sales__c[] mobiles) {
        Integer Discount = 0;
        ID seasonId;
        
        // Iterates the mobiles array
        for (Mobile_Sales__c mobile : mobiles) {
            // If season is selected    
            if(mobile.Season__c != NULL) {             
                seasonId = (ID) mobile.Season__c; 
                Season__c seasonRecord = [select Id, From_Date__c,To_Date__c from Season__c where Id =: mobile.Season__c ];
                if(seasonRecord != NULL) {   
                     if(date.today() <= seasonRecord.From_Date__c && seasonRecord.To_Date__c >= date.today() ) {
                          if(mobile.Brand__c == 'Apple') { // Apply discount of 20% for Apple brand
                              Discount = 20;                  
                           }
                           
                            if(mobile.Brand__c == 'Samsung') { // Apply discount of 10% for Samsung brand
                                Discount = 10;                  
                            }
                 	}   
                }  
            } else {  // If season is not selected    
                if(mobile.Brand__c == 'Apple') { // Apply discount of 15% for Apple brand
                    Discount = 15;                  
                }
                
                if(mobile.Brand__c == 'Samsung') { // Apply discount of 5% for Samsung brand
                    Discount = 5;               
                } 
            } 
            
            // Apply discount of on the mobile sale price
            if(Discount >0) {
                mobile.Price__c= mobile.Price__c - (mobile.Price__c * Discount)/100;
                mobile.Discount_Status__c = 'Congrates! you got '+Discount+'% Discount';
            } else { // Do not apply discount of on the mobile sale price
                mobile.Discount_Status__c = 'Sorry, you have not any discount.';
            }   
        } 
    }
      
      
    /*  
     * Performs the update functionlity for the trigger (before update)
     *
     * @param  sObject Mobile_Sales__c
     * @return  
   */   
    public static void processUpdateDiscount(Mobile_Sales__c[] mobiles) {
         
         Integer Discount = 0;
         Id seasonId ;
         
         // Iterates the mobiles array
         for (Mobile_Sales__c mobile : mobiles) {             
             // If season is selected
             if(mobile.Season__c != NULL) {
               seasonId =  (ID) mobile.Season__c;                
               Season__c season = [select Name, From_Date__c from Season__c where Id =: mobile.Season__c ];
                  
               if(season != NULL) {
                     if(season.From_Date__c > date.today()) {
                         if(mobile.Brand__c == 'Samsung') { // Apply discount of 5% for Samsung brand
                                Discount = 5;                  
                         }  
                     }
               } 
           } 
           
           // Apply discount of on the mobile sale price
           if(Discount >0) {
                mobile.Price__c= mobile.Price__c - (mobile.Price__c * Discount)/100;
                mobile.Discount_Status__c = 'Congrates! you got '+Discount+'% Discount';
           } else { // Do not apply discount of on the mobile sale price
                mobile.Discount_Status__c = 'Sorry, you have not any discount.';
           }                                 
         }  
      }
}