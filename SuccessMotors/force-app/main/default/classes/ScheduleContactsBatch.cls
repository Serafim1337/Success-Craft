public with sharing class ScheduleContactsBatch implements Schedulable{

    public void execute(SchedulableContext sc) {

        Id batchId = Database.executeBatch(new ContactsBatch());

    }
}


// ScheduleContactsBatch m = new ScheduleContactsBatch();
// String sch = '0 35 17 * * ?';
// String jobID = system.schedule('Job', sch, m);