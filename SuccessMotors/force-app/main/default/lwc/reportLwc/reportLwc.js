import { LightningElement, api,wire} from 'lwc';

import getAccounts from '@salesforce/apex/reportLwcController.getAccounts';
import searchAccounts from '@salesforce/apex/reportLwcController.searchAccounts';

export default class ReportLwc extends LightningElement {
  @api view

  accounts

  @wire(getAccounts) accounts

  visibleAccounts

  updateAccountHandler(event){
    this.visibleAccounts=[...event.detail.records];
  }

  @api searchTerm = ''

  @wire(searchAccounts, {searchTerm: '$searchTerm'}) accounts
  
  searchHandler(event) {
     
    window.clearTimeout(this.delayTimeout);

		const searchTerm = event.target.value;
		
		this.delayTimeout = setTimeout(() => {
			this.searchTerm = searchTerm;
		}, 300);
    
  }



  renderedCallback() {


    // let oppsBlocks = this.template.querySelectorAll('.opps-block');

    // for(let ob of oppsBlocks) {
    //   if(ob.children.length > 0) {

    //     let amountElements = ob.children;
    //     let sum = 0;

    //     for(let elem of amountElements) {
          
    //       let amounts = elem.textContent.substring(elem.textContent.indexOf('=')+1);
    //       sum+= parseInt(amounts);

    //       }

          

    //       ob.lastElementChild.textContent = 'Sum= ' + sum;

    //     }

    //   } 


    }

    linksHandler(event) {
      let id = event.target.dataset.targetId;
      let url = 'https://successcraft56-dev-ed.lightning.force.com/lightning/r/Opportunity/' + id + '/view';
      window.open(url, '_blank');
    }

    buttonsHandler(event) {
      let id = event.target.dataset.buttonId;
      let url = 'https://successcraft56-dev-ed.lightning.force.com/lightning/r/Opportunity/' + id + '/related/OpportunityLineItems/view';

      let windowFeatures = "menubar=no,resizable=yes,scrollbars=yes";
      windowFeatures  = "width=" + 800;
      windowFeatures += ",height=" + 800;

      window.open(url, '_blank', windowFeatures);
    }

  }

  
