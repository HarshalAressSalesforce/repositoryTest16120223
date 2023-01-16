public class firstVfpage {
    public List<Account> getListOfAccounts() {
        return [select Id from  Account];
    }
    
     @AuraEnabled
    public static Objwrapper getrelatedData(String objectName,String recordId){
        System.debug('objectName-->'+objectName);
        Id myRecordId = recordId;	
        System.debug('myRecordId-->'+myRecordId);
        String ParentObjName = myRecordId.getSObjectType().getDescribe().getName();
        System.debug('ParentObjName--'+ParentObjName);
        //SObject pObjectName = String.valueof(myRecordId.getSObjectType().getDescribe().getName());
        //System.debug('pObjeName-->'+pObjeName);
        //Split the string
        List<String> objnameList = objectName.split(',');
        system.debug('objnameList-->'+objnameList);
        objnameList.sort();
	 	system.debug('objnameList sorted-->'+objnameList);
        Map<String,String> objMap = new Map<String,String>();
        /*Code added for " Schema.sObjectType.Account.getChildRelationships()" to make this line generic.*/        
        Map<String,Schema.SObjectType> gd = Schema.getGlobalDescribe();
        Schema.SObjectType sobjType = gd.get(ParentObjName);
        System.debug('sobjType--'+sobjType);
        Schema.DescribeSObjectResult r = sobjType.getDescribe();
        System.debug('rrrrr 28--'+r);
        
        for (Schema.ChildRelationship s : r.getChildRelationships()) { // need to change Account to ParentObjectname
            System.debug('debugging all object Names ********* '+String.valueOf(s.getChildSObject()));
            System.debug('debugging all child relationships *********'+String.valueOf(s.getRelationshipName()));
            System.debug('Object Name *********'+String.valueOf(s.getChildSObject())+'*****child relationships***'+String.valueOf(s.getRelationshipName()));
            // * Getting the API name and value of current sObject and adding it to the map
            If(s.getRelationshipName() != null)
            {
                objMap.put(String.valueOf(s.getChildSObject()), String.valueOf(s.getRelationshipName())); 
            } 
        }
        System.debug('objMap-->'+objMap);
        Map<String,string> csMap = new Map<String,string>();
        Map<String,string> countMap = new Map<String,string>();
        for(String parentobj: objnameList)
        {
            if(objMap.containsKey(parentobj))
            {
                csMap.put(parentobj,objMap.get(parentobj));
                countMap.put(objMap.get(parentobj),parentobj);
            }
        }
        System.debug('csMap-->'+csMap);
        List<String> queryList = new List<String>();
        for(string createquery: csMap.Values()){
            String query = '('+'SELECT Id FROM '+' '+createquery+')';
            system.debug('Query Created for Child Objects ******** '+query);
            queryList.add(query);
        }
        System.debug('queryList--'+queryList);
        
        String parentquery = 'SELECT id,';
        for(integer i=0; i<queryList.size();i++){
            parentquery = parentquery+queryList[i]+',';
        }
        parentquery = parentquery.removeEnd(','); 
        system.debug('Value is--'+parentquery);
        System.debug('parentquery 37-->'+parentquery);
        parentquery = parentquery+' FROM '+ParentObjName+' WHERE ID ='+'\''+recordId+'\'';
        System.debug('parentquery 41--'+parentquery);
        
        //sObject sObj = Schema.getGlobalDescribe().get(ParentObjName).newSObject();
        //System.debug('sObject--'+sObj);
        //List<sObject> sobjList = Database.query(parentquery);
        //System.debug('queryresult 43--'+sobjList);
        List<SObject> comp=new List<SObject>();
        comp= Database.query(parentquery);
        System.debug('comp-->'+comp);
        Sobject sobj=comp[0];
        /*List<SObject> divs=sobj.getSObjects('Contacts');
            System.debug('Contacts--'+divs.size());
        List<SObject> divs1=sobj.getSObjects('Opportunities');
            System.debug('Opportunities--'+divs1.size());*/
        Map<string,Integer> finalCountMap = new Map<string,Integer>();
        System.debug('csMap.values()--'+csMap.values());
        System.debug('countMap key--'+countMap.keyset());
        List<SObject> divsize;
        for(string countvalues: csMap.values()){
            System.debug('countvalues--'+countvalues);
            if(countMap.containskey(countvalues)){
              	System.debug('Inside 63==='+countvalues);
                Integer size;
                divsize=sobj.getSObjects(countvalues);
                System.debug('divsize67-'+divsize);
                if(divsize == null){ //!divsize.isEmpty() && divsize != null
                    System.debug('Inside ifffff');
                    size = 0;
                    System.debug('divsize--'+size);
                }else if(divsize != null){
                     System.debug('Inside elseee');
                    size = divsize.size();
                    System.debug('size 76-->'+size);
                }
                finalCountMap.put(countMap.get(countvalues),size); 
            }
            //divsize.clear();
            //System.debug('divsize clear--'+divsize);
        }
       	System.debug('finalCountMap-->'+finalCountMap);
      //  return finalCountMap;
      	Objwrapper WrapObj = new Objwrapper();
           WrapObj.ObjNameCount=finalCountMap;
      
        String u='{';
        integer count=0;
        List<Schema.DescribeTabSetResult> tabSetDesc = Schema.describeTabs();
        List<Schema.DescribeTabResult> tabDesc = new List<Schema.DescribeTabResult>();
        List<Schema.DescribeIconResult> iconDesc = new List<Schema.DescribeIconResult>();
        list<string> sobjectNamesStoredUniquely = new list<string>();
		system.debug('FINAL COUNT STRINGS :'+finalCountMap.keyset());
        for(Schema.DescribeTabSetResult tsr : tabSetDesc) 
        {
            for(Schema.DescribeTabResult tr : tsr.getTabs()) 
            {
                system.debug('THIS IS TR : '+tr);
                system.debug('THIS IS TR SOBJECT :'+tr.getSobjectName());
                if(finalCountMap.Keyset().contains(tr.getSobjectName()) && !sobjectNamesStoredUniquely.contains(tr.getSobjectName()))
                {
                    sobjectNamesStoredUniquely.add(tr.getSobjectName());
                    system.debug('Getting inside');
                    system.debug('127--->'+tr.getSobjectName());
                    tabDesc.add(tr); 
                }
            }
        }
        Map<string,List<object>> customiconMap =new Map<string,List<object>>();
        system.debug('sobjectNamesStoredUniquely : '+sobjectNamesStoredUniquely.size()+' : '+sobjectNamesStoredUniquely);
        system.debug('TABDESC : '+tabDesc.size());
        for(string fMap :finalCountMap.keyset()){
            system.debug('fmap Keyset==='+fMap);
            for(Schema.DescribeTabResult tr : tabDesc) {
                system.debug('tr *** '+tr.getSobjectName());
                if( fMap == tr.getSobjectName() ) {
                    if( tr.isCustom() == true ) {
                        iconDesc.addAll(tr.getIcons());
                        customiconMap.put(fMap, tr.getIcons());
                        system.debug('custom **'+tr.getIcons());
                    } else {
                        system.debug('hitting else **');
                        WrapObj.iconname.put(fMap,'standard:'+tr.getSobjectName().toLowerCase());
                        //u =u+'standard:' + tr.getSobjectName()+',';
                        system.debug(' WrapObj.iconname=='+ WrapObj.iconname);
                    }
                }
            }
            
        }
        Map<String,string> custIconMap =  New Map<String,string>();
        for (Schema.DescribeIconResult ir : iconDesc) {
            if (ir.getContentType() == 'image/svg+xml'){
                u = 'custom:' + ir.getUrl().substringBetween('custom/','.svg').substringBefore('_')+',';
                for(string fmap1:customiconMap.keySet()){
                   
                   WrapObj.iconname.put(fmap1,u);
                }
            }
        }
        System.debug('WrapObj-->'+WrapObj);
        u=u.removeEnd(',');
       u=u+'}';
		system.debug('iconName:: '+u);
        //WrapObj.iconname=u;
  	return WrapObj;
    }
 	 public with sharing class Objwrapper{
		@Auraenabled
		public Map<string,string> iconname = new Map<string,string>();
         @Auraenabled
       public Map<string,integer> ObjNameCount = new Map<string,integer>(); 
    }
   
}