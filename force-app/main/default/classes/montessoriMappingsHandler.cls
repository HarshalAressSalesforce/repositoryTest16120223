@RestResource(urlMapping='/montessoriMappings/*')

global with sharing class montessoriMappingsHandler{
    
    @HttpPost
    global static Account doPost() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        Map<String, Object> requestBody = new Map<String, Object>();
        requestBody   = (Map<String, Object>) JSON.deserializeuntyped(req.requestbody.tostring()); 
        
        
        
        List<Account> AccountDetails = new List<Account>();
        Account account = new Account();
        
        for(String key : requestBody.KeySet()) {
             if(requestBody.get(key) != null && requestBody.get(key) != '') {  
                 if(key == 'msa_id__c') {
                     String msa_id = String.valueOf(requestBody.get(key));
                     
                     if(msa_id != null)  {
                       AccountDetails = [SELECT Id FROM Account WHERE msa_id__c = :msa_id];                      
                     }
                 }                 
                 account.put(key,String.valueOf(requestBody.get(key))); 
             }
        }
               
        if(AccountDetails.size()>0) {
           account.put('id',AccountDetails[0].Id); 
           update account; 
        } else {
           insert account;
        }
        
        return account;  
    }
}