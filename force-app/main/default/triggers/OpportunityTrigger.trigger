trigger OpportunityTrigger on Opportunity (after insert) {
   Opportunity[] opp = Trigger.new;   
   OpportunitySharing.preventAccess(opp);
}