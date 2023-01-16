({
	 fetchData: function (cmp,event,helper) {
        var action = cmp.get("c.getAllData");
          
         action.setParams({ObjectName : 'Account',
                           columns : 'CurrencyIsoCode,Phone,Name,AressH__Active__c,Site,AnnualRevenue,AressH__NumberofLocations__c',
                           filters :'CurrencyIsoCode,Phone,Name,AressH__Active__c,Site,AnnualRevenue,AressH__NumberofLocations__c',                            
                           customFilter : '',
                           search : cmp.get('v.filters'),
                           page : cmp.get('v.currentPage')
                           })

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                console.log('24-->'+JSON.stringify(data));
                cmp.set('v.columns',data.fields);
                cmp.set('v.data',data.records);
                cmp.set('v.filters',data.filters);
                
            }
            // error handling when state is "INCOMPLETE" or "ERROR"
        });
        $A.enqueueAction(action);
    },
    fetchColumns: function (cmp,event,helper) {
        var action = cmp.get("c.getColumns");
        
        action.setParams({ObjectName : 'Account',
                          columns : 'CurrencyIsoCode,Phone,Name,AressH__Active__c,Site,AnnualRevenue,AressH__NumberofLocations__c'})
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                
                console.log('24-->'+JSON.stringify(data));
                cmp.set('v.columns',data);
            }
            // error handling when state is "INCOMPLETE" or "ERROR"
        });
        $A.enqueueAction(action);
    }
})