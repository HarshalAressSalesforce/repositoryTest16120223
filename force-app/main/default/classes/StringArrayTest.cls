public class StringArrayTest {
    public static List<String> generateStringArray(Integer numberOfStrings ) {
         
         List<String> myString = new List<String>();
         
         for (Integer i=0;i<numberOfStrings ;i++) {
             
             myString.add('Test '+i);
         }
         return myString;
    }
}