public with sharing class productController {
	@AuraEnabled(cacheable=true)
	public static Map<String, List<String>> getPicklistValues() {
		Map<String, List<String>> picklistValues = new Map<String, List<String>>();

		Schema.DescribeFieldResult familyField = Product__c.Family__c.getDescribe();
		picklistValues.put('Family', new List<String>());
		for (Schema.PicklistEntry entry : familyField.getPicklistValues()) {
			picklistValues.get('Family').add(entry.getValue());
		}

		Schema.DescribeFieldResult typeField = Product__c.Type__c.getDescribe();
		picklistValues.put('Type', new List<String>());
		for (Schema.PicklistEntry entry : typeField.getPicklistValues()) {
			picklistValues.get('Type').add(entry.getValue());
		}

		return picklistValues;
	}
	@AuraEnabled(cacheable=true)
	public static List<Product__c> getFilteredProducts(Map<String, String> filters, String searchTerm) {
		String familyFilter = filters.containsKey('family') ? filters.get('family') : null;
		String typeFilter = filters.containsKey('type') ? filters.get('type') : null;

		String query = 'SELECT Id, Name__c, Family__c, Type__c, Description__c, Price__c FROM Product__c';
		List<String> conditions = new List<String>();

		if (familyFilter != null && familyFilter != '') {
			conditions.add('Family__c = :familyFilter');
		}

		if (typeFilter != null && typeFilter != '') {
			conditions.add('Type__c = :typeFilter');
		}

		if (searchTerm != null && searchTerm != '') {
			String searchPattern = '%' + searchTerm + '%';
			conditions.add('(Name__c LIKE :searchPattern OR Description__c LIKE :searchPattern)');
		}

		if (!conditions.isEmpty()) {
			query += ' WHERE ' + String.join(conditions, ' AND ');
		}

		return Database.query(query);
	}

	@AuraEnabled
	public static void createProduct(String name, String description, String family, String type, Decimal price) {
		Product__c newProduct = new Product__c(
				Name__c = name,
				Description__c = description,
				Family__c = family,
				Type__c = type,
				Price__c = price
		);
		insert newProduct;
	}

}
