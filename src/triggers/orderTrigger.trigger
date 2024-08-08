//trigger orderTrigger on Order__c (before insert, before update) {
//
//	// Aggregate the quantities from OrderItem__c related to the Orders
//	Map<Id, AggregateResult> orderSums = new Map<Id, AggregateResult>();
//
//	// Aggregate all OrderItem__c records associated with Orders in trigger.new
//	List<AggregateResult> results = [
//			SELECT OrderId__c,
//			SUM(Quantity__c) totalQuantity
//			FROM OrderItem__c
//			WHERE OrderId__c IN :Trigger.new
//			GROUP BY OrderId__c
//	];
//
//	// Store the aggregate results in the map
//	for (AggregateResult result : results) {
//		orderSums.put((Id)result.get('OrderId__c'), result);
//	}
//
//	// Update the TotalProductCount__c and TotalProductPrice__c fields on Order__c
//	for (Order__c order : Trigger.new) {
//		if (orderSums.containsKey(order.Id)) {
//			AggregateResult agg = orderSums.get(order.Id);
//			order.TotalProductCount__c = (Decimal)agg.get('totalQuantity');
//
//			// Calculate total price in Apex code
//			Decimal totalPrice = 0;
//			List<OrderItem__c> orderItems = [
//					SELECT Quantity__c, Price__c
//					FROM OrderItem__c
//					WHERE OrderId__c = :order.Id
//			];
//			for (OrderItem__c item : orderItems) {
//				totalPrice += item.Quantity__c * item.Price__c;
//			}
//			order.TotalProductPrice__c = totalPrice;
//		} else {
//			// If there are no related OrderItems, set the fields to 0
//			order.TotalProductCount__c = 0;
//			order.TotalProductPrice__c = 0;
//		}
//	}
//}

trigger orderTrigger on OrderItem__c (after insert, after update, after delete) {

	// Collect Order Ids from the trigger context
	Set<Id> orderIds = new Set<Id>();
	if (Trigger.isInsert || Trigger.isUpdate) {
		for (OrderItem__c item : Trigger.new) {
			orderIds.add(item.OrderId__c);
		}
	}
	if (Trigger.isDelete) {
		for (OrderItem__c item : Trigger.old) {
			orderIds.add(item.OrderId__c);
		}
	}

	// Query to aggregate total quantities
	Map<Id, Decimal> orderQuantities = new Map<Id, Decimal>();
	if (!orderIds.isEmpty()) {
		List<AggregateResult> quantityResults = [
				SELECT OrderId__c,
				SUM(Quantity__c) totalQuantity
				FROM OrderItem__c
				WHERE OrderId__c IN :orderIds
				GROUP BY OrderId__c
		];

		for (AggregateResult result : quantityResults) {
			orderQuantities.put((Id)result.get('OrderId__c'), (Decimal)result.get('totalQuantity'));
		}
	}

	// Calculate total prices manually
	Map<Id, Decimal> orderPrices = new Map<Id, Decimal>();
	if (!orderIds.isEmpty()) {
		List<OrderItem__c> orderItems = [
				SELECT OrderId__c, Quantity__c, Price__c
				FROM OrderItem__c
				WHERE OrderId__c IN :orderIds
		];

		for (OrderItem__c item : orderItems) {
			Id orderId = item.OrderId__c;
			if (!orderPrices.containsKey(orderId)) {
				orderPrices.put(orderId, 0);
			}
			Decimal currentTotalPrice = orderPrices.get(orderId);
			currentTotalPrice += item.Quantity__c * item.Price__c;
			orderPrices.put(orderId, currentTotalPrice);
		}
	}

	// Update related Order__c records
	List<Order__c> ordersToUpdate = new List<Order__c>();
	for (Id orderId : orderIds) {
		Order__c order = new Order__c(Id = orderId);
		order.TotalProductCount__c = orderQuantities.get(orderId) != null ? orderQuantities.get(orderId) : 0;
		order.TotalProductPrice__c = orderPrices.get(orderId) != null ? orderPrices.get(orderId) : 0;
		ordersToUpdate.add(order);
	}

	if (!ordersToUpdate.isEmpty()) {
		update ordersToUpdate;
	}
}
