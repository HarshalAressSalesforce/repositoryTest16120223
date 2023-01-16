public with sharing class cityHandler {
  @AuraEnabled
    public static AressH__City__c saveCity(AressH__City__c city) {
        // Perform isUpdatable() checking first, then
        upsert city;
        return city;
    }
}