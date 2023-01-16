trigger proceccMarkTrigger on Student__c (before insert,before update) {
    Student__c[] students = Trigger.new;
    proceccMarks.addTotalMarks(students);
}