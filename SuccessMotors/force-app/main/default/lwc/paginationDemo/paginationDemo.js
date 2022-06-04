import { LightningElement, wire } from 'lwc';
import getAccountList from '@salesforce/apex/DataController.getAccountList'
export default class PaginationDemo extends LightningElement {
  

    
    visibleAccounts
    

    @wire(getAccountList) accounts;

    updateAccountHandler(event){
        this.visibleAccounts=[...event.detail.records]
        console.log(event.detail.records)
    }
}