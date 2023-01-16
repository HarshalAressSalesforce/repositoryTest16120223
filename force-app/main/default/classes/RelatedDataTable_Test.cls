/************************************************************************
* @description       : Test class for relateddatatable apex controller.
* @author            : Aress Software
************************************************************************/

@istest
public class RelatedDataTable_Test {
    
    /***********************************************************************
    * @description  : Testsetup method to create test data.
    * @author     : Aress Software
    ***********************************************************************/   
    @testsetup
    public static void creattestdata(){
        Account accObj = New Account();
        accObj.Name= 'Aress SOftware';
        Insert accObj;
        
        List<Contact> conList = New List<Contact>();
        for(Integer i = 0 ; i<5; i++){
            
            Contact conObj = New Contact();
            conObj.LastName = 'John Doe';
            conObj.AccountId = accObj.Id;
            conList.add(conObj);
        }
        Insert conList;
    }
    
     
   /***********************************************************************
    * @description: Testmethod to cover mouseOver method of apex controller RelatedDataTable
    * @author     : Aress software
    ***********************************************************************/  
    @istest
    public static void test_mouseOver(){
        
        Account accObj = [SELECT Id,Name 
                       FROM ACCOUNT
                       LIMIT 1];
        
         List<Contact> conList=[SELECT Id,AccountId 
                                FROM CONTACT
                                WHERE AccountId =:accObj.Id];
        Test.startTest();
        RelatedDataTable.mouseOver('Contact',accObj.Id);
        RelatedDataTable.deleteRecord(conList[0].Id);
        Test.stopTest();
    }
}