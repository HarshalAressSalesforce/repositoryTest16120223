({
    init: function (cmp, event, helper) {
        cmp.set('v.columns', helper.getColumnDefinitions());

        var fetchData = {
            opportunityName: "company.companyName",
            accountName : "name.findName",
            closeDate : "date.future",
            amount : "finance.amount",
            contact: "internet.email",
            phone : "phone.phoneNumber",
            website : "internet.url",
            status : {type : "helpers.randomize", values : [ 'Pending', 'Approved', 'Complete', 'Closed' ] },
            actionLabel : {type : "helpers.randomize", values : [ 'Approve', 'Complete', 'Close', 'Closed' ]},
            confidenceDeltaIcon : {type : "helpers.randomize", values : [ 'utility:up', 'utility:down' ]}
        },
        promiseData = helper.fetchData(cmp, fetchData, cmp.get('v.initialRows'));

        cmp.set('v.dataTableSchema', fetchData);
        promiseData.then(function(results) {
            cmp.set('v.data', results);
        });

    },

    updateSelectedText: function (cmp, event) {
        var selectedRows = event.getParam('selectedRows');
        cmp.set('v.selectedRowsCount', selectedRows.length);
    },

    resetRows: function (cmp, event, helper) {
        cmp.set('v.data', []);
        helper.fetchData(cmp, cmp.get('v.initialRows'))
            .then($A.getCallback(function (data) {
                cmp.set('v.data', data);
            }));
    },

    loadMoreData: function (cmp, event, helper) {
        var rowsToLoad = cmp.get('v.rowsToLoad'),
            fetchData = cmp.get('v.dataTableSchema'),
            promiseData;

        event.getSource().set("v.isLoading", true);
        cmp.set('v.loadMoreStatus', 'Loading');

        promiseData = helper.fetchData(cmp, fetchData, rowsToLoad);

        promiseData.then($A.getCallback(function (data) {
                if (cmp.get('v.data').length >= cmp.get('v.totalNumberOfRows')) {
                    cmp.set('v.enableInfiniteLoading', false);
                    cmp.set('v.loadMoreStatus', 'No more data to load');
                } else {
                    var currentData = cmp.get('v.data');
                    var newData = currentData.concat(data);
                    cmp.set('v.data', newData);
                    cmp.set('v.loadMoreStatus', '');
                }
                event.getSource().set("v.isLoading", false);
            }));
    }
})