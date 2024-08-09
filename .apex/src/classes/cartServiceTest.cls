@isTest
public class cartServiceTest {

	@isTest
	static void testCreateOrUpdateCartAndAddProductToCart() {
		Account acc = new Account(Name = 'Test Account');
		insert acc;

		Product__c prod = new Product__c(Name__c = 'Test Product', Family__c = 'Grocery Staples', Type__c = 'Beverages', Description__c = 'Simple Description', Price__c = 100);
		insert prod;
		Cart__c cart;
		Test.startTest();
		cart = cartService.createOrUpdateCart(acc.Id, 'My Cart');
		cartService.addProductToCart(cart.Id, prod.Id, 100, 1);
		Test.stopTest();

		System.assertNotEquals(null, cart, 'Cart should be created or fetched.');
		System.assertEquals('My Cart', cart.Name__c, 'Cart name should match.');
		System.assertEquals(acc.Id, cart.Account__c, 'Cart account should match.');


		List<CartItem__c> cartItems = [
				SELECT Id, Product__c, Quantity__c, Price__c
				FROM CartItem__c
				WHERE CartId__c = :cart.Id AND Product__c = :prod.Id
				LIMIT 1
		];

		System.assertEquals(1, cartItems.size(), 'There should be one CartItem.');
		CartItem__c cartItem = cartItems[0];
		System.assertEquals(prod.Id, cartItem.Product__c, 'Product should match.');
		System.assertEquals(1, cartItem.Quantity__c, 'Quantity should be 1.');
		System.assertEquals(prod.Price__c, cartItem.Price__c, 'Price should match.');

		List<CartItem__c> duplicateCartItems = [
				SELECT Id, Quantity__c
				FROM CartItem__c
				WHERE CartId__c = :cart.Id AND Product__c = :prod.Id
				LIMIT 2
		];
		System.assertEquals(1, duplicateCartItems.size(), 'There should be no duplicate CartItems.');
	}
}
