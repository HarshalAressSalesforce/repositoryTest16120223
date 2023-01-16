({
	doInit : function(component, event, helper) {
		var action = component.get( "c.getAllObjects" );
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS" ) { 
                component.set('v.ObjectName',response.getReturnValue()); 
            } else {
                console.log( "Failed with state: " + state );
            }
            
        });
        
        $A.enqueueAction(action);
	},
    showFields : function(component, event, helper) {
        alert(component.get('v.Object_Name'));
		var action = component.get( "c.getAllfields" );
        action.setParams({fld:component.get('v.Object_Name')});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS" ) { 
                component.set('v.fields',response.getReturnValue()); 
            } else {
                console.log( "Failed with state: " + state );
            }
            
        });
        
        $A.enqueueAction(action);
	}
})