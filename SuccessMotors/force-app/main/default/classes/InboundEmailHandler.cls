global class InboundEmailHandler implements Messaging.InboundEmailHandler {
    
        global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {

                Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
               
                String invoiceNumber = email.subject.right(10);

                Opportunity opp = [SELECT Name, StageName 
                FROM Opportunity 
                WHERE Invoice_Number__c=:invoiceNumber
                WITH SECURITY_ENFORCED];

                String[] stages = new String[]{'Prospecting',
                'Qualification', 
                'Needs Analysis',
                'Value Proposition',
                'Id. Decision Makers',
                'Perception Analysis',
                'Proposal/Price Quote',
                'Negotiation/Review',
                'Closed Won'
                };

                if(email.plainTextBody.toLowerCase().contains('approved')) {
                        if(opp.StageName != 'Closed Won') {
                      Integer pos =  stages.indexOf(opp.StageName);
                      opp.StageName = stages.get(pos+1);
                        }
                } else if(email.plainTextBody.toLowerCase().contains('rejected')){
                        opp.StageName = 'Closed Lost';
                }

                update opp;
  

                return result;
        }

        
}
