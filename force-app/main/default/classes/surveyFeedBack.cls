/*
Class Name: Class to handle the feedback of the user to the survey
Author: Aress
Version: 38.0 
*/


public class surveyFeedBack{
    public Feedback__c feedBackDetails {get;private set;}   // Object for survey details
    public Survey__c surveyDetails{get;private set;}   // Object for survey details

    public Map<Id,List<SelectOption>> surveyQuestionListOptions { get ; private set;} // Array of the options of the selected question 
    public Map<Id,List<String>> surveyQuestionOptions { get ; private set;} // Array of the options of the selected question 
    Map<Integer,surveyQuestionWrapper> surveyQuestionWrapper{get;Set;}

    public String strSelected  {get;set;}
    public List<SelectOption> options {get;set;}
    public String searchByEmail { get; set; }

    /*  
* Controller to fetch the question list            
*/ 
    public ApexPages.StandardSetController con {
        get {
            if(con == null) {                 
                con = new ApexPages.StandardSetController(Database.getQueryLocator([select Id,surveyId__r.Name,SurveyRecipientId__r.email__c,SurveyRecipientId__r.typeOfRecipient__c, userId__r.Email from feedback__c where surveyId__c !=null ]));
                // sets the number of records in each page set
                con.setPageSize(surveyConfigs.numberOfRecordPerPage);
            }
            return con;
        }
        set;
    }

    /*  
* Checks whether the current user has attempted the selected survey or not
*
* @param   Id surveyId
* @return Boolean
*/
    public static boolean userHasAttemptedSurvey(Id surveyId) {
        String userId = UserInfo.getUserId();
        List<Feedback__c> feedBackDetails =  [SELECT Id FROM Feedback__c WHERE surveyId__c =:surveyId and  userId__c =: userId ];
        if(feedBackDetails.size() > 0) {
            return true;        
        }
        return false;
    }

    /*  
* Checks whether the current user has attempted the selected survey or not
*
* @param   Id surveyId
* @return Boolean
*/
    public static boolean recipientHasAttemptedSurvey(Id surveyId, Id recptId) {
        List<Feedback__c> feedBackDetails =  [SELECT Id FROM Feedback__c WHERE surveyId__c =:surveyId and  surveyRecipientId__c =: recptId];
        if(feedBackDetails.size() > 0) {
            return true;        
        }
        return false;
    }

    /*  
* Inserts the new feedback for the current logged in user
*
* @param   Id surveyId
* @return Id
*/  
    public static Id addFeedBack(Id surveyId) {
        String userId = UserInfo.getUserId();
        Feedback__c feedBack = new Feedback__c();
        feedBack.surveyId__c = surveyId;
        feedBack.userId__c = (Id) userId ;
        insert feedBack;
        return  feedBack.Id;
    }

    /*  
* Inserts the new feedback for the current logged in user
*
* @param   Id surveyId
* @return Id
*/  
    public static Id addRecipientFeedBack(Id surveyId, Id recptId) {
        Feedback__c feedBack = new Feedback__c();
        feedBack.surveyId__c = surveyId;
        feedBack.surveyRecipientId__c = (Id) recptId ;
        insert feedBack;
        return  feedBack.Id;
    }

    /*  
* List the questions of the system
*
* @param   
* @return List<Question__c>
*/ 
    public List<Feedback__c> getfeedBackList() {            
        system.debug('Record - '+con.getRecords());
        return (List<Feedback__c> ) con.getRecords();
    } 


    /*  
* Loads the selected feedback details
*
* @param  Id FeedbackId
* @return 
*/  

    public void loadFeedback () {

        Id id= ApexPages.currentPage().getParameters().get('id');

        if(id != null) {         
            try {
                List<Feedback__c> feedbackData = [select Id,surveyId__c,    SurveyRecipientId__c, userId__c from Feedback__c where Id=:id limit 1 ];             

                if(feedbackData .size() > 0 ) {
                    feedBackDetails = feedbackData [0]; 
                    
                    
                    List<Survey__c> surveyData = [select Id,Name,Description__c,sentDate__c  from Survey__c  where Id=:feedBackDetails.surveyId__c limit 1 ];             
                        if(surveyData.size() > 0 ) {
                          surveyDetails = surveyData[0]; 
                        }                              
                   } 




            } catch(Exception e) {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()); 
                ApexPages.addMessage(myMsg);  
            }
        }   


    }

    /*  
* Get the responses of the selected feedback
*
* @param   Id FeedbackId
* @return 
*/    
    public Map<Integer,surveyQuestionWrapper> getUserFeedback() {
        Map<String,String> response = new Map<String,String>();

        if(feedBackDetails != null) {

            Map<Id,List<SelectOption>> options = new Map<Id,List<SelectOption>>();
            Map<Id,List<String>> QuestionOptions = new Map<Id,List<String>>(); 

            if(surveyQuestionWrapper == null) {
                surveyQuestionWrapper = new Map<Integer,surveyQuestionWrapper>();
            } 

            Integer count = 0;

            for(List<FeedbackDetail__c> FeedbackDetails : [select Id,questionId__c, response__c from FeedbackDetail__c where feedbackId__c =:feedBackDetails.Id ]) {

                for(FeedbackDetail__c details : FeedbackDetails ) {
                    List<Question__c> questionData = [select Id,Question__c,typeOfQuestion__c from Question__c where Id=:details.questionId__c limit 1];
                    if(questionData.size() > 0) {
                        try {
                            Question__c questionDetails = questionData[0];

                            if(questionDetails.typeOfQuestion__c == 'free_text') { 
                                surveyQuestionWrapper.put(count,new surveyQuestionWrapper(questionDetails,details.response__c)); 
                            }  

                            if(questionDetails.typeOfQuestion__c == 'radio') { 
                                surveyQuestionWrapper.put(count,new surveyQuestionWrapper(questionDetails,Id.valueOf(details.response__c))); 
                            }

                            if(questionDetails.typeOfQuestion__c == 'slider') { 
                                List<questionOptions__c > optionData = [select  option__c from questionOptions__c where id=: details.response__c limit 1];
                                if(optionData != null && optionData.size() > 0 ) {
                                    surveyQuestionWrapper.put(count,new surveyQuestionWrapper(questionDetails,optionData[0].option__c )); 
                                }                              
                            }  



                            List<questionOptions__c> option = questionBank.getOptionsByQuestionId(questionDetails.Id);

                            if(option != null && option.size() > 0) { 
                                if(questionDetails.typeOfQuestion__c == 'radio') {
                                    List<SelectOption> optionList = new List<SelectOption>(); 
                                    for(questionOptions__c optionItem : option ) {
                                        if(optionItem.option__c != null) {
                                            optionList.add(new SelectOption(optionItem.Id,optionItem.option__c)); 
                                        }
                                    }
                                    options.put(questionDetails.Id,optionList);
                                }

                                if(questionDetails.typeOfQuestion__c == 'slider') {
                                    List<String> sliderOptions = new List<String>(); 
                                    for(questionOptions__c optionItem : option ) {
                                        if(optionItem.option__c != null) {
                                            //sliderOptions.add( Integer.valueof(optionItem.option__c.trim())); 
                                            sliderOptions.add( optionItem.option__c.trim()); 
                                        }
                                    }  
                                    //sliderOptions.sort();
                                    QuestionOptions.put(questionDetails.Id,sliderOptions);                        
                                }                        
                            }
                        } catch(Exception e) { 
                            system.debug(e);
                        } 
                        count++;
                    } 
                }
            }  

            surveyQuestionListOptions =  options;
            surveyQuestionOptions =  QuestionOptions;            
        }

        return surveyQuestionWrapper;  

    }  

    //Load picklist on page load

    public surveyFeedBack()    // only display surveys whose feedback is given
    {
        strSelected = '';
        options = new List<SelectOption>(); 
        for(Survey__c survey : [SELECT Name,id FROM Survey__c])
          {
           options.add(new SelectOption(survey.id, survey.name));
          }
    }


    //Load picklist on page load
   /* public surveyFeedBack()    / only display surveys whose feedback is given
    {
        strSelected = '';
        options = new List<SelectOption>(); 
        Integer i=0;
        for(list<AggregateResult> obj :[SELECT surveyId__c FROM Feedback__c GROUP BY surveyId__c])
        {
            while(i <= obj.size()-1){
                Id  surveyId = (Id)obj[i].get('surveyId__c');
                List<Survey__c> surveys = [SELECT Name FROM Survey__c WHERE Id=:surveyId];
                If(surveys.size() > 0){
                    options.add(new Selectoption(surveyId,surveys[0].Name));
                }
                i++;
            }
        }
    } */

    public void fromSurveyList(){
    Id searchId = ApexPages.currentPage().getParameters().get('sId');
        If(searchId != null){
            strSelected = searchId;
        }else{
            strSelected  = null;
        }
        searchFeedback();
    }

    public void searchFeedback(){
        String searchText;
        String tempText;
        String tempEmail;

        if(strSelected != null && searchByEmail == null) {
            survey__c n = [SELECT name FROM survey__c WHERE Id=:strSelected];
            searchText = n.name;
            tempText = '%' + searchText + '%';
            con = new ApexPages.StandardSetController(Database.getQueryLocator([SELECT Id,surveyId__r.Name,userId__r.Email,surveyRecipientId__r.email__c,surveyRecipientId__r.typeOfRecipient__c 
                                                                                FROM Feedback__c 
                                                                                WHERE surveyId__c =:strSelected]));
            con.setPageSize(surveyConfigs.numberOfRecordPerPage);
        }else if(strSelected == null && searchByEmail != null) {
            tempEmail = '%' + searchByEmail + '%';
            con = new ApexPages.StandardSetController(Database.getQueryLocator([SELECT Id,surveyId__r.Name,userId__r.Email,surveyRecipientId__r.email__c,surveyRecipientId__r.typeOfRecipient__c 
                                                                                FROM Feedback__c 
                                                                                WHERE userId__r.Email LIKE :tempEmail OR surveyRecipientId__r.email__c LIKE :tempEmail]));
            con.setPageSize(surveyConfigs.numberOfRecordPerPage);
        }else if(strSelected != null && searchByEmail != null){
            survey__c n = [SELECT name FROM survey__c WHERE Id=:strSelected];
            searchText = n.name;
            tempText = '%' + searchText + '%';
            tempEmail = '%' + searchByEmail + '%';
            //system.debug([SELECT Id,surveyId__r.Name,userId__r.Email,surveyRecipientId__r.userId__c 
            //              FROM Feedback__c 
            //              WHERE surveyId__c =:strSelected AND 
            //              (userId__r.Email LIKE :tempEmail OR surveyRecipientId__r.userId__c LIKE :tempEmail)]);

            con = new ApexPages.StandardSetController(Database.getQueryLocator([SELECT Id,surveyId__r.Name,userId__r.Email,surveyRecipientId__r.email__c,surveyRecipientId__r.typeOfRecipient__c 
                                                                                FROM Feedback__c 
                                                                                WHERE surveyId__c =:strSelected AND 
                                                                                (userId__r.Email LIKE :tempEmail OR surveyRecipientId__r.email__c LIKE :tempEmail)]));
            con.setPageSize(surveyConfigs.numberOfRecordPerPage);
        }else{
            con = new ApexPages.StandardSetController(Database.getQueryLocator([SELECT Id,surveyId__r.Name,userId__r.Email,surveyRecipientId__r.email__c FROM Feedback__c]));
            con.setPageSize(surveyConfigs.numberOfRecordPerPage);
        }   
    }

    public PageReference Reload() {
     PageReference feedbacks = Page.feedBacks;
        feedbacks.setRedirect(true);
        return feedbacks; 
    }
}