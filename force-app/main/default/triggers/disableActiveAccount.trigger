trigger disableActiveAccount on Contact (before update,after update) {
    List<Account> deactivatedAccounts = new  List<Account>();
    if(Trigger.isBefore) {
        if(Trigger.isUpdate) {            
            for(Contact cnt :[select accountId from Contact where Id IN : Trigger.new and Account.AressH__Active__c='No']) {
                deactivatedAccounts.add(new Account(Id=cnt.accountId,
                                                    AressH__Active__c='Yes'));
            }
            system.debug('9--->'+deactivatedAccounts);
            update deactivatedAccounts;
        }
    }
    
    if(Trigger.isAfter) {
       system.debug('9--->'+deactivatedAccounts);
        if(Trigger.isUpdate) {
            system.debug('9--->'+deactivatedAccounts);
            deactivatedAccounts = new  List<Account>();
            for(Contact cnt :[select accountId from Contact where Id IN : Trigger.new and Account.AressH__Active__c='No']) {
                deactivatedAccounts.add(new Account(Id=cnt.accountId,
                                                    AressH__Active__c='No'));
            }
            
            update deactivatedAccounts;
            system.debug('9--->'+deactivatedAccounts);
            
        }
    }
}