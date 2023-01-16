public class OpportunitySharing {
   
   public static boolean ShareOpportunity(Id OpportunityId, Id userID){
       
      OpportunityShare oppShare = new OpportunityShare();
   
      oppShare.OpportunityId = OpportunityId;
      oppShare.OpportunityAccessLevel = 'Read';
      oppShare.UserOrGroupId = userID;
      oppShare.RowCause = 'Rule';
      Database.SaveResult sr = Database.insert(oppShare,false);
       

      // Process the save results.
      if(sr.isSuccess()){
         // Indicates success
         return true;
      }
      return false;
   }
   
   public static void preventAccess(Opportunity[] Opportunities) {
      for(Opportunity opp :Opportunities) {
         if(opp.Name.contains('Harshal')) {
            List<Group> groups = [select id,name from Group where Name= 'Sales Representative' ];
            for(Group groupName :groups ) {
              ShareOpportunity(opp.Id,groupName.Id);
            }            
         }      
      }
   }
   
}