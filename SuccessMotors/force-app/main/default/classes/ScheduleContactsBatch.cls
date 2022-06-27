public with sharing class ScheduleContactsBatch implements Schedulable{

    public void execute(SchedulableContext sc) {

        Id batchId = Database.executeBatch(new ContactsBatch());

    }

}