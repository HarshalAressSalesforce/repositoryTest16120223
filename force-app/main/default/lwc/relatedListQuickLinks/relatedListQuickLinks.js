import { LightningElement,api,track, wire } from 'lwc';
import { getRelatedListCount } from 'lightning/uiRelatedListApi';
import { NavigationMixin } from 'lightning/navigation';
import getrelatedData from '@salesforce/apex/RelatedListCount.getrelatedData';
import { CurrentPageReference } from 'lightning/navigation';

export default class RelatedListQuickLinks extends NavigationMixin(LightningElement) {
    @api recordId;
    @track url;
    @track showDatatable;
    error;
    responseData;
    @track hoverObj = '';
    @track childObjectLabel = '';
    @api hideHeaderVisibility =false;
    @api HideHeader;
    //@track Header;
    @track showMore=false;
    @track buttonLabel='Show All';
    @api Header = '';

    @api obj;
    @track ObjArray;
    @api alpha;
    @track countdata=[];
    @track shortarrData=[];
    @track showMorevar;
    @track showLen;
    @track parentobjname;
    @track childobjwithrelationname = [];
    @track backuparray=[];
    @track childobjiconname;
    @track icon;
    @track alphaView = "display:flex;";
    @track columnView = " ";

    @track objlist = 'Contact,Case,Order,Campaign,Opportunity';
    connectedCallback(){
        if(this.HideHeader){
            this.Header = ''; // to null the Header
        }
        if(this.shortarrData.length>=8){
            this.showLen=this.shortarrData.length;
            this.showMorevar=true;
        }
        if(this.alpha == 'Vertical' || this.alpha == 'vertical'){
            this.alphaView = "display:list-item;";
            this.columnView = "column-count:2;";
        }
    }
    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
    if (currentPageReference) {
        //this.recordId = currentPageReference.state.recordId;
        console.log('recordId: ' + this.recordId);
        }
        console.log('obj names--'+this.obj);
        if( this.ObjArray != undefined){
            this.ObjArray = this.obj.split(',');
            console.log('ObjArray--'+this.ObjArray[0]);
            console.log('ObjArray--'+this.ObjArray);
        }
        console.log('this.obj'+this.obj);
        getrelatedData({objectName: this.obj, recordId:this.recordId})
        .then(result => {
           if(result.IsSuccess==true){
           this.countdata=[];
           this.shortarrData=[];
           this.parentobjname = result.parentObjName;
           this.childobjwithrelationname = result.objectwithchilerelationname;

           console.log('Result-->'+JSON.stringify(result));
           var tmp;
           tmp=result.iconname;
           var keylist = [];
          // const mapAsc = new Map([...tmp.entries()].sort()); 
          for(let key in tmp){
            keylist.push(key);
          }
          keylist.sort();
           console.log(keylist);         
         for(var i=0;i<keylist.length;i++){
            console.log(keylist[i]); //standard:contact
             for(let key2 in result.ObjNameCount){
                 if(keylist[i]===key2){
                   console.log('key2'+key2); // Contact
                  //  if(result.ObjNameCount[key2]>3){
                    console.log(keylist[i]);
                     this.countdata.push({icon:tmp[keylist[i]],objectLabel: result.ObjNameMapping[keylist[i]], objectName:key2, objCount:result.ObjNameCount[key2]});
                     this.shortarrData.push({icon:tmp[keylist[i]],objectLabel: result.ObjNameMapping[keylist[i]],objectName:key2,objCount:result.ObjNameCount[key2] });
                     console.log(this.countdata);
                     //this.backuparray.push({icon:result.iconname[key],objectName:key2, objCount:'3+'});
                  /*  }else{
                        this.countdata.push({icon:tmp[key],objectLabel: result.ObjNameMapping[key],objectName:key2, objCount:result.ObjNameCount[key2]});
                        this.shortarrData.push({icon:tmp[key],objectLabel: result.ObjNameMapping[key],objectName:key2, objCount:result.ObjNameCount[key2]});
                        //this.backuparray.push({icon:result.iconname[key],objectName:key2, objCount:result.ObjNameCount[key2]});
                    }*/
                 }
             }

         }
        console.log('countdata===>>'+JSON.stringify(this.countdata));
        console.log('countdata===>>'+JSON.stringify(this.countdata.length));
        this.countdata.sort();
        console.log(' count data '+this.countdata);
        if(this.countdata.length>8){
            this.countdata.splice(8,this.countdata.length-8);
            this.showMore = true;
            this.showLen='\('+this.shortarrData.length+'\)';
            this.showMorevar=true;
        }
    }
        console.log('this.shortarrData===>>'+JSON.stringify(this.shortarrData));
        console.log('this.shortarrData===>>'+JSON.stringify(this.shortarrData.length));
        })
    }
    handleclick(event){
        console.log('event'+event);
        console.log('Inside handle click'+event.currentTarget.name);
        console.log('Inside handle click recordId--'+this.recordId);
        console.log('parent obj Name'+this.parentobjname);
        console.log('this.childobjwithrelationname '+JSON.stringify(this.childobjwithrelationname));

        let txt = "";
        for (let x in this.childobjwithrelationname) {
        if(x == event.currentTarget.name)
           txt = this.childobjwithrelationname[x];
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
            /*
            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                recordId: this.accountNameInfo.Id,
                objectApiName: 'Account',
                actionName: 'view'
                },
                });*/
       
    }
    handleMouseOver(event){
        console.log('In mouse over'+event);
        console.log('In mouseOver 111'+event.currentTarget);
        console.log('inside mouse over icon name'+event.currentTarget.id);
        this.icon = event.currentTarget.id;
        var str = event.currentTarget.id;
        var array = str.split("-");
        array.pop();
        this.icon = array.join("");
        
        console.log('icon'+this.icon);
        this.hoverObj=event.currentTarget.name;
        this.childObjectLabel=event.currentTarget.title;
        console.log('childObjectLabel-->'+this.childObjectLabel);
        console.log('hoverObj==>'+this.hoverObj);
        this.showDatatable=true;
        
        console.log('Child object name==='+this.hoverObj);
        const toolTipDiv = this.template.querySelector('div.ModelTooltip');
        toolTipDiv.style.opacity = 1;
        toolTipDiv.style.display = "block";
        // eslint-disable-next-line
        

        //const toolTipDiv = this.template.querySelector('div.ModelTooltip');
        //toolTipDiv.style.opacity = 1;
        //toolTipDiv.style.display = "block";

        /*var classcss = this.template.querySelector('.tooltipOver');
            console.log(classcss);
            if(classcss.classList.contains('tooltipClass')){
                classcss.classList.remove('tooltipClass');
            }*/
        // eslint-disable-next-line
      //window.clearTimeout(this.delayTimeout);
      //  eslint-disable-next-line @lwc/lwc/no-async-operation
      //  this.delayTimeout = setTimeout(() => {
         //   this.objRecordId = this.recordId;
      //  }, 50);
    }
    handleMouseOut(event) {
        console.log('In mouse Out');
        
        window.clearTimeout(this.delayTimeout);
        // eslint-disable-next-line @lwc/lwc/no-async-operation
        
        //uncomment after testing
        this.delayTimeout = setTimeout(() => {
            this.objRecordId = this.recordId;
            this.showDatatable=false;
            const toolTipDiv = this.template.querySelector('div.ModelTooltip');
            toolTipDiv.style.opacity = 0;
            toolTipDiv.style.display = "none";
        }, 200); //10000*/
         //uncomment after testing

        //const toolTipDiv = this.template.querySelector('div.ModelTooltip');
        //toolTipDiv.style.opacity = 0;
        //toolTipDiv.style.display = "none";
       /* var classcss = this.template.querySelector('.tooltipOver');
            console.log(classcss);
            if(classcss.classList.contains('tooltipClass')){
                classcss.classList.add('tooltipClass');
            }*/
    }
    handleView(event){

        console.log('events ----->'+event.currentTarget.name);

        if(event.currentTarget.name=='Show All'){
            this.backuparray = this.countdata;
            this.countdata = this.shortarrData;
            this.buttonLabel = 'Show Less';
            this.showLen='';
        }else if(event.currentTarget.name=='Show Less'){
            this.countdata = this.backuparray;
            this.buttonLabel = 'Show All';
            this.showLen='\('+this.shortarrData.length+'\)';
        }

       /* this.showMore=!this.showMore;
        var divblock = this.template.querySelector('[data-id="divblock"]');
        this.buttonLabel='Show less';
        if(this.showMore){
            this.buttonLabel='Show Less';
            console.log('this.buttonLabel='+this.buttonLabel);
            this.template.querySelector('[data-id="divblock"]').classList.add('showMore');
            //console.log(this.template.querySelector('[data-id="divblock"]'));
        }else{
            this.buttonLabel='Show More';
            console.log('this.buttonLabel='+this.buttonLabel);
            this.template.querySelector('[data-id="divblock"]').classList.remove('showMore');
        }
      //  var divblock = this.template.querySelector('[data-id="divblock"]');*/
    }
    handleshowtable(event){
        console.log('In handleshowtable - '+ event.detail);
        window.clearTimeout(this.delayTimeout);
        this.delayTimeout = setTimeout(() => {
        this.showDatatable = event.detail;
        this.objRecordId = this.recordId;
        }, 201); 
        console.log('In handleshowtable - '+ this.showDatatable);
        }
}