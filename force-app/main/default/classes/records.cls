public class records {
  
    @AuraEnabled 
    public static List<Map<String,String>> getAllObjects() {
        List<Schema.SObjectType> gd = Schema.getGlobalDescribe().Values();     
        List<Map<String,String>> objects = new List<Map<String,String>>();
        Map<String,String> obj ;
        for(Schema.SObjectType f : gd) {
             obj = new Map<String,String>();
             obj.put('label',f.getDescribe().getLabel());
             obj.put('name',f.getDescribe().getName());
             objects.add(obj);
        }
        return objects;    
    }
}