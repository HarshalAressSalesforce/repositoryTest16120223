/*
Class Name: Class to handle the global configuration for the app
Author: Aress
Version: 38.0 
*/


public class surveyConfigs { 
  private final questionBank questBank; // Object where we have have used this class as extension
  private final surveyQuestions surveyQuestions; // Object where we have have used this class as extension
  private final surveyFeedBack surveyFeedBack; // Object where we have have used this class as extension
  
  public static Integer numberOfRecordPerPage = 3; // number of recordper page
  
  /*  
     * Constructor
     *
     * @param   
     * @return  
   */ 
  public surveyConfigs() {     
  }
  
   /*  
     * Constructor for the class where we have have used this class as extension            
   */ 
  public surveyConfigs(surveyFeedBack surveyFeedBack) {
       this.surveyFeedBack= surveyFeedBack;
  }
  
  /*  
     * Constructor for the class where we have have used this class as extension            
   */ 
  public surveyConfigs(questionBank questionBank) {
       this.questBank= questionBank;
  }
  
  /*  
     * Constructor for the class where we have have used this class as extension            
   */ 
  public surveyConfigs(surveyQuestions surveyQuestions) {
       this.surveyQuestions = surveyQuestions;
   }
        
  /*  
     * Dropdown for the available question types         
   */ 
  public List<SelectOption> getQuestionTypes() {         
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('radio','Radio'));
        options.add(new SelectOption('slider','Slider'));
        options.add(new SelectOption('multiselect','Multiselect'));
        options.add(new SelectOption('free_text','Free Text'));
        return options;
   }    
}