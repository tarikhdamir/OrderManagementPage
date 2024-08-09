@isTest
public class orderTriggerTestClass {

	@isTest
	static void testOrderItemTrigger() {
		Account acc = new Account(Name = 'Test Account');
		insert acc;

		Cart__c cart = new Cart__c(Name__c = 'My Cart', Account__c = acc.Id);
		insert cart;

		Product__c prod = new Product__c(Name__c = 'Test Product', Description__c = 'Test Product description', Family__c = 'Grocery Staples', Type__c = 'Beverages', Price__c = 100);
		insert prod;

		Product__c prod2 = new Product__c(Name__c = 'Test Product 2', Description__c = 'Test Product 2 description', Family__c = 'Bakery products', Type__c = 'Frozen Foods', Price__c = 700);
		insert prod2;

		CartItem__c cartItem1 = new CartItem__c(
				CartId__c = cart.Id,
				Product__c = prod.Id,
				Quantity__c = 2,
				Price__c = prod.Price__c
		);
		CartItem__c cartItem2 = new CartItem__c(
				CartId__c = cart.Id,
				Product__c = prod2.Id,
				Quantity__c = 1,
				Price__c = prod2.Price__c
		);
		insert (cartItem1);
		insert (cartItem2);

		Test.startTest();
		Id orderId = cartService.checkoutCart(acc.Id);
		Test.stopTest();

		String orderName = cart.Name__c + ' Order';

		Order__c order = [SELECT Id, Account__c, Name__c FROM Order__c WHERE Id = :orderId LIMIT 1];
		System.assertNotEquals(null, order, 'Order should have been created.');
		System.assertEquals(orderName, order.Name__c, 'Order name should match.');

		List<OrderItem__c> orderItems = [SELECT OrderId__c, ProductId__c, Quantity__c, Price__c FROM OrderItem__c WHERE OrderId__c = :orderId];
		System.assertEquals(2, orderItems.size(), 'There should be two Order Items.');

		List<CartItem__c> remainingCartItems = [SELECT Id FROM CartItem__c WHERE Cart__c = :cart.Id];
		System.assertEquals(0, remainingCartItems.size(), 'Cart Items should be cleared.');
	}
}
