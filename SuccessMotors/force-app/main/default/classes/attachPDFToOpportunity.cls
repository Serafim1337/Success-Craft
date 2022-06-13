public class attachPDFToOpportunity {

	private final Opportunity opp;

	public attachPDFToOpportunity(ApexPages.StandardController standardPageController) {
			opp = (Opportunity) standardPageController.getRecord();
	}

	public PageReference attachPDF() {

			Opportunity currentOpp = [SELECT Invoice_Number__c,Id
					FROM Opportunity
					WHERE Id =: opp.Id
			];

			PageReference pdfPage = Page.InvoicePdf;
			Blob pdfBlob;
			if (!Test.isRunningTest()) {
					pdfPage.getParameters().put('Id', opp.Id);
					pdfBlob = pdfPage.getContent();
			} else {
					pdfBlob = Blob.valueOf('Empty pdf');
			}

			String currentId = opp.Id;
		
			List<ContentDocumentLink> links = Database.query('Select ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId=: currentId');
			
			if(links.size() < 1) {

				ContentVersion cv = new ContentVersion();
				cv.Title = currentOpp.Invoice_Number__c;
				cv.PathOnClient = currentOpp.Invoice_Number__c + '.pdf';
				cv.VersionData = pdfBlob;
				cv.IsMajorVersion = true;
	
				insert cv;
	
				Id conDocId = [SELECT ContentDocumentId 
											FROM ContentVersion 
											WHERE Id =:cv.Id].ContentDocumentId;
	
				ContentDocumentLink cdl = new ContentDocumentLink();
				cdl.LinkedEntityId = currentOpp.Id;
				cdl.ContentDocumentId = conDocId;
				cdl.shareType = 'V';
	
				insert cdl;

			} else {

				ContentDocumentLink cdl = [SELECT ContentDocumentId FROM    ContentDocumentLink WHERE LinkedEntityId =: currentId];

        ContentVersion contentVersion = new ContentVersion(
            ContentDocumentId = cdl.ContentDocumentId,
            Title = currentOpp.Invoice_Number__c,
            PathOnClient = currentOpp.Invoice_Number__c + '.pdf',
            ReasonForChange = 'Document replaced by user',
            VersionData = pdfBlob,
            IsMajorVersion = true
        );

        insert contentVersion;
				
			}

			PageReference pageWhereWeWantToGo = new ApexPages.StandardController(opp).view();
			pageWhereWeWantToGo.setRedirect(true);
			return pageWhereWeWantToGo;
	}

}