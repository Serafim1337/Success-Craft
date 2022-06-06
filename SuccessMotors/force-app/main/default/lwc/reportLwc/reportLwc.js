import {
  LightningElement,
  api,
  wire,
  track
} from 'lwc';

import getAccounts from '@salesforce/apex/reportLwcController.getAccounts';
import searchAccounts from '@salesforce/apex/reportLwcController.searchAccounts';
import getSingleAccount from '@salesforce/apex/reportLwcController.getSingleAccount';
import getProducts from '@salesforce/apex/reportLwcController.getProducts';

export default class ReportLwc extends LightningElement {
  @api recordId

  @wire(getSingleAccount, {
      accountId: '$recordId'
  }) singleAccount

  @api view

  accounts

  @wire(getAccounts) accounts

  visibleAccounts

  updateAccountHandler(event) {
      this.visibleAccounts = [...event.detail.records];
  }

  renderedCallback() {
      let accordions = this.template.querySelectorAll('.accordion-section');
      for(let a of accordions) {
        let name = a.dataset.name;
        let sum = a.dataset.sum || ' ';
  
        a.label=`${name} : ${sum}`;
      }
  }

   columns = [
    { label: 'Name', fieldName: 'Name' },
    { label: 'Amount', fieldName: 'Amount', type: 'currency' },
    { label: 'Created Date', fieldName: 'CreatedDate', type: 'date' },
    { label: 'Close Date', fieldName: 'CloseDate', type: 'date' },
];

@track openModal = false;

@api oppId

@wire(getProducts, {oppId: '$oppId'}) products

    showModal(event) {
        this.openModal = true;
        this.oppId = event.target.dataset.oppId;
    }
    closeModal() {
        this.openModal = false;
    }

  @api searchTerm = ''

  @wire(searchAccounts, {
      searchTerm: '$searchTerm'
  }) accounts

  searchHandler(event) {

      window.clearTimeout(this.delayTimeout);

      const searchTerm = event.target.value;

      this.delayTimeout = setTimeout(() => {
          this.searchTerm = searchTerm;
      }, 300);

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
      windowFeatures = "width=" + 800;
      windowFeatures += ",height=" + 800;

      window.open(url, '_blank', windowFeatures);
  }

}