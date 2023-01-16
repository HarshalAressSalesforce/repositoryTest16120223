public class shopifyParser {
    public shopifyParser() {
        /*string ResponseBody;
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        String url = 'https://aress-developer-store.myshopify.com';
        string endPointValue = url + '/admin/products.json';
        req.setEndpoint(endPointValue);
        req.setClientCertificateName('shopify');
        String username = '9315d5edfee6cce6e80e1a89d138c637';
        String password = '9827f07e8a8db48e103472dc15311aff';
        Blob headerValue = Blob.valueOf(username + ':' + password);
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        req.setHeader('Authorization', authorizationHeader);
        req.setHeader('content-type', 'application/json');
        req.setBody('{"product": {"title":"Shaamli Salesforce Developer","body_html": "<strong>This is the testing description</strong>","vendor": "Aress","product_type": "Human","published": "false"}}');
        req.setMethod('POST');
        try {
            HttpResponse res = h.send(req);
            ResponseBody = res.getBody();
            system.debug(ResponseBody );
        } catch (exception e) {
            System.debug('exception' + e);
        }*/
        
    }
    
     
    public static void sendProductToShopify(List<Product2> products) {
       Map<String,List<Map<String,String>>> productsContainer = new Map<String,List<Map<String,String>>>();
       List<Map<String,String>> productsSections = new List<Map<String,String>>();
       for(Product2 product : products) {
           Map<String,String> productPart = new Map<String,String>();
           productPart.put('title',product.name);
           productPart.put('body_html',product.Description);
           productPart.put('vendor','Aress');
           productPart.put('type',product.Family);
           productPart.put('published','true');           
           productsSections.add(productPart);
       }
       productsContainer.put('product',productsSections);
       String productString =  JSON.serialize(productsContainer);
       confirmProductToShopify(productString );
       
       
    }
    
    
    @future(callout=true)
    public static void confirmProductToShopify(String products) {
       system.debug('Products-->'+products);
       products= products.replace('"product":[', '"product":');
       products= products.replace('}]}', '}}');
       system.debug('Products-->'+products);
       Http h = new Http();
       HttpRequest req = new HttpRequest();
       String url = 'https://aress-developer-store.myshopify.com';
       string endPointValue = url + '/admin/products.json';
       req.setEndpoint(endPointValue);
       req.setClientCertificateName('shopify');
       String username = '9315d5edfee6cce6e80e1a89d138c637';
       String password = '9827f07e8a8db48e103472dc15311aff';
       Blob headerValue = Blob.valueOf(username + ':' + password);
       String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
       req.setHeader('Authorization', authorizationHeader);
       req.setHeader('content-type', 'application/json');
       req.setBody(products);
       req.setMethod('POST');
       try {
            HttpResponse res = h.send(req);
            String ResponseBody = res.getBody();
            system.debug(ResponseBody );
            
            /*Map<String,Object> response = (Map<String,Object>) ResponseBody.deserializeUntyped(ResponseBody );
            if(response.size() > 0 && response != null) {            
              
            }*/
       } catch (exception e) {
            System.debug('exception' + e);
       }
    }
    
    
}