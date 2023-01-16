import { LightningElement, api, wire, track } from 'lwc';
import showOrderNumbers from '@salesforce/apex/orderManager.showNumberOfOrders';
import createOrder from '@salesforce/apex/orderManager.createOrder';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import { createRecordInputFilteredByEditedFields } from 'lightning/uiRecordApi';


export default class CloneOrders extends LightningElement {
    @api recordId;
    @track numberOfOrders=0;
    @track orderList; 
    @track showList = false;

    setNumberOfOrder(event) {
        this.numberOfOrders = event.target.value; 
        this.showList = false;       
    }

    handleEffectveDateChange(event) { 
        for(let i = 0; i < this.orderList.length; i++){
            if(this.orderList[i].SrNo == event.target.dataset.id) {
                if(event.target.dataset.type =='EffectiveDate') {
                    this.orderList[i].EffectiveDate = event.target.value;
                }

                if(event.target.dataset.type =='Endate') {
                    this.orderList[i].EndDate = event.target.value;
                }

                 
            }    
        }
    }

    generateOrders(event) {

        createOrder({orderId : this.recordId,
                    orderList : JSON.stringify(this.orderList)})
        .then(result => {
            const evt = new ShowToastEvent({
                title: 'Order created',
                message: 'Order has been successfully created',
                variant: 'success',
            });
            this.dispatchEvent(evt);
        })
        .catch(error => {
            
        });             

    }

    showOrders(event){
        showOrderNumbers({ noOfOrders : this.numberOfOrders })
        .then(result => {
            this.orderList = result;
             
            if(this.orderList.length>0) {
                this.showList = true;
            }
            console.log(JSON.stringify(this.orderList));
            console.log(JSON.stringify(this.orderList.length));
        })
        .catch(error => {
            const event = new ShowToastEvent({
                title : 'Error',
                message : 'Error creating contact. Please Contact System Admin',
                variant : 'error'
            });
            this.dispatchEvent(event);
        }); 
     }

}