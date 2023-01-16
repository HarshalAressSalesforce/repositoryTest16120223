@RestResource(urlMapping='/api/pdf/*')

global with sharing class Fin_StorePdfs{
    @httpPost
    global static map<String,string> StorePdf(){
        RestRequest req = RestContext.request;
        
        record account = (record)JSON.deserialize(req.requestbody.toString(), record.class);
        
        if(account.accounts.size() > 0 && !account.accounts.isEmpty()) {
            for(accountRecord records : account.accounts) {
                    
            }        
        }
        
        /*JSONParser parser = JSON.createParser(req.requestbody.toString());
        String accountNumber;
        account accountObj;
        Object transactionObj;
        while(parser.nextToken() != null) {
             if(parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                parser.nextValue();
                if(parser.getText() == 'accounts') {
                    while(parser.nextToken()!= JSONToken.END_ARRAY) {                        
                        system.debug('15--->'+parser.getText());
                        if(parser.getCurrentToken() == JSONToken.FIELD_NAME) {  
                            parser.nextValue();
                            if(parser.getText() == 'account') {
                                accountObj = (account)parser.readValueAs(account.class);
                                system.debug('17-->'+accountObj);
                            }  
                            
                            if(parser.getText() == 'transactions') {
                                transactionObj = (Object)parser.readValueAs(Object.class);
                                system.debug('17-->'+transactionObj);
                                
                            }                                                  
                        } else if(parser.getCurrentToken() == JSONToken.END_OBJECT) {
                            continue;
                        } else if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                            continue;
                        }
                    }                   
                }
            }
        }*/
        
       
        return Null;
    }
    
    global class record{
        public List<accountRecord> accounts;           
    }
    
    global class accountRecord{
        public account account; 
        public List<transactions> transactions;          
    }
    
    global class account{
        public String id;   
        public String accountNumber; 
        public String name; 
        public String balance; 
        public String type; 
        public String status; 
        public String customerId; 
        public String institutionId; 
        public String createdDate; 
        public String lastUpdatedDate; 
        public String currencySymbol; 
        public String institutionLoginId; 
        public String displayPosition;                   
    }
    
    global class transactions{
        public string id;
        public string amount;
       // public Fin_bankAccount__c account;
        public String accountId; 
        public String customerId; 
        public string status;
        public string description;
        public string memo;
        public string type;
        public string postedDate;
        public string createdDate;
        public  categorization categorization ;
        //public Fin_Transaction_category__c category;        
    }
    
    global class categorization {
        public string normalizedPayeeName;
        public string category;
        public string bestRepresentation;
        public string country;        
    }
    

}