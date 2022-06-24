public with sharing class BatchSchedulerLwcController {

    @AuraEnabled
    public static void scheduleBatch(String cronString, String batchName, String schedulerName, String jobName){

            Type dynamicApexType = Type.forName(schedulerName);
            Schedulable schedulerInstance = (Schedulable) dynamicApexType.newInstance();
            
            String sch = cronString;
            String jobID = system.schedule(jobName, sch, schedulerInstance);      
    }

    @AuraEnabled
    public static void abortBatch(String jobName) {
        
        CronTrigger jobRecord = [SELECT Id FROM CronTrigger WHERE CronJobDetail.Name =: jobName];
        System.abortJob(jobRecord.Id);
    }

    @AuraEnabled
    public static void runBatch(String batchName) {

        Type dynamicApexType = Type.forName(batchName);

        Database.Batchable<SObject> batchInstance = (Database.Batchable<SObject>) dynamicApexType.newInstance();

        Id batchId = Database.executeBatch(batchInstance);
    }

}
