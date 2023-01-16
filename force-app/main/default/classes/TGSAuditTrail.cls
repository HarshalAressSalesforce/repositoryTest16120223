@RestResource(urlMapping='/manageAuditTrial/*')
global with sharing class TGSAuditTrail {
	@HttpPost
    global static void  createAudtiTrial(){  
        RestRequest req = RestContext.request;
        String input = req.requestBody.toString();
        system.debug(input);
        
        map<string,object> restMap = (map<string,object>)JSON.deserializeUntyped(req.requestBody.toString());
        String transactionId;
        
        if(restMap.get('TransactionId') != null) {
            transactionId = String.valueOf(restMap.get('TransactionId'));
            system.debug(transactionId);
            Map<String, Object> details;
            if(restMap.get('Documents') != null) {
                for(Object instance : (List<Object>)restMap.get('Documents'))  { 
                    details = (Map<String, Object>)instance;
                    if(details.get('Url') != null) {
                         system.debug(String.valueOf(details.get('Url')));                          
                    }
                    
                    if(details.get('Id') != null) {                        
                         system.debug(String.valueOf(details.get('Id')));
                    }
                }                    
            }
            
            if(restMap.get('AuditLog') != null) {
                for(Object instance : (List<Object>)restMap.get('AuditLog'))  { 
                    details = (Map<String, Object>)instance;
                    if(details.get('Status') != null) {
                         system.debug(String.valueOf(details.get('Status')));                          
                    }
                    
                    if(details.get('IPAddress') != null) {                        
                         system.debug(String.valueOf(details.get('IPAddress')));
                    }
                    
                    if(details.get('CreatedOn') != null) {
                         system.debug(String.valueOf(details.get('CreatedOn')));                          
                    } 
                }                    
            }
        }
    }
}