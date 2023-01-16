public class docusignApiHandler {
   
  
   
   public docusignApiHandler () {
      
      
      
   }
   
   public static String getEncodedString(String Str) {
       String encoded = EncodingUtil.base64Encode(Blob.valueOf(Str));
       String replaced = encoded.replace('+/','-_');
       return replaced.replace('=','');
   }
   
   public static void check() {
       docuSignSoapApi.APIServiceSoap dsApiStatus = new docuSignSoapApi.APIServiceSoap(); 
       //Setting docusign authorization. 
       dsApiStatus.inputHttpHeaders_x = new Map<String, String>(); 
       dsApiStatus.inputHttpHeaders_x.put('X-DocuSign-Authentication',  
                    '<DocuSignCredentials><Username>63877c17-94c9-41ff-bf74-5c545c59363b</Username><Password>Aress123</Password><IntegratorKey>de0c1a28-8a53-4047-8f90-76139d38b2aa</IntegratorKey></DocuSignCredentials>'); 
       system.debug(dsApiStatus.RequestStatus('318a6ef8-9c85-401e-a45d-099745ed3d75'));  
       
       system.debug(dsApiStatus.RequestTemplates('4c52eb5b-4ee2-48f1-9b4c-f74c662a6d4c',true));           
   }
   
   public static void getLogin() {
       
    
     
      /*url += '/oauth/auth?';
      url += 'response_type=token';
      url += '&scope=signature';
      url += '&client_id='+integrator_key;
      url += '&state=myCustomState';
      url += '&redirect_uri=https://harshal-kulkarni-dev-ed.my.salesforce.com';   
      
      url += '/oauth/auth?';
      url += 'response_type=code';
      url += '&scope=signature%20impersonation';
      url += '&client_id='+integrator_key;
      url += '&redirect_uri=https://harshal-kulkarni-dev-ed.my.salesforce.com';  
      
      system.debug(url);
      
      Http http = new Http();
      HttpRequest request = new HttpRequest();
      request.setEndpoint(url );
      request.setMethod('GET');
      HttpResponse response = http.send(request);
      system.debug(response );*/
       
      String url = 'https://account-d.docusign.com/oauth/token';       
      String integrator_key= 'de0c1a28-8a53-4047-8f90-76139d38b2aa'; 
      String api_username= '63877c17-94c9-41ff-bf74-5c545c59363b'; 
      
       
       
      Map<String,String> header = new Map<String,String>();
      header.put('type','JWT');
      header.put('alg','RSA');
       
      String headerJSON = JSON.serialize(header );
      
      
      //String encoded = EncodingUtil.urlEncode(headerJSON, 'UTF-8');
       
      //Blob headerBlob = Blob.valueOf(encoded);
       
      //String JWTHeader = String.valueOf(EncodingUtil.base64Encode(headerBlob));
      
      String JWTHeader = docusignApiHandler.getEncodedString(headerJSON );
      system.debug(JWTHeader);
       
       
      long currentTime = DateTime.now().getTime();
       
      Map<String,String> body = new Map<String,String>();
      body.put('iss',integrator_key);
      body.put('sub',api_username);
      body.put('iat',String.valueOf(currentTime));
      body.put('exp',String.valueOf(currentTime+60000));
      body.put('aud','account-d.docusign.com');
      body.put('scope','signature impersonation');
       
             
      //String JWTBody = EncodingUtil.base64Encode(Blob.valueOf(EncodingUtil.urlEncode(JSON.serialize(body), 'UTF-8')));
      String JWTBody = docusignApiHandler.getEncodedString(JSON.serialize(body));
      system.debug(JWTBody );
      
      AressH__docConfigs__mdt  settings = [select AressH__privateKey__c from AressH__docConfigs__mdt where MasterLabel ='privateKey'];
              
      String privateKey = settings.AressH__privateKey__c; 
      
      
      //String privateKey = 'MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDYfpdY1j0WbdTIXb++rJ6OCV7Dhmwp/5BTY5R06Bh0EVq0Nx1HMR27fKhRPCZF6G8WZsp3HM7hF1O8JhImdQu7IwIXpSwOCFBGnyJLW8mR7/OMATXjCwFcXfvplFuwQpe3+Zl39Nak7jw1Zz6NMWAhZfl6DEmEZDRvIQc7lafkVP/HoOocFvHSkVC5H8eEzQVs2SY617/vOBB5F1Dig9h2SzJk+QoTjxOfpJbShiKU5nRLprSvzBGNmB53jAcmtIpIaIXAWRt5ZV1BSEq0SN4VCGFAOBGddptg1Lxdj35QxtemVQKDEyFrFL7w75GEM6OboAY9CItGJz+eZjhSsbxNAgMBAAECggEAAVMc9/UvoICBicxRDQifW70g8E9VQBiJOIlmciStaaBljq67piDdzrTfjsewcEMQ0vFEEeCCP4xV/dO5zrRuovF+5Mgk8d0JKLV2j0F7hUITmmqzerUph/gnP3Gh8f0mUoDbeIlt+speYfFEx7ZioTGvihijJoU6cOeh1LKAuXvsxYuZPTdk7ypzrDpTwEvGBNnkxOWcRKRhnfCC+ALiKCeu33QnLl0hz7Z86nGHqvc4N5OL9XFJVmdipsYu1S4ObZ33WHzjm7OezIPRtQOXevuIiC++6GFmCt8Nyr4P+97mfJuKKbuV9gDDNMukDvnBdHCsK5WhRCVLxmpr6l4eAQKBgQD7vnwBQAAX0hIUQY8rhZeFvpoSqXb/x0fhLpOrKYK1sp+IZU6wj2pZnvWDI+qYZmP5cvn7K46oP7SzafU+73SNaNuyYXLfZ41A4kaqwPLtCSH0+SVjxluuhOqbz7xt9fvNTjG+3rvDhh0qwNhFrvfaVeN6YKOf5IRI+Vh53RcSgQKBgQDcJ40baWkcCdObyzIjlEK0RPct4Ew3YFdw14T7kstnDI0Au/piH7bPK0QP5TnK+4Jc+L7lksRBSFHTpkX0rCYQO93tQWIGEQ9VGk10AdQHqZO9iKa6hxvumhjyFJ7jtYU55nwmGffNPT5O4k2nXpvpEU5Z5rx544MYBpqerHxrzQKBgGpbR7ifeWqW7dxw9jPE9QckR6OqxQO7Bbs1Gl4t43MwTAYsBtrBPIUwizkka3CHkaVJ1iMve83JXGaQVXSJZgx4SJlMYmPQM/U9o+1wJzHNsfL1b75/hyxsK1I4qbsrOX67kni5UUqB1sDBSJ3oFf7AWqLRQU/EE79g2OhjZ+QBAoGAMfEa9pP0DzM/eMEgr6eLdj+K3zJZt9o4G9YYScWkNM1JE1iRVT8ihl6nQv/aG2zwxsx66bNgp/qS7XNzvSxsOhSKpK7HYN7v3ntoBKABjHdwl3dvczMBKCB29jutS7S680aQ9UfAyiNRhi2aNhSlQ7r0TjqkmPX+oC2nV8WDOCUCgYEAjdLEFUX86tdRcGYpea8pIQBM/XGple9+LaNF9a8n46F6PVpMrBdkWhqtmcgAs1Oq35QF+PnQkVv1DMr8aRMmEIqQamO/FeOfyMl38ziTwEGPbkfKzevNt+yOpZJU2w80gMgX5ukypYlE89e9hrCH80biDpHx/8Hrk1Mue9RBzeM=';    
      
      
      system.debug(privateKey);   
      
      
          
      //String signature = EncodingUtil.base64Encode(Crypto.generateMac('hmacSHA256',Blob.valueOf(JWTHeader+'.'+JWTBody),Blob.valueOf(privateKey)));
      String signature = EncodingUtil.base64Encode(Crypto.sign('RSA-SHA256',Blob.valueOf(JWTHeader+'.'+JWTBody),EncodingUtil.base64Decode(privateKey)));
      
       //String signature = EncodingUtil.base64Encode(Crypto.generateMac('hmacSHA256',Blob.valueOf(JWTHeader+'.'+JWTBody),Blob.valueOf(privateKey)));
       
      system.debug(signature);
       
       
      Http http = new Http();
      HttpRequest request = new HttpRequest();
      request.setEndpoint(url);
      request.setHeader('Content-Type','application/x-www-form-urlencoded');
      request.setMethod('POST');
            
      request.setBody('grant_type='+EncodingUtil.urlEncode('urn:ietf:params:oauth:grant-type:jwt-bearer','UTF-8')+'&assertion='+EncodingUtil.urlEncode(signature,'UTF-8')) ;
      
      /*Map<String,String> inputs = new Map<String,String>();
      inputs.put('grant_type','urn:ietf:params:oauth:grant-type:jwt-bearer');
      inputs.put('assertion',String.valueOf(signature));      
      request.setBody(JSON.serialize(inputs)); */
      
      HttpResponse response = http.send(request);
      system.debug(response);
        
       
       
   }
   
   
   public static void getFormdata() {
        String accountID = '63877c17-94c9-41ff-bf74-5c545c59363b'; 
        String userName = '4c52eb5b-4ee2-48f1-9b4c-f74c662a6d4c'; 
        String passWord = 'Aress123'; 
        String integratorKey = 'de0c1a28-8a53-4047-8f90-76139d38b2aa'; 
        String powerformId = 'f9e42a75-2b7b-40e9-bf20-02d26f85bda5';
        String endPoint = 'https://account-d.docusign.com/restapi/v2/accounts/'+accountID+'/powerforms/'+powerformId+'/form_data';
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endPoint); 
        request.setMethod('POST'); 
   
        String authorizationHeader = '<DocuSignCredentials><Username>'+userName+'</Username><Password>'+Password+'</Password><IntegratorKey>'+integratorKey+'</IntegratorKey></DocuSignCredentials>'; 

        request.setHeader('X-DocuSign-Authentication', authorizationHeader); 
        request.setHeader('Accept','application/json'); 
        request.setHeader('Content-Length','162100'); 
        request.setHeader('Content-Type','application/json'); 
        request.setHeader('Content-Disposition','form-data'); 
        request.setTimeout(60000);
        Http http = new Http(); 
        HTTPResponse res = http.send(request); 
        system.debug(res );
        
    }
    
}