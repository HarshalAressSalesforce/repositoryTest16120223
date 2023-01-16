public class jsonParser1 {
   public List<Results> results;
   public String status;
    
   public class results {
        public List<address_components> address_components;
        public String formatted_address;
        public geometry geometry; 
        public String place_id;
        public List<String> types; 
    }
    
    public class address_components {
        public String long_name;
        public String short_name;
        public List<String> types;
    } 
    
    public class geometry {
        public Map<String,Map<String,String>> bounds;
        public Map<String,String> location;
        public String location_type;
        public Map<String,Map<String,String>> viewPort;
        
        
    }
}