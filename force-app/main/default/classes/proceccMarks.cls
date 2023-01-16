public class proceccMarks {
    public static void addTotalMarks(Student__c[] students) {
        Boolean isWinner = true;
        List<String> myList = new List<String>();
        myList.add('Harshal');
        
        String i = myList.get(0);
        myList.set(0, 'Vijay');
        myList.clear();
        
        for (Student__c s :students){
            s.Total_Marks__c += 1;
           
        }
        
    }
}