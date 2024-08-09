@isTest
public class picklistValuesTest {

	@isTest
	static void testGetPicklistValues() {

		Test.startTest();
		Map<String, List<String>> picklistValues = productController.getPicklistValues();
		Test.stopTest();

		System.assertNotEquals(null, picklistValues, 'Picklist values map should not be null.');
		System.assert(picklistValues.containsKey('Family'), 'Picklist values should contain a key for Family.');
		System.assert(picklistValues.containsKey('Type'), 'Picklist values should contain a key for Type.');

		List<String> familyValues = picklistValues.get('Family');
		List<String> typeValues = picklistValues.get('Type');

		System.assertNotEquals(0, familyValues.size(), 'Family picklist values should not be empty.');
		System.assertNotEquals(0, typeValues.size(), 'Type picklist values should not be empty.');


		 System.assert(familyValues.contains('Grocery Staples'), 'Family picklist should contain the expected value.');
		 System.assert(typeValues.contains('Beverages'), 'Type picklist should contain the expected value.');
	}
}
