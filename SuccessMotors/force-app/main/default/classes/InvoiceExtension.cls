public class InvoiceExtension {
  public Opportunity currentRecord{get; set;}
    
    public InvoiceExtension(ApexPages.StandardController controller) {
        currentRecord = [SELECT Id, Name, Amount FROM Opportunity WHERE Id = :ApexPages.currentPage().getParameters().get('id')];
    }
}