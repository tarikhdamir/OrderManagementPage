trigger orderTrigger on Order__c (after insert) {
	// Map to store Order Ids and their associated aggregate data
	Map<Id, AggregateResult> orderSums = new Map<Id, AggregateResult>();

	List<Order__c> orders = [SELECT Account__c, Name__c FROM Order__c WHERE Id IN :trigger.new];
	// Aggregate the quantities and prices from OrderItems__c related to the Orders
	for (Order__c order : orders) {
		AggregateResult[] results = [
				SELECT SUM(Quantity__c) totalQuantity, SUM(Price__c) totalPrice
				FROM OrderItem__c
				WHERE OrderId__c = :order.Id
		];

		if (!results.isEmpty()) {
			orderSums.put(order.Id, results[0]);
		}
	}


	for (Order__c order : orders) {
		if (orderSums.containsKey(order.Id)) {
			AggregateResult agg = orderSums.get(order.Id);
			order.TotalProductCount__c = (Decimal)agg.get('totalQuantity');
			order.TotalProductPrice__c = (Decimal)agg.get('totalPrice');
		}
	}

	update orders;

}
