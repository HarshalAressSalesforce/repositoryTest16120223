trigger triggerUpDateStudentPresenty on Student_Attendaces__c (before insert, after insert) {
   if(trigger.isAfter && trigger.isInsert) {
       processStudentPresenty.incrementTotalPresenty(Trigger.new);
   }
   
   if(trigger.isBefore && trigger.isInsert) {
       processStudentPresenty.ClearDuplicates(Trigger.new);
   }
}