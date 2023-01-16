public class datatableResponse {
	@AuraEnabled public List<datatableFields> fields ;
    @AuraEnabled public List<datatablefilters> filters ;
    @AuraEnabled public datatablerecords records ;
    @AuraEnabled public String customFilter ;
    
    public static String obj;
    public static String cols;
    public static Integer currentPage;
    
    public datatableResponse(String ObjectName,String columns,String filters,String customFilter,List<datatablefilters> search,Integer page) {
        if(columns != '' && ObjectName !='') {
        	obj = ObjectName;
        	cols = columns;
            currentPage = page;
            this.customFilter = customFilter;
            this.filters = search;
            prepareGridColumns(filters);
            prepareRecords(); 
        }
    }
    
    public void prepareRecords() {
        this.records = new datatablerecords();
        this.records.prepareData(obj,cols,this.filters,this.customFilter,currentPage);
    }
    
    private void prepareFilters(String filters, Map<String,Schema.SObjectField> mfields) {
    	 if(filters !='') {
             List<String> ListOffilters = filters.split(',');
             if(ListOffilters.size()>0) {
                 String type;
                 for(String col : ListOffilters) {
                     if(mfields.get(col) != null) {
                         schema.describefieldresult dfield = mfields.get(col).getDescribe();
                         type = String.valueOf(dfield.getType()).toLowerCase();
                         datatablefilters filterObj = new datatablefilters();
                         filterObj.label = dfield.getLabel();
                         filterObj.type = type;
                         if(type == 'text' || type == 'email'|| type == 'id' || type == 'phone'|| type == 'string'|| type == 'url' ) {                             
                             filterObj.operators = filterObj.getTextOperators();                             
                         }
                         
                         if(type == 'date' || type == 'percent'|| type == 'integer' || type == 'currency' || type == 'long'|| type == 'double'|| type == 'datetime' ) {                             
                             filterObj.operators = filterObj.getNumericOperators();                             
                         }
                         
                         if(type == 'boolean') {
                             filterObj.operators = filterObj.getBooleanOperators();   
                         }
                         
                         if(type == 'picklist') {
                             filterObj.operators = filterObj.getPickListOperators();  
                             List<Schema.PicklistEntry> ple = dfield.getPicklistValues();
                             if(ple.size()>0) {
                                 Map<String,String> opt;
                                 for(Schema.PicklistEntry f : ple) {
      								 opt = new Map<String,String>();
                                     opt.put('value',f.getValue());
                                     opt.put('label',f.getLabel());
                                     filterObj.options.add(opt);
   								 }   
                             }
                         }
                         
                         if(this.filters == null) {
                             this.filters = new List<datatablefilters>();
                         }
                         
                         this.filters.add(filterObj);
                     }
                 }
             }
         }   
    }
    
    private void prepareGridColumns(String filters) {
        if(obj != '' && cols !='') { 
            List<String> ListOfcolumn = cols.split(','); 
            if(ListOfcolumn.size()>0) {
                
                
                SObjectType objType = Schema.getGlobalDescribe().get(obj);
                Map<String,Schema.SObjectField> mfields = objType.getDescribe().fields.getMap();
                if(mfields.keySet().size()>0) {
                    this.fields = new List<datatableFields>();
                    String type;
                    
                    prepareFilters(filters,mfields);
                    
                    
                    type= '';
                    for(String col : ListOfcolumn) {
                        system.debug(ListOfcolumn+'--->'+mfields.get(col));
                        if(mfields.get(col) != null) {
                            schema.describefieldresult dfield = mfields.get(col).getDescribe();
                            type = String.valueOf(dfield.getType()).toLowerCase();
                            
                            
                            
                            
                            
                            if(type!='picklist') {
                                datatableFields fld = new datatableFields();
                                fld.fieldName = dfield.getName();                            
                                fld.type =  type;
                                if(fld.type == 'string') {
                                    fld.type = 'text';
                                }
                                
                                if(fld.type == 'double') {
                                    fld.type = 'number';
                                }
                                fld.label= dfield.getLabel();
                                
                                this.fields.add(fld);
                                
                                system.debug('45--->'+this.fields);
                            }
                        }
                    }
                }                
            } 
        }
    }
}