public class ccavnue {
     public String Merchant_Id {get; private set;}  
     public String WorkingKey {get; private set;}  
     public String Redirect_Url{get; private set;}
     public String OrderId{get; private set;} 
     
     public String EncData{get; set;} 
      
      
     public Decimal Amount{get; set;}       
      
     public String delivery_cust_address{get; set;}  
     public String delivery_cust_name{get; set;} 
     public String billing_cust_email{get; set;}  
     public String billing_cust_tel{get; set;}  
     public String billing_cust_country{get; set;} 
     public String billing_cust_address{get; set;}  
     public String billing_cust_name{get; set;}  
     public String billing_cust_state{get; set;} 
     public String billing_cust_city{get; set;}  
     public String delivery_cust_state{get; set;}  
     public String delivery_cust_city{get; set;} 
     public String delivery_cust_tel{get; set;}  
     public String checksum{get; private set;} 
     
     
     public String firstname{get; set;}  
     public String middlename{get; set;}
     public String lastname{get; set;} 


    public Boolean confirm {get; private set;} 
          
     public ccavnue() {
         Merchant_Id = 'M_jumpin_14968';
         WorkingKey  = 'o6mku9lg3a0a0p3cod';
         Redirect_Url = 'https://ap2.salesforce.com/';
         WorkingKey  = 'o6mku9lg3a0a0p3cod';
         confirm = false;
     } 
     
     public void proceed() {
        confirm = true;
       /* String PLAIN_TEXT = 'tid=1234&merchant_id='+Merchant_Id +'&order_id='+OrderId+'&amount='+Amount+'&currency=INR&redirect_url='+Redirect_Url +'&cancel_url='+Redirect_Url+'&language=EN&billing_name=testing&billing_address=testing&billing_city=testing&billing_state=testing&billing_zip=testing&billing_country=testing&billing_tel=testing&billing_email=testing&delivery_name=testing&delivery_address=testing&delivery_city=testing&delivery_state=testing&delivery_zip=12345&delivery_country=testing&delivery_tel=testing&merchant_param1=testing&merchant_param2=testing&merchant_param3=testing&merchant_param4=XXXX&merchant_param5=testing&promo_code=&customer_identifier=&';
        Blob cryptoKey = Blob.valueOf(WorkingKey); 
        Blob hash = Crypto.generateDigest('MD5', cryptoKey );
        Blob data = Blob.valueOf(PLAIN_TEXT);
        Blob encryptedData = Crypto.encryptWithManagedIV('AES128', hash , data);
        String encRequest = EncodingUtil.convertToHex(encryptedData ); */
        
        OrderId = 'Order-20161219-175357';
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
          
        string OrderID = 'Order-20161219-175357';
        
        //string Redirect_Url = 'https://kiran-vidhate-dev-ed--c.ap2.visual.force.com/apex/CCAvenue_Handler';
        string WorkingKey = 'o6mku9lg3a0a0p3cod';
        request.setEndpoint('http://203.193.165.235:1350/Api/Checksum/GetChecksum?Merchant_ID=' + Merchant_Id + '&OrderID=' + OrderId + '&Amount=' + Amount+ '&Redirect_Url=' + Redirect_Url + '&WorkingKey=' + WorkingKey );
        request.setMethod('GET');
        HttpResponse response = http.send(request);
          // If the request is successful, parse the JSON response.
        if (response.getStatusCode() == 200) {
          // Deserialize the JSON string into collections of primitive data types.
          checksum = (String)JSON.deserializeUntyped(response.getBody());
        }
        
     }
     
     public void initAction() {
        
        if ( ApexPages.currentPage().getParameters().get('EncData') != null ) {
           EncData =  ApexPages.currentPage().getParameters().get('EncData');           
        }
        
        
       
        if ( ApexPages.currentPage().getParameters().get('firstname') != null ) {
           firstname=  ApexPages.currentPage().getParameters().get('firstname');           
        }
        
        if(ApexPages.currentPage().getParameters().get('middlename') != null ) {
           middlename=  ApexPages.currentPage().getParameters().get('middlename');
        }
        
        
        if(ApexPages.currentPage().getParameters().get('lastname') != null ) {
           lastname=  ApexPages.currentPage().getParameters().get('lastname');
        }
        
     }
     
     

}