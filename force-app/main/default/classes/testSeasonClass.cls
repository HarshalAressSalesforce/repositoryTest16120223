@isTest

/*
Class Name: Test SeasonManager class
Description: Act as testclass for the SeasonManager.
Author: Aress
Version: 38.0 
*/
public class testSeasonClass {
   /*  
     * Performs the testing of insert functionlity  
     *
     * @param  
     * @return  
  */ 
  static TestMethod void insertSeason() {
     Test.startTest();       
     Season__c season = new Season__c();
     season.Name = 'Case1';     
     Date fromDate = date.newinstance(2016, 11, 1);
     Date toDate = date.newinstance(2016, 11, 30);       
     season.From_Date__c = fromDate;
     season.To_Date__c = toDate;       
     insert season;  
     Test.stopTest();
  }
    
  /*  
     * Performs the testing of update functionlity  
     *
     * @param  
     * @return  
  */   
  static TestMethod void updateSeason() {
     Test.startTest();       
     Season__c season = new Season__c(Id='a0U28000004ceMQEAY');
     season.Name = 'Case1';     
     Date fromDate = date.newinstance(2016, 11, 1);
     Date toDate = date.newinstance(2016, 11, 29);       
     season.From_Date__c = fromDate;
     season.To_Date__c = toDate;       
     update season;  
     Test.stopTest();
  }  
    
    
}