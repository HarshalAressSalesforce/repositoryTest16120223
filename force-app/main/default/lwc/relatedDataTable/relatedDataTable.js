import { LightningElement,api, wire, track } from 'lwc';
import mouseOver from '@salesforce/apex/RelatedDataTable.mouseOver';
import { deleteRecord } from 'lightning/uiRecordApi';
import { NavigationMixin } from 'lightning/navigation';
import fetchObjectDetails from '@salesforce/apex/RelatedListCount.fetchObjectDetails';

const actions = [
    { label: 'Show details', name: 'show_details' },
    { label: 'Delete', name: 'delete' },
];
const columns = [
    { label: 'Id', fieldName: 'Id' },
    { label: 'Name', fieldName: 'Name',},
    { label: 'Auto Number', fieldName: 'AutoNumber',},
    { label: 'CreatedDate', fieldName: 'CreatedDate', type: 'date' },
    { label: 'LastModifiedDate', fieldName: 'LastModifiedDate', type: 'date' },
    {
        type: 'action',
        typeAttributes: { rowActions: actions },
    },
];


export default class relatedDataTable extends NavigationMixin(LightningElement) {
    cols=columns;
    @api recordId;
    @api childObjectName='';
    @api childObjectLabel='';
    @track isData = false;
    @track data = [];
    @track showNewForm=false;
    @track fields = [];
    @api icon;
    @api childobjarray;
    @api parentobjname;
    @track objSize;

    connectedCallback(){
        console.log('recordId==='+this.recordId);
        console.log('childObjectName==='+this.childObjectName);
        console.log('icon=='+this.icon);
        if(this.childObjectName!=''){
        mouseOver({childObj:this.childObjectName,recordId:this.recordId})
        .then(result => {
           this.data=result;
           if(this.data.length > 0)
           {
               this.isData = true;
           }
           this.objSize = this.data.length;
           console.log('objSize-->'+this.objSize);
           console.log(JSON.stringify(this.data));
        })
        .catch(error => {
            console.log(JSON.stringify(error));
        });    
        } 

        /*fetchObjectDetails({objectName: this.childObjectName, recordId:this.recordId})
        .then(result => {     
            console.log('55-->'+JSON.stringify(result));
            this.fields = result;
            console.log('58-->'+JSON.stringify(this.fields));
        });*/
    } 

  showNewRecordForm(event){       
       this.showNewForm = true;
       console.log('recordId 111--'+this.recordId);
        console.log('childObjectName 111---'+this.childObjectName);
       fetchObjectDetails({objectName: this.childObjectName, recordId:this.recordId})
        .then(result => {     
            console.log('55-->'+JSON.stringify(result));
            this.fields = result;
            console.log('58-->'+JSON.stringify(this.fields));
        })
        .catch(error => {
            console.log(JSON.stringify(error));
        }); 
  }

  handleCreateRecordSubmit(event){
    event.preventDefault();       // stop the form from submitting
    this.fields = event.detail.fields;
    
    
    //console.log('68--->'+JSON.stringify(this.fields));
    return false;
    //this.template.querySelector('lightning-record-edit-form').submit(fields);
  }

  closeModal() {
    // to close modal set isModalOpen tarck value as false
    this.showNewForm = false;
}

   handleRowAction(event) {
    const actionName = event.detail.action.name;
    const row = event.detail.row;
    console.log('actionName=='+actionName);
    console.log('row=='+row);
    switch (actionName) {
        case 'delete':
            deleteRecord(row.Id).then(() => {
             this.deleteRow(row);
            }).catch(error => {
                console.log('error'+error);   
            });
            break;
       case 'show_details':
         this.showRowDetails(row);
         break;
        default:
    }
    
   }
   deleteRow(row) {
       console.log('delete row==='+JSON.stringify(row));
    const  id  = row.Id;
    console.log('id===='+id);
    const index = this.findRowIndexById(id);
    console.log('index==='+index);
    if (index !== -1) {
        this.data = this.data
            .slice(0, index)
            .concat(this.data.slice(index + 1));
    }
}
findRowIndexById(id) {
    let ret = -1;
    this.data.some((row, index) => {
        if (row.Id === id) {
            ret = index;
            return true;
        }
        return false;
    });
    return ret;
}
showRowDetails(row) {
   console.log('show detail'+JSON.stringify(row));
   
   this[NavigationMixin.GenerateUrl]({
    type: 'standard__recordPage',
    attributes: {
        recordId: row.Id,
        actionName: 'view',
    },
}).then((url) => {
    console.log('in then loop');
    this[NavigationMixin.Navigate]({
        type: 'standard__recordPage',
        attributes: {
            recordId: row.Id,
            //objectApiName: 'Case', // objectApiName is optional
            actionName: 'view'
        }
    });
});
}

handleclick(event){
    console.log('handle click--->'+event.target.name);
    console.log('handle click--->'+event.target.id);
    console.log('childobjwithrelationname--->'+JSON.stringify(this.childobjarray));
    console.log('parentobjname'+this.parentobjname);

    let txt = "";
    for (let x in this.childobjarray) {
    if(x == event.target.name)
    txt = this.childobjarray[x];
    }
    console.log('TXT'+txt);

    console.log('Inside navigate')
    this[NavigationMixin.Navigate]({
    type: 'standard__recordRelationshipPage',//'standard__recordRelationshipPage',
    attributes: {
    recordId: this.recordId,
    objectApiName:this.parentobjname,
    relationshipApiName: txt,
    actionName: 'view'
    },
    });
   }

handleMouseOver(event){
    const selectedEvent = new CustomEvent("showtable", {
    detail: true
    });
    this.dispatchEvent(selectedEvent);
   }
   handlemouseout(event){
    const selectedEvent = new CustomEvent("showtable", {
    detail: false
    });
    this.dispatchEvent(selectedEvent);
   }
    
}