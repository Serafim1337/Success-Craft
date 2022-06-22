public with sharing class ContactsBatch implements Database.Batchable<SObject>{

    public  Database.QueryLocator start (Database.BatchableContext bc) {
        return Database.getQueryLocator('SELECT Id, FirstName, LastName, Birthdate, Email, Account.Id FROM Contact');
    }

    public void execute (Database.BatchableContext bc, List<Contact> scope) {
        List<Contact> contsWithBday = new List<Contact>();
        for(Contact s : scope) {
            if(s.Birthdate == Date.today()) {
                contsWithBday.add(s);
            }
        }

        for(Contact c : contsWithBday) {
            BirthdayEmailSender.sendBirthdayEmail(c);
        }
        
    }

    public void finish (Database.BatchableContext bc) {
        
    }

}
