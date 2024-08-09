@isTest
public class filterTest {

	@isTest
	static void testProductFilter() {
		Account acc = new Account(Name = 'Test Account');
		insert acc;

		Product__c prod1 = new Product__c(Name__c = 'Product 1', Family__c = 'Grocery Staples', Type__c = 'Beverages', Description__c = 'Simple Description', Price__c = 10);
		Product__c prod2 = new Product__c(Name__c = 'Product 2', Family__c = 'Bakery products', Type__c = 'Frozen Foods', Description__c = 'Simple Description', Price__c = 10);
		Product__c prod3 = new Product__c(Name__c = 'Product 3', Family__c = 'Grocery Staples', Type__c = 'Beverages', Description__c = 'Simple Description', Price__c = 10);
		insert new List<Product__c>{prod1, prod2, prod3};

		Map<String, String> filters = new Map<String, String>{
		'family' => 'Grocery Staples'
		};

		Test.startTest();
		List<Product__c> filteredProducts = productController.getFilteredProducts(filters, '');
		Test.stopTest();

		System.assertEquals(2, filteredProducts.size(), 'There should be two products matching the filter criteria.');
		System.assertEquals(True, filteredProducts.contains(prod1), 'Product 1 should be in the filtered results.');
		System.assertEquals(True, filteredProducts.contains(prod3), 'Product 3 should be in the filtered results.');
		System.assertNotEquals(True, filteredProducts.contains(prod2), 'Product 2 should not be in the filtered results.');
	}
}
