@isTest
public class InboundEmailHandlerTest {
    @isTest
    static void handleInboundEmailTestOnApproval() {
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();

        Opportunity opp = new Opportunity(Name = 'oppTest', StageName = 'Prospecting', CloseDate = Date.newInstance(2022, 6, 17));
        insert opp;

        email.subject = 'Invoice Number: ' + opp.Invoice_Number__c;
        email.fromAddress = 'someaddress@email.com';
        email.plainTextBody = 'Approved';

        InboundEmailHandler testInbound = new InboundEmailHandler();
        testInbound.handleInboundEmail(email, envelope);

    }

    @isTest
    static void handleInboundEmailTestOnRejection() {
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();

        Opportunity opp = new Opportunity(Name = 'oppTest', StageName = 'Prospecting', CloseDate = Date.newInstance(2022, 6, 17));
        insert opp;

        email.subject = 'Invoice Number: ' + opp.Invoice_Number__c;
        email.fromAddress = 'someaddress@email.com';
        email.plainTextBody = 'Rejected';

        InboundEmailHandler testInbound = new InboundEmailHandler();
        testInbound.handleInboundEmail(email, envelope);

    }
}