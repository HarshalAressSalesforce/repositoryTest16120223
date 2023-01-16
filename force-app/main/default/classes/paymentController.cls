global class paymentController{   
   public String mer_txn_ref_no{get; set;}  
   public String amount{get; set;}  
   public String access_code{get; set;}  
   public String access_key{get; set;}  
   public String OrderInfo{get; set;}  
   public String cardholder_email{get; set;}  
   public String cardholder_phone{get; set;}
   public String encDataString{get; set;}  
   public Map<String,String> response {get; set;}  
   public  Map<String, String> paymentParameters {get;set;}
   public String encData {get; set;} 
   public String siteResponse{get; set;} 
   public paymentController() {
     //paymentParameters =  ApexPages.currentPage().getParameters().get('EncData');     
     
   }
   
   public void loadPaymentData() {
    
     encData = ApexPages.currentPage().getParameters().get('EncData');
     
     //encData = 'wslV0qZvrp37vjTHFWJBur61TbXjwphuQxoxzFwhuJf3LO/iNVBvnNyNLtJeaXcLBNDr2xQqVcBinyQ7gDhIiFdzUSOsHFu8uaO8D+d3apxQqZF7Zrp4xCouE5iznY/GkJLHFLrrsPueaURBP+sQCwVCRiRZE8m712d6XA6kyxxZsfe5VQchbSaWguLBzDSdwmGY531DFKIl9jk4vZfsAwREqLgKipqsvWBDM50TVGIwvEn9+BnpZ9DnC6tOIBkd+064xURjj5vTrUnvNemF6s19MSz+iDfSqflaWCSrmhexdGUbw+KbGDzwwaDFxlwGVYxdCK7WcuQ12dehfP1LoAx1t27AkrUCY0mSYKBpOTxxxBnQjp97oWz3LsHRL0/CIniJjtcz/XWlXutRAhSujA==';
     Http h = new Http();
     HttpRequest req = new HttpRequest();
     String url = 'http://linux2.aress.net/paymentEncryptor/getDecryptedString.php';
     req.setEndpoint(url );     
     String body = 'EncData='+EncodingUtil.urlEncode(encData , 'UTF-8');
     req.setBody(body);          
     req.setMethod('POST');
     HttpResponse res = h.send(req);
     String decryptedString  = res.getBody();
     siteResponse = decryptedString  ;
     if(decryptedString != '') {
         Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(decryptedString);
         response = new Map<String,String>();
         for(String s:m.keyset()){
           response.put(s,String.valueOf(m.get(s)));        
         }
     }  
   }
   
   
   public void paynow() {
     String PassCode = 'SVPL4257';
     String BankId= '000004';
     String TerminalId= '10100781';
     String MerchantId= '101000000000781';
     String MCC  ='5137';
     String TRCurrency  ='356';
     String TxnType = '02';
     String version = '1';
     
     String  data = 'Amount||'+amount+'::';
     data += 'BankId||'+BankId+'::'; 
     data += 'Currency||'+TRCurrency+'::';  
     data += EncodingUtil.urlEncode('Email||harhsal.kulkarni@aressindia.net::','UTF-8');    
     data += 'MCC||'+MCC  +'::';
     data += 'MerchantId||'+MerchantId+'::'; 
     data += 'OrderInfo||1::';
     data += 'PassCode||'+PassCode +'::';
     data += 'Phone||'+cardholder_phone+'::';
     data += 'ReturnURL||https://harshal-kulkarni-dev-ed.my.salesforce.com/apex/yesBanlPaymentSuccess::';
     data += 'TerminalId||'+TerminalId+'::';  
     data += 'TxnRefNo||'+mer_txn_ref_no+'::';
     data += 'TxnType||Pay::';     
     data += 'Version||1';
    system.debug('37-->'+ data );  
     String hashData = 'E59CD2BF6F4D86B5FB3897A680E0DD3E';
     
     hashData += amount;
     hashData += BankId;
     hashData += TRCurrency;  
     hashData += EncodingUtil.urlEncode('harhsal.kulkarni@aressindia.net','UTF-8');  
     hashData += MCC ; 
     hashData += MerchantId; 
     hashData += '1';    
     hashData += PassCode;
     hashData += cardholder_phone;
     hashData += 'https://harshal-kulkarni-dev-ed.my.salesforce.com/apex/yesBanlPaymentSuccess';
     hashData += TerminalId;
     hashData += mer_txn_ref_no;
     hashData += 'Pay';
     hashData += '1';     
        system.debug('54-->'+ hashData );  
     Blob hash = Crypto.generateDigest('SHA-256', Blob.valueOf(hashData));       
     system.debug('55-->'+ blobToString(hash, 'UTF-8'));
     
     Blob dataToSent = Blob.valueOf('SecureHash||'+EncodingUtil.urlEncode(EncodingUtil.base64Encode(hash), 'UTF-8')+'::'+data);   
     
     system.debug('74-->'+EncodingUtil.urlEncode(EncodingUtil.base64Encode(dataToSent),'UTF-8'));
     
    
     string cryptokey='T7D+IbdKOBfF3zd+LT+cYGDFhQ4YcHU2';
     Blob exampleIv =  Blob.valueOf('ABC123DEF456HIJ7');                
     Blob encData =  Crypto.encrypt('AES256', blob.valueof(cryptokey),exampleIv , dataToSent );  
     
     encDataString = EncodingUtil.urlEncode(EncodingUtil.base64Encode(encData),'UTF-8');  
     system.debug('72-->'+encDataString );
     
     Http h = new Http();
     HttpRequest req = new HttpRequest();
     String url = 'http://linux2.aress.net/paymentEncryptor/getEncryptedString.php';
     req.setEndpoint(url );
     
     String body = 'Amount='+EncodingUtil.urlEncode(amount, 'UTF-8')+'&BankId='+EncodingUtil.urlEncode(BankId, 'UTF-8')+'&Currency='+EncodingUtil.urlEncode(TRCurrency, 'UTF-8')+'&Email='+EncodingUtil.urlEncode('harhsal.kulkarni@aressindia.net', 'UTF-8')+'&MCC='+EncodingUtil.urlEncode(MCC, 'UTF-8')+'&MerchantId='+EncodingUtil.urlEncode(MerchantId, 'UTF-8')+'&OrderInfo='+EncodingUtil.urlEncode('1', 'UTF-8')+'&PassCode='+EncodingUtil.urlEncode(PassCode, 'UTF-8')+'&Phone='+EncodingUtil.urlEncode(cardholder_phone, 'UTF-8')+'&ReturnURL='+EncodingUtil.urlEncode('https://harshal-kulkarni-developer-edition.ap7.force.com/CCAvenueHandler/yesBanlPaymentSuccess', 'UTF-8')+'&TerminalId='+EncodingUtil.urlEncode(TerminalId, 'UTF-8')+'&TxnRefNo='+EncodingUtil.urlEncode(mer_txn_ref_no, 'UTF-8')+'&TxnType='+EncodingUtil.urlEncode('Pay', 'UTF-8')+'&Version='+EncodingUtil.urlEncode('1', 'UTF-8');
     req.setBody(body);
          
     req.setMethod('POST');
     HttpResponse res = h.send(req);
     encDataString  = res.getBody();
     system.debug(encDataString ); 
     
   }
   
   
   public static String blobToString(Blob input, String inCharset){
    String hex = EncodingUtil.convertToHex(input);
    System.assertEquals(0, hex.length() & 1);
    final Integer bytesCount = hex.length() >> 1;
    String[] bytes = new String[bytesCount];
    for(Integer i = 0; i < bytesCount; ++i)
        bytes[i] =  hex.mid(i << 1, 2);
    return EncodingUtil.urlEncode('%' + String.join(bytes, '%'), inCharset);
}
   
   
}