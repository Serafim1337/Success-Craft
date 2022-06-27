@isTest
public class RestWebServiceTest {
	@isTest
    static void testPost() {
        Opportunity opp = new Opportunity(Name = 'Tester', CloseDate = Date.today(), StageName = 'Qualifying', Amount = 100000);
        insert opp;
        List<RestWebService.PaymentClass> payments = new List<RestWebService.PaymentClass>();
        for(Integer i = 0; i < 10; i++) {
            RestWebService.PaymentClass p = new RestWebService.PaymentClass(opp.Id,String.valueOf(10000*i),'f'+i,'l'+i);
            payments.add(p);
        }
        List<Payment__c> paymentsBefore = [SELECT Id FROM Payment__c WHERE Opportunity__c =: opp.Id];
        Test.startTest();
        RestWebService.requestManager(payments);
        Test.stopTest();
        List<Payment__c> paymentsAfter = [SELECT Id FROM Payment__c WHERE Opportunity__c =: opp.Id];
		System.assertEquals(0, paymentsBefore.size());
        System.assertEquals(10, paymentsAfter.size());
    }
}