import { LightningElement, api,wire} from 'lwc';

import getAccounts from '@salesforce/apex/reportLwcController.getAccounts';

export default class ReportLwc extends LightningElement {
  @api view

  @wire(getAccounts) accounts

  renderedCallback() {
    let oppsBlocks = this.template.querySelectorAll('.opps-block');

    for(let ob of oppsBlocks) {
      if(ob.children.length > 0) {

        let amountElements = ob.children;
        let sum = 0;

        for(let elem of amountElements) {
          
          let amounts = elem.textContent.substring(elem.textContent.indexOf('=')+1);
          sum+= parseInt(amounts);

          }

          console.log(sum);

          ob.lastElementChild.textContent = 'Sum= ' + sum;

        }

      }

    }

    linksHandler(event) {
      let id = event.target.dataset.targetId;
      let url = 'https://successcraft56-dev-ed.lightning.force.com/lightning/r/Opportunity/'+ id +'/view';
      window.open(url, '_blank')
    }

  }

  
