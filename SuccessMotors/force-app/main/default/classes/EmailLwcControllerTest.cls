@isTest
public class EmailLwcControllerTest {
    @testSetup
    static void setup() {

        Contact cont = new Contact(FirstName = 'Test', LastName = 'Guy', Email = 'test@gmail.com');
        insert cont;

        Opportunity opp = new Opportunity(Name = 'oppTest', StageName = 'Prospecting', CloseDate = Date.newInstance(2022, 6, 17));
        insert opp;

        OpportunityContactRole oppCr = new OpportunityContactRole(OpportunityId = opp.Id, ContactId = cont.Id, IsPrimary = true, Role = 'Business User');
        insert oppCr;

        Blob testBlob;

        Attachment att = new Attachment(ParentId = opp.Id, Name = 'Test Attachment', Body = Blob.valueOf('Unit Test Attachment Body'));
        insert att;

    }

    @isTest
    static void getTemplateDataTest() {
        String templateExpected = 'Invoice Template';
        EmailTemplate actual = EmailLwcController.getTemplateData();
        System.assertEquals(templateExpected, actual.Name);
    }

    @isTest
    static void getContactDataTest() {
        Opportunity opp = [SELECT Id FROM Opportunity WHERE Name = 'oppTest'];
        Contact res = EmailLwcController.getContactData(opp.Id);
        System.assertEquals('Test Guy', res.Name);
        System.assertEquals('test@gmail.com', res.Email);
    }

    @isTest
    static void getAttachmentTest() {
        Opportunity opp = [SELECT Id FROM Opportunity WHERE Name = 'oppTest'];
        Attachment res = EmailLwcController.getAttachment(opp.Id);
        System.assertEquals('Test Attachment', res.Name);
    }

    @isTest
    static void sendEmailToControllerTest() {
        Opportunity opp = [SELECT Id FROM Opportunity WHERE Name = 'oppTest'];

        Test.startTest();

        List < Exception > exceptions = new List < Exception > ();

        try {
            EmailLwcController.sendEmailToController('body', 'test@gmail.com', 'subject', 'fileName', opp.Id);
        } catch (Exception ex) {
            exceptions.add(ex);
        }

        Test.stopTest();

        System.assertEquals(1, exceptions.size());
    }
}