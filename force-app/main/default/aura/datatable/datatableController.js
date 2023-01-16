({
	init: function (cmp, event, helper) {
        /*cmp.set('v.columns', [
            {label: 'Id', fieldName: 'Id', type: 'text' , editable: true},
            {label: 'Name', fieldName: 'Name', type: 'text' ,editable: true},
            {label: 'Annual Revenue', fieldName: 'AnnualRevenue', type: 'currency' ,editable: true},
            {label: 'Description', fieldName: 'Description', type: 'text' ,editable: true},
            {label: 'Number Of Employees', fieldName: 'NumberOfEmployees', type: 'number' ,editable: true},
            {label: 'Industry', fieldName: 'Industry', type: 'text' ,editable: true},
            {label: 'Rating', fieldName: 'Rating', type: 'text' ,editable: true},
            {label: 'Phone', fieldName: 'Phone', type: 'phone' ,editable: true } 
        ]);*/
        //helper.fetchColumns(cmp,event, helper);
        helper.fetchData(cmp,event, helper);
    },
    handleSaveEdition: function (cmp, event, helper) {
        var draftValues = event.getParam('draftValues');
        console.log(draftValues);
        var action = cmp.get("c.updateObject");
        action.setParams({"obj" : draftValues});
        action.setCallback(this, function(response) {
            var state = response.getState();
            $A.get('e.force:refreshView').fire();
            
        });
        $A.enqueueAction(action);
        
    } ,
    first: function (cmp, event, helper) {        
        cmp.set('v.currentPage',1);
        var action = cmp.get("c.init");
        $A.enqueueAction(action);
    },
    next: function (cmp, event, helper) {        
        cmp.set('v.currentPage',cmp.get('v.currentPage')+1);        
        if(cmp.get('v.currentPage') >= cmp.get('v.data.pages').length) {     
            cmp.set('v.currentPage',cmp.get('v.data.pages').length);
        }
        
        var action = cmp.get("c.init");
        $A.enqueueAction(action);
    },
    prev: function (cmp, event, helper) {        
        if(cmp.get('v.currentPage') ==1) {            
            var action = cmp.get("c.first");
            $A.enqueueAction(action);
        } else {
            cmp.set('v.currentPage',cmp.get('v.currentPage')-1);
            var action = cmp.get("c.init");
            $A.enqueueAction(action);
        }
    },
    last: function (cmp, event, helper) {        
        cmp.set('v.currentPage',cmp.get('v.data.pages').length); 
        var action = cmp.get("c.init");
        $A.enqueueAction(action);
    },
    gotoPage : function (cmp, event, helper) {        
        cmp.set('v.currentPage',cmp.get('v.currentPage')); 
        var action = cmp.get("c.init");
        $A.enqueueAction(action);
    },
})