@isTest
public class attachPDFToOpportunityTest {
    @isTest
    static void attachPDFTestOnNoContentVersion() {
        PageReference pageRef = Page.InvoicePdf;
        Test.setCurrentPage(pageRef);


        Opportunity opp = new Opportunity(Name = 'oppTest', StageName = 'Prospecting', CloseDate = Date.newInstance(2022, 6, 17));
        insert opp;

        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        attachPDFToOpportunity a = new attachPDFToOpportunity(sc);
        
        

        PageReference res = a.attachPDF();
    }
    
    @isTest
    static void attachPDFTestOnExistingContentVersion() {
        PageReference pageRef = Page.InvoicePdf;
        Test.setCurrentPage(pageRef);


        Opportunity opp = new Opportunity(Name = 'oppTest', StageName = 'Prospecting', CloseDate = Date.newInstance(2022, 6, 17));
        insert opp;

        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        attachPDFToOpportunity a = new attachPDFToOpportunity(sc);
        
        ContentVersion cv = new ContentVersion();
				cv.Title = opp.Invoice_Number__c;
				cv.PathOnClient = opp.Invoice_Number__c + '.pdf';
				cv.VersionData = Blob.valueOf('file');
				cv.IsMajorVersion = true;
	
				insert cv;
	
				Id conDocId = [SELECT ContentDocumentId 
											FROM ContentVersion 
											WHERE Id =:cv.Id].ContentDocumentId;
	
				ContentDocumentLink cdl = new ContentDocumentLink();
				cdl.LinkedEntityId = opp.Id;
				cdl.ContentDocumentId = conDocId;
				cdl.shareType = 'V';
	
				insert cdl;

        PageReference res = a.attachPDF();
    }
}