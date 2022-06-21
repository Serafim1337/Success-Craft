trigger PaymentTrigger on Payment__c (after insert) {

  List<Payment__c> recentPayments = new List<Payment__c>();
  for(Payment__c pay : Trigger.new) {
    recentPayments.add(pay);
  }

  Set<Id> oppsIds = new Set<Id>();

  for (Payment__c pay : recentPayments) {
    oppsIds.add(pay.Opportunity__c);
  }

  List<Payment__c> allPayments = [SELECT Id, Amount__c, Opportunity__c 
  FROM Payment__c 
  WHERE Opportunity__c IN:oppsIds];

  List<Opportunity> oppsToCheck = [SELECT Id, Name, Amount, CreatedById 
  FROM Opportunity
  WHERE Id IN:oppsIds];

  List<Opportunity> oppsToUpdate = new List<Opportunity>();
  List<Opportunity> oppsToSetTask = new List<Opportunity>();

  for(Opportunity opp : oppsToCheck) {
    Decimal oppAmount = 0;
    Decimal paymentsAmount = 0;
    oppAmount = opp.Amount;
    for(Payment__c pay : allPayments) {
      if(pay.Opportunity__c == opp.Id) {
        paymentsAmount += pay.Amount__c;
      }
    }

    if(oppAmount > paymentsAmount) {
      opp.StageName = 'Partially Paid';
    } else {
      opp.StageName = 'Fully Paid';
      oppsToSetTask.add(opp);
    }

    oppsToUpdate.add(opp);

  }

  PaymentTriggerController.createTask(oppsToSetTask);

  update oppsToUpdate;
}