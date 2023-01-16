public class listopportunities {
   @AuraEnabled
    public static List<Opportunity> listopportunities() {
        return [select Id,Name from Opportunity ];
        
    }
}