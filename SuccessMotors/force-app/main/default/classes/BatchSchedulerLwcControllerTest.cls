@isTest
public class BatchSchedulerLwcControllerTest {
	@testSetup
    static void setup() {
        List<Contact> contacts = new List<Contact>();
        for(Integer i = 0 ; i < 10 ; i++) {
            Contact c = new Contact(FirstName = 'Tester ' + i,
                                   LastName = 'Test ' + i,
                                   Birthdate = Date.today(),
                                   Email = 'tester@gmail.com');
            contacts.add(c);
        }
        insert contacts;
    }
    
    @isTest
    static void scheduleBatchTest() {
        List<CronTrigger> jobRecord = [SELECT Id FROM CronTrigger WHERE CronJobDetail.Name =: 'ScheduleJob'];
        System.assertEquals(jobRecord.size(),0);
        
        Test.startTest();
        BatchSchedulerLwcController.scheduleBatch('0 0 13 * * ?','ContactsBatch','ScheduleContactsBatch','ScheduleJob');
        Test.stopTest();
        
        jobRecord = [SELECT Id FROM CronTrigger WHERE CronJobDetail.Name =: 'ScheduleJob'];
        System.assertEquals(jobRecord.size(),1);
    }
    
    @isTest
    static void abortBatchTest() {
        scheduleBatchTest(); 
        
        BatchSchedulerLwcController.abortBatch('ScheduleJob');
        
        List<CronTrigger> jobRecord = [SELECT Id FROM CronTrigger WHERE CronJobDetail.Name =: 'ScheduleJob'];
        System.assertEquals(jobRecord.size(),0);
    }
    
    @isTest
    static void runBatchTest() {
        List<AsyncApexJob> jobs = [SELECT Id 
        FROM AsyncApexJob
        WHERE ApexClass.Name = 'ContactsBatch'];
        Integer sizeBefore = jobs.size();
        Test.startTest();
        BatchSchedulerLwcController.runBatch('ContactsBatch');
        Test.stopTest();
        jobs = [SELECT Id 
        FROM AsyncApexJob
        WHERE ApexClass.Name = 'ContactsBatch'];
        Integer sizeAfter = jobs.size();
        System.assert(sizeBefore<sizeAfter);

    }
}