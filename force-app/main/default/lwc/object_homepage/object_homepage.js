import { LightningElement,api,track,wire } from 'lwc';
//import fetchObjects from '@salesforce/apex/objectConsoleManager.fetchObjects';
//import fetchFields from '@salesforce/apex/objectConsoleManager.fetchFields';
import sendChatMessage from '@salesforce/apex/objectConsoleManager.sendChatMessage';
import fetchChatMessage from '@salesforce/apex/objectConsoleManager.fetchChatMessage';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { subscribe, unsubscribe, onError, setDebugFlag, isEmpEnabled } from 'lightning/empApi';
import uId from '@salesforce/user/Id';

export default class Object_homepage extends LightningElement {
   /* obj;
    flds;
    msg;
    @track objects=[];
    @track fields=[];
    @track value ='';
    @track values=[];*/

    @track message='';
    @api chatMessage='';
    subscription = {};
    @api channelName = '/event/AressH__chat__e';
    @track messages=[]; 
   
    @track userId = uId;  

    listChatMessage() {
        //alert(63);
        fetchChatMessage()
        .then((result) => {            
            this.messages = result;
        })
        .catch((error) => {
        });
    }
    

    connectedCallback() {
        // Register error listener   
        this.listChatMessage();  
        this.registerErrorListener();
        this.handleSubscribe();
    }
    
    sendMessageNow() {
        sendChatMessage({ message:this.chatMessage}) 
        .then((result) => {
            this.listChatMessage();              
        })
        .catch((error) => {
            console.log('81-->'+JSON.stringify(error));
         
        });   
    }
   /* async sendMessageNow() {
        try {
            await sendChatMessage({ message:this.chatMessage}) 
            .then((result) => {
               
                
            })
            .catch((error) => {
                console.log('81-->'+JSON.stringify(error));
            // this.error = error;
            // this.contacts = undefined;
            });
        } catch(error) {
            console.error(error);
        } finally {
            console.log('Finally Block');
        }
    }*/



    
    sendMessage() { 
        var inp=this.template.querySelectorAll("lightning-input");

        inp.forEach(function(element){
            if(element.name=="chatMessage") {
                this.chatMessage=element.value;
            }
        },this);
       
         
        this.sendMessageNow();
        
        inp.forEach(function(element){
            if(element.name=="chatMessage") {
                element.value='';
            }
        },this);
        
    }


    handleSubscribe() {
        
        // Callback invoked whenever a new event message is received
        const self = this;
        const messageCallback = function (response) {
            console.log('New message received 1: ', JSON.stringify(response));
            console.log('New message received 2: ', response);
            var obj = JSON.parse(JSON.stringify(response));
            console.log('98-->'+obj.data.payload);
            console.log('99-->'+obj.data.payload.AressH__message__c);
            console.log('100-->'+self.channelName);
            let objData = obj.data.payload;

            self.listChatMessage();


           //self.message = objData.AressH__message__c;    
           // console.log('103: ', self.message);        
           
        };
 
        // Invoke subscribe method of empApi. Pass reference to messageCallback
        subscribe(this.channelName, -1, messageCallback).then(response => {
            // Response contains the subscription information on subscribe call
            console.log('Subscription request sent to: ', JSON.stringify(response.channel));
            this.subscription = response;
        });
    }

    registerErrorListener() {
        onError(error => {
            console.log('Received error from server: ', JSON.stringify(error));
        });
    }

     
}