public with sharing class calendar {
    public calendar() {

    }

    public class lines {
        @AuraEnabled public List<blocks> blks;
    }

    public class blocks {
        @AuraEnabled public String label;
        @AuraEnabled public List<items> tasks;
        @AuraEnabled public List<items> events; 
    }

    public class days {
        @AuraEnabled public String label;
    }

    public class cal {
        @AuraEnabled public List<String> days =  new List<String>{'Sunday',
                                                                 'Monday',
                                                                 'Tuesday',
                                                                 'Wednesday',
                                                                 'Thursday',
                                                                 'Friday',
                                                                 'Saturday' };
        @AuraEnabled public List<lines> dayNames;
        @AuraEnabled public List<lines> dayNumbers; 
        @AuraEnabled public Integer month; 
        @AuraEnabled public Integer year;  
        @AuraEnabled public String monthName;                                                    
    }
    
    public class parmaObject {
        public String action;
        public String recordId;
        public Integer month;
        public Integer year;  
    }

    public class items {
        @AuraEnabled public String description;
        @AuraEnabled public String Id;
        @AuraEnabled public String href;
    }


    @AuraEnabled(cacheable=true)
    public static cal fetchCalendar(String param){ //Integer month,Integer year,String action
        cal res = new cal();         
        parmaObject params = (parmaObject) JSON.deserialize(param,parmaObject.class) ;
        
        if(params.month<1) {
            params.month = Date.today().month();
        }

        if(params.year<1) {
            params.year = Date.today().year();
        }

        Date today = Date.newInstance(params.year,params.month,1); 
        
        if(params.action == 'next') {
            today = today.addMonths(1); 
        }

        if(params.action == 'prev') {
            today = today.addMonths(-1); 
        }

        Datetime dt = DateTime.newInstance(today, Time.newInstance(0, 0, 0, 0));  
 
        res.dayNames = new List<lines>();
        res.month = today.month();
        res.year = today.year();
        res.monthName = dt.format('MMMM');

        Lines lin = new Lines();
        lin.blks = new List<blocks>();

        for(String day : res.days) {
            blocks bk = new blocks();
            bk.label = day;
            lin.blks.add(bk);   
        } 
        res.dayNames.add(lin); 
                    
        String firstDay = dt.format('EEEE');
        Boolean nextLine = true;
        Boolean calStart = false;
        Integer dayNumber = 1;
        blocks bk;
        Integer dayIndex;
        items item;
        Id objectId = (Id) params.recordId;        
        Integer daysInMonth = Date.daysInMonth(today.year(),today.month());
        Map<Integer,List<items>> tasks = new Map<Integer,List<items>>();
        Map<Integer,List<items>> events = new Map<Integer,List<items>>();
        Map<String,List<items>> eventDateMappings = new Map<String,List<items>>(); 
        Date temp;
        Date endDate;
        Date startDate;
        String key;
        
        String taskSQL = 'select Id,Subject,Status,ActivityDate from Task ';
        taskSQL += 'where (WhoId=:objectId or whatId=:objectId ';
          
        String eventSQL = 'select Id,Subject,StartDateTime,EndDate from Event ';
        eventSQL += 'where (WhoId=:objectId or whatId=:objectId ';

        String sObjName = objectId.getSObjectType().getDescribe().getName();
        if(sObjName == 'Account') {
            taskSQL += ' or AccountId=:objectId';
            eventSQL += ' or AccountId=:objectId';
        }

        taskSQL += ') ';
        eventSQL += ') ';

        Date lastDAyOFmonth = Date.newInstance(today.year(),today.month(),daysInMonth);
        Integer currentMonth = today.month();

        taskSQL += '  and ActivityDate>=:today and ActivityDate<=:lastDAyOFmonth';       
        eventSQL += '  and ( CALENDAR_MONTH(StartDateTime) =:currentMonth  or ( CALENDAR_MONTH(EndDate)=:currentMonth)) ';
       
        for(Task task: Database.query(taskSQL)) {// and
            dayIndex = task.ActivityDate.day();
            if(tasks.get(dayIndex) == null) {
                tasks.put(dayIndex,new List<items>());
            }
            item = new items();
            item.description = task.Subject;
            item.id = task.Id;
            item.href = '/'+item.id;
            tasks.get(dayIndex).add(item);
        }


        
        for(Event evt: Database.query(eventSQL)) {              
            temp = Date.newInstance(evt.StartDateTime.Year(),evt.StartDateTime.month(),evt.StartDateTime.day()); 
            while(temp<=evt.EndDate) {
                key = String.valueOf(temp.Year())+''+String.valueOf(temp.month())+''+String.valueOf(temp.day());
                item = new items();
                item.description = evt.Subject;
                item.id = evt.Id;
                item.href = '/'+item.id;        
                
                if(eventDateMappings.get(key) == null) {
                    eventDateMappings.put(key,new List<items>());
                }

                eventDateMappings.get(key).add(item); 
                temp = temp.addDays(1);
            }
        }

        res.dayNumbers = new List<lines>();

        while(nextLine) {
            lin = new Lines();
            lin.blks = new List<blocks>();
            for(String day : res.days) {
                bk = new blocks();
                bk.label = '';
                if(firstDay == day) {
                    calStart = true;
                }

                if(dayNumber > daysInMonth) {
                    calStart = false;
                    nextLine = false;
                }

                if(calStart) {
                    bk.label = String.valueOf(Integer.valueOf(dayNumber));                    
                    if(tasks.get(dayNumber) != null) {
                        bk.tasks = tasks.get(dayNumber);
                    }

                    key = String.valueOf(today.Year())+''+String.valueOf(today.month())+''+String.valueOf(dayNumber);
                    if(eventDateMappings.get(key) != null) {
                        bk.events = eventDateMappings.get(key);
                    }
                    dayNumber++;
                }
                lin.blks.add(bk);   
            }
            res.dayNumbers.add(lin);
        }             
        return res;
    }     
}