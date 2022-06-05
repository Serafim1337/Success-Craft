@isTest
public class InvoicePdfControllerTest {
    @isTest
    static void controllerTest() {

        Account acc = new Account(Name = 'Tester');
        insert acc;

        Contact cont = new Contact(FirstName = 'Test', LastName = 'Guy', Email = 'test@gmail.com', AccountId = acc.Id);
        insert cont;

        Opportunity opp = new Opportunity(Name = 'oppTest', StageName = 'Prospecting', CloseDate = Date.newInstance(2022, 6, 17));
        insert opp;

        OpportunityContactRole oppCr = new OpportunityContactRole(OpportunityId = opp.Id, ContactId = cont.Id, IsPrimary = true, Role = 'Business User');
        insert oppCr;

        PageReference page = new ApexPages.StandardController(opp).view();
        InvoicePdfController controller = new InvoicePdfController();

        System.assertEquals('Tester', controller.oppContactCompany.Name);

        System.assertEquals('Test Guy', controller.oppContact.Name);

        System.assertEquals(opp.Id, controller.currentRecord.Id);

        System.assertEquals(cont.Id, controller.oppContRole.ContactId);
    }
}