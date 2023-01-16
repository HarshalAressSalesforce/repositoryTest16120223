({
	addNewCityForm : function(component, event, helper) {
        var btnClicked = event.getSource();     
		document.getElementById('listing').style.display = 'none';
        document.getElementById('add_new_form').style.display = 'block';
        component.set("v.title", btnClicked.get('v.label')); 
	},
    
    createCity :function(component, event, helper) {
       
       var city = component.get("v.city");
       helper.createNewCity(component, city);
	}
})