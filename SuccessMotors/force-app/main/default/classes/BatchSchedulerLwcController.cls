public with sharing class BatchSchedulerLwcController {

    @AuraEnabled
    public static void scheduleBatch(String cronString, String batchName, String schedulerName){
            ScheduleContactsBatch m = new ScheduleContactsBatch();
            
            String sch = cronString;
            String jobID = system.schedule('ScheduleJob', sch, m);      
    }

    @AuraEnabled
    public static void abortBatch(String jobName) {
        
        CronTrigger jobRecord = [SELECT Id FROM CronTrigger WHERE CronJobDetail.Name =: jobName];
        System.abortJob(jobRecord.Id);
    }

    @AuraEnabled
    public static void runBatch(String batchName) {
        Id batchId = Database.executeBatch(new ContactsBatch());
    }

}
