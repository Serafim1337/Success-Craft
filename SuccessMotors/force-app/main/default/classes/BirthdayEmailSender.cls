public with sharing class BirthdayEmailSender {
    public static void sendBirthdayEmail(Contact c) {

        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();

        message.setTargetObjectId(c.Id);
        message.setSenderDisplayName('With great wishes from Success Motors!');
        message.setReplyTo('no-reply@success-motors.com');

        EmailTemplate emailTemplate = [SELECT Id, Subject, Body 
        FROM EmailTemplate 
        WHERE Name = 'Contact Birthday Template'];
        
        message.setTemplateId(emailTemplate.Id);
        message.setWhatId(c.Account.Id);
        message.toAddresses = new String[] {c.Email};   

        Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};

        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
    }
}