public with sharing class BatchSchedulerLwcController {

    @AuraEnabled
    public static void scheduleBatch(){
            ScheduleContactsBatch m = new ScheduleContactsBatch();
            String sch = '0 35 17 * * ?';
            String jobID = system.schedule('ScheduleJob', sch, m);      
    }

    @AuraEnabled
    public static void abortBatch(String name) {
        
        CronTrigger jobRecord = [SELECT Id FROM CronTrigger WHERE CronJobDetail.Name =: name];
        System.abortJob(jobRecord.Id);
    }

}
