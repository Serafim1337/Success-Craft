import { LightningElement, api, wire, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

import sendEmailToController from '@salesforce/apex/ControllerLwcExample.sendEmailToController';
import getTemplateData from '@salesforce/apex/ControllerLwcExample.getTemplateData';
import getContactData from '@salesforce/apex/ControllerLwcExample.getContactData';

import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import { getSObjectValue } from '@salesforce/apex';

import INVOICE_NUMBER from '@salesforce/schema/Opportunity.Invoice_Number__c';
import TEMPLATE_SUBJECT from '@salesforce/schema/EmailTemplate.Subject';
import TEMPLATE_BODY from '@salesforce/schema/EmailTemplate.Body';
import CONTACT_NAME from '@salesforce/schema/Contact.Name';
import CONTACT_EMAIL from '@salesforce/schema/Contact.Email';

const fields = [INVOICE_NUMBER];


export default class LwcExample extends NavigationMixin (LightningElement) {
    subject = 'Test Email';
    //body = 'Hello';
    toSend = '7620226@gmail.com';

    @api recordId;

    @wire(getRecord, {recordId: '$recordId', fields}) currentOpp;

    

    get invoiceNumber() {
        return getFieldValue(this.currentOpp.data, INVOICE_NUMBER);
    }

    body="";

    sendEmailAfterEvent(){
        const recordInput = {body: this.body == "" ? this.templateBody : this.body, toSend: this.contactEmail, subject: this.templateSubject} ; //You can send parameters
        sendEmailToController(recordInput)
        .then( () => {
            //If response is ok
        }).catch( error => {
            //If there is an error on response
        })
    }

    handleBodyChange(event) {
        this.body = event.target.value;
    }

    @wire(getTemplateData) email;

    get templateSubject() {
        return getSObjectValue(this.email.data, TEMPLATE_SUBJECT);
    }

    get templateBody() {
        return getSObjectValue(this.email.data, TEMPLATE_BODY);
    }

    @wire(getContactData, {oppId: '$recordId'}) contact;

    get contactName() {
        return getSObjectValue(this.contact.data, CONTACT_NAME)
    }

    get contactEmail() {
        return getSObjectValue(this.contact.data, CONTACT_EMAIL)
    }

    previewHandler() {
        let id = this.recordId;
        this[NavigationMixin.GenerateUrl]({
            type: 'standard__webPage',
            attributes: {
                url: '/apex/InvoicePdf?id='+id,
            }
        }).then(generatedUrl => {
            window.open(generatedUrl);
        });
    }
}

