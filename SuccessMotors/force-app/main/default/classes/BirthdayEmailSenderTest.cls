@isTest
public class BirthdayEmailSenderTest {
	@isTest
    static void sendBirthdayEmailTest() {
        Contact c = new Contact(FirstName = 'Tester ',
                                   LastName = 'Test ',
                                   Birthdate = Date.today(),
                                   Email = 'tester@gmail.com');
        insert c;
        
        Test.startTest();
        System.assertEquals(0, Limits.getEmailInvocations());
        BirthdayEmailSender.sendBirthdayEmail(c);
        System.assertEquals(1, Limits.getEmailInvocations());
        Test.stopTest();
    }
}