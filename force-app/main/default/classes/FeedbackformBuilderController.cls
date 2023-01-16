public class FeedbackformBuilderController {
    List<Id> formClients= new List<Id>();
    
    public FeedbackformBuilderController () {
        system.debug(this.formClients.size());
         if(this.formClients.size()<=0) {                    
             Client__c client = [select Id, Name__c from Client__c order by Name ASC LIMIT 1];
             system.debug(client );
             this.formClients.add(client.Id);
        }
        
    }
    
    public List<Project__c> getProejcts() {
        List<Project__c> results = Database.query('SELECT Name FROM Project__c ORDER BY  Project Name ASC LIMIT 10');
        return results;
    }
    
    public List<SelectOption> getClients() {    
        
        List<SelectOption> options = new List<SelectOption>();
        for(List<Client__c> results : [select Id, Name__c from Client__c order by Name ASC ]) {
            for(Client__c client : results) {
                
               
                
                options.add(new SelectOption(client.Id,client.Name__c));
            }    
        }    
        return options;
    
    }
    
    public List<SelectOption> getDaysList() {
        List<SelectOption> options = new List<SelectOption>();
        Map<String,String> Days = new Map<String,String>();
        Days = this.getDays();
        for( String dayNumber : Days.KeySet()) {                
             options.add(new SelectOption(dayNumber,Days.get(dayNumber))); 
        }  
        return options;
    }
        
    public Map<String,String> getDays() {
        Map<String,String> days = new  Map<String,String>();
        days.put('1','Sunday');
        days.put('2','Monday');
        days.put('3','Tuesday');
        days.put('4','Wednesday');
        days.put('5','Thursday');
        days.put('6','Friday');
        days.put('7','saturday');
        return days;         
    }
    
    public List<SelectOption> getHoursList() {
        List<SelectOption> options = new List<SelectOption>();
        Map<String,String> hours = new Map<String,String>();
        hours = this.getHours();
        for( String hr: hours.KeySet()) {                
             options.add(new SelectOption(hr,hours.get(hr))); 
        }  
        return options;
    }
    
    
    public Map<String,String> getHours() {
        Map<String,String> hours = new  Map<String,String>();
        for(integer i=1;i<=24;i++) {
           hours.put(String.valueOf(i) ,String.valueOf(i));
        }        
        return hours;         
    }
    
    public List<Id> getformClients() {
        return formClients;
    }
      
    
    public void setformClients(List<Id> clients) {
         this.formClients= clients;
    }
    
    public void Save() {
       
    }
}