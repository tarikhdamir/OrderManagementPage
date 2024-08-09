@isTest
public class searchboxTest {

	@isTest
	static void testSearchBox() {
		Account acc = new Account(Name = 'Test Account');
		insert acc;

		Product__c prod1 = new Product__c(Name__c = 'Apple Juice', Family__c = 'Grocery Staples', Type__c = 'Beverages', Description__c = 'Simple Description', Price__c = 10);
		Product__c prod2 = new Product__c(Name__c = 'Frozen Pizza', Family__c = 'Bakery products', Type__c = 'Frozen Foods', Description__c = 'Simple Description', Price__c = 10);
		insert new List<Product__c>{prod1, prod2};

		Test.startTest();
		List<Product__c> searchResults = productController.getFilteredProducts(new Map<String, String>(), 'Apple');
		Test.stopTest();

		System.assertEquals(1, searchResults.size(), 'There should be one product matching the search query.');
		System.assertEquals(True, searchResults.contains(prod1), 'Apple Juice should be in the search results.');
		System.assertNotEquals(True, searchResults.contains(prod2), 'Frozen Pizza should not be in the search results.');
	}
}
