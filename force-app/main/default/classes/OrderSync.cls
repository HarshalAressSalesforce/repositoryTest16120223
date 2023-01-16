public class OrderSync 
{

    public void retrieveGoogleAccessToken() {
    //Local Variables
    string ResponseBody;
    //Making Callouts using HTTP Requests
    Http h = new Http();
    HttpRequest req = new HttpRequest();
    //Provide URL of the Shopify store to HTTP requests
    String url = 'https://aress-demo.myshopify.com';
    string endPointValue = url + '/admin/orders.json';
    req.setEndpoint(endPointValue);
    //Adding certificate to HTTP Requests
    req.setClientCertificateName('shopify');
    //Providing Username and Password
    String username = '5f201dbc6f6ea6c0cc8ac0fe4394e45c';
    String password = '04a84878f4b82f16a7e71a6372c10cd9';
    Blob headerValue = Blob.valueOf(username + ':' + password);
    String authorizationHeader = 'Basic ' +
    EncodingUtil.base64Encode(headerValue);
    req.setHeader('Authorization', authorizationHeader);
    req.setHeader('content-type', 'application/json');
    //Use get Method as we are retrieving data from shopify
    req.setMethod('GET');
    try {
        HttpResponse res = h.send(req);
        ResponseBody = res.getBody();
        System.debug('Response Body:'+ResponseBody);
        
        // new code begins
        JSONParser parser = JSON.createParser(ResponseBody); 
        String text = '';
while (parser.nextToken() != null) {
    if(parser.getCurrentToken() == JSONToken.START_OBJECT){
       // parser.nextToken();
        text = parser.getText() + ', ' + text;
    }
    //System.debug(parser.getText() + parser.nextToken() + ' - ' + parser.getText());
    if (parser.getCurrentToken() == JSONToken.START_ARRAY) {
        //parser.nextToken();
        text = parser.getText() + ', ' + text;
    }
}
system.debug(text);
//new code ends
       
       /* 
        Map<String, Object> root = (Map<String, Object>)JSON.deserializeUntyped(ResponseBody);
       // List<Object> items = (List<Object>)root.get('items');
      //  System.debug('Item:'+items);
        for(Object item : root) 
        {
           // Map<String, Object> i = (Map<String, Object>)item;
            System.debug(item.get('id'));
        }
        */
    }
    catch (exception e) 
    {
        System.debug('exception' + e);
    }
     
     /*
    // Parse entire JSON response.
    JSONParser parser = JSON.createParser(jsonStr);
    while (parser.nextToken() != null) {
        // Start at the array of invoices.
        if (parser.getCurrentToken() == JSONToken.START_ARRAY) {
            while (parser.nextToken() != null) {
                // Advance to the start object marker to
                //  find next invoice statement object.
                if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                    // Read entire invoice object, including its array of line items.
                    Invoice inv = (Invoice)parser.readValueAs(Invoice.class);
                    system.debug('Invoice number: ' + inv.invoiceNumber);
                    system.debug('Size of list items: ' + inv.lineItems.size());
                    // For debugging purposes, serialize again to verify what was parsed.
                    String s = JSON.serialize(inv);
                    system.debug('Serialized invoice: ' + s);

                    // Skip the child start array and start object markers.
                    parser.skipChildren();
                }
            }
        }
    }
    */
    
    
    }
    
}