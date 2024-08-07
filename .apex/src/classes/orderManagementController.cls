public class orderManagementController {
	@AuraEnabled(cacheable=true)
	public static Account getAccountDetails(Id accountId) {
		return [SELECT Id, Name, AccountNumber FROM Account WHERE Id = :accountId LIMIT 1];
	}
}
