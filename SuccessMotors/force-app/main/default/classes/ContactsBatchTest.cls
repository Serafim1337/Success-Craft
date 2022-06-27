@isTest
public class ContactsBatchTest {
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
    static void testBatch() {
        
        List<AsyncApexJob> jobs = [SELECT Id 
        FROM AsyncApexJob
        WHERE ApexClass.Name = 'ContactsBatch'];
        Integer sizeBefore = jobs.size();
        
        Test.startTest();
       
        Id batchId = Database.executeBatch(new ContactsBatch());

        Test.stopTest();
        
        jobs = [SELECT Id 
        FROM AsyncApexJob
        WHERE ApexClass.Name = 'ContactsBatch'];
        Integer sizeAfter = jobs.size();
        
        System.assert(sizeBefore<sizeAfter);
        
    }
}