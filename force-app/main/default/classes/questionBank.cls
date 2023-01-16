/*
Class Name: Class to handle the question related activites
Description: Handles all the question related activites of the app.
Author: Aress
Version: 38.0 
*/


public class questionBank {
    
    public String questionType {get;set;} // Question type - Radio/slider/ Free Text
    public String question {get;set;} // Text of the question
    public Boolean  questionStatus {get;set;}   // Whether the question is active or not
    public String selectedOptions{get;set;}    // Text containing all the options of the question
    public String successMessage {get;set;}  // Suucessmessage for the vf page
    public String searchFilter {get;set;}  // search filter string from question listing page 
    public static Boolean validatedFailed{get;set;} // Determines whether the validation failr or not   
    public Question__c questionDetails{get;private set;}   // Object for question details
    public String editID {get;set;}  // ID of the question to edit   
    public boolean deleteStart{get;private set;} // Flag to determine dete process is started or not   
    private final surveyQuestions surveyQuestion; // Object where we have have used this class as extension
    public List<String> statuses = new List<String>();  // Statuses of the question
    public Boolean IsSubmiited{get{return false;}set;}
    
    /*  
* Constructor for the class where we have have used this class as extension            
*/ 
    public questionBank (surveyQuestions surveyQuestion) {
        this.surveyQuestion = surveyQuestion;
    }
    
    
    private final surveyFeedBack surveyFeedBack; // Object where we have have used this class as extension
    
    /*  
* Constructor for the class where we have have used this class as extension            
*/ 
    public questionBank (surveyFeedBack surveyFeedBack) {
        this.surveyFeedBack= surveyFeedBack;
    }
    /*  
* Constructor
*
* @param   
* @return  
*/ 
    public questionBank() {
        questionStatus = true;
        successMessage = '';
    }
    
    
    public Map<String,String> updateOptions = new Map<String,String>();  // Array of the options of the selected question      
    String[] options = new String[]{}; // Array of the options of the question  
        
        /*  
* Controller to fetch the question list            
*/ 
        public ApexPages.StandardSetController con {
            get {
                if(con == null) {                 
                    con = new ApexPages.StandardSetController(Database.getQueryLocator([select Id,name,Question__c from Question__c  order by createdOn__c desc NULLS LAST]));
                    // sets the number of records in each page set
                    con.setPageSize(surveyConfigs.numberOfRecordPerPage);
                }
                return con;
            }
            set;
        }
    
    /*  
* Filters the question according to the provide search text
*
* @param  search text
* @return  
*/   
    public void search() {
        if(searchFilter != null) {
            string tempInput = '%' + searchFilter + '%';
            con = new ApexPages.StandardSetController(Database.getQueryLocator([SELECT Id,name,Question__c FROM Question__c WHERE Question__c LIKE :tempInput order by createdOn__c desc]));
            con.setPageSize(surveyConfigs.numberOfRecordPerPage);
        }   
    }
    
    /*  
* List the questions of the system
*
* @param   
* @return List<Question__c>
*/ 
    public List<Question__c> getQuestions() {            
        
        
        String msg = Apexpages.currentPage().getParameters().get('m');
        if(msg != null) {
            Integer messageNumber = Integer.valueOf(msg );
            if(messageNumber != null) {
                if (messageNumber == 2) {
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Question has been successfully updated.'); 
                    ApexPages.addMessage(myMsg);         
                }
                
                if (messageNumber == 1) {
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Question has been successfully inserted.'); 
                    ApexPages.addMessage(myMsg);         
                }
                
                if (messageNumber == 3) {
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM, 'You can now delete the question.'); 
                    ApexPages.addMessage(myMsg);         
                }
            }
        }
        
        
        
        
        return (List<Question__c> ) con.getRecords();
    } 
    
    
    
    /*  
* returns the options of the selected question
*
* @param   
* @return array
*/ 
    public Map<String,String> getQuestionOptions() {              
        return updateOptions;
    }
    
    /*  
* returns the options of the selected question
*
* @param  questionId  
* @return List<questionOptions__c>
*/ 
    public static List<questionOptions__c> getOptionsByQuestionId(Id questionId ) {
        try {  
            List<questionOptions__c>  questionOptions = [select Id, option__c from questionOptions__c where Question__c =: questionId ];
            return questionOptions ;
        } catch(Exception e) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()); 
            ApexPages.addMessage(myMsg);  
        }
        return null;    
    }
    
    /*  
* Loads the question data for edit purpose
*
* @param  questionId  
* @return 
*/ 
    public void loadQuestionDetails() {
        Id Id = ApexPages.currentPage().getParameters().get('id');
        if(Id != null) {         
            try {
                List<Question__c> questDetails = [select Id,name,Question__c,Status__c,typeOfQuestion__c  from Question__c where Id=:Id limit 1];
                
                if(questDetails.size() <= 0 ) {
                    successMessage = 'No record found';
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,successMessage ); 
                    ApexPages.addMessage(myMsg);       
                } else {
                    questionDetails = questDetails[0]; 
                    editID = questionDetails.Id; 
                    question = questionDetails.Question__c ; 
                    questionStatus= questionDetails.Status__c ;
                    questionType = questionDetails.typeOfQuestion__c ;  
                    if(questionType != 'free_text') {
                        processQuestionOptions(editID ); 
                    }                             
                } 
            } catch(Exception e) {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()); 
                ApexPages.addMessage(myMsg);  
            }
        }   
    }
    
    /*  
* Manages the options of the selected question
*
* @param  questionId  
* @return 
*/ 
    public void processQuestionOptions(Id questionId) {
        List<questionOptions__c> questOptions =  getOptionsByQuestionId(questionId);
        
        updateOptions = new Map<String,String>();
        if(!questOptions.isEmpty()) {
            for(questionOptions__c option : questOptions ) {                                                    
                if(option.option__c != null) {
                    updateOptions.put(option.Id,option.option__c);
                }
            }                                           
        }
    }
    
    
    /*  
* Updates the selectd question
*
* @param  
* @return 
*/ 
    public PageReference editQuestion() { 
        IsSubmiited = true;
        questionDetails.Question__c = question;
        questionDetails.Status__c = questionStatus;
        questionDetails.typeOfQuestion__c = questionType;
        try {
            update questionDetails;       
            addQuestionOptions(questionDetails.id);           
            processQuestionOptions(questionDetails.id ); 
            
            
            
            
            
            PageReference redirectPage = Page.manageQuestions;
            redirectPage .getParameters().put('m', '2');
            redirectPage.setRedirect(true);
            return redirectPage;   
            
            
            
            
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM,'Question has been successfully updated.'); 
            ApexPages.addMessage(myMsg);
        } catch(Exception e) {
            system.debug(e);
        }   
        return null;
    }
    
    
    /*  
* Adds the option to the selected question
*
* @param  questionId
* @return 
*/ 
    public void addQuestionOptions(Id questionId) {
        try {
            if(selectedOptions != null) {
                String[] questOptions  = selectedOptions.split(',');         
                
                Integer i;
                Integer length= questOptions.size();
                
                List<questionOptions__c> newQuestionOptions = new List<questionOptions__c>(); 
                List<questionOptions__c> oldQuestionOptions = new List<questionOptions__c>(); 
                
                for (i=0;i<length;i++ ) {
                    if(questOptions[i] != null ||  questOptions[i] != '') {
                        questionOptions__c questOpt = new questionOptions__c();
                        questOpt.option__c = questOptions[i];
                        questOpt.Name= questOpt.option__c ;
                        questOpt.Question__c = questionId;                  
                        
                        list<questionOptions__c> optionList = [select Id from questionOptions__c where Question__c =: questionId AND option__c =: questOpt.option__c limit 1];
                        
                        if(optionList.size() > 0 ) {
                            questionOptions__c optionDetails = optionList[0];
                            optionDetails.option__c = questOpt.option__c;
                            optionDetails.Name= questOpt.Name ;
                            oldQuestionOptions.add(optionDetails);
                        } else {
                            newQuestionOptions.add(questOpt);  
                        } 
                    }                            
                }
                
                
                if(newQuestionOptions.size() > 0) {
                    insert newQuestionOptions; 
                } 
                
                if(oldQuestionOptions.size() > 0) {
                    update oldQuestionOptions; 
                }    
            }                              
        } catch(Exception e){
            
        } 
    } 
    
    
    /*  
* Deletes the selected question
*
* @param  
* @return 
*/ 
    public PageReference deleteQuestion() {
         
        
        Id questionId = (Id) Apexpages.currentPage().getParameters().get('questionId');
        //---------------------
        //List of survey to which the question is allocated
        List<SurveyQuestion__c> surveyAllocations = [SELECT id, SurveyId__c FROM SurveyQuestion__c WHERE questionId__c = :questionId];
        //Redirect to questionAllocations page if the question is allocated to atleast one survey
        if(surveyAllocations.size()>0){
            PageReference allocationListing = new PageReference('/apex/questionAllocations?qId='+questionId);//Page.questionAllocations;
            //allocationListing.getParameters().put('qId', questionId);
            allocationListing.setRedirect(true);
            return allocationListing;
        }
        //---------------------
        if(questionId!=null){
            try {
                
                List<Question__c> questDetails = [select Id,name,Question__c,Status__c,typeOfQuestion__c  from Question__c where Id=:questionId limit 1];
                if(questDetails.size() > 0 ) {
                    Question__c questionData = questDetails[0];
                    List<questionOptions__c> questOptions =  getOptionsByQuestionId(questionId);
                    if(!questOptions.isEmpty()) {
                        List<questionOptions__c> options = new List<questionOptions__c>();
                        for(questionOptions__c option : questOptions ) {                                                    
                            options.add(option);
                        }   
                        delete options;                                        
                    }
                    
                    list<FeedbackDetail__c> feedBackDetails = new list<FeedbackDetail__c>();
                    for(list<FeedbackDetail__c > feedbackDetailsList : [select Id, feedbackId__c from FeedbackDetail__c where  questionId__c =: questionId  ]) {
                        for(FeedbackDetail__c feedBack : feedbackDetailsList ) { 
                            feedBackDetails.add(feedBack );  
                        }
                    }
                    delete feedBackDetails;
                    delete questionData;
                    //getQuestions();
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Question deleted successfully'); 
                    ApexPages.addMessage(myMsg);
                    //return null;
                    //PageReference redirectPage = Page.manageQuestions; 
                    //redirectPage.setRedirect(true);
                    //return redirectPage;  
                    
                }      
            } catch(Exception e) {
                system.debug(e);
            }
        }
        return null;
    }
    
    
    /*  
* Deletes the selected option
*
* @param  
* @return 
*/ 
    public void deleteOption() {
        deleteStart = true;
        Id optionId = (Id) Apexpages.currentPage().getParameters().get('optionId');      
        try {
            if(optionId != null) {
                List<questionOptions__c > optionData = [select Id, option__c, Question__c  from questionOptions__c where id=: optionId limit 1];
                if(optionData != null) {
                    questionOptions__c optionDetails = optionData[0];
                    Id questionID = optionDetails.Question__c;
                    delete optionDetails;
                    processQuestionOptions(questionID ); 
                }
            }
        } catch(Exception e) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()); 
            ApexPages.addMessage(myMsg); 
        }
    }
    
    
    /*  
* Assigns the questions to the selected survey
*
* @param  
* @return 
*/ 
    public static void allocateQuestionToSurvey(Id surveyId,Id questionId) {
        if(surveyId != null) {
            List<Survey__c > surveyDetails = [select Id from Survey__c where Id =: surveyId limit 1];
            
            if(surveyDetails.size() > 0 ) {
                Survey__c  surveyData  = surveyDetails[0];                   
                list<SurveyQuestion__c> questionList = [select Id from SurveyQuestion__c where questionId__c =: questionId AND surveyId__c =: surveyId limit 1];
                Decimal maxValue = (Decimal)[Select MAX(sortOrder__c)val FROM SurveyQuestion__c WHERE surveyId__c =: surveyId][0].get('val');   
                if(questionList.size() <= 0 ) {
                    SurveyQuestion__c  surveyQuestion = new SurveyQuestion__c ();
                    surveyQuestion.questionId__c = questionId;
                    surveyQuestion.surveyId__c = surveyData.Id;
                    if(maxValue == null){
                        surveyQuestion.sortOrder__c = 1;
                    }else{
                        surveyQuestion.sortOrder__c = maxValue + 1;
                    }
                    insert surveyQuestion ; 
                }                       
            }  
        }
    }
    
    
    /*  
* Adds the new question
*
* @param  
* @return 
*/ 
    public PageReference addQuestion() {    
        IsSubmiited = true;
        Question__c questionObject = new Question__c();
        questionObject.Question__c = question;
        questionObject.Status__c = questionStatus;
        questionObject.typeOfQuestion__c = questionType;
        questionObject.createdOn__c = Date.today();
        try{
            insert questionObject; 
            addQuestionOptions(questionObject.id); 
            questionType  = null;
            question =  null;
            questionStatus = null;
            selectedOptions = null; 
            Id surveyId= (Id) Apexpages.currentPage().getParameters().get('surveyId');
            if(surveyId != null) {
                allocateQuestionToSurvey(surveyId,questionObject.id);
            }  else {
                PageReference redirectPage = Page.manageQuestions;
                redirectPage .getParameters().put('m', '1');
                redirectPage.setRedirect(true);
                return redirectPage;  
            }  
            
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM,'Question has been successfully inserted.'); 
            ApexPages.addMessage(myMsg);                  
            
        } catch(Exception e){
            system.debug(e);
        }            
        
        return null;
    } 
    
    
    /*  
* Action will be called as the user will click on the 'Create Questionnaire' button
*
* @param  
* @return 
*/ 
    public PageReference createSurveyQuestionnaire() {
        validatedFailed = false;
        if(question == null || question == '') {
            validatedFailed = true;
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Question should not be empty.'); 
            ApexPages.addMessage(myMsg);   
        } else {
            addQuestion();
        }
        return null;
    }
    
    /*  
* Navigation function to take the user to create new question page
*
* @param  
* @return 
*/ 
    public PageReference createQuestion()   {
        PageReference redirectPage = Page.createQuestion;
        redirectPage.setRedirect(true);
        return redirectPage;
        return null;  
    }
    
    
    /*  
* List all the statuses of the question
*
* @param  
* @return 
*/ 
    public String[] getStatuses () {
        if(!statuses.isEmpty()) {
            return statuses;
        }
        return null;
    }
    
    /*  
* Set the selected statuses to the question
*
* @param  
* @return 
*/ 
    public void setStatuses (List<String> statuses ) {
        this.statuses = statuses ;       
    }
    
    /*  
* List the optios for the question
*
* @param  
* @return 
*/ 
    public String[] getOptions() {
        
        if(!options.isEmpty()) {
            return options;
        }
        return null;
    }
    
    /*  
* Set the optios to the question
*
* @param  
* @return 
*/ 
    public void setOptions(String[] options ) {
        this.options = options ;
    } 
    
    public PageReference Reload() {
        PageReference manageQuestions = Page.manageQuestions;
        manageQuestions.setRedirect(true);
        return manageQuestions; 
    }
    
}