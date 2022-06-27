public with sharing class PaymentTriggerController {
    public static void createTask(List<Opportunity> oppsForTasks) {
        List<Task> tasks = new List<Task>();

        for(Opportunity opp : oppsForTasks) {
            Task t = new Task();
            t.Subject = 'Delivery of goods';
            t.Priority = 'High';
            t.Status = 'Not Started';
            t.IsReminderSet = true;

            Integer year = Datetime.now().year();
            Integer month = Datetime.now().month();
            Integer day = Datetime.now().day() + 2;
            t.ReminderDateTime = Datetime.newInstance(year, month, day, 10,0,0);

            t.OwnerId = opp.CreatedById;
            t.WhatId = opp.Id;

            tasks.add(t);
        }

        insert tasks;
    }
}