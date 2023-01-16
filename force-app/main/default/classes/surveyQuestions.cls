/*
Class Name: Class to handle the assignment of the questions to the survey
Description: Handles the assignment of the questions to the survey
Author: Aress
Version: 38.0 
*/


public class surveyQuestions{
   public String surveyQuestionOption {get;private set;} // List the option of the selected question
   public Boolean isCreateNewOption{get;private set;} // Determines whether the admin has selected  'Create New Question' option
   public Boolean isQuestionFromLibrary{get;private set;} // Determines whether the admin has selected  'library option
   public Boolean isDefaultList{get;set;} // Determines whether the admin has selected  'library option
   
   public Boolean surveyAllocated {get { return false;}private set;} // Determines to show the message or not
   
   List<questionWrapper> questions{get;set;}   // Checkbox wrapper for the question listing
  
   Map<Integer,surveyQuestionWrapper> surveyQuestionWrapper{get;Set;}
  
   public String questionSearchFilter {get;set;} // Filter for the question listing
   
   public Id questionId {get;set;}
   
   public Survey__c surveyDetails{get;private set;}   // Object for survey details
   //public Map<Id,Question__c> questionOptions = new Map<Id,Question__c>();  // Array of the options of the selected question   
   
   public Map<Id,Question__c> surveyQuestions = new Map<Id,Question__c>();  // Array of the options of the selected question 
   public Map<Id,List<SelectOption>> surveyQuestionListOptions { get ; private set;} // Array of the options of the selected question 
   public Map<Id,List<String>> surveyQuestionOptions { get ; private set;} // Array of the options of the selected question 
   
   public Boolean surveySubmitted{get;private set;}
   public Boolean surveyHasQuestions{get ; private set;}
    
   public Id recptId{get;private set;}
    
   public Id firstQuestionId{get;private set;}
   public Id lastQuestionId{get;private set;}
   
   public Decimal questionCount{get;private set;}
   public Boolean canUseLibrary{get;private set;} 
   
   public static Id reportQuestionId;
   public static  Id surveyQuestionId;
  
   public surveyQuestions() {
       isDefaultList = true;
   } 
   /*  
     * Filters the question according to the provide search text
     *
     * @param  
     * @return  
   */  
   public void searchSurveyQuestion() {
      if(questionSearchFilter != null) {
          getQuestionLibrary();          
      }   
   }
   
   /*  
     * List the question which are not allocated to the selected survey
     *
     * @param  
     * @return  
   */  
   public List<questionWrapper> getQuestionLibrary() {
        questions= new List<questionWrapper>();  
        Id surveyId= (Id) Apexpages.currentPage().getParameters().get('surveyId');
        Set<Id> questionIDs = getQuestions(surveyId);
        
        
        if(questionSearchFilter != null) {                  
            string tempInput = '%' + questionSearchFilter + '%';
            for(List<Question__c> question : [select Id,name,Question__c from Question__c where Question__c LIKE :tempInput and Id NOT IN : questionIDs]) {
                for(Question__c ques : question ) {
                    questions.add(new questionWrapper(ques));
                }  
            }
        }  else {
             for(List<Question__c> question : [select Id,name,Question__c from Question__c where Id NOT IN : questionIDs]) {
                for(Question__c ques : question ) {
                    questions.add(new questionWrapper(ques));
                }  
            }        
        }  
        questionCount = questions.size();
        canUseLibrary = (questionCount==0)? false:true;
        return questions;
    }
    
    
    /*  
     * Assigns the question to the selected survey
     *
     * @param  
     * @return  
   */  
    public PageReference processQuestionLibrary() {        
       try {
           surveyAllocated  = true;
           Id surveyId = (Id) Apexpages.currentPage().getParameters().get('surveyId');          
           
           Boolean questionChecked = false;
           
           for(questionWrapper question : questions) {
                if(question.checked) {
                    questionChecked = true;
                    if(surveyId != null) {                         
                        questionBank.allocateQuestionToSurvey(surveyId,question.question.Id);
                    }                  
                } 
           } 
           
           ApexPages.Message myMsg;
           if(questionChecked) {
               myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM,'Question has been successfully assigned to survey.'); 
           } else {
               myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please select the question for survey.');
           }
           
           ApexPages.addMessage(myMsg);   
           
      } catch(Exception e){
          ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()); 
      }            
      return null;
    }
    
    
    /*  
     * Action to take the user to create new question option
     *
     * @param  
     * @return  
   */  
   public void initDefaultList() {
     isCreateNewOption = false;
     isQuestionFromLibrary = false;
     isDefaultList = true;
   }
   
   
   /*  
     * Action to take the user to create new question option
     *
     * @param  
     * @return  
   */  
   public void selectCreateNewQuestion() {
     isCreateNewOption = true;
     isQuestionFromLibrary = false;
     questionBank.validatedFailed = false; 
     isDefaultList = false;
   }
   
   
   /*  
     * Action to take the user to question library option
     *
     * @param  
     * @return  
   */       
   public void selectQuestionFromLibrary() {
     isCreateNewOption = false;
     isQuestionFromLibrary = true;
     questionBank.validatedFailed = false;
     isDefaultList = false;
   }
   
   /*  
     * Action to take the user to manage receipients page
     *
     * @param  
     * @return  
   */  
   public PageReference gotoManageReceipients() {
     Set<Id> questionIDs = getQuestions(surveyDetails.Id);
     
     if(questionIDs.size()>0) {
         Id surveyId= (Id) Apexpages.currentPage().getParameters().get('surveyId');
      
         List<Survey__c> surveyDetails = [SELECT Id, currentState__c FROM Survey__c WHERE Id =: surveyId];
         if(surveyDetails.size() > 0) {
             Survey__c surveyData = surveyDetails[0];
             surveyData.currentState__c++;
             update surveyData ;
          }
         
          PageReference redirectPage = Page.SBRecipient;
          redirectPage.getParameters().put('surveyId',surveyId);
          redirectPage.setRedirect(true);
          return redirectPage; 
     } else {
         
         ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please assign at least one question to survey.');
         ApexPages.addMessage(myMsg);
         
     }
      
      return null;
      
   }
   
   /*  
     * Lists the question ids for the selected survey
     *
     * @param  Id surveyId
     * @return  Set<Id>
   */  
   public static Set<Id> getQuestions(Id surveyId ) {      
        Set<Id> questionIDs = new Set<Id>();          
        if(surveyId != null) {
           for(list<SurveyQuestion__c> questionList : [select questionId__c from SurveyQuestion__c where  surveyId__c =: surveyId ]) {
               for(SurveyQuestion__c queestion : questionList ) {
                  questionIDs.add(queestion.questionId__c );
               }
           }            
        }
        return questionIDs;
   }
   
   
  public List<Question__c> getListOfSurveyQuestions() {
       LIST<Question__c> newQuestions = new LIST<Question__c>();
       LIST<SurveyQuestion__c> objects = [SELECT questionId__c                                  
                                          FROM surveyQuestion__c
                                          WHERE surveyId__c = :surveyDetails.Id AND questionId__r.status__c = true order by sortOrder__c];
     
       if(objects.size() > 0) {
            for(SurveyQuestion__c s:objects){
                LIST<Question__c> question = [SELECT Id , Question__c                                  
                                          FROM Question__c
                                          WHERE Id  = :s.questionId__c ];
               
                if(question.size() > 0) {
                    newQuestions.add(question[0]);
                } 
            } 
       }
      initQuestionOrdering();
       return newQuestions;
  }
   
   /*  
     * Builds the list of the question for the selected survey
     *
     * @param   
     * @return Map<Integer,surveyQuestionWrapper>
   */    
   public Map<Integer,surveyQuestionWrapper> getquestionList() {
      // Set<Id> questionIDs = getQuestions(surveyDetails.Id);
       LIST<Question__c> newQuestions = new LIST<Question__c>();
        
       LIST<SurveyQuestion__c> objects = [SELECT questionId__r.typeOfQuestion__c,questionId__r.Name,questionId__r.id,questionId__r.question__c                                   
                                           FROM surveyQuestion__c
                                           WHERE surveyId__c = :surveyDetails.Id AND questionId__r.status__c = true order by sortOrder__c];
                                           
                                                  
        initQuestionOrdering();
        
        for(SurveyQuestion__c s:objects){
            newQuestions.add(s.questionId__r);
        }
        
       
       
       Map<Id,List<SelectOption>> options = new Map<Id,List<SelectOption>>();
       Map<Id,List<String>> QuestionOptions = new Map<Id,List<String>>(); 
       
       Integer count = 0;
       
       if(surveyQuestionWrapper == null) {
          surveyQuestionWrapper = new Map<Integer,surveyQuestionWrapper>();
       } 
       
      // for(List<Question__c> question : [select Id,name,Question__c,typeOfQuestion__c from Question__c where status__c = true and Id IN : questionIDs]) {
            for(Question__c ques : newQuestions ) {                              
                
                surveyQuestionWrapper.put(count,new surveyQuestionWrapper(ques));                
                List<questionOptions__c> option = questionBank.getOptionsByQuestionId(ques.Id); 
                           
                if(option != null && option.size() > 0) {
                    if(ques.typeOfQuestion__c != 'free_text') {
                          if(ques.typeOfQuestion__c == 'radio') {
                               List<SelectOption> optionList = new List<SelectOption>(); 
                               for(questionOptions__c optionItem : option ) {
                                   if(optionItem.option__c != null) {
                                       optionList.add(new SelectOption(optionItem.Id,optionItem.option__c)); 
                                   }
                               }
                               options.put(ques.Id,optionList);
                          }   
                          
                          if(ques.typeOfQuestion__c == 'slider') {
                               List<String> sliderOptions = new List<String>(); 
                               for(questionOptions__c optionItem : option ) {
                                  if(optionItem.option__c != null) {
                                      //sliderOptions.add( Integer.valueof(optionItem.option__c.trim())); 
                                      sliderOptions.add( optionItem.option__c.trim()); 
                                  }
                               }  
                               //sliderOptions.sort();
                               QuestionOptions.put(ques.Id,sliderOptions);                        
                          }                 
                    }                 
                } 
                count++;
            }  
      // }    
        
        
       surveyQuestionListOptions =  options;
       surveyQuestionOptions =  QuestionOptions;
       
       if(surveyQuestionWrapper.isEmpty()) {
          surveyHasQuestions = false;       
       } else {
           surveyHasQuestions = true;
           system.debug('eee-->'+surveyHasQuestions );
       }
          
       return surveyQuestionWrapper; 
   }
      
   
   /*  
     * Manages the feedback provided by the recipient or employee of org
     *
     * @param   Id FeedbackId
     * @return 
   */ 
   public void processFeedback(Id FeedbackId ) {       
      try {
      
       List<FeedbackDetail__c> feedbackDetails = new List<FeedbackDetail__c>(); 
       
       if(surveyQuestionWrapper == null) {
          surveyQuestionWrapper = new Map<Integer,surveyQuestionWrapper>();
       } 
       
       for(Integer key : surveyQuestionWrapper.KeySet()) {
           surveyQuestionWrapper wrapper = surveyQuestionWrapper.get(key) ;            
           FeedbackDetail__c feedBack = new FeedbackDetail__c();
           feedBack.feedbackId__c = FeedbackId;
           feedBack.questionId__c = wrapper.question.Id;
           
           if(wrapper.question.typeOfQuestion__c  == 'slider') {              
             List<questionOptions__c> questOption =  [select Id from questionOptions__c where Question__c =: wrapper.question.Id and option__c=: wrapper.value]; 
             if(questOption.size() > 0) {           
                 questionOptions__c optiondetails = questOption[0];
                 feedBack.response__c = optiondetails.Id;
              }           
           } else {
              feedBack.response__c = wrapper.value;
           }
           
           feedbackDetails.add(feedBack);
      }
      
        insert feedbackDetails;
      } catch (Exception e) {
      
       
      }
       
   }
   
   /*  
     * Method get called as you will hit the save button from preivew survey page
     *
     * @param   Id FeedbackId
     * @return 
   */ 
   public void saveFeedback() {            
      //if(!surveyFeedBack.userHasAttemptedSurvey(surveyDetails.Id)) {           
           Id feedBackId= surveyFeedBack.addFeedBack(surveyDetails.Id);
           processFeedback(feedBackId); 
           surveySubmitted = true;
           ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM ,'Your feedback has been saved successfully.'); 
           ApexPages.addMessage(myMsg);
      //} 
   }
   
   
   /*  
     * Method get called as you will hit the save button from survey form page
     *
     * @param   Id FeedbackId
     * @return 
   */ 
   public void saveRecipientFeedback() {    
   Id recptId = ApexPages.currentPage().getParameters().get('recptId');    
       if(recptId != null){
           if(!surveyFeedBack.recipientHasAttemptedSurvey(surveyDetails.Id, recptId)) {    
               Id feedBackId= surveyFeedBack.addRecipientFeedBack(surveyDetails.Id, recptId);
               processFeedback(feedBackId); 
               surveySubmitted = true;
               ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM ,'Your feedback has been saved successfully.'); 
               ApexPages.addMessage(myMsg);
          }else{
              ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Please enter Account name'));
          }
       }
   }
   
   
   
   /*  
     * Deletes the selected assigned question for the selected survey
     *
     * @param   
     * @return 
   */ 
   public Boolean deleteSurveyQuestion() {
       
        
       
      Id surveyId = ApexPages.currentPage().getParameters().get('surveyId');
      Id questionId= ApexPages.currentPage().getParameters().get('qId');
       
      list<SurveyQuestion__c> surveyQuestionDetails = [select Id,questionId__c from SurveyQuestion__c where questionId__c =:questionId and  surveyId__c =: surveyId ];
      if(surveyQuestionDetails.size() > 0) {
          SurveyQuestion__c surveyQuestion = surveyQuestionDetails[0];
          
          List<Feedback__c> feedbacks = new List<Feedback__c>(); 
          List<FeedbackDetail__c> FeedbackDetails = new List<FeedbackDetail__c>();  
           
          for(list<FeedbackDetail__c > feedbackDetailsList : [select Id, feedbackId__c from FeedbackDetail__c where  questionId__c =: surveyQuestion.questionId__c ]) {
             for(FeedbackDetail__c details : feedbackDetailsList ) {
                  
                  list<Feedback__c> feedBackPart =  [select ID from Feedback__c where Id =: details.feedbackId__c];
                  FeedbackDetails.add(details);
                  
                  if(feedBackPart.size() > 0) {
                      Feedback__c  feedBack = feedBackPart[0];
                      feedbacks.add(feedBack );
                  }                 
             }
          }
          
          delete feedbacks ;
          delete FeedbackDetails;
          delete surveyQuestion ;
          return true;
      }
       
      return false;
   }
   
   
   /*  
     * Lists of the options of the selected question
     *
     * @param   Id FeedbackId
     * @return 
   */    
   public List<questionOptions__c> getLoadOptions() {      
      List<questionOptions__c> options = questionBank.getOptionsByQuestionId(questionId );
      return options;
   }
   
   
   
   /*  
     * Loads the selected survey details
     *
     * @param   Id FeedbackId
     * @return 
   */  
   
   public PageReference loadSurvey() {
       surveySubmitted = false;
       Id surveyId = ApexPages.currentPage().getParameters().get('surveyId');
       recptId = ApexPages.currentPage().getParameters().get('recptId'); 
       if(surveyId != null) {         
           try {
              List<Survey__c> surveyData = [select Id,Name,Description__c,sentDate__c  from Survey__c  where Id=:surveyId limit 1 ];             
              
              if(surveyData.size() > 0 ) {
                  surveyDetails = surveyData[0]; 
              }  
              
              Id questionId= ApexPages.currentPage().getParameters().get('qId');
              
              if(questionId != null) {
                  Boolean isDeleted =  deleteSurveyQuestion();
                  if(isDeleted) {
                    PageReference surveyQuestionsPage = Page.createSurveyQuestions;
                    surveyQuestionsPage.getParameters().put('surveyId',surveyId);
                    surveyQuestionsPage.getParameters().put('m','1');
                    surveyQuestionsPage.setRedirect(true);
                    return surveyQuestionsPage;
                  }else{
                    PageReference surveyQuestionsPage = Page.createSurveyQuestions;
                    surveyQuestionsPage.getParameters().put('surveyId',surveyId);
                    surveyQuestionsPage.getParameters().put('m','2');
                    surveyQuestionsPage.setRedirect(true);
                    return surveyQuestionsPage;  
                  }
              }
              
          } catch(Exception e) {
               ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()); 
               ApexPages.addMessage(myMsg);  
          }
      } else if(recptId != null){ //Added by shubham
        surveyId = [SELECT SurveyId__c FROM SurveyRecipient__c WHERE id=:recptId].surveyId__c;
        try{
           List<Survey__c> surveyData = [select Id,Name,Description__c  from Survey__c  where Id=:surveyId limit 1 ];             
              
              if(surveyData.size() > 0 ) {
                  surveyDetails = surveyData[0]; 
              }   
        }catch(Exception e){
              ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()); 
              ApexPages.addMessage(myMsg);
        }
      }
      //firstQuestion And Last question
      initQuestionOrdering();
      ShowMessages();
      return null;
   }
    
   /*
    * 
    * 
    */
    public void ShowMessages(){
        String message = ApexPages.currentPage().getParameters().get('m');
        if(message!=null){
            if(message=='1'){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM,'Question has been deleted successfully from the survey.'); 
                ApexPages.addMessage(myMsg);
            }
            
            if(message=='2'){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM,'There was some problem deleting the question from the survey.'); 
                ApexPages.addMessage(myMsg);
            }
        }
    }
    
   /* Method to move a question up in the surveyForm
     * @param
     * @return: void
     */
    public void moveUp() {
        Id surveyId = ApexPages.currentPage().getParameters().get('surveyId');
        Id questionId = ApexPages.currentPage().getParameters().get('questionId');
        //sortOrder of current question
        Decimal currentSortOrder = (Decimal)[Select sortOrder__c FROM SurveyQuestion__c WHERE 
                                             QuestionId__c=:questionId AND 
                                             surveyId__c=:surveyId].sortOrder__c;
        //sortOrder of previous question
        Decimal prevSortOrder = (Decimal)[Select MAX(sortOrder__c)val FROM SurveyQuestion__c WHERE 
                                          sortOrder__c < :currentSortOrder
                                          AND surveyId__c=:surveyId 
                                          AND QuestionId__r.Status__c = true
                                          GROUP BY surveyId__c][0].get('val');
        //current question
        SurveyQuestion__c currentQuestion = [SELECT Id FROM SurveyQuestion__c WHERE 
                                             QuestionId__c=:questionId AND 
                                             surveyId__c=:surveyId];
        //previous question
        SurveyQuestion__c prevQuestion = [SELECT Id FROM SurveyQuestion__c 
                                          WHERE surveyId__c=:surveyId
                                          AND QuestionId__r.Status__c = true
                                          AND sortOrder__c =:prevSortOrder];
        
        //Swap sortOrder
        currentQuestion.sortOrder__c = prevSortOrder;
        prevQuestion.sortOrder__c = currentSortOrder;
        update currentQuestion;
        update prevQuestion;
        getquestionList();
    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Display order has been changed successfully'));
    }
    
    /* Method to move a question down in the surveyForm
     * @param
     * @return: void
     */
    public void moveDown(){
        Id surveyId = ApexPages.currentPage().getParameters().get('surveyId');
        Id questionId = ApexPages.currentPage().getParameters().get('questionId');
        //SortOrder of current question
        Decimal currentSortOrder = (Decimal)[Select sortOrder__c FROM SurveyQuestion__c WHERE 
                                             QuestionId__c=:questionId AND surveyId__c=:surveyId].sortOrder__c;
        //SortOrder of next question
        Decimal nextSortOrder = (Decimal)[Select MIN(sortOrder__c)val FROM SurveyQuestion__c 
                                          WHERE sortOrder__c > :currentSortOrder
                                          AND surveyId__c=:surveyId AND QuestionId__r.Status__c = true
                                          GROUP BY surveyId__c][0].get('val');
        //current Question
        SurveyQuestion__c currentQuestion = [SELECT Id FROM SurveyQuestion__c WHERE 
                                             QuestionId__c=:questionId AND surveyId__c=:surveyId];
        //Next Question
        SurveyQuestion__c nextQuestion = [SELECT Id FROM SurveyQuestion__c 
                                          WHERE surveyId__c=:surveyId AND QuestionId__r.Status__c = true
                                          AND sortOrder__c =:nextSortOrder];
        
        //Swap the sortOrders
        currentQuestion.sortOrder__c = nextSortOrder;
        nextQuestion.sortOrder__c = currentSortOrder;
        update currentQuestion;
        update nextQuestion;
        getquestionList();
    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Display order has been changed successfully'));
    }
    
    /* Method for setting the id of first question and last question of the survey
     * @param
     * @return: void
     */
    public void initQuestionOrdering(){
        try {
        Decimal maxSortOrder = (Decimal) [Select MAX(sortOrder__c)val FROM SurveyQuestion__c
                             WHERE surveyId__c = :surveyDetails.Id AND questionId__r.status__c = true][0].get('val');
        Decimal minSortOrder = (Decimal)[Select MIN(sortOrder__c)val FROM SurveyQuestion__c
                             WHERE surveyId__c = :surveyDetails.Id AND questionId__r.status__c = true][0].get('val');
        
        firstQuestionId = [SELECT questionId__r.Id FROM SurveyQuestion__c WHERE sortOrder__C=:minSortOrder  
                  AND surveyId__c = :surveyDetails.Id AND questionId__r.status__c = true].questionId__r.Id;
        lastQuestionId = [SELECT questionId__r.Id FROM SurveyQuestion__c WHERE sortOrder__C=:maxSortOrder
                  AND surveyId__c = :surveyDetails.Id AND questionId__r.status__c = true].questionId__r.Id;
        } catch(Exception e) {
        
        
        }
    }
    
    
    
     
    
    
    public Map<Id,String> getquestionReport() {         
        
        Map<Id,String> questionReportWrapper = new Map<Id,String>();   
         
        if(surveyDetails.Id != null) {
           for(list<Feedback__c > feedbackList : [select Id from Feedback__c where  surveyId__c =: surveyDetails.Id ]) {
               for(Feedback__c Feedback : feedbackList ) {                                  
                  for(List<FeedbackDetail__c> feedbackdetails : [SELECT feedbackId__c,questionId__r.typeOfQuestion__c,questionId__r.Question__c,questionId__c,response__c from FeedbackDetail__c where feedbackId__c =:Feedback.Id ]) {
                      for(FeedbackDetail__c feedbackdetail : feedbackdetails) {
                          List<Question__c> questionDetails = [SELECT Id,Question__c from Question__c where Id =:feedbackdetail.questionId__c and typeOfQuestion__c != 'free_text' Limit 1];  
                          if(questionDetails.size() > 0) { 
                              questionReportWrapper.put(questionDetails[0].Id,questionDetails[0].Question__c);
                              
                                                             
                          }
                      }                  
                  }          
               }
           }            
        } 
        return questionReportWrapper;
    }
    
    public void setReportQuestionId (Id questionId) {
        reportQuestionId = questionId;
    }
    
    public Id getReportQuestionId() {
      return reportQuestionId ;
    } 
  
  
    public void setSurveyQuestionId (Id s) {
      surveyQuestionId= s;
    }
    
    public String getSurveyQuestionId() {
      return surveyQuestionId;
    } 
     
    //private static List<PieWedgeData> generatePieData(String surveyId,String questionId) {
    
    public static List<PieWedgeData> getPieData() {
        system.debug(reportQuestionId );
        system.debug(surveyQuestionId);
        
        List<PieWedgeData> data = new List<PieWedgeData>();
        
        Id surveyId  = surveyQuestionId;
        Id questionId = reportQuestionId ;
        
        
        
        Map<String,Integer> Stats = new Map<String,Integer>();
        
        Integer totalFeedBacks = 0;        
       // list<Feedback__c > feedbackList = [select Id from Feedback__c where  surveyId__c =: surveyId ];
        //totalFeedBacks = feedbackList.size();
        
        Set<Id> feedbackIds = new Set<Id>();          
        if(surveyId != null) {
           for(list<Feedback__c > feedbackList  : [select Id from Feedback__c where  surveyId__c =: surveyId ]) {
               for(Feedback__c Feedback: feedbackList  ) {
                  feedbackIds.add(Feedback.Id);
                  totalFeedBacks++;
               }
           }            
        }
         
        
        List<Question__c> questionDetails = [SELECT Id,Question__c from Question__c where Id =:questionId and typeOfQuestion__c != 'free_text' Limit 1]; 
        if(questionDetails.size() > 0) { 
            system.debug('Query-->'+[SELECT feedbackId__c,questionId__r.typeOfQuestion__c,questionId__r.Question__c,questionId__c,response__c from FeedbackDetail__c where questionId__c =:questionDetails[0].Id ]);
            for(List<FeedbackDetail__c> feedbackdetails : [SELECT feedbackId__c,questionId__r.typeOfQuestion__c,questionId__r.Question__c,questionId__c,response__c from FeedbackDetail__c where feedbackId__c IN:feedbackIds and  questionId__c =:questionDetails[0].Id ]) {
                for(FeedbackDetail__c feedback : feedbackdetails) {
                     List<questionOptions__c>  questionOptionDetails = [select Id, option__c from questionOptions__c where Question__c =: feedback.questionId__c and Id =:feedback.response__c limit 1 ];
                     if(questionOptionDetails.size() > 0) {
                         if(stats.get(questionOptionDetails[0].option__c) == null) {
                             stats.put(questionOptionDetails[0].option__c,0);
                         }
                         
                         Integer count = stats.get(questionOptionDetails[0].option__c);
                         count++;
                         stats.put(questionOptionDetails[0].option__c,count);  
                     }
                }            
            }
            
             
            for(String key : stats.KeySet()) {
                Integer option = stats.get(key );
                //data.add(new PieWedgeData(key ,(100 *option )/totalFeedBacks));
                data.add(new PieWedgeData(key , option ));
            }
        }
        return data; 

    }
    
    // Wrapper class

   public class PieWedgeData {
      public String name { get; set; }
      public Integer data { get; set; }
      public PieWedgeData(String name, Integer data) {
         this.name = name;
         this.data = data;
      }
   }


      
}