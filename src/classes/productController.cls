public with sharing class productController {
	@AuraEnabled(cacheable=true)
	public static Map<String, List<String>> getPicklistValues() {
		Map<String, List<String>> picklistValues = new Map<String, List<String>>();

		// Retrieve picklist values for Family field
		Schema.DescribeFieldResult familyField = Product__c.Family__c.getDescribe();
		picklistValues.put('Family', new List<String>());
		for (Schema.PicklistEntry entry : familyField.getPicklistValues()) {
			picklistValues.get('Family').add(entry.getValue());
		}

		// Retrieve picklist values for Type field
		Schema.DescribeFieldResult typeField = Product__c.Type__c.getDescribe();
		picklistValues.put('Type', new List<String>());
		for (Schema.PicklistEntry entry : typeField.getPicklistValues()) {
			picklistValues.get('Type').add(entry.getValue());
		}

		return picklistValues;
	}
	@AuraEnabled(cacheable=true)
	public static List<Product__c> getFilteredProducts(Map<String, String> filters) {
		String familyFilter = filters.containsKey('family') ? filters.get('family') : null;
		String typeFilter = filters.containsKey('type') ? filters.get('type') : null;
		String searchTerm = filters.containsKey('searchTerm') ? '%' + filters.get('searchTerm') + '%' : null;

		String query = 'SELECT Id, Name, Family__c, Type__c, Description__c FROM Product__c WHERE ';
		List<String> conditions = new List<String>();

		if (familyFilter != null && familyFilter != '') {
			conditions.add('Family__c = :familyFilter');
		}

		if (typeFilter != null && typeFilter != '') {
			conditions.add('Type__c = :typeFilter');
		}

		if (searchTerm != null && searchTerm != '%%') {
			conditions.add('(Name LIKE :searchTerm OR Description__c LIKE :searchTerm)');
		}

		if (conditions.size() > 0) {
			query += String.join(conditions, ' AND ');
		} else {
			query += '1 = 1'; // No filters, return all products
		}

		return Database.query(query);
	}

	@AuraEnabled
	public static void createProduct(String name, String description, String family, String type) {
		Product__c newProduct = new Product__c(
				Name__c = name,
				Description__c = description,
				Family__c = family,
				Type__c = type
		);
		insert newProduct;
	}

}
