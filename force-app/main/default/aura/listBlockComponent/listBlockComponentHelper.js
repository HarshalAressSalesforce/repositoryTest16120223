({
	fetchObjects: function(component) { 
        var action = component.get('c.getAllObjects');
        action.setCallback(this, function(response) {
            console.log(JSON.stringify(response.getReturnValue()));
             component.set("v.objects", response.getReturnValue());              
        });
        $A.enqueueAction(action);
    }
})