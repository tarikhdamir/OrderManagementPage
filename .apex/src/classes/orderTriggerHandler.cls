public class orderTriggerHandler {
	public static void calculateTotals(List<Order__c> orders) {
		for (Order__c order : orders) {
			AggregateResult[] results = [
					SELECT SUM(Quantity__c) totalQuantity, SUM(Price__c) totalPrice
					FROM OrderItem__c
					WHERE OrderId__c = :order.Id
			];

			if (results.size() > 0) {
				order.TotalProductCount__c = (Decimal) results[0].get('totalQuantity');
				order.TotalProductPrice__c = (Decimal) results[0].get('totalPrice');
			}
		}

		update orders;
	}
}
