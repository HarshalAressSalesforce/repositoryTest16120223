public class geoparser {
    public String json = '';
    
    public String getAddress(String latitude,String longitude) {
        String address;
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        String url = 'http://maps.googleapis.com/maps/api/geocode/json?latlng='+latitude+','+longitude+'&sensor=false'; 
        req.setEndpoint(url);
        req.setMethod('GET');
        try {
            HttpResponse res = h.send(req);
            String ResponseBody = res.getBody();
            
            
            jsonParser parser = (jsonParser) System.JSON.deserialize(ResponseBody, jsonParser.class);
            system.debug(parser);
            integer count = 0;
            integer matchingCount;
            Double min;
            Double mindiff = 0;
            
            if(parser.results.size() > 0) {
                for(jsonParser.results result :parser.results ){
                    jsonParser.geometry geometries = result.geometry;
                    //if(Decimal.valueOf(geometries.location.get('lng')) == Decimal.valueOf(longitude)) {
                    /*Decimal lat =   Decimal.valueOf(latitude).setScale(4);
                    Decimal locLat =   Decimal.valueOf(geometries.location.get('lat')).setScale(4);
                    
                     
                    
                    if(lat >= locLat) {
                        min = lat - locLat;
                    } else {
                        if(lat  < locLat ) {
                            min = locLat - lat;
                        } 
                    } 
                    if(mindiff == null) {
                        mindiff = min;
                    }
                    
                    if(min <= mindiff)  {
                        mindiff = min;
                        matchingCount = count;
                    }
                    //}
                    count++;*/
                    
                    if(geometries.location_type =='ROOFTOP') {
                        matchingCount = count;                        
                    }
                     
                }
                
                
                if(matchingCount !=null) {
                    address = parser.results[matchingCount].formatted_address;
                }
                
                address = parser.results[0].formatted_address;
            }
            
            
        } catch (exception e) {
            System.debug('exception' + e);
        }
        return address;
    } 
    
    
    
    
    
}