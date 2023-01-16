trigger myPackageTrigger on Opportunity (before insert) {
   Opportunity[] opp = Trigger.new;   
   MyPackage.CheckMyPackage();
}