public class DurablePushTopicStreamingController {

    private static final String TOPIC_NAME = 'TestAccountStreaming';
    
    public String channel{get; private set;}
    public Integer replayFrom{get;set;}
    public Id topicId{get;set;}
    public String token{get;private set;}
    
    public DurablePushTopicStreamingController() {
        this.channel = '/topic/' + TOPIC_NAME;
        this.replayFrom = -2;
    }
    
    public PageReference getOrCreatePushChannel() {
        List<PushTopic> pushTopics = [SELECT Id,Name FROM PushTopic WHERE Name=:TOPIC_NAME];
        system.debug('16--->'+pushTopics);
        if (null == pushTopics || pushTopics.size() == 0) {
            PushTopic topic = new PushTopic();
            topic.Name = TOPIC_NAME;
            topic.Query = 'SELECT Id,Name,Website FROM ACCOUNT';
            topic.NotifyForFields = 'Referenced';
            topic.ApiVersion = 37.0;
            insert topic;
            this.topicId = topic.Id;
        } else {
            this.topicId = pushTopics.get(0).Id;
        }
        return null;
    }
    
    public String getAuthentication() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
		request.setEndpoint('https://login.salesforce.com/services/oauth2/token');
        String details = 'grant_type=password&client_id=3MVG9ZL0ppGP5UrCyn4nX.TOEnZ4UZc3r_R38.yduHHdvsFmiQxoi16yWYyatCQEqJDqw8eN3UpfJh_3NIEj_';
        details +=  '&client_secret=5CFD9006AC747CBA86183A55EAB19EEF5638B0D8CAD6E4410E2C51D661CBD765&username=harshal.kulkarni@aressindia.net&password=Harshal52021VeHK1wqVCw9ov6PP75JTAoCSs'; 
        /*Map<String,String> details =  new Map<String,String>();
        details.put('grant_type','password');
        details.put('client_id','3MVG9ZL0ppGP5UrCyn4nX.TOEnX6Y7b59Hwa.6ERIqBXQ3nt6rXfJMmSwmpeRPtn4C_82KkvzBjZN98GXr852');
        details.put('client_secret','1394053104847121403');
        details.put('username','harshal.kulkarni@aressindia.net');
        details.put('password','Harshal52021');*/
        request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        request.setHeader('Content-length', String.valueOf(details.length()));
		request.setMethod('POST');
        request.setbody(details);
        
        HttpResponse res = http.send(request);
    	Map<String,Object> response = (Map<String,Object>) JSOn.deserializeUntyped(res.getBody());
        system.debug('47--->'+response);
        token = String.valueOf(response.get('access_token'));
        new DurablePushTopicStreamingController().getOrCreatePushChannel();
        return null;
    }
}