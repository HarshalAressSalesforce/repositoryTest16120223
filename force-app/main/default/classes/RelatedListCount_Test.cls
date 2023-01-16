/************************************************************************
* @description       : Test class for RelatedListCount apex controller.
* @author            : Aress Software
************************************************************************/
@isTest
public class RelatedListCount_Test {
    
    /***********************************************************************
    * @description  : Testsetup method to create test data.
    * @author     : Aress Software
    ***********************************************************************/   
    @testsetup
    public static void creattestdata(){
        Account acc = new Account();
        acc.Name = 'AccountTest';
        insert acc;
    }
    
    /***********************************************************************
    * @description: Testmethod to cover getrelatedData,fetchObjectDetails,fetchMandatoryFields method of apex controller RelatedListCount
    * @author     : Aress software
    ***********************************************************************/ 
    @isTest
    public Static void createrelatedData(){
        String objectName = 'Contact,Case,Opportunity';
        String fetchobj = 'Contact';
        
        Id recid= [SELECT Id FROM ACCOUNT LIMIT 1].id;
        String aid = Id.valueOf(recid); 
        Test.startTest();
        RelatedListCount.getrelatedData(objectName,aid);
        RelatedListCount.fetchObjectDetails(fetchobj,aid);
        RelatedListCount.fetchMandatoryFields(fetchobj);
        Test.stopTest();
    }    
}