@isTest
public class orderTotalCalculationTest {

	@isTest
	static void testTotalCalculation() {
		Account acc = new Account(Name = 'Test Account');
		insert acc;

		Order__c order = new Order__c(Account__c = acc.Id, Name__c = 'Test Order');
		insert order;

		Product__c prod1 = new Product__c(Name__c = 'Product 1', Price__c = 100, Description__c = 'Test Description');
		Product__c prod2 = new Product__c(Name__c = 'Product 2', Price__c = 200, Description__c = 'Test Description');
		insert new List<Product__c> { prod1, prod2 };

		OrderItem__c orderItem1 = new OrderItem__c(
				OrderId__c = order.Id,
				ProductId__c = prod1.Id,
				Quantity__c = 2,
				Price__c = prod1.Price__c
		);
		OrderItem__c orderItem2 = new OrderItem__c(
				OrderId__c = order.Id,
				ProductId__c = prod2.Id,
				Quantity__c = 1,
				Price__c = prod2.Price__c
		);
		insert new List<OrderItem__c> { orderItem1, orderItem2 };

		Order__c updatedOrder = [SELECT TotalProductCount__c, TotalProductPrice__c FROM Order__c WHERE Id = :order.Id];

		System.assertEquals(3, updatedOrder.TotalProductCount__c, 'TotalProductCount__c should be 3.');
		System.assertEquals(400, updatedOrder.TotalProductPrice__c, 'TotalProductPrice__c should be 400.');
	}
}
