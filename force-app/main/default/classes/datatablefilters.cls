public class datatablefilters {
     @AuraEnabled public String label;
     @AuraEnabled public String type;
     @AuraEnabled public List<String> operators = new List<String>();
     @AuraEnabled public String value; 
     @AuraEnabled public List<Map<String,String>> options = new List<Map<String,String>>();
    
    
    public static final String CONTAINS = 'contains';
    public static final String EQUAL = 'equal';
    public static final String NOTEQUALTO = 'not equal to'; 
    public static final String LESSTHAN = 'less than';
    public static final String LESSTHANOREQUALTO = 'less than or equal to';
    public static final String GRETERTHAN = 'greter than';
    public static final String GRETERTHANOREQUALTO = 'greter than or equal to';
    
     
    
    public List<String> getTextOperators() {
        return new List<String>{CONTAINS,
                                EQUAL,
                                NOTEQUALTO};
    }
    
    public List<String> getBooleanOperators() {
        return new List<String>{EQUAL,
                                NOTEQUALTO};
    }
    
    public List<String> getPickListOperators() {
        return new List<String>{EQUAL,
                                NOTEQUALTO};
    }
    
    public List<String> getNumericOperators() {
        return new List<String>{EQUAL,
                                NOTEQUALTO,
                                LESSTHAN,
                                LESSTHANOREQUALTO,
                                GRETERTHAN,
                                GRETERTHANOREQUALTO
                                };
    }
    
}