import {
    LightningElement,
    api,
    wire,
    track
} from 'lwc';
import {
    NavigationMixin
} from 'lightning/navigation';

import {
    ShowToastEvent
} from 'lightning/platformShowToastEvent';
import {
    CloseActionScreenEvent
} from 'lightning/actions';

import sendEmailToController from '@salesforce/apex/EmailLwcController.sendEmailToController';
import getTemplateData from '@salesforce/apex/EmailLwcController.getTemplateData';
import getContactData from '@salesforce/apex/EmailLwcController.getContactData';
import getAttachment from '@salesforce/apex/EmailLwcController.getAttachment';

import {
    getRecord,
    getFieldValue
} from 'lightning/uiRecordApi';
import {
    getSObjectValue
} from '@salesforce/apex';

import INVOICE_NUMBER from '@salesforce/schema/Opportunity.Invoice_Number__c';
import TEMPLATE_SUBJECT from '@salesforce/schema/EmailTemplate.Subject';
import TEMPLATE_BODY from '@salesforce/schema/EmailTemplate.Body';
import CONTACT_NAME from '@salesforce/schema/Contact.Name';
import CONTACT_EMAIL from '@salesforce/schema/Contact.Email';
import ATTACHMENT_NAME from '@salesforce/schema/Attachment.Name';

const fields = [INVOICE_NUMBER];


export default class LwcExample extends NavigationMixin(LightningElement) {

    @api recordId;

    @wire(getRecord, {
        recordId: '$recordId',
        fields
    }) currentOpp;

    get invoiceNumber() {
        return getFieldValue(this.currentOpp.data, INVOICE_NUMBER);
    }

    body = "";

    sendEmailAfterEvent() {
        const recordInput = {
            body: this.body == "" ? this.templateBody : this.body,
            toSend: this.contactEmail,
            subject: this.templateSubject + this.invoiceNumber,
            fileName: this.invoiceNumber,
            oppId: this.recordId
        };
        sendEmailToController(recordInput)
            .then(() => {
                const event = new ShowToastEvent({
                    title: 'Success',
                    message: 'Invoice ' + this.invoiceNumber + ' successfully sent to ' + this.contactEmail,
                    variant: 'success',
                    mode: 'dismissable',
                });
                this.dispatchEvent(event);
                this.dispatchEvent(new CloseActionScreenEvent());

            }).catch(() => {
                const event = new ShowToastEvent({
                    title: 'Error occurred',
                    message: 'Invoice not sent, check contact role on existence',
                    variant: 'error',
                    mode: 'dismissable',
                });
                this.dispatchEvent(event);
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

    @wire(getContactData, {
        oppId: '$recordId'
    }) contact;

    get contactName() {
        return getSObjectValue(this.contact.data, CONTACT_NAME)
    }

    get contactEmail() {
        return getSObjectValue(this.contact.data, CONTACT_EMAIL)
    }

    @wire(getAttachment, {
        oppId: '$recordId'
    }) attachment;

    get attachmentName() {
        return getSObjectValue(this.attachment.data, ATTACHMENT_NAME)
    }

    previewHandler() {
        let id = this.recordId;
        this[NavigationMixin.GenerateUrl]({
            type: 'standard__webPage',
            attributes: {
                url: '/apex/InvoicePdf?id=' + id,
            }
        }).then(generatedUrl => {
            window.open(generatedUrl);
        });
    }
}