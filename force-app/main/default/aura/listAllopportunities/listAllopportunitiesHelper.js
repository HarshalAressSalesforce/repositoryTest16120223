({
    getColumnDefinitions: function () {
        var columns = [
            {label: 'Opportunity name', fieldName: 'opportunityName', type: 'text', sortable: true},
            {label: 'Account name', fieldName: 'accountName', type: 'text', sortable: true},
            {label: 'Close date', fieldName: 'closeDate', type: 'date', sortable: true, cellAttributes: { iconName: 'utility:event' }},
            {label: 'Confidence', fieldName: 'confidence', type: 'percent', sortable: true, cellAttributes:
                { iconName: { fieldName: 'confidenceDeltaIcon' }, iconLabel: { fieldName: 'confidenceDelta' }, iconPosition: 'right' }},
            {label: 'Amount', fieldName: 'amount', type: 'currency', typeAttributes: { currencyCode: 'EUR'}, sortable: true},
            {label: 'Contact Email', fieldName: 'contact', type: 'email'},
            {label: 'Contact Phone', fieldName: 'phone', type: 'phone'},
            {label: 'Website', fieldName: 'website', type: 'url', typeAttributes: { label: { fieldName: 'opportunityName' }, target: '_blank' }}
        ];

        return columns;
    },

    fetchData: function (cmp, fetchData, numberOfRecords) {
        var dataPromise,
            latitude,
            longitude,
            fakerLib = this.mockdataLibrary.getFakerLib();

        fetchData.confidence =  { type : function () {
            return Math.random();
        }};

        dataPromise = this.mockdataLibrary.lightningMockDataFaker(fetchData,numberOfRecords);

        return dataPromise;
    }

  });