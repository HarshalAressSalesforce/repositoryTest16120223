public with sharing class MyFirstApexClass {
    public MyFirstApexClass() {            
    }

    public static List<Account> getAllActiveAccounts() {
        return [SELECT Id,Name FROM Account ];
    } 
    
    
     
    
}