@isTest


public class TestEditSurvey {
    
   @isTest
   public static void testloadSurveydetails(){
     Test.startTest();
     surveyTabs surveyTabs = new surveyTabs();
     surveyTabs.currentSurveyId = 'a0W280000099IccEAE';
     surveyTabs.getloadSurveydetails();
     Test.stopTest();   
   }
}