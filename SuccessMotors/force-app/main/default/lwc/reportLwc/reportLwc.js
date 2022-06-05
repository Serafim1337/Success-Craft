import {
  LightningElement,
  api,
  wire
} from 'lwc';

import getAccounts from '@salesforce/apex/reportLwcController.getAccounts';
import searchAccounts from '@salesforce/apex/reportLwcController.searchAccounts';
import getSingleAccount from '@salesforce/apex/reportLwcController.getSingleAccount';

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