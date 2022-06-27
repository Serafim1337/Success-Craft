@isTest
public class PaymentTriggerControllerTest {
 	@isTest
    static void testController() {
        Opportunity opp = new Opportunity(Name = 'TesterTrigger1', CloseDate = Date.today(), StageName = 'Qualifying', Amount = 100000);
        insert opp;
        List<RestWebService.PaymentClass> payments = new List<RestWebService.PaymentClass>();
        for(Integer i = 0; i < 10; i++) {
            RestWebService.PaymentClass p = new RestWebService.PaymentClass(opp.Id,String.valueOf(10000*i),'f'+i,'l'+i);
            payments.add(p);
        }
        
        List<Task> tasksBefore = [SELECT ReminderDateTime FROM Task WHERE WhatId =: opp.Id];
        
        Test.startTest();
        RestWebService.requestManager(payments);
        Test.stopTest();
        Opportunity oppAfter = [SELECT StageName FROM Opportunity WHERE Name = 'TesterTrigger1'];
        System.assertEquals('Fully paid', oppAfter.StageName);
        
        List<Task> tasksAfter = [SELECT ReminderDateTime FROM Task WHERE WhatId =: opp.Id];
        
        System.assertEquals(0, tasksBefore.size());
        System.assertEquals(1, tasksAfter.size());
        
        Integer year = Datetime.now().year();
        Integer month = Datetime.now().month();
        Integer day = Datetime.now().day() + 2;
        Datetime testReminder = Datetime.newInstance(year, month, day, 10,0,0);
        
        System.assertEquals(testReminder, tasksAfter.get(0).ReminderDateTime);
    } 
}