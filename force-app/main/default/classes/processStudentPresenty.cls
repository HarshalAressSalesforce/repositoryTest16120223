public class processStudentPresenty {
   
   public void processStudentPresenty() {
   }
   
   public static void incrementTotalPresenty(Student_Attendaces__c[] sa) {
       
        
       List<Student_Attendaces__c> StudentAttendanceObjects = new List<Student_Attendaces__c>();
       
       List<Student_Attendance_Count__c> attendancecountOld = new List<Student_Attendance_Count__c>();
       List<Student_Attendance_Count__c> attendancecountNew = new List<Student_Attendance_Count__c>();
        
       /*for(Student_Attendaces__c saObject : sa) {
            
            for(List<Student_Attendaces__c> StudentAttendance : [select Id, Name,Total_Presenty__c from Student_Attendaces__c where Attendance__c =: saObject.Attendance__c and  Student__c =: saObject.Student__c ]) {
                 for(Student_Attendaces__c  temp : StudentAttendance ) {
                    temp.Total_Presenty__c = 1;
                    StudentAttendanceObjects.add(temp);
                 }
            }                     
       }*/
       
       
        for (Student_Attendaces__c s :sa){          
           Student_Attendaces__c temp = new Student_Attendaces__c();
           temp.Id = s.Id;          
           temp.Total_Presenty__c = 1;
           StudentAttendanceObjects.add(temp);
           
           List<Student_Attendance_Count__c> attendancecountContainer = [select Id, Presenty__c,Attendance__c , Student__c  from Student_Attendance_Count__c where Attendance__c =: s.Attendance__c and  Student__c =: s.Student__c ];
           
            if(attendancecountContainer.isEmpty()) {
                Student_Attendance_Count__c attendancecountTmp = new Student_Attendance_Count__c();
                attendancecountTmp.Attendance__c  =  s.Attendance__c;
                attendancecountTmp.Student__c =  s.Student__c ;
                attendancecountTmp.Presenty__c = 1;
                attendancecountNew.add(attendancecountTmp); 
            } else {
                for(List<Student_Attendance_Count__c> cnt1 : [select Id, Presenty__c,Attendance__c , Student__c  from Student_Attendance_Count__c where Attendance__c =: s.Attendance__c and  Student__c =: s.Student__c ]) {
                    for (Student_Attendance_Count__c sac : cnt1){  
                       sac.Presenty__c = sac.Presenty__c + 1;
                       attendancecountOld .add(sac );
                    }
                }
            }
                     
              
           
        }
       
       //update StudentAttendanceObjects ;
        
       update StudentAttendanceObjects ;
       
       if(!attendancecountOld.isEmpty()) {
            update attendancecountOld ;
       }  
       
       if(!attendancecountNew.isEmpty()) {
            insert attendancecountNew ;
       }  
       
       
       system.debug('Testing from apex');
   }
   
   public static void ClearDuplicates(Student_Attendaces__c[] sa) {
        
        
        //List<Student_Attendaces__c> StudentAttendanceObjects = new List<Student_Attendaces__c>();
        for(Student_Attendaces__c saObject : sa) {
             for(List<Student_Attendaces__c> StudentAttendance : [select Id, Name from Student_Attendaces__c where Attended_On__c = :saObject.Attended_On__c and ID !=: saObject.ID and Attendance__c =: saObject.Attendance__c and  Student__c =: saObject.Student__c ]) {
                 for(Student_Attendaces__c  temp : StudentAttendance ) {
                    //StudentAttendanceObjects.add(temp);
                    saObject.Attended_On__c.addError('You have already attended the student on this date');
                 }
             } 
        }
        
        //if(!StudentAttendanceObjects.isEmpty()) {
          // delete StudentAttendanceObjects;
       // }
   }
}