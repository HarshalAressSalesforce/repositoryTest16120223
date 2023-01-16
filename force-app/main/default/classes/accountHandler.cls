@RestResource(urlMapping='/MyAccountHandler/*')

global with sharing class accountHandler{
    
    @HttpDelete
    global static void doDelete() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String accountId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        Account account = [SELECT Id FROM Account WHERE Id = :accountId];         
        delete account;
    }
    
    @HttpPatch
    global static String updateAccount() {
       
       try {
            RestRequest req = RestContext.request;
            RestResponse res = RestContext.response;
            Id accountId;
           //Case companyCase = [SELECT Id, Name, Phone, Website,NumberOfEmployees from Account WHERE Id =: accountId];
            Map<String, Object> requestBody = new Map<String, Object>();
            requestBody   = (Map<String, Object>) JSON.deserializeuntyped(req.requestbody.tostring()); 
            Account account = new Account();
            
            for(String key : requestBody.KeySet()) {                 
                 if(requestBody.get(key) != null && requestBody.get(key) != '') {                                           
                     if(key == 'AnnualRevenue') {
                          account.put(key,(Decimal) requestBody.get(key)); 
                     } else {
                        if(key == 'NumberOfEmployees') {
                           account.put(key,Integer.valueOf(requestBody.get(key)));
                        } else {
                           if(key == 'Id') {
                              accountId = (Id) requestBody.get(key);
                              account.put('Id' ,accountId );  
                           } else {
                                account.put(key,requestBody.get(key));
                           }                           
                        }
                     } 
                 }
            }
            
             
            if(accountId  != null) {
            
               List<Account> accountDetails = [SELECT Id from Account WHERE Id =: accountId limit 1];
               if(accountDetails.size() >0 ) {
                  
                   update account;              
               }
            }
            
            //insert account;
            return 'Account Updated';  
                      
        } catch(Exception e) {
            system.debug(e.getMessage());
           
        }
        
         return 'Account not Updated';
         
    }
    
    
    @HttpGet
    global static Account doGet() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String accountId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        
        Account result = [SELECT Id, Name, Phone,Fax,AnnualRevenue, Website,NumberOfEmployees,AccountNumber,Site,BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry,ShippingStreet,ShippingCity,ShippingState,ShippingPostalCode,ShippingCountry FROM Account WHERE Id = :accountId];
        system.debug(result );
        return result;
    }
    
    
    @HttpPost
    global static Account doPost() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        
        List<String> fields = new List<String>{'Name', 'AccountNumber', 'Site','BillingStreet','BillingCity','BillingState','BillingPostalCode',
        'BillingCountry','ShippingStreet','ShippingCity','ShippingState','ShippingPostalCode','ShippingCountry','Phone','Fax','AnnualRevenue','NumberOfEmployees'};
        
          
         
        //try {
            Map<String, Object> requestBody = new Map<String, Object>();
            requestBody   = (Map<String, Object>) JSON.deserializeuntyped(req.requestbody.tostring()); 
            system.debug(requestBody   );
            Account account = new Account();
            for(String key : requestBody.KeySet()) {
                 if(requestBody.get(key) != null && requestBody.get(key) != '') { 
                      if(key == 'AnnualRevenue' || key == 'NumberofLocations__c') {
                          account.put(key,(Decimal)requestBody.get(key)); 
                     } else {
                        if(key == 'NumberOfEmployees') {
                           account.put(key,Integer.valueOf(requestBody.get(key)));
                        } else {
                           system.debug(key);
                           account.put(key,requestBody.get(key)); 
                        }
                     } 
                 }
            }
            
            
            insert account;
            return account;  
                      
        //} catch(Exception e) {
            //system.debug(e.getMessage());
       // }
        return null;
    }


}