public with sharing class cartService {

	@AuraEnabled(cacheable=true)
	public static List<CartItem__c> getCartProducts(Id accountId) {
		return [
				SELECT Id, CartId__r.Name__c, Product__r.Name__c, Quantity__c, Price__c
				FROM CartItem__c
				WHERE CartId__r.Account__c = :accountId
		];
	}

	@AuraEnabled
	public static Cart__c createOrUpdateCart(Id accountId, String cartName) {
		Cart__c cart;
		try {
			// Try to find an existing cart for the account
			List<Cart__c> existingCarts = [SELECT Id, Name FROM Cart__c WHERE Account__c = :accountId LIMIT 1];
			if (existingCarts.isEmpty()) {
				// If no existing cart, create a new one
				cart = new Cart__c(Account__c = accountId, Name__c = cartName);
				insert(cart);
			} else {
				// Use the existing cart
				cart = existingCarts[0];
			}
		} catch (Exception e) {
			throw new AuraHandledException('Error while creating or updating cart: ' + e.getMessage());
		}
		return cart;
	}

	@AuraEnabled
	public static void addProductToCart(Id cartId, Id productId, Integer price, Integer quantity) {
		try {
			CartItem__c cartItem = new CartItem__c(
					CartId__c = cartId,
					Product__c = productId,
					Price__c = price,
					Quantity__c = quantity
			);
			insert(cartItem);
		} catch (Exception e) {
			throw new AuraHandledException('Error while adding product to cart: ' + e.getMessage());
		}
	}

	@AuraEnabled
	public static Id checkoutCart(Id accountId) {
		// Query Cart and CartItems

		Cart__c cart = [SELECT Id, Name__c, Account__c, Name,
		(SELECT Id, Product__c, Quantity__c, Price__c FROM CartItems__r)
		FROM Cart__c
		WHERE Account__c = :accountId LIMIT 1];

		// Create the Order
		Order__c order = new Order__c();
		order.Account__c = cart.Account__c;
		order.Name__c = cart.Name + ' Order';
		insert order;

		// Create OrderItems based on CartItems
		List<OrderItem__c> orderItems = new List<OrderItem__c>();
		for (CartItem__c cartItem : cart.CartItems__r) {
			OrderItem__c orderItem = new OrderItem__c();
			orderItem.OrderId__c = order.Id;
			orderItem.ProductId__c = cartItem.Product__c;
			orderItem.Quantity__c = cartItem.Quantity__c;
			orderItem.Price__c = cartItem.Price__c;
			orderItems.add(orderItem);
		}
		insert orderItems;

		// Return the order Id for redirection
		return order.Id;
	}
}
