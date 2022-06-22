import { LightningElement,track,api,wire } from 'lwc';

import scheduleBatch from '@salesforce/apex/BatchSchedulerLwcController.scheduleBatch';
import abortBatch from '@salesforce/apex/BatchSchedulerLwcController.abortBatch';

export default class BatchSchedulerLwc extends LightningElement {

  batchName = 'ContactsBatch';
  schedulerName = 'ScheduleContactsBatch';
  jobName = 'ScheduleJob'
  scheduleDate = '0 35 17 * * ?';

  @track view = true;

  jobId;

  handleRunButton(event) {

  }

  handleScheduleButton(event) {
      scheduleBatch().then(()=>{
       
      }).catch(()=>{
  
      });
      this.view = !this.view;
  }

  handleAbortButton(event) {

    const jobInfo = {
      name: this.jobName,
    };

    abortBatch({name: this.jobName}).then(()=>{

    }).catch(()=>{

    });

    this.view = !this.view;
  }
}