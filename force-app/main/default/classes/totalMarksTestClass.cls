@isTest

private class totalMarksTestClass {
    static testMethod void validateHelloWorld() {
        Student__c b = new Student__c(Total_Marks__c=100,total_Marks_Out_Of__c=500,Total_Subject__c=10);
        System.debug('Mark before inserting new book: ' + b.Total_Marks__c);
        // Insert book
        insert b;
        // Retrieve the new book
        b = [SELECT Total_Marks__c FROM Student__c WHERE Id =:b.Id];
        System.debug('Mark after trigger fired: ' + b.Total_Marks__c);
        // Test that the trigger correctly updated the price
        System.assertEquals(101, b.Total_Marks__c);
    }
}