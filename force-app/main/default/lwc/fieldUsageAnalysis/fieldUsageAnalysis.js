import { LightningElement,api,track,wire } from 'lwc';
import fetchObjects from '@salesforce/apex/objectanalysis.fetchObjects';
import fetchAnalysis from '@salesforce/apex/objectanalysis.fetchAnalysis';
export default class FieldUsageAnalysis extends LightningElement {
    @api recordId;
    objects=[];
    analysis=[];
    error;
    value;
    @track isLoaded = false;

    connectedCallback() {
        this.isLoaded = false;
        fetchObjects()
        .then((result) => {
            this.objects = result;
            this.error = undefined;
            this.isLoaded = true;
        })
        .catch((error) => {
            this.error = error;
            this.contacts = undefined;
        });
    }

    showData(event) {
        this.isLoaded = false;
        this.value = event.detail.value;
        console.log('value-->'+this.value);
        fetchAnalysis({objectName:this.value})
        .then((result) => {
            this.isLoaded = true;
            this.analysis = result;

            console.log('analysis-->'+JSON.stringify(this.analysis));
            this.error = undefined;
        })
        .catch((error) => {
            this.error = error;
            this.contacts = undefined;
        });
    }

}