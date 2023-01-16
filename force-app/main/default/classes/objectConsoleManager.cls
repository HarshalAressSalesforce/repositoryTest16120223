public with sharing class objectConsoleManager {
    @AuraEnabled
    public static void sendChatMessage(String message) {
        AressH__chat__e event = new AressH__chat__e();
        event.AressH__message__c = message;             
        event.AressH__sender__c = String.valueOf( UserInfo.getUserId());       
        EventBus.publish(event);
    }


    public static void manageChats(List<AressH__chat__e> messages) {
         if(messages.size()>0) {
            List<AressH__chatMessage__c> msgs  = new List<AressH__chatMessage__c>();
            
            for(AressH__chat__e message : messages) {
                msgs.add(new AressH__chatMessage__c(AressH__message__c= message.AressH__message__c,
                                                    AressH__relayId__c= message.ReplayId,
                                                    AressH__sender__c=message.AressH__sender__c));
            }

            if(msgs.size()>0) {
                insert msgs;
            }
         }
    }

    public class chatmessage {
        @AuraEnabled public AressH__chatMessage__c message;
        @AuraEnabled public String chatSentTime;
        @AuraEnabled public Boolean isOther= false;
        @AuraEnabled public Boolean isOwn = false;
        public chatmessage(AressH__chatMessage__c msg,String t,Boolean other,Boolean own) {
            message = msg;
            chatSentTime = t;
            isOther = other;
            isOwn = own;
        }
    }
    
    @AuraEnabled
    public static List<chatmessage> fetchChatMessage() {
        List<chatmessage> messages = new List<chatmessage>();
         
        Boolean isOwn,isOther;  

        Id userId = UserInfo.getUserId();

        for(AressH__chatMessage__c msg : [select AressH__relayId__c,AressH__message__c,createddate,
                                          AressH__sender__c,AressH__sender__r.Name,AressH__sender__r.SmallPhotoUrl
                                          from AressH__chatMessage__c
                                          order by createddate asc]) {            
            isOwn = false;
            isOther = false;

            if(userId == msg.AressH__sender__c){
                isOwn = true;
            } else {
                isOther = true;
            }
            messages.add(new chatmessage(msg,msg.createddate.format('hh:mm a'),isOther,isOwn));                                
        }
        return messages;
    }
}