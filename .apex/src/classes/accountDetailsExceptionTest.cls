@isTest
public class accountDetailsExceptionTest {

	@isTest
	static void testInvalidAccountIdHandling() {
		// Test data
		Id invalidAccountId = '00t000000000000';

		// Perform test
		Test.startTest();
		Boolean exceptionThrown = false;
		try {
			// Attempt to get product details with an invalid ID
			accountController.getAccountDetails(invalidAccountId);
		} catch (Exception e) {
			exceptionThrown = true;
		}
		Test.stopTest();

		// Assert that an exception was thrown
		System.assert(exceptionThrown, 'An exception should be thrown for an invalid Product ID.');
	}
}
