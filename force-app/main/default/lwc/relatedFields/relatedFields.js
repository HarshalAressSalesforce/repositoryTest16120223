import { LightningElement,api, wire, track } from 'lwc';
import fetchMandatoryFields from '@salesforce/apex/RelatedListCount.fetchObjectDetails';

export default class RelatedFields extends LightningElement {
    @api recordId;
    @api objectApiName;
    @track fields;

    connectedCallback(){
        fetchMandatoryFields({objectName: this.objectApiName})
        .then(result => {  
            this.fields = result;
        });
    }

   /* renderedCallback() {
        const inputFields = this.template.querySelectorAll(
            'lightning-input-field'
        );
        
        if (inputFields) {
            
            inputFields.forEach(field => {
                console.log('17-->'+field)
                
            });
        }
    }*/


}