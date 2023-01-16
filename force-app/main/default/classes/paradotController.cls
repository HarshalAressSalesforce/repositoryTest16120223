public class paradotController{
   public  paradotController() {
     String userKey = '2af2d4555958677ceaad5006f0ba5739';
     Http h = new Http();
     HttpRequest req = new HttpRequest(); 
     req.setEndpoint('https://pi.pardot.com/api/login/version/3');
     req.setBody('email=sumanta.mukherjee@aress.com&password=Aress123$&user_key=2af2d4555958677ceaad5006f0ba5739');
     req.setMethod('POST');
     try {
            HttpResponse res = h.send(req);
            String ResponseBody = res.getBody();
            system.debug(ResponseBody );
            
            Dom.Document doc = res.getBodyDocument();
            Dom.XMLNode rsp = doc.getRootElement();
            system.debug('rsp->'+rsp );
             system.debug('api_key->'+rsp.getChildElement('api_key', null).getText());
       } catch (exception e) {
            System.debug('exception' + e);
       }  
   }   
}