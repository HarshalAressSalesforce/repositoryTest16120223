/************************************************************************
* @description       : Apex controller for relatedListquickLinks,relatedFields & relatedDataTable LWC
* @author            : Aress Softwares
************************************************************************/
global with sharing class RelatedListCount {
    GLOBAL with sharing class fieldList{
        @AuraEnabled global String fieldKey = '';
        @AuraEnabled global String field = '';
        @AuraEnabled global String value = '';
        
    }
    /***********************************************************************
	* @description  : Method to fetch Mandatory Fields on Click of New Button to create new record.
	* @author     	: Aress Softwares
	* @param    	: objectName 
	* @return    	: List<String> requiredFields
	***********************************************************************/
    @AuraEnabled
    public static List<String> fetchMandatoryFields(String objectName){
        Map<String, Schema.SObjectType> m = Schema.getGlobalDescribe() ;
        Schema.SObjectType s = m.get(objectName) ;
        Schema.DescribeSObjectResult r = s.getDescribe() ;
        Map<String,Schema.SObjectField> fields = r.fields.getMap() ;
        List<String> lstrequiredfields=new List<String>();
        
        for(String f : fields.keyset()) {
            Schema.DescribeFieldResult desribeResult = fields.get(f).getDescribe();
            if(desribeResult.isCreateable() && !desribeResult.isNillable() && !desribeResult.isDefaultedOnCreate() )  {                
                lstrequiredfields.add(f);
            }
        }

        if(lstrequiredfields.size()<=0) {
            lstrequiredfields.add('Name');
        }

        return lstrequiredfields;        
    }
	/***********************************************************************
	* @description  : Method to fetch Object Details.
	* @author     	: Aress Softwares
	* @param    	: objectName & recordId 
	* @return    	: List<fieldList>
	***********************************************************************/
    @AuraEnabled
    public static List<fieldList> fetchObjectDetails(String objectName,String recordId){
        System.debug('objectName=='+objectName);
        System.debug('recordId=='+recordId);
        Id myRecordId = recordId;	
        String ParentObjName;
        if(myRecordId != null || myRecordId != ' '){
           ParentObjName = myRecordId.getSObjectType().getDescribe().getName();
        }
        System.debug('ParentObjName=='+ParentObjName);
        Set<String> listOfFilds = new Set<String>();

        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(objectName);
        System.debug('Test targetType-->'+targetType);
        Map<String, Schema.SObjectField> fieldMap = targetType.getDescribe().fields.getMap();
        List<fieldList> fl = new List<fieldList>();
        Integer counter = 1;
        for(String fieldName : fieldMap.keySet()) {
            Schema.SObjectField field = fieldMap.get(fieldName);
            Schema.DescribeFieldResult fieldDescribe = field.getDescribe();
            
            for(Schema.SObjectType reference : fieldDescribe.getReferenceTo()) {
                if(reference.getDescribe().getName() == ParentObjName) {
                    fieldList fldMap = new fieldList();
                    counter++;
                    fldMap.fieldKey = 'key'+String.valueOf(counter);
                    fldMap.field = field.getDescribe().getName();
                    fldMap.value = recordId;
                    fl.add(fldMap);
                } 
            } 
        } 
        return fl;
    }
    /***********************************************************************
	* @description  : Method to fetch object data like Object Name,Icon & its record Count
	* @author     	: Aress Softwares
	* @param    	: objectName & recordId
	* @return    	: Objwrapper
	***********************************************************************/
    @AuraEnabled
    public static Objwrapper getrelatedData(String objectName,String recordId){
        //System.debug('objectName--'+objectName);
        system.debug('objectName'+objectName);
        system.debug('recordId'+recordId);
        Objwrapper WrapObj = new Objwrapper();
        if(objectName != null && recordId != null && recordId !=''){
        system.debug('recordId'+recordId);
        Id myRecordId = recordId;	
        String ParentObjName = myRecordId.getSObjectType().getDescribe().getName();
        WrapObj.parentObjName = ParentObjName;
        List<String> objnameList = objectName.split(',');	    //Split the string
        objnameList.sort();
        System.debug('objnameList-->'+objnameList);
        Map<String,String> objMap = new Map<String,String>();
        
        /*Code added for " Schema.sObjectType.Account.getChildRelationships()" to make this line generic.*/        
        Map<String,Schema.SObjectType> gd = Schema.getGlobalDescribe();
        Schema.SObjectType sobjType = gd.get(ParentObjName);
        Schema.DescribeSObjectResult r = sobjType.getDescribe();
        
        for (Schema.ChildRelationship s : r.getChildRelationships()) { 		// need to change Account to ParentObjectname
            //System.debug('Object Name *********'+String.valueOf(s.getChildSObject())+'*****child relationships***'+String.valueOf(s.getRelationshipName()));
            // * Getting the API name and value of current sObject and adding it to the map
            If(s.getRelationshipName() != null)
            {
                objMap.put(String.valueOf(s.getChildSObject()), String.valueOf(s.getRelationshipName())); 
            } 
        }
        Map<String,string> csMap = new Map<String,string>();
        Map<String,string> countMap = new Map<String,string>();
        for(String parentobj: objnameList)
        {
            if(objMap.containsKey(parentobj))
            {
                //String objectLabel  = r.getLabel();
                //system.debug('objectLabel-->'+objectLabel);
                //csMap.put(objectLabel,objMap.get(parentobj)); //csMap.put(parentobj,objMap.get(parentobj));
                csMap.put(parentobj,objMap.get(parentobj));
                //countMap.put(objMap.get(parentobj),objectLabel);
                countMap.put(objMap.get(parentobj),parentobj);
            }
        }
        
        List<String> queryList = new List<String>();
        for(string createquery: csMap.Values()){
            String query = '('+'SELECT Id FROM '+' '+createquery+')';
            system.debug('Query Created for Child Objects ******** '+query);
            queryList.add(query);
        }
        
        String parentquery = 'SELECT id,';
        for(integer i=0; i<queryList.size();i++){
            parentquery = parentquery+queryList[i]+',';
        }
        
        parentquery = parentquery.removeEnd(','); 
        parentquery = parentquery+' FROM '+ParentObjName+' WHERE ID ='+'\''+recordId+'\'';
        List<SObject> comp=new List<SObject>();
        comp= Database.query(parentquery);
        Sobject sobj=comp[0];
        
        Map<string,Integer> finalCountMap = new Map<string,Integer>();
        List<SObject> divsize;
        for(string countvalues: csMap.values()){
            if(countMap.containskey(countvalues)){
                Integer size;
                divsize=sobj.getSObjects(countvalues);
                if(divsize == null){ 					//!divsize.isEmpty() && divsize != null
                    size = 0;
                }else if(divsize != null){
                    size = divsize.size();
                }
                finalCountMap.put(countMap.get(countvalues),size); 
            }
        }
        System.debug('finalCountMap 130==>'+finalCountMap);
        WrapObj.ObjNameCount=finalCountMap;
        
        if(finalCountMap.keySet().size()>0) {
            for(String objName : finalCountMap.keySet()) {
               WrapObj.ObjNameMapping.put(objName, Schema.getGlobalDescribe().get(objName).getDescribe().getLabel());
            }
        }
        //system.debug('136-->'+WrapObj.ObjNameMapping);
        
        String u='{';
        integer count=0;
        List<Schema.DescribeTabSetResult> tabSetDesc = Schema.describeTabs();
        List<Schema.DescribeTabResult> tabDesc = new List<Schema.DescribeTabResult>();
        List<Schema.DescribeIconResult> iconDesc = new List<Schema.DescribeIconResult>();
        list<string> sobjectNamesStoredUniquely = new list<string>();

        for(Schema.DescribeTabSetResult tsr : tabSetDesc) {
            for(Schema.DescribeTabResult tr : tsr.getTabs()) {
                if(finalCountMap.Keyset().contains(tr.getSobjectName()) && !sobjectNamesStoredUniquely.contains(tr.getSobjectName())) {
                    sobjectNamesStoredUniquely.add(tr.getSobjectName());
                    tabDesc.add(tr); 
                }
            }
        }
        
        Map<string,List<object>> customiconMap =new Map<string,List<object>>();
        for(string fMap :finalCountMap.keyset()){
            for(Schema.DescribeTabResult tr : tabDesc) {
                if( fMap == tr.getSobjectName() ) {
                    if( tr.isCustom() == true ) {
                        iconDesc.addAll(tr.getIcons());
                        customiconMap.put(fMap, tr.getIcons());
                    } else {
                        WrapObj.iconname.put(fMap,'standard:'+tr.getSobjectName().toLowerCase());		//u =u+'standard:' + tr.getSobjectName()+',';
                    }
                }
            }   
        }
        
        Map<String,string> custIconMap =  New Map<String,string>();
        for(string fmap1:customiconMap.keySet()){
            for (Schema.DescribeIconResult ir : iconDesc) {
                if (ir.getContentType() == 'image/svg+xml'){
                    u = 'custom:' + ir.getUrl().substringBetween('custom/','.svg').substringBefore('_')+',';
                    u=u.removeEnd(',');
                    WrapObj.iconname.put(fmap1,u);
                }
            }
        }
        Map <String,string> Iconname = New Map<string, String>();
        Iconname.put('Asset','standard:asset_object');
        Iconname.put('WorkOrder','standard:work_order');
        Iconname.put('Order','standard:orders');
        for(string icn:Iconname.keySet()){
            //System.debug('WrapObj.iconname'+WrapObj.iconname.keyset());
            if(WrapObj.iconname.containsKey(icn)){
                WrapObj.iconname.put(icn,Iconname.get(icn));
            }
        }
        WrapObj.objectwithchilerelationname = objMap;
        WrapObj.IsSuccess = true;
        System.debug('WrapObj==>'+WrapObj);
        }else{
        WrapObj.IsSuccess = false;
        }
        return WrapObj;
    }
    GLOBAL with sharing class Objwrapper{
        @Auraenabled
        global Map<string,string> iconname = new Map<string,string>();
        @Auraenabled
        global Map<string,integer> ObjNameCount = new Map<string,integer>();
        @Auraenabled
        global Map<string,string> objectwithchilerelationname = new Map<string,string>();
        @Auraenabled
        global string parentObjName;
        @Auraenabled
        global Map<string,String> ObjNameMapping = new Map<string,String>();
        @Auraenabled
        global boolean IsSuccess=false;
    } 
}