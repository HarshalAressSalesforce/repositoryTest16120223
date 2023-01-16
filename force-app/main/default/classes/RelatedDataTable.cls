/************************************************************************
* @description       : Apex controller for relatedDataTable LWC
* @author            : Aress Softwares
************************************************************************/
public class RelatedDataTable {
    public String fields;
    public boolean delrec;
    /***********************************************************************
	* @description  : Method to fetch records.
	* @author     	: Aress Softwares
	* @param    	: childObj & recordId 
	* @return    	: List<SObject>
	***********************************************************************/
    @AuraEnabled
    public static List<SObject> mouseOver(String childObj,String recordId){
        system.debug('childObj'+childObj);
        system.debug('recordId'+recordId);
        String childObjquery = childObj;
        system.debug('childObjquery'+childObjquery);
        Id myRecordId = recordId;	
        String ParentObjName = myRecordId.getSObjectType().getDescribe().getName();
        
                String ParentObjNameinquery = '';
               Map<String, Schema.SObjectType> m1 = Schema.getGlobalDescribe() ;
               // Schema.SObjectType s = m1.get('Generic_LWC_obj__c') ;
               Schema.SObjectType s = m1.get(childObjquery) ;
                Schema.DescribeSObjectResult r1 = s.getDescribe() ;
                Map<String,Schema.SObjectField> fields = r1.fields.getMap() ;
                List<String> lstrequiredfields=new List<String>();
                
                for(String f : fields.keyset()) {
                    system.debug('f----->'+f);
                    Schema.DescribeFieldResult desribeResult = fields.get(f).getDescribe();
                    system.debug('desribeResult---->'+String.valueof(desribeResult.getReferenceTo()));
                    string temp = String.valueof(desribeResult.getReferenceTo());
                   // temp = temp.replaceAll('[^a-zA-Z0-9\\s+]', '');
                   temp = temp.substring(1, temp.length() - 1);
                    system.debug('temp-->'+temp);
                    System.debug('f--->'+ParentObjName);
                    if(temp == ParentObjName){
                        System.debug('f----->'+f);
                        ParentObjNameinquery = f;
                    }
                }
            system.debug('ParentObjNameinquery'+ParentObjNameinquery);
             if(ParentObjNameinquery.contains('__c')){
                 
                ParentObjNameinquery = ParentObjNameinquery.replace('__c', '__r');
                 
            }
			system.debug('ParentObjNameinquery'+ParentObjNameinquery);
            
        
           if(!childObjquery.contains('__c')){
                ParentObjNameinquery = ParentObjName;    
            }
            
            System.debug('ParentObjNameinquery'+ParentObjNameinquery);
        
        string name = '';
        Map<String,Schema.SObjectType> gd = Schema.getGlobalDescribe();
        
        Schema.SObjectType sobjType = gd.get(childObjquery);
        Schema.DescribeSObjectResult r = sobjType.getDescribe();
        Map<String,Schema.SObjectField> M = r.fields.getMap();
        for(Schema.SobjectField strFld: r.fields.getMap().Values()) {
            if(string.valueOf(strFld) == 'Name') {
                name = 'Name';
            }
        }
        if(name == ''){
            name = childObjquery+'Number';
        }
        
        String query = 'SELECT Id,CreatedDate,LastModifiedDate,'+name+' FROM '+childObjquery+' '+'WHERE'+' '+ParentObjNameinquery+'.Id = '+'\''+myRecordId+'\''+' order by CreatedDate desc'; //Owner.Name,
        system.debug('query----->'+query);
        List<SObject> queryResult=new List<SObject>();
        queryResult= Database.query(query);   
        return queryResult;   
    }
    /***********************************************************************
	* @description  : Method to delete record on click of delete action.
	* @author     	: Aress Softwares
	* @param    	: recordId 
	* @return    	: void
	***********************************************************************/
    @AuraEnabled
    public static void deleteRecord(String recordId) {
        Id recid = Id.valueOf(recordId.replace('"',''));
        System.debug('recid--'+recid);
        if(recid != null){         
            Database.delete(recid);
        }
    }
}