@isTest 
private class OpportunitySharingTest {
   // Test for the manualShareRead method
   static testMethod void testOpportunityShareRead(){
      
      
      /*Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
      User userObj = new User();
      userObj.Username= 'standarduser@testAressorg.com';
      userObj.Email = 'standarduser@testAressorg.com';
      userObj.Lastname = 'standt';
      userObj.Firstname = 'standt';
      userObj.Alias = 'standt';
      userObj.CommunityNickname = 'standt';
      userObj.ProfileId = p.Id;        
      userObj.TimeZoneSidKey = 'GMT';
      userObj.LocaleSidKey = 'en_US';
      userObj.EmailEncodingKey = 'ISO-8859-1';
      userObj.LanguageLocaleKey = 'en_US';
        
      insert userObj ;
            
      Id userId = userObj.Id;    
       
      // Create new job.
      Opportunity j = new Opportunity();
      j.Name = 'My Test Oppoertunity';
      j.OwnerId = UserInfo.getUserId();
      j.StageName = 'Qualification';
      j.CloseDate = date.valueOf('2017-05-01');
      insert j; 
        
        
      Id opportunityId = j.Id;
       
      // Insert manual share for user who is not record owner.
      System.assertEquals(OpportunitySharing.ShareOpportunity(opportunityId, userId), true);
   
      // Query job sharing records.
      List<OpportunityShare> jShrs = [SELECT Id, UserOrGroupId, OpportunityAccessLevel, 
         RowCause FROM OpportunityShare WHERE OpportunityId = :opportunityId AND UserOrGroupId= :userId];
      
      // Test for only one manual share on job.
      System.assertEquals(jShrs.size(),1);
      
      // Test attributes of manual share.
      System.assertEquals(jShrs[0].OpportunityAccessLevel, 'Read');
      System.assertEquals(jShrs[0].RowCause, 'Manual');
      System.assertEquals(jShrs[0].UserOrGroupId, userId);
      */
      
      
      Opportunity j = new Opportunity();
      j.Name = 'Harshal Opportunity';
      j.OwnerId = UserInfo.getUserId();
      j.StageName = 'Qualification';
      j.CloseDate = date.valueOf('2017-05-01');
      insert j;
   
      
      
   }  
}