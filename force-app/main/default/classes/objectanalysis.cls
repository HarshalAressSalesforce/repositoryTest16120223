public with sharing class objectanalysis {
    public objectanalysis() {

    }

    public class objectList {
        @AuraEnabled public String value;
        @AuraEnabled public String label;
    }

    public class analysis {
        @AuraEnabled public String label;
        @AuraEnabled public String apiName;
        @AuraEnabled public Integer percentValue =0;
        @AuraEnabled public Integer totalRecords =0;
        @AuraEnabled public Integer numberRecords =0;
    }

    @AuraEnabled(cacheable=true)
    public static List<objectList> fetchObjects(){  
        List<objectList> objects = new List<objectList>(); 
        List<Schema.SObjectType> gd = Schema.getGlobalDescribe().Values();
        List<SelectOption> options = new List<SelectOption>();
        objectList obj;
        for(Schema.SObjectType f : gd) {
            obj = new objectList();
            obj.value = f.getDescribe().getName();
            obj.label = f.getDescribe().getLabel();
            objects.add(obj);
        }
        return objects;
    }

    @AuraEnabled(cacheable=true)
    public static List<analysis> fetchAnalysis(String objectName){  
        List<analysis> analysis = new List<analysis>(); 
        Map <String,Schema.SObjectType> gd = Schema.getGlobalDescribe();
        Schema.SObjectType sobjType = gd.get(objectName);
        Schema.DescribeSObjectResult r = sobjType.getDescribe();
        Map<String, Schema.SObjectField> MapofField = r.fields.getMap();

        List<String> fields = new List<String>();
        Map<String,analysis> fieldDetails = new Map<String,analysis>();
        analysis an;

        List<String> excludedFieldTypes = new List<String>();

        for(String fieldName : MapofField.keySet()) {
            Schema.SObjectField field = MapofField.get(fieldName);
            Schema.DescribeFieldResult F = field.getDescribe();
            
            system.debug('52--->'+f.getName()+'-->'+f.isFilterable()+'--->'+f.isCreateable());
            if(!f.isFilterable() || !f.isCreateable() || !f.isNillable()) {
                continue;
            }
            fields.add('count('+f.getName()+')'+f.getName()+'');

            an = new analysis();
            an.label = f.getLabel();
            an.apiName = f.getName();            
            fieldDetails.put(f.getName(),an);
        }

        String sql = 'select '+String.join(fields, ',')+' from '+objectName;
         
        system.debug('58--->'+sql);
        Integer totalRecords = 0;
        for(AggregateResult result : Database.query('select count(Id) total from '+objectName) ) {
            totalRecords+=(Integer)result.get('total');
        }
    
        
        for(Aggregateresult result : Database.query(sql)) {
            if(fieldDetails.keySet().size()>0) {
                for(String fld : fieldDetails.keySet()) {
                    if(result.get(fld) != null) {
                        if(Integer.valueOf(result.get(fld))>0) {
                            fieldDetails.get(fld).numberRecords =  Integer.valueOf(result.get(fld)) ;
                            fieldDetails.get(fld).totalRecords =  totalRecords ;
                            fieldDetails.get(fld).percentValue = (fieldDetails.get(fld).numberRecords * 100) /fieldDetails.get(fld).totalRecords;
                        } 
                    }                      
                } 
            } 
        }

        if(fieldDetails.keySet().size()>0) {
            return fieldDetails.values();
        }
        return null;
    }
}