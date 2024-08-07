public class accountController {
	@AuraEnabled(cacheable=true)
	public static Account getAccountDetails(Id accountId) {
		if (accountId == null) {
			throw new AuraHandledException('Account ID cannot be null.');
		}
		return [SELECT Name, AccountNumber FROM Account WHERE Id = :accountId LIMIT 1];
	}
}
