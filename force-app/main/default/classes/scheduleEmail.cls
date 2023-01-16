global class scheduleEmail Implements Schedulable
{
    global void execute(SchedulableContext sc)
    {
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<String> sendTo = new List<String>();
        sendTo.add('harshal.kulkarni@aressindia.net');
        mail.setToAddresses(sendTo);
        mail.setSubject('Testing cron');         
        mail.setHtmlBody('Testing cron email message');
        mails.add(mail);
        Messaging.sendEmail(mails);
        
        
        
    }
}