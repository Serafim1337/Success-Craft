import { LightningElement,track,api,wire } from 'lwc';

import scheduleBatch from '@salesforce/apex/BatchSchedulerLwcController.scheduleBatch';
import abortBatch from '@salesforce/apex/BatchSchedulerLwcController.abortBatch';
import runBatch from '@salesforce/apex/BatchSchedulerLwcController.runBatch';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class BatchSchedulerLwc extends LightningElement {

  //!---Settings
  batchName = 'ContactsBatch';
  schedulerName = 'ScheduleContactsBatch';
  jobName = 'ScheduleJob'
  //!---Settings

  @track view = true;


  handleRunButton(e){

    runBatch({batchName: this.batchName}).then(()=>{

      const event = new ShowToastEvent({
        title: 'Success',
        message: 'Batch executed',
        variant: 'success',
        mode: 'dismissable',
    });
    this.dispatchEvent(event);

    }).catch(()=>{

    });

    
  }

  handleScheduleButton(e) {

      scheduleBatch({cronString: this.template.querySelector('.input').value,
      batchName: this.batchName,
      schedulerName: this.schedulerName,
      jobName: this.jobName
      }).then(()=>{
       
        const event = new ShowToastEvent({
          title: 'Success',
          message: 'Batch scheduled',
          variant: 'success',
          mode: 'dismissable',
      });
      this.dispatchEvent(event);

      }).catch(()=>{
  
      });
      
      this.view = !this.view;
  }

  handleAbortButton(e) {

    abortBatch({jobName: this.jobName}).then(()=>{

      const event = new ShowToastEvent({
        title: 'Success',
        message: 'Batch aborted',
        variant: 'success',
        mode: 'dismissable',
    });
    this.dispatchEvent(event);

    }).catch(()=>{

    });

    this.view = !this.view;
  }
}