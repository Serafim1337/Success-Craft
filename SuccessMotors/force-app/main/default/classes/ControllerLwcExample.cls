public with sharing class ControllerLwcExample {
    @AuraEnabled(cacheable=true)
    public static void sendEmailToController(String body, String toSend, String subject, String fileName, String oppId){
        try{
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {toSend};
            mail.setToAddresses(toAddresses);
            mail.setSubject(subject);
            mail.setHtmlBody('<h1>'+ body + '</h1>');
            
            OrgWideEmailAddress owea = [SELECT 
            Id,Address 
            FROM OrgWideEmailAddress
            WHERE DisplayName = 'New email'];
            mail.setOrgWideEmailAddressId(owea.Id);

            PageReference pdfPage = Page.InvoicePdf;
            Blob pdfBlob;
            pdfPage.getParameters().put('Id', oppId);
            pdfBlob = pdfPage.getContent();

            Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
            attachment.setContentType('application/pdf');
            attachment.setFileName(fileName+'.pdf');
            attachment.setInline(false);
            attachment.setBody(pdfBlob);

            mail.setFileAttachments(new Messaging.EmailFileAttachment[]{ attachment });
        
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }catch(Exception ex){
            throw new AuraHandledException(ex.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static EmailTemplate getTemplateData() {
        return [SELECT 
        Id,Subject,Description,HtmlValue,DeveloperName,Body 
        FROM EmailTemplate 
        WHERE name = 'Invoice Template'
        WITH SECURITY_ENFORCED];
    }

    @AuraEnabled(cacheable=true)
    public static Contact getContactData(String oppId) {

        OpportunityContactRole cr = [SELECT ContactId
        FROM OpportunityContactRole
        WHERE OpportunityId=:oppId];

        Contact cont = [SELECT Name, Email
        FROM Contact
        WHERE Id=: cr.ContactId];

        return cont;
    } 

    @AuraEnabled(cacheable=true)
    public static Attachment getAttachment(String oppId) {
        return [SELECT Name
        FROM Attachment
        WHERE ParentId=:oppId];
    }

    
}