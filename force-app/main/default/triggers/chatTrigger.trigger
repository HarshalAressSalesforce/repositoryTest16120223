trigger chatTrigger on chat__e (after insert) {
   if(Trigger.isAfter) {
       if(Trigger.isInsert) {
           objectConsoleManager.manageChats(Trigger.New);
       }
   }
}