public class DataTableApexClass {
    /*@AuraEnabled
    public static List<Account> getAllAccounts(){
        return [Select Id,Name ,AnnualRevenue,Description,NumberOfEmployees,Industry,Rating,Phone from Account] ; 
        
    }*/
    
    @AuraEnabled
    public static Object getAllData(String ObjectName,String columns,String filters,String customFilter,List<datatablefilters> search,Integer page){
        if(columns != '' && ObjectName !='') {
            return new datatableResponse(ObjectName,columns,filters,customFilter,search,page);
        }
        return null;
        //return [Select Id,Name ,AnnualRevenue,Description,NumberOfEmployees,Industry,Rating,Phone from Account] ; 
        
    }
    
    @AuraEnabled
    public static void updateObject(List<SObject> obj ){
        update obj;
    }
    
    @AuraEnabled
    public static void updateAccount(List<Account> acc ){
        update acc;
    }
    
    //system.debug(DataTableApexClass.getColumns('Account',''));
    
    @AuraEnabled
    public static Object getColumns(String ObjectName,String columns){
        if(columns != '' && ObjectName !='') {
            
            
            List<String> ListOfcolumn = columns.split(',');
            
            if(ListOfcolumn.size()>0) {
                SObjectType objType = Schema.getGlobalDescribe().get(ObjectName);
                Map<String,Schema.SObjectField> mfields = objType.getDescribe().fields.getMap();
                if(mfields.keySet().size()>0) {
                    List<Fields> columnsData = new List<Fields>();
                    String type;
                    for(String col : ListOfcolumn) {
                        system.debug(ListOfcolumn+'--->'+mfields.get(col));
                        if(mfields.get(col) != null) {
                            schema.describefieldresult dfield = mfields.get(col).getDescribe();
                            type = String.valueOf(dfield.getType()).toLowerCase();
                            if(type!='picklist') {
                                Fields fld = new Fields();
                                fld.fieldName = dfield.getName();                            
                                fld.type =  type;
                                if(fld.type == 'string') {
                                    fld.type = 'text';
                                }
                                
                                if(fld.type == 'double') {
                                    fld.type = 'number';
                                }
                                fld.label= dfield.getLabel();
                                system.debug(fld);
                                columnsData.add(fld);
                            }
                        }
                    }
                    
                    if(columnsData.size()>0) {
                       system.debug(JSON.serialize(columnsData));
                        return columnsData;
                    }
                }
                system.debug(mfields);
            }
                                                    
            
        }
        
        return null; 
    }
    
    
    public class Fields {
        @AuraEnabled public String label;
        @AuraEnabled public String fieldName;
        @AuraEnabled public String type;
        @AuraEnabled public Boolean editable = true;
    }
    
}