({
	createNewCity : function(component, city) {
		alert("SDFSD");
        var cities = component.get("v.cities");
        var newCity = JSON.parse(JSON.stringify(city));
        cities.push(city);
        //component.set("v.cities", cities);
        
        var action = component.get("c.saveCity");
        
        action.setParams({
	        "city": city
	    });
        
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var cities = component.get("v.cities");
                cities.push(response.getReturnValue());
                component.set("v.cities", cities);
            }
    	});
        
    	$A.enqueueAction(action);
        
	}
})