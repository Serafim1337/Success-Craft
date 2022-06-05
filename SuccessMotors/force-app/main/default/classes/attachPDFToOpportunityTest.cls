@isTest
public class attachPDFToOpportunityTest {
    @isTest
    static void attachPDFTest() {
        PageReference pageRef = Page.InvoicePdf;
        Test.setCurrentPage(pageRef);


        Opportunity opp = new Opportunity(Name = 'oppTest', StageName = 'Prospecting', CloseDate = Date.newInstance(2022, 6, 17));
        insert opp;

        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        attachPDFToOpportunity a = new attachPDFToOpportunity(sc);

        PageReference res = a.attachPDF();
    }
}