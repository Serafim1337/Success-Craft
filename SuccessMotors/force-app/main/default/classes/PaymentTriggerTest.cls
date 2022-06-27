@isTest
public class PaymentTriggerTest {
	@isTest
    static void testTriggerFullPay() {
        Opportunity opp = new Opportunity(Name = 'TesterTrigger1', CloseDate = Date.today(), StageName = 'Qualifying', Amount = 100000);
        insert opp;
        List<RestWebService.PaymentClass> payments = new List<RestWebService.PaymentClass>();
        for(Integer i = 0; i < 10; i++) {
            RestWebService.PaymentClass p = new RestWebService.PaymentClass(opp.Id,String.valueOf(10000*i),'f'+i,'l'+i);
            payments.add(p);
        }
        
        Test.startTest();
        RestWebService.requestManager(payments);
        Test.stopTest();
        Opportunity oppAfter = [SELECT StageName FROM Opportunity WHERE Name = 'TesterTrigger1'];
        System.assertEquals('Fully paid', oppAfter.StageName);
    }
    @isTest
    static void testTriggerPartialPay() {
        Opportunity opp = new Opportunity(Name = 'TesterTrigger2', CloseDate = Date.today(), StageName = 'Qualifying', Amount = 1000000);
        insert opp;
        List<RestWebService.PaymentClass> payments = new List<RestWebService.PaymentClass>();
        for(Integer i = 0; i < 10; i++) {
            RestWebService.PaymentClass p = new RestWebService.PaymentClass(opp.Id,String.valueOf(5000*i),'f'+i,'l'+i);
            payments.add(p);
        }
        
        Test.startTest();
        RestWebService.requestManager(payments);
        Test.stopTest();
        Opportunity oppAfter = [SELECT StageName FROM Opportunity WHERE Name = 'TesterTrigger2'];
        System.assertEquals('Partially Paid', oppAfter.StageName);
    }
}