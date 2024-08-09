trigger orderTrigger on OrderItem__c (after insert, after update, after delete) {

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
