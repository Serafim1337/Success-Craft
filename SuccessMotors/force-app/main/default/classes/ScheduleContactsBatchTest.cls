@isTest
public class ScheduleContactsBatchTest {
	@testSetup
    static void setup() {
        List<Contact> contacts = new List<Contact>();
        for(Integer i = 0 ; i < 10 ; i++) {
            Contact c = new Contact(FirstName = 'Tester ' + i,
                                   LastName = 'Test ' + i,
                                   Birthdate = Date.today(),
                                    Email = 'tester' + i + '@gmail.com');
            contacts.add(c);
        }
        insert contacts;
    }
    @isTest
    static void scheduleTest() {
        List<CronTrigger> jobRecord = [SELECT Id FROM CronTrigger WHERE CronJobDetail.Name =: 'ScheduleJob'];
        System.assertEquals(jobRecord.size(),0);
        
        Test.startTest();
        ScheduleContactsBatch m = new ScheduleContactsBatch();
		String sch = '0 35 17 * * ?';
		String jobID = system.schedule('ScheduleJob', sch, m);
        Test.stopTest();
        
        jobRecord = [SELECT Id FROM CronTrigger WHERE CronJobDetail.Name =: 'ScheduleJob'];
        System.assertEquals(jobRecord.size(),1);
    }
}