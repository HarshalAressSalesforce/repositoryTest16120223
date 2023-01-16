public class fetchListOfEmailRecipients {
	 public static void getListOfRecipients() {
		string sessionId= UserInfo.getSessionID();
		string domainUrl='https://ebiconsulting--uat.my.salesforce.com/';//URL.getSalesforceBaseUrl().toExternalForm();
		system.debug('********domainUrl:'+domainUrl);
		string objectId ='Contact'; //for custom objects, provide 15 digit or 18 digit object id
		HttpRequest req = new HttpRequest();
		req.setHeader('Authorization', 'Bearer ' + sessionId);
		req.setHeader('Content-Type', 'application/json');
		req.setEndpoint(domainUrl+'/services/data/v47.0/tooling/query/?q=select+id,SenderType,templateId+from+WorkflowAlert');
		req.setMethod('GET');
		Http h = new Http();
		HttpResponse res = h.send(req);
		system.debug(res.getBody());

		List<string> workflowEmailAlertIds= new List<string>();
		String response=res.getBody();
		JSONParser  parser = JSON.createParser(Response);
		while (parser.nextToken() != null) {
			if ((parser.getCurrentToken() == JSONToken.FIELD_NAME)){
				String fieldName = parser.getText();
				parser.nextToken();
				String fieldValue=parser.getText();
				if(fieldName == 'Id') {
					workflowEmailAlertIds.add(fieldValue);
				}
			}
		}
		system.debug('***workflowEmailAlertIds size:'+workflowEmailAlertIds.size());
		system.debug('***workflowEmailAlertIds size:'+workflowEmailAlertIds);
		string csvString='Workflow Email Alert Id,WorkFlow Email Alert Developer Name,Description,ccEmails,recipients,senderAddress,senderType,Email template Name,Email template Id\n';
		//as there is limit of 100 callouts in single transaction, I am restricting it to 90. Assuming there will not be more than 
		//90 email alert on single object
		if(workflowEmailAlertIds.size()<90){
			for(string ss:workflowEmailAlertIds){
				system.debug('***workflowEmailAlertId :'+ss);
				req = new HttpRequest();
				req.setHeader('Authorization', 'Bearer ' +sessionId );
				req.setHeader('Content-Type', 'application/json');
				req.setEndPoint(domainUrl+'/services/data/v41.0/tooling/sobjects/WorkflowAlert/'+ss); 
				req.setMethod('GET');
				h = new Http();
				res = h.send(req);
				system.debug(res.getBody());
				response=res.getBody();
				response = response.replace('type', 'type_z');
				response = response.replace('protected','protected_z');
				response = response.replaceAll(',\r\n','\r\n');
				JSONParserDemo   emailAlertDetails=new JSONParserDemo();
				//try{
				   emailAlertDetails =(JSONParserDemo) JSON.deserialize(response, JSONParserDemo.class);
					system.debug('******emailAlertDetails:'+emailAlertDetails);
					csvString = csvString + emailAlertDetails.Id+ ',' + emailAlertDetails.DeveloperName.escapeCSV() + ','+ emailAlertDetails.Description.escapeCSV(); 
					string ccEmails ='';
					if(emailAlertDetails.Metadata!=null){
						if(emailAlertDetails.Metadata.ccEmails.size()>0){
							ccEmails = string.join(emailAlertDetails.Metadata.ccEmails,',');
							csvString = csvString + ','+ ccEmails.escapeCSV();
						}else{
							csvString = csvString + ',';
						}
                        
                        system.debug('63--->'+emailAlertDetails.Metadata.recipients);
						if(emailAlertDetails.Metadata.recipients!=null){
							if(emailAlertDetails.Metadata.recipients.size()>0){
								string recString='';
								for(JSONParserDemo.Recipients  rec: emailAlertDetails.Metadata.recipients){
									recString = recString + rec.toString();
								}
								csvString = csvString + ','+ recString.escapeCSV();
								system.debug('****recipients:'+recString);
							}else{
								csvString = csvString + ',';
							}
						}else{
							csvString = csvString + ',';
						}
						if(emailAlertDetails.Metadata.senderAddress!=null){
							csvString = csvString + ','+ emailAlertDetails.Metadata.senderAddress.escapeCSV() ;	
						}else{
							csvString = csvString + ',';
						}
						if(emailAlertDetails.Metadata.senderType !=null){
							csvString = csvString + ','+ emailAlertDetails.Metadata.senderType.escapeCSV() ;	
						}else{
							csvString = csvString + ',';
						}
						if(emailAlertDetails.Metadata.template !=null){
							csvString = csvString + ','+ emailAlertDetails.Metadata.template.escapeCSV() ;	
						}else{
							csvString = csvString + ',';
						}
					}
					csvString = csvString + ','+emailAlertDetails.TemplateId+'\n';  
				/*}catch(exception ex){
					system.debug('****exception for email alertid-'+ss);
					csvString = csvString +ss+','+ex.getmessage().escapeCSV()+'\n';
				}*/
			}
		}
		Messaging.EmailFileAttachment csvAtt = new Messaging.EmailFileAttachment();
		blob csvBlob = Blob.valueOf(csvString);
		csvAtt.setFileName(domainUrl+'-Email Alerts info for '+objectId+'.csv');
		csvAtt.setBody(csvBlob);
		Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();
		String[] toAddresses = new list<string> {'harshal.kulkarni@aress.com'}; //UserInfo.getUserEmail()
		string subject=domainUrl+'-Email Alerts info for '+objectId;
		email.setSubject(subject);
		email.setToAddresses( toAddresses );
		email.setPlainTextBody(subject); 
		email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAtt});
		Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
	}
}