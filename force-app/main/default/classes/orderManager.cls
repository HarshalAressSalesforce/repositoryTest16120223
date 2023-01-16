public class orderManager {
     
	@AuraEnabled //(cacheable=true)
    public static List<orderWrapper> showNumberOfOrders(Integer noOfOrders) {
        List<orderWrapper> orders = new  List<orderWrapper>();
         
        /*Schema.DescribeFieldResult fieldResult = Order.Status.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        List<picklist> statuses =new List<picklist>();
        
        for( Schema.PicklistEntry pickListVal : ple){
			picklist pick = new picklist();
            pick.label = pickListVal.getLabel();
            pick.value = pickListVal.getValue();
            statuses.add(pick);
		}    
        */
        
        for(Integer i=1; i<=noOfOrders;i++) {
            orderWrapper ow = new orderWrapper();
            ow.SrNo = i;
            ow.orderName = 'Harshal'+i;
            ow.EffectiveDate = Date.today();
            ow.EndDate =  Date.today();
			//ow.status = statuses;
            //ow.orderStatus = 'Draft';
            orders.add(ow);
        }
        return orders;
    }
    
    @AuraEnabled
    public static void createOrder(String orderId,String orderList){
        system.debug('orderId-->'+orderId);
        system.debug('orderList-->'+orderList);
        if(orderId != null && orderId != '') {
            
            
            List<Order> orderDetails = [select Id,AccountId,Pricebook2Id,BillingCity,BillingCountry,BillingPostalCode,BillingState,BillingStreet from order where Id=:orderId];
            if(orderDetails.size()>0) {
                List<OrderItem> orderProducts = [select AvailableQuantity,CurrencyIsoCode,Description,
                                                EndDate,ListPrice,PricebookEntryId,Product2Id,Quantity,
                                                ServiceDate,TotalPrice,UnitPrice 
                                                from OrderItem 
                                                where OrderId=:orderDetails[0].Id];
                
                List<orderWrapper> orders = (List<orderWrapper>) JSON.deserialize(orderList, List<orderWrapper>.class);
                if(orders.size()>0) {
                	system.debug('orderList-->'+orders);
                    List<Order> newOrders = new List<Order>();
                    for(orderWrapper ord : orders) {
                        newOrders.add(new Order(AccountId = orderDetails[0].AccountId,
                                                BillingCity = orderDetails[0].BillingCity,
                                                BillingCountry = orderDetails[0].BillingCountry,
                                                BillingPostalCode = orderDetails[0].BillingPostalCode,
                                                BillingState = orderDetails[0].BillingState,
                                                BillingStreet = orderDetails[0].BillingStreet,
                                                EffectiveDate = ord.EffectiveDate,
                                                EndDate = ord.EndDate,
                                                Pricebook2Id = orderDetails[0].Pricebook2Id,
                                                Status = 'Draft'));
                    }
                    system.debug('newOrders-->'+newOrders);
                    if(newOrders.size()>0) {
                        insert newOrders;
                        system.debug('newOrders-->'+newOrders);
                        
                        if(orderProducts.size()>0) {
                            system.debug('orderProducts-->'+orderProducts);
                            List<OrderItem> newOrderItems = new List<OrderItem>();
                            
                            for(Order ord : newOrders) {
                                for(OrderItem oi : orderProducts) {                                	 
                                    newOrderItems.add(new OrderItem(Description = oi.Description,
                                                					EndDate =oi.EndDate,
                                                                    ListPrice=oi.ListPrice,
                                                                    PricebookEntryId=oi.PricebookEntryId,
                                                                    Product2Id=oi.Product2Id,
                                                                    Quantity=oi.Quantity,
                                               					    ServiceDate= oi.ServiceDate,
                                                                    UnitPrice = oi.UnitPrice,
                                                                    OrderId = ord.Id));
                           		}
                            }
                            system.debug('newOrderItems-->'+newOrderItems);
                            if(newOrderItems.size()>0) {
                                insert newOrderItems;
                                system.debug('newOrderItems-->'+newOrderItems);
                            }
                            
                        }
                    }
            	}
            }
            
            
            
        }
        
    }

    public class orderWrapper {
        @AuraEnabled public Integer SrNo;
        @AuraEnabled public Date EffectiveDate;
        @AuraEnabled public Date EndDate;
        @AuraEnabled public String orderName;
        //@AuraEnabled public String orderStatus;
		//@AuraEnabled public List<picklist> status;        
        public orderWrapper() {
            
        }
    }
    
    public class picklist {
        @AuraEnabled public String label;
        @AuraEnabled public String value;        
    }
}