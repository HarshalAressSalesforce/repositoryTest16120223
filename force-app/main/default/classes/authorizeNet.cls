public class authorizeNet {
    public static String dataValue{get;set;}
    public static String dataDescriptor{get;set;}
    
    public static void createTransaction() {
       system.debug('6--->'+dataDescriptor);
       system.debug('7--->'+dataValue);
       Http h = new Http();
       HttpRequest req = new HttpRequest();
       req.setEndpoint('https://apitest.authorize.net/xml/v1/request.api');
       req.setMethod('POST');
       req.setHeader('Content-Type', 'application/json');
        
       String body = '{"createTransactionRequest": {';
       body += '"merchantAuthentication": {"name": "37B486ZCGrav","transactionKey": "5vWNx3E6Q39wGd9H"},';
       body += '"refId": "123456",';
       body += '"transactionRequest": {';
       body += '"transactionType": "authCaptureTransaction",';
       body += '"amount": "5",';
       body += '"payment":{ "opaqueData": {"dataDescriptor": "'+dataDescriptor+'","dataValue": "'+dataValue+'"}},';
       body += '"lineItems": [';
       body += '{"lineItem": {"itemId": "1","name": "vase","description": "Cannes logo", "quantity": "18", "unitPrice": "45.00"}}';
       body += '],';
       body += '"tax": {"amount": "4.26","name": "level2 tax name","description": "level2 tax"},';
       body += '"duty": {"amount": "8.55","name": "duty name","description": "duty description"},';
       body += '"shipping": {"amount": "4.26","name": "level2 tax name","description": "level2 tax"},';
       body += '"poNumber": "456654",';
       body += '"customer": {"id": "99999456654"},';
       body += '"billTo": {"firstName": "Ellen","lastName": "Johnson","company": "Souveniropolis","address": "14 Main Street","city": "Pecan Springs","state": "TX","zip": "44628","country": "US"},';
       body += '"shipTo": {"firstName": "China","lastName": "Bayles","company": "Thyme for Tea","address": "12 Main Street","city": "Pecan Springs","state": "TX","zip": "44628","country": "US"},';
       body += '"customerIP": "192.168.1.1",';
       body += '"transactionSettings": {"setting": {"settingName": "testRequest","settingValue": "false"}},';
       body += '"userFields": {"userField": [{"name": "MerchantDefinedFieldName1","value": "MerchantDefinedFieldValue1"},{"name": "favorite_color","value": "blue"}]},';
       body += '"processingOptions": {"isSubsequentAuth": "true"},';
       body += '"subsequentAuthInformation": {"originalNetworkTransId": "123456789NNNH","originalAuthAmount": "45.00","reason": "resubmission"},';
       body += ' "authorizationIndicatorType": {"authorizationIndicator": "final"}';
       body += '}';
       body += '}';
       body += '}';   
       req.setBody(body );
        system.debug('40--->'+body);
       HttpResponse res = h.send(req); 
       
       system.debug(res.getBody());
        
        
        
    }
    
    public static void makePayment() {
       Http h = new Http();
       HttpRequest req = new HttpRequest();
       req.setEndpoint('https://apitest.authorize.net/xml/v1/request.api');
       req.setMethod('POST');
       req.setHeader('Content-Type', 'application/json');
       String body = '{"createTransactionRequest": {';
       body += '"merchantAuthentication": {"name": "37B486ZCGrav","transactionKey": "5vWNx3E6Q39wGd9H"},';
       body += '"refId": "123456",';
       body += '"transactionRequest": {';
       body += '"transactionType": "authCaptureTransaction",';
       body += '"amount": "5",';
       body += '"payment": {"creditCard": {"cardNumber": "5424000000000015","expirationDate": "2025-12","cardCode": "999"}},';
       body += '"lineItems": [';
        body += '{"lineItem": {"itemId": "1","name": "vase","description": "Cannes logo", "quantity": "18", "unitPrice": "45.00"}}';
       body += '],';
       body += '"tax": {"amount": "4.26","name": "level2 tax name","description": "level2 tax"},';
       body += '"duty": {"amount": "8.55","name": "duty name","description": "duty description"},';
       body += '"shipping": {"amount": "4.26","name": "level2 tax name","description": "level2 tax"},';
       body += '"poNumber": "456654",';
       body += '"customer": {"id": "99999456654"},';
       body += '"billTo": {"firstName": "Ellen","lastName": "Johnson","company": "Souveniropolis","address": "14 Main Street","city": "Pecan Springs","state": "TX","zip": "44628","country": "US"},';
       body += '"shipTo": {"firstName": "China","lastName": "Bayles","company": "Thyme for Tea","address": "12 Main Street","city": "Pecan Springs","state": "TX","zip": "44628","country": "US"},';
       body += '"customerIP": "192.168.1.1",';
       body += '"transactionSettings": {"setting": {"settingName": "testRequest","settingValue": "false"}},';
       body += '"userFields": {"userField": [{"name": "MerchantDefinedFieldName1","value": "MerchantDefinedFieldValue1"},{"name": "favorite_color","value": "blue"}]},';
       body += '"processingOptions": {"isSubsequentAuth": "true"},';
       body += '"subsequentAuthInformation": {"originalNetworkTransId": "123456789NNNH","originalAuthAmount": "45.00","reason": "resubmission"},';
       body += ' "authorizationIndicatorType": {"authorizationIndicator": "final"}';
       body += '}';
       body += '}';
       body += '}';   
       req.setBody(body );
       HttpResponse res = h.send(req); 
       
       system.debug(res.getBody());
       }
}