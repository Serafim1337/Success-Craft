public class attachPDFToOpportunity {
	
	private final Opportunity opp; 
	
	
	public attachPDFToOpportunity(ApexPages.StandardController standardPageController) {
		opp = (Opportunity)standardPageController.getRecord();
	}
	
	
	public PageReference attachPDF() {
		
        Opportunity currentOpp = [SELECT Invoice_Number__c
                                 FROM Opportunity
                                 WHERE Id=:opp.Id];
        
        String attachQuery = currentOpp.Invoice_Number__c+'.pdf';
        
        List<Attachment> att =  Database.query('SELECT Name FROM Attachment WHERE Name=: attachQuery');
        if(att.size()>0) {
            Attachment attToDelete = [SELECT Name 
                                      FROM Attachment 
                                      WHERE Name=: attachQuery];
            delete attToDelete;
        }
        
		PageReference pdfPage = Page.InvoicePdf; 
		Blob pdfBlob; 
		if (!Test.isRunningTest()) { 
            pdfPage.getParameters().put('Id',opp.Id);
			pdfBlob = pdfPage.getContent(); 
		} else { 
			pdfBlob = Blob.valueOf('Empty pdf');
		}
		Attachment attach = new Attachment(parentId = opp.Id, Name = currentOpp.Invoice_Number__c+'.pdf', body = pdfBlob); 
		insert attach; 
		
		
		PageReference pageWhereWeWantToGo = new ApexPages.StandardController(opp).view(); 
		pageWhereWeWantToGo.setRedirect(true); 
		return pageWhereWeWantToGo; 
	}

}