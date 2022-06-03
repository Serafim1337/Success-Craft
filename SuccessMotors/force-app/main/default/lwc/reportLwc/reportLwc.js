import { LightningElement, api,wire} from 'lwc';

import getAccounts from '@salesforce/apex/reportLwcController.getAccounts';

export default class ReportLwc extends LightningElement {
  @api view

  @wire(getAccounts) accounts

  handleSumAmount(event) {
    // let target = event.target;

    // let parent = target.parentElement;

    // let amounts = parent.querySelectorAll('.amount');

    // let sum = 0;

    // for(let a of amounts) {
    //   sum+= parseInt(a.textContent());
    // }

    // target.textContent = sum;
  }
}