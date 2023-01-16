public with sharing class myVisualTestClass {
    public myVisualTestClass() {

    }
    
     public static List<Account> getAllActiveAccounts() {
    return [SELECT Id,Name,Active__c FROM Account WHERE Active__c = 'Yes'];
  }
}