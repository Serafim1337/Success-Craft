public with sharing class ControllerLwcExample {
    @AuraEnabled(cacheable=true)
    public static void sendEmailToController(String body, String toSend, String subject){
        try{
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {toSend};
            mail.setToAddresses(toAddresses);
            mail.setSubject(subject);
            mail.setHtmlBody('<h1>'+ body + '</h1>');
        
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
        // OpportunityContactRole cr = [SELECT Contact.Name, Contact.Email 
        // FROM OpportunityContactRole 
        // WHERE OpportunityId=:oppId];
        // return cr;

        OpportunityContactRole cr = [SELECT ContactId
        FROM OpportunityContactRole
        WHERE OpportunityId=:oppId];

        Contact cont = [SELECT Name, Email
        FROM Contact
        WHERE Id=: cr.ContactId];

        return cont;
    } 

    
}