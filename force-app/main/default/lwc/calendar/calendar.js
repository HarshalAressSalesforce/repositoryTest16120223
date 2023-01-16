import { LightningElement,api,track,wire } from 'lwc';
import fetchCalendar from '@salesforce/apex/calendar.fetchCalendar';

import { loadScript, loadStyle } from 'lightning/platformResourceLoader';
import interest from '@salesforce/resourceUrl/calculatePrincipleInterest';

import printDiv from '@salesforce/resourceUrl/printDiv';

export default class Calendar extends LightningElement {
    calObj;
   @api recordId;
    @track error;
    @track dayNames;
    @track dayNumbers;
    @track parmaObject;// = { 'recordId' : this.recordId,'month':0,'year':0,'action':''};
    @track parmaObjectStr;// = JSON.stringify(this.parmaObject);
    @track month=0;
    @track year=0;
    @track action= '';
    @track monthName = '';
    @track isLoaded = false;
    //@wire(fetchCalendar) calendar;

    renderedCallback() {
        loadScript(this, interest).then(() => {
            //this is the name of the function that’s present
            //in the uploaded static resource.
            const interest = myLib.calculatePrincipleInterest(4567);
            console.log('Interest-->'+interest);
        });

        loadScript(this, printDiv).then(() => {
            alert("233");
       });

    }

    printSection() {  
        ExampleJS.printDiv();
    }

    connectedCallback() {
        this.parmaObject = {
            'recordId' : this.recordId,
            'action' :'',
            'month' : 0,
            'year' : 0
        };  
        this.parmaObjectStr = JSON.stringify(this.parmaObject);  

       
        
    }
     
    prev() {  
       this.isLoaded = false;
       this.parmaObject = {
            'recordId' : this.recordId,
            'action' :'prev',
            'month' : this.month,
            'year' : this.year
        };  
        this.parmaObjectStr = JSON.stringify(this.parmaObject);     
    } 

    next() { 
        this.isLoaded = false;
        this.parmaObject = {
            'recordId' : this.recordId,
            'action' :'next',
            'month' : this.month,
            'year' : this.year
        };
         
        this.parmaObjectStr = JSON.stringify(this.parmaObject);
         
     } 
//,month: '$month', year: '$year',action:'$action'
    @wire(fetchCalendar,{param:'$parmaObjectStr'})
    wiredCalObj({ error, data }) {
        console.log('12-->'+JSON.stringify(error));
        console.log('13-->'+JSON.stringify(data));
        
        if (data) {
            this.isLoaded = true;
            this.calObj = data;
            this.dayNames = this.calObj.dayNames;
            this.dayNumbers = this.calObj.dayNumbers;
            this.monthName = this.calObj.monthName;
            this.month = this.calObj.month;
            this.year = this.calObj.year;
            console.log('16-->'+JSON.stringify(this.calObj));
            console.log('16-->'+JSON.stringify(this.dayNames));
            this.error = undefined;
            
        } else if (error) {
            this.error = error;
            this.calendar = undefined;
        }
    } 

}