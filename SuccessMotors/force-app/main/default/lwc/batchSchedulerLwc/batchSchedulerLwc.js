import { LightningElement,track,api,wire } from 'lwc';

import scheduleBatch from '@salesforce/apex/BatchSchedulerLwcController.scheduleBatch';
import abortBatch from '@salesforce/apex/BatchSchedulerLwcController.abortBatch';
import runBatch from '@salesforce/apex/BatchSchedulerLwcController.runBatch';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class BatchSchedulerLwc extends LightningElement {

  //!---Settings
  @api batchName;
  @api schedulerName;
  @api jobName;
  //!---Settings

  @track view = true;

  @track inputValue = '0 0 12 * * ?';

  handleInputFieldChange(e) {
    this.inputValue = e.target.value.trim();
  }


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

      scheduleBatch({cronString: this.inputValue,
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

      this.template.querySelector('.input').disabled = true;
      
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

    this.template.querySelector('.input').disabled = false;
  }
}