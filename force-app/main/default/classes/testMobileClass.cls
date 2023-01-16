@isTest (SeeAlldata = true)

/*
Class Name: Test mobile class
Description: Act as testclass for the MobileSalesClass.
Author: Aress
Version: 38.0 
*/

public class testMobileClass {
   /*  
     * Performs the testing of insert functionlity for the case where season is applicable and brand is Samsung
     *
     * @param  
     * @return  
  */ 
  static TestMethod void insertTestClass() {
     Test.startTest();
     ID SeasonId;
     SeasonId =  'a0U28000004ceMQEAY';
        
     Mobile_Sales__c mb = new Mobile_Sales__c();
     mb.Customer_Name__c = 'Testing Apex Class Name';
     mb.Price__c = 100;  
     mb.Brand__c = 'Samsung';
     mb.Season__c = SeasonId;  
     system.debug('Price Before-->'+ mb.Price__c);
     insert mb; 
     Mobile_Sales__c  mobileCompareObject = [SELECT Id, Price__c FROM Mobile_Sales__c WHERE Name = 'Testing Apex Class Name'];
     system.debug('Price After-->'+ mobileCompareObject.Price__c); 
     System.assertEquals(mobileCompareObject.Price__c, 90);  
     Test.stopTest();
  }
  
  /*  
     * Performs the testing of insert functionlity for the case where season is applicable and brand is Apple
     *
     * @param  
     * @return  
  */ 
  static TestMethod void insertTestAppleClass() {
     Test.startTest();
     ID SeasonId;
     SeasonId =  'a0U28000004ceMQEAY';
        
     Mobile_Sales__c mb = new Mobile_Sales__c();
     mb.Customer_Name__c = 'Testing Apex Class Name';
     mb.Price__c = 100;  
     mb.Brand__c = 'Apple';
     mb.Season__c = SeasonId;  
    
     insert mb; 
     Mobile_Sales__c  mobileCompareObject = [SELECT Id, Price__c FROM Mobile_Sales__c WHERE Name = 'Testing Apex Class Name'];
     
     System.assertEquals(mobileCompareObject.Price__c, 80);  
     Test.stopTest();
  }  
  
  /*  
     * Performs the testing of insert functionlity for the case where season is not selected and brand is Samsung
     *
     * @param  
     * @return  
  */
    
  static TestMethod void insertTestwithoutSeasonClass() {
     Test.startTest();
     Mobile_Sales__c mb = new Mobile_Sales__c();
     mb.Customer_Name__c = 'Testing Apex Class Name';
     mb.Price__c = 100;  
     mb.Brand__c = 'Samsung';
     insert mb;
     Mobile_Sales__c  mobileCompareObject = [SELECT Id, Price__c FROM Mobile_Sales__c WHERE Name = 'Testing Apex Class Name'];
     
     System.assertEquals(mobileCompareObject.Price__c, 95); 
     Test.stopTest();
  }   
  
  /*  
     * Performs the testing of insert functionlity for the case where season is not selected and brand is Apple
     *
     * @param  
     * @return  
  */  
  static TestMethod void insertTestApplewithoutSeasonClass() {
     Test.startTest();
     Mobile_Sales__c mb = new Mobile_Sales__c();
     mb.Customer_Name__c = 'Testing Apex Class Name';
     mb.Price__c = 100;  
     mb.Brand__c = 'Apple';
     
     insert mb;
     Mobile_Sales__c  mobileCompareObject = [SELECT Id, Price__c FROM Mobile_Sales__c WHERE Name = 'Testing Apex Class Name'];
      
     System.assertEquals(mobileCompareObject.Price__c, 95); 
     Test.stopTest();
  }   
  
  /*  
     * Performs the testing of insert functionlity for the case where season is selected and but is out of range of selected period of time so no discount will be applicable
     *
     * @param  
     * @return  
  */   
  static TestMethod void insertWithNoDiscountClass() {
     Test.startTest();
     ID SeasonId;
     SeasonId =  'a0U28000004ceMQEAY';
        
     Mobile_Sales__c mb = new Mobile_Sales__c();
     mb.Customer_Name__c = 'Testing Apex Class Name';
     mb.Price__c = 100;  
     
     mb.Season__c = SeasonId;  
    
     insert mb; 
     Mobile_Sales__c  mobileCompareObject = [SELECT Id, Price__c FROM Mobile_Sales__c WHERE Name = 'Testing Apex Class Name'];
     
     System.assertEquals(mobileCompareObject.Price__c, 100);  
     Test.stopTest();
  }       
  
  /*  
     * Performs the testing of update functionlity for the case where season is selected and brand is samsung
     *
     * @param  
     * @return  
  */   
  static TestMethod void updateTestInSeasonClass() {
     Test.startTest();
     Mobile_Sales__c  mobileCompareObject = new Mobile_Sales__c(ID = 'a0V28000003CqV6EAK',Brand__c='Samsung',Price__c=200);  
     
     update mobileCompareObject;
     
     Mobile_Sales__c  mb = new Mobile_Sales__c(ID = 'a0V28000003CqV6EAK');
     System.assertEquals(mb.Price__c, 190);
     Test.stopTest(); 
  } 
    
  /*  
     * Performs the testing of update functionlity for the case where season is selected and brand is apple
     *
     * @param  
     * @return  
  */  
  static TestMethod void updateTestInAppleSeasonClass() {
     Test.startTest();
     Mobile_Sales__c  mobileCompareObject = new Mobile_Sales__c(ID = 'a0V28000003CqVVEA0');  
     
     mobileCompareObject.Brand__c = 'Apple';
     mobileCompareObject.Price__c = 200; 
    
     update mobileCompareObject;
     
     Mobile_Sales__c  mb = new Mobile_Sales__c(ID = 'a0V28000003CqVVEA0');
     System.assertEquals(mb.Price__c, 0);
     Test.stopTest(); 
  }    
  
  /*  
     * Performs the testing of update functionlity for the case where inactive (out of range) season is selected and brand is samsung 
     *
     * @param  
     * @return  
  */   
  static TestMethod void updateTestOutSeasonClass() {
     Test.startTest();
     Mobile_Sales__c  mobileCompareObject = new Mobile_Sales__c(ID = 'a0V28000003CqV6EAK');  
         
     mobileCompareObject.Brand__c = 'Samsung';
     mobileCompareObject.Price__c = 200;     
     update mobileCompareObject;
     
     Mobile_Sales__c  mb = new Mobile_Sales__c(ID = 'a0V28000003CqV6EAK');
     System.assertEquals(mb.Price__c, 200);
     Test.stopTest(); 
  }  
}