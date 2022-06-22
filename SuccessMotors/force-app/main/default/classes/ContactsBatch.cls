public with sharing class ContactsBatch implements Database.Batchable<SObject>{

    public static List<Contact> BIRTHDAY_CONTACTS = null;


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

        System.debug(contsWithBday);
        //BIRTHDAY_CONTACTS = contsWithBday;

        for(Contact c : contsWithBday) {
            BirthdayEmailSender.sendBirthdayEmail(c);
        }
        
    }

    public void finish (Database.BatchableContext bc) {
        // List<Contact> contsToEmail = new List<Contact>();
        // contsToEmail = BIRTHDAY_CONTACTS;
        
        // for(Contact c : BIRTHDAY_CONTACTS) {
        //     BirthdayEmailSender.sendBirthdayEmail(c);
        // }
    }

}
